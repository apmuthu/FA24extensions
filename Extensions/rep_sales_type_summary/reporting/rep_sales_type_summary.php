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
$page_security = 'SA_SALESANALYTIC';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Chaitanya
// date_:	2005-05-19
// Title:	Item Sales Report
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");

//----------------------------------------------------------------------------------------------------

print_inventory_sales();

function getTransactions($cat, $supplier, $item_type, $sales_type, $from, $to)
{
	$from = date2sql($from);
	$to = date2sql($to);
	$sql = "SELECT item.stock_id,
			item.description,
			SUM(IF(line.debtor_trans_type = ".ST_CUSTCREDIT.", -line.quantity, line.quantity)) AS quantity,
			SUM(IF(line.debtor_trans_type = ".ST_CUSTCREDIT.", -line.quantity, line.quantity)* line.unit_price * trans.rate) AS amount
		FROM ".TB_PREF."stock_master item,
            ".TB_PREF."debtors_master d,
			".TB_PREF."debtor_trans trans,
			".TB_PREF."debtor_trans_details line
		WHERE line.stock_id = item.stock_id
        AND d.debtor_no=trans.debtor_no
		AND line.debtor_trans_type=trans.type
		AND line.debtor_trans_no=trans.trans_no
		AND trans.tran_date>='$from'
		AND trans.tran_date<='$to'
		AND line.quantity<>0
		AND item.mb_flag <>'F'
		AND (line.debtor_trans_type = ".ST_SALESINVOICE." OR line.debtor_trans_type = ".ST_CUSTCREDIT.")";

		if ($item_type == 1)
			$sql .= " AND item.mb_flag = 'M'";
		if ($sales_type != 0)
			$sql .= " AND d.sales_type = ".db_escape($sales_type);
        if ($cat != -1)
			$sql .= " AND item.category_id = ".db_escape($cat);
        if ($supplier != 0)
			$sql .= " AND EXISTS (SELECT *
                FROM ".TB_PREF."purch_data pd
                WHERE pd.stock_id = item.stock_id
                AND pd.supplier_id = ".db_escape($supplier).")";
		$sql .= " GROUP BY item.stock_id,
			item.description
		ORDER BY quantity DESC, item.description";
	
    return db_query($sql,"No transactions were returned");

}

//----------------------------------------------------------------------------------------------------
function get_domestic_price($myrow, $stock_id)
{
    if ($myrow['type'] == ST_SUPPRECEIVE || $myrow['type'] == ST_SUPPCREDIT)
    {
        $price = $myrow['price'];
        if ($myrow['person_id'] > 0)
        {
            // Do we have foreign currency?
            $supp = get_supplier($myrow['person_id']);
            $currency = $supp['curr_code'];
            $ex_rate = get_exchange_rate_to_home_currency($currency, sql2date($myrow['tran_date']));
            $price /= $ex_rate;
        }   
    }
    else
        $price = $myrow['standard_cost']; // Item Adjustments just have the real cost
    return $price;
}   

