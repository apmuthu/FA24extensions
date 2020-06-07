<?php
define ('SS_DELIVERY_MAP', 177<<8);
class hooks_delivery_map extends hooks {

	function __construct() {
		$this->module_name = 'delivery_map';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('Delivery Map'), 
					$path_to_root.'/modules/'.$this->module_name.'/delivery_map.php', 'SA_DELIVERY_MAP');
		}
	}

	function install_access()
	{
		$security_sections[SS_DELIVERY_MAP] =	_("Delivery Map");

		$security_areas['SA_DELIVERY_MAP'] = array(SS_DELIVERY_MAP|178, _("Delivery Map"));

		return array($security_areas, $security_sections);
	}
}
