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
include_once($path_to_root . "/modules/rep_dr0100/reporting/testcases.inc");
include_once($path_to_root . "/modules/rep_dr0100/reporting/zerofilers.inc");

define("TAX_GROUP_EXEMPT_WHOLESALE",'2');
define("TAX_GROUP_COLORADO",'5'); // non-physical locations
define("TAX_GROUP_EXEMPT_OOS",'8');
define("TAX_GROUP_EXEMPT_CHARITY",'10');
define("TAX_GROUP_EXEMPT_WINEMAKERS",'11');

define("REPORT_TYPE_SUMMARY",'0');
define("REPORT_TYPE_DR0100",'1');
define("REPORT_TYPE_XML",'2');
define("REPORT_TYPE_DR0098",'3');


//----------------------------------------------------------------------------------------------------
$sites=array();
read_sites();

$eventids=array();
read_eventids();

company_dr0100($testcases, $zerofilers);

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


// Note: food includes import adjustments, credit card testing
// Food include grape sales to home winemakers, but not to wineries,
// because wineries are WINEMAKERS.

// Note that Nancy does not want wholesale bottle sales to include bulk wine or grape sales,
// so the tax group of these customers is WINEMAKERS instead.  If a winery is
// erroneously set to WHOLESALE, and gets bulk wine, it will show up as food!

// However, the DOR wholesale includes bluk wine and grapes sales to wineries

// net is our actual sales from Grand Junction Tasting Room, incl. food
// (gross according to DOR is net + wholesale + charity + oota, etc,
//  but that all gets subtracted off)
function GetPhysicalSales($from, $to)
{
    $fromdate = date2sql($from);
    $todate = date2sql($to);

    $sql= "SELECT
            'Physical Location' as description,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_OOS.","
                    .TAX_GROUP_EXEMPT_CHARITY.","
                    .TAX_GROUP_EXEMPT_WHOLESALE.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.")
                AND LOCATE('220 32 RD', so.delivery_address) != 0
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS net,

            ROUND(SUM(CASE WHEN cb.tax_group_id IN ("
                    .TAX_GROUP_EXEMPT_WHOLESALE.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.")
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS WholesaleSales,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_WHOLESALE.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_COLORADO.")
                THEN (CASE WHEN dt.type=".ST_CUSTCREDIT." THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) ELSE 0 END),2) AS OutsideOfColorado,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_OOS.","
                    .TAX_GROUP_EXEMPT_CHARITY.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_EXEMPT_WHOLESALE.")
                 AND ttd.tax_type_id=0 THEN ttd.net_amount ELSE 0 END),2) AS Food,

            ROUND(SUM(CASE WHEN cb.tax_group_id NOT IN ("
                    .TAX_GROUP_EXEMPT_OOS.","
                    .TAX_GROUP_EXEMPT_CHARITY.","
                    .TAX_GROUP_EXEMPT_WINEMAKERS.","
                    .TAX_GROUP_EXEMPT_WHOLESALE.")
                AND ttd.tax_type_id=2 THEN ttd.net_amount ELSE 0 END),2) AS candy

        FROM ".TB_PREF."debtor_trans dt
        LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type
        LEFT JOIN ".TB_PREF."cust_branch cb ON cb.branch_code = dt.branch_code
        LEFT JOIN ".TB_PREF."areas a ON cb.area = a.area_code
        LEFT JOIN ".TB_PREF."sales_orders so ON so.order_no = dt.order_
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
            so.delivery_address as address,
            a.description,

            (CASE WHEN dt.type=".ST_CUSTCREDIT."
                THEN (ttd.net_amount)*-1
                ELSE (ttd.net_amount) END *ex_rate) AS net,

            ROUND((CASE WHEN ttd.tax_type_id=0 THEN ttd.net_amount ELSE 0 END),2) AS Food,

            ROUND((CASE WHEN ttd.tax_type_id=2 THEN ttd.net_amount ELSE 0 END),2) AS candy

        FROM ".TB_PREF."debtor_trans dt
        LEFT JOIN ".TB_PREF."voided as v ON dt.trans_no=v.id AND dt.type=v.type
        LEFT JOIN ".TB_PREF."cust_branch cb ON cb.branch_code = dt.branch_code
        LEFT JOIN ".TB_PREF."areas a ON cb.area = a.area_code
        LEFT JOIN ".TB_PREF."sales_orders so ON so.order_no = dt.order_
        LEFT JOIN ".TB_PREF."trans_tax_details ttd ON ttd.trans_type=dt.type AND ttd.trans_no=dt.trans_no
        WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.")
            AND ISNULL(v.date_)
            AND LOCATE('220 32 RD', so.delivery_address) = 0
            AND dt.tran_date >='$fromdate'
            AND dt.tran_date <='$todate'
            AND cb.tax_group_id = '" . TAX_GROUP_COLORADO ."'";

// display_notification(str_replace('&TB_PREF&', '1_', $sql));
    return db_query($sql, "Error getting order details");
}

function xml_deduct($k, $d, $amt, $comment = null)
{
    if ($amt != 0)
        return "                <Deductions>
                    <ExemptionDeductionDescription>$d</ExemptionDeductionDescription>
                    <ExemptionDeductionCode>$k</ExemptionDeductionCode>
                    <ExemptionDeductionAmount>$amt</ExemptionDeductionAmount>
                    <OtherExemptionExplanation>$comment</OtherExemptionExplanation>
                </Deductions>\n";
}

