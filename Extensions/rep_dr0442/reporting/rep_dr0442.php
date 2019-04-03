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
// $ Revision:    2.2 $
// Creator:    Joe Hunt - Based on the new Report Engine by Tom Hallman
// Creator:    Based on Tom Hallman's Report.
// Date:    2010-03-03
// Title:    Printable Check
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/modules/tax_rate/get_tax_rate.inc");

define("ACCOUNT_NUMBER", '01514419-0001');
define("FEIN", '84-1457020');
define("CUSTOMER_GROUP_CHARITY", 'Government, Religious Or Charity');
define("PRECISION",2); // force totals to round to whole numbers
define("TAX_GROUP_PHYSICAL",'1'); // physical location
define("TAX_GROUP_EXEMPT_WHOLESALE",'2');
define("TAX_GROUP_THORNTON",'4');
define("TAX_GROUP_COLORADO",'5'); // non-physical locations
define("TAX_GROUP_DOUGLAS_COUNTY",'7');
define("TAX_GROUP_EXEMPT_OOS",'8');
define("TAX_GROUP_EXEMPT_CHARITY",'10');
define("TAX_GROUP_EXEMPT_USE",'11');

//----------------------------------------------------------------------------------------------------

print_dr0442();

function getLiters($from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql = "SELECT
        SUM(IF(
            sm.type=".ST_INVADJUST.",
                sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75),
            0)) AS adj_liters,
        SUM(IF(
            sm.type=".ST_WORKORDER.",
                sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75),
            0)) AS mfg_liters,
        SUM(IF(
            sm.type!=".ST_WORKORDER." AND sm.type!=".ST_INVADJUST.",
                sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75),
            0)) AS liters
        FROM ".TB_PREF."stock_moves sm
            LEFT JOIN ".TB_PREF."stock_master item ON sm.stock_id=item.stock_id
            WHERE tran_date BETWEEN '$fromdate' AND '$todate'
                AND item.category_id=36";
//display_notification($sql);

    return db_query($sql,"No transactions were returned");

}

function getInvLiters($d, $include=false)
{
    $d = date2sql($d);

    $sql = "SELECT
        SUM(sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75)) AS liters
        FROM ".TB_PREF."stock_moves sm
            LEFT JOIN ".TB_PREF."stock_master item ON sm.stock_id=item.stock_id
                WHERE item.category_id=36";
    if ($include)
        $sql .= " AND tran_date <= '$d'";
    else
        $sql .= " AND tran_date < '$d'";

//display_notification($sql);
    return db_query($sql,"No transactions were returned");

}

function getExportLiters($from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql = "SELECT
        SUM(sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75)) AS liters
        FROM ".TB_PREF."stock_moves sm
            LEFT JOIN ".TB_PREF."stock_master item ON sm.stock_id=item.stock_id
            LEFT JOIN ".TB_PREF."debtor_trans t ON t.trans_no=sm.trans_no AND t.type=sm.type
            LEFT JOIN ".TB_PREF."cust_branch cb ON cb.debtor_no=t.debtor_no AND cb.branch_code=t.branch_code
            WHERE sm.tran_date BETWEEN '$fromdate' AND '$todate'
                AND item.category_id=36
                AND tax_group_id IN ('8','3')";

//display_notification($sql);
    return db_query($sql,"No transactions were returned");

}

function getExportSales($from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql = "SELECT
        sm.tran_date,
        cb.*,
        tg.name as state,
        t.order_,
        so.deliver_to,
        SUM(sm.qty*IF(LOCATE('wt:2.0', item.long_description) != 0,.375,.75)) AS liters
        FROM ".TB_PREF."stock_moves sm
            LEFT JOIN ".TB_PREF."stock_master item ON sm.stock_id=item.stock_id
            LEFT JOIN ".TB_PREF."debtor_trans t ON t.trans_no=sm.trans_no AND t.type=sm.type
            LEFT JOIN ".TB_PREF."sales_orders so ON so.order_no=t.order_ AND so.trans_type=".ST_SALESORDER."
            LEFT JOIN ".TB_PREF."cust_branch cb ON cb.debtor_no=t.debtor_no AND cb.branch_code=t.branch_code
            LEFT JOIN ".TB_PREF."tax_groups tg ON cb.tax_group_id=tg.id
            WHERE sm.tran_date BETWEEN '$fromdate' AND '$todate'
                AND item.category_id=36
                AND cb.tax_group_id IN ('8','3')
            GROUP BY t.order_
            ORDER BY cb.tax_group_id, tg.name";

//display_notification($sql);
    return db_query($sql,"No transactions were returned");

}