//----------------------------------------------------------------------------------------------------
function trans_qty_unit_cost($stock_id, $location=null, $from_date, $to_date, $inward = true)
{
    if ($from_date == null)
        $from_date = Today();

    $from_date = date2sql($from_date);  

    if ($to_date == null)
        $to_date = Today();

    $to_date = date2sql($to_date);

    $sql = "SELECT move.*, IF(ISNULL(supplier.supplier_id), debtor.debtor_no, supplier.supplier_id) person_id
        FROM ".TB_PREF."stock_moves move
                LEFT JOIN ".TB_PREF."supp_trans credit ON credit.trans_no=move.trans_no AND credit.type=move.type
                LEFT JOIN ".TB_PREF."grn_batch grn ON grn.id=move.trans_no AND 25=move.type
                LEFT JOIN ".TB_PREF."suppliers supplier ON IFNULL(grn.supplier_id, credit.supplier_id)=supplier.supplier_id
                LEFT JOIN ".TB_PREF."debtor_trans cust_trans ON cust_trans.trans_no=move.trans_no AND cust_trans.type=move.type
                LEFT JOIN ".TB_PREF."debtors_master debtor ON cust_trans.debtor_no=debtor.debtor_no
        WHERE stock_id=".db_escape($stock_id)."
        AND move.tran_date >= '$from_date' AND move.tran_date <= '$to_date' AND qty <> 0 AND move.type <> ".ST_LOCTRANSFER;

    if ($location != '')
        $sql .= " AND move.loc_code = ".db_escape($location);

    if ($inward)
        $sql .= " AND qty > 0 ";
    else
        $sql .= " AND qty < 0 ";
    $sql .= " ORDER BY tran_date";
    
    $result = db_query($sql, "No standard cost transactions were returned");
    
    if ($result == false)
        return false;

    $qty = $tot_cost = 0;
    while ($row=db_fetch($result))
    {
        $qty += $row['qty'];
        $price = get_domestic_price($row, $stock_id); 
        $tran_cost = $row['qty'] * $price;
        $tot_cost += $tran_cost;
    }   
    if ($qty == 0)
        return 0;
    return $tot_cost/$qty;
}

//----------------------------------------------------------------------------------------------------


function print_inventory_sales()
{
    global $path_to_root;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
    $cat = $_POST['PARAM_2'];
    $supplier = $_POST['PARAM_3'];
    $sales_type = $_POST['PARAM_4'];
	$item_type = $_POST['PARAM_5'];
	$comments = $_POST['PARAM_6'];
	$orientation = $_POST['PARAM_7'];
	$destination = $_POST['PARAM_8'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");

	$orientation = ($orientation ? 'L' : 'P');
    $dec = user_price_dec();
    if ($supplier == 0)
        $sup = "All suppliers";
    else
        $sup = get_supplier_name($supplier);

	$cols = array(0, 100, 260, 300, 350, 400, 450);

	$headers = array(_('Item'), _('Description'), _('Qty Sold'), _('Gross'), _('Cost'), _('Net'));

	$aligns = array('left',	'left',	'right', 'right', 'right', 'right');

    $params =   array( 	0 => $comments,
    				    1 => array('text' => _('Period'),'from' => $from, 'to' => $to),
    				    2 => array('text' => _('Supplier'), 'from' => $sup, 'to' => ''),
    				    3 => array('text' => _('Sales Type'), 'from' => get_sales_type_name($sales_type), 'to' => ''));

    $rep = new FrontReport(_('Item Sales Report By Quantity, Supplier and Type'), "ItemSalesTypeSummaryReport", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$res = getTransactions($cat, $supplier, $item_type, $sales_type, $from, $to);
	$total = $total_cost = $total_net = 0.0;
	while ($trans=db_fetch($res))
	{
        $unit_cost = trans_qty_unit_cost($trans['stock_id'], null, $from, $to, false);
        if ($unit_cost === false)
            continue;
        $cost = $trans['quantity'] * $unit_cost;
		$rep->NewLine();
		$rep->fontSize -= 2;
		$rep->TextCol(0, 1, $trans['stock_id']);
		$rep->TextCol(1, 2, $trans['description']);
		$rep->AmountCol(2, 3, $trans['quantity'], get_qty_dec($trans['stock_id']));
		$rep->AmountCol(3, 4, $trans['amount'], $dec);
		$rep->AmountCol(4, 5, $cost, $dec);
		$rep->AmountCol(5, 6, $trans['amount'] - $cost, $dec);
		$rep->fontSize += 2;
		$total += $trans['amount'];
		$total_cost += $cost;
		$total_net += $trans['amount'] - $cost;
	}
	$rep->Line($rep->row  - 4);
	$rep->NewLine(2, 3);
	$rep->TextCol(0, 4, _('Total'));
	$rep->AmountCol(3, 4, $total, $dec);
	$rep->AmountCol(4, 5, $total_cost, $dec);
	$rep->AmountCol(5, 6, $total_net, $dec);

	$rep->Line($rep->row  - 4);
	$rep->NewLine();
    $rep->End();
}

