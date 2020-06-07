<?php
// include_once($path_to_root . "/includes/ui/ui_lists.inc");


global $reports, $dim;

$reports->addReport(RC_CUSTOMER, "_dr0442",_('&Colorado DR0442 Excise Tax Form'),
    array(  _('Period (YYYY-MM)') => 'TEXT',
         _('Beginning inventory from prior report (leave blank)') => 'TEXT',
         _('Manufactured liters (leave blank)') => 'TEXT',
         _('Grape tons') => 'TEXT',
));
?>
