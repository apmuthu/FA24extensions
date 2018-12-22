<?php

//-----------------------------------------------------------------------------------------------
//DOCUMENT TYPES
function document_types_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT doc_type_code, description, inactive FROM ".TB_PREF."addfields_doc_type";

	return combo_input($name, $selected_id, $sql, 'doc_type_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Document Types") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function document_types_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo document_types_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function document_types_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	document_types_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------
//CUSTOMER CLASSES
function customer_class_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT cust_class_code, description, inactive FROM ".TB_PREF."addfields_cust_class";

	return combo_input($name, $selected_id, $sql, 'cust_class_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Customer Classes") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function customer_class_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo customer_class_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function customer_class_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	customer_class_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------
//Paises
function country_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT country_code, description, codigo, inactive FROM ".TB_PREF."addfields_country";

	return combo_input($name, $selected_id, $sql, 'country_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Document Types") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function country_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo country_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function country_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	country_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------

//Departments
function departments_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT departments_code, description, codigo, inactive FROM ".TB_PREF."addfields_departments";

	return combo_input($name, $selected_id, $sql, 'departments_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Departments") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function departments_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo departments_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function departments_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	departments_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------
//Municipios
function city_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT city_code, description, codigo, inactive FROM ".TB_PREF."addfields_city";

	return combo_input($name, $selected_id, $sql, 'city_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Municipios") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function city_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo city_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function city_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	city_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------
//Sectors
function sectors_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT sectors_code, description, codigo, inactive FROM ".TB_PREF."addfields_sectors";

	return combo_input($name, $selected_id, $sql, 'sectors_code', 'description',
	array(
		'spec_option' => $special_option===true ? _("All Sectors") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	) );
}

function sectors_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo sectors_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function sectors_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	sectors_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

//-----------------------------------------------------------------------------------------------
// Not used when CIS is integrated
function readonly_textarea_cells($label, $name, $value, $cols, $rows, $title = null, $params="")
{
  	global $Ajax;

	default_focus($name);
	if ($label != null)
		echo "<td $params>$label</td>\n";
	if ($value == null)
		$value = (!isset($_POST[$name]) ? "" : $_POST[$name]);
	echo "<td><textarea name='$name' cols='$cols' rows='$rows' readonly"
	.($title ? " title='$title'" : '')
	.">$value</textarea></td>\n";
	$Ajax->addUpdate($name, $name, $value);
}

function readonly_textarea_row($label, $name, $value, $cols, $rows, $title=null, $params="")
{
	echo "<tr><td class='label'>$label</td>";
	readonly_textarea_cells(null, $name, $value, $cols, $rows, $title, $params);
	echo "</tr>\n";
}
//-----------------------------------------------------------------------------------
