<?php
global $reports;
unset($reports->ar_reports[RC_CUSTOMER][108]); // unset built-in statements

$reports->addReport(RC_CUSTOMER, '_cust_statement', _('Print &Statements'),
    array(  _('Start Date') => 'DATEBEGIN',
            _('Customer') => 'CUSTOMERS_NO_FILTER',
            _('Currency Filter') => 'CURRENCY',
            _('Show Also Allocated') => 'YES_NO',
            _('Email Customers') => 'YES_NO',
            _('Comments') => 'TEXTBOX',
            _('Orientation') => 'ORIENTATION'));

?>
