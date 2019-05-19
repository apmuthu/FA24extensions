<?php
/**********************************************
Author: Braath Waate
Name: Square Connector
Free software under GNU GPL
***********************************************/
$page_security = 'SA_SQUARE';
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
include_once($path_to_root . "/taxes/db/item_tax_types_db.inc");

include_once ($path_to_root . "/modules/square/connect-php-sdk-master/autoload.php");

display_posts();

function getTransactions($category, $location, $item_like)
{
    global $SysPrefs;
    $sql = "SELECT item.category_id,
            category.description AS cat_description,
            item.stock_id, item.units,
            item.description, item.inactive,
            IF(move.stock_id IS NULL, '', move.loc_code) AS loc_code,
            SUM(IF(move.stock_id IS NULL,0,move.qty)) AS QtyOnHand
        FROM ("
            .TB_PREF."stock_master item,"
            .TB_PREF."stock_category category)
            LEFT JOIN ".TB_PREF."stock_moves move ON item.stock_id=move.stock_id
        WHERE item.category_id=category.category_id
        AND item.inactive = 0
        AND item.no_sale = 0
        AND (item.mb_flag='B' OR item.mb_flag='M')";
    if ($category != 0)
        $sql .= " AND item.category_id = ".db_escape($category);
    if ($location != 'all')
        $sql .= " AND IF(move.stock_id IS NULL, '1=1',move.loc_code = ".db_escape($location).")";
  if($item_like)
  {
    $regexp = null;

    if(sscanf($item_like, "/%s", $regexp)==1)
      $sql .= " AND item.stock_id RLIKE ".db_escape($regexp);
    else
      $sql .= " AND item.stock_id LIKE ".db_escape($item_like);
  }
    $sql .= " GROUP BY item.category_id,
        category.description,
        item.stock_id,
        item.description
        ORDER BY item.category_id,";

    if (@$SysPrefs->sort_item_list_desc)
        $sql .= "item.description";
    else
        $sql .= "item.stock_id";

    return db_query($sql,"No transactions were returned");
}

function square_thumbnail_with_proportion($src_file,$destination_file,$square_dimensions,$jpeg_quality=90)
{
    // Step one: Rezise with proportion the src_file *** I found this in many places.

    $src_img=imagecreatefromjpeg($src_file);

    $old_x=imageSX($src_img);
    $old_y=imageSY($src_img);

    $ratio1=$old_x/$square_dimensions;
    $ratio2=$old_y/$square_dimensions;

    if($ratio1>$ratio2)
    {
        $thumb_w=$square_dimensions;
        $thumb_h=$old_y/$ratio1;
    }
    else    
    {
        $thumb_h=$square_dimensions;
        $thumb_w=$old_x/$ratio2;
    }

    // we create a new image with the new dimmensions
    $smaller_image_with_proportions=ImageCreateTrueColor($thumb_w,$thumb_h);

    // resize the big image to the new created one
    imagecopyresampled($smaller_image_with_proportions,$src_img,0,0,0,0,$thumb_w,$thumb_h,$old_x,$old_y); 

    // *** End of Step one ***

    // Step Two (this is new): "Copy and Paste" the $smaller_image_with_proportions in the center of a white image of the desired square dimensions

    // Create image of $square_dimensions x $square_dimensions in white color (white background)
    $final_image = imagecreatetruecolor($square_dimensions, $square_dimensions);
    $bg = imagecolorallocate ( $final_image, 255, 255, 255 );
    imagefilledrectangle($final_image,0,0,$square_dimensions,$square_dimensions,$bg);

    // need to center the small image in the squared new white image
    if($thumb_w>$thumb_h)
    {
        // more width than height we have to center height
        $dst_x=0;
        $dst_y=($square_dimensions-$thumb_h)/2;
    }
    elseif($thumb_h>$thumb_w)
    {
        // more height than width we have to center width
        $dst_x=($square_dimensions-$thumb_w)/2;
        $dst_y=0;

    }
    else
    {
        $dst_x=0;
        $dst_y=0;
    }

    $src_x=0; // we copy the src image complete
    $src_y=0; // we copy the src image complete

    $src_w=$thumb_w; // we copy the src image complete
    $src_h=$thumb_h; // we copy the src image complete

    $pct=100; // 100% over the white color ... here you can use transparency. 100 is no transparency.

    imagecopymerge($final_image,$smaller_image_with_proportions,$dst_x,$dst_y,$src_x,$src_y,$src_w,$src_h,$pct);

    imagejpeg($final_image,$destination_file,$jpeg_quality);

    // destroy aux images (free memory)
    imagedestroy($src_img); 
    imagedestroy($smaller_image_with_proportions);
    imagedestroy($final_image);
}


function uploadItemImage($square_url, $access_token, $image_path_on_server)
{
    $output = tempnam( sys_get_temp_dir(), "sq");
    square_thumbnail_with_proportion($image_path_on_server, $output, 600);
    // scale_image($image_path_on_server, $output);

$cfile = new CURLFile($output, 'image/jpeg', 'image_data');
$image_data = array('image_data' => $cfile);

$curl = curl_init();
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  'Authorization: Bearer ' . $access_token,
  'Accept: application/json',
));
curl_setopt($curl, CURLOPT_POST, TRUE);
curl_setopt($curl, CURLOPT_POSTFIELDS, $image_data);
curl_setopt($curl, CURLOPT_URL, $square_url);
curl_setopt($curl, CURLOPT_SAFE_UPLOAD, TRUE);
curl_setopt($curl, CURLOPT_BINARYTRANSFER, TRUE);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
curl_setopt($curl, CURLOPT_VERBOSE, TRUE);
$json = curl_exec($curl);
/*
    $return_status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    print "POST to $square_url with status $return_status\n";
    print "$json\n";
*/
curl_close($curl);
unlink($output);
}