//----------------------------------------------------------------------------------------------------

function print_dr0442()
{
    global $path_to_root;

    // Get the payment
    $period = $_POST['PARAM_0'];
    $beg_inv = $_POST['PARAM_1'];
    $grape_tons = $_POST['PARAM_2'];

    $from_date = substr($period,5,2) . "/01/" . substr($period,0,4);
    $to_date = substr($from_date,0,3) . "31" . substr($from_date,5);
    $dec = user_price_dec();

    include_once($path_to_root . "/reporting/includes/pdf_report.inc");

    $rep = new FrontReport(_('DR0442 Summary Report'), "DR0442SummaryReport", user_pagesize(), 9, 'P');

    $params =   array(0 => '', 
                      1 => array('text' => _('Period'), 'from' => $from_date, 'to' => $to_date));

    $cols = array(0, 200, 230, 330, 430);

    $headers = array(_('Location'), _('Jurisdiction'), _('Self-Collected'), _('State-Collected'));
    $aligns = array('left', 'left', 'right', 'right');

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();



$formfile= $path_to_root . '/tmp/newform.ps';
$handle = fopen($formfile, 'w');
if ($handle) {

define('CUSTOMER_ID_INVENTORY_ADJ', '71');
define('CUSTOMER_ID_MANUFACTURED_WINE', '73');
define('CATEGORY_ID_WINE', '21');
define('SALES_ORDER', '2');

$sm = db_fetch(getLiters($from_date, $to_date));

if ($beg_inv == '') {
    $inv = db_fetch(getInvLiters($from_date));
    $beg_inv = $inv['liters'];
}

$end_inv = db_fetch(getInvLiters($to_date, true));
$actual_totalliters = $beg_inv - $end_inv['liters'] + $sm['mfg_liters'];


$export = db_fetch(getExportLiters($from_date, $to_date));
$export_liters=-$export['liters'];

// we need to determine the amount sold since July 1 in order to determine
// how much excise tax to pay.  This could be inaccurate if prior forms have
// be overridden.  The data that we have is in the database, not what
// was told to the tax authority on the paper forms

$year = substr($period,0,4);
if (substr($period,5,2) < '07')
    $year--;

$july_start_date = "07/01/" . $year;
$july = db_fetch(getLiters($july_start_date, $to_date));
$july_export = db_fetch(getExportLiters($july_start_date, $to_date));

   $actual_totalliters_03=0;
   $actual_totalliters_05=0;

   if (-$july['liters'] + $july_export['liters'] > 9000) {
    if (-$july['liters']  + $july_export['liters'] - ($actual_totalliters - $export_liters) > 9000) {
        // all is .03
        $actual_totalliters_03 = $actual_totalliters - $export_liters;
    } else {
        $actual_totalliters_03 = -$july['liters']  + $july_export['liters'] - 9000;
        $actual_totalliters_05 = 9000 - (-$july['liters']  + $july_export['liters'] - ($actual_totalliters - $export_liters));
    }
    } else {
        $actual_totalliters_05=$actual_totalliters - $export_liters;
    }


   $tax_due = number_format(round(($actual_totalliters-$export_liters)*.0733,2) +
		round(($actual_totalliters-$export_liters)*.01,2) +
		round($actual_totalliters_05*.05,2) +
		round($actual_totalliters_03*.03,2) +
		round($grape_tons*10,2), 2, '.', ',');

    $duedate=date("m-20-y", mktime(0,0,0,(int)substr($period,5,2),20,(int)substr($period,0,4))+60*60*24*30);


    $annote = array(
	array('x' => 1, 'y' => 8.1, 'text' => 'WHITEWATER HILL VINEYARDS'),
	array('x' => 1, 'y' => 7.7, 'text' => '130 31 ROAD'),
	array('x' => 4, 'y' => 7.7, 'text' => 'GRAND JUNCTION'),
	array('x' => 6.8, 'y' => 7.7, 'text' => 'CO 81503-9642'),
	array('x' => 1, 'y' => 7.35, 'text' => ACCOUNT_NUMBER),
	array('x' => 4.7, 'y' => 7.35, 'text' => $period),
	array('x' => 7, 'y' => 7.35, 'text' => $duedate),
	array('x' => 4, 'y' => 7.0, 'text' => FEIN),
	array('x' => 3.4, 'y' => 5.9, 'text' => $beg_inv), // beginning inventory
	array('x' => 4.5, 'y' => 5.9, 'text' => 'N/A'), // beginning inventory
	array('x' => 5.5, 'y' => 5.9, 'text' => 'N/A'), // beginning inventory
	array('x' => 6.5, 'y' => 5.9, 'text' => 'N/A'), // beginning inventory
	array('x' => 7.5, 'y' => 5.9, 'text' => 'N/A'), // beginning inventory
	array('x' => 3.4, 'y' => 5.5, 'text' => $sm['mfg_liters']), // manufactured in Colorado
	array('x' => 3.4, 'y' => 5, 'text' => '0'),
	array('x' => 3.4, 'y' => 4.7, 'text' => '0'),
	array('x' => 3.4, 'y' => 4.4, 'text' => $beg_inv + $sm['mfg_liters']), // total
	array('x' => 3.4, 'y' => 4, 'text' => $end_inv['liters']), // ending inventory 
	array('x' => 3.4, 'y' => 3.65, 'text' => $actual_totalliters), // beginning - ending inventory
	array('x' => 3.4, 'y' => 3.45, 'text' => $export_liters),
	array('x' => 3.4, 'y' => 3.05, 'text' => '0'),
	array('x' => 3.4, 'y' => 2.85, 'text' => '0'),
	array('x' => 3.4, 'y' => 2.35, 'text' => $export_liters),
	array('x' => 3.4, 'y' => 2.0, 'text' => $actual_totalliters-$export_liters), // taxable sales
	array('x' => 3.4, 'y' => 1.8, 'text' => '0'), // taxable sales
	array('x' => 3.4, 'y' => 1.4, 'text' => $actual_totalliters-$export_liters) // tax due sales
 );

    $annote2 = array(
	array('x' => 3.6, 'y' => 8.85, 'text' => number_format(($actual_totalliters-$export_liters)*.0733,2,'.',',')),
	array('x' => 3.6, 'y' => 8.5, 'text' => number_format(($actual_totalliters-$export_liters)*.01,2,'.',',')),
	array('x' => 2.4, 'y' => 7.9, 'text' => $actual_totalliters-$export_liters), // tax due sales
	array('x' => 3.6, 'y' => 7.9, 'text' => number_format($actual_totalliters_05*.05 + $actual_totalliters_03*.03,2,'.',',')),
	array('x' => 3.6, 'y' => 7.55, 'text' => number_format($grape_tons*10,2,'.',',')),
	array('x' => 3.7, 'y' => 7, 'text' => $tax_due),
	array('x' => 5.3, 'y' => 7, 'text' => $actual_totalliters_03 . ' liters @.03, ' . $actual_totalliters_05 . ' liters @.05'),
	array('x' => 3.7, 'y' => 5.9, 'text' => $tax_due)
   );



  $rows = 0;
  $exports = getExportSales($from_date, $to_date);

  $state = '';
  $page = 1;
  $total = 0;
  while ($row = db_fetch($exports)) {
    $rows ++;
    if ($state != $row['state']) {
        $state = $row['state'];
        $page++;
        $rows = 1;
        $i = 0;
        $annote_export[$page][$i++] = array('x' => 1, 'y' => 9.0, 'text' => 'Whitewater Hill Vineyards');
        $annote_export[$page][$i++] = array('x' => 4.3, 'y' => 9.0, 'text' => ACCOUNT_NUMBER);
        $annote_export[$page][$i++] = array('x' => 6.5, 'y' => 9.0, 'text' => $period);
        $annote_export[$page][$i++] = array('x' => 4.3, 'y' => 8.8, 'text' => $state);
        $annote_export[$page][$i++] = array('x' => .7, 'y' => 8.3, 'text' => 'X');
    }
    $line = 7.9 - $rows * .23;
    $annote_export[$page][$i++] = array('x' => .5, 'y' => $line, 'text' => $row['tran_date']);
    $annote_export[$page][$i++] = array('x' => 1.5, 'y' => $line, 'text' => $row['deliver_to']);
    $annote_export[$page][$i++] = array('x' => 4.3, 'y' => $line, 'text' => $row['order_']);
    $annote_export[$page][$i++] = array('x' => 6.5, 'y' => $line, 'text' => -$row['liters']);
    $total -= $row['liters'];
  }
  $annote_export[$page][$i++] = array('x' => 6.5, 'y' => 1.1, 'text' => $total);

fputs($handle, '
%!PS
% Written by Helge Blischke, see
% http://groups.google.com/groups?ic=1&selm=3964A684.49D%40srz-berlin.de
%
% The following 2 procs encapsulate the jobs to be processed
% much as is done with EPS images:
/_begin_job_
{
        /tweak_save save def
        /tweak_dc countdictstack def
        /tweak_oc count 1 sub def
        userdict begin
}bind def

/_end_job_
{
        count tweak_oc sub{pop}repeat
        countdictstack tweak_dc sub{end}repeat
        tweak_save restore
}bind def

% Now, add your jobs like this:
_begin_job_
');

	   // copy excise tax form
	   $handleform = fopen('../modules/rep_dr0442/reporting/forms/dr0442p1.ps', 'r');
	   if ($handleform) {
	     while (!feof($handleform)) {
	       $buffer = fgets($handleform, 4096);
		$i = strpos($buffer, 'startpage');
                if ($i === false)
                        $i = strpos($buffer, '%%BeginProlog');
		if ($i !== false) {
			// annotate
			fwrite($handle, $buffer, $i-1);
			foreach ($annote as $value) {
			   fputs($handle, "gsave %matrix defaultmatrix setmatrix\n 0 rotate " . $value['x']*72 . " " . $value['y']*72 . " moveto /Times-Roman findfont 12 scalefont setfont 0.400000 setgray (" . $value['text'] . ") show grestore\n");
			}
			fwrite($handle, substr($buffer, $i));
		}
		else {
			fwrite($handle, $buffer, 4096);
		}
	     } // while
	     fclose($handleform);
	   } // end of handleform

	   fputs($handle, '_end_job_
');
		     fputs($handle, '_begin_job_
');
	   // copy excise tax form page 2
	   $handleform = fopen('../modules/rep_dr0442/reporting/forms/dr0442p2.ps', 'r');
	   if ($handleform) {
	     while (!feof($handleform)) {
	       $buffer = fgets($handleform, 4096);
		$i = strpos($buffer, 'startpage');
                if ($i === false)
                        $i = strpos($buffer, '%%BeginProlog');
		if ($i !== false) {
			// annotate
			fwrite($handle, $buffer, $i-1);
			foreach ($annote2 as $value) {
			   fputs($handle, "gsave %matrix defaultmatrix setmatrix\n 0 rotate " . $value['x']*72 . " " . $value['y']*72 . " moveto /Times-Roman findfont 12 scalefont setfont 0.400000 setgray (" . $value['text'] . ") show grestore\n");
			}
			fwrite($handle, substr($buffer, $i));
		}
		else {
			fwrite($handle, $buffer, 4096);
		}
	     } // while
	     fclose($handleform);
	   } // end of handleform

	   fputs($handle, '_end_job_
');

	   if ($export_liters != 0) {
		// copy export tax form
		foreach ($annote_export as $page => $item) {
		     fputs($handle, '_begin_job_
');
		     $handleform = fopen('../modules/rep_dr0442/reporting/forms/dr0443.ps', 'r');
		     if ($handleform) {
			while (!feof($handleform)) {
			   $buffer = fgets($handleform, 4096);

			   $i = strpos($buffer, '%%BeginProlog');
			   if ($i !== false) {
				// annotate
				fwrite($handle, $buffer, $i-1);
				foreach ($item as $value) {
				   fputs($handle, "gsave %matrix defaultmatrix setmatrix\n 0 rotate " . $value['x']*72 . " " . $value['y']*72 . " moveto /Times-Roman findfont 12 scalefont setfont 0.400000 setgray (" . $value['text'] . ") show grestore\n");
				} // foreach
				fwrite($handle, substr($buffer, $i));
			    } else {
				fwrite($handle, $buffer, 4096);
			    } // $i != 0
			} // while
			fclose($handleform);
		     } // end of handleform
		     fputs($handle, '_end_job_
');
		   } // foreach
		} // end of export sales


	     fclose($handle);
     } else { // end of handle
	print "Unable to write " . $formfile;
	die();
     }



/*


    $rep->NewLine();
    $rep->TextCol(0, 1, 'TOTAL DUE STATE');
    $rep->AmountCol(3, 4, $total, $dec);

   $rep->end();
*/


   exec("ps2pdf $path_to_root/tmp/newform.ps $path_to_root/tmp/newform.pdf");
   meta_forward($path_to_root . "/tmp/newform.pdf");
}
?>



