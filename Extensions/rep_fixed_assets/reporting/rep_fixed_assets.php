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
$page_security = 'SA_GLREP';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	GL Accounts Transactions
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/admin/db/fiscalyears_db.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");

//----------------------------------------------------------------------------------------------------

print_GL_transactions();

//----------------------------------------------------------------------------------------------------

function get_fixed_asset_gl_trans($from_date, $to_date, $trans_no=0,
	$account=null, $dimension=0, $dimension2=0, $exclude_dim=false, $detail=null)
{
	global $SysPrefs;

	$from = date2sql($from_date);
	$to = date2sql($to_date);

	$sql = "SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
        IF(gl.memo_!='', gl.memo_, c.memo_), '(Reference', 1), '( Person', 1), ':', 1))  as memo,";
    if (!$detail)
        $sql .= " SUM(gl.amount) as total, gl.dimension_id, gl.dimension2_id";
    else
        $sql .= " gl.*, j.event_date, j.doc_date, a.gl_seq, u.user_id, st.supp_reference, gl.person_id subcode,
			IFNULL(IFNULL(sup.supp_name, debt.name), bt.person_id) as person_name, 
			IFNULL(gl.person_id, IFNULL(sup.supplier_id, IFNULL(debt.debtor_no, bt.person_id))) as person_id,
                        IF(gl.person_id, gl.person_type_id, IF(sup.supplier_id,".  PT_SUPPLIER . "," .  "IF(debt.debtor_no," . PT_CUSTOMER . "," . "IF(bt.person_id != '' AND !ISNULL(bt.person_id), bt.person_type_id, -1)))) as person_type_id,
			IFNULL(st.tran_date, IFNULL(dt.tran_date, IFNULL(bt.trans_date, IFNULL(grn.delivery_date, gl.tran_date)))) as doc_date,
			coa.account_name, ref.reference";

    $sql .= " FROM ".TB_PREF."gl_trans gl
			LEFT JOIN ".TB_PREF."voided v ON gl.type_no=v.id AND v.type=gl.type

			LEFT JOIN ".TB_PREF."supp_trans st ON gl.type_no=st.trans_no AND st.type=gl.type AND (gl.type!=".ST_JOURNAL." OR gl.person_id=st.supplier_id)
			LEFT JOIN ".TB_PREF."grn_batch grn ON grn.id=gl.type_no AND gl.type=".ST_SUPPRECEIVE." AND gl.person_id=grn.supplier_id
			LEFT JOIN ".TB_PREF."debtor_trans dt ON gl.type_no=dt.trans_no AND dt.type=gl.type AND (gl.type!=".ST_JOURNAL." OR gl.person_id=dt.debtor_no)

			LEFT JOIN ".TB_PREF."suppliers sup ON st.supplier_id=sup.supplier_id OR grn.supplier_id=sup.supplier_id
			LEFT JOIN ".TB_PREF."cust_branch branch ON dt.branch_code=branch.branch_code
			LEFT JOIN ".TB_PREF."debtors_master debt ON dt.debtor_no=debt.debtor_no

			LEFT JOIN ".TB_PREF."bank_trans bt ON bt.type=gl.type AND bt.trans_no=gl.type_no AND bt.amount!=0
                        AND (bt.person_id != '' AND !ISNULL(bt.person_id))

			LEFT JOIN ".TB_PREF."journal j ON j.type=gl.type AND j.trans_no=gl.type_no
			LEFT JOIN ".TB_PREF."audit_trail a ON a.type=gl.type AND a.trans_no=gl.type_no AND NOT ISNULL(gl_seq)
			LEFT JOIN ".TB_PREF."users u ON a.user=u.id
			LEFT JOIN ".TB_PREF."comments c ON c.type=gl.type AND c.id=gl.type_no

			LEFT JOIN ".TB_PREF."refs ref ON ref.type=gl.type AND ref.id=gl.type_no,"
		.TB_PREF."chart_master coa
		WHERE coa.account_code=gl.account
		AND ISNULL(v.date_)
		AND gl.tran_date >= '$from'
		AND gl.tran_date <= '$to'
		AND gl.amount <> 0"; 

	if ($trans_no > 0)
		$sql .= " AND gl.type_no LIKE ".db_escape('%'.$trans_no);;

	if ($account != null)
		$sql .= " AND gl.account = ".db_escape($account);

    if ($exclude_dim) {
        if ($dimension != 0)
            $sql .= " AND gl.dimension_id != ".($dimension<0 ? 0 : db_escape($dimension));

        if ($dimension2 != 0)
            $sql .= " AND gl.dimension2_id != ".($dimension2<0 ? 0 : db_escape($dimension2));
    } else {
        if ($dimension != 0)
            $sql .= " AND gl.dimension_id = ".($dimension<0 ? 0 : db_escape($dimension));

        if ($dimension2 != 0)
            $sql .= " AND gl.dimension2_id = ".($dimension2<0 ? 0 : db_escape($dimension2));
    }

    if ($detail)
        $sql .= " ORDER BY memo, tran_date, counter";
    else
        $sql .= " GROUP BY memo HAVING ROUND(total,2) != 0 ORDER BY memo";

    // display_notification(str_replace(TB_PREF, "1_", $sql));
	return db_query($sql, "The transactions for could not be retrieved");
}