function square_variation($stock_id)
{
    $myprice = get_kit_price($stock_id, $_POST['currency'], $_POST['sales_type']);

    $result = get_all_item_codes($stock_id);
    $row    = db_fetch($result);

    return array(
        "name" => "Small",
        "pricing_type" => "FIXED_PRICING",
        "sku" => $row['item_code'],
        "price_money" => array(
            "amount" => 100 * $myprice,
            "currency_code" => "USD"
        )
    );
}


function square_body($stock_id, $trans)
{
  return array(
    "id" => $stock_id,
    "name" => str_replace("Whitewater Hill ","",$trans['description']),
    "category_id" => $trans['category_id'],
    "variations" => array(square_variation($stock_id))
  );
}


function display_posts()
{
    $query = "";
    foreach ($_POST as $key => $value) {
        $query .= $key . "=" . $value;
        if ($key == 'action')
            break;
        $query .= "&";
    }
    display_notification($query);
}

function not_null($str) {
    if ($str != '' && $str != NULL) return 1;
    return 0;
}

function square_locs($accessToken, $date = null)
{
# setup authorization
\SquareConnect\Configuration::getDefaultConfiguration()->setAccessToken($accessToken);

# create an instance of the Location API
$locations_api = new \SquareConnect\Api\LocationsApi();

try {
  $locations = $locations_api->listLocations();
  $locs = json_decode($locations);
  // print "hello" . print_r($locs->locations[0], true) . "asdf";
//  print_r($locations->getLocations());
} catch (\SquareConnect\ApiException $e) {
  echo "Caught exception!<br/>";
  print_r("<strong>Response body:</strong><br/>");
  echo "<pre>"; var_dump($e->getResponseBody()); echo "</pre>";
  echo "<br/><strong>Response headers:</strong><br/>";
  echo "<pre>"; var_dump($e->getResponseHeaders()); echo "</pre>";
  exit(1);
}


    $api = new \SquareConnect\Api\V1TransactionsApi();
    $items_api = new \SquareConnect\Api\V1ItemsApi();
    $cat_api = new \SquareConnect\Api\CatalogApi();
    $cursor = null;
    $loc_orders = array();
    foreach ($locs->locations as $location) {
        if (empty($date))
            $loc_orders[$location->name] = $location->id;
        else
        do {
            $trans = $api->listPayments($location->id, null, gmdate("c", strtotime($date)), null, 200, $cursor);
            $loc_orders[$location->name] = count((array)$trans);

            if (!isset($trans->cursor))
                break;
            $cursor = $trans->cursor;
        } while (1);
    }
    return $loc_orders;
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

function get_item_tax_type_by_name($name) {
    $sql = "SELECT * FROM ".TB_PREF."item_tax_types WHERE name=".db_escape($name);
    $result = db_query($sql, "could not get item tax type");
    return db_fetch($result);
}

function get_sales_point_by_name($name)
{
        $sql = "SELECT pos.*, loc.location_name, acc.bank_account_name FROM "
                .TB_PREF."sales_pos as pos
                LEFT JOIN ".TB_PREF."locations as loc on pos.pos_location=loc.loc_code
                LEFT JOIN ".TB_PREF."bank_accounts as acc on pos.pos_account=acc.id
                WHERE pos.pos_name=".db_escape($name);

        $result = db_query($sql, "could not get POS definition");

        return db_fetch($result);
}

function paymentExistsInFA($id)
{
    $sql = "SELECT EXISTS (SELECT 1 FROM " .TB_PREF."sales_orders so
        WHERE so.customer_ref=".db_escape($id) . ")";
    $result = db_query($sql, "could not query sales orders");
    $row = db_fetch($result);
    return ($row[0] != 0);
}