function randomNumber($length) {
    $result = '';
    for($i = 0; $i < $length; $i++) {
        $result .= mt_rand(0, 9);
    }
    return $result;
}

function xml_header($period, $fein, $coacct, $coy_name='', $address, $phone, $email)
{
    global $suts;
    $seq="0000001";
    $timestamp=date("c");
    $digits = 20;
    $tid = randomNumber(20);

    $address = str_replace("\r", "", $address);
    $address = str_replace("\n", ", ", $address);
    list($street, $city, $statezip) = explode(", ", $address);
    list($state, $zip) = explode(" ", $statezip);

    $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    $xml .= "\n";

    if ($suts == true)
        $xml .= '<Transmission xsi:noNamespaceSchemaLocation="FERTransmission.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <TransmissionHeader recordCount="1">
        <Jurisdiction>CO</Jurisdiction>
        <TransmissionId>'.$tid.'</TransmissionId>
        <Timestamp>' . $timestamp . '</Timestamp>
        <TransmitterId>' . get_company_pref("'gst_no'")  . '</TransmitterId>
        <TestIndicator>P</TestIndicator>
    </TransmissionHeader>';

    $xml .= '<ReturnState xsi:noNamespaceSchemaLocation="FERReturnState.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<ReturnHeaderState binaryAttachmentCount="0">
    <Jurisdiction>CO</Jurisdiction>
    <Timestamp>' . date("c") . '</Timestamp>
    <TaxPeriodBeginDate>' . $period . '-01</TaxPeriodBeginDate>
    <TaxPeriodEndDate>' . date("Y-m-t", strtotime($period . '-01')) . '</TaxPeriodEndDate>
    <TaxYear>' . substr($period, 0, 4) . '</TaxYear>
    <Originator>
        <EFIN>' . ($suts == true ? str_replace('-', '', get_company_pref("'gst_no'")) : "000000") . '</EFIN> 
        <Type>OnlineFiler</Type>
    </Originator>
    <SoftwareId>FrontAcct</SoftwareId>
    <SoftwareVersion>2.4</SoftwareVersion>
    <ReturnType>Sales</ReturnType>
    <SubmissionID>' . substr($coacct, 0, 6) . date('Y') . sprintf('%03d', (int)date('z'))  . $seq . '</SubmissionID>
    <FilingFrequency>M</FilingFrequency> 
    <Filer> 
        <TIN>
            <TypeTIN>FEIN</TypeTIN>
            <TINTypeValue>' . str_replace('-', '', $fein) . '</TINTypeValue> 
        </TIN>
        <StateTaxpayerID>' . $coacct . '</StateTaxpayerID>
        <Name>
            <BusinessNameLine1>' . $coy_name . '</BusinessNameLine1>
        </Name>
        <USAddress>
            <AddressLine1>' . $street . '</AddressLine1> 
            <City>' . $city . '</City>
            <State>' . $state . '</State>
            <ZIPCode>' . $zip . '</ZIPCode>
        </USAddress>
        <DateSigned>'. date('Y-m-d') . '</DateSigned>
    </Filer>
    <Contact>
        <ContactName>Administrator</ContactName>
        <ContactPhone>' . str_replace('-', '', $phone) . '</ContactPhone>
        <ContactEmail>' . $email . '</ContactEmail>
    </Contact>
    <AckAddress>' . $email . '</AckAddress>
</ReturnHeaderState>
<ReturnDataState>
    <SubmissionID>' . substr($coacct, 0, 6) . date('Y') . sprintf('%03d', (int)date('z'))  . $seq . '</SubmissionID>
';

    $xml .= "\n";
    return $xml;
}

//----------------------------------------------------------------------------------------------------

