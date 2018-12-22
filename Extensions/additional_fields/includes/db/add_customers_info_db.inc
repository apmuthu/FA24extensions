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

function add_customer_additional_info($cust_debtor_no, $cust_city, $cust_department, $cust_country, 
	$cust_postcode, $cust_doc_type, $cust_valid_digit, $cust_start_date, $cust_sector, $cust_class, $cust_custom_one, 
	$cust_custom_two, $cust_custom_three, $cust_custom_four)
{
	$date = date2sql($cust_start_date);
	$sql = "INSERT INTO ".TB_PREF."addfields_cust (cust_debtor_no, cust_city, cust_department, 
		cust_country, cust_postcode, cust_doc_type, cust_valid_digit, cust_start_date, cust_sector, cust_class, 
		cust_custom_one, cust_custom_two, cust_custom_three, cust_custom_four) VALUES ("
		.db_escape($cust_debtor_no) .", "
		.db_escape($cust_city) .", "
		.db_escape($cust_department) . ", "
		.db_escape($cust_country) . ","
		.db_escape($cust_postcode) . ", " 
		.db_escape($cust_doc_type) . ", "
		.db_escape($cust_valid_digit) . ", "
		.db_escape($date) . ", "
		.db_escape($cust_sector) . ", "
		.db_escape($cust_class) . ", "
		.db_escape($cust_custom_one) . ", "
		.db_escape($cust_custom_two) . ", "
		.db_escape($cust_custom_three) .", "
		.db_escape($cust_custom_four).")";
	db_query($sql,"The customer additional information could not be added");
}

function update_customer_additional_info($cust_debtor_no, $cust_city, $cust_department, $cust_country, 
	$cust_postcode, $cust_doc_type, $cust_valid_digit, $cust_start_date, $cust_sector, $cust_class, $cust_custom_one, 
	$cust_custom_two, $cust_custom_three, $cust_custom_four)
{
	$date = date2sql($cust_start_date);
	$sql = "UPDATE ".TB_PREF."addfields_cust SET 
		cust_debtor_no=" . db_escape($cust_debtor_no) . ", 
		cust_city=" . db_escape($cust_city) . ",
		cust_department=".db_escape($cust_department) . ", 
		cust_country=".db_escape($cust_country) . ", 
		cust_postcode=".db_escape($cust_postcode) . ", 
		cust_doc_type=".db_escape($cust_doc_type) . ", 
		cust_valid_digit=".db_escape($cust_valid_digit) . ",
		cust_start_date='$date', 
		cust_sector=".db_escape($cust_sector) . ", 
		cust_class=" .db_escape($cust_class) . ", 
		cust_custom_one=" .db_escape($cust_custom_one) . ", 
		cust_custom_two=" .db_escape($cust_custom_two) . ", 
		cust_custom_three = ".db_escape($cust_custom_three) . ", 
		cust_custom_four=".db_escape($cust_custom_four) ."
		WHERE cust_debtor_no = ".db_escape($cust_debtor_no);

	db_query($sql,"The customer additional information could not be updated");
}

function delete_customer_additional_info($customer_id)
{
	begin_transaction();
	delete_entity_contacts('customer', $customer_id);

	$sql = "DELETE FROM ".TB_PREF."addfields_cust WHERE cust_debtor_no=".db_escape($customer_id);;
	db_query($sql,"cannot delete customer additional infomation");
	commit_transaction();
}


//MOD
//----------------------------------------------------------------------------------
function get_customer_additional_info($customer_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_cust WHERE cust_debtor_no=".db_escape($customer_id);

	$result = db_query($sql, "could not get customer additonal info");

	return db_fetch($result);
}
//----------------------------------------------------------------------------------

//DOCUMENT TYPES

function add_document_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_doc_type (description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The document type could not be added");
}

function update_document_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."addfields_doc_type SET description=".db_escape($description)." WHERE doc_type_code = ".db_escape($selected_id);
   	db_query($sql,"The document type could not be updated");
}

function delete_document_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."addfields_doc_type WHERE doc_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete document type");
}

function get_document_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_doc_type";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get document types");
}

function get_document_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_doc_type WHERE doc_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get document type");
	return db_fetch($result);
}

function get_document_type_name($id)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_doc_type WHERE doc_type_code=".db_escape($id);

	$result = db_query($sql, "could not get document type");

	$row = db_fetch_row($result);
	return $row[0];
}


//----------------------------------------------------------------------------------

//CUSTOMER CLASSES

function add_cust_class($description)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_cust_class (description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The Customer Class could not be added");
}

function update_cust_class($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."addfields_cust_class SET description=".db_escape($description)." WHERE cust_class_code = ".db_escape($selected_id);
   	db_query($sql,"The Customer Class could not be updated");
}

function delete_cust_class($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."addfields_cust_class WHERE cust_class_code=".db_escape($selected_id);
	db_query($sql,"could not delete Customer Class");
}

function get_cust_classs($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_cust_class";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get Customer Classs");
}

function get_cust_class($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_cust_class WHERE cust_class_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get Customer Class");
	return db_fetch($result);
}

function get_cust_class_name($id)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_cust_class WHERE cust_class_code=".db_escape($id);

	$result = db_query($sql, "could not get Customer Class");

	$row = db_fetch_row($result);
	return $row[0];
}


//----------------------------------------------------------------------------------

//PAISES CLASSES

function add_country($description, $codigo)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_country (description, codigo) VALUES (".db_escape($description).", ".db_escape($codigo).")";
   	db_query($sql,"The Paises could not be added");
}

