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
$page_security = 'SA_GLANALYTIC';
$path_to_root="../..";
$path_to_file="gl/inquiry/profit_loss.php";
$path_to_file="modules/pl_dimension/pl_dimension.php";
// $path_to_file="modules/pl_dimension/pl_dimension.php";

include_once($path_to_root . "/includes/session.inc");

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/reporting/includes/class.graphic.inc");
include_once($path_to_root . "/includes/dashboard.inc"); // here are all the dashboard routines.


$js = "";
if (user_use_date_picker())
	$js = get_js_date_picker();
$js .= get_js_history(array('payment_type', 'taxgroup', 'tax_groups', 'year', 'month'));

page(_($help_context = "Sales History"), false, false, "", $js);

//----------------------------------------------------------------------------------------------------
// Ajax updates

if (get_post('Show')) 
{
	$Ajax->activate('sales_tbl');
}

set_posts(array("payment_type", 'taxgroup', "tax_groups", "year", "month"));

function getYears()
{
    $sql = "select year(dt.tran_date) row_year  from ".TB_PREF."debtor_trans dt WHERE type=".ST_SALESINVOICE." GROUP BY year(dt.tran_date)";
    return db_query($sql,"No transactions were returned");
}

function menu_list($name, $selected_id=null, $items, $submit_on_change=false)
{
    return array_selector($name, $selected_id, $items,
        array(
            'select_submit'=> $submit_on_change,
            'async' => false ) ); // FIX?
}

function menu_list_cells($label, $name, $selected_id=null, $items, $submit_on_change=false)
{
    if ($label != null)
        echo "<td>$label</td>\n";
    echo "<td>";
    echo menu_list($name, $selected_id, $items, $submit_on_change);
    echo "</td>\n";
}

function menu_list_row($label, $name, $selected_id=null, $items, $submit_on_change=false)
{
    echo "<tr><td class='label'>$label</td>";
    menu_list_cells(null, $name, $selected_id, $items, $submit_on_change);
    echo "</tr>\n";
}

function getTaxGroups()
{
	$sql = "SELECT *
            FROM ".TB_PREF."tax_groups
            WHERE no_sale=0";
    return db_query($sql,"No tax groups found");
}


// This returns the sum of allocated transactions sorted by bank account
// and unallocated transactions as unpaid.

// TBD: But if a transaction is only partially paid/allocated, it does not return
// the unpaid portion.  Thus the totals paid/unpaid  might be less than the total sales.
// To be correct, the sql would have to be split and the unpaid amount would come from
// debtor_trans alloc without joining cust_allocations.  The sql is already ugly
// and so I did not bother.

