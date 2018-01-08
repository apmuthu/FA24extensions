<?php
// include_once($path_to_root . "/includes/ui/ui_lists.inc");


global $reports, $dim;

function bank_sweep($param, $type)
{
    if ($type == 'BANK_SWEEP') {
        return bank_accounts_list($param, 9999, false, "-- No Sweep --");
    }
}
$reports->register_controls("bank_sweep");



$reports->addReport(RC_BANKING, "_bank_daily_sweep",_('&Bank Daily Summary w/Sweep'),
        array(  _('Bank Accounts') => 'BANK_ACCOUNTS',
                        _('Start Date') => 'DATEBEGINM',
                        _('End Date') => 'DATEENDM',
                        _('Zero values') => 'YES_NO',
                        _('Sweep To Bank Account') => 'BANK_SWEEP',
                        _('Comments') => 'TEXTBOX',
                        _('Orientation') => 'ORIENTATION',
                        _('Destination') => 'DESTINATION'));

?>
