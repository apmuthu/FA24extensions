<?php
global $reports;
unset($reports->ar_reports[RC_CUSTOMER][116]); // unset built-in statements

$reports->addReport(RC_CUSTOMER, '_route_deliveries', _('&Route Deliveries'),
	array(	_('From') => 'DATE',
			_('To') => 'DATE',
			_('email Customers') => 'YES_NO',
			_('Print as Packing Slip') => 'YES_NO',
	  _('Route Deliveries') => 'YES_NO',
	  _('Remove Home Location') => 'YES_NO',
	  _('Route Linear, Not Roundtrip') => 'YES_NO',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION',));
	  //requires modified functions in core, was submitted to github repo
#	  _('Shipper') => 'SHIPPERS_NO_FILTER', 


?>
