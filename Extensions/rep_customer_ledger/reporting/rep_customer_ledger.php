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
$page_security = 'SA_CUSTPAYMREP';

// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Customer Balances
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");

//----------------------------------------------------------------------------------------------------

print_customer_balances();

function get_open_balance($debtorno, $to)
{
	if($to)
		$to = date2sql($to);

     $sql = "SELECT SUM(IF(t.type = ".ST_SALESINVOICE." OR (t.type = ".ST_JOURNAL." AND t.ov_amount>0),
     	-abs(t.ov_amount + t.ov_gst + t.ov_freight + t.ov_freight_tax + t.ov_discount), 0)) AS charges,";
     $sql .= "SUM(IF(t.type != ".ST_SALESINVOICE." AND NOT(t.type = ".ST_JOURNAL." AND t.ov_amount>0),
     	abs(t.ov_amount + t.ov_gst + t.ov_freight + t.ov_freight_tax + t.ov_discount) * -1, 0)) AS credits,";
     $sql .= "SUM(IF(t.type != ".ST_SALESINVOICE." AND NOT(t.type = ".ST_JOURNAL." AND t.ov_amount>0), t.alloc * -1, t.alloc)) AS Allocated,";

 	$sql .=	"SUM(IF(t.type = ".ST_SALESINVOICE.", 1, -1) *
 			(abs(t.ov_amount + t.ov_gst + t.ov_freight + t.ov_freight_tax + t.ov_discount) - abs(t.alloc))) AS OutStanding
		FROM ".TB_PREF."debtor_trans t
    	WHERE t.debtor_no = ".db_escape($debtorno)
		." AND t.type <> ".ST_CUSTDELIVERY;
    if ($to)
    	$sql .= " AND t.tran_date < '$to'";
	$sql .= " GROUP BY debtor_no";

    $result = db_query($sql,"No transactions were returned");
    return db_fetch($result);
}

function get_transactions($debtorno, $from, $to, $only_rec)
{
	$from = date2sql($from);
	$to = date2sql($to);

 	$allocated_from = 
 			"(SELECT trans_type_from as trans_type, trans_no_from as trans_no, date_alloc, sum(amt) amount
 			FROM ".TB_PREF."cust_allocations alloc
 				WHERE person_id=".db_escape($debtorno)."
 					AND date_alloc <= '$to'
 				GROUP BY trans_type_from, trans_no_from) alloc_from";
 	$allocated_to = 
 			"(SELECT trans_type_to as trans_type, trans_no_to as trans_no, date_alloc, sum(amt) amount
 			FROM ".TB_PREF."cust_allocations alloc
 				WHERE person_id=".db_escape($debtorno)."
 					AND date_alloc <= '$to'
 				GROUP BY trans_type_to, trans_no_to) alloc_to";

     $sql = "SELECT trans.*, comments.memo_,
 		(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) AS TotalAmount,
 		IFNULL(alloc_from.amount, alloc_to.amount) AS Allocated,
 		((trans.type = ".ST_SALESINVOICE.")	AND trans.due_date < '$to') AS OverDue
     	FROM ".TB_PREF."debtor_trans trans
 			LEFT JOIN ".TB_PREF."voided voided ON trans.type=voided.type AND trans.trans_no=voided.id
			LEFT JOIN ".TB_PREF."comments comments ON trans.type=comments.type AND trans.trans_no=comments.id
 			LEFT JOIN $allocated_from ON alloc_from.trans_type = trans.type AND alloc_from.trans_no = trans.trans_no
 			LEFT JOIN $allocated_to ON alloc_to.trans_type = trans.type AND alloc_to.trans_no = trans.trans_no

     	WHERE trans.tran_date >= '$from'
 			AND trans.tran_date <= '$to'
 			AND trans.debtor_no = ".db_escape($debtorno);

			if ($only_rec)
				$sql .= " AND trans.type IN (".ST_CUSTPAYMENT.",".ST_BULKDEPOSIT.",".ST_BANKDEPOSIT.",".ST_CASHDEPOSIT.")";
			else
				$sql .= " AND trans.type <> ".ST_CUSTDELIVERY;

 			$sql .= " AND ISNULL(voided.id)
     	ORDER BY trans.tran_date ";
    return db_query($sql,"No transactions were returned");
}

function get_customer_reference ($order_number)
{

	$sql = "SELECT customer_ref FROM ".TB_PREF."sales_orders WHERE order_no ='$order_number' AND trans_type=".ST_SALESORDER."";

	$result = db_query($sql,"No Transcation were returned");

	$val = db_fetch($result);

	return $val['customer_ref'];


}
//----------------------------------------------------------------------------------------------------

