<?php

global $reports;
unset($reports->ar_reports[RC_CUSTOMER][116]); // unset built-in statements

function route_shippers_list($name, $selected_id = null, $spec_option = false) {
    $sql = "SELECT shipper_id, shipper_name, inactive FROM ".TB_PREF."shippers";
    return combo_input($name, $selected_id, $sql, 'shipper_id', 'shipper_name', 
        array(
            'order' => array('shipper_name'),
            'spec_option' => $spec_option === true ? _("All Shippers") : $spec_option,
        )
    );
}

// Register the custom ROUTE_SHIPPERS_NO_FILTER control
function route_shippers($name, $type) {
    if ($type == 'ROUTE_SHIPPERS_NO_FILTER') {
        return route_shippers_list($name, null, _('All Shippers'));
    }
}

$reports->register_controls('route_shippers');

$reports->addReport(RC_CUSTOMER, '_route_deliveries', _('&Route Deliveries'),
	array(	_('From') => 'DATE',
			_('To') => 'DATE',
			_('email Customers') => 'YES_NO',
			_('Print as Packing Slip') => 'YES_NO',
      _('Shipper') => 'ROUTE_SHIPPERS_NO_FILTER', 
      _('Route Deliveries') => 'YES_NO',
      _('Remove Home Location') => 'YES_NO',
      _('Route Linear, Not Roundtrip') => 'YES_NO',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION'));

