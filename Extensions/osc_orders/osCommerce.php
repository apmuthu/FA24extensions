<?php
/**********************************************
Author: Tom Moulton
Name: osCommerce order import to Sales Order
Free software under GNU GPL
***********************************************/
$page_security = 'SA_OSCORDERS';
$path_to_root  = "../..";

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/db/branches_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_order_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/inventory/includes/db/items_prices_db.inc");

/*
SELECT c.customers_id, CONCAT(c.customers_firstname, ' ', c.customers_lastname) , b.entry_street_address, b.entry_suburb, b.entry_city, b.entry_zone_id, b.entry_state, b.entry_postcode, b.entry_country_id, c.customers_telephone, c.customers_email_address FROM customers c left join `customers_info` i on c.customers_id = i.customers_info_id left join address_book b on c.customers_default_address_id = b.address_book_id

SELECT `customers_id` FROM `customers` order by `customers_id` desc LIMIT 0,1
SELECT `customers_id` FROM `customers` order by `customers_id` asc LIMIT 0,1

SELECT products_model, products_price FROM products WHERE products_status = 1
*/

function osc_connect() {
    global $db, $one_database, $dbHost, $dbUser, $dbPassword, $dbName;
    
    $osc = false;
    if ($one_database) $osc = $db;
    else $osc = mysqli_connect($dbHost, $dbUser, $dbPassword, $dbName);

    if (!$osc) display_notification("Failed to connect osCommerce Database");

    return $osc;
}

function osc_dbQuery($sql, $multirow = false) {
    global $osc;

    $result = mysqli_query($osc, $sql);
    if ($multirow)
        return $result;
    $data = mysqli_fetch_assoc($result);
    mysqli_free_result($result);
    return $data;
}

function osc_escape($value = "", $nullify = false) {
    global $osc;
    
    $value = @html_entity_decode($value, ENT_QUOTES, $_SESSION['language']->encoding);
    $value = html_specials_encode($value);

      //reset default if second parameter is skipped
    $nullify = ($nullify === null) ? (false) : ($nullify);

      //check for null/unset/empty strings
    if ((!isset($value)) || (is_null($value)) || ($value === "")) {
        $value = ($nullify) ? ("NULL") : ("''");
    } else {
        if (is_string($value)) {
            $value = "'" . mysqli_real_escape_string($osc, $value) . "'";
              //value is a string and should be quoted; 
        } else if (!is_numeric($value)) {
            //value is not a string nor numeric
            display_error("ERROR: incorrect data type send to sql query");
            echo '<br><br>';
            exit();
        }
    }
    return $value;
}

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function osc_get_zone_code($zone_name) {
    $sql  = "SELECT zone_code from zones where zone_name=".osc_escape($zone_name);
    $zone = osc_dbQuery($sql);
    $id   = $zone['zone_code'];
    if (!not_null($id)) $id = $zone_name;
    return $id;
}

function osc_get_zone_code_from_id($zone_id) {
    $sql  = "SELECT zone_code from zones where zone_id=".osc_escape($zone_id);
    $zone = osc_dbQuery($sql);
    $id   = $zone['zone_code'];
    return $id;
}

function osc_get_zone_name_from_id($zone_id) {
    $sql  = "SELECT zone_name from zones where zone_id=".osc_escape($zone_id);
    $zone = osc_dbQuery($sql);
    $id   = $zone['zone_name'];
    return $id;
}

function osc_get_country($country_id) {
    $sql     = "SELECT countries_name from countries where countries_id=".osc_escape($country_id);
    $country = osc_dbQuery($sql);
    $id      = $country['countries_name'];
    return $id;
}

function osc_address_format($data, $pre) {
    $company = $data[$pre . 'company'];
    if (!empty($data[$pre . 'name'])) $name = $data[$pre . 'name'];
    else $name = $data[$pre . 'firstname'] . ' ' . $data[$pre . 'lastname'];
    $street_address = $data[$pre . 'street_address'];
    $suburb         = $data[$pre . 'suburb'];
    $city           = $data[$pre . 'city'];
    $postcode       = $data[$pre . 'postcode'];
    // $state = $data[$pre . 'state'];
    if (not_null($data[$pre . 'state'])) $state = $data[$pre . 'state'];
    else if (not_null($data[$pre . 'zone_id'])) $state = osc_get_zone_code_from_id( $data[$pre . 'zone_id']);
    if (!empty($data[$pre . 'country_id'])) $country = osc_get_country($data[$pre . 'country_id']);
    else $country = $data[$pre . 'country'];

    $ret = '';
    if (not_null($company)) $ret .= $company . "\n";
    $ret .= $name . "\n" . $street_address . "\n";
    if (not_null($suburb))   $ret .= $suburb . "\n";
    if (not_null($city))     $ret .= $city;
    if (not_null($state))    $ret .= ", " . osc_get_zone_code($state);
    if (not_null($postcode)) $ret .= " " . $postcode . "\n";
    else $ret .=  "\n";
    if (not_null($country))  $ret .= $country . "\n";
    return $ret;
}

