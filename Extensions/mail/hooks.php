<?php

class hooks_mail extends hooks {
	var $module_name = 'mail'; 

	/*
	* Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'system':
			$app->add_rapp_function(0, _("Mail sending setup"),
				$path_to_root."/modules/".$this->module_name."/mail_setup.php?", 'SA_SETUPCOMPANY', MENU_SETTINGS);
			break;
		}
	}
}