function getBankTransactions($tran_date, $sel_month, $tax_groups)
{
	$sql = "SELECT sum(count) as count, tran_date, SUM(amount) as amount, payment_method
            FROM (
                SELECT count(*) as count,
                dt.tran_date,
                SUM(IFNULL(ca.amt, (ov_amount+ov_freight+ov_discount+ov_gst) *dt.rate)) as amount,
                ba.bank_account_name as payment_method
                FROM ".TB_PREF."debtor_trans dt
                LEFT JOIN ".TB_PREF."cust_allocations ca ON dt.type=trans_type_to AND dt.trans_no=trans_no_to
                LEFT JOIN ".TB_PREF."bank_trans bt ON trans_type_from=bt.type and trans_no_from=bt.trans_no
                LEFT JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id
                LEFT JOIN ".TB_PREF."cust_branch br ON br.branch_code=dt.branch_code
                LEFT JOIN ".TB_PREF."voided as v
                    ON dt.trans_no=v.id AND dt.type=v.type
            WHERE dt.type=".ST_SALESINVOICE;

	if ($tax_groups)
		$sql .= " AND br.tax_group_id IN (" . $tax_groups . ")";
	$sql .= " AND ISNULL(v.date_)"; // exclude voided transactions
	$sql .= " AND (ISNULL(bt.amount) OR bt.amount != 0)"; // exclude bank transactions that were voided and then reentered

    $sql .= " AND year(dt.tran_date) = year('" . $tran_date . "')";

    if ($sel_month>0)
        $sql .= " AND month(dt.tran_date) = " . $sel_month . "
        AND dayofmonth(dt.tran_date) = dayofmonth('" . $tran_date ."')";
    else if ($sel_month==0)
        $sql .= " AND month(dt.tran_date) = month('" . $tran_date . "')";
    $sql .= " GROUP BY bt.bank_act";

        $sql .= " UNION ALL
                SELECT count(*) as count,
                dt.tran_date,
                SUM(IFNULL(ca.amt*-1, (ov_amount+ov_freight+ov_discount+ov_gst) *-1)) as amount,
                ba.bank_account_name as payment_method
                FROM ".TB_PREF."debtor_trans dt
                LEFT JOIN ".TB_PREF."cust_allocations ca ON dt.type=trans_type_from AND dt.trans_no=trans_no_from
                LEFT JOIN ".TB_PREF."bank_trans bt ON trans_type_to=bt.type and trans_no_to=bt.trans_no
                LEFT JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id
                LEFT JOIN ".TB_PREF."cust_branch br ON br.branch_code=dt.branch_code
                LEFT JOIN ".TB_PREF."voided as v
                    ON dt.trans_no=v.id AND dt.type=v.type
            WHERE (dt.type=".ST_CUSTCREDIT . " OR dt.type=".ST_JOURNAL.")";
	if ($tax_groups)
		$sql .= " AND br.tax_group_id IN (" . $tax_groups . ")";
	$sql .= " AND ISNULL(v.date_)"; // exclude voided transactions
	$sql .= " AND (ISNULL(bt.amount) OR bt.amount != 0)"; // exclude bank transactions that were voided and then reentered

    $sql .= " AND year(dt.tran_date) = year('" . $tran_date . "')";

    if ($sel_month>0)
        $sql .= " AND month(dt.tran_date) = " . $sel_month . "
        AND dayofmonth(dt.tran_date) = dayofmonth('" . $tran_date ."')";
    else if ($sel_month == 0)
        $sql .= " AND month(dt.tran_date) = month('" . $tran_date . "')";
    $sql .= " GROUP BY bt.bank_act";

    $sql .= ") AS CUSTOM GROUP BY payment_method";

//    display_notification($sql);

    return db_query($sql,"No transactions were returned");
}

function getTaxTransactions($payment_type, $from, $sel_month, $tax_groups, $invert)
{
	$sql = "SELECT 

            dt.tran_date,
            monthname(dt.tran_date) row_month, year(dt.tran_date) row_year,
            month(dt.tran_date) i_month, dayofmonth(dt.tran_date) row_day, dayname(dt.tran_date) day_name,

			SUM(CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ov_amount+ov_freight+ov_discount)*-1 
			ELSE (ov_amount+ov_freight+ov_discount) END *dt.rate) AS total,
			SUM(CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ov_amount+ov_discount)*-1 
			ELSE (ov_amount+ov_discount) END *dt.rate) AS nf,
			SUM(CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ov_freight)*-1 
			ELSE (ov_freight) END *dt.rate) AS freight,
			SUM(CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ov_discount)*-1 
			ELSE (ov_discount) END *dt.rate) AS discounts

            FROM ".TB_PREF."debtor_trans dt
			LEFT JOIN ".TB_PREF."cust_branch br ON br.branch_code=dt.branch_code
            LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type";

    if ($payment_type != -1)
        $sql .= " LEFT JOIN ".TB_PREF."cust_allocations ca ON dt.type=trans_type_to AND dt.trans_no=trans_no_to
            LEFT JOIN ".TB_PREF."bank_trans bt ON trans_type_from=bt.type and trans_no_from=bt.trans_no
            LEFT JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id";

    $sql .= " WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT." OR dt.type=".ST_JOURNAL.") ";

    if ($payment_type != -1)
        $sql .= " AND ba.account_type = " . db_escape($payment_type);

	if ($tax_groups)
		$sql .= "AND br.tax_group_id IN (" . $tax_groups . ")";
	$sql .= " AND year(dt.tran_date) >= '" . $from . "'
            AND ISNULL(v.date_)"; // exclude voided transactions

