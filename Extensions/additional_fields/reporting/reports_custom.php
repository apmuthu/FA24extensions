<?php
define('RC_ADD', 8);


global $reports, $dim;
$reports->addReportClass(_('Addfields'), RC_ADD);


$reports->addReport(RC_INVENTORY, 1303, _('Stock &Check Sheets with Bin Locations'),
	array(	_('Inventory Category') => 'CATEGORIES',
			_('Location') => 'LOCATIONS',
			_('Show Pictures') => 'YES_NO',
			_('Inventory Column') => 'YES_NO',
			_('Show Shortage') => 'YES_NO',
			_('Suppress Zeros') => 'YES_NO',
			_('Item Like') => 'TEXT',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION',
			_('Destination') => 'DESTINATION'));
$reports->addReport(RC_CUSTOMER, "_customer_details_complete_excel", _('Customer Additional Information Listing'),
	array(	_('<div class=warn_msg><b>Excel download only</b></div><br>Comments') => 'TEXTBOX'));
$reports->addReport(RC_SUPPLIER, "_supplier_details_complete_excel", _('Supplier Additional Information Listing'),
	array(	_('<div class=warn_msg><b>Excel download only</b></div><br>Comments') => 'TEXTBOX'));
$reports->addReport(RC_INVENTORY, "_item_details_complete_excel", _('Item Additional Information Listing'),
	array(	_('<div class=warn_msg><b>Excel download only</b></div><br>Comments') => 'TEXTBOX'));
