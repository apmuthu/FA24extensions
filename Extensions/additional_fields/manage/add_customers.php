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
$page_security = 'SA_CUSTOMER';
$path_to_root = "../../..";

include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if (user_use_date_picker())
	$js .= get_js_date_picker();
	
page(_($help_context = "Customer Additional Information"), false, false, "", $js); 

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");
include_once($path_to_root . "/modules/additional_fields/includes/ui/additional_cust_info_ui.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/sales/includes/db/credit_status_db.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");

if (isset($_GET['debtor_no'])) 
{
	$_POST['customer_id'] = $_GET['debtor_no'];
}

$selected_id = get_post('customer_id','');
//--------------------------------------------------------------------------------------------

function customer_settings($selected_id) 
{
	global $page_nested;
	
	if ($selected_id) 
	{
		$myrow = get_customer($selected_id);

		$_POST['CustName'] = $myrow["name"];
		$_POST['cust_ref'] = $myrow["debtor_ref"];
		$_POST['address']  = $myrow["address"];
		$_POST['tax_id']  = $myrow["tax_id"];
		$_POST['sales_type'] = $myrow["sales_type"];
		$_POST['curr_code']  = $myrow["curr_code"];
		$_POST['credit_status']  = $myrow["credit_status"];
		$_POST['payment_terms']  = $myrow["payment_terms"];
		$_POST['discount']  = percent_format($myrow["discount"] * 100);
		$_POST['pymt_discount']  = percent_format($myrow["pymt_discount"] * 100);
		$_POST['credit_limit']	= price_format($myrow["credit_limit"]);
		$_POST['notes']  = $myrow["notes"];
		$_POST['inactive'] = $myrow["inactive"];

		$myrow2 = get_customer_additional_info($selected_id);
		$_POST['customer_id'] = $myrow2["cust_debtor_no"];
		$_POST['cust_city']  = $myrow2["cust_city"];
		$_POST['cust_department']  = $myrow2["cust_department"];
		$_POST['cust_country']  = $myrow2["cust_country"];
		$_POST['cust_postcode']  = $myrow2["cust_postcode"];
		$_POST['cust_doc_type']  = $myrow2["cust_doc_type"];
		$_POST['cust_valid_digit']  = $myrow2["cust_valid_digit"];
		$_POST['cust_start_date']  = sql2date($myrow2["cust_start_date"]);
		$_POST['cust_sector']  = $myrow2["cust_sector"];
		$_POST['cust_class']  = $myrow2["cust_class"];
		$_POST['cust_custom_one']  = $myrow2["cust_custom_one"];
		$_POST['cust_custom_two']  = $myrow2["cust_custom_two"];
		$_POST['cust_custom_three']  = $myrow2["cust_custom_three"];
		$_POST['cust_custom_four']  = $myrow2["cust_custom_four"];

	}

	start_outer_table(TABLESTYLE2);

	table_section(1);

	table_section_title(_("Name and Address"));

	label_row(_("Customer Name:"),$_POST['CustName']);
	label_row(_("Customer Short Name:"),$_POST['cust_ref']);
	readonly_textarea_row(_("Address:<br>\n(Read Only)"), 'address', $_POST['address'], 35, 5);
	city_list_row(_("City:"), 'cust_city');
	departments_list_row(_("State/Department:"), 'cust_department');
	country_list_row(_("Country:"), 'cust_country');
	text_row(_("Postcode:"), 'cust_postcode', null, 10, 10);
	label_row(_("GSTNo:"),$_POST['tax_id']);
	text_row(_("Validation Digit:"), 'cust_valid_digit', null, 1, 1);
	document_types_list_row(_("Type of Document:"), 'cust_doc_type');
	customer_class_list_row(_("Customer Class:"), 'cust_class');
	$currency_name = get_currency($myrow["curr_code"]);
	label_row(_("New Customer's Currency:"), $currency_name['currency']);
	$sales_type_name = get_sales_type_name($myrow["sales_type"]);
	label_row(_("Sales Type/Price List:"), $sales_type_name);
	date_row(_("Customer Since") . ":", 'cust_start_date', '', true);
	label_row(_("Customer Status:"),($myrow['inactive']==1 ? _("Inactive") : _("Active")), -1);

	table_section(2);

	table_section_title(_("Sales"));
	label_row(_("Discount Percent:"),$_POST['discount']);
	label_row(_("Prompt Payment Discount Percent:"),$_POST['pymt_discount']);
	label_row(_("Credit Limit:"),$_POST['credit_limit']);
	$payment_terms_name = get_payment_terms($myrow["payment_terms"]);
	label_row(_("Payment Terms:"), $payment_terms_name['terms']);
	$credit_status_name = get_credit_status($myrow["credit_status"]);
	label_row(_("New Credit Status:"), $credit_status_name['reason_description']);
	readonly_textarea_row(_("General Notes: (Read Only)"), 'notes', null, 35, 5);

	table_section_title(_("Additional Information"));

	text_row(get_cust_custom_labels_name(1).':', 'cust_custom_one', null, 40, 255);
	text_row(get_cust_custom_labels_name(2).':', 'cust_custom_two', null, 40, 255);
	text_row(get_cust_custom_labels_name(3).':', 'cust_custom_three', null, 40, 255);
	text_row(get_cust_custom_labels_name(4).':', 'cust_custom_four', null, 40, 255);
	sectors_list_row(_("Sector:"), 'cust_sector');
	
	end_outer_table(1);

	div_start('controls');
	
	if (!$selected_id)
	{
		display_heading(_('Select a Customer'));
	} 
	else 
	{
		submit_center_first('submit', _("Update Customer and Additional Infomation"), 
		  _('Update customer data and Additional Infomation'), $page_nested ? true : 'default');
		submit_center_last('delete', _("Delete Customer Additional Information"), 
		  _('Delete customer and Additional Infomation data'), true);
	}
	div_end();
}

