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
$page_security = 'SA_ITEM';
$path_to_root = "../../..";
include($path_to_root . "/includes/session.inc");

$js = "";
if (user_use_date_picker())
	$js .= get_js_date_picker();

$_SESSION['page_title'] = _($help_context = "Add Additional Item Information");


page($_SESSION['page_title'], false, false, "", $js);
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/inventory/includes/inventory_db.inc");
include_once($path_to_root . "/fixed_assets/includes/fixed_assets_db.inc");
include_once($path_to_root . "/modules/additional_fields/includes/ui/additional_cust_info_ui.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");
//-----------------------------------------------------------------------------------

if (isset($_GET['stock_id']))
{
	$_POST['stock_id'] = $_GET['stock_id'];

}

$stock_id = get_post('stock_id');
$Ajax->activate('details');
//------------------------------------------------------------------------------------
function item_settings_add_info(&$stock_id) 
{
	global $SysPrefs, $path_to_root, $page_nested, $stock_types, $Ajax;
	
	start_outer_table(TABLESTYLE2);

	table_section(1);

	table_section_title(_("General Settings"));

	if ($stock_id) 
	{
		$myrow = get_item($_POST['stock_id']);
		$_POST['existing_stock_id'] = $myrow["stock_id"];
		$_POST['long_description'] = $myrow["long_description"];
		$_POST['description'] = $myrow["description"];
		$_POST['category_id']  = $myrow["category_id"];
		$_POST['tax_type_id']  = $myrow["tax_type_id"];
		$_POST['units']  = $myrow["units"];
		$_POST['mb_flag']  = $myrow["mb_flag"];

		$_POST['depreciation_method'] = $myrow['depreciation_method'];
		$_POST['depreciation_rate'] = number_format2($myrow['depreciation_rate'], 1);
		$_POST['depreciation_factor'] = number_format2($myrow['depreciation_factor'], 1);
		$_POST['depreciation_start'] = sql2date($myrow['depreciation_start']);
		$_POST['depreciation_date'] = sql2date($myrow['depreciation_date']);
		$_POST['fa_class_id'] = $myrow['fa_class_id'];
		$_POST['material_cost'] = $myrow['material_cost'];
		$_POST['purchase_cost'] = $myrow['purchase_cost'];
		
		$_POST['sales_account'] =  $myrow['sales_account'];
		$_POST['inventory_account'] = $myrow['inventory_account'];
		$_POST['cogs_account'] = $myrow['cogs_account'];
		$_POST['adjustment_account']	= $myrow['adjustment_account'];
		$_POST['wip_account']	= $myrow['wip_account'];
		$_POST['dimension_id']	= $myrow['dimension_id'];
		$_POST['dimension2_id']	= $myrow['dimension2_id'];
		$_POST['no_sale']	= $myrow['no_sale'];
		$_POST['no_purchase']	= $myrow['no_purchase'];
		$_POST['del_image'] = 0;
		$_POST['inactive'] = $myrow["inactive"];
		$_POST['editable'] = $myrow["editable"];
		$is_active = $myrow["inactive"];
		
		$myrow2 = get_item_additional_info($_POST['stock_id']);
		$_POST['stock_id'] = $myrow2["item_stock_id"];
		$_POST['item_bin_num']  = $myrow2["item_bin_num"];
		$_POST['item_prime_supp']  = $myrow2["item_prime_supp"];
		$_POST['item_prime_supp_no']  = $myrow2["item_prime_supp_no"];
		$_POST['item_alternative_part_no']  = $myrow2["item_alternative_part_no"];
		$_POST['item_manu_part_no']  = $myrow2["item_manu_part_no"];
		$_POST['item_start_date']  = sql2date($myrow2["item_start_date"]);
		$_POST['item_custom_one']  = $myrow2["item_custom_one"];
		$_POST['item_custom_two']  = $myrow2["item_custom_two"];
		$_POST['item_custom_three']  = $myrow2["item_custom_three"];
		$_POST['item_custom_four']  = $myrow2["item_custom_four"];

		label_row(_("Item Code:"),$_POST['existing_stock_id']);
		set_focus('item_bin_num');
		
	}

	label_row(_("Name:"),$_POST['description']);
	readonly_textarea_row(_("Description:<br>\n(Read Only)"), 'long_description', null, 42, 3);
	text_row(_("Bin number:"), 'item_bin_num', null, 50, 200);
	supplier_list_row(_("Primary supplier:"), 'item_prime_supp', null, false, false, false, false);
	text_row(_("Primary suppliers Part number:"), 'item_prime_supp_no', null, 50, 200);
	text_row(_("Alternative part number:"), 'item_alternative_part_no', null, 50, 200);
	text_row(_("Manufacturers part number:"), 'item_manu_part_no', null, 50, 200);
	$category_name = get_category_name($myrow["category_id"]);
	label_row(_("Category:"), $category_name);
	$item_tax_type_name = get_item_tax_type($myrow["tax_type_id"]);
	label_row(_("Item Tax Type:"), $item_tax_type_name['name']);
	label_row(_("Item Type:"),$stock_types[$myrow["mb_flag"]]);
	label_row(_("Units of Measure:"),$_POST['units']);
	label_row(_("Editable description:"), $_POST['editable'] ? _('Yes') : _('No'));
	label_row(_("Exclude from sales:"), $_POST['no_sale'] ? _('Yes') : _('No'));
	label_row(_("Exclude from purchases:"), $_POST['no_purchase'] ? _('Yes') : _('No'));

	table_section(2);
	
	table_section_title(_("GL Accounts"));
	
	$sales_accname = get_gl_account_name($_POST['sales_account']);
	$inventory_accname = get_gl_account_name($_POST['inventory_account']);
	$cogs_accname = get_gl_account_name($_POST['cogs_account']);
	$adjustment_accname = get_gl_account_name($_POST['adjustment_account']);
	$wip_accname = get_gl_account_name($_POST['wip_account']);
	label_row(_("Sales Account:"),$_POST['sales_account'] . " ".$sales_accname);
	
	if (!is_service($_POST['mb_flag'])) 
	{
		label_row(_("Inventory Account:"),$_POST['inventory_account'] . " ".$inventory_accname);
		label_row(_("C.O.G.S. Account:"),$_POST['cogs_account'] . " ".$cogs_accname);
		label_row(_("Inventory Adjustments Account:"),$_POST['adjustment_account'] . " ".$adjustment_accname);
	}
	else 
	{
		label_row(_("C.O.G.S. Account:"),$_POST['cogs_account'] . " ".$cogs_accname);
	}


	if (is_manufactured($_POST['mb_flag']))
		label_row(_("WIP Account:"),$_POST['wip_account'] . " ".$wip_accname);

	table_section_title(_("Other"));
	text_row(get_item_custom_labels_name(1).':', 'item_custom_one', null, 40, 255);
	text_row(get_item_custom_labels_name(2).':', 'item_custom_two', null, 40, 255);
	text_row(get_item_custom_labels_name(3).':', 'item_custom_three', null, 40, 255);
	text_row(get_item_custom_labels_name(4).':', 'item_custom_four', null, 40, 255);
	date_row(_("Stocked Since") . ":", 'item_start_date', '', false);

	label_row(_("Item Status:"),($myrow['inactive']==1 ? _("Inactive") : _("Active")), -1);
	
	end_outer_table(1);

	div_start('controls');
	if ($stock_id)
	{
		submit_center_first('addupdate', _("Update Item Additional Information"), 
			_('Update item additional information'), $page_nested ? true : 'default');
		submit('delete', _("Delete This Item Additional Information"), true, '', true);
	} 
	else 
	{
		display_heading(_('Select an Item'));
	}

	div_end();
}

