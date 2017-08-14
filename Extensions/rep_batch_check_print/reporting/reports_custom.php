<?php
// include_once($path_to_root . "/includes/ui/ui_lists.inc");


global $reports, $dim;

function check_end($param, $type)
{
    if ($type == 'CHECK_END')
        return "<input type=\"number\" name=\"$param\" min=1 max=999999>";
}
$reports->register_controls("check_end");

function check_start($param, $type)
{
    if ($type == 'CHECK_START')
        return "<input type=\"number\" name=\"$param\" min=1 max=999999>";
}
$reports->register_controls("check_start");

function check_replace($param, $type)
{
    if ($type == 'CHECK_REPLACE')
        return "<input class='text' type=\"text\" name=\"$param\" size=6 maxlength=6 value='@@@@'>";
}
$reports->register_controls("check_replace");

function check_style($param, $type)
{
    if ($type == 'CHECK_STYLE')
        return yesno_list($param, "1-Up", "3-Up", "1-Up");
}
$reports->register_controls("check_style");

$reports->addReport(RC_BANKING, "_batch_check_print",_('&Batch Check Printing'),
    array(  _('Accounts') => 'BANK_ACCOUNTS',
            _('Checks Per Page') => 'CHECK_STYLE',
            _('Starting Check Number') => 'CHECK_START',
            _('Ending Check Number<br>(Leave blank for no limit)') => 'CHECK_END',
            _('Check Replacement String In Comments
<br><a href="javascript:void(0);" onclick="popup=window.open(\'../modules/rep_batch_check_print/moreinfo.html\',\'popupWindow\',\'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width=600,height=550,top=50,left=100\')">(More Info)</a>
') => 'CHECK_REPLACE',
            _('Update Check Numbers') => 'YES_NO',
            _('Destination') => 'DESTINATION'
));
?>
