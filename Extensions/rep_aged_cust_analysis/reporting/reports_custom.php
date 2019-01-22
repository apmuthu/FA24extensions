<?php
global $reports;
unset($reports->ar_reports[RC_CUSTOMER][102]); // unset built-in

$reports->addReport(RC_CUSTOMER, "_aged_cust_analysis", _('&Aged Customer Analysis'),
    array(  _('Start Date') => 'DATEBEGIN',
            _('End Date') => 'DATEEND',
            _('Customer') => 'CUSTOMERS_NO_FILTER',
            _('Currency Filter') => 'CURRENCY',
            _('Show Also Allocated') => 'YES_NO',
            _('Summary Only') => 'YES_NO',
            _('Suppress Zeros') => 'YES_NO',
            _('Graphics') => 'GRAPHIC',
            _('Comments') => 'TEXTBOX',
            _('Orientation') => 'ORIENTATION',
            _('Destination') => 'DESTINATION'));

?>