if ($sel_month<>0) $sql .= " AND month(dt.tran_date) = " . $sel_month;
$sql .= " GROUP BY year(dt.tran_date), month(dt.tran_date)";
if ($sel_month<>0) $sql .= ", dayofmonth(dt.tran_date)";

$sql .=  " ORDER BY dt.tran_date ";
if (!$invert) $sql .= "ASC"; else $sql .= "DESC";


    // display_notification($sql);

    return db_query($sql,"No transactions were returned");
}

function getTaxes($payment_type, $tran_date, $sel_month, $tax_groups, $invert)
{
	$sql = "SELECT 

			SUM(CASE WHEN td.rate = 0 THEN
                CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (net_amount)*-1 
                ELSE (net_amount) END ELSE 0 END) AS nontaxed_sales,

			SUM(CASE WHEN td.rate != 0 THEN
                CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (net_amount)*-1 
                ELSE (net_amount) END ELSE 0 END) AS taxed_sales,

			SUM(CASE WHEN included_in_price = 1 THEN
                CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (td.amount)*-1 
                ELSE (td.amount) END *ex_rate ELSE 0 END) AS tax_included,

			SUM(CASE WHEN included_in_price = 0 THEN
                CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (td.amount)*-1 
                ELSE (td.amount) END *ex_rate ELSE 0 END) AS tax_added

            FROM ".TB_PREF."debtor_trans dt
			LEFT JOIN ".TB_PREF."debtors_master d ON d.debtor_no=dt.debtor_no
			LEFT JOIN ".TB_PREF."cust_branch br ON br.branch_code=dt.branch_code
			LEFT JOIN ".TB_PREF."tax_groups t ON br.tax_group_id=t.id
			LEFT JOIN ".TB_PREF."trans_tax_details td ON td.trans_type=dt.type AND td.trans_no=dt.trans_no
            LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type";

    if ($payment_type != -1)
        $sql .= " LEFT JOIN ".TB_PREF."cust_allocations ca ON dt.type=trans_type_to AND dt.trans_no=trans_no_to
            LEFT JOIN ".TB_PREF."bank_trans bt ON trans_type_from=bt.type and trans_no_from=bt.trans_no
            LEFT JOIN ".TB_PREF."bank_accounts ba ON bt.bank_act = ba.id";

    $sql .= " WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.") ";

    if ($payment_type != -1)
        $sql .= " AND ba.account_type = " . db_escape($payment_type);

	if ($tax_groups)
		$sql .= "AND br.tax_group_id IN (" . $tax_groups . ")";
	$sql .= " 
            AND ISNULL(v.date_)"; // exclude voided transactions

    $sql .= " AND year(dt.tran_date) = year('" . $tran_date . "')";

    if ($sel_month<>0)
        $sql .= " AND month(dt.tran_date) = " . $sel_month . "
        AND dayofmonth(dt.tran_date) = dayofmonth('" . $tran_date ."')";
    else
        $sql .= " AND month(dt.tran_date) = month('" . $tran_date . "')";

//    display_notification($sql);
    return db_query($sql,"No transactions were returned");
}

function compare_graph($sel_month, $pg)
{
    // display_notification(print_r($pg_years, true));
    // display_notification(print_r($pg, true));

    $today = Today();
    $title = "Sales Comparison";

    dashboard("custom");
    source_graphic($today, $title, ($sel_month == 0 ? _("Month") : _("Day")), $pg);
}



//----------------------------------------------------------------------------------------------------


    $taxgroup = array();
    if (isset($_POST['taxgroup']))
        $taxgroup = $_POST['taxgroup'];
    else if (isset($_GET['tax_groups'])) {
        $taxgroup = $_GET['tax_groups'];
        $_POST['taxgroup'] = $taxgroup;
    }

    // display_notification(print_r($taxgroup, true));

