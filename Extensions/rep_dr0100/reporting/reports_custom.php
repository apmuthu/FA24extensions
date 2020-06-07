<?php
// include_once($path_to_root . "/includes/ui/ui_lists.inc");


global $reports, $dim;

$reports->addReport(RC_CUSTOMER, "_dr0100",_('&Colorado DR0100 Sales Tax Form'),
    array(  _('Period (YYYY-MM)') => 'TEXT',
        ('DR0098 Only') => 'YES_NO',
));
?>