if (isset($_POST['addupdate'])) 
{
	
	if ($stock_id) 
	{
		$add_item_info_exists = db_query("SELECT item_stock_id FROM ".TB_PREF."addfields_item where item_stock_id = '$stock_id' LIMIT 1");
		if(db_fetch($add_item_info_exists)) 
			{
				update_item_additional_info($_POST['stock_id'], 
				$_POST['item_bin_num'], $_POST['item_prime_supp'],
				$_POST['item_prime_supp_no'], $_POST['item_alternative_part_no'], 
				$_POST['item_manu_part_no'], $_POST['item_start_date'], 
				$_POST['item_custom_one'], $_POST['item_custom_two'], 
				$_POST['item_custom_three'], $_POST['item_custom_four']);
			} 
		else 
			{
				add_item_additional_info($_POST['stock_id'], 
				$_POST['item_bin_num'], $_POST['item_prime_supp'],
				$_POST['item_prime_supp_no'], $_POST['item_alternative_part_no'], 
				$_POST['item_manu_part_no'], $_POST['item_start_date'], 
				$_POST['item_custom_one'], $_POST['item_custom_two'], 
				$_POST['item_custom_three'], $_POST['item_custom_four']);
			}
			$Ajax->activate('stock_id'); 
			display_notification(_("Item additional infomation has been updated."));
	}
} 

elseif (isset($_POST['delete']) && $_POST['delete'] != "") 
{
		delete_item_additional_info($stock_id);
		$Ajax->activate('_page_body');
		display_notification(_("Selected item additional infomation has been deleted."));	
}

start_form(true);

if (db_has_stock_items()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
	stock_items_list_cells(_("Select an item:"), 'stock_id', null,
		_('Select item'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();

	if (get_post('_show_inactive_update')) {
		$Ajax->activate('stock_id');
		set_focus('stock_id');
	}
}
else
{
	hidden('stock_id', get_post('stock_id'));
}

div_start('details');
$stock_id = get_post('stock_id');
if ($stock_id)
	{
		item_settings_add_info($stock_id);
	}

div_end();		

end_form();
end_page();