function addImageToFA($stock_id, $oscwebsite, $name)
{
    if (!is_null($oscwebsite)) {
        $filename = company_path().'/images';
        $filename .= "/".item_img_name($stock_id).".jpg";

        @copy($oscwebsite . "/catalog/images/" . $name, $filename);
    }
}

function addItemToFA($osc_id, $products_name, $desc, $cat, $tax_type_id, $mb_flag, $products_price, $products_status, $no_sale, $no_purchase, $barcode)
{
        $inactive = ($products_status == 0 ? 1 : 0);
        $sql    = "SELECT stock_id FROM ".TB_PREF."stock_master WHERE stock_id=".db_escape($osc_id);
        $result = db_query($sql,"item could not be retreived");
        $row    = db_fetch_row($result);
        if (!$row) {
            $sql = "INSERT INTO ".TB_PREF."stock_master (stock_id, description, long_description, category_id,
                    tax_type_id, units, mb_flag, sales_account, inventory_account, cogs_account,
                    adjustment_account, wip_account, dimension_id, dimension2_id, inactive, no_sale, no_purchase)
                    VALUES ('$osc_id', " . db_escape($products_name) . ", " . db_escape($desc) . ",
                    '$cat', '$tax_type_id', '{$_POST['units']}', '$mb_flag',
                    '{$_POST['sales_account']}', '{$_POST['inventory_account']}', '{$_POST['cogs_account']}',
                    '{$_POST['adjustment_account']}', '{$_POST['wip_account']}', '{$_POST['dimension_id']}', '{$_POST['dimension2_id']}', '$inactive', '$no_sale', '$no_purchase')";

            db_query($sql, "The item could not be added");
            $sql = "INSERT INTO ".TB_PREF."loc_stock (loc_code, stock_id) VALUES ('{$_POST['default_location']}', ".db_escape($osc_id).")";

            db_query($sql, "The item locstock could not be added");
            add_item_price($osc_id, $_POST['sales_type'], $_POST['currency'], $products_price);
            display_notification("Insert $osc_id " . $products_name);
        } else {
            // FrontAccounting is considered the inventory master
            // so once an osCommerce item is imported into FA,
            // update is limited to fields controlled by OSC
            // ignoring price and inventory quantity.
            // Note that Update Prices and Update Inventory
            // will overwrite these fields in osCommerce, so it
            // it pointless to change them in osCommerce.
            // Conversely, product name, category, tax class are controlled
            // by osCommerce so it is pointless to change them
            // in FA, as they will be overwritten.
            $sql = "UPDATE ".TB_PREF."stock_master SET description=" . db_escape($products_name) .", long_description=" . db_escape($desc) . ", category_id='$cat', tax_type_id='$tax_type_id'
                WHERE stock_id=" . db_escape($osc_id);

            db_query($sql, "The item could not be updated");
            display_notification("Update $osc_id $products_name");
        }

        $sql    = "SELECT id from ".TB_PREF."item_codes WHERE item_code=".db_escape($osc_id)." AND stock_id = ".db_escape($osc_id);
        $result = db_query($sql, "item code could not be retreived");
        $row    = db_fetch_row($result);
        if (!$row) add_item_code($osc_id, $osc_id, $products_name, $cat, 1);
        else update_item_code($row[0], $osc_id, $osc_id, $products_name, $cat, 1);

        // barcode
        if ($barcode != "" && strlen($barcode) <= 20) {
            $sql    = "SELECT id from ".TB_PREF."item_codes WHERE item_code=".db_escape($barcode)." AND stock_id = ".db_escape($osc_id);
            $result = db_query($sql, "item code could not be retreived");
            $row    = db_fetch_row($result);
            if (!$row) add_item_code($barcode, $osc_id, $products_name, $cat, 1, 1);
            else update_item_code($row[0], $barcode, $osc_id, $products_name, $cat, 1, 1);
        }
    }

