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

define("FEIN", '84-1457020');
define("CUSTOMER_GROUP_CHARITY", 'Government, Religious Or Charity');
define("TAX_GROUP_EXEMPT_WHOLESALE",'2');
define("TAX_GROUP_THORNTON",'4');
define("TAX_GROUP_COLORADO",'5'); // non-physical locations
define("TAX_GROUP_DOUGLAS_COUNTY",'7');
define("TAX_GROUP_EXEMPT_OOS",'8');
define("TAX_GROUP_EXEMPT_CHARITY",'10');
define("TAX_GROUP_EXEMPT_WINEMAKERS",'11');
define("TAX_GROUP_EXEMPT_USE",'11');

//----------------------------------------------------------------------------------------------------

$sites=array();
read_sites();

$eventids=array();
read_eventids();

print_dr0100();

// sites are just extra useless data the DOR wants
// https://www.colorado.gov/pacific/tax/sales-and-use-tax-rates-lookup
function read_sites()
{
   global $path_to_root, $sites;
   $csv = array_map('str_getcsv', file($path_to_root . "/modules/rep_dr0100/reporting" . "/wwhsitenumbers.csv"));
   foreach ($csv[0] as $key =>$value)
    $csv[0][$key]=preg_replace( '/\s*/m', '',$value);

    array_walk($csv, function(&$a) use ($csv) {
      $a = array_combine($csv[0], $a);
    });

    array_shift($csv); # remove column header
    // display_notification(print_r($csv, true));

    foreach ($csv as $value) {
        $location=trim($value['LocationCode']);
        $sites[$location] = $value;
    }

    //display_notification(print_r($sites, true));
}

// event ids are just more extra useless data the DOR wants
// GO to Verify a License or Certificate
// Verify a single license
// CAN or Location ID: 02768867

function read_eventids()
{
   global $path_to_root, $eventids;
   $csv = array_map('str_getcsv', file($path_to_root . "/modules/rep_dr0100/reporting" . "/wwheventids.csv"));
   foreach ($csv[0] as $key =>$value)
    $csv[0][$key]=preg_replace( '/\s*/m', '',$value);

    array_walk($csv, function(&$a) use ($csv) {
      $a = array_combine($csv[0], $a);
    });

    array_shift($csv); # remove column header
    // display_notification(print_r($csv, true));

    foreach ($csv as $value) {
        $address=trim($value['Address']);
        $start = strpos($address, ",")+2;
        $end = strpos($address, ",", $start);
        $address=substr($address, $start, $end-$start);
        $eventids[$address] = $value;
    }

    // display_notification(print_r($eventids, true));
}


// Note: food includes grape sales, import adjustments, credit card testing
function GetPhysicalSales($from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql= "SELECT
            'Physical Location' as description,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_WINEMAKERS.")
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS net,

            SUM(CASE WHEN cb.tax_group_id=".TAX_GROUP_EXEMPT_WHOLESALE."
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END) AS tax_exempt,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_WHOLESALE.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.")
                AND a.description != 'Grand Junction'
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS oota,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_WHOLESALE.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_COLORADO.")
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS ootac,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_OOS.","
                    .TAX_GROUP_EXEMPT_USE.","
                    .TAX_GROUP_EXEMPT_CHARITY.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_EXEMPT_WHOLESALE.")
                 AND ttd.tax_type_id=0 THEN ttd.net_amount ELSE 0 END),2) AS food,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_OOS.","
                    .TAX_GROUP_EXEMPT_USE.","
                    .TAX_GROUP_EXEMPT_CHARITY.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_EXEMPT_WHOLESALE.")
                AND ttd.tax_type_id=2 THEN ttd.net_amount ELSE 0 END),2) AS candy

        FROM ".TB_PREF."debtor_trans dt
        LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type
        LEFT JOIN ".TB_PREF."cust_branch cb ON cb.branch_code = dt.branch_code
        LEFT JOIN ".TB_PREF."areas a ON cb.area = a.area_code
        LEFT JOIN ".TB_PREF."trans_tax_details ttd ON ttd.trans_type=dt.type AND ttd.trans_no=dt.trans_no
        WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.")
            AND ISNULL(v.date_)
            AND dt.tran_date >='$fromdate'
            AND dt.tran_date <='$todate'";