function print_customer_balances()
{
    	global $path_to_root, $systypes_array;

    	$from = $_POST['PARAM_0'];
    	$to = $_POST['PARAM_1'];
    	$fromcust = $_POST['PARAM_2'];
        $area = $_POST['PARAM_3'];
        $folk = $_POST['PARAM_4'];
    $show_balance = $_POST['PARAM_5'];
    	$currency = $_POST['PARAM_6'];
    	$no_zeros = $_POST['PARAM_7'];
    	$hide_trans = $_POST['PARAM_8'];
    	$only_rec = $_POST['PARAM_9'];
    	$comments = $_POST['PARAM_10'];
	$orientation = $_POST['PARAM_11'];
	$destination = $_POST['PARAM_12'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$orientation = ($orientation ? 'L' : 'P');
	if ($fromcust == ALL_TEXT)
		$cust = _('All');
	else
		$cust = get_customer_name($fromcust);
    	$dec = user_price_dec();

	if ($area == ALL_NUMERIC)
 			$area = 0;
 	if ($area == 0)
 			$sarea = _('All Areas');
 	else
 			$sarea = get_area_name($area);

 	if ($folk == ALL_NUMERIC)
 			$folk = 0;
 	if ($folk == 0)
 			$salesfolk = _('All Sales Man');
 	else
 			$salesfolk = get_salesman_name($folk);

	if ($currency == ALL_TEXT)
	{
		$convert = true;
		$currency = _('Balances in Home Currency');
	}
	else
		$convert = false;

	if ($no_zeros) $nozeros = _('Yes');
	else $nozeros = _('No');

	$cols = array(0, 70, 100, 170, 215,	280, 320, 395, 465,	535);

	$headers = array(_('Trans Type'), _('#'), _('Cust Ref'), _('Date'), _('Due Date'), _('Debits'), _('Credits'),
		_('Allocated'), 	_('Outstanding'));

	if ($show_balance)
		$headers[7] = _('Balance');
	$aligns = array('left','left',	'left',	'left',	'left',	'right', 'right', 'right', 'right');

    $params =   array(  0 => $comments,
    				    1 => array('text' => _('Period'),         'from' => $from,      'to' => $to),
    				    2 => array('text' => _('Customer'),       'from' => $cust,      'to' => ''),
    				    3 => array('text' => _('Sales Areas'),    'from' => $sarea,     'to' => ''),
    				    4 => array('text' => _('Sales Folk'),     'from' => $salesfolk, 'to' => ''),
    				    5 => array('text' => _('Currency'),       'from' => $currency,  'to' => ''),
						6 => array('text' => _('Suppress Zeros'), 'from' => $nozeros,   'to' => ''));

    $rep = new FrontReport(_('Customer Ledger'), "CustomerLedger", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);
    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$grandtotal = array(0,0,0,0);

    $sql = "SELECT cust.debtor_no, name, curr_code
FROM ".TB_PREF."debtors_master cust
    INNER JOIN ".TB_PREF."cust_branch branch
        ON cust.debtor_no=branch.debtor_no
    INNER JOIN ".TB_PREF."areas areas
        ON branch.area = areas.area_code
    INNER JOIN ".TB_PREF."salesman salesman
        ON branch.salesman=salesman.salesman_code
WHERE 1=1";
    if ($fromcust != ALL_TEXT )
        $sql .= " AND cust.debtor_no=".db_escape($fromcust);
    if ($area != 0)
        $sql .= " AND areas.area_code=".db_escape($area);
    if ($folk != 0 )
        $sql .= " AND salesman.salesman_code=".db_escape($folk);
 
	$sql .= " GROUP BY cust.debtor_no ORDER BY name";

	$result = db_query($sql, "The customers could not be retrieved");

	while ($myrow = db_fetch($result))
	{
		if (!$convert && $currency != $myrow['curr_code']) continue;
		
		$accumulate = 0;
		$rate = $convert ? get_exchange_rate_from_home_currency($myrow['curr_code'], Today()) : 1;
		$bal = get_open_balance($myrow['debtor_no'], $from, $convert);
		$init[0] = $init[1] = 0.0;
		$init[0] = round2(abs($bal['charges']*$rate), $dec);
		$init[1] = round2(Abs($bal['credits']*$rate), $dec);
		$init[2] = round2($bal['Allocated']*$rate, $dec);
		if ($show_balance)
		{
			$init[3] = $init[0] - $init[1];
			$accumulate += $init[3];
		}	
		else	
			$init[3] = round2($bal['OutStanding']*$rate, $dec);

		$res = get_transactions($myrow['debtor_no'], $from, $to, $only_rec);
		if ($no_zeros && db_num_rows($res) == 0) continue;

		$rep->fontSize += 2;
		if (!$hide_trans) $rep->TextCol(0, 2, $myrow['name']);
		if ($convert)
			if (!$hide_trans) $rep->TextCol(2, 3,	$myrow['curr_code']);
		$rep->fontSize -= 2;
		if (!$only_rec && !$hide_trans)
		{
			$rep->TextCol(3, 4,	_("Open Balance"));
			$rep->AmountCol(5, 6, $init[0], $dec);
			$rep->AmountCol(6, 7, $init[1], $dec);
			$rep->AmountCol(7, 8, $init[2], $dec);
			$rep->AmountCol(8, 9, $init[3], $dec);
		}
		$total = array(0,0,0,0);
		for ($i = 0; $i < 4; $i++)
		{
			if (!$only_rec)
			{
				$total[$i] += $init[$i];
				$grandtotal[$i] += $init[$i];
			}
		}
		if (!$hide_trans)
		{
			$rep->NewLine(1, 2);
			$rep->Line($rep->row + 4);
		}
		if (db_num_rows($res)==0) {
			if (!$hide_trans) $rep->NewLine(1, 2);
			continue;
		}
		while ($trans = db_fetch($res)) //Detail starts here
		{
			if ($no_zeros) {
                if ($show_balance) {
                    if ($trans['TotalAmount'] == 0) continue;
                } else {
                    if (floatcmp($trans['TotalAmount'], $trans['Allocated']) == 0) continue;
                }
            }
			if (!$hide_trans)
			{
				$rep->NewLine(1, 2);
				$rep->TextCol(0, 1, $systypes_array[$trans['type']]);
				$rep->TextCol(1, 2,	$trans['reference']);
				$rep->TextCol(2, 3,	get_customer_reference($trans['order_'])); // added by faisal
				$rep->DateCol(3, 4,	$trans['tran_date'], true);
			}
			if ($trans['type'] == ST_SALESINVOICE)
			if (!$hide_trans) $rep->DateCol(4, 5,	$trans['due_date'], true);
			$item[0] = $item[1] = 0.0;
			if ($trans['type'] == ST_CUSTCREDIT || $trans['type'] == ST_CUSTPAYMENT || $trans['type'] == ST_BANKDEPOSIT || $trans['type'] == ST_BULKDEPOSIT || $trans['type'] == ST_CASHDEPOSIT)
				$trans['TotalAmount'] *= -1;
			if ($trans['TotalAmount'] > 0.0)
			{
				$item[0] = round2(abs($trans['TotalAmount']) * $rate, $dec);
				if (!$hide_trans) $rep->AmountCol(5, 6, $item[0], $dec);
				$accumulate += $item[0];
				$item[2] = round2($trans['Allocated'] * $rate, $dec);
			}
			else
			{
				$item[1] = round2(Abs($trans['TotalAmount']) * $rate, $dec);
				if (!$hide_trans) $rep->AmountCol(6, 7, $item[1], $dec);
				$accumulate -= $item[1];
				$item[2] = round2($trans['Allocated'] * $rate, $dec) * -1;
			}
			if (!$hide_trans) $rep->AmountCol(7, 8, $item[2], $dec);
			if ($trans['type'] == ST_SALESINVOICE || $trans['type'] == ST_BANKPAYMENT)
				$item[3] = $item[0] - $item[2];
			else	
				$item[3] = -$item[1] - $item[2];

			if ($show_balance )
			{
				if (!$hide_trans) $rep->AmountCol(8, 9, $accumulate, $dec);
			}
			else	
			{
			 if (!$hide_trans) $rep->AmountCol(8, 9, $item[3], $dec);
		 	}
			if ($only_rec)
				if (!$hide_trans) $rep->AmountCol(8, 9, $item[3], $dec);
			if (!$hide_trans && $trans['memo_']<>"")
			{
				$rep->NewLine(1, 2);
				$rep->fontSize -= 2;
				$rep->TextCol(1, 8,	$trans['memo_']);
				$rep->fontSize += 2;
			}
			if (!$hide_trans) $rep->Line($rep->row - 2);
			for ($i = 0; $i < 4; $i++)
			{
				$total[$i] += $item[$i];
				$grandtotal[$i] += $item[$i];
			}
			if ($show_balance)
				$total[3] = $total[0] - $total[1];
		}
		if (!$hide_trans)
		{
			$rep->Line($rep->row - 8);
			$rep->NewLine(2);
		}
		$rep->TextCol(0, 3, _('Total'));
		if ($hide_trans) $rep->TextCol(1, 5, $myrow['name']);
		for ($i = 0; $i < 4; $i++)
			$rep->AmountCol($i + 5, $i + 6, $total[$i], $dec);
   		$rep->Line($rep->row  - 4);
   		$rep->NewLine(2);
	}
	$rep->fontSize += 2;
	$rep->TextCol(0, 3, _('Grand Total'));
	$rep->fontSize -= 2;
	if ($show_balance)
		$grandtotal[3] = $grandtotal[0] - $grandtotal[1];
	for ($i = 0; $i < 4; $i++)
		$rep->AmountCol($i + 5, $i + 6, $grandtotal[$i], $dec);
	$rep->Line($rep->row  - 4);
	$rep->NewLine();
    	$rep->End();
}