if (isset($_POST['submit'])) 
{

	if ($selected_id) 
	{
		$add_cust_info_exists = db_query("SELECT cust_debtor_no FROM ".TB_PREF."addfields_cust where cust_debtor_no = '$selected_id' LIMIT 1");
		if(db_fetch($add_cust_info_exists)) 
			{
		        update_customer_additional_info($_POST['customer_id'], 
		        $_POST['cust_city'], $_POST['cust_department'],
				$_POST['cust_country'], $_POST['cust_postcode'], 
				$_POST['cust_doc_type'], $_POST['cust_valid_digit'], 
				$_POST['cust_start_date'], $_POST['cust_sector'], 
				$_POST['cust_class'], $_POST['cust_custom_one'], 
				$_POST['cust_custom_two'], $_POST['cust_custom_three'], 
				$_POST['cust_custom_four']);
		    } 
		    else 
		    {
		        add_customer_additional_info($_POST['customer_id'], 
		        $_POST['cust_city'], $_POST['cust_department'],
				$_POST['cust_country'], $_POST['cust_postcode'], 
				$_POST['cust_doc_type'], $_POST['cust_valid_digit'], 
				$_POST['cust_start_date'], $_POST['cust_sector'], 
				$_POST['cust_class'], $_POST['cust_custom_one'], 
				$_POST['cust_custom_two'], $_POST['cust_custom_three'], 
				$_POST['cust_custom_four']);
		    }

		$Ajax->activate('customer_id'); // in case of status change
		display_notification(_("Customer additional information has been updated."));
	} 
}
elseif (isset($_POST['delete'])) 
{
		delete_customer_additional_info($selected_id);
		display_notification(_("Selected Customer Additional Infomation has been deleted."));
		$Ajax->activate('_page_body');
}
//--------------------------------------------------------------------------------------------
 
start_form();

if (db_has_customers()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
	customer_list_cells(_("Select a customer: "), 'customer_id', null, _('Select a customer'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();

	if (get_post('_show_inactive_update')) {
		$Ajax->activate('customer_id');
		set_focus('customer_id');
	}
} 
else 
{
	hidden('customer_id');
}
if ($selected_id) 
	customer_settings($selected_id); 

end_form();
end_page();
