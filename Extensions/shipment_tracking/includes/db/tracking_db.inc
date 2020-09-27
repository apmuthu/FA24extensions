<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/


function add_shipment($shipment_document, $shipment_via, $shipment_date, $shipment_tracking_no, $shipment_vehicle_no, $shipment_eway_bill, $shipment_package, $abbr, $shipment_freight, $shipment_status)
{
    $date = date2sql($shipment_date);
    $ship_doc = explode("-", $shipment_document);
    $trans_no = $ship_doc[0];
    $type = $ship_doc[1];
	$sql = "INSERT INTO ".TB_PREF."shipments (trans_no, type, shipment_date, shipment_tracking_no, shipment_vehicle_no, shipment_eway_bill, shipment_package, abbr, shipment_freight, shipment_status) VALUES (".db_escape($trans_no).", ".db_escape($type).", ".db_escape($date).", ".db_escape($shipment_tracking_no).", ".db_escape($shipment_vehicle_no).", ".db_escape($shipment_eway_bill).", ".db_escape($shipment_package).", ".db_escape($abbr).", ".db_escape($shipment_freight).", ".db_escape($shipment_status).")";
	
   	db_query($sql,"The Shipment could not be added");
   	update_ship_via($trans_no, $type, $shipment_via);
}

function update_shipment($shipment_id,$shipment_document,$shipment_via,$shipment_date,$shipment_tracking_no,$shipment_vehicle_no,$shipment_eway_bill,$shipment_package,$abbr,$shipment_freight,$shipment_status)
{
    $date = date2sql($shipment_date);
    $ship_doc = explode("-", $shipment_document);
    $trans_no = $ship_doc[0];
    $type = $ship_doc[1];
	$sql = "UPDATE ".TB_PREF."shipments SET trans_no=".db_escape($trans_no).", type=".db_escape($type).", shipment_date=".db_escape($date).", shipment_tracking_no=".db_escape($shipment_tracking_no).", shipment_vehicle_no=".db_escape($shipment_vehicle_no).", shipment_eway_bill=".db_escape($shipment_eway_bill).", shipment_package=".db_escape($shipment_package).", abbr=".db_escape($abbr).", shipment_freight=".db_escape($shipment_freight).", shipment_status=".db_escape($shipment_status);

    $sql .= " WHERE shipment_id = ".db_escape($shipment_id);                                   
   db_query($sql,"The Shipment could not be updated");
   update_ship_via($trans_no, $type, $shipment_via);
}

function update_ship_via($trans_no, $type, $shipment_via)
{
    $sql = "UPDATE ".TB_PREF."debtor_trans SET ship_via=".db_escape($shipment_via);
    $sql .= " WHERE trans_no = ".db_escape($trans_no)." AND type = ".db_escape($type);
    db_query($sql,"The Shipping Company could not be updated");
}

function delete_shipment($shipment_id)
{
	$sql="DELETE FROM ".TB_PREF."shipments WHERE shipment_id=".db_escape($shipment_id);
	db_query($sql,"could not delete Shipment");
}

function get_shipments($show_inactive)
{
	$sql = "SELECT shipment.*, trans.tran_date as transaction_date, trans.reference as transaction_reference, trans.ship_via AS shipment_via, trans.order_ AS transaction_order, concat(trans.trans_no, '-', trans.type) AS shipment_document, debtor.name AS debtor_name, debtor.debtor_no AS debtor_no, (SELECT count(*) FROM ".TB_PREF."debtor_trans_details WHERE debtor_trans_no=trans.trans_no AND debtor_trans_type=trans.type) AS shipment_items, SUM(trans.ov_freight + trans.ov_freight_tax) AS transaction_freight, ship.shipper_name AS shipping_company, opt.column_value AS shipment_status_value FROM ".TB_PREF."shipments shipment";
	$sql .= " LEFT JOIN ".TB_PREF."debtor_trans trans ON trans.trans_no=shipment.trans_no AND shipment.type=trans.type LEFT JOIN ".TB_PREF."shippers ship ON ship.shipper_id=trans.ship_via LEFT JOIN ".TB_PREF."debtors_master debtor ON debtor.debtor_no=trans.debtor_no LEFT JOIN ".TB_PREF."options opt ON opt.option_id=shipment.shipment_status LEFT JOIN ".TB_PREF."voided AS vd ON trans.type=vd.type AND trans.trans_no=vd.id";
	$sql .= " WHERE ISNULL(vd.id)";
	if (!$show_inactive) $sql .= " AND !shipment.inactive";
	$sql .= " GROUP BY shipment.shipment_id";
	return db_query($sql,"could not get Shipments");
}

