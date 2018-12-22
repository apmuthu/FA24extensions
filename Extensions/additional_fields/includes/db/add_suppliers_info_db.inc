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

function add_supplier_additional_info($supp_supplier_id, $supp_city, $supp_department, $supp_country, 
	$supp_postcode, $supp_doc_type, $supp_valid_digit, $supp_start_date, $supp_sector, $supp_class, $supp_custom_one, 
	$supp_custom_two, $supp_custom_three, $supp_custom_four)
{
	$date = date2sql($supp_start_date);
	$sql = "INSERT INTO ".TB_PREF."addfields_supp (supp_supplier_id, supp_city, supp_department, 
		supp_country, supp_postcode, supp_doc_type, supp_valid_digit, supp_start_date, supp_sector, supp_class, 
		supp_custom_one, supp_custom_two, supp_custom_three, supp_custom_four) VALUES (".db_escape($supp_supplier_id) .", "
		.db_escape($supp_city) .", "
		.db_escape($supp_department) . ", "
		.db_escape($supp_country) . ","
		.db_escape($supp_postcode) . ", " 
		.db_escape($supp_doc_type) . ", "
		.db_escape($supp_valid_digit) . ", "
		.db_escape($date) . ", "
		.db_escape($supp_sector) . ", "
		.db_escape($supp_class) . ", "
		.db_escape($supp_custom_one) . ", "
		.db_escape($supp_custom_two) . ", "
		.db_escape($supp_custom_three) .", "
		.db_escape($supp_custom_four).")";

	db_query($sql,"The supplier additonal information could not be added");
}

function update_supplier_additional_info($supp_supplier_id, $supp_city, $supp_department, $supp_country, 
	$supp_postcode, $supp_doc_type, $supp_valid_digit, $supp_start_date, $supp_sector, $supp_class, $supp_custom_one, 
	$supp_custom_two, $supp_custom_three, $supp_custom_four)
{
	$date = date2sql($supp_start_date);
	$sql = "UPDATE ".TB_PREF."addfields_supp SET 
		supp_supplier_id=" . db_escape($supp_supplier_id) . ", 
		supp_city=" . db_escape($supp_city) . ",
		supp_department=".db_escape($supp_department) . ", 
		supp_country=".db_escape($supp_country) . ", 
		supp_postcode=".db_escape($supp_postcode) . ", 
		supp_doc_type=".db_escape($supp_doc_type) . ", 
		supp_valid_digit=".db_escape($supp_valid_digit) . ",
		supp_start_date='$date', 
		supp_sector=".db_escape($supp_sector) . ", 
		supp_class=" .db_escape($supp_class) . ", 
		supp_custom_one=" .db_escape($supp_custom_one) . ", 
		supp_custom_two=" .db_escape($supp_custom_two) . ", 
		supp_custom_three = ".db_escape($supp_custom_three) . ", 
		supp_custom_four=".db_escape($supp_custom_four) ."
		WHERE supp_supplier_id = ".db_escape($supp_supplier_id);

	db_query($sql,"The supplier additonal information could not be updated");
}

function delete_supplier_additional_info($supplier_id)
{
	$sql="DELETE FROM ".TB_PREF."addfields_supp WHERE supp_supplier_id=".db_escape($supplier_id);
	db_query($sql,"check failed");
}


function get_supplier_additional_info($supplier_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_supp WHERE supp_supplier_id=".db_escape($supplier_id);

	$result = db_query($sql, "could not get supplier additonal information");

	return db_fetch($result);
}


