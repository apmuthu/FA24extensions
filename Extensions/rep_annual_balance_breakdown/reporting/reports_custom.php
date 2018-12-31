<?php

global $reports, $dim;

// $dim = get_company_pref('use_dimension');

if ($dim == 2) {
    $reports->addReport(RC_GL,"_annual_balance_breakdown",_('Annual &Balance Breakdown - Detailed'),
        array(  _('Report Period') => 'DATEENDM',
                _('Dimension') => 'DIMENSIONS1',
                _('Dimension 2') => 'DIMENSIONS2',
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
} elseif ($dim == 1) {
    $reports->addReport(RC_GL,"_annual_balance_breakdown",_('Annual &Balance Breakdown - Detailed'),
        array(  _('Report Period') => 'DATEENDM',
                _('Dimension') => 'DIMENSIONS1',
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
} else {
    $reports->addReport(RC_GL,"_annual_balance_breakdown",_('Annual &Balance Breakdown - Detailed'),
        array(  _('Report Period') => 'DATEENDM',                      
                _('Comments') => 'TEXTBOX',
                _('Destination') => 'DESTINATION'));
}