//
// entry for popup display of tax detail
if (isset($_GET['show'])) {
	$ot_type = $_GET['show'];

    $bank_trans = getBankTransactions($_GET['tran_date'], $_GET['sel_month'], implode(",", $taxgroup));

    start_table(TABLESTYLE);
    label_cell($_GET['tran_date'], "colspan=7 align='center'");
    end_row();

    $th = array(_("Payment Type"),  _("Amount"), _("Number Of Orders"), _("$$ Per Order"));
    table_header($th);

    $k = 0;
    $total = 0;
    $total_count = 0;
	while ($detail_line = db_fetch($bank_trans)) {
        alt_table_row_color($k);
		if ($ot_type == "ot_total") {
			label_cell(($detail_line['payment_method'] == '' ? "Unpaid/Unallocated" : $detail_line['payment_method']));
            amount_cell($detail_line['amount']);
            qty_cell($detail_line['count'], false, 0);
            amount_cell($detail_line['amount']/$detail_line['count']);
		} else
			echo "<td align=left width='75%'>" . $detail_line['description'] . "</td><td align=right>" . number_format($detail_line['amount'],2) . "</td></tr>";
        $total += $detail_line['amount'];
        $total_count += $detail_line['count'];
        end_row();
	}
    alt_table_row_color($k);
    label_cell("TOTAL");
    amount_cell($total);
    qty_cell($total_count, false, 0);
    end_row();
    end_table();
    end_page();
    exit();
};

//
// main entry for report display
// set printer-friendly toggle
if (@$_GET['print']=='yes') $print=true; else $print=false;
// set inversion toggle
if (@$_GET['invert']=='yes') $invert=true; else $invert=false;

$invert=true;

// detect whether this is monthly detail request
    $sel_month = @$_GET['month'];

    start_form();
    start_table(TABLESTYLE);
    $transactions = getYears();
    while ($years=db_fetch($transactions)) {
        $years_array[$years['row_year']] = $years['row_year'];
        $max_year = $years['row_year'];
    }
    if (isset($_POST['year']))
        $default_year = $_POST['year'];
    else
        $default_year = $max_year;

    menu_list_cells('year', 'year', $default_year, $years_array, false);

    $_POST['payment_type'] = -1;
/*
    $payment_types[$_POST['payment_type']] = "All";
    foreach ($bank_transfer_types as $b)
        $payment_types[] = $b;
    menu_list_row('payment_type', 'payment_type', null, $payment_types, false);
*/

// Ajax breaks tax groups filter array
    submit_cells('Show',_("Show"));
    end_table();

    start_table(TABLESTYLE);
    $th = array(_("Tax Group"), _("Filter"));
    table_header($th);

    // tax_groups_list_cells('Tax_group', 'tax_group_id', null, 'All Groups', true);
    $taxgroups = getTaxGroups();
    while ($tg = db_fetch($taxgroups)) {
        check_row($tg['name'], "taxgroup[]", $tg['id']);
    }
    end_table();
    end_form();




div_start('sales_tbl');
start_table(TABLESTYLE);

$th = array(_("Month"));

if ($sel_month != 0)
    $th = array_merge($th, array(_("Day"), _("Day")));
else
    $th = array_merge($th, array( _("Year")));

$th = array_merge($th, array(_("Total"), _("Total ex Freight"), _("Total ex Tax"),
    _("Non-taxed Sales"), _("Taxed Sales"), _("Taxes Collected"), _("Freight"), _("Order Adjust")));

table_header($th);

// clear footer totals
	$footer_gross = 0;
	$footer_nf = 0;
	$footer_sales = 0;
	$footer_sales_nontaxed = 0;
	$footer_sales_taxed = 0;
	$footer_tax_coll = 0;
	$footer_shiphndl = 0;
	$footer_custom = 0;
	$footer_other = 0;

//
// loop here for each row reported
$rows=0;
$transactions = getTaxTransactions($_POST['payment_type'], $default_year, $sel_month, implode(",", $taxgroup), $invert);
$num_rows=db_num_rows($transactions);
$k = 0;
    $pg = new chart('bar', 'd1');
    if (isset($_POST['select_d1']))
        $pg->type = $_POST['select_d1'];

