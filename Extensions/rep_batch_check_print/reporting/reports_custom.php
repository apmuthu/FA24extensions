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
    if ($type == 'CHECK_START') {

// find the last computer printed check
        $sql = "SELECT memo_ FROM ".TB_PREF."bank_trans bt LEFT JOIN " .TB_PREF."comments c ON bt.trans_no=c.id AND bt.type=c.type  WHERE (bt.type = " . ST_BANKPAYMENT . " OR bt.type = " . ST_SUPPAYMENT . ") AND memo_ REGEXP '\[[0-9]+\]$' ORDER BY bt.id DESC LIMIT 1";
        $result = db_query($sql, "The check number cannot be retrieved");
        $row = db_fetch($result);
        $checkno='';
        if ($row != 0) {
            $checkno = substr($row['memo_'], strpos($row['memo_'], '[')+1, -1);
            $checkno++;
        }

        return "<input type=\"number\" name=\"$param\" min=1 max=999999 value=\"$checkno\">";
    }
}
$reports->register_controls("check_start");

function bank_payments($param, $type)
{
    if ($type == 'BANK_PAYMENTS') {

// find all the supplier and bank payments after the last
// computer printed check

        $sql = "SELECT child.id, concat(child.id, ': ', child.person_id, ' (', child.amount, ')')  as IName FROM ".TB_PREF."bank_trans AS child, (select max(bt.id) AS maxid FROM ".TB_PREF."bank_trans bt LEFT JOIN " .TB_PREF."comments c ON bt.trans_no=c.id AND bt.type=c.type  WHERE (bt.type = " . ST_BANKPAYMENT . " OR bt.type = " . ST_SUPPAYMENT . ") AND memo_ REGEXP '\[[0-9]+\]$') AS parent WHERE (child.type = " . ST_BANKPAYMENT . " OR child.type = " . ST_SUPPAYMENT . ") AND (ISNULL(parent.maxid) OR  child.id > parent.maxid) ORDER BY child.id";
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
