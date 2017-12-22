<?php
/*=======================================================\
|                        FrontKanban                     |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   01-12-2017                                  |
|   Description: Frontaccounting Project Management Ext  |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/

function projects_list($name, $id = null, $spec_option = false, $submit_on_change = false, $show_closed = false, $type = false)
{
	$sql = "SELECT proj_id, proj_name, closed FROM ".TB_PREF."projects ";

	return combo_input($name, $id, $sql, 'proj_id', 'proj_name',
	array(       
		'spec_option' => $spec_option,
		'select_submit' => $submit_on_change,
		'where' => $type == false ? 1 : array("proj_type = $type"),
		'async' => false,
		'show_inactive' => $show_closed
	));
}

//--------------------------------------------------------------------------

function projects_list_cells($label, $name, $id = null, $all_option = false, $submit_on_change = false, $show_inactive = false, $type = false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo projects_list($name, $id, $all_option, $submit_on_change, $show_inactive, $type);
	echo "</td>\n";
}

//--------------------------------------------------------------------------

function projects_list_row($label, $name, $id = null, $all_option = false, $submit_on_change = false, $show_inactive = false, $type = false)
{
	echo "<tr><td class='label'>$label</td>";
	projects_list_cells(null, $name, $id, $all_option, 
	$submit_on_change, $show_inactive, $type);
	echo "</tr>";
}