//display_notification($sql);

    return db_query($sql, "Error getting order details");
}

function GetNonPhysicalSales($period, $from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql= "SELECT
            substring_index(
                LEFT(
                    IF(delivery_address!='',delivery_address,br_address),
                    LENGTH(IF(delivery_address!='',delivery_address,br_address)) -
                        LOCATE(',', REVERSE(IF(delivery_address!='',delivery_address,br_address)))),
                '\n', -1) AS location,
            a.description,

            SUM(CASE WHEN dt.type=".ST_CUSTCREDIT."
                THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) AS net,
            0 AS tax_exempt, 0 AS oota, 0 as ootac,

            ROUND(SUM(CASE WHEN ttd.tax_type_id=0 THEN ttd.net_amount ELSE 0 END),2) AS food,

            ROUND(SUM(CASE WHEN ttd.tax_type_id=2 THEN ttd.net_amount ELSE 0 END),2) AS candy

        FROM ".TB_PREF."debtor_trans dt
        LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type
        LEFT JOIN ".TB_PREF."cust_branch cb ON cb.branch_code = dt.branch_code
        LEFT JOIN ".TB_PREF."areas a ON cb.area = a.area_code
        LEFT JOIN ".TB_PREF."sales_orders so ON so.order_no = dt.order_
        LEFT JOIN ".TB_PREF."trans_tax_details ttd ON ttd.trans_type=dt.type AND ttd.trans_no=dt.trans_no
        WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.")
            AND ISNULL(v.date_)
            AND dt.tran_date >='$fromdate'
            AND dt.tran_date <='$todate'
            AND a.description NOT IN (
                ".($period >= "2019-06" ? '' : 'Colorado'). "
                'Grand Junction',
                'California',
                'Out-of-state')
            AND cb.tax_group_id != '". TAX_GROUP_EXEMPT_CHARITY."'
            AND cb.tax_group_id != '". TAX_GROUP_EXEMPT_WHOLESALE."'
            AND cb.tax_group_id != '". TAX_GROUP_EXEMPT_USE."'
        GROUP BY location, a.description";

//display_notification($sql);
    return db_query($sql, "Error getting order details");
}

//----------------------------------------------------------------------------------------------------

