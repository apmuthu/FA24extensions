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
$page_security = 'SA_CUSTBULKREP';
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
include_once($path_to_root . "/gl/includes/gl_db.inc");
//ADDED
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");

//END ADDED

//----------------------------------------------------------------------------------------------------

print_customer_details_listing();

function get_customer_details_for_report($area=0, $salesid=0)
{
	$sql = "SELECT debtor.debtor_no,
			debtor.name,
			debtor.address,
			debtor.curr_code,
			debtor.dimension_id,
			debtor.dimension2_id,
			debtor.notes,
			debtor.tax_id,
			debtor.credit_status,
			debtor.payment_terms,
			debtor.discount,
			debtor.pymt_discount,
			debtor.credit_limit,
			debtor.inactive,
			addfields.cust_city,
			addfields.cust_department,
			addfields.cust_country,
			addfields.cust_postcode,
			addfields.cust_doc_type,
			addfields.cust_valid_digit,
			addfields.cust_start_date,
			addfields.cust_sector,
			addfields.cust_class,
			addfields.cust_custom_one,
			addfields.cust_custom_two,
			addfields.cust_custom_three,
			addfields.cust_custom_four,
			pricelist.sales_type,
			branch.branch_code,
			branch.br_name,
			branch.br_address,
			branch.br_post_address,
			branch.area,
			branch.salesman,
			branch.group_no,
			area.description,
			salesman.salesman_name
		FROM ".TB_PREF."debtors_master debtor
		INNER JOIN ".TB_PREF."cust_branch branch ON debtor.debtor_no=branch.debtor_no
		INNER JOIN ".TB_PREF."addfields_cust addfields ON debtor.debtor_no=addfields.cust_debtor_no
		INNER JOIN ".TB_PREF."sales_types pricelist	ON debtor.sales_type=pricelist.id
		INNER JOIN ".TB_PREF."areas area ON branch.area = area.area_code
		INNER JOIN ".TB_PREF."salesman salesman	ON branch.salesman=salesman.salesman_code";
	
	$sql .= " ORDER BY debtor.debtor_no,
			branch.branch_code";

    return db_query($sql,"No transactions were returned");
}

function get_contacts_for_branch($branch)
{
	$sql = "SELECT p.*, r.action, r.type, CONCAT(r.type,'.',r.action) as ext_type 
		FROM ".TB_PREF."crm_persons p,"
			.TB_PREF."crm_contacts r
		WHERE r.person_id=p.id AND r.type='cust_branch' 
			AND r.entity_id=".db_escape($branch);
	$res = db_query($sql, "can't retrieve branch contacts");
	$results = array();
	while($contact = db_fetch($res))
		$results[] = $contact;
	return $results;
}

//----------------------------------------------------------------------------------------------------