function print_dr0100($handle, $fein, $name, $site, $rep, $period, $sales, $tax_rates, $suts_hr, $blacklisted=null)
{
global $total, $total_state_service_fee, $eventids, $path_to_root, $report_type, $suts;

$dec = user_price_dec();
$xml = '';
$xml .= '   <FilingBody FilingType="Location">
    <LocationCode>' . str_replace('-', '', $site) . '</LocationCode>
    <JurisdictionTax>
        <LocationJurisCode>' . $tax_rates['JurisdictionCode'] . '</LocationJurisCode>
';




$from_date = substr($period,5,2) . "/01/" . substr($period,0,4);

// map entities to DR0100 columns
$entities = array(
    "State" => "state",
    "RTD" => "rtd",
    "RTA" => "sd",  // per DR1002
    "CD" => "rtd",
    "County" => "county",   // xml is Cnty
    "HSD" => "sd",      // per DR1002
    "PSI" => "sd",      // per DR1002
    "MHA" => "sd",    //per DR1002
    "MTS" => "county",    //per DR1002
    "MDT" => "sd",    //per DR1002
    "LID" => "city",    // per DR1002
    "City" => "city");

for ($i=0; !($tax_rates[$i] == '' && $tax_rates[$i+1] == '' && $tax_rates[$i+2] == ''); $i += 3) {
    if (strpos($tax_rates[$i], 'food') !== false)
        continue;

    if ($tax_rates[$i] == '' || !array_key_exists($tax_rates[$i], $entities)) {
        display_error("Unsupported entity:" . $tax_rates[$i] . "," . $tax_rates[$i+1] . "," . $tax_rates[$i+2]);
        continue;
    }

    $service_fee[$tax_rates[$i]]=$tax_rates[$i+2]/100;
    $tax_rate[$tax_rates[$i]]=$tax_rates[$i+1]/100;
}

$deductions = array(
    108 => 'Food',
    110 => 'Machinery', 
    112 => 'Electricity', 
    114 => 'FarmEquipment', 
    116 => 'LowEmitVehicle', 
    118 => 'SchoolRelatedSales', 
    112 => 'RenewableEnergyComponents', 
    124 => 'SpaceFlight', 
    126 => 'RetailMarijuana',
    146 => 'OtherExemption');

$hr_deductions[100040] = array(
    'Food' => 43);

//display_notification(print_r($sales, true));

// initialize
foreach ($entities as $ent_xml => $col) {
    $deduct_total[$col] = 0;
    $deduct_total[$ent_xml] = 0;
    $tax_rate[$col] = 0;
    $service_fee[$col] = 0;

}

$exemptions = array(
    84 => 'WholesaleSales',
    102 => 'AgriculturalSales',
    88 => 'Service',
    86 => 'OutsideOfColorado',
    90 => 'ExemptEntities',
    92 => 'Gas',
    94 => 'DrugsMedicalDevices',
    96 => 'Tradeins',
    104 => 'ComputerSoftware',
    100 => 'UtilitiesRestaurant',
    98 => 'BadDebt');

// sql returns net but tests return gross
// DOR wants gross

$exempt_total = 0;
foreach ($exemptions as $e)
    if (isset($sales[$e]))
        $exempt_total += $sales[$e];

if (!isset($sales['net']) && !isset($sales['gross'])) {
    display_error("Period $period has no sales data");
    die();
}

if (!isset($sales['net']))
    $sales['net'] = $sales['gross'] - $exempt_total;
if (!isset($sales['gross']))
    $sales['gross'] = $sales['net'] + $exempt_total;

// If we refunded someone and there were not any positive offseting sales,
// I just do not know how to get the tax refunded
if ($sales['net'] < 0)
    return;

$tax_due = 0;
$service_fee_due = 0;

foreach ($entities as $ent_xml => $col) {
    if (isset($tax_rate[$ent_xml])) {

        if ($suts_hr) {
            if ($col != 'city')
                continue;
        } else if ($tax_rates['HomeRule'] == 'Self-collected'
            && $col == 'city') {
                if (!$suts) {
                    // LID and City both mapped into "city", so add tax_rates
                    // RTD and CD both mapped into "rtd", so add tax_rates
                    $tax_rate[$col] += $tax_rate[$ent_xml]; // for dr0100

                    // unclear which service fee to use
                    $service_fee[$col] = $service_fee[$ent_xml];    // for dr0100
                }
                continue;
        }

        // LID and City both mapped into "city", so add tax_rates
        // RTD and CD both mapped into "rtd", so add tax_rates
        $tax_rate[$col] += $tax_rate[$ent_xml]; // for dr0100

        // unclear which service fee to use
        $service_fee[$col] = $service_fee[$ent_xml];    // for dr0100

        // The DR0100 maps tax codes into columns,
        // but XML appears to do no mapping (see Sample Instance, CD & RTD)
        $xml .= '           <SalesOrUseTaxes TaxType="Sales">' . "\n";
        if ($ent_xml == "County")
            $xml .= "            <TaxCode>Cnty</TaxCode>\n";
        else if ($ent_xml == "MTS")
            $xml .= "            <TaxCode>MT</TaxCode>\n";
        else if ($ent_xml == "MDT")
            $xml .= "            <TaxCode>BGM</TaxCode>\n";
        else
            $xml .= "            <TaxCode>$ent_xml</TaxCode>\n";

        $xml .= "            <TaxBasis>
                <BasisAmount>" . sprintf("%.2f", $sales['gross']) . "</BasisAmount>\n";

        foreach ($exemptions as $k => $e)
            if (isset($sales[$e]))
                $xml .= xml_deduct($k, $e, $sales[$e]);

        // add deductions
        foreach ($deductions as $k => $d) {
            if (!isset($sales[$col][$d])) {
                if ($col == 'city' && isset($hr_deductions[$tax_rates['JurisdictionCode']][$d]))
                    $code = $hr_deductions[$tax_rates['JurisdictionCode']][$d];
                else
                    $code = $k;
                if (isset($sales[$ent_xml][$d])) {
        // display_notification($col . " " .$d . " " . $sales[$ent_xml][$d]);
                    $deduct_total[$col] += $sales[$ent_xml][$d];    // for dr0100
                    $deduct_total[$ent_xml] += $sales[$ent_xml][$d];    // for xml
                    $sales[$col][$d] = $sales[$ent_xml][$d];    // for dr0100
                    $xml .= xml_deduct($code, $d, $sales[$col][$d], @$sales['Comment'][$d]);
                } else if (isset($sales[$d])) { // deductions identical for all entities

                    if ($d == 'Food') {
                        // import adjustments are food, ignore them
                        if ($sales['Food'] <= 1)
                            $sales['Food'] = 0;

                        if ($col == 'city'
                            && strpos($tax_rates['CityExemptions(state-collectedcities)'], 'A') === false)
                            continue;

                        if ($col != 'city'
                            && strpos($tax_rates['CountyExemptions'], 'A') === false)
                            continue;

// Does Mesa County MC define candy as food?
// Nancy showed me a receipt dated 03/04/20 from City Market (CM).
// Lindor Dark Choc Kisses has a tax class B.  Total was $10.00 and tax was 0.29.
// CM also has a tax class T for taxable goods and a class F for food with no tax.
// So it appears that candy is taxed at 2.9% (state tax) but exempt from other taxes,
// so MC must define candy as food.

                        if ($col == "state")
                            $sales[$col][$d] = $sales[$d];  // for dr0100
                        else
                            $sales[$col][$d] = $sales[$d] + $sales['candy'];
                    } else
                        $sales[$col][$d] = $sales[$d];  // for dr0100

                    $deduct_total[$col] += $sales[$col][$d];  // for dr0100
                    $deduct_total[$ent_xml] += $sales[$col][$d];    // for xml
                    $xml .= xml_deduct($code, $d, $sales[$col][$d]);
                }
            } // isset sales
        } // foreach deductions

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

$taxableSales = $sales['net'] - $deduct_total[$ent_xml];
$taxAmount = round($taxableSales * $tax_rate[$ent_xml], $PRECISION);
$serviceFee = round($taxAmount * $service_fee[$ent_xml], $PRECISION);
$taxDueAmount = $taxAmount - $serviceFee;

if ($col != "city") {
    $tax_due += $taxDueAmount;
    $service_fee_due += $serviceFee;
}

$taxableSales = sprintf("%.2f", $taxableSales);
$taxAmount = sprintf("%.2f", $taxAmount);
$serviceFee = sprintf("%.2f", $serviceFee);
$taxDueAmount = sprintf("%.2f", $taxDueAmount);
$netSales = sprintf("%.2f", $sales['net']);


$xml .= "                   <TaxableAmount>$netSales</TaxableAmount>
                    <TaxRate>" . $tax_rate[$ent_xml] . "</TaxRate>
                    <TaxAmount>$taxAmount</TaxAmount>
                    <NetTaxableSales>$taxableSales</NetTaxableSales>
                    <DeductionWorksheetTotal>$exempt_total</DeductionWorksheetTotal>
                    <ExemptionWorksheetTotal>" . $deduct_total[$ent_xml] . "</ExemptionWorksheetTotal>
                </TaxBasis>
                <TaxDueAmount>$taxDueAmount</TaxDueAmount>
                <TaxCollected>$taxAmount</TaxCollected>
                <SalesTaxDueAmount>$taxDueAmount</SalesTaxDueAmount>
                <Discounts>
                    <DiscountRate>" . $service_fee[$ent_xml] . "</DiscountRate>
                    <DiscountAmount>$serviceFee</DiscountAmount>
                </Discounts>
           </SalesOrUseTaxes>\n";

    } // tax_rate set
} // entities

    $columns = array('sd', 'rtd', 'city', 'county', 'state');
    foreach ($columns as $col) {

        $sales_taxed[$col] = round($sales['net'] - $deduct_total[$col], $PRECISION);

        // zero out missing tax rates/deductions
        if ($tax_rate[$col] == 0) {
            $sales_taxed[$col] = round(0, $PRECISION);
            $tax_rate[$col] = 0;
            $service_fee[$col] = 0;
        }
        foreach ($deductions as $e) {
            if (!isset($sales[$col][$e]))
                $sales[$col][$e] = 0;
        }
        foreach ($exemptions as $e)
            if (!isset($sales[$e]))
                $sales[$e] = 0;
    }

    $tax_sd = round($sales_taxed['sd'] * $tax_rate['sd'], $PRECISION);
    $tax_rtdcd = round($sales_taxed['rtd'] * $tax_rate['rtd'], $PRECISION);
    $tax_city = round($sales_taxed['city'] * $tax_rate['city'], $PRECISION);
    $tax_county = round($sales_taxed['county'] * $tax_rate['county'], $PRECISION);
    $tax_state = round($sales_taxed['state'] * $tax_rate['state'], $PRECISION);

    $service_fee_sd = round($tax_sd * $service_fee['sd'], $PRECISION);
    $service_fee_rtdcd = round($tax_rtdcd * $service_fee['rtd'], $PRECISION);
    $service_fee_city = round($tax_city * $service_fee['city'], $PRECISION);
    $service_fee_county = round($tax_county * $service_fee['county'], $PRECISION);
    $service_fee_state = round($tax_state * $service_fee['state'], $PRECISION);

    $tax_due_sd = $tax_sd - $service_fee_sd;
    $tax_due_rtdcd = $tax_rtdcd - $service_fee_rtdcd;
    $tax_due_city = $tax_city - $service_fee_city;
    $tax_due_county = $tax_county - $service_fee_county;
    $tax_due_state = $tax_state - $service_fee_state;

    $self_paid = 0;
    if ($tax_rates['HomeRule'] == 'Self-collected') {
        if ($suts_hr)
            if (in_array($tax_rates['Location'], $blacklisted)) {
                $tax_due = 0;
                $self_paid = $tax_due_city;
                if ($self_paid == 0)    // maybe we just sold them spices
                    return;
                $self_paid_sales = $sales_taxed['city'];
            } else
                $tax_due = $tax_due_city;
        else {
            $self_paid = $tax_due_city;
            $self_paid_sales = $sales_taxed['city'];
            $tax_city = $service_fee_city = $tax_due_city = $sales_taxed['city'] = 0;
            $tax_rate['city'] = 0;
        }
    } else
        $tax_due += $tax_due_city;

    if ($report_type == REPORT_TYPE_SUMMARY) {
        $rep->TextCol(0, 1, $tax_rates['Location']);
        $rep->TextCol(1, 2, $site);
        if ($self_paid != 0) {
            $rep->AmountCol(2, 3, $self_paid_sales, $dec);
            $rep->AmountCol(3, 4, $self_paid, $dec);
        }
        $rep->AmountCol(4, 5, $tax_due, $dec);
        $rep->NewLine();
    }

    // no xml for blacklisted homerule cities
    if ($tax_due == 0 && $self_paid != 0)
        return;

    if ($sales['description'] != 'Special Event') {
        $total += $tax_due;
        $total_state_service_fee += $service_fee_state;
    }

    if ($report_type == REPORT_TYPE_XML) {
        $xml .= "               <TotalTaxDueAmount>$tax_due</TotalTaxDueAmount>
            </JurisdictionTax>
        </FilingBody>\n";

        fputs($handle, $xml);
    } else {

    if ($sales['description'] == 'Special Event') {

    if ($report_type == REPORT_TYPE_DR0098) {

    $special = array(
	array('x' => 6.5, 'y' => 9.2, 'text' => $fein),

	array('x' => 1, 'y' => 8.7, 'text' => strtoupper($name)),
	array('x' => 6.7, 'y' => 8.7, 'text' => '970 434-6868'),

	array('x' => 4.6, 'y' => 8.2, 'text' => $tax_rates['JurisdictionCode']),


	array('x' => 6.7, 'y' => 8.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),

	array('x' => 1, 'y' => 8.2, 'text' => $site),

	array('x' => 1, 'y' => 7.8, 'text' => $tax_rates['Location']),
	array('x' => 2.5, 'y' => 6.9, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),

	array('x' => 2.5, 'y' => 5.5, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),
	array('x' => 3.7, 'y' => 5.5, 'text' => ($tax_rate['rtd'] ? sprintf("%6.".$PRECISION."f", $sales['net']) : "N/A")),
	array('x' => 4.7, 'y' => 5.5, 'text' => ($tax_rate['sd'] ? sprintf("%6.".$PRECISION."f", $sales['net']) : "N/A")),
	array('x' => 6, 'y' => 5.5, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),
	array('x' => 7.2, 'y' => 5.5, 'text' => ($tax_rate['city'] ? sprintf("%6.".$PRECISION."f", $sales['net']) : "N/A")),


	array('x' => 2.5, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['state'])),
	array('x' => 3.7, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['rtd'])),
	array('x' => 4.7, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['sd'])),
	array('x' => 6, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['county'])),
	array('x' => 7.2, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['city'])),

	array('x' => 2.5, 'y' => 4.4, 'text' => number_format($tax_rate['state'],4)),
	array('x' => 3.7, 'y' => 4.4, 'text' => number_format($tax_rate['rtd'],4)),
	array('x' => 4.7, 'y' => 4.4, 'text' => number_format($tax_rate['sd'],4)),
	array('x' => 6, 'y' => 4.4, 'text' => number_format($tax_rate['county'],4)),
	array('x' => 7.2, 'y' => 4.4, 'text' => number_format($tax_rate['city'],4)),

	array('x' => 2.5, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_state)),
	array('x' => 3.7, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_rtdcd)),
	array('x' => 4.7, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_sd)),
	array('x' => 6, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_county)),
	array('x' => 7.2, 'y' => 4.1, 'text' => sprintf("%6.".$PRECISION."f", $tax_city)),

	array('x' => 2.5, 'y' => 3.8, 'text' => number_format($service_fee['state'],4)),
	array('x' => 3.7, 'y' => 3.8, 'text' => number_format($service_fee['rtd'],4)),
	array('x' => 4.7, 'y' => 3.8, 'text' => number_format($service_fee['sd'],4)),
	array('x' => 6, 'y' => 3.8, 'text' => number_format($service_fee['county'],4)),
	array('x' => 7.2, 'y' => 3.8, 'text' => number_format($service_fee['city'],4)),

	array('x' => 2.5, 'y' => 3.3, 'text' => $service_fee_state),
	array('x' => 3.7, 'y' => 3.3, 'text' => $service_fee_rtdcd),
	array('x' => 4.7, 'y' => 3.3, 'text' => $service_fee_sd),
	array('x' => 6, 'y' => 3.3, 'text' => $service_fee_county),
	array('x' => 7.2, 'y' => 3.3, 'text' => $service_fee_city),

	array('x' => 2.5, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_state)),
	array('x' => 3.7, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_rtdcd)),
	array('x' => 4.7, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_sd)),
	array('x' => 6, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_county)),
	array('x' => 7.2, 'y' => 3, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_city)),

	array('x' => 2.5, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_state)),
	array('x' => 3.7, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_rtdcd)),
	array('x' => 4.7, 'y' => 1.5, 'text' => sprintf("%6.".$PRECISION."f",$tax_due_sd)),
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

    } else {    // not a special event

    if ($report_type == REPORT_TYPE_DR0100) {

    $annote = array(
	array('x' => 6.5, 'y' => 9.3, 'text' => date('m/d/y')),
	array('x' => 6.5, 'y' => 8.7, 'text' => $fein),

	array('x' => 1, 'y' => 8.3, 'text' => strtoupper($name)),

	array('x' => 1, 'y' => 7.8, 'text' => get_company_pref("postal_address")),

	// phone number does not print, do not know why?!?!?
	array('x' => 6.7, 'y' => 7.8, 'text' => get_company_pref("phone")),

	array('x' => 1, 'y' => 7.2, 'text' => $site),
	array('x' => 3.0, 'y' => 7.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 3.8, 'y' => 7.2, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 4.6, 'y' => 7.2, 'text' => $tax_rates['JurisdictionCode']),
	array('x' => 6.8, 'y' => 7.2, 'text' => date('m/d/y', strtotime($from_date . "+1 month +19 days"))),

	array('x' => 3.3, 'y' => 6.9, 'text' => $tax_rates['Location']),
	array('x' => 6.8, 'y' => 6.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['gross'])),
	array('x' => 6.8, 'y' => 5.8, 'text' => $exempt_total),

	array('x' => 2.5, 'y' => 5.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),
	array('x' => 3.7, 'y' => 5.2, 'text' => ($tax_rate['rtd'] ? sprintf("%6.".$PRECISION."f", $sales['net']): "N/A")),
	array('x' => 5, 'y' => 5.2, 'text' => ($tax_rate['sd'] ? sprintf("%6.".$PRECISION."f", $sales['net']): "N/A")),
	array('x' => 6, 'y' => 5.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['net'])),
	array('x' => 7.2, 'y' => 5.2, 'text' => ($tax_rate['city'] ? sprintf("%6.".$PRECISION."f", $sales['net']): "N/A")),



	array('x' => 2.5, 'y' => 4.5, 'text' => $deduct_total['state']),
	array('x' => 3.7, 'y' => 4.5, 'text' => ($tax_rate['rtd'] ? $deduct_total['rtd'] : "N/A")),
	array('x' => 5, 'y' => 4.5, 'text' => ($tax_rate['sd'] ? $deduct_total['sd'] : "N/A")),
	array('x' => 6, 'y' => 4.5, 'text' => $deduct_total['county']),
	array('x' => 7.2, 'y' => 4.5, 'text' => ($tax_rate['city'] ? $deduct_total['city'] : "N/A")),

	array('x' => 2.5, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['state'])),
	array('x' => 3.7, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['rtd'])),
	array('x' => 5, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['sd'])),
	array('x' => 6, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['county'])),
	array('x' => 7.2, 'y' => 4.3, 'text' => sprintf("%6.".$PRECISION."f", $sales_taxed['city'])),

	array('x' => 2.5, 'y' => 4.0, 'text' => number_format($tax_rate['state'],4)),
	array('x' => 3.7, 'y' => 4.0, 'text' => number_format($tax_rate['rtd'],4)),
	array('x' => 5, 'y' => 4.0, 'text' => number_format($tax_rate['sd'],4)),
	array('x' => 6, 'y' => 4.0, 'text' => number_format($tax_rate['county'],4)),
	array('x' => 7.2, 'y' => 4.0, 'text' => number_format($tax_rate['city'],4)),

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

	array('x' => 2.5, 'y' => 2.6, 'text' => number_format($service_fee['state'],4)),
	array('x' => 3.7, 'y' => 2.6, 'text' => number_format($service_fee['rtd'],4)),
	array('x' => 5, 'y' => 2.6, 'text' => number_format($service_fee['sd'],4)),
	array('x' => 6, 'y' => 2.6, 'text' => number_format($service_fee['county'],4)),
	array('x' => 7.2, 'y' => 2.6, 'text' => number_format($service_fee['city'],4)),

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