function sales_service_items_list_row($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
        echo "<tr>";
        if ($label != null)
                echo "<td class='label'>$label</td>\n";
        echo "<td>";
        echo sales_items_list($name, $selected_id, $all_option, $submit_on_change,
                'local', array('where'=>array("mb_flag='D'"), 'cells'=>false, 'editable' => false));
        echo "</td></tr>";
}

function get_error_status()
{
    global $messages;
    if (count($messages)) {
        foreach($messages as $cnt=>$msg) {
            if ($msg[0] == E_USER_ERROR)
                return "FAILED";
        }
    }
    // Note: some warnings are expected, like duplicate items in cart
    return "SUCCESS";
}

// get FA qoh for an OSC item.  The quantity of OSC parent items is the sum
// of the quantities of their attributes.  The quantity of FA parent items
// should always be zero

function get_fa_qoh($osc_id)
{
    $osc_attr = $osc_id . "-";
    $sql    = "SELECT stock_id FROM ".TB_PREF."stock_master WHERE LOCATE(" . db_escape($osc_attr) . ", stock_id) != 0";
    $result = db_query($sql, "could not get item");
    if (db_num_rows($result) == 0)
        $myqty = get_qoh_on_date($osc_id, $_POST['default_location']);
    else {
        $myqty = 0;
        while ($row=db_fetch($result)) {
            $myqty += get_qoh_on_date($row['stock_id'], $_POST['default_location']);
        }
    }
    return $myqty;
}

function show_items($stock)
{
    $list="";
    foreach ($stock as $stock_id) {
        $item = get_item($stock_id);
        $list.="{" . $stock_id . "=" . $item['description'] . "}";
    }
    return $list;
}

// Match FA payment_terms from Square payment method.
// We need a matching POS Name to find the FA pos.
// Then find the first FA payment terms that match the Square payment type
// The idea is to generate payments for some Square payment types
// and no payment for credit payment types.

function get_FA_payment_terms($cart)
{
    $result = get_payment_terms_all(false);
    while($row=db_fetch($result))
    {
        if (($cart->pos['cash_sale'] == 0
            && $row['days_before_due'] != 0) ||
            ($cart->pos['cash_sale']
                && $row['days_before_due'] == 0))
                return $row['terms_indicator'];
    }
    return null;
}


// error_reporting(E_ALL);
// ini_set("display_errors", "on");
$error_status="";

global $db; // Allow access to the FA database connection
$debug_sql = 0;

global $db_connections;
$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

$sql          = "SHOW TABLES";
$result       = db_query($sql, "could not show tables");
$found        = 0;
while (($row = db_fetch_row($result))) {
    if ($row[0] == $cur_prefix."square") $found = 1;
}


$accessToken           = "";
$locationId           = "";
$lastdate         = "";
$destCust         = 0;
$oscwebsite       = "";

$access_Token          = "";
$location_id          = "";
$last_date        = "";

$min_cid = 0;
$max_cid = 0;
$min_date = "";
$min_iid = 0;
$max_iid = 0;
$order_count = 0;

if ($found) {
    // Get Access Token
    $sql     = "SELECT * FROM ".TB_PREF."square WHERE name = 'access_token'";
    $result  = db_query($sql, "could not get host name");
    $row     = db_fetch_row($result);
    $access_Token = $row[1];

    // Get Location Id
    $sql     = "SELECT * FROM ".TB_PREF."square WHERE name = 'location_id'";
    $result  = db_query($sql, "could not get host name");
    $row     = db_fetch_row($result);
    $location_id = $row[1];

    // Get last order imported
    $sql = "SELECT * FROM ".TB_PREF."square WHERE name = 'lastdate'";
    $result = db_query($sql, "could not get DB name");
    $row    = db_fetch_row($result);
    if (!$row) {
        $last_date = Today();
        $sql = "INSERT INTO ".TB_PREF."square (name, value) VALUES ('lastdate', '" . $last_date ."')";
        db_query($sql, "add lastdate");
    } else $last_date = $row[1];

    // Get destination customer
    $sql        = "SELECT * FROM ".TB_PREF."square WHERE name = 'destCust'";
    $result     = db_query($sql, "could not get destCust");
    $row        = db_fetch_row($result);
    $destCust  = $row[1];

    // Get osc website
    $sql        = "SELECT * FROM ".TB_PREF."square WHERE name = 'oscwebsite'";
    $result     = db_query($sql, "could not get oscwebsite");
    $row        = db_fetch_row($result);
    $oscwebsite  = $row[1];
}