function update_country($country_code, $description, $codigo)
{
	$sql = "UPDATE ".TB_PREF."addfields_country SET description=".db_escape($description).", 
                                       codigo=".db_escape($codigo);

    $sql .= " WHERE country_code = ".db_escape($country_code);                                   
   	db_query($sql,"The Paises could not be updated");
}

function delete_country($country_code)
{
	$sql="DELETE FROM ".TB_PREF."addfields_country WHERE country_code=".db_escape($country_code);
	db_query($sql,"could not delete Paises");
}

function get_countrys($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_country";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get Paisess");
}

function get_country($country_code)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_country WHERE country_code=".db_escape($country_code);

	$result = db_query($sql,"could not get Paises");
	return db_fetch($result);
}

function get_country_name($country_code)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_country WHERE country_code=".db_escape($country_code);

	$result = db_query($sql, "could not get Paises");

	$row = db_fetch_row($result);
	return $row[0];
}

//----------------------------------------------------------------------------------

//Departments CLASSES

function add_departments($description, $codigo)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_departments (description, codigo) VALUES (".db_escape($description).", ".db_escape($codigo).")";
   	db_query($sql,"The Department could not be added");
}

function update_departments($departments_code, $description, $codigo)
{
	$sql = "UPDATE ".TB_PREF."addfields_departments SET description=".db_escape($description).", 
                                       codigo=".db_escape($codigo);

    $sql .= " WHERE departments_code = ".db_escape($departments_code);                                   
   	db_query($sql,"The Department could not be updated");
}

function delete_departments($departments_code)
{
	$sql="DELETE FROM ".TB_PREF."addfields_departments WHERE departments_code=".db_escape($departments_code);
	db_query($sql,"could not delete Department");
}

function get_departmentss($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_departments";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get Department");
}

function get_departments($departments_code)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_departments WHERE departments_code=".db_escape($departments_code);

	$result = db_query($sql,"could not get Department");
	return db_fetch($result);
}

function get_departments_name($departments_code)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_departments WHERE departments_code=".db_escape($departments_code);

	$result = db_query($sql, "could not get Department");

	$row = db_fetch_row($result);
	return $row[0];
}

//----------------------------------------------------------------------------------

//Municipios CLASSES

function add_city($description, $codigo)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_city (description, codigo) VALUES (".db_escape($description).", ".db_escape($codigo).")";
   	db_query($sql,"The Municipios could not be added");
}

function update_city($city_code, $description, $codigo)
{
	$sql = "UPDATE ".TB_PREF."addfields_city SET description=".db_escape($description).", 
                                       codigo=".db_escape($codigo);

    $sql .= " WHERE city_code = ".db_escape($city_code);                                   
   	db_query($sql,"The Municipios could not be updated");
}

function delete_city($city_code)
{
	$sql="DELETE FROM ".TB_PREF."addfields_city WHERE city_code=".db_escape($city_code);
	db_query($sql,"could not delete Municipios");
}

function get_citys($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_city";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get Municipios");
}

function get_city($city_code)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_city WHERE city_code=".db_escape($city_code);

	$result = db_query($sql,"could not get Municipios");
	return db_fetch($result);
}

function get_city_name($city_code)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_city WHERE city_code=".db_escape($city_code);

	$result = db_query($sql, "could not get Municipios");

	$row = db_fetch_row($result);
	return $row[0];
}


//----------------------------------------------------------------------------------

//Sectors

function add_sectors($description, $codigo)
{
	$sql = "INSERT INTO ".TB_PREF."addfields_sectors (description, codigo) VALUES (".db_escape($description).", ".db_escape($codigo).")";
   	db_query($sql,"The Sectors could not be added");
}

function update_sectors($sectors_code, $description, $codigo)
{
	$sql = "UPDATE ".TB_PREF."addfields_sectors SET description=".db_escape($description).", 
                                       codigo=".db_escape($codigo);

    $sql .= " WHERE sectors_code = ".db_escape($sectors_code);                                   
   	db_query($sql,"The Sectors could not be updated");
}

function delete_sectors($sectors_code)
{
	$sql="DELETE FROM ".TB_PREF."addfields_sectors WHERE sectors_code=".db_escape($sectors_code);
	db_query($sql,"could not delete Sectors");
}

function get_sectorss($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_sectors";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get Sectors");
}

function get_sectors($sectors_code)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_sectors WHERE sectors_code=".db_escape($sectors_code);

	$result = db_query($sql,"could not get Sectors");
	return db_fetch($result);
}

function get_sectors_name($sectors_code)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_sectors WHERE sectors_code=".db_escape($sectors_code);

	$result = db_query($sql, "could not get Sectors");

	$row = db_fetch_row($result);
	return $row[0];
}
//----------------------------------------------------------------------------------


//MOD
//----------------------------------------------------------------------------------
function get_customerbranch_additional_info($customer_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_branchcust WHERE branchcust_debtor_no=".db_escape($customer_id);

	$result = db_query($sql, "could not get customer additonal info");

	return db_fetch($result);
}
//----------------------------------------------------------------------------------
//CREDIT STATUS
function get_credit_status_reason($status_id)
{
	$sql = "SELECT reason_description FROM ".TB_PREF."credit_status WHERE id=".db_escape($status_id);

	$result = db_query($sql, "could not get credit status");

	// return db_fetch($result);
	$row = db_fetch_row($result);
	return $row[0];
}

//----------------------------------------------------------------------------------
//PAYMENT TERMS
function get_payment_term_name($selected_id)
{
	$sql = "SELECT terms FROM ".TB_PREF."payment_terms WHERE terms_indicator=".db_escape($selected_id);

	$result = db_query($sql, "could not get credit status");

	// return db_fetch($result);
	$row = db_fetch_row($result);
	return $row[0];
}