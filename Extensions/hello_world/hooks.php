<?php

include_once($path_to_root . "/modules/hello_world/helloworld.php");
class hooks_hello_world extends hooks {

	function __construct() {
		$this->module_name = 'hello_world';
	}

	/*
		Install additional menu options provided by module
	*/
    function install_tabs($app) {
        $app->add_application(new helloworld_app);

/*
	Default order of keys in $app->applications
	'orders','AP','stock','manuf','assets','proj','GL','hello'
	,'system' => $x['system'] // Setup gets added after all the applications
*/

// Change tab order
		$i = 4; // set this extension on the 4th tab
		$x = $app->applications;
		$y = array_pop($app->applications); // this application was added last just now
		$app->applications = Array();
		$app->applications = array_merge(array_slice($x, 0, $i-1), array('hello' => $y), array_slice($x, $i-1));
		unset($x,$y,$i);
    }
/*
	// generally use for placing menu items in standard / existing tabs
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'hello':
				$app->add_rapp_function(1, "",""); // provide a menu spacer in right menu of second (1) section
				$app->add_rapp_function(1, _('Hello World'), 
					$path_to_root.'/modules/'.$this->module_name.'/hello_world.php', 'SA_OPEN', MENU_INQUIRY); // menu icons defined in applications/application.php
		}
	}
*/
}