$num_price_errors = -1;
$num_qty_errors = -1;

$action = 'summary';
if (isset($_GET['action']) && $found) $action = $_GET['action'];
if (!$found) $action = 'show';

if (isset($_POST['action'])) {
    $action = $_POST['action'];

    // Create Table
    if ($action == 'create') {
        $sql = "DROP TABLE IF EXISTS ".TB_PREF."square";
        db_query($sql, "Error dropping table");
        $sql = "CREATE TABLE ".TB_PREF."square ( `name` char(15) NOT NULL default '', " .
               " `value` varchar(100) NOT NULL default '', PRIMARY KEY  (`name`)) ENGINE=MyISAM";
        db_query($sql, "Error creating table");
        header("Location: square.php?action=show");
    }

    if ($action == 'update') {
        if (isset($_POST['accessToken']))     $accessToken          = $_POST['accessToken'];
        if ($accessToken != $access_Token) { // It changed
            if ($accessToken == '') $sql = "DELETE FROM ".TB_PREF."square WHERE name = 'access_token'";
            else if ($access_Token == '') $sql = "INSERT INTO ".TB_PREF."square (name, value) VALUES ('access_token', ".db_escape($accessToken).")";
            else $sql = "UPDATE  ".TB_PREF."square SET value = ".db_escape($accessToken)." WHERE name = 'access_token'";
            db_query($sql, "Update 'access_token'");
        }
        if (isset($_POST['locationId']))     $locationId          = $_POST['locationId'];
        if ($locationId != $location_id) { // It changed
            if ($locationId == '') $sql = "DELETE FROM ".TB_PREF."square WHERE name = 'location_id'";
            else if ($location_id == '') $sql = "INSERT INTO ".TB_PREF."square (name, value) VALUES ('location_id', ".db_escape($locationId).")";
            else $sql = "UPDATE  ".TB_PREF."square SET value = ".db_escape($locationId)." WHERE name = 'location_id'";
            db_query($sql, "Update 'location_id'");
        }

        $action = 'show';

    } else {
        $accessToken          = $access_Token;
        $locationId          = $location_id;
        $lastdate        = $last_date;
    }

    if ( in_array($action, array('o_import', 'i_export')) ) {

        if ($action == 'o_import') { // Import Order specified by oID

            $destCust        = $_POST['destCust'];
            $sql = "INSERT INTO ".TB_PREF."square (name, value) VALUES ('destCust', ".db_escape($destCust).") ON DUPLICATE KEY UPDATE name='destCust', value=".db_escape($destCust);
            db_query($sql, "Update 'destCust'");

            $customer = null;
            $errors = (int) $_POST['errors'];
            $error = 0;

            $sql    = "SELECT * FROM ".TB_PREF."debtors_master WHERE debtor_no=".$destCust;
            $result = db_query($sql, "Could not find customer by debtor_no");
            if (db_num_rows($result) == 0) {
                display_error("Customer id " . $destCust  . " not found");
                $error = 1;
            } else {
                $customer = db_fetch_assoc($result);
                $debtor_no = $customer['debtor_no'];
            }

            // display_notification("Found " . mysqli_num_rows($oid_result) . " New Orders");

            $default_sales_act = get_company_pref('default_sales_act');

            // find the tax included sales type for osc orders without tax
            $result = get_all_sales_types();
            while ($sales_type = db_fetch($result)) {
                if ($sales_type['tax_included'])
                    $tax_included_sales_type_id  = $sales_type['id'];
            }

            if ($error == 0) {

# setup authorization
\SquareConnect\Configuration::getDefaultConfiguration()->setAccessToken($accessToken);

# create an instance of the Location API
$locations_api = new \SquareConnect\Api\LocationsApi();

try {
  $locations = $locations_api->listLocations();
  $locs = json_decode($locations);
  // print "hello" . print_r($locs->locations[0], true) . "asdf";
//  print_r($locations->getLocations());
} catch (\SquareConnect\ApiException $e) {
  echo "Caught exception!<br/>";
  print_r("<strong>Response body:</strong><br/>");
  echo "<pre>"; var_dump($e->getResponseBody()); echo "</pre>";
  echo "<br/><strong>Response headers:</strong><br/>";
  echo "<pre>"; var_dump($e->getResponseHeaders()); echo "</pre>";
  exit(1);
}


    $api = new \SquareConnect\Api\V1TransactionsApi();
    $items_api = new \SquareConnect\Api\V1ItemsApi();
    $cat_api = new \SquareConnect\Api\CatalogApi();
    $cursor = null;
    $fees = 0;
    $total = 0;
    foreach ($locs->locations as $location) {

            // Find the customer branch using the Square location as the branch name
            // This is necessary to get the correct sales tax rate on the order,
            // because each square location can have a different tax rate.

                $sql       = "SELECT *, t.name AS tax_group_name FROM ".TB_PREF."cust_branch LEFT JOIN ".TB_PREF."tax_groups t ON tax_group_id=t.id WHERE debtor_no = ".db_escape($debtor_no) . " AND br_name = " .db_escape($location->name);
                $result = db_query($sql, "Could not load branch");
                if (db_num_rows($result) == 0) {

                    display_notification("Customer branch for location "  . $location->name . " not found.  Skipping.");
                    continue;
                }
            $branch                  = db_fetch_assoc($result);
            // print_r($branch);

        do {
            $trans = $api->listPayments($location->id, null, gmdate("c", strtotime($_POST['from_date'])), gmdate("c", strtotime("+1 day", strtotime($_POST['to_date']))), 200, $cursor);
            if (!empty((array)$trans)) {
                foreach ($trans as $t) {

                    if (paymentExistsInFA($t->getId())) {
                        display_notification("Skipping " . $t->getId());
                        continue;
                    } else
                        display_notification("Processing " . $t->getId());

                    $cart                = new Cart(ST_SALESINVOICE);

                    $payment_method = $t->getTender()[0]->getType();
                    $pos = get_sales_point_by_name($payment_method);
                    if (!$pos) {
                        display_error("Payment method $payment_method does not exist as a Point of Sale in FA.  Do Setup->Points of Sale first.");
                        continue;
                    }

                    $cart->pos=$pos;
                    $cart->Location = $cart->pos['pos_location'];
                    $cart->location_name = $cart->pos['location_name'];

                    $cart->payment = get_FA_payment_terms($cart);
                    if ($cart->payment == null) {
                        display_error('No matching payment terms for order ' . $t->getId());
                        continue;
                    }
                    $cart->payment_terms = get_payment_terms($cart->payment);

                if ($customer['sales_type'] == 0) {
                    display_error("zero customer sales type");
                    display_error(print_r($customer, true));
                    display_error('Skipping order ' . $oID);
                    continue;
                }

                // Now Add Sales_Order and Sales_Order_Details
                $cart->customer_id       = $customer['debtor_no'];
                $cart->customer_currency = $customer['curr_code'];

                $addr = "";
                $total_shipping = 0;
                $total_tax = 0;
                $customers_name = "Square";
                $comments = "";
                $date_purchased = $t->getCreatedAt();

                $cart->set_branch(
                    $branch["branch_code"],
                    $branch["tax_group_id"],
                    $addr);
                $cart->set_delivery($branch['default_ship_via'], $customers_name, $addr, $total_shipping);

                $cart->cust_ref          = $t->getId();
                $cart->Comments          = $comments;
                $cart->document_date     = sql2date($date_purchased);

                // If the osc order did not have tax, assume tax was included
                // (if items are tax exempt, like food, this has no effect)
                if ($total_tax == 0
                    && isset($tax_included_sales_type_id))
                    $cart->sales_type    = $tax_included_sales_type_id;
                else
                    $cart->sales_type    = $customer['sales_type'];

                $cart->due_date          = sql2date($date_purchased);
                $cart->dimension_id      = $customer['dimension_id'];
                $cart->dimension2_id     = $customer['dimension2_id'];
                // $cart->payment_info      = $order['cc_owner'] . ' ' . $order['cc_number'];

                       $total += $t->getTender()[0]->getTotalMoney()->getAmount();
                        $fees += $t->getProcessingFeeMoney()->getAmount();
                        $items = $t->getItemizations();
//print_r($items);
                        foreach ($items as $item) {
                            $detail = $item->getItemDetail();
                            $item_id = $detail->getItemId();
                            $item2 = $items_api->retrieveItem($location->id, $item_id);
                            $item3 = $cat_api->retrieveCatalogObject($item2->getV2Id(), false);
                            $catobj = $item3->getObject();
                            $item4 = $catobj->getCatalogV1Ids();
                            $stock_id = $item4[0]->getCatalogV1Id();
                            add_to_order($cart, $stock_id, $item->getQuantity(),
                                $item->getSingleQuantityMoney()->getAmount()/100,
                                -$item->getDiscountMoney()->getAmount()/$item->getGrossSalesMoney()->getAmount());
                        }

                        if (!empty($t->refunds)) {
                            foreach ($t->refunds as $ref) {
                                print "REF " . $ref->amount_money->amount . "," . $ref->processing_fee_money->amount . "\n";
                                $total -= $ref->amount_money->amount;
                                $fees -= $ref->processing_fee_money->amount;
                            }
                       }

                if ($_POST['trial_run'] == 0) {
                    $order_no = $cart->write(1);
                    display_notification("Added Order Number $order_no for " . $customers_name);
                }

                } // foreach

            } // !empty

            if (!isset($trans->cursor))
                break;
            $cursor = $trans->cursor;
        } while (1);

    } // location


            } // dest customer found


            if ($_POST['trial_run'] == 0) {
                if ($_POST['to_date'] > $lastdate) {
                    $sql = "UPDATE  ".TB_PREF."square SET value = ".db_escape($_POST['to_date'])." WHERE name = 'lastdate'";
                    db_query($sql, "Update 'lastdate'");
                    $last_date = $_POST['to_date'];
                }
            }

            $order_count = square_locs($accessToken, $last_date);
            $error_status = get_error_status();
            $action = 'oimport';
        } // no error
    } // o_import


        if ($action == 'i_export') { // Export Items

// Configure OAuth2 access token for authorization: oauth2
SquareConnect\Configuration::getDefaultConfiguration()->setAccessToken($accessToken);

$items_api = new \SquareConnect\Api\V1ItemsApi();

// Create category

$body=array(
    "id" => $_POST['category'],
    "name" => get_category_name($_POST['category'])
  );

//print "$accessToken $locationId";
//die();

try {
  $items = $items_api->createCategory($locationId, $body);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->createCategory: ', $e->getMessage(), PHP_EOL;
}

// Delete items no longer in FA

try {
  $items = $items_api->listItems($locationId);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->listItems: ', $e->getMessage(), PHP_EOL;
}

  foreach ($items as $item) {
  $stock_id = $item->getId();
  $square_items[$stock_id] = 1;

  $trans = get_item($stock_id);
   if ($trans == null) {
    display_notification("$stock_id not found");
    continue;
   }

  if ($trans['inactive'] == 1 || $trans['no_sale'] == 1) {
try {
    $result = $items_api->deleteItem($locationId, $stock_id);
    // print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->deleteItem: ', $e->getMessage(), PHP_EOL;
}
    continue;
  }

// Update Item


try {
    $result = $items_api->updateItem(
        $locationId,
        $stock_id,
        square_body($stock_id, $trans)
    );
    //  print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->updateItem: ', $e->getMessage(), PHP_EOL;
}

try {
    $result = $items_api->updateVariation(
        $locationId,
        $stock_id,
        $item->getVariations()[0]->getId(),
        square_variation($stock_id)
    );
    //  print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->getVariations: ', $e->getMessage(), PHP_EOL;
}

    $filename = company_path().'/images';
    $filename .= "/".item_img_name($stock_id).".jpg";
    if ($_POST['upload'] == 1 && file_exists($filename)) {
        $url = "https://connect.squareup.com/v1/$locationId/items/$stock_id/image";
        uploadItemImage($url, $accessToken, $filename);
    }

    } // foreach

// Add Items from selected category

    $res = getTransactions($_POST['category'], 'all', null);
    $catt = '';
    while ($trans=db_fetch($res))
    {
    $stock_id = $trans['stock_id'];
    if (isset($square_items[$stock_id]))
        continue;

display_notification("Adding $stock_id");
  $body = square_body($stock_id, $trans);

try {
    $result = $items_api->createItem($locationId, $body);
    // print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling V1ItemsApi->createItem: ', $e->getMessage(), PHP_EOL;
}

} // while





} // i_export



} else {
    $accessToken      = $access_Token;
    $locationId      = $location_id;
    $lastdate         = $last_date;
}

