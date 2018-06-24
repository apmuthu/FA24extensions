<?php
define ('SS_SALES_MAP', 178<<8);
class hooks_sales_map extends hooks {

	function __construct() {
		$this->module_name = 'sales_map';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('Sales Map'), 
					$path_to_root.'/modules/'.$this->module_name.'/sales_map.php', 'SA_SALES_MAP');
		}
	}

	function install_access()
	{
		$security_sections[SS_SALES_MAP] =	_("Sales Map");

		$security_areas['SA_SALES_MAP'] = array(SS_SALES_MAP|178, _("Sales Map"));

		return array($security_areas, $security_sections);
	}
}