function get_tax_group_from_zone_id($zone_id, $def_tax_group_id) {
    $tax_group = osc_get_zone_name_from_id($zone_id);
    $taxgid    = "";
    if ($tax_group != "") {
        $sql    = "SELECT id from ".TB_PREF."tax_groups WHERE name=".db_escape($tax_group);
        $result = db_query($sql, "Non Taxable Group");
        $row    = db_fetch_row($result);
        if ($row) $taxgid = $row[0];
    }
    if ($taxgid == "") $taxgid = $def_tax_group_id;
    return $taxgid;
}

function check_stock_id($stock_id) {
    $sql    = "SELECT * FROM ".TB_PREF."stock_master where stock_id = " . db_escape($stock_id);
    $result = db_query($sql, "Can not look up stock_id");
    $row    = db_fetch_row($result);
    if (!$row[0]) return 0;
    return 1;
}

function get_item_category_by_name($name) {
    $sql    = "SELECT * FROM ".TB_PREF."stock_category WHERE description=".db_escape($name);
    $result = db_query($sql, "an item category could not be retrieved");
    return db_fetch($result);
}

// error_reporting(E_ALL);
// ini_set("display_errors", "on");

global $db; // Allow access to the FA database connection
$debug_sql = 0;

global $db_connections;
$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

check_db_has_sales_areas("You must first define atleast one Sales Area");

$sql          = "SHOW TABLES";
$result       = db_query($sql, "could not show tables");
$found        = 0;
$one_database = 0; // Use one DB, auto-detect below
while (($row = db_fetch_row($result))) {
    if ($row[0] == $cur_prefix."oscommerce") $found = 1;
    if (stripos($row[0], 'orders_status_history') !== false) $one_database = 1;
}

$dbHost           = "";
$dbUser           = "";
$dbPassword       = "";
$dbName           = "";
$oscId            = "products_model";
$oscPrefix        = "";
$lastcid          = 0;
$lastoid          = 0;
$defaultTaxGroup  = 0;

$db_Host          = "";
$db_User          = "";
$db_Password      = "";
$db_Name          = "";
$osc_Id           = "products_model";
$osc_Prefix       = "";
$last_cid         = 0;
$last_oid         = 0;
$default_TaxGroup = 0;

$min_cid = 0;
$max_cid = 0;
$min_oid = 0;
$max_oid = 0;
$min_iid = 0;
$max_iid = 0;

if ($found) {
    // Get Host Name
    $sql     = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myhost'";
    $result  = db_query($sql, "could not get host name");
    $row     = db_fetch_row($result);
    $db_Host = $row[1];

    // Get User Name
    $sql     = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myuser'";
    $result  = db_query($sql, "could not get user name");
    $row     = db_fetch_row($result);
    $db_User = $row[1];

    // Get Password
    $sql         = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'mypassword'";
    $result      = db_query($sql, "could not get password");
    $row         = db_fetch_row($result);
    $db_Password = $row[1];

    // Get DB Name
    $sql     = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'myname'";
    $result  = db_query($sql, "could not get DB name");
    $row     = db_fetch_row($result);
    $db_Name = $row[1];

    // Get item prefix
    $sql        = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'osc_prefix'";
    $result     = db_query($sql, "could not get osc_prefix");
    $row        = db_fetch_row($result);
    $osc_Prefix = $row[1];

    // Get item prefix
    $sql    = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'osc_id'";
    $result = db_query($sql, "could not get osc_id");
    $row    = db_fetch_row($result);
    $osc_Id = $row[1];

    // Get last cID imported
    $sql    = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'lastcid'";
    $result = db_query($sql, "could not get DB name");
    $row    = db_fetch_row($result);
    if (!$row) {
        $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastcid', 0)";
        db_query($sql, "add lastcid");
        $last_cid = 0;
    } else $last_cid = $row[1];

    // Get last oID imported
    $sql = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'lastoid'";
    $result = db_query($sql, "could not get DB name");
    $row    = db_fetch_row($result);
    if (!$row) {
        $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastoid', 0)";
        db_query($sql, "add lastoid");
        $last_oid = 0;
    } else $last_oid = $row[1];

    // Get Default Tax Group
    $sql              = "SELECT * FROM ".TB_PREF."oscommerce WHERE name = 'taxgroup'";
    $result           = db_query($sql, "could not get taxgroup");
    $row              = db_fetch_row($result);
    $default_TaxGroup = $row[1];
}

$num_price_errors = -1;

$action = 'summary';
if (isset($_GET['action']) && $found) $action = $_GET['action'];
if (!$found) $action = 'show';

