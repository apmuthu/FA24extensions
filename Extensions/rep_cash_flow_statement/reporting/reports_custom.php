<?php

global $reports;

$dim = get_company_pref('use_dimension');

if ( $dim == 2 ) {
    $reports->addReport(RC_BANKING,"_cash_flow_statement",_('Cash Flow Statement'),
        array(  _('Report Period') => 'DATEENDM',
                _('Dimension') => 'DIMENSIONS1',
                _('Dimension 2') => 'DIMENSIONS2',
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
} elseif ( $dim == 1 ) {
    $reports->addReport(RC_BANKING,"_cash_flow_statement",_('Cash Flow Statement'),
        array(  _('Report Period') => 'DATEENDM',
                _('Bank Account') => 'BANK_ACCOUNTS_NO_FILTER',
                _('Dimension') => 'DIMENSIONS1',
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
} else {
    $reports->addReport(RC_BANKING,"_cash_flow_statement",_('Cash Flow Statement'),
        array(  _('Report Period') => 'DATEENDM',
                _('Bank Account') => 'BANK_ACCOUNTS_NO_FILTER',                    
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
}
