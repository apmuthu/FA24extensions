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
function update_item_additional_info($item_stock_id, $item_bin_num, $item_prime_supp, 
	$item_prime_supp_no, $item_alternative_part_no, $item_manu_part_no, 
	$item_start_date, $item_custom_one, $item_custom_two, $item_custom_three, 
	$item_custom_four)
{
	$date = date2sql($item_start_date);
	$sql = "UPDATE ".TB_PREF."addfields_item SET 
		item_stock_id=".db_escape($item_stock_id).",
		item_bin_num=".db_escape($item_bin_num).",
		item_prime_supp=".db_escape($item_prime_supp).",
		item_prime_supp_no=".db_escape($item_prime_supp_no).",
		item_alternative_part_no=".db_escape($item_alternative_part_no).",
		item_manu_part_no=".db_escape($item_manu_part_no).",
		item_start_date='$date',
		item_custom_one=".db_escape($item_custom_one).",
		item_custom_two=".db_escape($item_custom_two).",
		item_custom_three=".db_escape($item_custom_three).",
		item_custom_four=".db_escape($item_custom_four);

	$sql .= " WHERE item_stock_id=".db_escape($item_stock_id);

	db_query($sql, "The item could not be updated");

}

function add_item_additional_info($item_stock_id, $item_bin_num, $item_prime_supp, 
	$item_prime_supp_no, $item_alternative_part_no, $item_manu_part_no, 
	$item_start_date, $item_custom_one, $item_custom_two, $item_custom_three, 
	$item_custom_four)
{
	$date = date2sql($item_start_date);
	$sql = "INSERT INTO ".TB_PREF."addfields_item (item_stock_id, item_bin_num, 
		item_prime_supp, item_prime_supp_no, item_alternative_part_no, 
		item_manu_part_no, item_start_date, item_custom_one, item_custom_two, 
		item_custom_three, item_custom_four)
		VALUES (".db_escape($item_stock_id).", ".db_escape($item_bin_num).", ".db_escape($item_prime_supp).",
		".db_escape($item_prime_supp_no).", ".db_escape($item_alternative_part_no).", "
		.db_escape($item_manu_part_no).",'$date', ".db_escape($item_custom_one).",".db_escape($item_custom_two)
		.", ".db_escape($item_custom_three).", "
		.db_escape($item_custom_four).")";

	db_query($sql, "The item could not be added");
}

function delete_item_additional_info($stock_id)
{
	$sql="DELETE FROM ".TB_PREF."addfields_item WHERE item_stock_id=".db_escape($stock_id);
	db_query($sql, "could not delete stock item additonal info");
}


function get_item_additional_info($stock_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_item WHERE item_stock_id=".db_escape($stock_id);

	$result = db_query($sql, "could not get item additonal info");

	return db_fetch($result);
}

function get_item_bin_no($stock_id)
{
	$sql = "SELECT item_bin_num FROM ".TB_PREF."addfields_item WHERE item_stock_id=".db_escape($stock_id);

	$result = db_query($sql, "could not get item bin number");

	return db_fetch($result);
}


function get_gl_account_name_orundefined($code)
	{
		if ($code == 0)
			return 'Use Item Inventory/COGS Account';
		else 
		{
		$sql = "SELECT account_name from ".TB_PREF."chart_master WHERE account_code=".db_escape($code);

		$result = db_query($sql);

			if (db_num_rows($result) == 1)
			{
				$row = db_fetch_row($result);
				return $row[0];
			}

		}

	}