$pg_years=array();
$pgx=array();
while ($sales=db_fetch($transactions)) {
   alt_table_row_color($k);
	$rows++;

    $taxes = db_fetch(getTaxes($_POST['payment_type'], $sales['tran_date'], $sel_month, implode(",", $taxgroup), $invert));

    $sales['gross_sales'] = $sales['total'] + $taxes['tax_added'];
    $sales['nf'] = $sales['nf'] + $taxes['tax_added'];
    $sales['net_sales'] = $sales['total'] - $taxes['tax_included'];
    $sales['tax_coll'] = $taxes['tax_added'] + $taxes['tax_included'];

	if ($rows>1 && $sales['row_year']<>$last_row_year) {  // emit annual footer
?>
<td class="dataTableHeadingContent" align="left">
<?php 
	if ($last_row_year==date("Y")) mirror_out("YTD"); 
	else 
		if ($sel_month==0) mirror_out("YEAR");
		else {
			mirror_out(strtoupper(substr($sales['row_month'],0,3)));

?>
</td>
<td class="dataTableHeadingContent" align="left">
</td>
<?php
}
?>
<td class="dataTableHeadingContent" align="left">
<?php mirror_out($last_row_year); ?></td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_gross,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_nf,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales_nontaxed,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales_taxed,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_tax_coll,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_shiphndl,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_custom,2)); ?>
</td>
<?php

// clear footer totals
$footer_gross = 0;
$footer_nf = 0;
$footer_sales = 0;
$footer_sales_nontaxed = 0;
$footer_sales_taxed = 0;
$footer_tax_coll = 0;
$footer_shiphndl = 0;
$footer_custom = 0;
$footer_other = 0;

end_row();
};


//
// accumulate row results in footer
	$footer_gross += $sales['gross_sales'];
	$footer_nf += $sales['nf'];
	$footer_sales += $sales['net_sales'];
	$footer_sales_nontaxed += $taxes['nontaxed_sales'];
	$footer_sales_taxed += $taxes['taxed_sales'];
	$footer_tax_coll += $sales['tax_coll'];
	$footer_shiphndl += $sales['freight'];

    if (!in_array($sales['row_year'], $pg_years) ) {
        $pg_years[] = $sales['row_year'];

// zero out all months/days for years with missing data
// this prevents php errors in graphic

        if ($sel_month==0)
            for ($i=0; $i<12; $i++)
                $pgz[$sales['row_year']][$i] = 0;
        else
            for ($i=0; $i<31; $i++)
                $pgz[$sales['row_year']][$i] = 0;
    }

    if (!isset($pg_years[1])) {
        if ($sel_month==0)
            $pgx[] = strtoupper(substr($sales['row_month'],0,3));
        else
            $pgx[] = $sales['row_day'];
        $pgy[] = $sales['gross_sales'];
    } else {
        if ($sel_month==0) {
            $key = array_search(strtoupper(substr($sales['row_month'],0,3)), $pgx);
            if ($key === FALSE) {
                $pgx[] = strtoupper(substr($sales['row_month'],0,3));
                $pgy[] = 0;
                $key = array_key_last($pgx);
            }
        } else {
            $key = array_search($sales['row_day'], $pgx);
            if ($key === FALSE) {
                $pgx[] = $sales['row_day'];
                $pgy[] = 0;
                $key = array_key_last($pgx);
            }
        }
        $pgz[$sales['row_year']][$key] = $sales['gross_sales'];
    }

?>
<td class="dataTableContent" align="left">
<?php  // live link to report monthly detail
if ($sel_month == 0	&& !$print) {
	echo "<a href='" . $_SERVER['PHP_SELF'] . "?" . http_build_query(array('tax_groups' => $taxgroup)) . "&month=" . $sales['i_month'] . "&year=" . $_POST['year'] . "&payment_type=" . $_POST['payment_type'] . "' title='" . "TEXT_BUTTON_REPORT_GET_DETAIL" . "'>";
	}