/*
	// excise report fields
	foreach ($annote as $value) {
		echo '<tr><td>' . $value['text'] . '</td></tr>';
	}
*/

    $annote2 = array(
	array('x' => 1, 'y' => 9.6, 'text' => $site),
	array('x' => 5, 'y' => 9.6, 'text' => strtoupper($name)),
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
	array('x' => 7.2, 'y' => 6.3, 'text' => sprintf("%6.".$PRECISION."f", $sales['WholesaleSales'])),
	array('x' => 7.2, 'y' => 5.8, 'text' => sprintf("%6.".$PRECISION."f", $sales['OutsideOfColorado'])),
	array('x' => 7.2, 'y' => 5.3, 'text' => sprintf("%6.".$PRECISION."f", $sales['Service'])),
	array('x' => 7.2, 'y' => 4.7, 'text' => sprintf("%6.".$PRECISION."f", $sales['ExemptEntities'])),
	array('x' => 7.2, 'y' => 4.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['Gas'])),
	array('x' => 7.2, 'y' => 3.7, 'text' => sprintf("%6.".$PRECISION."f", $sales['DrugsMedicalDevices'])),
	array('x' => 7.2, 'y' => 3.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['Tradeins'])),
	array('x' => 7.2, 'y' => 2.7, 'text' => sprintf("%6.".$PRECISION."f", $sales['BadDebt'])),
	array('x' => 7.2, 'y' => 2.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['UtilitiesRestaurant'])),
	array('x' => 7.2, 'y' => 1.7, 'text' => sprintf("%6.".$PRECISION."f", $sales['AgriculturalSales'])),
	array('x' => 7.2, 'y' => 1.2, 'text' => sprintf("%6.".$PRECISION."f", $sales['ComputerSoftware']))
   );

    $annote3 = array(
	array('x' => 1, 'y' => 9.6, 'text' => $site),
	array('x' => 5, 'y' => 9.6, 'text' => strtoupper($name)),
	array('x' => 3.2, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),
	array('x' => 3.8, 'y' => 9.6, 'text' => substr($from_date,0,2)."/".substr($from_date,8,2)),

	array('x' => 7.2, 'y' => 8.3, 'text' => $exempt_total),

	array('x' => 2.5, 'y' => 1.8, 'text' => @$sales['Comment']['OtherExemption']),

	array('x' => 2.5, 'y' => 1.2, 'text' => $deduct_total['state']),
	array('x' => 3.7, 'y' => 1.2, 'text' => $deduct_total['rtd']),
	array('x' => 5, 'y' => 1.2, 'text' => $deduct_total['sd']),
	array('x' => 6, 'y' => 1.2, 'text' => $deduct_total['county']),
	array('x' => 7.2, 'y' => 1.2, 'text' => $deduct_total['city'])
   );

    $y = 7.2;
    foreach ($deductions as $d) {
        $annote3 = array_merge($annote3, array(
            array('x' => 2.5, 'y' => $y, 'text' => $sales['state'][$d]),
            array('x' => 3.7, 'y' => $y, 'text' => $sales['rtd'][$d]),
            array('x' => 5, 'y' => $y, 'text' => $sales['sd'][$d]),
            array('x' => 6, 'y' => $y, 'text' => $sales['county'][$d]),
            array('x' => 7.2, 'y' => $y, 'text' => $sales['city'][$d])));

            $y -= .5;
    }


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

} // dr00098 = 0

} // not a special event

} // not xml_output

}

