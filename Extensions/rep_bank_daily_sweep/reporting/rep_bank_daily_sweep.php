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
$page_security = 'SA_BANKREP';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Bank Accounts Transactions
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");

//----------------------------------------------------------------------------------------------------

print_bank_transactions_daily();

//----------------------------------------------------------------------------------------------------

function get_bank_balance_to($to, $account)
{
	$to = date2sql($to);
	$sql = "SELECT SUM(amount) FROM ".TB_PREF."bank_trans WHERE bank_act='$account'
	AND trans_date < '$to'";
	$result = db_query($sql, "The starting balance on hand could not be calculated");
	$row = db_fetch_row($result);
	return $row[0];
}

function get_bank_transactions($from, $to, $account)
{
	$from = date2sql($from);
	$to = date2sql($to);
	$sql = "SELECT * FROM ".TB_PREF."bank_trans
		WHERE bank_act = '$account'
		AND trans_date >= '$from'
		AND trans_date <= '$to'
		ORDER BY trans_date, id";

	return db_query($sql,"The transactions for '$account' could not be retrieved");
}

function sweep($acc, $act, $sweep, $rep, $total_daily, $dec, $lastdate, $comments)
{
    global $Refs;

    $rep->DateCol(3, 4,	$lastdate, true);
    $rep->TextCol(4, 6, _("Total"));
    $rep->AmountCol(7, 8, $total_daily, $dec);
    $rep->NewLine(2);

    $total_daily = round($total_daily, $dec);
    if ($sweep != '' && $total_daily != 0) {
        new_doc_date($lastdate);
        $trans_no = add_bank_transfer($acc, $sweep, sql2date($lastdate), $total_daily, $Refs->get_next(ST_BANKTRANSFER, null, sql2date($lastdate)), "Sweep" . $comments, 0, $total_daily);

        display_notification("Swept $lastdate $total_daily");
    }
}

function print_bank_transactions_daily()
{
	global $path_to_root, $systypes_array;

	$acc = $_POST['PARAM_0'];
	$from = $_POST['PARAM_1'];
	$to = $_POST['PARAM_2'];
	$zero = $_POST['PARAM_3'];
	$sweep = $_POST['PARAM_4'];
	$comments = $_POST['PARAM_5'];
	$orientation = $_POST['PARAM_6'];
	$destination = $_POST['PARAM_7'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$orientation = ($orientation ? 'L' : 'P');
	$rep = new FrontReport(_('Bank Statement'), "BankStatement", user_pagesize(), 9, $orientation);
	$dec = user_price_dec();

	$cols = array(0, 90, 120, 170, 225, 350, 400, 460, 520);

	$aligns = array('left',	'left',	'left',	'left',	'left',	'right', 'right', 'right');

	$headers = array(_('Type'),	_('#'),	_('Reference'), _('Date'), _('Person/Item'),
		_('Debit'),	_('Credit'), _('Balance'));

	$account = get_bank_account($acc);
	$act = $account['bank_account_name']." - ".$account['bank_curr_code']." - ".$account['bank_account_number'];
   	$params =   array( 	0 => $comments,
	    1 => array('text' => _('Period'), 'from' => $from, 'to' => $to),
	    2 => array('text' => _('Bank Account'),'from' => $act,'to' => ''));

    if ($orientation == 'L')
    	recalculate_cols($cols);
	$rep->Font();
	$rep->Info($params, $cols, $headers, $aligns);
	$rep->NewPage();


	$prev_balance = get_bank_balance_to($from, $account["id"]);

	$trans = get_bank_transactions($from, $to, $account['id']);

	$rows = db_num_rows($trans);
	if ($prev_balance != 0.0 || $rows != 0)
	{
		$rep->Font('bold');
		$rep->TextCol(0, 3,	$act);
		$rep->TextCol(3, 5, _('Opening Balance'));
		if ($prev_balance > 0.0)
			$rep->AmountCol(5, 6, abs($prev_balance), $dec);
		else
			$rep->AmountCol(6, 7, abs($prev_balance), $dec);
		$rep->Font();
		$total = $prev_balance;
		$rep->NewLine(2);
		$total_debit = $total_credit = 0;
        $total_daily = 0;
        $lastdate = "";
        $comment_line = "";
		if ($rows > 0)
		{
			// Keep a running total as we loop through
			// the transactions.
			
			while ($myrow=db_fetch($trans))
			{
				if ($zero == 0 && $myrow['amount'] == 0.0)
					continue;
                if ($lastdate != ''
                    && $lastdate != $myrow['trans_date']) {
                        sweep($acc, $act, $sweep, $rep, $total_daily, $dec, $lastdate, $comment_line);
                        $total_daily = 0;
                        $comment_line = "";
                }
                $lastdate = $myrow['trans_date'];
				$total_daily += $myrow['amount'];

				$total += $myrow['amount'];

				$rep->TextCol(0, 1, $systypes_array[$myrow["type"]]);
				$rep->TextCol(1, 2,	$myrow['trans_no']);
				$rep->TextCol(2, 3,	$myrow['ref']);
				$rep->DateCol(3, 4,	$myrow["trans_date"], true);
				$name = get_counterparty_name($myrow["type"], $myrow["trans_no"], false);
                if ($name != "" && strpos($comment_line, $name) === false)
                    $comment_line .= " " . $name;
				$rep->TextCol(4, 5,	$name);
				if ($myrow['amount'] > 0.0)
				{
					$rep->AmountCol(5, 6, abs($myrow['amount']), $dec);
					$total_debit += abs($myrow['amount']);
				}
				else
				{
					$rep->AmountCol(6, 7, abs($myrow['amount']), $dec);
					$total_credit += abs($myrow['amount']);
				}
				$rep->AmountCol(7, 8, $total, $dec);
				$rep->NewLine();
				if ($rep->row < $rep->bottomMargin + $rep->lineHeight)
				{
					$rep->Line($rep->row - 2);
					$rep->NewPage();
				}
			}
			$rep->NewLine();

            sweep($acc, $act, $sweep, $rep, $total_daily, $dec, $lastdate, $comment_line);
		}
	

		// Print totals for the debit and credit columns.
		$rep->TextCol(3, 5, _("Total Debit / Credit"));
		$rep->AmountCol(5, 6, $total_debit, $dec);
		$rep->AmountCol(6, 7, $total_credit, $dec);
		$rep->NewLine(2);

		$rep->Font('bold');
		$rep->TextCol(3, 5,	_("Ending Balance"));
		if ($total > 0.0)
			$rep->AmountCol(5, 6, abs($total), $dec);
		else
			$rep->AmountCol(6, 7, abs($total), $dec);
		$rep->Font();
		$rep->Line($rep->row - $rep->lineHeight + 4);
		$rep->NewLine(2, 1);
		
		// Print the difference between starting and ending balances.
		$net_change = ($total - $prev_balance); 
		$rep->TextCol(3, 5, _("Net Change"));
		if ($total > 0.0)
			$rep->AmountCol(5, 6, $net_change, $dec, 0, 0, 0, 0, null, 1, True);
		else
			$rep->AmountCol(6, 7, $net_change, $dec, 0, 0, 0, 0, null, 1, True);
	}
	$rep->End();
}

