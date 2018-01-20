<?php
define ('SS_PL_DIMENSION', 198<<8);
class hooks_pl_dimension extends hooks {

	function __construct() {
		$this->module_name = 'pl_dimension';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_rapp_function(2, _('Profit Loss All Dimensions'), 
					$path_to_root.'/modules/'.$this->module_name.'/pl_dimension.php', 'SA_PL_DIMENSION');
		}
	}

	function install_access()
	{
		$security_sections[SS_PL_DIMENSION] =	_("Profit Loss All Dimensions");

		$security_areas['SA_PL_DIMENSION'] = array(SS_PL_DIMENSION|198, _("Profit Loss All Dimensions"));

		return array($security_areas, $security_sections);
	}
}
