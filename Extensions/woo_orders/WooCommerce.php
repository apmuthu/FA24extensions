<?php
/**********************************************
Author: Tom Moulton
Name: WooCommerce order import to Sales Order
Free software under GNU GPLv3
***********************************************/
$page_security = 'SA_WOOORDERS';
$path_to_root="../..";

// error_reporting(E_ALL);
// ini_set("display_errors", "on");

include($path_to_root . "/includes/session.inc");
add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/db/branches_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/db/sales_order_db.inc");
include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/inventory/includes/db/items_prices_db.inc");

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function fa_get_item_code_id($sku) {
    $sql = "SELECT id FROM ".TB_PREF."item_codes WHERE item_code = ".db_escape($sku);
    $result = db_query($sql, "could not get item id");
    $row = db_fetch_row($result);
    return is_array($row) ? $row[0] : false;
}

function woo_address_format($data) {
    $company = $data['company'];
    $name = $data['first_name'] . ' ' . $data['last_name'];
    $street_address = $data['address_1'];
    $addr2 = $data['address_2'];
    $city = $data['city'];
    $postcode = $data['postcode'];
    $state = $data['state'];
    $country = $data['country'];

    $ret = '';
    if (not_null($company)) $ret .= $company . "\n";
    $ret .= $name . "\n" . $street_address . "\n";
    if (not_null($addr2)) $ret .= $addr2 . "\n";
    if (not_null($city)) $ret .= $city;
    if (not_null($state)) $ret .= ", " . $state;
    if (not_null($postcode)) $ret .= " " . $postcode . "\n";
    else $ret .=  "\n";
    if (not_null($country)) $ret .= $country . "\n";
    return $ret;
}

function get_tax_group_from_order($woo, $order_id, $def_tax_group_id) {
    $taxgid = $def_tax_group_id;
    $sql = "SELECT `order_item_id` FROM `wp_woocommerce_order_items` WHERE `order_item_type` = 'tax' AND `order_id` = " . db_escape($order_id);
    $result = mysqli_query($woo, $sql);
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $item_id = (int)$row['order_item_id'];
        $sql = "SELECT * FROM `wp_woocommerce_order_itemmeta` WHERE `meta_key` = 'label' AND `order_item_id` = " . db_escape($item_id);
        $result = mysqli_query($woo, $sql);
        if (mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);
            $tax_name = $row['meta_value'];
            $names = explode('-', $tax_name);
            while (count($names) > 3) {
                array_pop($names);
                $taxn = implode('-', $names);
                $sql = "SELECT `id` FROM ".TB_PREF."tax_groups WHERE `name` LIKE " . db_escape($taxn);
                $result = db_query($sql, "Find Tax Group");
                if (db_num_rows($result) == 1) { // Only accept ONE result, not first
                    $row = db_fetch_assoc($result);
                    $taxgid = (int)$row['id'];
                    if ($taxgid != 0) break;
                }
            }
        }
    }
    return $taxgid;
}

global $db; // Allow access to the FA database connection
$debug_sql = 0;

global $db_connections;
$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

check_db_has_sales_areas("You must first define atleast one Sales Area");

$sql = "SHOW TABLES";
$result = db_query($sql, "could not show tables");
$found = 0;
$one_database = 0; // Use one DB, auto-detect below
while (($row = db_fetch_row($result))) {
    if ($row[0] == $cur_prefix."woocommerce") $found = 1;
	if (stripos($row[0], 'wp_wc_orders') !== false) $one_database = 1;
}

$dbHost = "";
$dbUser = "";
$dbPassword = "";
$dbName = "";
$startOrder = 0;
$defaultTaxGroup = 0;

$db_Host = "";
$db_User = "";
$db_Password = "";
$db_Name = "";
$start_Order = 0;
$default_TaxGroup = '';