function print_GL_transactions()
{
	global $path_to_root, $systypes_array;

	$dim = get_company_pref('use_dimension');
	$dimension = $dimension2 = 0;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
	$acc = $_POST['PARAM_2'];
	if ($dim == 2)
	{
		$dimension = $_POST['PARAM_3'];
		$dimension2 = $_POST['PARAM_4'];
		$exclude_dim = $_POST['PARAM_5'];
		$detail = $_POST['PARAM_6'];
		$comments = $_POST['PARAM_7'];
		$orientation = $_POST['PARAM_8'];
		$destination = $_POST['PARAM_9'];
	}
	elseif ($dim == 1)
	{
		$dimension = $_POST['PARAM_3'];
		$exclude_dim = $_POST['PARAM_4'];
		$detail = $_POST['PARAM_5'];
		$comments = $_POST['PARAM_6'];
		$orientation = $_POST['PARAM_7'];
		$destination = $_POST['PARAM_8'];
	}
	else
	{
		$exclude_dim = $_POST['PARAM_3'];
		$detail = $_POST['PARAM_4'];
		$comments = $_POST['PARAM_5'];
		$orientation = $_POST['PARAM_6'];
		$destination = $_POST['PARAM_7'];
	}
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");
	$orientation = ($orientation ? 'L' : 'P');

	$account = get_gl_account($acc);

	if (is_account_balancesheet($account["account_code"]))
		$begin = "";
	else
	{
		$begin = get_fiscalyear_begin_for_date($from);
		if (date1_greater_date2($begin, $from))
			$begin = $from;
		$begin = add_days($begin, -1);
	}

	$trans = get_fixed_asset_gl_trans($from, $to, -1, $account['account_code'], $dimension, $dimension2, $exclude_dim, $detail);
	$rows = db_num_rows($trans);
	if ($rows == 0)
		exit();

	$rep = new FrontReport(_($account['account_code'] . " " . $account['account_name']), "FixedAssets", user_pagesize(), 9, $orientation);
	$dec = user_price_dec();

	//------------0--1---2---3----4----5----6----7----8----9----10-------
	//-----------------------dim1-dim2-----------------------------------
	//-----------------------dim1----------------------------------------
	//-------------------------------------------------------------------
	$aligns = array('left', 'left', 'left',	'left',	'left',	'left',	'left',	'right', 'right', 'right');

	if ($dim == 2) {
        $cols = array(0, 65, 105, 125, 175, 230, 290, 345, 405, 465, 525);
		$headers = array(_('Type'),	_('Ref'), _('#'),	_('Date'), _('Dimension')." 1", _('Dimension')." 2",
			_('Person/Item'), _('Debit'),	_('Credit'), _('Balance'));
	} elseif ($dim == 1) {
        $cols = array(0, 65, 105, 125, 175, 175, 230, 345, 405, 465, 525);
		$headers = array(_('Type'),	_('Ref'), _('#'),	_('Date'), _('Dimension'), "", _('Person/Item'),
			_('Debit'),	_('Credit'), _('Balance'));
	} else {
        $cols = array(0, 65, 105, 125, 175, 230, 290, 345, 405, 465, 525);
		$headers = array(_('Type'),	_('Ref'), _('#'),	_('Date'), "", "", _('Person/Item'),
			_('Debit'),	_('Credit'), _('Balance'));
    }

	if ($dim == 2)
	{
    	$params =   array( 	0 => $comments,
    				    1 => array('text' => _('Period'), 'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Accounts'),'from' => $acc, 'to' => $acc),
                    	3 => array('text' => _('Dimension')." 1", 'from' => get_dimension_string($dimension),
                            'to' => ''),
                    	4 => array('text' => _('Dimension')." 2", 'from' => get_dimension_string($dimension2),
                            'to' => ''));
    }
    elseif ($dim == 1)
    {
    	$params =   array( 	0 => $comments,
    				    1 => array('text' => _('Period'), 'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Accounts'),'from' => $acc, 'to' => $acc),
                    	3 => array('text' => _('Dimension'), 'from' => ($exclude_dim ? "Excluding " : "")  . get_dimension_string($dimension),
                            'to' => ''));
    }
    else
    {
    	$params =   array( 	0 => $comments,
    				    1 => array('text' => _('Period'), 'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Accounts'),'from' => $acc, 'to' => $acc));
    }
    if ($orientation == 'L')
    	recalculate_cols($cols);

	$rep->Font();
	$rep->Info($params, $cols, $headers, $aligns);
	$rep->NewPage();

	if ($rows > 0)
	{
		$last_asset="";
        $total=0;
        $grandtotal=0;
		while ($myrow=db_fetch($trans))
		{
			$asset = $myrow['memo'];
			if ($asset != $last_asset) {

				$rep->NewLine(1);
				$rep->Font('bold');
				$rep->TextCol(0, 4,	$asset, -2);
				$rep->Font();
                $grandtotal += $total;
				$total = 0;
				$last_asset = $asset;
                if (!$detail) {
                    $total = $myrow['total'];
                    if ($total > 0.0)
                        $rep->AmountCol(7, 8, abs($total), $dec);
                    else
                        $rep->AmountCol(8, 9, abs($total), $dec);
                    if ($dim >= 1)
                        $rep->TextCol(4, 5,	get_dimension_string($myrow['dimension_id']));
                    if ($dim > 1)
                        $rep->TextCol(5, 6,	get_dimension_string($myrow['dimension2_id']));
                    continue;
                }
				$rep->NewLine(1);
			}

			$total += $myrow['amount'];

			$rep->TextCol(0, 1, $systypes_array[$myrow["type"]], -2);
			$reference = get_reference($myrow["type"], $myrow["type_no"]);
			$rep->TextCol(1, 2, $reference);
			$rep->TextCol(2, 3,	$myrow['type_no'], -2);
			$rep->DateCol(3, 4,	$myrow["tran_date"], true);
			if ($dim >= 1)
				$rep->TextCol(4, 5,	get_dimension_string($myrow['dimension_id']));
			if ($dim > 1)
				$rep->TextCol(5, 6,	get_dimension_string($myrow['dimension2_id']));
			$txt = payment_person_name($myrow["person_type_id"],$myrow["person_id"], false);
			$rep->TextCol(6, 7,	$txt, -2);
			if ($myrow['amount'] > 0.0)
				$rep->AmountCol(7, 8, abs($myrow['amount']), $dec);
			else
				$rep->AmountCol(8, 9, abs($myrow['amount']), $dec);
			$rep->TextCol(9, 10, number_format2($total, $dec));
			$rep->NewLine();
			if ($rep->row < $rep->bottomMargin + $rep->lineHeight)
			{
				$rep->Line($rep->row - 2);
				$rep->NewPage();
			}
		}
		$rep->NewLine();
	}
	$rep->Font('bold');
	$rep->TextCol(4, 6,	_("Total"));
	if ($grandtotal > 0.0)
		$rep->AmountCol(7, 8, abs($grandtotal), $dec);
	else
		$rep->AmountCol(8, 9, abs($grandtotal), $dec);
	$rep->Font();
	$rep->Line($rep->row - $rep->lineHeight + 4);
	$rep->NewLine(2, 1);

	$rep->End();
}

