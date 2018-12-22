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
function update_item_custom_labels($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."addfields_item_custom_labels SET description=".db_escape($description)." WHERE id = ".db_escape($selected_id);
   	db_query($sql,"The Item Custom Field Label could not be updated");
}


function get_item_custom_labelss()
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_item_custom_labels";
	// if (!$show_inactive) $sql .= " WHERE !inactive";
	$sql .= " ORDER BY id";
	return db_query($sql,"could not get Item Custom Field Labels");
}

function get_item_custom_labels($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."addfields_item_custom_labels WHERE id=".db_escape($selected_id);

	$result = db_query($sql,"could not get Item Custom Field Label");
	return db_fetch($result);
}

function get_item_custom_labels_name($label_id)
{
	$sql = "SELECT description FROM ".TB_PREF."addfields_item_custom_labels WHERE id = ".db_escape($label_id);
	$result = db_query($sql, "could not get Item Custom Field Label");
	$row = db_fetch($result);
	return $row[0];
}