mirror_out(substr($sales['row_month'],0,3)); 
if ($sel_month == 0 && !$print) echo '</a>';
?>
</td>
<td class="dataTableContent" align="left">
<?php 
if ($sel_month==0) mirror_out($sales['row_year']);
else {
	mirror_out($sales['row_day']);
?>
</td>
<td class="dataTableContent" align="left">
<?php 
	mirror_out(substr($sales['day_name'],0,3));
}
$last_row_year = $sales['row_year']; // save this row's year to check for annual footer
?>
</td>
<td class="dataTableContent" width='70' align="right">
<?php 
	// make this a link to the detail popup if nonzero
	if (!$print && ($sales['gross_sales']>0)) {
		echo "<a href=\"#\" onClick=\"window.open('" . $_SERVER['PHP_SELF'] . "?&show=ot_total&tran_date=" . $sales['tran_date'] . "&sel_month=" . $sel_month;
		if ($taxgroup<>array()) echo "&" . http_build_query(array('tax_groups' => $taxgroup));
		echo "','detail',config='height=400,width=800,scrollbars=1, resizable=1')\" title=\"Show detail\">";
	};
	mirror_out(number_format($sales['gross_sales'],2)); 
	if (!$print && $sales['gross_sales']>0) echo "</a>";
?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($sales['nf'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($sales['net_sales'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($taxes['nontaxed_sales'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($taxes['taxed_sales'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($sales['tax_coll'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($sales['freight'],2)); ?></td>
<td class="dataTableContent" width='70' align="right"><?php mirror_out(number_format($sales['discounts'],2)); ?></td>
<?php 

end_row();



//
//
// output footer below ending row
if ($rows==$num_rows){
?>
<tr class="dataTableHeadingRow">
<td class="dataTableHeadingContent" align="left">
<?php 
	if ($sel_month<>0) {
	mirror_out(strtoupper(substr($sales['row_month'],0,3)));
?>
</td>
<td class="dataTableHeadingContent" align="left">
</td>
<?php
	} else {
        if ($last_row_year==date("Y"))
            mirror_out("YTD"); 
         else mirror_out("YEAR");
    };
?>
</td>
<td class="dataTableHeadingContent" align="left">
<?php mirror_out($sales['row_year']); ?></td>

<td class="dataTableHeadingContent" width='70' align="right">
<?php
// make this a link to the detail popup if nonzero
if (!$print && ($footer_gross>0)) {
	echo "<a href=\"#\" onClick=\"window.open('" . $_SERVER['PHP_SELF'] . "?&show=ot_total&tran_date=" . $sales['tran_date'];
	if ($sel_month<>0) echo "&sel_month=0";
    else echo "&sel_month=-1";
	if ($taxgroup<>array()) echo "&" . http_build_query(array('tax_groups' => $taxgroup));
	echo "','detail',config='height=400,width=800,scrollbars=1, resizable=1')\" title=\"Show detail\">";
};
mirror_out(number_format($footer_gross,2));
if (!$print && $footer_gross>0) echo "</a>";
?>
</td>

<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_nf,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales_nontaxed,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_sales_taxed,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_tax_coll,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_shiphndl,2)); ?>
</td>
<td class="dataTableHeadingContent" width='70' align="right">
<?php mirror_out(number_format($footer_custom,2)); ?>
</td>
<?php
// clear footer totals
$footer_gross = 0;
$footer_nf = 0;
$footer_sales = 0;
$footer_sales_nontaxed = 0;
$footer_sales_taxed = 0;
$footer_tax_coll = 0;
$footer_shiphndl = 0;
$footer_custom = 0;
$footer_other = 0;
?>
</tr>
<?php };
  };

end_table();

if (isset($pg_years[1])) {
$pg->setLabels($pgx);
$pg->addSerie($pg_years[0], $pgy);
for ($i = 1; isset($pg_years[$i]); $i++)
    $pg->addSerie($pg_years[$i], $pgz[$pg_years[$i]]);

compare_graph($sel_month, $pg);
}

div_end();
end_page();


function mirror_out ($field) {
	echo $field;
	return;
}