function print_customer_details_listing()
{
    global $path_to_root;
    $comments = $_POST['PARAM_0'];

	include_once($path_to_root . "/reporting/includes/excel_report.inc");

	$orientation = 'L';
    $dec = 0;
    $cust_custom_label_one = get_cust_custom_labels_name(1);
    $cust_custom_label_two = get_cust_custom_labels_name(2);
    $cust_custom_label_three = get_cust_custom_labels_name(3);
    $cust_custom_label_four = get_cust_custom_labels_name(4);

	$cols = array(0, 120, 240, 340, 410, 480, 550, 690, 740, 790, 860, 930, 970, 1010, 1050, 1090, 1150, 1190, 1230, 1290, 1350, 1390, 1405, 1420, 1440, 1460, 1520, 1580, 1640, 1700);//max 1700
			//    1  2	  3	   4	5	 6	  7	   8	9	 10	  11   12   13	 14	   15	 16	   17	 18	   19	 20	   21	 22	   23	 24	   25	 26    27    28    29    30
	$headers = array(_('Customer Name'), _('Address'),	_('Name'),
			_('NIT/Cedula'), _('Document Type'), _('Customer Type'), _('Sector')
			, _('Customer Since'), _('Credit Limit'), _('Credit Status')
			, _('Payment Terms'), _('Discount'), _('PYMT Discount'), _('Currency Code')
			, _('Sales Area'), _('Salesman'), _('Sales Group'), _('Active?')
			, _('Dimension 1'), _('Dimension 2'), _('Notes'), _('Phone')
			, _('2nd Phone'), _('Fax'), _('E-mail'), $cust_custom_label_one, $cust_custom_label_two, $cust_custom_label_three, $cust_custom_label_four);

	$aligns = array('left', 'left', 'left', 'left', 'left', 'left', 'left', 
					'left', 'left', 'left', 'left', 'left', 'left', 'left', 
					'left', 'left', 'left', 'left', 'left', 'left', 'left', 
					'left', 'left', 'left', 'left', 'left', 'left', 'left',
					'left', 'left');

    $params =   array( 	0 => $comments);

    $rep = new FrontReport(_('Customer Additional Details'), "CustomerDetailsListing", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$result = get_customer_details_for_report();

	$carea = '';
	$sman = '';
	while ($myrow=db_fetch($result))
	{
		$printcustomer = true;

		if ($printcustomer)
		{
			$newrow = 0;
			
			$rep->NewLine();
			// Here starts the new report lines
			$contacts = get_contacts_for_branch($myrow['branch_code']);
			$rep->TextCol(0, 1,	$myrow['name']);

			$unspaced_address = $myrow['address'];
			$spaced_address = str_replace(array("\n", "\r"), ', ', $unspaced_address);
			$city = get_city_name($myrow['cust_city']);
			$department = get_departments_name($myrow['cust_department']);
			$country = get_country_name($myrow['cust_country']);
			$rep->TextCol(1, 2, $spaced_address . ", " . $city . ", " . $department . ", " . $country
				 . ", " . $myrow['cust_postcode']);

			$rep->TextCol(2, 3, $myrow['name']);
			$rep->TextCol(3, 4,	$myrow['tax_id'] . "-" . $myrow['cust_valid_digit']);
			$cust_doc_type = get_document_type_name($myrow['cust_doc_type']);
			$rep->TextCol(4, 5, $cust_doc_type);
			$cust_class = get_cust_class_name($myrow['cust_class']);
			$rep->TextCol(5, 6, $cust_class);
			$sector = get_sectors_name($myrow['cust_sector']);
			$rep->TextCol(6, 7, $sector);
			$rep->DateCol(7, 8, $myrow['cust_start_date'], true);

			$rep->AmountCol(8, 9,	$myrow['credit_limit'], $dec);
			$credit_status = get_credit_status_reason($myrow['credit_status']);
			$rep->TextCol(9, 10, $credit_status);
			$payment_terms = get_payment_term_name($myrow['payment_terms']);
			$rep->TextCol(10, 11, $payment_terms);
			$rep->TextCol(11, 12,	$myrow['discount']. '%');
			$rep->TextCol(12, 13,	$myrow['pymt_discount']. '%');
			$rep->TextCol(13, 14,	$myrow['curr_code']);
			$rep->TextCol(14, 15,	$myrow['description']);
			$salesman = get_salesman_name($myrow['salesman']);
			$rep->TextCol(15, 16, $salesman);
			$group_no = get_sales_group_name($myrow['group_no']);
			$rep->TextCol(16, 17, $group_no);
			$is_active = $myrow["inactive"];
			if ($is_active)
		    	$rep->TextCol(17, 18, _('Inactive'));
			else
				$rep->TextCol(17, 18, _('Active'));
			if ($myrow['dimension_id'] != 0)
			{
			$dim1 = get_dimension($myrow['dimension_id']);
			$rep->TextCol(18, 19,	$dim1['name']);
			}
			if ($myrow['dimension2_id'] != 0)
			{
			$dim2 = get_dimension($myrow['dimension2_id']);
			$rep->TextCol(19, 20,	$dim2['name']);
			}
			$rep->TextCol(20, 21,	$myrow['notes']);
			
			$crm = get_customer_contacts($myrow["debtor_no"]);

			if (isset($crm[0]))
			{
			$rep->TextCol(21, 22,	$crm[0]['phone']);
			$rep->TextCol(22, 23,	$crm[0]['phone2']);
			$rep->TextCol(23, 24,	$crm[0]['fax']);
			$rep->TextCol(24, 25,	$crm[0]['email']);
			}
			$rep->TextCol(25, 26,	$myrow['cust_custom_one']);
			$rep->TextCol(26, 27,	$myrow['cust_custom_two']);
			$rep->TextCol(27, 28,	$myrow['cust_custom_three']);
			$rep->TextCol(28, 29,	$myrow['cust_custom_four']);

			if ($newrow != 0 && $newrow < $rep->row)
				$rep->row = $newrow;
			$rep->NewLine();
			$rep->Line($rep->row + 8);
			$rep->NewLine(0, 3);
		}
	}
    $rep->End();
}