$total=0;
$total_state_service_fee=0;

function company_dr0100($testcases, $zerofilers)
{
    global $path_to_root, $sites, $total, $total_state_service_fee, $report_type, $suts;

    $blacklisted=array(
        'CONNERS (MAIL VIA ARVADA)',
        'AURORA',
        'CASTLE ROCK',
        'LAKEWOOD',
        'LOUISVILLE',
        'THORNTON',
        'GRAND JUNCTION',
        'GREELEY',
        'BROOMFIELD (CD Only)',
        'BROOMFIELD (RTD AND CD)');

    // $blacklisted=array('');

    // Get the payment
    $period = $_POST['PARAM_0'];
    if ($period < "201906") {
        display_error("Period $period not supported");
        die();
    }
    $report_type = $_POST['PARAM_1'];
    $test = $_POST['PARAM_2'];
    $suts = $_POST['PARAM_3'];

    $from_date = substr($period,5,2) . "/01/" . substr($period,0,4);
    $to_date = date("m/t/Y", strtotime($from_date));

    $dec = user_price_dec();

    include_once($path_to_root . "/reporting/includes/pdf_report.inc");

    $rep = new FrontReport(_('DR0100 Summary Report'), "DR0100SummaryReport", user_pagesize(), 9, 'P');

    $params =   array(0 => '', 
                      1 => array('text' => _('Period'), 'from' => $from_date, 'to' => $to_date));

    $cols = array(0, 200, 300, 360, 420, 480);

    $headers = array(_('Location'), _('Account No.'), _('Sales'), _('Pay HR City'), _('Pay State'));
    $aligns = array('left', 'left', 'right', 'right', 'right');

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

    if ($report_type == REPORT_TYPE_XML)
        $formfile= $path_to_root . '/tmp/salestax' . $period . '.xml';
    else
        $formfile= $path_to_root . '/tmp/newform.ps';
    $handle = fopen($formfile, 'w');
    if (!$handle) {
        print "Unable to write " . $formfile;
        die();
    }


        if ($test) {
            $t = $testcases[$test];
            $fein = "99-9999999";
            if ($report_type == REPORT_TYPE_XML)
                fputs($handle, xml_header($t['period'], $fein, $t["coacct"]));
            foreach ($t['sales'] as $sales) {
                print_dr0100($handle, $fein, $t["name"], $sales["site"], $rep, $t["period"], $sales, get_tax_rate_by_code($sales['code']), false);
            }
        } else {
            $sales = db_fetch(GetPhysicalSales($from_date, $to_date));
            $address = get_company_pref('postal_address');
            $fein = get_company_pref('gst_no');
            $tax_rates=get_tax_rates($address);
            $site = $sites[$tax_rates['JurisdictionCode']]['SiteID'];
            $coacct=substr($site,0,strlen($site)-4);
            $site=$coacct."-0001";
            if ($report_type == REPORT_TYPE_XML)
                fputs($handle, xml_header($period, $fein, $coacct,
                    get_company_pref('coy_name'),
                    $address,
                    get_company_pref('phone'),
                    get_company_pref('email') ));
/*
$sales['State']['OtherExemption'] = $sales['net'] - $sales['Food'];
$sales['Comment']['OtherExemption'] = "COVID Deduction";
*/
            print_dr0100($handle, $fein, get_company_pref('coy_name'), $site, $rep, $period, $sales, $tax_rates, false);

            $nonphys = GetNonPhysicalSales($period, $from_date, $to_date);
            while ($sales = db_fetch($nonphys)) {
                if ($sales['net'] == 0)
                    continue;

                $address = $sales['address'];
                $tax_rates=get_tax_rates($address);
                if (isset($sites[$tax_rates['JurisdictionCode']])) {
                    $site = $sites[$tax_rates['JurisdictionCode']]['SiteID'];
                    $site=substr($site,0,strlen($site)-4)."-".substr($site,-4);
                    $location=$tax_rates['Location'];
                } else {
                    $site = "";
                    $location = "";
                    display_error("
                        WWH sales tax location not found for " . $tax_rates['JurisdictionCode'] . " address " . $address . '. ' .
                        "This means that Colorado DOR advertises a sales tax jurisdiction at https://www.colorado.gov/pacific/tax/sales-and-use-tax-rates-lookup " .
                        "that is not in the list WWH sales tax locations.  Call DOR and find out what to do.");
                }
            // display_notification($address);

            // display_notification(print_r($sales, true));

            // display_notification("tax rates" . print_r($tax_rates,true));

            // optional taxes

            // Because different cities can map into the same jurisdiction
            // we add them up here.  For example, Ft. Collins and Fort Collins.
            // Note: this will take more work once we start using the actual address
            // rather than just the city.

                $siteSales[$location]['site'] = $site;
                $siteSales[$location]['tax_rates'] = $tax_rates;
                @$siteSales[$location]['sales']['net'] += $sales['net'];
                @$siteSales[$location]['sales']['Food'] += $sales['Food'];
                @$siteSales[$location]['sales']['candy'] += $sales['candy'];
                $siteSales[$location]['sales']['description'] = $sales['description'];

            } // while

            foreach ($zerofilers as $z) {
                $tax_rates=get_tax_rate_by_code($z['JurisdictionCode']);
                if (isset($sites[$tax_rates['JurisdictionCode']])) {
                    $site = $sites[$tax_rates['JurisdictionCode']]['SiteID'];
                    $site=substr($site,0,strlen($site)-4)."-".substr($site,-4);
                    $location=$tax_rates['Location'];
                } else {
                    display_error("Zero filer not found");
                    continue;
                }

                $siteSales[$location]['site'] = $site;
                $siteSales[$location]['tax_rates'] = $tax_rates;
                $siteSales[$location]['sales']['description'] = "Zero filer";
                @$siteSales[$location]['sales']['net'] += 0;
            }

            ksort($siteSales);
//display_notification(print_r($siteSales, true));
            foreach ($siteSales as $location => $siteSale) {
                if ($siteSale['sales']['description'] != 'Special Event'
                    || $report_type == REPORT_TYPE_DR0098) {
                    print_dr0100($handle, $fein, get_company_pref('coy_name'), $siteSale['site'], $rep, $period, $siteSale['sales'], $siteSale['tax_rates'], false);
                    if ($suts
                            && $siteSale['tax_rates']['HomeRule'] == 'Self-collected')
                        print_dr0100($handle, $fein, get_company_pref('coy_name'), "0000", $rep, $period, $siteSale['sales'], $siteSale['tax_rates'], true, $blacklisted);
                }
            }
        }

    if ($report_type == REPORT_TYPE_SUMMARY) {
        $rep->NewLine();
        $rep->TextCol(0, 2, 'TOTAL DUE STATE ON DR0100 ONLY');
        $rep->AmountCol(4, 5, $total, $dec);

       $rep->End();
    }

    if ($report_type == REPORT_TYPE_XML) {
        if ($total_state_service_fee > 1000)
            $excess_state_service_fee = $total_state_service_fee - 1000;
        else
            $excess_state_service_fee = 0;
        $total_payment_due = $total + $excess_state_service_fee;

        fputs($handle, "        <StateServiceFeeCap>
            <StateServiceFeeTotalReturnAmt>$total_state_service_fee</StateServiceFeeTotalReturnAmt>
            <ExcessStateServiceFeeAmt>$excess_state_service_fee</ExcessStateServiceFeeAmt>
            <TotalTaxDueThisReturnAmt>$total</TotalTaxDueThisReturnAmt>
            <TotalPaymentDueThisReturnAmt>$total_payment_due</TotalPaymentDueThisReturnAmt>
        </StateServiceFeeCap>
</ReturnDataState>\n");

    if ($suts == true)
        fputs($handle, "<FinancialTransaction>
    <StatePayment>
        <Checking>" . (get_company_pref("checking") ? "X" : "" ) . "</Checking>
        <RoutingTransitNumber>" . get_company_pref("routing_transit_number") . "</RoutingTransitNumber>
        <BankAccountNumber>" . get_company_pref("bank_account_number") . "</BankAccountNumber>
        <PaymentAmount>$total_payment_due</PaymentAmount>
        <AccountHolderName>" . get_company_pref("account_holder_name") . "</AccountHolderName>
        <AccountHolderType>" . get_company_pref("account_holder_type") . "</AccountHolderType>
        <RequestedPaymentDate>". date('Y-m-d') . "</RequestedPaymentDate>
    </StatePayment>
</FinancialTransaction>\n");


        fputs($handle, "</ReturnState>\n");

    if ($suts == true)
        fputs($handle, "</Transmission>\n");
    }

    fclose($handle);

    if ($report_type == REPORT_TYPE_XML)
        meta_forward($path_to_root . "/tmp/salestax" . $period . ".xml");
    else if ($report_type == REPORT_TYPE_DR0100
        || $report_type == REPORT_TYPE_DR0098) {
        exec("ps2pdf $path_to_root/tmp/newform.ps $path_to_root/tmp/newform.pdf");
        meta_forward($path_to_root . "/tmp/newform.pdf");
    }
}

?>