if ( in_array($action, array('summary', 'oimport'))  ) {

    if ($action == 'summary') {
        $order_count = square_locs($accessToken, $last_date);
    }
}

$js = "";
if ($SysPrefs->use_popup_windows)
    $js .= get_js_open_window(800, 500);
if (user_use_date_picker())
        $js .= get_js_date_picker();

$help_context="Square Connector";
page(_($help_context), false, false, "", $js);

if ($action == 'summary') echo 'Summary';
else hyperlink_params($_SERVER['PHP_SELF'], _("Summary"), "action=summary", false);
echo '&nbsp;|&nbsp;';
if ($action == 'show') echo 'Configuration';
else hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
echo '&nbsp;|&nbsp;';
if ($action == 'oimport') echo 'Order Import';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Order Import"), "action=oimport", false);
echo '&nbsp;|&nbsp;';
if ($action == 'iexport') echo 'Export Inventory';
else hyperlink_params($_SERVER['PHP_SELF'], _("&Export Inventory"), "action=iexport", false);
echo "<br><br>";

include($path_to_root . "/includes/ui.inc");

if ($action == 'summary') {
    start_form(true);
    start_table(TABLESTYLE);

    $th = array("Type", "Order Count");
    table_header($th);

    $k = 0;

    //alt_table_row_color($k);

    label_cell("Last Import Date");
    label_cell($last_date);
    end_row();

    foreach ($order_count as $loc => $count) {
        label_cell("$loc");
        label_cell($count);
        end_row();
    }

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
        text_row("Square Access Token", 'accessToken', $accessToken, 20, 40);
        if (!empty($accessToken)) {
            end_table(1);
            start_table(TABLESTYLE);
            $th = array("Inventory Location", "Square Location Id");
            table_header($th);
            alt_table_row_color($k);
            $locs = square_locs($accessToken);
            if (count($locs) == 0)
                display_error("Access Token is invalid or no square locations found");
            else
            foreach ($locs as $loc_name => $id) {
                label_cell($loc_name);
                if (count($locs) == 1 || $locationId == $id)
                    label_cell(radio($id, 'locationId', $id, true));
                else
                    label_cell(radio($id, 'locationId', $id));
                end_row();
            }
        }
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

    table_section_title("Order Import Options");

    if (!isset($_POST['from_date']))
        $_POST['from_date'] = $lastdate;
    if (!isset($_POST['to_date']))
        $_POST['to_date'] = Today();
    date_row("From Order Date:", 'from_date');
    date_row("To Order Date:", 'to_date');
    customer_list_row(_("Destination Customer:"), 'destCust', $destCust, false);
    sales_service_items_list_row(_('Adjustment Item:'),'adjustment', null, false, false, false);

    yesno_list_row(_("Errors"), 'errors', null, "Ignore", "Skip", false);
    yesno_list_row(_("Trial Run"), 'trial_run', null, "", "", false);

    if ($destCust != 0) {
            $sql    = "SELECT name FROM ".TB_PREF."debtors_master WHERE debtor_no=".$destCust;
            $result = db_query($sql, "customer could not be retrieved");
            $row    = db_fetch_assoc($result);

    }
    label_row("Operation Result", $error_status);

    end_table(1);

    hidden('action', 'o_import');
    submit_center('oimport', "Import osC Orders");

    end_form();
    end_page();
}

if ($action == 'iexport') {

    if ($order_count != 0)
        display_error("Order Import required before Inventory Update ($order_count new orders)");
    else {
    start_form(true);

    start_table(TABLESTYLE2, "width=40%");

    table_section_title("Export Inventory Options");

    currencies_list_row("Customer Currency:", 'currency', get_company_pref("curr_default"));
    sales_types_list_row("Sales Type:", 'sales_type', null);

    locations_list_row("Location:", 'default_location', null);
    stock_categories_list_row("Category:", 'category', null, _("All Categories"));
    yesno_list_row("Upload Images:", 'upload', null);

    end_table(1);

    hidden('action', 'i_export');
    submit_center('pexport', "Export FA Items To Square");
    if ($num_qty_errors > 0) display_notification("There were $num_qty_errors items updated");

    end_form();
    end_page();
    }
}
