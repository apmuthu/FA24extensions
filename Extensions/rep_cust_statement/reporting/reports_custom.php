<?php
$reports->addReport(RC_CUSTOMER, '_cust_statement', _('Print Enhanced &Statements'),
    array(  _('Customer') => 'CUSTOMERS_NO_FILTER',
            _('Currency Filter') => 'CURRENCY',
            _('Show Also Allocated') => 'YES_NO',
            _('Email Customers') => 'YES_NO',
            _('Comments') => 'TEXTBOX',
            _('Orientation') => 'ORIENTATION'));

?>
