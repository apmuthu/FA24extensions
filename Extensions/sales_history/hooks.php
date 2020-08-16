<?php
define ('SS_SALES_HISTORY', 195<<8);
class hooks_sales_history extends hooks {

	function __construct() {
		$this->module_name = 'sales_history';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('Sales History'), 
					$path_to_root.'/modules/'.$this->module_name.'/sales_history.php', 'SA_SALES_HISTORY');
		}
	}

	function install_access()
	{
		$security_sections[SS_SALES_HISTORY] =	_("Sales History");

		$security_areas['SA_SALES_HISTORY'] = array(SS_SALES_HISTORY|195, _("Sales History"));

		return array($security_areas, $security_sections);
	}
}
