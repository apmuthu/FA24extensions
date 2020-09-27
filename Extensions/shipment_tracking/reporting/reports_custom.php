<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/

define('IMPULSE_REP_SHIPMENT_TRACKING', 8);
global $reports, $dim;

$reports->addReport(RC_CUSTOMER, '_shipment_tracking', _('Shipment Tracking'),
	array(	_('Customer') => 'CUSTOMERS_NO_FILTER',
			_('Shipping Company') => 'SHIPPER',
			_('Comments') => 'TEXTBOX',
			_('Status') => 'SHIPMENTSTATUS',
			_('Destination') => 'DESTINATION',
			_('Orientation') => 'ORIENTATION'
));

function shipper_list($name, $type) {
	if($type == 'SHIPPER')
	return combo_input($name, '', "SELECT * FROM ".TB_PREF."shippers WHERE !inactive", 'shipper_id', 'shipper_name',array('order'=>true));
}

$reports->register_controls('shipper_list');

function shipment_status_list($name, $type) {
	if($type == 'SHIPMENTSTATUS')
	return combo_input($name, '', "SELECT option_id, column_value AS shipment_status FROM ".TB_PREF."options WHERE table_name='shipments' AND column_name='shipment_status' AND !inactive", 'option_id', 'shipment_status',array('order'=>false));
}

$reports->register_controls('shipment_status_list');