if ($action == 'c_import') {
    if (!check_num('credit_limit', 0)) {
        display_error(_("The credit limit must be numeric and not less than zero."));
        $action = 'cimport';
    }
}

if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
        $sql = "DROP TABLE IF EXISTS ".TB_PREF."oscommerce";
        db_query($sql, "Error dropping table");
        $sql = "CREATE TABLE ".TB_PREF."oscommerce ( `name` char(15) NOT NULL default '', " .
               " `value` varchar(100) NOT NULL default '', PRIMARY KEY  (`name`)) ENGINE=MyISAM";
        db_query($sql, "Error creating table");
        header("Location: osCommerce.php?action=show");
    }

    if ($action == 'update') {
        if (isset($_POST['dbHost']))     $dbHost          = $_POST['dbHost'];
        if (isset($_POST['dbUser']))     $dbUser          = $_POST['dbUser'];
        if (isset($_POST['dbPassword'])) $dbPassword      = $_POST['dbPassword'];
        if (isset($_POST['dbName']))     $dbName          = $_POST['dbName'];
        if (isset($_POST['oscId']))      $oscId           = $_POST['oscId'];
        if (isset($_POST['oscPrefix']))  $oscPrefix       = $_POST['oscPrefix'];
        if (isset($_POST['lastcid']))    $lastcid         = $_POST['lastcid'];
        if (isset($_POST['lastoid']))    $lastoid         = $_POST['lastoid'];
        if (isset($_POST['taxgroup']))   $defaultTaxGroup = $_POST['taxgroup'];

        if ($dbHost != $db_Host) { // It changed
            if ($dbHost == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myhost'";
            else if ($db_Host == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myhost', ".db_escape($dbHost).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($dbHost)." WHERE name = 'myhost'";
            db_query($sql, "Update 'myhost'");
        }

        if ($dbUser != $db_User) { // It changed
            if ($dbUser == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myuser'";
            else if ($db_User == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myuser', ".db_escape($dbUser).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($dbUser)." WHERE name = 'myuser'";
            db_query($sql, "Update 'myuser'");
        }

        if ($dbPassword != $db_Password) { // It changed
            if ($dbPassword == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'mypassword'";
            else if ($db_Password == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('mypassword', ".db_escape($dbPassword).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($dbPassword)." WHERE name = 'mypassword'";
            db_query($sql, "Update 'mypassword'");
        }

        if ($dbName != $db_Name) { // It changed
            if ($dbName == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'myname'";
            else if ($db_Name == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('myname', ".db_escape($dbName).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($dbName)." WHERE name = 'myname'";
            db_query($sql, "Update 'myname'");
        }

        if ($oscId != $osc_Id) { // It changed
            if ($oscId == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'osc_id'";
            else if ($osc_Id == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('osc_id', ".db_escape($oscId).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($oscId)." WHERE name = 'osc_id'";
            db_query($sql, "Update 'osc_id'");
        }

        if ($oscPrefix != $osc_Prefix) { // It changed
            if ($oscPrefix == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'osc_prefix'";
            else if ($osc_Prefix == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('osc_prefix', ".db_escape($oscPrefix).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($oscPrefix)." WHERE name = 'osc_prefix'";
            db_query($sql, "Update 'osc_prefix'");
        }

        if ($lastcid != $last_cid) { // It changed
            if ($lastcid == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'lastcid'";
            else if ($last_cid == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastcid', ".db_escape($lastcid).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($lastcid)." WHERE name = 'lastcid'";
            db_query($sql, "Update 'lastcid'");
        }

        if ($lastoid != $last_oid) { // It changed
            if ($lastoid == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'lastoid'";
            else if ($last_oid == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('lastoid', ".db_escape($lastoid).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($lastoid)." WHERE name = 'lastoid'";
            db_query($sql, "Update 'lastoid'");
        }

        if ($defaultTaxGroup != $default_TaxGroup) { // It changed
            if ($defaultTaxGroup == '') $sql = "DELETE FROM ".TB_PREF."oscommerce WHERE name = 'taxgroup'";
            else if ($default_TaxGroup == '') $sql = "INSERT INTO ".TB_PREF."oscommerce (name, value) VALUES ('taxgroup', ".db_escape($defaultTaxGroup).")";
            else $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($defaultTaxGroup)." WHERE name = 'taxgroup'";
            db_query($sql, "Update 'defaultTaxGroup'");
            header("Location: osCommerce.php?action=summary");
        }
    } else {
        $dbHost          = $db_Host;
        $dbUser          = $db_User;
        $dbPassword      = $db_Password;
        $dbName          = $db_Name;
        $oscId           = $osc_Id;
        $oscPrefix       = $osc_Prefix;
        $lastcid         = $last_cid;
        $lastoid         = $last_oid;
        $defaultTaxGroup = $default_TaxGroup;
    }

    if ( in_array($action, array('c_import', 'o_import', 'p_check', 'p_update', 'i_import')) && ($osc = osc_connect()) ) {

        if ($action == 'c_import') {
            if (!check_num('credit_limit', 0)) {
                display_error(_("The credit limit must be numeric and not less than zero."));
            }
        
            $min_cid = 0;
            $max_cid = 0;
            if (isset($_POST['min_cid'])) $min_cid = $_POST['min_cid'];
            if (isset($_POST['max_cid'])) $max_cid = $_POST['max_cid'];

            $sql = "SELECT * FROM customers c LEFT JOIN address_book b on c.customers_default_address_id = b.address_book_id where c.customers_id  >= ".osc_escape($min_cid)." AND c.customers_id <= ".osc_escape($max_cid);
            $customers = osc_dbQuery($sql, true);
            display_notification("Found " . db_num_rows($customers) . " new customers");
            $i = $j = 0;
            while ($cust = mysqli_fetch_assoc($customers)) {
                $email     = $cust['customers_email_address'];
                $name      = $cust['customers_firstname'] . ' ' . $cust['customers_lastname'];
                $contact   = $cust['entry_firstname'] . ' ' . $cust['entry_lastname'];
                $addr      = osc_address_format($cust, 'entry_');
                $tax_id    = '';
                $phone     = $cust['customers_telephone'];
                $fax       = $cust['customers_fax'];
                $area_code = $_POST['area'];
                $currency  = $_POST['currency'];

                // id; name; address1; address2; address3; address4; area; phone; fax; email; contact; tax_id; currency; tax_group

                $taxgid = get_tax_group_from_zone_id($cust['entry_zone_id'], $_POST['tax_group_id']);

                $sql    = "SELECT debtor_no,name FROM ".TB_PREF."debtors_master WHERE name=".db_escape($name);
                $result = db_query($sql, "customer could not be retrieved");
                $row    = db_fetch_assoc($result);

                if (!$row) {
                    add_customer($name, $name, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    $id = db_insert_id();
                    if ($debug_sql) display_notification("INSERT DM " . $sql);
                    db_query($sql, "The customer could not be added");
                    add_branch($id, $name, $name, $addr, $_POST['salesman'], $area_code, $taxgid, $_POST['sales_account'], $_POST['sales_discount_account'], $_POST['receivables_account'], $_POST['payment_discount_account'], $_POST['default_location'], $addr, 0, 0, 1, NULL);
                    if ($debug_sql) display_notification("INSERT BR " . $sql);
                    display_notification("Added New Customer $name");

                    $i++;
                } else {
                    update_customer($row['debtor_no'], $name, $name, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    if ($debug_sql) display_notification("UPDATE DM " . $sql);
                    display_notification("Updated Customer $name");
                    $j++;
                }
                if ((int) $cust['customers_id'] > $lastcid) {
                    $sql = "UPDATE ".TB_PREF."oscommerce SET value = ".db_escape($cust['customers_id'])." WHERE `name` = 'lastcid'";
                    db_query($sql, "Update 'lastcid'");
                }
            }
            mysqli_free_result($customers);
            display_notification("$i customer posts created, $j customer posts updated.");
        }

        if ($action == 'o_import') { // Import Order specified by oID
            $first_oid = (int) $_POST['first_oid'];
            $last_oid  = (int) $_POST['last_oid'];
            if (!not_null($first_oid) || !not_null($last_oid)) {
                $first_oid = 0;
                $last_oid  = 0;
            }

            $sql        = "SELECT * FROM orders where orders_id >= ".osc_escape($first_oid)." AND orders_id <= ".osc_escape($last_oid);
            $oid_result = osc_dbQuery($sql, true);
            display_notification("Found " . mysqli_num_rows($oid_result) . " New Orders");
            while ($order = mysqli_fetch_assoc($oid_result)) {
                $oID         = $order['orders_id'];
                $sql         = "SELECT * FROM orders_total WHERE orders_id = ".osc_escape($oID)." AND class = 'ot_shipping'";
                $order_total = osc_dbQuery($sql);
                $sql      = "SELECT comments FROM orders_status_history WHERE orders_id = ".osc_escape($oID);
                $result   = osc_dbQuery($sql, true);
                $comments = "";
                while ($row = mysqli_fetch_assoc($result)) {
                    if (not_null($row['comments'])) $comments .= $row['comments'] . "\n";
                }
                mysqli_free_result($result);
                $sql    = "SELECT * FROM ".TB_PREF."debtors_master WHERE `name` = ".db_escape($order['customers_name']);
                $result = db_query($sql, "Could not find customer by name");
                // echo "Found " . db_num_rows($result);
                if (db_num_rows($result) == 0) {
                    display_notification("Customer " . $order['customers_name'] . " not found");
                    break;
                }
                $customer = db_fetch_assoc($result);
                $addr     = osc_address_format($order, 'delivery_');
                $taxgid   = get_tax_group_from_zone_id($order['delivery_state'], $defaultTaxGroup);
                $sql      = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no = ".db_escape($customer['debtor_no'])." AND br_address = ".db_escape($addr);
                if ($debug_sql) display_notification("Find BR " . $sql);
                $result = db_query($sql, "could not find customer branch");
                if (db_num_rows($result) == 0) {
                    if ($debug_sql) display_notification("New Branch");
                    $debtor_no = $customer['debtor_no'];
                    $sql       = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no = ".db_escape($debtor_no);
                    if ($debug_sql) display_notification("Find BR * " . $sql);
                    $result     = db_query($sql, "could not find any customer branch");
                    $old_branch = db_fetch_assoc($result);
                    if ($debug_sql) print_r($old_branch);
                    add_branch($debtor_no, $old_branch['br_name'], $old_branch['branch_ref'], $addr, $old_branch['salesman'], $old_branch['area'], $taxgid, $old_branch['sales_account'], $old_branch['sales_discount_account'], $old_branch['receivables_account'], $old_branch['payment_discount_account'], $old_branch['default_location'], $addr, 0, 0, 1, $old_branch['notes']);
                    $id  = db_insert_id();
                    $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE branch_code = ".db_escape($id);
                    if ($debug_sql) display_notification("Get BR " . $sql);
                    $result = db_query($sql, "Could not load new branch");
                }
                $branch                  = db_fetch_assoc($result);
                // print_r($branch);
                // Now Add Sales_Order and Sales_Order_Details
                $cart                    = new Cart(30); // New Sales Order
                $cart->customer_id       = $customer['debtor_no'];
                $cart->customer_currency = $customer['curr_code'];
                $cart->Branch            = $branch['branch_code'];
                $cart->cust_ref          = "osC Order # $oID";
                $cart->Comments          = $comments;
                $cart->document_date     = Today();
                // $_POST['OrderDate'] = $cart->document_date;
                $cart->sales_type        = $customer['sales_type'];
                $cart->ship_via          = $branch['default_ship_via'];
                $cart->deliver_to        = $branch['br_name'];
                $cart->delivery_address  = $branch['br_address'];
                $cart->phone             = $branch['phone'];
                $cart->email             = $branch['email'];
                $cart->freight_cost      = $order_total['value'];
                $cart->Location          = $branch['default_location'];
                $cart->due_date          = Today();
                $sql                     = "SELECT * FROM orders_products WHERE orders_id = ".osc_escape($oID);
                $result                  = osc_dbQuery($sql, true);
                $lines                   = array();
                while ($prod = mysqli_fetch_assoc($result)) {
                    add_to_order($cart, $osc_Prefix . $prod[$osc_Id], $prod['products_quantity'], $prod['products_price'], $customer['pymt_discount']);
                }
                mysqli_free_result($result);
                $order_no = $cart->write(0);
                display_notification("Added Order Number $order_no for " . $order['customers_name']);

                if ($oID > $lastoid) {
                    $sql = "UPDATE  ".TB_PREF."oscommerce SET value = ".db_escape($oID)." WHERE name = 'lastoid'";
                    db_query($sql, "Update 'lastoid'");
                }

            }
            mysqli_free_result($oid_result);
            $action = 'oimport';
        }

        if ($action == 'p_check') { // Price Check

            $sql = "SELECT " . $osc_Id . ", products_price FROM products WHERE products_status = 1";
            // echo $sql;
            $p_result         = osc_dbQuery($sql, true);
            $currency         = $_POST['currency'];
            $sales_type       = $_POST['sales_type'];
            $num_price_errors = 0;
            while ($pp = mysqli_fetch_assoc($p_result)) {
                $price   = $pp['products_price'];
                $osc_id = $osc_Prefix . $pp[$osc_Id];
                $myprice = false;
                $myprice = get_kit_price($osc_id, $currency, $sales_type);
                if ($myprice === false) display_notification("$osc_id price not found in FA");
                else if ($price != $myprice) {
                    display_notification("$osc_id Prices do not match FA $myprice osC $price");
                    $num_price_errors++;
                }
            }
            mysqli_free_result($p_result);
            $action = 'pcheck';
        }

        if ($action == 'p_update') { // Price Update
            $sql              = "SELECT " . $osc_Id . ", products_price FROM products WHERE products_status = 1";
            $p_result         = osc_dbQuery($sql, true);
            $currency         = $_POST['currency'];
            $sales_type       = $_POST['sales_type'];
            $num_price_errors = 0;
            while ($pp = mysqli_fetch_assoc($p_result)) {
                $price   = $pp['products_price'];
                $osc_id = $osc_Prefix . $pp[$osc_Id];
                $myprice = false;
                $myprice = get_kit_price($osc_id, $currency, $sales_type);
                if ($myprice === false) display_notification("$osc_id price not found in FA");
                else if ($price != $myprice) {
                    display_notification("Updating $osc_id from $price to $myprice");
                    $sql = "UPDATE products SET products_price = ".osc_escape($myprice)." WHERE $osc_Id = ".osc_escape($osc_id);
                    osc_dbQuery($sql);
                    $num_price_errors++;
                }
            }
            mysqli_free_result($p_result);
            $action = 'pupdate';
        }

        if ($action == 'i_import') { // Item Import
            $sql = "SELECT p." . $osc_Id . ", pd.products_name, cd.categories_name, p.products_price FROM products p left join products_description pd on p.products_id=pd.products_id left join products_to_categories pc on p.products_id=pc.products_id left join categories_description cd on pc.categories_id=cd.categories_id";

            $p_result = osc_dbQuery($sql, true);
            while ($pp = mysqli_fetch_assoc($p_result)) {
                $products_name = utf8_decode($pp['products_name']);
                $osc_id = $osc_Prefix . $pp[$osc_Id];

                $row = get_item_category_by_name($pp['categories_name']);
                if (!$row) {
                    add_item_category($pp['categories_name'], 
                    $_POST['tax_type_id'],
                    $_POST['sales_account'],
                    $_POST['cogs_account'],
                    $_POST['inventory_account'],
                    $_POST['adjustment_account'],
                    $_POST['wip_account'],
                    $_POST['units'],
                    "B",
                    "",
                    0,
                    0,
                    0
                    );
                    $cat = db_insert_id();
                    display_notification("Add Category " . $pp['categories_name']);
                } else
                    $cat = $row['category_id'];

                $sql    = "SELECT stock_id FROM ".TB_PREF."stock_master WHERE stock_id=".db_escape($osc_id);
                $result = db_query($sql,"item could not be retreived");
                $row    = db_fetch_row($result);
                if (!$row) {
                    $sql = "INSERT INTO ".TB_PREF."stock_master (stock_id, description, long_description, category_id,
                            tax_type_id, units, mb_flag, sales_account, inventory_account, cogs_account,
                            adjustment_account, wip_account, dimension_id, dimension2_id)
                            VALUES ('$osc_id', " . db_escape($products_name) . ", '',
                            '$cat', {$_POST['tax_type_id']}, '{$_POST['units']}', 'B',
                            '{$_POST['sales_account']}', '{$_POST['inventory_account']}', '{$_POST['cogs_account']}',
                            '{$_POST['adjustment_account']}', '{$_POST['wip_account']}', '{$_POST['dimension_id']}', '{$_POST['dimension2_id']}')";

                    db_query($sql, "The item could not be added");
                    $sql = "INSERT INTO ".TB_PREF."loc_stock (loc_code, stock_id) VALUES ('{$_POST['default_location']}', ".db_escape($osc_id).")";

                    db_query($sql, "The item locstock could not be added");
                    display_notification("Insert $osc_id " . $products_name);
                }
                $sql    = "SELECT id from ".TB_PREF."item_codes WHERE item_code=".db_escape($osc_id)." AND stock_id = ".db_escape($osc_id);
                $result = db_query($sql, "item code could not be retreived");
                $row    = db_fetch_row($result);
                if (!$row) add_item_code($osc_id, $osc_id, $products_name, $cat, 1);
                else update_item_code($row[0], $osc_id, $osc_id, $products_name, $cat, 1);
            }
            mysqli_free_result($p_result);
            $action = 'iimport';
        }
        if ($osc && !$one_database) mysqli_close($osc);
   }

} else {
    $dbHost          = $db_Host;
    $dbUser          = $db_User;
    $dbPassword      = $db_Password;
    $dbName          = $db_Name;
    $oscId           = $osc_Id;
    $oscPrefix       = $osc_Prefix;
    $lastcid         = $last_cid;
    $lastoid         = $last_oid;
    $defaultTaxGroup = $default_TaxGroup;

    if ( in_array($action, array('summary', 'cimport', 'oimport', 'iimport')) && ($osc = osc_connect()) ) {

        if ($action == 'cimport' || $action == 'summary') { // Preview Customer Import page

            $sql     = "SELECT `customers_id` FROM `customers` order by `customers_id` asc LIMIT 0,1";
            $cid     = osc_dbQuery($sql);
            $min_cid = (int) $cid['customers_id'];
            if ($min_cid <= $last_cid) $min_cid = $last_cid + 1;
            $sql     = "SELECT `customers_id` FROM `customers` order by `customers_id` desc LIMIT 0,1";
            $cid     = osc_dbQuery($sql);
            $max_cid = (int) $cid['customers_id'];
        }

        if ($action == 'oimport' || $action == 'summary') { // Preview Order Import page

            $sql     = "SELECT `orders_id` FROM `orders` order by `orders_id` asc LIMIT 0,1";
            $oid     = osc_dbQuery($sql);
            $min_oid = (int) $oid['orders_id'];
            if ($min_oid <= $last_oid) $min_oid = $last_oid + 1;
            $sql     = "SELECT `orders_id` FROM `orders` order by `orders_id` desc LIMIT 0,1";
            $oid     = osc_dbQuery($sql);
            $max_oid = (int) $oid['orders_id'];
        }

        if ($action == 'iimport' || $action == 'summary') { // Preview Item Import page

            // TBD
        }
        if ($osc && !$one_database) mysqli_close($osc);
    }
}

page("osCommerce Interface");
if ($action == 'summary') echo 'Summary';
else hyperlink_params($_SERVER['PHP_SELF'], _("Summary"), "action=summary", false);
echo '&nbsp;|&nbsp;';
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'cimport') echo 'Customer Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Customer Import"), "action=cimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pcheck') echo 'Price Check';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Price Check"), "action=pcheck", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pupdate') echo 'Update Prices';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Update Prices"), "action=pupdate", false);
echo '&nbsp;|&nbsp;';
if ($action == 'iimport') echo 'Item Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Item Import"), "action=iimport", false);
echo "<br><br>";

include($path_to_root . "/includes/ui.inc");

if ($action == 'summary') {
    start_form(true);
    start_table(TABLESTYLE);

    $th = array("Type", "# of Updates Needed");
    table_header($th);

    $k = 0;

    //alt_table_row_color($k);

    label_cell("New Customers");
    if ($min_cid > $max_cid) {
        label_cell("None");
    } else {
        label_cell($max_cid - $min_cid + 1);
    }
    end_row();
    label_cell("New Orders");
    if ($min_oid > $max_oid) {
        label_cell("None");
    } else {
        label_cell($max_oid - $min_oid + 1);
    }
    end_row();
    end_form();

    end_page();
}

if ($action == 'show') {
    start_form(true);
    start_table(TABLESTYLE);

    $th = array("Function", "Description");
    table_header($th);

    $k = 0;

    alt_table_row_color($k);

    label_cell("Table Status");
    if ($found) $table_st = "Found";
    else $table_st = "<font color=red>Not Found</font>";
    label_cell($table_st);
    end_row();

    if ($found) {
        text_row("Mysql Host", 'dbHost', $dbHost, 20, 40);
        
        text_row("User", 'dbUser', $dbUser, 20, 40);
        
        text_row("Password", 'dbPassword', $dbPassword, 20, 40);
        
        text_row("DB Name", 'dbName', $dbName, 20, 40);
        text_row("Osc Id", 'oscId', $oscId, 20, 40);
        text_row("Osc_Item Prefix", 'oscPrefix', $oscPrefix, 20, 40);
        tax_groups_list_row(_("Default Tax Group:"), 'taxgroup', $default_TaxGroup);
    }

    end_table(1);

    if (!$found) {
        hidden('action', 'create');
        submit_center('create', 'Create Table');
    } else {
        hidden('action', 'update');
        submit_center('update', 'Update Mysql');
    }

    end_form();

    end_page();
}

if ($action == 'cimport') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Default GL Accounts");

    $company_record = get_company_prefs();

    if (!isset($_POST['sales_account']) || $_POST['sales_account'] == "")
        $_POST['sales_account'] = $company_record["default_sales_act"];

    if (!isset($_POST['sales_discount_account']) || $_POST['sales_discount_account'] == "")
        $_POST['sales_discount_account'] = $company_record["default_sales_discount_act"];

    if (!isset($_POST['receivables_account']) || $_POST['receivables_account'] == "")
        $_POST['receivables_account'] = $company_record["debtors_act"];

    if (!isset($_POST['payment_discount_account']) || $_POST['payment_discount_account'] == "")
        $_POST['payment_discount_account'] = $company_record["default_prompt_payment_act"];

    gl_all_accounts_list_row("Sales Account:", 'sales_account', $_POST['sales_account']);
    gl_all_accounts_list_row("Sales Discount Account:", 'sales_discount_account', $_POST['sales_discount_account']);
    gl_all_accounts_list_row("Receivables Account:", 'receivables_account', $_POST['receivables_account']);
    gl_all_accounts_list_row("Payment Discount Account:", 'payment_discount_account', $_POST['payment_discount_account']);

    $dim = get_company_pref('use_dimension');
    if ($dim < 1)
        hidden('dimension_id', 0);
    if ($dim < 2)
        hidden('dimension2_id', 0);

    global $SysPrefs;
    $credit_limit = price_format($SysPrefs->default_credit_limit());

    table_section_title("Location, Tax Type, Sales Type, Sales Person and Payment Terms");
    locations_list_row("Location:", 'default_location', null);
    tax_groups_list_row(_("Default Tax Group:"), 'tax_group_id', $default_TaxGroup);
    sales_types_list_row("Sales Type:", 'sales_type', null);
    sales_persons_list_row("Sales Person:", 'salesman', null);
    sales_areas_list_row("Sales Area:", 'area');
    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    payment_terms_list_row("Payment Terms:", 'payment_terms', null);
    amount_row(_("Credit Limit:"), 'credit_limit', $credit_limit);

    if ($dim >= 1)
        dimensions_list_row(_("Dimension")." 1:", 'dimension_id', NULL, true, " ", false, 1);
    if ($dim > 1)
        dimensions_list_row(_("Dimension")." 2:", 'dimension2_id', NULL, true, " ", false, 2);

    text_row("Starting osC Customer ID:", 'min_cid', $min_cid, 6, 6);
    text_row("Ending osC Customer ID:", 'max_cid', $max_cid, 6, 6);

    end_table(1);

    hidden('action', 'c_import');
    submit_center('cimport', "Import osC Customers");

    end_form();
    end_page();
}

if ($action == 'oimport') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Order Import Options");

    text_row("Starting Order Number:", 'first_oid', $min_oid, 8, 8);
    text_row("Last Order Number:", 'last_oid', $max_oid, 8, 8);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', "Import osC Orders");

    end_form();
    end_page();
}

if ($action == 'pcheck') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Price Check Options");

    $company_record = get_company_prefs();

    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    sales_types_list_row("Sales Type:", 'sales_type', null);

    end_table(1);

    hidden('action', 'p_check');
    submit_center('pcheck', "Check osC Prices");
    if ($num_price_errors == 0) display_notification("No Pricing Errors Found");

    end_form();

    hyperlink_params($_SERVER['PHP_SELF'], _("Refresh"), "action=pcheck");
    end_page();
}

if ($action == 'pupdate') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Update Price Options");

    $company_record = get_company_prefs();

    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    sales_types_list_row("Sales Type:", 'sales_type', null);

    end_table(1);

    hidden('action', 'p_update');
    submit_center('pupdate', "Update osC Prices");
    if ($num_price_errors > 0) display_notification("There were $num_price_errors prices updated");

    end_form();
    end_page();
}

if ($action == 'iimport') {

    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Import Items");
    $company_record = get_company_prefs();

    locations_list_row("Location:", 'default_location', null);

    $dim = get_company_pref('use_dimension');
    if ($dim < 1)
        hidden('dimension_id', 0);
    if ($dim < 2)
        hidden('dimension2_id', 0);

    if ($dim >= 1)
        dimensions_list_row(_("Dimension")." 1:", 'dimension_id', null, true, " ", false, 1);
    if ($dim > 1)
        dimensions_list_row(_("Dimension")." 2:", 'dimension2_id', null, true, " ", false, 2);

    if (!isset($_POST['inventory_account']) || $_POST['inventory_account'] == "")
        $_POST['inventory_account'] = $company_record["default_inventory_act"];

    if (!isset($_POST['cogs_account']) || $_POST['cogs_account'] == "")
        $_POST['cogs_account'] = $company_record["default_cogs_act"];

    if (!isset($_POST['sales_account']) || $_POST['sales_account'] == "")
        $_POST['sales_account'] = $company_record["default_inv_sales_act"];

    if (!isset($_POST['adjustment_account']) || $_POST['adjustment_account'] == "")
        $_POST['adjustment_account'] = $company_record["default_adj_act"];

    if (!isset($_POST['wip_account']) || $_POST['wip_account'] == "")
        $_POST['wip_account'] = $company_record["default_wip_act"];

    if (!isset($_POST['units']) || $_POST['units'] == "")
        $_POST['units'] = null;

    gl_all_accounts_list_row("Sales Account:", 'sales_account', $_POST['sales_account']);
    gl_all_accounts_list_row("Inventory Account:", 'inventory_account', $_POST['inventory_account']);
    gl_all_accounts_list_row("C.O.G.S. Account:", 'cogs_account', $_POST['cogs_account']);
    gl_all_accounts_list_row("Inventory Adjustments Account:", 'adjustment_account', $_POST['adjustment_account']);
    gl_all_accounts_list_row("Item Assembly Costs Account:", 'wip_account', $_POST['wip_account']);
    stock_units_list_row(_('Units of Measure:'), 'units', $_POST['units'], true);
    item_tax_types_list_row("Item Tax Type:", 'tax_type_id', null);

    end_table(1);

    hidden('action', 'i_import');
    submit_center('iimport', "Import Items");
    if ($num_price_errors > 0) display_notification("There were $num_price_errors prices updated");

    end_form();
    end_page();
}
