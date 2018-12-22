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
$page_security = 'SA_SUPPLIER';
$path_to_root = "../../..";
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if (user_use_date_picker())
	$js .= get_js_date_picker();

page(_($help_context = "Supplier Additional Information"), false, false, "", $js);

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

include_once($path_to_root . "/modules/additional_fields/includes/ui/additional_cust_info_ui.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");
include_once($path_to_root . "/purchasing/includes/db/suppliers_db.inc");

if (isset($_GET['supplier_id'])) 
{
	$_POST['supplier_id'] = $_GET['supplier_id'];
}

$supplier_id = get_post('supplier_id'); 
//--------------------------------------------------------------------------------------------
function supplier_settings_add_info(&$supplier_id)
{
	global $page_nested;
	
	start_outer_table(TABLESTYLE2);

	table_section(1);

	if ($supplier_id) 
	{
		$myrow = get_supplier($_POST['supplier_id']);

		$_POST['supp_name'] = $myrow["supp_name"];
		$_POST['supp_ref'] = $myrow["supp_ref"];
		$_POST['address']  = $myrow["address"];
		$_POST['supp_address']  = $myrow["supp_address"];

		$_POST['gst_no']  = $myrow["gst_no"];
		$_POST['website']  = $myrow["website"];
		$_POST['supp_account_no']  = $myrow["supp_account_no"];
		$_POST['bank_account']  = $myrow["bank_account"];
		$_POST['dimension_id']  = $myrow["dimension_id"];
		$_POST['dimension2_id']  = $myrow["dimension2_id"];
		$_POST['curr_code']  = $myrow["curr_code"];
		$_POST['payment_terms']  = $myrow["payment_terms"];
		$_POST['credit_limit']  = price_format($myrow["credit_limit"]);
		$_POST['tax_group_id'] = $myrow["tax_group_id"];
		$_POST['tax_included'] = $myrow["tax_included"];
		$_POST['payable_account']  = $myrow["payable_account"];
		$_POST['purchase_account']  = $myrow["purchase_account"];
		$_POST['payment_discount_account'] = $myrow["payment_discount_account"];
		$_POST['notes']  = $myrow["notes"];
	 	$_POST['inactive'] = $myrow["inactive"];

		$myrow2 = get_supplier_additional_info($_POST['supplier_id']);
		$_POST['supplier_id'] = $myrow2["supp_supplier_id"];
		$_POST['supp_city']  = $myrow2["supp_city"];
		$_POST['supp_department']  = $myrow2["supp_department"];
		$_POST['supp_country']  = $myrow2["supp_country"];
		$_POST['supp_postcode']  = $myrow2["supp_postcode"];
		$_POST['supp_doc_type']  = $myrow2["supp_doc_type"];
		$_POST['supp_valid_digit']  = $myrow2["supp_valid_digit"];
		$_POST['supp_start_date']  = sql2date($myrow2["supp_start_date"]);
		$_POST['supp_sector']  = $myrow2["supp_sector"];
		$_POST['supp_class']  = $myrow2["supp_class"];
		$_POST['supp_custom_one']  = $myrow2["supp_custom_one"];
		$_POST['supp_custom_two']  = $myrow2["supp_custom_two"];
		$_POST['supp_custom_three']  = $myrow2["supp_custom_three"];
		$_POST['supp_custom_four']  = $myrow2["supp_custom_four"];

		set_focus('supp_valid_digit');
	} 

	table_section_title(_("Basic Data"));

	label_row(_("Supplier Name:"),$_POST['supp_name']);
	label_row(_("Supplier Short Name:"),$_POST['supp_ref']);
	label_row(_("GSTNo:"),$_POST['gst_no']);
	text_row(_("Validation Digit:"), 'supp_valid_digit', null, 40, 1);
	document_types_list_row(_("Type of Document:"), 'supp_doc_type', $_POST['supp_doc_type']);
	customer_class_list_row(_("Supplier Class:"), 'supp_class', $_POST['supp_class']);
	label_row(_("Website:"),$_POST['website']);
	$currency_name = get_currency($myrow["curr_code"]);
	label_row(_("New Supplier's Currency:"), $currency_name['currency']);
	$tax_group_name = get_tax_group($myrow["tax_group_id"]);
	label_row(_("Tax Group:"), $tax_group_name['name']);
	label_row(_("Our Customer No:"),$_POST['supp_account_no']);
	date_row(_("Supplier Since") . ":", 'supp_start_date', '', false);

	table_section_title(_("Purchasing"));
	label_row(_("Bank Name/Account:"),$_POST['bank_account']);
	label_row(_("Credit Limit:"),$_POST['credit_limit']);
	$payment_terms_name = get_payment_terms($myrow["payment_terms"]);
	label_row(_("Payment Terms:"), $payment_terms_name['terms']);
	label_row(_("Prices contain tax included:"), $_POST['tax_included'] ? _('Yes') : _('No'));

	table_section_title(_("Accounts"));
	$payable_accname = get_gl_account_name($_POST['payable_account']);
	$purchase_accname = get_gl_account_name_orundefined($_POST['purchase_account']);
	$payment_discount = get_gl_account_name($_POST['payment_discount_account']);
	label_row(_("Accounts Payable Account:"),$_POST['payable_account'] . " ".$payable_accname);
	label_row(_("Purchase Account:"),$_POST['purchase_account'] . " ".$purchase_accname);
	label_row(_("Purchase Discount Account:"),$_POST['payment_discount_account'] . " ".$payment_discount);

	table_section(2);

	table_section_title(_("Additional Information"));
	text_row(get_supp_custom_labels_name(1).':', 'supp_custom_one', null, 40, 255);
	text_row(get_supp_custom_labels_name(2).':', 'supp_custom_two', null, 40, 255);
	text_row(get_supp_custom_labels_name(3).':', 'supp_custom_three', null, 40, 255);
	text_row(get_supp_custom_labels_name(4).':', 'supp_custom_four', null, 40, 255);
	sectors_list_row(_("Sector:"), 'supp_sector');

	table_section_title(_("Addresses"));
	readonly_textarea_row(_("Mailing Address:<br>\n(Read Only)"), 'address', null, 35, 5);
	readonly_textarea_row(_("Physical Address:<br>\n(Read Only)"), 'supp_address', null, 35, 5);
	city_list_row(_("City:"), 'supp_city');
	departments_list_row(_("State/Department:"), 'supp_department');
	country_list_row(_("Country:"), 'supp_country');
	text_row(_("Postcode:"), 'supp_postcode', null, 30, 30);

	table_section_title(_("General"));
	readonly_textarea_row(_("General Notes:<br>\n (Read Only)"), 'notes', null, 35, 5);
	label_row(_("Supplier Status:"),($myrow['inactive']==1 ? _("Inactive") : _("Active")), -1);

	end_outer_table(1);

	div_start('controls');

	if ($supplier_id) 
	{
		submit_center_first('submit', _("Update Supplier Additional Information"), 
		  _('Update supplier  additional information'), $page_nested ? true : 'default');
		submit_center_last('delete', _("Delete Supplier Additional Information"), 
		  _('Delete supplier additional information'), true);
	}
	else 
	{
		display_heading(_('Select a Supplier'));
	}
	div_end();
}

