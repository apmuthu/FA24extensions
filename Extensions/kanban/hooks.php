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
define ('SS_KANBAN', 252<<8);

class kanban_app extends application {

    function __construct() {
        global $path_to_root;

        parent::__construct("kanban", _($this->help_context = "Projects"));

        $this->add_module(_("Transactions"));
        // $this->add_lapp_function(0, _('TEST'), $path_to_root.'/modules/kanban/test.php', 'SA_MANAGER', MENU_TRANSACTION);

        $this->add_module(_("Inquiries and Reports"));
        $this->add_lapp_function(1, _('Projects List'), $path_to_root.'/modules/kanban/manage/projects.php?action=list', 'SA_MANAGER', MENU_TRANSACTION);

        $this->add_module(_("Maintenance"));
        $this->add_lapp_function(2, _('Manage Project'), $path_to_root.'/modules/kanban/manage/add_project.php', 'SA_MANAGER', MENU_ENTRY);

		$this->add_extensions();
    }
}

class hooks_kanban extends hooks {

    function __construct() {
 		$this->module_name = 'kanban';
 	}

    function install_tabs($app) {
        $app->add_application(new kanban_app);
    }

    function install_access() {
        $security_sections[SS_KANBAN] =  _("Project Management");
        $security_areas['SA_MANAGER'] = array(SS_KANBAN|1, _("Project manager"));
        $security_areas['SA_MEMBER'] = array(SS_KANBAN|1, _("Project member"));
        return array($security_areas, $security_sections);
    }

    function activate_extension($company, $check_only=true) {
        global $db_connections;

        $updates = array( 'update.sql' => array(''));

        return $this->update_databases($company, $updates, $check_only);
    }

    function deactivate_extension($company, $check_only=true) {
        global $db_connections;

        $updates = array('remove.sql' => array(''));

        return $this->update_databases($company, $updates, $check_only);
    }
}
