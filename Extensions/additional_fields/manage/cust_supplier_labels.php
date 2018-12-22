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
$page_security = 'SA_ADD_FIELDS_SUPP_LABELS';
$path_to_root = "../../..";
include($path_to_root . "/includes/session.inc");

add_access_extensions();

page(_($help_context = "Supplier Custom Field Labels"));

include($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/additional_fields/includes/addfields_db.inc");

simple_page_mode(true);
if ($Mode=='UPDATE_ITEM') 
{

	$input_error = 0;

	if (strlen($_POST['description']) == 0) 
	{
		$input_error = 1;
		display_error(_("The Supplier Custom Field Label description cannot be empty."));
		set_focus('description');
	}

	if ($input_error != 1)
	{
    	if ($selected_id != -1) 
    	{
    		update_supp_custom_labels($selected_id, $_POST['description']);
			$note = _('Selected Supplier Custom Field Label has been updated');
    	} 

		display_notification($note);    	
		$Mode = 'RESET';
	}
} 

//-------------------------------------------------------------------------------------------------

$result = get_supp_custom_labelss();

start_form();
start_table(TABLESTYLE, "width='30%'");
$th = array(_("ID"), _("Supplier Custom Field Label"), "");

table_header($th);
$k = 0; 

while ($myrow = db_fetch($result)) 
{
	
	alt_table_row_color($k);
		
	label_cell($myrow["id"], "nowrap align='right'");
	label_cell($myrow["description"]);
 	edit_button_cell("Edit".$myrow["id"], _("Edit"));
	end_row();
}

end_table(1);

//-------------------------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
	$myrow = get_supp_custom_labels($selected_id);
	$_POST['description']  = $myrow["description"];
	hidden("selected_id", $selected_id);
	label_row(_("ID"), $myrow["id"]);
	text_row_ex(_("Supplier Custom Field Label:"), 'description', 30); 
}
end_table(1);

submit_cust_update_center($selected_id == -1, '', 'both');

end_form();

end_page();