if ($found) {
    // Get Host Name
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'myhost'";
    $result = db_query($sql, "could not get host name");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $db_Host = $row[1];
    }

    // Get User Name
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'myuser'";
    $result = db_query($sql, "could not get user name");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $db_User = $row[1];
    }

    // Get Password
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'mypassword'";
    $result = db_query($sql, "could not get password");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $db_Password = $row[1];
    }

    // Get DB Name
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'myname'";
    $result = db_query($sql, "could not get DB name");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $db_Name = $row[1];
    }

    // Get last oID imported
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'startorder'";
    $result = db_query($sql, "could not get DB name");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $start_Order = $row[1];
    } else {
        $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('startorder', 0)";
	db_query($sql, "add startorder");
	$last_oid = 0;
    }
    // Get Default Tax Group
    $sql = "SELECT * FROM ".TB_PREF."woocommerce WHERE name = 'taxgroup'";
    $result = db_query($sql, "could not get taxgroup");
    if (mysqli_num_rows($result) > 0) {
        $row = db_fetch_row($result);
        $default_TaxGroup = $row[1];
    }
}

$num_price_errors = -1;

$action = 'summary';
if (isset($_GET['action']) && $found) $action = $_GET['action'];
if (!$found) $action = 'show';
if ($db_Host == '') $action = 'show';

if ($action == 'o_import') {
	if (!check_num('credit_limit', 0)) {
		display_error(_("The credit limit must be numeric and not less than zero."));
		$action = 'oimport';
	} 
}
	
