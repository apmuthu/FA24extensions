<?php

global $reports;


$reports->addReport(RC_CUSTOMER, "_customer_ledger", _('Customer &Ledger'),
	array(	_('Start Date') => 'DATEBEGIN',
			_('End Date') => 'DATEENDM',
			_('Customer') => 'CUSTOMERS_NO_FILTER',
			_('Sales Areas') => 'AREAS',
			_('Sales Folk') => 'SALESMEN',
			_('Show Balance') => 'YES_NO',
			_('Currency Filter') => 'CURRENCY',
			_('Suppress Zeros') => 'YES_NO',
			_('Hide Trans') => 'YES_NO',
			_('Only Recovery') => 'YES_NO',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION',
			_('Destination') => 'DESTINATION'));

?>
