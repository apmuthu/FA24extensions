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
$page_security = $_POST['PARAM_0'] == $_POST['PARAM_1'] ?
	'SA_SALESTRANSVIEW' : 'SA_SALESBULKREP';
// ----------------------------------------------------------------
// $ Revision:	1.0 $
// Creator:	Jason March
// date_:	2023-02-12
// Title:	Route Deliveries
// Based on Print Deliveries
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/sales/includes/sales_db.inc");

//------------------------------------------------------------------------------
function get_delivery_date_range($from, $to, $route)
{
	global $SysPrefs;
	$fromdate = date2sql($from);
	$todate = date2sql($to);

	$ref = ($SysPrefs->print_invoice_no() == 1 ? "trans_no" : "reference");

  $sql = "SELECT trans.debtor_no, trans.branch_code, "
    ."trans.trans_no, trans.reference";
  if ($route == 1)
    $sql .=", addfields.cust_custom_one";

	$sql .= " FROM ".TB_PREF."debtor_trans trans 
    LEFT JOIN ".TB_PREF."voided voided ON trans.type=voided.type AND "
      ."trans.trans_no=voided.id";
  if ($route == 1)
    $sql .= " LEFT JOIN ".TB_PREF."addfields_cust addfields ON "
      ."trans.branch_code = addfields.cust_branch_no" ;

	$sql .= " WHERE trans.type=".ST_CUSTDELIVERY
		." AND ISNULL(voided.id)"
 		." AND trans.tran_date>='".$fromdate."'"
		." AND trans.tran_date<='".$todate."'";			

  $sql .= " ORDER BY trans.tran_date, trans.$ref";
  
  return db_query($sql, "Cant retrieve invoice range");
}

function no_geocode_error($branch_id)
{
  global $path_to_root;

  $branch = get_branch($branch_id);
  $cust = get_customer($branch['debtor_no']);

  $url1 = $path_to_root.'/modules/additional_fields/manage/add_customers.php?'
    .'debtor_no='.$branch['debtor_no']
    .'&branch_code='.$branch['debtor_no'];

  $url2 = $path_to_root.'/sales/manage/customer_branches.php?'
    .'SelectedBranch='.$branch_id;

  display_error("No Geocode Found" ."<br>"
    .'<a href="'.$url1.'">'
    ."Customer Name: ".$cust['debtor_ref'] ."<br>" ."</a>"
    ."Branch Name: ".$branch['branch_ref'] ."<br>" 
    .'<a href="'.$url2.'">'
    ."Mailing Address: ".$branch['br_post_address'] ."</a>");
}

print_deliveries();

//------------------------------------------------------------------------------