if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
	$sql = "DROP TABLE IF EXISTS ".TB_PREF."woocommerce";
	db_query($sql, "Error dropping table");
	$sql = "CREATE TABLE ".TB_PREF."woocommerce ( `name` char(15) NOT NULL default '', " .
  	       " `value` varchar(100) NOT NULL default '', PRIMARY KEY  (`name`))";
	db_query($sql, "Error creating table");
        header("Location: WooCommerce.php?action=show");
    }
    if ($action == 'update') {
        if (isset($_POST['dbHost'])) $dbHost = $_POST['dbHost'];
        if (isset($_POST['dbUser'])) $dbUser = $_POST['dbUser'];
        if (isset($_POST['dbPassword'])) $dbPassword = $_POST['dbPassword'];
        if (isset($_POST['dbName'])) $dbName = $_POST['dbName'];
        if (isset($_POST['startOrder'])) $startOrder = $_POST['startOrder'];
        if (isset($_POST['taxgroup'])) $defaultTaxGroup = $_POST['taxgroup'];

        if ($dbHost != $db_Host) { // It changed
            if ($dbHost == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'myhost'";
            else if ($db_Host == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('myhost', '" . $dbHost . "')";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = '" . $dbHost . "' WHERE name = 'myhost'";
	    db_query($sql, "Update 'myhost'");
	}

        if ($dbUser != $db_User) { // It changed
            if ($dbUser == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'myuser'";
            else if ($db_User == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('myuser', '" . $dbUser . "')";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = '" . $dbUser . "' WHERE name = 'myuser'";
	    db_query($sql, "Update 'myuser'");
	}

        if ($dbPassword != $db_Password) { // It changed
            if ($dbPassword == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'mypassword'";
            else if ($db_Password == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('mypassword', '" . $dbPassword . "')";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = '" . $dbPassword . "' WHERE name = 'mypassword'";
	    db_query($sql, "Update 'mypassword'");
	}

        if ($dbName != $db_Name) { // It changed
            if ($dbName == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'myname'";
            else if ($db_Name == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('myname', '" . $dbName . "')";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = '" . $dbName . "' WHERE name = 'myname'";
	    db_query($sql, "Update 'myname'");
        }

        if ($startOrder != $start_Order) { // It changed
            if ($startOrder == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'startorder'";
            else if ($start_Order == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('startorder', $lastoid)";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = $startOrder WHERE name = 'startorder'";
	    db_query($sql, "Update 'startOrder'");
	}

        if ($defaultTaxGroup != $default_TaxGroup) { // It changed
            if ($defaultTaxGroup == '') $sql = "DELETE FROM ".TB_PREF."woocommerce WHERE name = 'taxgroup'";
            else if ($default_TaxGroup == '') $sql = "INSERT INTO ".TB_PREF."woocommerce (name, value) VALUES ('taxgroup', $defaultTaxGroup)";
	    else $sql = "UPDATE  ".TB_PREF."woocommerce SET value = $defaultTaxGroup WHERE name = 'taxgroup'";
	    display_notification($sql);
	    db_query($sql, "Update 'defaultTaxGroup'");
            header("Location: WooCommerce.php?action=summary");
	}
     } else {
         $dbHost = $db_Host;
         $dbUser = $db_User;
         $dbPassword = $db_Password;
         $dbName = $db_Name;
         $startOrder = $start_Order;
     }
    if ($action == 'o_import') {
        if (!check_num('credit_limit', 0)) {
	        display_error(_("The credit limit must be numeric and not less than zero."));
        }

        if ($one_database) $woo = $db;
        else $woo = mysqli_connect($dbHost, $dbUser, $dbPassword);
        if (!$woo) display_notification("Failed to connect WooCommerce Database");
        else {
            if (!$one_database) mysqli_select_db($woo, $dbName);
            $debug_sql = false;
            $sql = "SELECT O.id, O.customer_id, O.billing_email, O.total_amount, O.date_created_gmt FROM `wp_wc_orders` AS O WHERE  O.id > $startOrder AND (O.status = 'wc-completed' OR O.status = 'wc-refunded' ) AND O.type = 'shop_order' order by `id` asc";
            if ($debug_sql) display_notification("woo " . $sql);
            $orders = mysqli_query($woo, $sql);
            display_notification("Found " . db_num_rows($orders) . " new orders");
            $new_orders = $new_cust = $update_cust = 0;
            while ($order = mysqli_fetch_assoc($orders)) {
                $order_id = (int)$order['id'];
                $sql = "SELECT * FROM ".TB_PREF."sales_orders WHERE customer_ref like 'Woo Order # $order_id'";
                $results = db_query($sql, "See if we have the order already");
                $nrows = mysqli_num_rows($results);
                if ($nrows > 0) continue;
                $sql = "SELECT * FROM `wp_wc_order_addresses` WHERE `address_type` = 'shipping' AND `order_id` = $order_id";
                if ($debug_sql) display_notification("ship " . $sql);
                $cust_adr = mysqli_query($woo, $sql);
                $addrinfo =  mysqli_fetch_assoc($cust_adr);
                $email = NULL;
                if (isset($addrinfo['email'])) $email = $addrinfo['email'];
                else {
    	            $sql = "SELECT `email` FROM `wp_wc_order_addresses` WHERE `address_type` = 'billing' AND `order_id` = $order_id";
                    if ($debug_sql) display_notification("bill " . $sql);
	                $cust_email = mysqli_query($woo, $sql);
	                $cemail =  mysqli_fetch_assoc($cust_email);
	                if (isset($cemail['email'])) $email = $cemail['email'];
	            }
	            if (!isset($email)) display_error("Order $order_id No Email address found");
                $name = $addrinfo['first_name'] . ' ' . $addrinfo['last_name'];
		        $contact = $name;
                $addr = woo_address_format($addrinfo);
                $tax_id = '';
                $phone = $addrinfo['phone'];
                $fax = '';
                $area_code = $_POST['area'];
                $currency = $_POST['currency'];
                $taxgid = get_tax_group_from_order($woo, $order_id, $_POST['tax_group_id']);

                $sql = "SELECT C.type, C.entity_id FROM `0_crm_persons` AS P LEFT JOIN `0_crm_contacts` AS C ON P.id = C.person_id WHERE P.email = ".db_escape($email);
                if ($debug_sql) display_notification("cust " . $sql);
                $results = db_query($sql,"customer could not be retreived");
                $nrows = mysqli_num_rows($results);
                if ($debug_sql) display_notification("cust nrows" . $nrows);
                $debtor_no = 0;
                begin_transaction();
                if ($nrows == 0) {
                    if ($debug_sql) display_notification("New Customer $name $addr");
                    $sql = "SELECT * FROM `0_debtors_master` WHERE `debtor_ref` LIKE ".db_escape($name."%");
                    if ($debug_sql) display_notification("num name " . $sql);
                    $results = db_query($sql,"debtor_master could not be read");
                    $nrows = mysqli_num_rows($results);
                    mysqli_free_result($results);
                    $name_ref = $name;
                    if ($nrows > 0) $name_ref = $name.'_'.($nrows+1);
                    if ($debug_sql) display_notification("Add customer $name as $name_ref");
        		    add_customer($name, $name_ref, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    $debtor_no = db_insert_id();
                    if ($debug_sql) display_notification("INSERTED DM $debtor_no");
                    $sql = "SELECT * FROM `0_cust_branch` WHERE `branch_ref` LIKE ".db_escape($name."%");
                    if ($debug_sql) display_notification("BR num name " . $sql);
                    $results = db_query($sql,"cust_branch could not be read");
                    $nrows = mysqli_num_rows($results);
                    mysqli_free_result($results);
                    $name_ref = $name;
                    if ($nrows > 0) $name_ref = $name.'_'.($nrows+1);
                    if ($debug_sql) display_notification("Add branch $name as $name_ref");
                    add_branch($debtor_no, $name, $name_ref, $addr, $_POST['salesman'], $area_code, $taxgid, $_POST['sales_account'], $_POST['sales_discount_account'], $_POST['receivables_account'], $_POST['payment_discount_account'], $_POST['default_location'], $addr, 0, 0, 1, NULL);
                    $branch_code = db_insert_id();
                    if ($debug_sql) display_notification("INSERT BR $name $email");
                    //$person_id = add_crm_person($name."_$branch_code", $name, '', $addr, '', '', '', $email, '', '');
                    $person_id = add_crm_person($name, $name, '', $addr, '', '', '', $email, '', '');
                    add_crm_contact('cust_branch', 'general', $branch_code, $person_id);
                    add_crm_contact('customer', 'general', $debtor_no, $person_id);
            	    display_notification("Added New Customer $name Person $person_id Branch $branch_code debtor $debtor_no");
                    $new_cust++;
                } else {
                    while ($debtornos = db_fetch_assoc($results)) {
                        //display_notification(print_r($debtornos, true));
                        if (isset($debtornos['type']) &&  $debtornos['type'] == 'customer') { // entity_id is the debtor_no
                            $debtor_no = $debtornos['entity_id'];
                            break;
                        }
                        if (isset($debtornos['type']) &&  $debtornos['type'] == 'cust_branch') { // entity_id is the branch_code
                            $sql = "SELECT `debtor_no` FROM `0_cust_branch` WHERE `branch_code` = ".$debtornos['entity_id'];
                            if ($debug_sql) display_notification("bc " . $sql);
                            $res = db_query($sql,"cust_branch could not be retreived");
                            if (mysqli_num_rows($res) > 0) {
                                $cbns = db_fetch_assoc($res);
                                if (isset($cbns['debtor_no'])) {
                                    $debtor_no = $cbns['debtor_no'];
                                    break;
                                }
                            }
                            mysqli_free_result($res);
                        }
                    }
		            update_customer($debtor_no, $name, $name, $addr, $tax_id, $currency, $_POST['dimension_id'], $_POST['dimension2_id'], 1, $_POST['payment_terms'], 0, 0, input_num('credit_limit'), $_POST['sales_type'], NULL);
                    if ($debug_sql) display_notification("UPDATE DM ");
            	    display_notification("Updated Customer $name");
                    $update_cust++;
                }
                commit_transaction();
                $sql = "SELECT * FROM `0_debtors_master` WHERE `debtor_no` = " . db_escape($debtor_no);
                if ($debug_sql) display_notification("dm " . $sql);
                $results = db_query($sql,"debtor_master could not be read");
                if (db_num_rows($results) == 0) {
                    display_notification("Debtor for $name not found!");
               	    break;
                }
                $customer = db_fetch_assoc($results); //sales_type
                // $order_id $debtor_no $name $addr $tax_id $currency

                // Now Collect order info and create order (see Cart in next section)
                $sql = "SELECT `tax_amount`, `total_amount`, `customer_note`, `billing_email` FROM `wp_wc_orders` WHERE `id` = " . db_escape($order_id);
                if ($debug_sql) display_notification("woo " . $sql);
                $results = mysqli_query($woo, $sql);
                if (mysqli_num_rows($results) == 0) {
                    display_notification("Unable to load order details for # $order_id");
                    break;
                }
                $order_info = mysqli_fetch_assoc($results); //Tax, Total, cust note
		        $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no =" . $debtor_no . " AND br_address = " . db_escape($addr);
                if ($debug_sql) display_notification("Find BR " . $sql);
                $result = db_query($sql, "could not find customer branch");
                if (db_num_rows($result) == 0) {
                    if ($debug_sql) display_notification("New Branch");
                    $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE debtor_no = $debtor_no";
                    if ($debug_sql) display_notification("Find BR * " . $sql);
                    $result = db_query($sql, "could not find any customer branch");
                    if (db_num_rows($result) == 0) {
                        display_notification("Found debtor_master $debtor_no but no branch at all");
                        break;
                    }
                    $old_branch = db_fetch_assoc($result);
                    //if ($debug_sql) print_r($old_branch);
                    add_branch($debtor_no, $old_branch['br_name'], $old_branch['branch_ref'], $addr, $old_branch['salesman'], $old_branch['area'], $taxgid, $old_branch['sales_account'], $old_branch['sales_discount_account'], $old_branch['receivables_account'], $old_branch['payment_discount_account'], $old_branch['default_location'], $addr, 0, 0, 1, $old_branch['notes']);
                    $id = db_insert_id();
                    $sql = "SELECT * FROM ".TB_PREF."cust_branch WHERE branch_code = $id";
                    if ($debug_sql) display_notification("Get BR " . $sql);
                    $result = db_query($sql, "Could not load new branch");
                }
                $branch = db_fetch_assoc($result);

                $sql = "SELECT `shipping_total_amount` FROM `wp_wc_order_operational_data` WHERE `order_id` = " . db_escape($order_id) ;
                if ($debug_sql) display_notification("shipping " . $sql);
                $results = mysqli_query($woo, $sql);
                if (mysqli_num_rows($results) == 0) {
                    display_notification("Unable to load order stats for # $order_id");
                    break;
                }
                $shipping = db_fetch_assoc($results);
                if (isset($shipping['shipping_total_amount'])) $freight = $shipping['shipping_total_amount'];

                if (isset($order['date_created_gmt'])) $order_date = sql2date($order['date_created_gmt']);
                else $order_date = Today();
                
                $comments = $order_info['customer_note'];
                if (strlen($comments) > 250) $comments = substr($comments, 0, 250); // FA has tinytext comments
                begin_transaction();
                // Now Add Sales_Order and Sales_Order_Details
                $cart = new Cart(30); // New Sales Order
                $cart->set_customer($debtor_no, $name, 0, $currency, $_POST['payment_terms']);
                $cart->Branch = $branch['branch_code'];
                $cart->cust_ref = "Woo Order # $order_id";
                $cart->Comments = $comments;
                $cart->document_date = $order_date;
                $cart->sales_type = $customer['sales_type'];
                $cart->ship_via = $branch['default_ship_via'];
                $cart->deliver_to = $branch['br_name'];
                $cart->delivery_address = $branch['br_address'];
                $cart->phone = ''; // $branch['phone'];
                $cart->email = $order_info['billing_email'];
                $cart->freight_cost = $freight;
                $cart->Location = $branch['default_location'];
                $cart->due_date = $order_date;

                $sql = "SELECT `order_item_id` FROM `wp_woocommerce_order_items` WHERE `order_item_type` LIKE 'line_item' AND `order_id` = " . db_escape($order_id);
                if ($debug_sql) display_notification("woo " . $sql);
                $results = mysqli_query($woo, $sql);
                if (mysqli_num_rows($results) == 0) {
                    display_notification("Unable to load order products for # $order_id");
                    $fail = true;
                    break;
                }
                $fail = false;
                while ($order_items = mysqli_fetch_assoc($results)) { // Filter out bundle components
                    $order_item_id = $order_items['order_item_id'];
                    $sql = "SELECT " .
                        "MAX(CASE WHEN `meta_key` = '_product_id' then `meta_value` END) as product_id, " .
                        "MAX(CASE WHEN `meta_key` = '_variation_id' then `meta_value` END) as variation_id, " .
                        "MAX(CASE WHEN `meta_key` = '_qty' then `meta_value` END) as product_qty, " .
                        "MAX(CASE WHEN `meta_key` = '_line_total' then `meta_value` END) as product_net_revenue, " .
                        "MAX(CASE WHEN `meta_key` = '_asnp_wepb_parent_id' then `meta_value` END) as parent_id " .
                        " FROM `wp_woocommerce_order_itemmeta` WHERE order_item_id = " . db_escape($order_item_id);
                    $result = mysqli_query($woo, $sql);
                    if (mysqli_num_rows($result) == 0) {
                        display_notification("Unable to load order meta products for # $order_id");
                        $fail = true;
                        break;
                    }
                    $order_prod = mysqli_fetch_assoc($result); // order products, qty and cost
                    if (not_null($order_prod['parent_id'])) continue; // If this is a bundle component, skip
                    // divide prod net revnue/qty since item price can change (unit cost)
                    $unit_qty = $order_prod['product_qty'];
                    $unit_cost = $order_prod['product_net_revenue']/$unit_qty;
                    $unit_discount = 0;
                    if ($order_prod['variation_id'] > 0) $order_sku = $order_prod['variation_id'];
                    else $order_sku = $order_prod['product_id'];
                    $sql = "SELECT `sku` FROM `wp_wc_product_meta_lookup` WHERE `product_id` = " . db_escape($order_sku);
                    $res = mysqli_query($woo, $sql);
                    if (mysqli_num_rows($results) == 0) {
                        display_notification("Unable to load order sku products for # $order_id");
                        $fail = true;
                        break;
                    }
                    if ($fail) break;
                    $res_sku = mysqli_fetch_assoc($res);
                    $unit_sku = $res_sku['sku'];
                    if ($debug_sql) display_notification("Add to Order $unit_sku x $unit_qty @ $unit_cost");
                    add_to_order($cart, $unit_sku, $unit_qty, $unit_cost, $unit_discount);
                }
                if ($fail) {
                    cancel_transaction();
                    break;
                }
                $new_order_no = $cart->write(0);
                commit_transaction();
                display_notification("Added Order Number $new_order_no for " . $name);

                $sql = "SELECT `meta_key`, `meta_value` FROM `wp_wc_orders_meta` WHERE (`meta_key` = '_wcpay_transaction_fee' OR `meta_key` = '_wcpay_refund_status' OR `meta_key` = '_refund_amount' OR `meta_key` = '_refund_reason') AND `order_id` = " . db_escape($order_id);
                if ($debug_sql) display_notification("woo " . $sql);
                $results = mysqli_query($woo, $sql);
                if (mysqli_num_rows($results) == 0) {
                    display_notification("Unable to load order meta for # $order_id");
                    break;
                }
                $order_meta = []; // transaction fees, refund info (optional)
                $order_meta['total_amount'] = $order['total_amount'];
                while ($res = mysqli_fetch_assoc($results)) {
                    $order_meta[$res['meta_key']] = $res['meta_value'];
                }
                display_notification("Payments ".$order_meta['total_amount']. " (Fees: ".$order_meta['_wcpay_transaction_fee'].")");
                // Does a refunded transaction incur double fees? No, does not seem to (We'll see what the checkbook says)
                //$sql = "SELECT `order_id`, `parent_id`, `total_sales`, `tax_total`, `shipping_total`, `status` FROM `wp_wc_order_stats` WHERE `order_id` = " . db_escape($order_id) ." OR `parent_id` = " . db_escape($order_id);
                //if ($debug_sql) display_notification("woo " . $sql);
                //$results_stats = mysqli_query($woo, $sql);
                //if (mysqli_num_rows($results_stats) == 0) {
                //    display_notification("Unable to load order stats for # $order_id");
                //    break;
                //}
                // $results_stat - maybe use this later once order is placed
                // If there is more than one record then a refund happened, add details in the customer_notes and adjust/add transactions
                // Automatically adding payments/refunds will be looked at later
                $new_orders++;
            }
            display_notification("$new_cust  New customers created, $update_cust customers updated and $new_orders new orders.");
        }
    }
    if ($action == 'p_check') { // Price Check
        if ($one_database) $woo = $db;
        else $woo = mysqli_connect($dbHost, $dbUser, $dbPassword);
        if (!$woo) display_notification("Failed to connect WooCommerce Database");
	else {
	    if (!$one_database) mysqli_select_db($woo, $dbName);
	    $sql = "SELECT M.sku, M.min_price, P.post_status, P.post_type FROM wp_wc_product_meta_lookup M INNER JOIN wp_posts P ON M.product_id = P.ID WHERE P.post_status = 'publish'  AND M.sku != '' ORDER BY M.sku";
	    // echo $sql;
	    $p_result = mysqli_query($woo, $sql);
	    $currency = $_POST['currency'];
	    $sales_type = $_POST['sales_type'];
	    $num_price_errors = 0;
	    while ($pp = mysqli_fetch_assoc($p_result)) {
                $price = $pp['min_price'];
                $model = $pp['sku'];
		$myprice = false;
		$myprice = get_kit_price($model, $currency, $sales_type);
		if ($myprice === false) {
		    display_notification("$model price not found in FA");
		} else if ($price != $myprice) {
		    display_notification("$model Prices do not match FA $myprice Woo $price");
		    $num_price_errors++;
		    if (fa_get_item_code_id($model) === false) display_notification("Could not find stock_id for $model");
	        }
            }
    	}
	$action = 'pcheck';
    }
    if ($action == 'p_update') { // Price Update
        if ($one_database) $woo = $db;
        else $woo = mysqli_connect($dbHost, $dbUser, $dbPassword);
        if (!$woo) display_notification("Failed to connect WooCommerce Database");
	else {
	    if (!$one_database) mysqli_select_db($woo, $dbName);
	    $sql = "SELECT M.sku, M.min_price, P.post_status, P.post_type FROM wp_wc_product_meta_lookup M INNER JOIN wp_posts P ON M.product_id = P.ID WHERE P.post_status = 'publish'  AND M.sku != '' ORDER BY M.sku";
	    $p_result = mysqli_query($woo, $sql);
	    $currency = $_POST['currency'];
	    $sales_type = $_POST['sales_type'];
	    $num_price_errors = 0;
	    while ($pp = mysqli_fetch_assoc($p_result)) {
                $price = $pp['min_price'];
                $model = $pp['sku'];
		$myprice = false;
		$myprice = get_kit_price($model, $currency, $sales_type);
		if ($myprice === false) display_notification("$model price not found in FA");
		else if ($price != $myprice) {
		    $stock_id = fa_get_item_code_id($model); // Make sure it exists
		    display_notification("Updating $model ($stock_id) from $myprice to $price");
		    if ($stock_id === false) display_notification("Could not find stock_id for $model");
		    else {
		        $sql = "UPDATE 0_prices SET price= '$price' WHERE sales_type_id='1' AND curr_abrev='USD' AND stock_id LIKE ".db_escape($model);
		        $result = db_query($sql, "could not get item id");
		        $num_price_errors++;
		    }
		}
            }
        }
	$action = 'pupdate';
    }
} else {
    $dbHost = $db_Host;
    $dbUser = $db_User;
    $dbPassword = $db_Password;
    $dbName = $db_Name;
    $startOrder = $start_Order;
    $defaultTaxGroup = $default_TaxGroup;

    if ($action == 'oimport' || $action == 'summary') { // Preview Order Import page
        $num_new_orders = 0;
        if ($one_database) $woo = $db;
        else $woo = mysqli_connect($dbHost, $dbUser, $dbPassword);
        if (!$woo) display_notification("Failed to connect WooCommerce Database");
        else {
	    if (!$one_database) mysqli_select_db($woo, $dbName);
	    $sql = "SELECT O.id, O.customer_id, O.billing_email, O.total_amount, O.date_created_gmt FROM `wp_wc_orders` AS O WHERE O.id > $startOrder AND (O.status = 'wc-completed' OR O.status = 'wc-refunded' ) AND O.type = 'shop_order' order by `id` asc";
        $result = mysqli_query($woo, $sql);
	    while ($order = mysqli_fetch_assoc($result)) {
	        $order_id = (int)$order['id'];
	        $sql = "SELECT * FROM ".TB_PREF."sales_orders WHERE customer_ref like 'Woo Order # $order_id'";
            if ($debug_sql) display_notification("woo " . $sql);
	        $results = db_query($sql, "See if we have the order already");
	        $nrows = mysqli_num_rows($results);
	        if ($nrows > 0) continue;
	        $num_new_orders = $num_new_orders + 1;
	    }
            if (!$one_database) mysqli_close($woo);
        }
    }
}

page("WooCommerce Interface");
if ($action == 'summary') echo 'Summary';
else hyperlink_params($_SERVER['PHP_SELF'], _("Summary"), "action=summary", false);
echo '&nbsp;|&nbsp;';
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Woo Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pcheck') echo 'Price Check';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Price Check"), "action=pcheck", false);
echo '&nbsp;|&nbsp;';
if ($action == 'pupdate') echo 'Update Prices';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Update Prices"), "action=pupdate", false);
echo "<br><br>";

include($path_to_root . "/includes/ui.inc");

if ($action == 'summary') {
    start_form(true);
    start_table(TABLESTYLE);

    $th = array("Type", "# of Updates Needed");
    table_header($th);

    $k = 0;

    label_cell("New Orders");
    if ($num_new_orders == 0) {
        label_cell("None");
    } else {
        label_cell($num_new_orders);
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
    	text_row("Starting Order", 'startOrder', $startOrder, 20, 40);
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
if ($action == 'oimport') {

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
    if (isset($_POST['dimension_id'])) $dim1 = $_POST['dimension_id'];
    else $dim1 = '';
    if (isset($_POST['dimension2_id'])) $dim2 = $_POST['dimension2_id'];
    else $dim2 = '';
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
        dimensions_list_row(_("Dimension")." 1:", 'dimension_id', $dim1, true, " ", false, 1);
    if ($dim > 1)
        dimensions_list_row(_("Dimension")." 2:", 'dimension2_id', $dim2, true, " ", false, 2);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', "Import Woo Orders");

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
    submit_center('pcheck', "Check Woo Prices");
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
    submit_center('pupdate', "Update Woo Prices");
    if ($num_price_errors > 0) display_notification("There were $num_price_errors prices updated");

    end_form();
    end_page();
}

