<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/

$page_security = 'PULSE_TRACKING';
$path_to_root = "../../..";
include($path_to_root . "/includes/session.inc");

$js = "";
if (user_use_date_picker())
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/ui_controls.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/modules/shipment_tracking/includes/db/tracking_db.inc");
include_once($path_to_root . "/modules/shipment_tracking/includes/ui/tracking_ui.inc");

add_access_extensions();
page(_($help_context = "Shipment Tracking"));

simple_page_mode(true);


if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	$input_error = 0;

	if (strlen($_POST['shipment_tracking_no']) == 0) 
	{
		$input_error = 1;
		display_error(_("Shipment tracking number cannot be empty."));
		set_focus('shipment_tracking_no');
	}
	if(strlen($_POST['shipment_vehicle_no']) == 0) {
	    $_POST['shipment_vehicle_no'] = '--';
	}
	if(strlen($_POST['shipment_eway_bill']) == 0) {
	    $_POST['shipment_eway_bill'] = '--';
	}
	if(strlen($_POST['shipment_package']) == 0) {
	    $_POST['shipment_package'] = number_format(0,get_units_dec($_POST['abbr']));
	} else if($_POST['shipment_package'] === 0) {
	    $_POST['shipment_package'] = number_format(0,get_units_dec($_POST['abbr']));
	} else {
	    $_POST['shipment_package'] = number_format($_POST['shipment_package'],get_units_dec($_POST['abbr']));
	}
	
	if(strlen($_POST['shipment_freight']) == 0) {
	    $_POST['shipment_freight'] = price_format(0);
	} else {
	    $_POST['shipment_freight'] = price_format($_POST['shipment_freight']);
	}
	
	if ($input_error != 1)
	{
    	if ($selected_id != -1) 
    	{
    		update_shipment($selected_id,$_POST["shipment_document"],$_POST["shipment_via"],$_POST["shipment_date"],$_POST["shipment_tracking_no"],$_POST["shipment_vehicle_no"],$_POST["shipment_eway_bill"],$_POST["shipment_package"],$_POST["abbr"],$_POST["shipment_freight"],$_POST["shipment_status"]);
    		
			$note = _('Selected shipment tracking has been updated');
    	} 
    	else 
    	{
    		add_shipment($_POST["shipment_document"],$_POST["shipment_via"],$_POST["shipment_date"],$_POST["shipment_tracking_no"],$_POST["shipment_vehicle_no"],$_POST["shipment_eway_bill"],$_POST["shipment_package"],$_POST["abbr"],$_POST["shipment_freight"],$_POST["shipment_status"]);
    		
			$note = _('New shipment tracking has been added');
    	}
    
		display_notification($note);    	
		$Mode = 'RESET';
	}
} 

if ($Mode == 'Delete')
{

	$cancel_delete = 0;

	if ($cancel_delete == 0) 
	{
		delete_shipment($selected_id);
		display_notification(_('Selected shipment tracking has been deleted'));
	}
	
	$Mode = 'RESET';
} 

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}

//-------------------------------------------------------------------------------------------------

$result = get_shipments(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width='99%'");

$th = array(_("Customer"),_("Date"), _("#"), _("Reference"), _("Shipping Company"), _("Shipping Date"), _("Tracking"), _("Vehicle"), _("Eway Bill"), _("Items"), _("Packages"), _("UOM"), _("Charged"), _("Paid"), _("Status"), "", "");
inactive_control_column($th);

table_header($th);
$k = 0; 

    while ($myrow = db_fetch($result)) 
    {   $trans_link = get_trans($myrow);
    	$doc_link = get_doc($myrow);
    	$debtor_link = get_debtor($myrow["debtor_no"]);
    	alt_table_row_color($k);
    	label_cell(viewer_link($myrow["debtor_name"], $debtor_link, '', '', null));
    	label_cell(sql2date($myrow["transaction_date"]));
    	label_cell("<a href='".$trans_link."' target='_blank'>".$myrow["transaction_order"]."</a>");
    	label_cell("<a href='".$doc_link."' target='_blank' class='printlink'>".$myrow["transaction_reference"]."</a>");
    	label_cell($myrow["shipping_company"]);
    	label_cell(sql2date($myrow["shipment_date"]));
    	label_cell($myrow["shipment_tracking_no"]);
    	label_cell($myrow["shipment_vehicle_no"]);
    	label_cell($myrow["shipment_eway_bill"]);
    	label_cell($myrow["shipment_items"]);
    	label_cell(number_format($myrow["shipment_package"],get_units_dec($myrow['abbr'])));
    	label_cell($myrow["abbr"]);
    	label_cell(price_format($myrow["transaction_freight"]));
    	label_cell(price_format($myrow["shipment_freight"]));
    	label_cell($myrow["shipment_status_value"]);
    	inactive_control_cell($myrow["shipment_id"], $myrow["inactive"], 'shipments', 'shipment_id');
    
     	edit_button_cell("Edit".$myrow["shipment_id"], _("Edit"));
     	delete_button_cell("Delete".$myrow["shipment_id"], _("Delete"));
    	end_row();
    }
inactive_control_row($th);
end_table();
echo '<br>';

//-------------------------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing garden
		$myrow = get_shipment($selected_id);
		if(isset($myrow['shipment_id']))
        $_POST['shipment_via'] = $myrow["shipment_via"];
        $_POST['shipment_document'] = $myrow["shipment_document"];
		$_POST['shipment_date']  = sql2date($myrow["shipment_date"]);
		$_POST['shipment_tracking_no']  = $myrow["shipment_tracking_no"];
		$_POST['shipment_vehicle_no']  = $myrow["shipment_vehicle_no"];
		$_POST['shipment_eway_bill']  = $myrow["shipment_eway_bill"];
		$_POST['shipment_package']  = number_format($myrow["shipment_package"],get_units_dec($myrow['abbr']));
		$_POST['abbr']  = $myrow["abbr"];
		$_POST['shipment_status']  = $myrow["shipment_status"];
		$_POST['shipment_freight'] = price_format($myrow["shipment_freight"]);
	}
	hidden("selected_id", $selected_id);
} 

invoice_list_row(_("Invoice:"), 'shipment_document');
shipper_list_row(_("Shipping Company:"), 'shipment_via');
date_row(_("Shipment Date") . ":", 'shipment_date', '', false);
text_row_ex(_("Tracking Number:"), 'shipment_tracking_no', 30);
text_row_ex(_("Vehicle No:"), 'shipment_vehicle_no', 30);
text_row_ex(_("Eway Bill:"), 'shipment_eway_bill', 30);
text_row_ex(_("Packages:"), 'shipment_package', 30);
uom_list_row(_("Unit Of Measure:"), 'abbr');
text_row_ex(_("Freight Paid:"), 'shipment_freight', 30);
status_list_row(_("Status:"), 'shipment_status');

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();