function print_dr0100()
{
    global $path_to_root, $sites, $eventids;

    // Get the payment
    $period = $_POST['PARAM_0'];
    $dr0098 = $_POST['PARAM_1'];
    $from_date = substr($period,5,2) . "/01/" . substr($period,0,4);
    $to_date = substr($from_date,0,3) . "31" . substr($from_date,5);
    $dec = user_price_dec();

    include_once($path_to_root . "/reporting/includes/pdf_report.inc");

    $rep = new FrontReport(_('DR0100 Summary Report'), "DR0100SummaryReport", user_pagesize(), 9, 'P');

    $params =   array(0 => '', 
                      1 => array('text' => _('Period'), 'from' => $from_date, 'to' => $to_date));

    $cols = array(0, 80, 250, 330, 430, 530);

    $headers = array(_('Area'), _('Location'), _('Account No.'), _('Self-Collected'), _('State-Collected'));
    $aligns = array('left', 'left', 'left', 'right', 'right');

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

$formfile= $path_to_root . '/tmp/newform.ps';
$handle = fopen($formfile, 'w');
if ($handle) {

$nonphys = GetNonPhysicalSales($period, $from_date, $to_date);

$first=0;
$total=0;

while (1) {
    if ($first == 0) {
        $sales = db_fetch(GetPhysicalSales($from_date, $to_date));
        $first = 1;
        $address = get_company_pref('postal_address');
        $tax_rates=get_tax_rates("Colorado Sales Tax", $address);
        $site = $sites[$tax_rates['JurisdictionCode']]['SiteID'];
        $site=substr($site,0,strlen($site)-4)."-0001";
    } else {
        if (!($sales = db_fetch($nonphys)))
            break;
        if ($sales['net'] == 0)
            continue;
        $address="\n" . trim($sales['location']) .  ", CO";
        $tax_rates=get_tax_rates("Colorado Sales Tax", $address);
        if (isset($sites[$tax_rates['JurisdictionCode']])) {
            $site = $sites[$tax_rates['JurisdictionCode']]['SiteID'];
            $site=substr($site,0,strlen($site)-4)."-".substr($site,-4);
        } else {
            $site = "";
            display_error("
                WWH sales tax location not found for " . $tax_rates['JurisdictionCode'] . " address " . $address . '. ' .
                "This means that Colorado DOR advertises a sales tax jurisdiction at https://www.colorado.gov/pacific/tax/sales-and-use-tax-rates-lookup " .
                "that is not in the list WWH sales tax locations.  Call DOR and find out what to do.");
        }
// display_notification($address);
    }

// display_notification(print_r($sales, true));

// display_notification("tax rates" . print_r($tax_rates,true));

// optional taxes

$service_fee = Array('SD'=> 0, 'RTD' => 0, 'City' => 0, 'County' => 0);
$tax_rate = Array('SD'=> 0, 'RTD' => 0, 'City' => 0, 'County' => 0);

for ($i=0; $tax_rates[$i] != null; $i += 3) {
    switch ($tax_rates[$i]) {
        case 'City' :
        case 'State' :
        case 'County' :
            $service_fee[$tax_rates[$i]]=$tax_rates[$i+2]/100;
            $tax_rate[$tax_rates[$i]]=$tax_rates[$i+1]/100;
            break;
        case 'RTD' :
        case 'CD' :
            $service_fee['RTD']=$tax_rates[$i+2]/100;
            $tax_rate['RTD']+=$tax_rates[$i+1]/100;
            break;
        default :   // special district?
            if (strpos($tax_rates[$i], 'food') === false) {
                $service_fee['SD']=$tax_rates[$i+2]/100;    // unclear which service fee to use
                $tax_rate['SD']+=$tax_rates[$i+1]/100;
            }
            break;
    }
}

if ($period >= "2019-06")
    $sales['ootac'] = $sales['oota'];

if ($sales['food'] <= 1)
    $sales['food'] = 0;

    if ($sales['description'] == 'Special Event') {
        $PRECISION = 0;
        if (isset($eventids[$tax_rates['Location']]['ID'])) {
            $site = $eventids[$tax_rates['Location']]['ID'];
            $site = substr($site, 0, 7) . '-' . substr($site,7);
        } else {
            display_error("Special Event " . $tax_rates['Location'] . " account number not found.  Fill in manually or add to wwheventids.csv and rerun report");
            $site = "";
        }
    } else
        $PRECISION = 2;
    

$sales['net'] = round($sales['net'], $PRECISION);

$sales_taxed_state=round($sales['net'] - $sales['tax_exempt'] - $sales['ootac'] -  $sales['food'], $PRECISION);
$sales_taxed_county=round($sales['net'] - $sales['tax_exempt'] - $sales['oota'] - $sales['food'] - $sales['candy'], $PRECISION);
$sales_taxed_rtdcd=round(($tax_rate['RTD']? $sales['net'] - $sales['tax_exempt'] - $sales['oota'] - $sales['food'] - $sales['candy'] : 0), $PRECISION);
$sales_taxed_sd=round(($tax_rate['SD'] ? $sales['net'] - $sales['tax_exempt'] - $sales['oota'] - $sales['food'] - $sales['candy'] : 0), $PRECISION);
$sales_taxed_city=round(($tax_rate['City'] ? $sales['net'] - $sales['tax_exempt'] - $sales['oota'] - $sales['food'] - $sales['candy'] : 0), $PRECISION);

$sales_customer[CUSTOMER_GROUP_CHARITY]=0;

    $tax_sd = round($sales_taxed_county * $tax_rate['SD'], $PRECISION);
    $tax_rtdcd = round($sales_taxed_county * $tax_rate['RTD'], $PRECISION);
    $tax_city = round($sales_taxed_county * $tax_rate['City'], $PRECISION);
    $tax_county = round($sales_taxed_county * $tax_rate['County'], $PRECISION);
    $tax_state = round($sales_taxed_state * $tax_rate['State'], $PRECISION);

    $service_fee_sd = round($tax_sd * $service_fee['SD'], $PRECISION);
    $service_fee_rtdcd = round($tax_rtdcd * $service_fee['RTD'], $PRECISION);
    $service_fee_city = round($tax_city * $service_fee['City'], $PRECISION);
    $service_fee_county = round($tax_county * $service_fee['County'], $PRECISION);
    $service_fee_state = round($tax_state * $service_fee['State'], $PRECISION);

    $tax_due_sd = round($tax_sd - $service_fee_sd, $PRECISION);
    $tax_due_rtdcd = round($tax_rtdcd - $service_fee_rtdcd, $PRECISION);
    $tax_due_city = round($tax_city - $service_fee_city, $PRECISION);
    $tax_due_county = round($tax_county - $service_fee_county, $PRECISION);
    $tax_due_state = round($tax_state - $service_fee_state, $PRECISION);

    $tax_due = $tax_due_sd + $tax_due_rtdcd + $tax_due_county + $tax_due_state;

    if ($tax_due == 0)  // maybe we just sold them spices?
        continue;

    if ($dr0098 == 0) {
        $rep->TextCol(0, 1, $sales['description']);
        $rep->TextCol(1, 2, $tax_rates['Location']);
        $rep->TextCol(2, 3, $site);
    }

    if ($tax_rates['HomeRule'] == 'Self-collected') {
        if ($dr0098 == 0)
            $rep->AmountCol(3, 4, $tax_due_city, $dec);
        $tax_city = $service_fee_city = $tax_due_city = $sales_taxed_city = 00;
        $tax_rate['City'] = 0;
    } else
        $tax_due += $tax_due_city;

    if ($dr0098 == 0) {
        $rep->AmountCol(4, 5, $tax_due, $dec);
        $rep->NewLine();
    }

    if ($sales['description'] == 'Special Event') {

    if ($dr0098) {

    $special = array(
	array('x' => 6.5, 'y' => 9.2, 'text' => FEIN),

	array('x' => 1, 'y' => 8.7, 'text' => strtoupper(get_company_pref('coy_name'))),
	array('x' => 6.7, 'y' => 8.7, 'text' => '970 434-6868'),

	array('x' => 4.6, 'y' => 8.2, 'text' => $tax_rates['JurisdictionCode']),


	array('x' => 8.0, 'y' => 8.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),

	array('x' => 1, 'y' => 8.2, 'text' => $site),

	array('x' => 1, 'y' => 7.8, 'text' => $tax_rates['Location']),
	array('x' => 2.5, 'y' => 6.9, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),

	array('x' => 2.5, 'y' => 5.5, 'text' => $sales['net'] - $sales['tax_exempt']),
	array('x' => 3.7, 'y' => 5.5, 'text' => ($tax_rate['RTD'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),
	array('x' => 5, 'y' => 5.5, 'text' => ($tax_rate['SD'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),
	array('x' => 6, 'y' => 5.5, 'text' => $sales['net'] - $sales['tax_exempt']),
	array('x' => 7.2, 'y' => 5.5, 'text' => ($tax_rate['City'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),


	array('x' => 2.5, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_state)),
	array('x' => 3.7, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_rtdcd)),
	array('x' => 5, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_sd)),
	array('x' => 6, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_county)),
	array('x' => 7.2, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_city)),

	array('x' => 2.5, 'y' => 4.4, 'text' => number_format($tax_rate['State'],4)),
	array('x' => 3.7, 'y' => 4.4, 'text' => number_format($tax_rate['RTD'],4)),
	array('x' => 5, 'y' => 4.4, 'text' => number_format($tax_rate['SD'],4)),
	array('x' => 6, 'y' => 4.4, 'text' => number_format($tax_rate['County'],4)),
	array('x' => 7.2, 'y' => 4.4, 'text' => number_format($tax_rate['City'],4)),

	array('x' => 2.5, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_state)),
	array('x' => 3.7, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_rtdcd)),
	array('x' => 5, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_sd)),
	array('x' => 6, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_county)),
	array('x' => 7.2, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_city)),

	array('x' => 2.5, 'y' => 3.9, 'text' => number_format($service_fee['State'],4)),
	array('x' => 3.7, 'y' => 3.9, 'text' => number_format($service_fee['RTD'],4)),
	array('x' => 5, 'y' => 3.9, 'text' => number_format($service_fee['SD'],4)),
	array('x' => 6, 'y' => 3.9, 'text' => number_format($service_fee['County'],4)),
	array('x' => 7.2, 'y' => 3.9, 'text' => number_format($service_fee['City'],4)),

	array('x' => 2.5, 'y' => 3.4, 'text' => $service_fee_state),
	array('x' => 3.7, 'y' => 3.4, 'text' => $service_fee_rtdcd),
	array('x' => 5, 'y' => 3.4, 'text' => $service_fee_sd),
	array('x' => 6, 'y' => 3.4, 'text' => $service_fee_county),
	array('x' => 7.2, 'y' => 3.4, 'text' => $service_fee_city),

	array('x' => 2.5, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_state)),
	array('x' => 3.7, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_rtdcd)),
	array('x' => 5, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_sd)),
	array('x' => 6, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_county)),
	array('x' => 7.2, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_city)),

	array('x' => 2.5, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_state)),
	array('x' => 3.7, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_rtdcd)),
	array('x' => 5, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_sd)),
	array('x' => 6, 'y' => 1.5, 'text' =>sprintf("%6.".$PRECISION."f", $tax_due_county)),
	array('x' => 7.2, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_city)),

	array('x' => 7.2, 'y' => 1.0, 'text' => $tax_due));

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
	   $handleform = fopen('../modules/rep_dr0100/reporting/forms/DR0098.ps', 'r');
	   if ($handleform) {
	     while (!feof($handleform)) {
	       $buffer = fgets($handleform, 4096);
		$i = strpos($buffer, 'startpage');
		if ($i === false)
			$i = strpos($buffer, '%%BeginProlog');
		if ($i !== false) {
			// annotate
			fwrite($handle, $buffer, $i-1);
			foreach ($special as $value) {
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







    } // $dr0098

    } else {

    if ($dr0098 == 0) {

    $total += $tax_due;

    $annote = array(
	array('x' => 6.5, 'y' => 9.3, 'text' => date('m/d/y')),
	array('x' => 6.5, 'y' => 8.7, 'text' => FEIN),

	array('x' => 1, 'y' => 8.3, 'text' => strtoupper(get_company_pref('coy_name'))),

	array('x' => 1, 'y' => 7.8, 'text' => '130 31 RD                                               GRAND JCT      CO          81503'),

	// phone number does not print, do not know why?!?!?
	array('x' => 6.7, 'y' => 7.8, 'text' => '970 434-6868'),

	array('x' => 1, 'y' => 7.2, 'text' => $site),
	array('x' => 3.0, 'y' => 7.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 3.8, 'y' => 7.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 6.8, 'y' => 7.2, 'text' => date('m/d/y', strtotime($from_date . "+1 month +19 days"))),

	array('x' => 4.6, 'y' => 7.2, 'text' => $tax_rates['JurisdictionCode']),
	array('x' => 3.6, 'y' => 7.05, 'text' => $tax_rates['Location']),
	array('x' => 6.8, 'y' => 6.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),
	array('x' => 6.8, 'y' => 5.8, 'text' => $sales['tax_exempt'] + $sales['oota'] + $sales_customer[CUSTOMER_GROUP_CHARITY]),

	array('x' => 2.5, 'y' => 5.2, 'text' => $sales['net'] - $sales['tax_exempt']),
	array('x' => 3.7, 'y' => 5.2, 'text' => ($tax_rate['RTD'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),
	array('x' => 5, 'y' => 5.2, 'text' => ($tax_rate['SD'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),
	array('x' => 6, 'y' => 5.2, 'text' => $sales['net'] - $sales['tax_exempt']),
	array('x' => 7.2, 'y' => 5.2, 'text' => ($tax_rate['City'] ? $sales['net'] - $sales['tax_exempt'] : "N/A")),



	array('x' => 2.5, 'y' => 4.5, 'text' => $sales['food']),
	array('x' => 3.7, 'y' => 4.5, 'text' => ($tax_rate['RTD'] ? $sales['food']+$sales['candy'] : "N/A")),
	array('x' => 5, 'y' => 4.5, 'text' => ($tax_rate['SD'] ? $sales['food']+$sales['candy'] : "N/A")),
	array('x' => 6, 'y' => 4.5, 'text' => $sales['food']+$sales['candy']),
	array('x' => 7.2, 'y' => 4.5, 'text' => ($tax_rate['City'] ? $sales['food']+$sales['candy'] : "N/A")),

	array('x' => 2.5, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_state)),
	array('x' => 3.7, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_rtdcd)),
	array('x' => 5, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_sd)),
	array('x' => 6, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_county)),
	array('x' => 7.2, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed_city)),

	array('x' => 2.5, 'y' => 4.0, 'text' => number_format($tax_rate['State'],4)),
	array('x' => 3.7, 'y' => 4.0, 'text' => number_format($tax_rate['RTD'],4)),
	array('x' => 5, 'y' => 4.0, 'text' => number_format($tax_rate['SD'],4)),
	array('x' => 6, 'y' => 4.0, 'text' => number_format($tax_rate['County'],4)),
	array('x' => 7.2, 'y' => 4.0, 'text' => number_format($tax_rate['City'],4)),

	array('x' => 2.5, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $tax_state)),
	array('x' => 3.7, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $tax_rtdcd)),
	array('x' => 5, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $tax_sd)),
	array('x' => 6, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $tax_county)),
	array('x' => 7.2, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $tax_city)),

	array('x' => 2.5, 'y' => 2.9, 'text' => sprintf("%6.".$PRECISION."f", $tax_state)),
	array('x' => 3.7, 'y' => 2.9, 'text' => sprintf("%6.".$PRECISION."f", $tax_rtdcd)),
	array('x' => 5, 'y' => 2.9, 'text' => sprintf("%6.".$PRECISION."f", $tax_sd)),
	array('x' => 6, 'y' => 2.9, 'text' => sprintf("%6.".$PRECISION."f", $tax_county)),
	array('x' => 7.2, 'y' => 2.9, 'text' => sprintf("%6.".$PRECISION."f", $tax_city)),

	array('x' => 2.5, 'y' => 2.6, 'text' => number_format($service_fee['State'],4)),
	array('x' => 3.7, 'y' => 2.6, 'text' => number_format($service_fee['RTD'],4)),
	array('x' => 5, 'y' => 2.6, 'text' => number_format($service_fee['SD'],4)),
	array('x' => 6, 'y' => 2.6, 'text' => number_format($service_fee['County'],4)),
	array('x' => 7.2, 'y' => 2.6, 'text' => number_format($service_fee['City'],4)),

	array('x' => 2.5, 'y' => 2.1, 'text' => $service_fee_state),
	array('x' => 3.7, 'y' => 2.1, 'text' => $service_fee_rtdcd),
	array('x' => 5, 'y' => 2.1, 'text' => $service_fee_sd),
	array('x' => 6, 'y' => 2.1, 'text' => $service_fee_county),
	array('x' => 7.2, 'y' => 2.1, 'text' => $service_fee_city),

	array('x' => 2.5, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_state)),
	array('x' => 3.7, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_rtdcd)),
	array('x' => 5, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_sd)),
	array('x' => 6, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_county)),
	array('x' => 7.2, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_city))


 );

	// excise report fields
	foreach ($annote as $value) {
		echo '<tr><td>' . $value['text'] . '</td></tr>';
	}

    $annote2 = array(
	array('x' => 1, 'y' => 9.6, 'text' => $site),
	array('x' => 5, 'y' => 9.6, 'text' => strtoupper(get_company_pref('coy_name'))),
	array('x' => 3.2, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 3.8, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),

	array('x' => 2.5, 'y' => 9.0, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_state)),
	array('x' => 3.7, 'y' => 9.0, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_rtdcd)),
	array('x' => 5, 'y' => 9.0, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_sd)),
	array('x' => 6, 'y' => 9.0, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_county)),
	array('x' => 7.2, 'y' => 9.0, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_city)),

	array('x' => 2.5, 'y' => 7.6, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_state)),
	array('x' => 3.7, 'y' => 7.6, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_rtdcd)),
	array('x' => 5, 'y' => 7.6, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_sd)),
	array('x' => 6, 'y' => 7.6, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_county)),
	array('x' => 7.2, 'y' => 7.6, 'text' => sprintf("%6.".$PRECISION."f", $tax_due_city)),

	array('x' => 7.2, 'y' => 7.1, 'text' => $tax_due_sd+$tax_due_county+$tax_due_state+$tax_due_city+$tax_due_rtdcd),
	array('x' => 7.2, 'y' => 6.3, 'text' => sprintf("%6.".$PRECISION."f", $sales['tax_exempt'])),
	array('x' => 7.2, 'y' => 5.8, 'text' => sprintf("%6.".$PRECISION."f", $sales['oota'])),
	array('x' => 7.2, 'y' => 4.7, 'text' => $sales_customer[CUSTOMER_GROUP_CHARITY])
   );

    $annote3 = array(
	array('x' => 1, 'y' => 9.6, 'text' => $site),
	array('x' => 5, 'y' => 9.6, 'text' => strtoupper(get_company_pref('coy_name'))),
	array('x' => 3.2, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 3.8, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),

	array('x' => 7.2, 'y' => 8.3, 'text' => $sales['tax_exempt'] + $sales['oota'] + $sales_customer[CUSTOMER_GROUP_CHARITY]),

	array('x' => 2.5, 'y' => 7.2, 'text' => $sales['food']),
	array('x' => 3.7, 'y' => 7.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 5, 'y' => 7.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 6, 'y' => 7.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 7.2, 'y' => 7.2, 'text' => $sales['food']+$sales['candy']),

	array('x' => 2.5, 'y' => 1.2, 'text' => $sales['food']),
	array('x' => 3.7, 'y' => 1.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 5, 'y' => 1.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 6, 'y' => 1.2, 'text' => $sales['food']+$sales['candy']),
	array('x' => 7.2, 'y' => 1.2, 'text' => $sales['food']+$sales['candy'])
   );


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
	   $handleform = fopen('../modules/rep_dr0100/reporting/forms/DR0100p5.ps', 'r');
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

	   // copy excise tax form page 2
	   $handleform = fopen('../modules/rep_dr0100/reporting/forms/DR0100p6.ps', 'r');
	   if ($handleform) {
	     fputs($handle, '_begin_job_
');
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

	   // copy excise tax form page 3
	   $handleform = fopen('../modules/rep_dr0100/reporting/forms/DR0100p7.ps', 'r');
	   if ($handleform) {
	     fputs($handle, '_begin_job_
');
	     while (!feof($handleform)) {
	       $buffer = fgets($handleform, 4096);
		$i = strpos($buffer, 'startpage');
		if ($i === false)
			$i = strpos($buffer, '%%BeginProlog');
		if ($i !== false) {
			// annotate
			fwrite($handle, $buffer, $i-1);
			foreach ($annote3 as $value) {
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

} // dr0100 stuff

} // $dr0098 == 0

} // while

	     fclose($handle);
     } else { // end of handle
	print "Unable to write " . $formfile;
	die();
     }


    if (!$dr0098) {
    $rep->NewLine();
    $rep->TextCol(0, 2, 'TOTAL DUE STATE ON DR0100 ONLY');
    $rep->AmountCol(4, 5, $total, $dec);

   $rep->end();
    }

   exec("ps2pdf $path_to_root/tmp/newform.ps $path_to_root/tmp/newform.pdf");
   meta_forward($path_to_root . "/tmp/newform.pdf");
}
?>