function print_deliveries()
{
	global $path_to_root, $SysPrefs;

	include_once($path_to_root . "/reporting/includes/pdf_report.inc");

  // Shipper ie. Driver requires modified class and function in core.
  // Changes have been submitted and pending in git
	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
	$email = $_POST['PARAM_2'];
	$packing_slip = $_POST['PARAM_3'];
	$shipper = $_POST['PARAM_4']; 
	$route = $_POST['PARAM_5'];
	$remove_home = $_POST['PARAM_6'];
	$route_linear = $_POST['PARAM_7'];
	$comments = $_POST['PARAM_8'];
	$orientation = $_POST['PARAM_9'];

	if (!$from || !$to) return;

  $orientation = ($orientation ? 'L' : 'P');
	$dec = user_price_dec();

	$cols = array(4, 60, 225, 300, 325, 385, 450, 515);

	// $headers in doctext.inc
	$aligns = array('left',	'left',	'right', 'left', 'right', 'right', 'right');

	$params = array('comments' => $comments, 'packing_slip' => $packing_slip);

	$cur = get_company_Pref('curr_default');

	if ($email == 0)
	{
		if ($packing_slip == 0)
      $rep = new FrontReport(_('DELIVERY'), 
        "DeliveryNoteBulk", user_pagesize(), 9, $orientation);
		else
      $rep = new FrontReport(_('PACKING SLIP'), 
        "PackingSlipBulk", user_pagesize(), 9, $orientation);
	}
  if ($orientation == 'L')
    recalculate_cols($cols);

  if ($route == 1)
  {
    // Make sure addional_fields plugin is installed
    if (file_exists($path_to_root 
      ."/modules/additional_fields/includes/addfields_db.inc"))
    {
      include_once($path_to_root 
        ."/modules/additional_fields/includes/addfields_db.inc");
    }else {
      display_error('Routing requires additional_fields module');
      return;
    }
    
    // Import your config settings
    $route_config = include_once($path_to_root 
      ."/modules/rep_route_deliveries/route_config.php");

    // Find what label id where geocoding is store in $geocode
    $field_label = $route_config['field_label'];
    $labels = get_cust_custom_labelss();

    while ($row = db_fetch($labels)){
      if ($row['description'] == $field_label)
        $label_id = $row['id'];
      if (!isset($label_id)){
        display_error('Could not find custom field labeled ' . $field_label);
        return;
      }
    }
    $label_keys = array(
      1 => "cust_custom_one",
      2 => "cust_custom_two",
      3 => "cust_custom_three",
      4 => "cust_custom_four",
    );

    $geocode = $label_keys[$label_id];
    
    // Set the instance of osrm url
    $osrm_url = $route_config['osrm_url'];
    // Set or clear home point 
    $home_point = $route_config['home_point'] . ';';
    if ($remove_home == 1)
      $home_point = "";
    // Clear for rountrip Set opt for linear 
    if ($route_linear == 1)
      $osrm_opt = "?roundtrip=false&source=first&destination=last";

    $geocodes = array();
    $branch = array();
    $rows = array();
    $range = array();

    // add elements for missing home location if set
    if($remove_home == 0){
      $rows[] = $row;
      $branch[]['br_name'] = 'Start Location'; 
    }

    // Iterate, fill arrays to sort since osrm doesn't sort it
    $range = get_delivery_date_range($from, $to, $route);
    while($row = db_fetch($range)){
      if (!empty($row[$geocode]))
      {
        if (!exists_customer_trans(ST_CUSTDELIVERY, $row['trans_no']))
          continue;
        $trans_row = get_customer_trans($row['trans_no'], ST_CUSTDELIVERY);
        if ($shipper && $trans_row['ship_via'] != $shipper)
         continue;
        // if data is lat,long swap order
        if ($route_config['swap_cords'] == 1)
        {
          $cordinates = explode(',', $row[$geocode]);
          $geocodes[] = $cordinates[1].",".$cordinates[0]; 
        }else{
          // else data is long,lat
          $geocodes[] = $row[$geocode]; 
        }
        $myrow = get_customer_trans($row['trans_no'], ST_CUSTDELIVERY);
        $branch[] = get_branch($myrow['branch_code']);
        $rows[] = $row;
      }else{
        no_geocode_error($row['branch_code']);
        return;
      }
    }

    // format the url
    $query = implode(';', $geocodes);
    $request_url = $osrm_url.$home_point.$query.$osrm_opt;

    // Use curl to get the data
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $request_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $osrm = curl_exec($ch);
    curl_close($ch);
    $osrm = json_decode($osrm, true);

    if ($osrm['code'] != 'Ok')
    {
      display_error('OSRM call failed, reason given: ' . $osrm['message']);
      display_error('API call was: ' . $request_url);
      return;
    }

    $waypoint_index = array();
    foreach($osrm['waypoints'] as $waypoints){
      $waypoint_index[] = $waypoints['waypoint_index'];
    }

    $distance = array();
    foreach($osrm['trips'][0]['legs'] as $legs){
      $distance[] = $legs['distance'];
    }

#    display_error($request_url);
#    display_error(json_encode($waypoint_index));
    array_multisort($waypoint_index,$branch,$rows);
#    display_error(json_encode($waypoint_index));
    $rep->Font('bold');
    $rep->Info($params, $cols, null, $aligns);
    $rep->NewPage();
    $rep->TextCol(0, 1,	"Delivery #", -2);
    $rep->TextCol(1, 1,	"Name", -2);
    if($route_config['km'] == 1)
      $rep->TextCol(2, 1,	"Distance km", -2);
    else
      $rep->TextCol(2, 1,	"Distance mi", -2);
    $rep->Font();
    for($i = 0; $i < count($osrm['waypoints']);$i++){
      if($route_config['km'] == 1)
        $distance[$i] = $distance[$i]/1000;
      else
        $distance[$i] = $distance[$i]*0.00062137;
	  $rep->NewLine();
    $rep->TextCol(0, 1,	$waypoint_index[$i]+1, -2);
    $rep->TextCol(1, 1,	$branch[$i]['br_name'], -2);
    $rep->TextCol(2, 1,	number_format($distance[$i],3), -2);
    }
	  $rep->NewLine();
    $rep->Font('bold');
    $rep->TextCol(0, 1,	"Total", -2);
    $rep->TextCol(2, 1,	number_format(array_sum($distance),3), -2);

  }else{
    $rows = array();
    $range = array();
    $range = get_delivery_date_range($from, $to, $route);
    while($row = db_fetch($range)){
      if (!exists_customer_trans(ST_CUSTDELIVERY, $row['trans_no']))
        continue;
      $myrow = get_customer_trans($row['trans_no'], ST_CUSTDELIVERY);
      $rows[] = $row;
    }
  }

  //Start to make the tickets
  $i = 0;
  foreach($rows as $row)
		{
			if (!exists_customer_trans(ST_CUSTDELIVERY, $row['trans_no']))
				continue;
      $myrow = get_customer_trans($row['trans_no'], ST_CUSTDELIVERY);

      // Shipper ie. Driver requires modified class and function in core.
      // Changes have been submitted and pending in git
			if ($shipper && $myrow['ship_via'] != $shipper)
       continue;
   
      $branch = get_branch($myrow["branch_code"]);
			$sales_order = get_sales_order_header($myrow["order_"], ST_SALESORDER); 
			if ($email == 1)
			{
				$rep = new FrontReport("", "", user_pagesize(), 9, $orientation);
				if ($packing_slip == 0)
				{
					$rep->title = _('DELIVERY NOTE');
					$rep->filename = "Delivery" . $myrow['reference'] . ".pdf";
				}
				else
				{
					$rep->title = _('PACKING SLIP');
					$rep->filename = "Packing_slip" . $myrow['reference'] . ".pdf";
				}
      }
			$rep->currency = ($cur == null ? "USD" : $cur);
			$rep->Font();
			$rep->Info($params, $cols, null, $aligns);

      $contacts = get_branch_contacts($branch['branch_code'], 
        'delivery', $branch['debtor_no'], true);
      $rep->SetCommonData($myrow, 
        $branch, $sales_order, '', ST_CUSTDELIVERY, $contacts);
			$rep->SetHeaderType('Header2');
			$rep->NewPage();

   			$result = get_customer_trans_details(ST_CUSTDELIVERY, $row['trans_no']);
			$SubTotal = 0;
			while ($myrow2=db_fetch($result))
			{
				if ($myrow2["quantity"] == 0)
					continue;

        $Net = round2(((1 - $myrow2["discount_percent"]) * 
          $myrow2["unit_price"] * $myrow2["quantity"]), user_price_dec());

				$SubTotal += $Net;
	    		$DisplayPrice = number_format2($myrow2["unit_price"],$dec);
        $DisplayQty = number_format2($myrow2["quantity"],
                      get_qty_dec($myrow2['stock_id']));
	    	$DisplayNet = number_format2($Net,$dec);
	    	if ($myrow2["discount_percent"]==0)
		  		$DisplayDiscount ="";
	    	else
          $DisplayDiscount = number_format2($myrow2["discount_percent"]*100,
            user_percent_dec()) . "%";
				$rep->TextCol(0, 1,	$myrow2['stock_id'], -2);
				$oldrow = $rep->row;
				$rep->TextColLines(1, 2, $myrow2['StockDescription'], -2);
				$newrow = $rep->row;
				$rep->row = $oldrow;
        if ($Net != 0.0  || !is_service($myrow2['mb_flag']) || 
          !$SysPrefs->no_zero_lines_amount())
				{
					$rep->TextCol(2, 3,	$DisplayQty, -2);
					$rep->TextCol(3, 4,	$myrow2['units'], -2);
					if ($packing_slip == 0)
					{
						$rep->TextCol(4, 5,	$DisplayPrice, -2);
						$rep->TextCol(5, 6,	$DisplayDiscount, -2);
						$rep->TextCol(6, 7,	$DisplayNet, -2);
					}
				}
				$rep->row = $newrow;
				//$rep->NewLine(1);
				if ($rep->row < $rep->bottomMargin + (15 * $rep->lineHeight))
					$rep->NewPage();
			}

      if ($route == 1)
      {
				$rep->NewLine();
        $rep->TextCol(0, 5, "Route Order: ".($waypoint_index[$i]+1), -2);
        $i++;
      }
			$memo = get_comments_string(ST_CUSTDELIVERY, $row['trans_no']);
			if ($memo != "")
			{
				$rep->NewLine();
				$rep->TextColLines(1, 3, $memo, -2);
      }

   			$DisplaySubTot = number_format2($SubTotal,$dec);

    		$rep->row = $rep->bottomMargin + (15 * $rep->lineHeight);
			$doctype=ST_CUSTDELIVERY;
			if ($packing_slip == 0)
			{
				$rep->TextCol(3, 6, _("Sub-total"), -2);
				$rep->TextCol(6, 7,	$DisplaySubTot, -2);
				$rep->NewLine();
				if ($myrow['ov_freight'] != 0.0)
				{
					$DisplayFreight = number_format2($myrow["ov_freight"],$dec);
					$rep->TextCol(3, 6, _("Shipping"), -2);
					$rep->TextCol(6, 7,	$DisplayFreight, -2);
					$rep->NewLine();
				}	
				$tax_items = get_trans_tax_details(ST_CUSTDELIVERY, $row['trans_no']);
				$first = true;
    			while ($tax_item = db_fetch($tax_items))
    			{
    				if ($tax_item['amount'] == 0)
    					continue;
    				$DisplayTax = number_format2($tax_item['amount'], $dec);
 
 					if ($SysPrefs->suppress_tax_rates() == 1)
 		   				$tax_type_name = $tax_item['tax_type_name'];
 		   			else
              $tax_type_name = $tax_item['tax_type_name']." ("
                .$tax_item['rate']."%) ";

 					if ($myrow['tax_included'])
    				{
   						if ($SysPrefs->alternative_tax_include_on_docs() == 1)
    					{
    						if ($first)
    						{
								$rep->TextCol(3, 6, _("Total Tax Excluded"), -2);
                $rep->TextCol(6, 7,	number_format2($tax_item['net_amount'], 
                    $dec), -2);
								$rep->NewLine();
    						}
							$rep->TextCol(3, 6, $tax_type_name, -2);
							$rep->TextCol(6, 7,	$DisplayTax, -2);
							$first = false;
    					}
    					else
                $rep->TextCol(3, 7, _("Included") . " " . $tax_type_name 
                  . _("Amount") . ": " . $DisplayTax, -2);
					}
    				else
    				{
						$rep->TextCol(3, 6, $tax_type_name, -2);
						$rep->TextCol(6, 7,	$DisplayTax, -2);
					}
					$rep->NewLine();
    			}
    			$rep->NewLine();
          $DisplayTotal = number_format2($myrow["ov_freight"] +
            $myrow["ov_freight_tax"] + $myrow["ov_gst"] +
					  $myrow["ov_amount"],$dec);
				$rep->Font('bold');
				$rep->TextCol(3, 6, _("TOTAL DELIVERY INCL. VAT"), - 2);
				$rep->TextCol(6, 7,	$DisplayTotal, -2);
				$words = price_in_words($myrow['Total'], ST_CUSTDELIVERY);
				if ($words != "")
				{
					$rep->NewLine(1);
					$rep->TextCol(1, 7, $myrow['curr_code'] . ": " . $words, - 2);
				}	
				$rep->Font();
			}	
			if ($email == 1)
			{
				$rep->End($email);
			}
	}
	if ($email == 0)
		$rep->End();
}

