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
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

$js = "";
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(700, 300);
if (user_use_date_picker())
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/kanban/includes/kanban_db.inc");
include_once($path_to_root . "/modules/kanban/includes/kanban_ui.inc");

//--------------------------------------------------------------------------

unset($_SESSION['project']);

function project_link($row) {
	return "<a href='?proj=".$row['proj_id']."'>".$row['proj_name']."</a>";
}
function check_overdue($row) {
	return false;
}
function get_owner($row) {
	return get_user($row['owner_id'])['real_name'];
}

function project_list() {
    $sql = get_projects();

        $cols = array(
          _('ID') => '',
          _('Name') => array('fun'=>'project_link'),
		  _('Description'),
          _('Type'),
          _('Created date') => array(),
          _('Closed date') => array(),
          _('Begin date') => array(),
          _('End date') => array(),
          _('Owner') => array('fun'=>'get_owner')
        );

        $table = new_db_pager('projects_tbl', $sql, $cols);
		$table->set_marker('check_overdue', _("Marked rows are overdue."));
        // $table->width = "60%";
	
	    display_note(_('Press name to go to project details.'));
        display_db_pager($table);
}

//--------------------------------------------------------------------------

if(isset($_GET['action']) && $_GET['action'] == 'list') {
    page(_($help_context = "Projects List"), false, false, "", $js);
    project_list();
} else {
	if(empty($_GET['proj']))
        $_SESSION['project'] = get_last_project()[0];
    else
        $_SESSION['project'] = $_GET['proj'];

    page($help_context = get_projects($_SESSION['project'])['proj_name'], false, false, "", $js);

    include_once("$path_to_root/modules/kanban/includes/ui/board.inc");
}
end_page();
