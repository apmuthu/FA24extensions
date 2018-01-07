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

function bank_payments($param, $type)
{
    if ($type == 'BANK_PAYMENTS') {
        $sql = "SELECT child.trans_no, concat(child.trans_no, ': ', child.person_id, ' (', child.amount, ')')  as IName FROM ".TB_PREF."bank_trans AS child, (select max(id) AS maxid FROM ".TB_PREF."comments WHERE (type = " . ST_BANKPAYMENT . " OR type = " . ST_SUPPAYMENT . ") AND memo_ REGEXP '\[[0-9]+\]$') AS parent WHERE (child.type = " . ST_BANKPAYMENT . " OR child.type = " . ST_SUPPAYMENT . ") AND child.trans_no > parent.maxid";
        return combo_input($param, '', $sql, 'order_no', 'IName',array('order'=>false));
    }
}
$reports->register_controls("bank_payments");


function check_style($param, $type)
{
    if ($type == 'CHECK_STYLE')
        return yesno_list($param, "1-Up", "3-Up", "1-Up");
}
$reports->register_controls("check_style");

$reports->addReport(RC_BANKING, "_batch_check_print",_('&Batch Check Printing'),
    array(  _('Accounts') => 'BANK_ACCOUNTS',
            _('Checks Per Page') => 'CHECK_STYLE',
            _('Starting Bank Payment
<br><a href="javascript:void(0);" onclick="popup=window.open(\'../modules/rep_batch_check_print/moreinfo.html\',\'popupWindow\',\'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width=600,height=550,top=50,left=100\')">(More Info)</a>
') => 'BANK_PAYMENTS',
            _('Starting Check Number') => 'CHECK_START',
            _('Ending Check Number<br>(Leave blank for no limit)') => 'CHECK_END',
            _('Update Check Numbers') => 'YES_NO',
            _('Destination') => 'DESTINATION'
));
?>