if (isset($_POST['submit'])) 
{

	begin_transaction();
	if ($supplier_id) 
	{
	$add_supp_info_exists = db_query("SELECT supp_supplier_id FROM ".TB_PREF."addfields_supp where supp_supplier_id = '$supplier_id' LIMIT 1");
		if(db_fetch($add_supp_info_exists)) 
			{
		        update_supplier_additional_info($_POST['supplier_id'], 
		        $_POST['supp_city'], $_POST['supp_department'],
				$_POST['supp_country'], $_POST['supp_postcode'], 
				$_POST['supp_doc_type'], $_POST['supp_valid_digit'], 
				$_POST['supp_start_date'], $_POST['supp_sector'], 
				$_POST['supp_class'], $_POST['supp_custom_one'], 
				$_POST['supp_custom_two'], $_POST['supp_custom_three'], 
				$_POST['supp_custom_four']);
		    } 
		    else 
		    {
		        add_supplier_additional_info($_POST['supplier_id'], 
		        $_POST['supp_city'], $_POST['supp_department'],
				$_POST['supp_country'], $_POST['supp_postcode'], 
				$_POST['supp_doc_type'], $_POST['supp_valid_digit'], 
				$_POST['supp_start_date'], $_POST['supp_sector'], 
				$_POST['supp_class'], $_POST['supp_custom_one'], 
				$_POST['supp_custom_two'], $_POST['supp_custom_three'], 
				$_POST['supp_custom_four']);
		}
		$Ajax->activate('supplier_id');
		display_notification(_("Supplier additional information has been updated."));
	}
	commit_transaction();

} 

elseif (isset($_POST['delete']) && $_POST['delete'] != "") 
{
		delete_supplier_additional_info($_POST['supplier_id']);
		$Ajax->activate('_page_body');
		display_notification("#" . $_POST['supplier_id'] . " " . _("Supplier Additional Infomation has been deleted."));
}

start_form();

if (db_has_suppliers()) 
{
	start_table(false, "", 3);
	start_row();
	supplier_list_cells(_("Select a supplier: "), 'supplier_id', null,
		  _('Select a supplier'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();
	if (get_post('_show_inactive_update')) {
		$Ajax->activate('supplier_id');
		set_focus('supplier_id');
	}
} 
else 
{
	hidden('supplier_id', get_post('supplier_id'));
}

if ($supplier_id)
	supplier_settings_add_info($supplier_id);

end_form();
end_page();
