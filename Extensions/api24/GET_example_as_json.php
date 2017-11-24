<?php

// Retrieves Sales Invoice #5 (trans_no=5, type=13) in Array Format
$trans_no=5;
$type=13; // Sales Invoice
$a = file_get_contents("http://localhost/frontac24/modules/api24/sales/$trans_no/$type");
header('Content-type: text/plain');
header('Content-Disposition: attachment; filename="FA_Doc_'.$type.'_'.$trans_no.'.txt"');
echo $a;

/*
Sample Output of Invoice indented for readability:

{"ref":"auto",
"comments":"Cash Sale",
"order_date":"11\/14\/2017",
"payment":"4",
"payment_terms":{"0":"4",
	"terms_indicator":"4",
	"1":"Cash Only",
	"terms":"Cash Only",
	"2":"0",
	"days_before_due":"0",
	"3":"0",
	"day_in_following_month":"0",
	"4":"0",
	"inactive":"0",
	"5":"1",
	"cash_sale":"1"},
"due_date":"11\/14\/2017",
"phone":"",
"cust_ref":"",
"delivery_address":"N\/A",
"ship_via":"1",
"deliver_to":"Donald Easter LLC",
"delivery_date":"11\/14\/2017",
"location":"DEF",
"freight_cost":"0",
"email":"",
"customer_id":"1",
"branch_id":"1",
"sales_type":"1",
"dimension_id":"0",
"dimension2_id":"0",
"line_items":[
	{"id":"13",
		"stock_id":"102",
		"qty":2,
		"units":"each",
		"price":"250",
		"discount":"0",
		"description":"iPhone 6 64GB"},
	{"id":"14",
		"stock_id":"103",
		"qty":2,
		"units":"each",
		"price":"50",
		"discount":"0",
		"description":"iPhone Cover Case"}
],
"sub_total":600,
"display_total":600}
*/
?>
