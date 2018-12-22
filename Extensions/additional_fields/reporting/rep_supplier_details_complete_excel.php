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
$page_security = 'SA_SUPPLIERANALYTIC';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Customer Details Listing
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
//ADDED
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");
//END ADDED

//----------------------------------------------------------------------------------------------------

print_supplier_details_listing();

function get_supplier_details_for_report()
{
	$sql = "SELECT supps.supplier_id,
			supps.supp_name,
			supps.address,
			supps.supp_address,
			supps.supp_ref,
			supps.contact,
			supps.curr_code,
			supps.dimension_id,
			supps.dimension2_id,
			supps.notes,
			supps.gst_no,
			supps.payment_terms,
			supps.credit_limit,
			supps.inactive,
			addfields.supp_city,
			addfields.supp_department,
			addfields.supp_country,
			addfields.supp_postcode,
			addfields.supp_doc_type,
			addfields.supp_valid_digit,
			addfields.supp_start_date,
			addfields.supp_sector,
			addfields.supp_class,
			addfields.supp_custom_one,
			addfields.supp_custom_two,
			addfields.supp_custom_three,
			addfields.supp_custom_four
			FROM ".TB_PREF."suppliers supps
			INNER JOIN ".TB_PREF."addfields_supp addfields ON supps.supplier_id=addfields.supp_supplier_id
			WHERE inactive = 0
	 		ORDER BY supp_name";

    return db_query($sql,"No transactions were returned");
}


function getTransactions($supplier_id, $date)
{
	$date = date2sql($date);

	$sql = "SELECT SUM((ov_amount+ov_discount)*rate) AS Turnover
		FROM ".TB_PREF."supp_trans
		WHERE supplier_id=".db_escape($supplier_id)."
		AND (type=".ST_SUPPINVOICE." OR type=".ST_SUPPCREDIT.")
		AND tran_date >='$date'";

    $result = db_query($sql,"No transactions were returned");

	$row = db_fetch_row($result);
	return $row[0];
}

//----------------------------------------------------------------------------------------------------

function print_supplier_details_listing()
{
    global $path_to_root;

    $comments = $_POST['PARAM_0'];
	include_once($path_to_root . "/reporting/includes/excel_report.inc");

	$orientation = 'L';
    $dec = 0;
    $supp_custom_label_one = get_supp_custom_labels_name(1);
    $supp_custom_label_two = get_supp_custom_labels_name(2);
    $supp_custom_label_three = get_supp_custom_labels_name(3);
    $supp_custom_label_four = get_supp_custom_labels_name(4);

	$cols = array(0, 120, 240, 340, 410, 480, 550, 690, 740, 790, 930, 970, 1010, 1050, 1090, 1150, 1190, 1230, 1290, 1350, 1430, 1510, 1590, 1670);//max 1700
			//    1  2	  3	   4	5	 6	  7	   8	9	 10	  11   12	13	  14	15	  16	17	  18	19	  20    21    22    23    24		
	$headers = array(_('Supplier Name'), _('Address'),	_('Name'),
			_('NIT/Cedula'), _('Document Type'), _('Supplier Type'), _('Sector')
			, _('Supplier Since'), _('Credit Limit')
			, _('Payment Terms'), _('Currency Code')
			, _('Active?')
			, _('Dimension 1'), _('Dimension 2'), _('Notes'), _('Phone')
			, _('2nd Phone'), _('Fax'), _('E-mail'), $supp_custom_label_one, $supp_custom_label_two, $supp_custom_label_three, $supp_custom_label_four);

	$aligns = array('left', 'left', 'left', 'left', 'left', 'left', 'left', 
					'left', 'left', 'left', 'left', 'left', 'left', 'left', 
					'left', 'left', 'left', 'left', 'left', 'left', 'left',
					'left', 'left', 'left', 'left');

    $params =   array( 	0 => $comments);

    $rep = new FrontReport(_('Supplier Additional Details'), "SupplierDetailsListing", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$result = get_supplier_details_for_report();

	while ($myrow=db_fetch($result))
	{
		$printsupplier = true;
		if ($printsupplier)
		{
			$newrow = 0;


			$rep->NewLine();
			// Here starts the new report lines
			$contacts = get_supplier_contacts($myrow['supplier_id']);
			$rep->TextCol(0, 1,	$myrow['supp_name']);

			$unspaced_address = $myrow['supp_address'];
			$spaced_address = str_replace(array("\n", "\r"), ', ', $unspaced_address);
			$city = get_city_name($myrow['supp_city']);
			$department = get_departments_name($myrow['supp_department']);
			$country = get_country_name($myrow['supp_country']);
			$rep->TextCol(1, 2, $spaced_address . ", " . $city . ", " . $department . ", " . $country
				 . ", " . $myrow['supp_postcode']);

			$rep->TextCol(2, 3, $myrow['supp_name']);
			$rep->TextCol(3, 4,	$myrow['gst_no'] . "-" . $myrow['supp_valid_digit']);
			$supp_doc_type = get_document_type_name($myrow['supp_doc_type']);
			$rep->TextCol(4, 5, $supp_doc_type);
			$supp_class = get_cust_class_name($myrow['supp_class']);
			$rep->TextCol(5, 6, $supp_class);
			$sector = get_sectors_name($myrow['supp_sector']);
			$rep->TextCol(6, 7, $sector);
			$rep->DateCol(7, 8, $myrow['supp_start_date'], true);

			$rep->AmountCol(8, 9,	$myrow['credit_limit'], $dec);
			$payment_terms = get_payment_term_name($myrow['payment_terms']);
			$rep->TextCol(9, 10, $payment_terms);
			$rep->TextCol(10, 11,	$myrow['curr_code']);
			$is_active = $myrow["inactive"];
			if ($is_active)
		    	$rep->TextCol(11, 12, _('Inactive'));
			else
				$rep->TextCol(11, 12, _('Active'));
			if ($myrow['dimension_id'] != 0)
			{
			$dim1 = get_dimension($myrow['dimension_id']);
			$rep->TextCol(12, 13,	$dim1['name']);
			}
			if ($myrow['dimension2_id'] != 0)
			{
			$dim2 = get_dimension($myrow['dimension2_id']);
			$rep->TextCol(13, 14,	$dim2['name']);
			}
			$rep->TextCol(14, 15,	$myrow['notes']);

			if (isset($contacts[0]))
			{
			$rep->TextCol(15, 16,	$contacts[0]['phone']);
			$rep->TextCol(16, 17,	$contacts[0]['phone2']);
			$rep->TextCol(17, 18,	$contacts[0]['fax']);
			$rep->TextCol(18, 19,	$contacts[0]['email']);
			}
			$rep->TextCol(19, 20,	$myrow['supp_custom_one']);
			$rep->TextCol(20, 21,	$myrow['supp_custom_two']);
			$rep->TextCol(21, 22,	$myrow['supp_custom_three']);
			$rep->TextCol(22, 23,	$myrow['supp_custom_four']);
			if ($newrow != 0 && $newrow < $rep->row)
				$rep->row = $newrow;
			$rep->NewLine();
			$rep->Line($rep->row + 8);
			$rep->NewLine(0, 3);
		}
	}
    $rep->End();
}