function get_shipment($shipment_id)
{
	$sql = "SELECT shipment.*, trans.tran_date as transaction_date, trans.reference as transaction_reference, trans.ship_via AS shipment_via, trans.order_ AS transaction_order, concat(trans.trans_no, '-', trans.type) AS shipment_document, debtor.name AS debtor_name, debtor.debtor_no AS debtor_no, (SELECT count(*) FROM ".TB_PREF."debtor_trans_details WHERE debtor_trans_no=trans.trans_no AND debtor_trans_type=trans.type) AS shipment_items, SUM(trans.ov_freight + trans.ov_freight_tax) AS transaction_freight, ship.shipper_name AS shipping_company, opt.column_value AS shipment_status_value FROM ".TB_PREF."shipments shipment";
	$sql .= " LEFT JOIN ".TB_PREF."debtor_trans trans ON trans.trans_no=shipment.trans_no AND shipment.type=trans.type LEFT JOIN ".TB_PREF."shippers ship ON ship.shipper_id=trans.ship_via LEFT JOIN ".TB_PREF."debtors_master debtor ON debtor.debtor_no=trans.debtor_no LEFT JOIN ".TB_PREF."options opt ON opt.option_id=shipment.shipment_status LEFT JOIN ".TB_PREF."voided AS vd ON trans.type=vd.type AND trans.trans_no=vd.id";
	$sql .= " WHERE shipment.shipment_id=".db_escape($shipment_id)." AND shipment.type=trans.type AND ISNULL(vd.id)";

	$result = db_query($sql,"could not get Shipment");
	return db_fetch($result);
}

function get_shipment_tracking($shipment_id)
{
	$sql = "SELECT shipment_tracking_no FROM ".TB_PREF."grade WHERE shipment_id=".db_escape($shipment_id);

	$result = db_query($sql, "could not get Shipment");

	$row = db_fetch_row($result);
	return $row[0];
}

function get_doc($row)
{
 $link = "/reporting/prn_redirect.php?";
 $link .= "PARAM_0=".$row["trans_no"]."-".$row["type"];
 $link .= "&PARAM_1=".$row["trans_no"]."-".$row["type"];
 $link .= "&PARAM_2=";
 $link .= "&PARAM_3=0";
 $link .= "&PARAM_4=&PARAM_5=&PARAM_6=";
 $link .= "&PARAM_7=0";
 $link .= "&REP_ID=107";
 return $link;
}

function get_trans($row)
{
$link = "/sales/view/view_sales_order.php?";
$link .= "trans_no=".$row["transaction_order"];
$link .= "&trans_type=30";
return $link;
}

function get_debtor($debtor_no)
{
$link = "/sales/manage/customers.php?";
$link .= "debtor_no=".$debtor_no;
$link .= "&popup=1";
return $link;
}

function get_units_dec($abbr)
{
	$sql = "SELECT decimals FROM ".TB_PREF."item_units WHERE abbr=".db_escape($abbr);

	$result = db_query($sql, "could not get unit decimal");

	$row = db_fetch_row($result);
	return $row[0];
}

function find_shipments($customer, $shipper, $status, $show_inactive=0)
{
	$sql = "SELECT shipment.*, trans.tran_date as transaction_date, trans.reference as transaction_reference, trans.ship_via AS shipment_via, trans.order_ AS transaction_order, concat(trans.trans_no, '-', trans.type) AS shipment_document, debtor.name AS debtor_name, debtor.debtor_no AS debtor_no, (SELECT count(*) FROM ".TB_PREF."debtor_trans_details WHERE debtor_trans_no=trans.trans_no AND debtor_trans_type=trans.type) AS shipment_items, SUM(trans.ov_freight + trans.ov_freight_tax) AS transaction_freight, ship.shipper_name AS shipping_company, opt.column_value AS shipment_status_value FROM ".TB_PREF."shipments shipment";
	$sql .= " LEFT JOIN ".TB_PREF."debtor_trans trans ON trans.trans_no=shipment.trans_no AND shipment.type=trans.type LEFT JOIN ".TB_PREF."shippers ship ON ship.shipper_id=trans.ship_via LEFT JOIN ".TB_PREF."debtors_master debtor ON debtor.debtor_no=trans.debtor_no LEFT JOIN ".TB_PREF."options opt ON opt.option_id=shipment.shipment_status LEFT JOIN ".TB_PREF."voided AS vd ON trans.type=vd.type AND trans.trans_no=vd.id";
	$sql .= " WHERE ISNULL(vd.id)";
	if (!$show_inactive) $sql .= " AND !shipment.inactive";
	$sql .= " GROUP BY shipment.shipment_id";
	return db_query($sql,"could not get Shipments");
}