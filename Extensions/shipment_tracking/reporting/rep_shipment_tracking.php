<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/
$page_security = 'SA_ITEMSVALREP';

$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/modules/shipment_tracking/includes/db/tracking_db.inc");

//----------------------------------------------------------------------------------------------------

    global $path_to_root, $SysPrefs;

	$customer = $_POST['PARAM_0'];
    $shipper = $_POST['PARAM_1'];
    $comments = $_POST['PARAM_2'];
    $status = $_POST['PARAM_3'];
    $destination = $_POST['PARAM_4'];
	$orientation = $_POST['PARAM_5'];

	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

    $dec = user_price_dec();

	$orientation = ($orientation ? 'L' : 'P');


	$cols = array(0, 130, 200, 320, 380, 460);

	$headers = array(_('Customer'), _('Reference'), _('Shipping Company'),  _('Date'), _('Tracking'), _('Status'));

	$aligns = array('left',	'left',	'left',	'left', 'left', 'left');

    $params =   array( 	0 => $comments,
    					1 => array('text' => _('Customer'), 'from' => $customer, 		'to' => ''),
    				    2 => array('text' => _('Shipping Company'), 'from' => $shipper, 'to' => ''),
    				    3 => array('text' => _('Status'), 'from' => $status, 'to' => ''));

    $rep = new FrontReport(_('Shipping Tracking Report'), "ShippingTrackingReport", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);
    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$shipments = find_shipments($customer, $shipper, $status);
	$serial = 1;

	$rep->NewLine(-1);
	while ($shipment=db_fetch($shipments))
	{
			$rep->NewLine();
			$rep->TextCol(0, 1, trim($shipment['debtor_name']));
			$rep->TextCol(1, 2, trim($shipment['transaction_reference']));
			$rep->TextCol(2, 3, trim($shipment['shipping_company']));
			$rep->TextCol(3, 4, sql2date($shipment['shipment_date']));
			$rep->TextCol(4, 5, trim($shipment['shipment_tracking_no']));
			$rep->TextCol(5, 6, trim($shipment['shipment_status_value']));
            $serial++;
	}
	$rep->NewLine();
    $rep->End();


