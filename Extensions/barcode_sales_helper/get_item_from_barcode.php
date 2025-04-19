<?php

$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");

$barcode = $_GET['barcode'];

$sql = "SELECT stock_id FROM 0_stock_master WHERE stock_id = ".db_escape($barcode);
$res = db_query($sql, "Could not find item by barcode");

if ($row = db_fetch($res)) {
    $price = get_stock_price_type_currency($row['stock_id'], get_company_pref('base_sales'), get_company_pref('curr_default'))['price'];
    echo json_encode(['success' => true, 'stock_id' => $row['stock_id'], 'price'=>$price]);
} else {
    echo json_encode(['success' => false]);
}
