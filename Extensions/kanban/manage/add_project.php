<?php
/*=======================================================\
|                        FrontKanban                     |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   01-Dec-2017                                 |
|   Description: Frontaccounting Project Management Ext  |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/
$page_security = 'SA_MANAGER';
$path_to_root  = '../../..';

include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

$js = "";
if (user_use_date_picker())
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/kanban/includes/kanban_db.inc");
include_once($path_to_root . "/modules/kanban/includes/kanban_ui.inc");

page(_($help_context = "Create Project"), true, false, "", $js, true);

//-----------------------------------------------------------------------------

if(isset($_POST['addupdate'])) {
	if(strlen($_POST['proj_name']) == 0 || $_POST['proj_name'] == "") {
		display_error(_("The project name must be entered."));
		set_focus('proj_name');
	}
	else {
		write_project(false, $_POST['proj_name'], get_post('desc'), null, Today(), null, null, null, $_SESSION["wa_current_user"]->user);
		$id = db_insert_id();
		if(add_project_data_file($id))
		    display_notification(_('New project created'));
		else{
			delete_project($id);
			display_error(_('could not created data file'));
		}
	}
}

//-----------------------------------------------------------------------------

start_form();
start_table(TABLESTYLE_NOBORDER);
text_row(_("Project name:"), 'proj_name', get_post('proj_name'), 40, 50);
textarea_row(_("Description:"), 'desc', null, 36, 5);
end_table(1);

div_start('controls');
	submit_center('addupdate', _("Add New Project"), true, '', 'default');
div_end();

end_form(1);
end_page(true, true, false, 3);
