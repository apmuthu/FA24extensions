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

// based on rep309.php - Item Sales Summary Report

$page_security = 'SA_SALESANALYTIC';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Brathwaate
// date_:	2018-06-24
// Title:	Sales Type Summary Report
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_category_db.inc");

//----------------------------------------------------------------------------------------------------

print_inventory_sales();

function getTransactions($category, $sales_type, $from, $to)
{
	$from = date2sql($from);
	$to = date2sql($to);
	$sql = "SELECT item.category_id,
			category.description AS cat_description,
			item.stock_id,
			item.description,
			SUM(IF(line.debtor_trans_type = ".ST_CUSTCREDIT.", -line.quantity, line.quantity)) AS quantity,
			SUM(IF(line.debtor_trans_type = ".ST_CUSTCREDIT.", -line.quantity, line.quantity)* line.unit_price * trans.rate) AS amount
		FROM ".TB_PREF."stock_master item,
			".TB_PREF."stock_category category,
            ".TB_PREF."debtors_master d,
			".TB_PREF."debtor_trans trans,
			".TB_PREF."debtor_trans_details line
		WHERE line.stock_id = item.stock_id
		AND item.category_id=category.category_id
        AND d.debtor_no=trans.debtor_no
		AND line.debtor_trans_type=trans.type
		AND line.debtor_trans_no=trans.trans_no
		AND trans.tran_date>='$from'
		AND trans.tran_date<='$to'
		AND line.quantity<>0
		AND item.mb_flag <>'F'
		AND (line.debtor_trans_type = ".ST_SALESINVOICE." OR line.debtor_trans_type = ".ST_CUSTCREDIT.")";
		if ($category != 0)
			$sql .= " AND item.category_id = ".db_escape($category);
		if ($sales_type != 0)
			$sql .= " AND d.sales_type = ".db_escape($sales_type);
		$sql .= " GROUP BY item.category_id,
			category.description,
			item.stock_id,
			item.description
		ORDER BY item.category_id, item.description";
			
	//display_notification($sql);
	
    return db_query($sql,"No transactions were returned");

}

//----------------------------------------------------------------------------------------------------

function print_inventory_sales()
{
    global $path_to_root;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
    $category = $_POST['PARAM_2'];
    $sales_type = $_POST['PARAM_3'];
	$comments = $_POST['PARAM_4'];
	$orientation = $_POST['PARAM_5'];
	$destination = $_POST['PARAM_6'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$orientation = ($orientation ? 'L' : 'P');
    $dec = user_price_dec();

	if ($category == ALL_NUMERIC)
		$category = 0;
	if ($category == 0)
		$cat = _('All');
	else
		$cat = get_category_name($category);

	$cols = array(0, 100, 260, 300, 350, 425, 430, 515);

	$headers = array(_('Item/Category'), _('Description'), _('Qty Sold'), _('Amount'), _('Remarks'));

	$aligns = array('left',	'left',	'right', 'right', 'right');

    $params =   array( 	0 => $comments,
    				    1 => array('text' => _('Period'),'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Category'), 'from' => $cat, 'to' => ''),
    				    3 => array('text' => _('Sales Type'), 'from' => get_sales_type_name($sales_type), 'to' => ''));

    $rep = new FrontReport(_('Item Sales Type Summary Report'), "ItemSalesTypeSummaryReport", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$res = getTransactions($category, $sales_type, $from, $to);
	$total = $grandtotal = 0.0;
	$catt = '';
	while ($trans=db_fetch($res))
	{
		if ($catt != $trans['cat_description'])
		{
			if ($catt != '')
			{
				$rep->NewLine(2, 3);
				$rep->TextCol(0, 3, _('Total'));
				$rep->AmountCol(3, 4, $total, $dec);
				$rep->Line($rep->row - 2);
				$rep->NewLine();
				$rep->NewLine();
				$total = 0.0;
			}
			$rep->TextCol(0, 1, $trans['category_id']);
			$rep->TextCol(1, 7, $trans['cat_description']);
			$catt = $trans['cat_description'];
			$rep->NewLine();
		}

		$rep->NewLine();
		$rep->fontSize -= 2;
		$rep->TextCol(0, 1, $trans['stock_id']);
		$rep->TextCol(1, 2, $trans['description']);
		$rep->AmountCol(2, 3, $trans['quantity'], get_qty_dec($trans['stock_id']));
		$rep->AmountCol(3, 4, $trans['amount'], $dec);
		$rep->fontSize += 2;
		$total += $trans['amount'];
		$grandtotal += $trans['amount'];
	}
	$rep->NewLine(2, 3);
	$rep->TextCol(0, 4, _('Total'));
	$rep->AmountCol(3, 4, $total, $dec);
	$rep->Line($rep->row - 2);
	$rep->NewLine();
	$rep->NewLine(2, 1);
	$rep->TextCol(0, 4, _('Grand Total'));
	$rep->AmountCol(3, 4, $grandtotal, $dec);

	$rep->Line($rep->row  - 4);
	$rep->NewLine();
    $rep->End();
}

