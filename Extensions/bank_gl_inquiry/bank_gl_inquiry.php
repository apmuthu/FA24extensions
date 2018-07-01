<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
$page_security = 'SA_BANKTRANSVIEW';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/includes/banking.inc");

$js = "";
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(800, 500);
if (user_use_date_picker())
	$js .= get_js_date_picker();
$js .= get_js_history(array('bank_account', 'TransAfterDate', 'TransToDate'));
page(_($help_context = "Bank Account G/L Inquiry"), isset($_GET['bank_account']) && !isset($_GET['TransAfterDate']), false, "", $js, false, "", true);

check_db_has_bank_accounts(_("There are no bank accounts defined in the system."));

//-----------------------------------------------------------------------------------
// Ajax updates
//
if (get_post('Show'))
{
	$Ajax->activate('trans_tbl');
}

set_posts(array('bank_account', 'TransAfterDate', 'TransToDate'));
//------------------------------------------------------------------------------------------------

if (isset($_GET['message']))
{
    display_notification_centered($_GET['message']);
}

function gl_link($account, $name)
{
    global $path_to_root;
    $search_link = "/gl/inquiry/gl_account_inquiry.php?account=$account";
    $img_title = "General Ledger Search";
    $from_date = get_post("TransAfterDate");
    $to_date = get_post("TransToDate");

    if ($from_date != "") {
        $search_link .= "&TransAfterDate=$from_date";
        if ($to_date == "")
            $to_date = Today();
        $search_link .= "&TransToDate=$to_date";
    }

    $theme = user_theme();
    $img = '<img src="'.$path_to_root.'/themes/'.$theme.'/images/'.ICON_VIEW.
        '" style="vertical-align:middle;width:12px;height:12px;border:0;" onclick="javascript:lookupWindow(&quot;'.
        $path_to_root.$search_link.'&quot;, &quot;&quot;);" title="' . $img_title . '" style="cursor:pointer;" />';

    return $name . " " . $img;
}

start_form();
start_table(TABLESTYLE_NOBORDER);
start_row();
bank_accounts_list_cells(_("Account:"), 'bank_account', null, true);

$days = user_transaction_days();
date_cells(_("From:"), 'TransAfterDate', '', null, -abs($days));
if ($days >= 0) {
    date_cells(_("To:"), 'TransToDate');
} else {
    date_cells(_("To:"), 'TransToDate', '', null, 0, 2);
}

submit_cells('Show',_("Show"),'','', 'default');
end_row();
end_table();
end_form();

//------------------------------------------------------------------------------------------------

if (!isset($_POST['bank_account']))
	$_POST['bank_account'] = "";

$result = get_bank_trans_for_bank_account($_POST['bank_account'], $_POST['TransAfterDate'], $_POST['TransToDate']);	

$act = get_bank_account($_POST["bank_account"]);
display_heading($act['bank_account_name']." - ".$act['bank_curr_code']);

div_start('trans_tbl');
start_table(TABLESTYLE);

$th = array(_("Type"), _("#"), _("Reference"), _("Date"),
	_("Debit"), _("Credit"), _("Balance"), _("Person/Item"), _("Memo"), _("X"), "", "", "");
table_header($th);

$bfw = get_balance_before_for_bank_account($_POST['bank_account'], $_POST['TransAfterDate']);

$credit = $debit = 0;
start_row("class='inquirybg' style='font-weight:bold'");
label_cell(_("Opening Balance")." - ".$_POST['TransAfterDate'], "colspan=4");
display_debit_or_credit_cells($bfw);
label_cell("");
label_cell("", "colspan=4");

end_row();
$running_total = $bfw;
if ($bfw > 0 ) 
	$debit += $bfw;
else 
	$credit += $bfw;
$j = 1;
$k = 0; //row colour counter
$dim = get_company_pref('use_dimension');

while ($myrow = db_fetch($result))
{

	alt_table_row_color($k);
	$running_total += $myrow["amount"];

	$trandate = sql2date($myrow["trans_date"]);
	label_cell($systypes_array[$myrow["type"]]);
	label_cell(get_trans_view_str($myrow["type"],$myrow["trans_no"]));
	label_cell(get_trans_view_str($myrow["type"],$myrow["trans_no"],$myrow['ref']));
	label_cell($trandate);
	display_debit_or_credit_cells($myrow["amount"]);
	amount_cell($running_total);

	label_cell(payment_person_name_link($myrow["person_type_id"],$myrow["person_id"], true, get_post("TransAfterDate"),get_post("TransToDate")));

	label_cell(get_comments_string($myrow["type"], $myrow["trans_no"]));
    label_cell(empty($myrow["reconciled"]) ? "" : "X");
	label_cell(get_gl_view_str($myrow["type"], $myrow["trans_no"]));

	label_cell(trans_editor_link($myrow["type"], $myrow["trans_no"]));
        label_cell(pager_link(_("Delete"), "/admin/void_transaction.php?trans_no=" . $myrow['trans_no'] . "&filterType=". $myrow['type'], ICON_DELETE));

	end_row();
 	if ($myrow["amount"] > 0 ) 
 		$debit += $myrow["amount"];
 	else 
 		$credit += $myrow["amount"];

    $gl_result = get_gl_trans($myrow['type'], $myrow['trans_no']);
    while ($myrow = db_fetch($gl_result))
    {
        if ($myrow['amount'] == 0) continue;
        if ($myrow['account'] == $act['account_code']) continue;
        alt_table_row_color($k);
        end_row();
        alt_table_row_color($k);
        label_cell("", "colspan=2");
        if ($dim >= 1)
            label_cell(get_dimension_string($myrow['dimension_id'], true), "colspan=2");
        if ($dim > 1)
            label_cell(get_dimension_string($myrow['dimension2_id'], true));

        display_debit_or_credit_cells($myrow["amount"]);
        label_cell("");
        label_cell(gl_link($myrow['account'], $myrow['account_name']));

        label_cell($myrow['memo_']);
        label_cell("", "colspan=4");
        end_row();
    }

	if ($j == 12)
	{
		$j = 1;
		table_header($th);
	}
	$j++;
}
//end of while loop

start_row("class='inquirybg' style='font-weight:bold'");
label_cell(_("Ending Balance")." - ". $_POST['TransToDate'], "colspan=4");
amount_cell($debit);
amount_cell(-$credit);
//display_debit_or_credit_cells($running_total);
amount_cell($debit+$credit);
hyperlink_params_td("$path_to_root/gl/gl_bank.php", _("Enter Another &Payment"), "NewPayment=yes&bank_account=".$_POST['bank_account']);
hyperlink_params_td("$path_to_root/gl/gl_bank.php", _("Enter A &Deposit"), "NewDeposit=yes&bank_account=".$_POST['bank_account']);

label_cell("", "colspan=3");
end_row();
end_table();
div_end();
scroll_down("trans_tbl");
set_browser_title("bank_account");

//------------------------------------------------------------------------------------------------

end_page(true);

