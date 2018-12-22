<?php
/**********************************************************************
	Released under the terms of the GNU General Public License, GPL,
	as published by the Free Software Foundation, either version 3
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
$page_security = 'SA_ITEMSVALREP';
// ----------------------------------------------------------------
// $ Revision:	1.0 $
// Creator:	Chris Fuller
// date_:	2018-10-10
// Title:	Item Details Listing
// ----------------------------------------------------------------
$path_to_root="..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/gl/includes/gl_db.inc");
include_once($path_to_root . "/inventory/includes/inventory_db.inc");
include_once($path_to_root . "/includes/db/manufacturing_db.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");

//----------------------------------------------------------------------------------------------------

print_stock_check();

//----------------------------------------------------------------------------------------------------
function get_items_add_info($category)
{
	$sql = "SELECT item.category_id,
			category.description AS cat_description,
			item.stock_id,
			item.units,
			item.description,
			item.inactive,
			addfields.item_stock_id,
			addfields.item_bin_num,
			addfields.item_prime_supp,
			addfields.item_prime_supp_no,
			addfields.item_alternative_part_no,
			addfields.item_manu_part_no,
			addfields.item_start_date,
			addfields.item_custom_one,
			addfields.item_custom_two,
			addfields.item_custom_three,
			addfields.item_custom_four
		FROM ".TB_PREF."stock_master item
			INNER JOIN ".TB_PREF."stock_category category ON item.category_id=category.category_id
			INNER JOIN ".TB_PREF."addfields_item addfields ON item.stock_id=addfields.item_stock_id
			WHERE item.category_id=category.category_id";
	
	$sql .= " GROUP BY item.category_id,
		category.description,
		item.stock_id,
		item.description
		ORDER BY item.category_id,
		item.stock_id";

    return db_query($sql,"No items were returned");
}

//----------------------------------------------------------------------------------------------------
function print_stock_check()
{
    global $path_to_root, $SysPrefs;

   	$comments = $_POST['PARAM_0'];

	include_once($path_to_root . "/reporting/includes/excel_report.inc");

	$orientation = 'L';

	$category = 0;
	$cat = get_category_name($category);
	$item_custom_label_one = get_item_custom_labels_name(1);
    $item_custom_label_two = get_item_custom_labels_name(2);
    $item_custom_label_three = get_item_custom_labels_name(3);
    $item_custom_label_four = get_item_custom_labels_name(4);

	$cols = array(0, 80, 220, 260, 300, 340, 440, 560, 680, 800, 860, 980, 1100, 1220, 1340);
					//1	   2    3    4    5    6    7    8    9   10   11    12    13    14
	$headers = array(_('Stock ID'), _('Description'), _('UOM'), _('Active?'),
		 _('Bin number'), _('Primary supplier'), _('Primary suppliers Part number'), _('Alternative part number'), 
		 _('Manufacturers part number'), _('Stocked Since'), $item_custom_label_one, $item_custom_label_two, $item_custom_label_three, $item_custom_label_four);
	$aligns = array('left',	'left',	'left', 'left', 'left', 'left', 'left','left',	'left',	'left', 'left', 'left', 'left', 'left');

    $params =   array(
		0 => $comments,
    	1 => array('text' => _('Category'), 'from' => $cat, 'to' => ''));
	

   	$rep = new FrontReport(_('Item Details Listing'), "ItemDetailsListing", user_pagesize(), 9, $orientation);
    if ($orientation == 'L')
    	recalculate_cols($cols);

    $rep->Font();
    $rep->Info($params, $cols, $headers, $aligns);
    $rep->NewPage();

	$res = get_items_add_info($category);
	$catt = '';
	while ($trans=db_fetch($res))
	{
		
		if ($catt != $trans['cat_description'])
		{
			if ($catt != '')
			{
				$rep->Line($rep->row - 2);
				$rep->NewLine(2, 3);
			}
			$rep->TextCol(0, 1, $trans['category_id']);
			$rep->TextCol(1, 2, $trans['cat_description']);
			$catt = $trans['cat_description'];
			$rep->NewLine();
		}
		$rep->NewLine();
		$dec = get_qty_dec($trans['stock_id']);
		$rep->TextCol(0, 1, $trans['stock_id']);
		$rep->TextCol(1, 2, $trans['description']);
		$rep->TextCol(2, 3, $trans['units']);


		$is_active = $trans["inactive"];
		if ($is_active)
	    	$rep->TextCol(3, 4, _('Inactive'));
		else
			$rep->TextCol(3, 4, _('Active'));
		$rep->TextCol(4, 5, $trans['item_bin_num']);
		$primary_supplier = get_supplier_name($trans['item_prime_supp']);
		$rep->TextCol(5, 6, $primary_supplier);
		$rep->TextCol(6, 7, $trans['item_prime_supp_no']);
		$rep->TextCol(7, 8, $trans['item_alternative_part_no']);
		$rep->TextCol(8, 9, $trans['item_manu_part_no']);
		$rep->DateCol(9, 10, $trans['item_start_date'], true);
		$rep->TextCol(10, 11, $trans['item_custom_one']);
		$rep->TextCol(11, 12, $trans['item_custom_two']);
		$rep->TextCol(12, 13, $trans['item_custom_three']);
		$rep->TextCol(13, 14, $trans['item_custom_four']);
		
	}
	$rep->Line($rep->row - 4);
	$rep->NewLine();
    $rep->End();
}

