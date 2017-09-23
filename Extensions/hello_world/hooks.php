<?php

class hooks_hello_world extends hooks {
	var $module_name = 'hello_world'; 

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(1, "",""); // provide a menu spacer in right menu of second (1) section
				$app->add_rapp_function(1, _('Hello World'), 
					$path_to_root.'/modules/'.$this->module_name.'/hello_world.php', 'SA_OPEN', MENU_INQUIRY); // menu icons defined in applications/application.php
		}
	}

}
