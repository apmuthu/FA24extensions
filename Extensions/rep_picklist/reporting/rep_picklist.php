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
$page_security = 'SA_SALESBULKREP';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Order Status List
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");
include_once($path_to_root . "/inventory/includes/db/items_category_db.inc");

//----------------------------------------------------------------------------------------------------

print_picklist();

//----------------------------------------------------------------------------------------------------

function GetSalesOrders($from, $to, $category=0, $location=null, $backorder=0)
{
	$fromdate = date2sql($from);
	$todate = date2sql($to);

	$sql= "SELECT sorder.order_no,
				sorder.debtor_no,
                sorder.branch_code,
                sorder.customer_ref,
                sorder.ord_date,
                sorder.from_stk_loc,
                sorder.delivery_date,
                sorder.total,
                line.stk_code,
                item.description,
                item.units,
                line.quantity,
                line.qty_sent,
                d.sales_type,
                cat.description AS cdesc
            FROM ".TB_PREF."sales_orders sorder
	           	INNER JOIN ".TB_PREF."debtors_master d
                    ON sorder.debtor_no = d.debtor_no
	           	INNER JOIN ".TB_PREF."sales_order_details line
            	    ON sorder.order_no = line.order_no
            	    AND sorder.trans_type = line.trans_type
            	    AND sorder.trans_type = ".ST_SALESORDER."
            	INNER JOIN ".TB_PREF."stock_master item
            	    ON line.stk_code = item.stock_id
            	INNER JOIN ".TB_PREF."stock_category cat
            	    ON item.category_id = cat.category_id
            WHERE sorder.ord_date >='$fromdate'
                AND sorder.ord_date <='$todate'";
	if ($category > 0)
		$sql .= " AND item.category_id=".db_escape($category);
	if ($location != null)
		$sql .= " AND sorder.from_stk_loc=".db_escape($location);
	if ($backorder)
		$sql .= " AND line.quantity - line.qty_sent > 0";
	$sql .= " ORDER BY sorder.order_no";

	return db_query($sql, "Error getting order details");
}

//----------------------------------------------------------------------------------------------------

function print_picklist()
{
	global $path_to_root;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
	$category = $_POST['PARAM_2'];
	$location = $_POST['PARAM_3'];
	$backorder = $_POST['PARAM_4'];
	$comments = $_POST['PARAM_5'];
	$orientation = $_POST['PARAM_6'];
	$destination = $_POST['PARAM_7'];
	if ($destination)
		include_once($path_to_root . "/reporting/includes/excel_report.inc");
	else
		include_once($path_to_root . "/reporting/includes/pdf_report.inc");
	$orientation = ($orientation ? 'L' : 'P');

	if ($category == ALL_NUMERIC)
		$category = 0;
	if ($location == ALL_TEXT)
		$location = null;
	if ($category == 0)
		$cat = _('All');
	else
		$cat = get_category_name($category);
	if ($location == null)
		$loc = _('All');
	else
		$loc = get_location_name($location);
	if ($backorder == 0)
		$back = _('All Orders');
	else
		$back = _('Back Orders Only');

	$cols = array(0, 20, 60, 300, 325,	385, 450, 515);

	$headers2 = array('', _('Customer'));

	$aligns = array('left',	'left',	'left', 'right', 'right', 'right',	'right');

	$headers = array('',	_('Cases'), _('Description'));

    $params =   array( 	0 => $comments,
	    				1 => array(  'text' => _('Period'), 'from' => $from, 'to' => $to),
	    				2 => array(  'text' => _('Category'), 'from' => $cat,'to' => ''),
	    				3 => array(  'text' => _('Location'), 'from' => $loc, 'to' => ''),
	    				4 => array(  'text' => _('Selection'),'from' => $back,'to' => ''));

	$aligns2 = $aligns;

	$orderno = 0;

	$result = GetSalesOrders($from, $to, $category, $location, $backorder);

    $grand_total = 0;
    $total = 0;
	while ($myrow=db_fetch($result))
	{
        if ($myrow['sales_type'] != 2)
            continue;
        if (!isset($rep)) {
            $rep = new FrontReport(_('Deliveries Picklist'), "Deliveries Picklist", user_pagesize(), 12, $orientation);
        if ($orientation == 'L')
            recalculate_cols($cols);
            $cols2 = $cols;
            $rep->Font();
            $rep->Info($params, $cols, $headers, $aligns, $cols2, $headers2, $aligns2);

            $rep->NewPage();
        }
		$rep->NewLine(0, 2, false, $orderno);
		if ($orderno != $myrow['order_no'])
		{
			if ($orderno != 0)
			{
                $rep->NewLine();
                $total = (int)(($total + 11) / 12);
                $rep->AmountCol(1, 2, $total);
                $grand_total += $total;
                $total = 0;
                $rep->TextCol(2, 3,	"Total");
				$rep->NewLine();
				$rep->Line($rep->row);
				$rep->NewLine();
			}
            $rep->Font('bold');
			$rep->TextCol(1, 3,	get_customer_name($myrow['debtor_no']));
            $rep->Font();
			$rep->NewLine(1);
			$rep->NewLine(1);
			$orderno = $myrow['order_no'];
		}
        $rep->RectangleCol(0, 1, 10, 10);

		$dec = get_qty_dec($myrow['stk_code']);
        $qty = $myrow['quantity'];
        $total += $qty;
        $cs = (int)($qty / 12);
        $b = (int)$qty % 12;
        $qty = (string)$cs;
        if ($b != 0)
            $qty .= "+" . $b . "b";
		$rep->TextCol(1, 2, $qty);

		$desc = $myrow['description'];
        // remove category name in item, if it exists
		$desc = str_replace($myrow['cdesc'] . " ", "", $desc);
		$rep->TextCol(2, 3,	$desc);
		$rep->NewLine();
	}
    if (!isset($rep))
        display_notification("No sales orders found");
    else {
        $rep->NewLine();
        $total = (int)(($total + 11) / 12);
        $rep->AmountCol(1, 2, $total);
        $grand_total += $total;
        $total = 0;
        $rep->TextCol(2, 3,	"Total");
        $rep->NewLine();
        $rep->Line($rep->row);

        $rep->NewLine();
        $rep->AmountCol(1, 2, $grand_total);
        $rep->TextCol(2, 3, _("Grand Total")); 
        $rep->Line($rep->row - 5);
        $rep->End();
    }
}

