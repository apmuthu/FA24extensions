<?php
define ('SS_QUICKREPORT', 196<<8);
class hooks_quickreport extends hooks {

	function __construct() {
		$this->module_name = 'quickreport';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_rapp_function(2, _('Quick Report'), 
					$path_to_root.'/modules/'.$this->module_name.'/quickreport_inquiry.php', 'SA_QUICKREPORT');
		}
	}

	function install_access()
	{
		$security_sections[SS_QUICKREPORT] =	_("Quick Report");

		$security_areas['SA_QUICKREPORT'] = array(SS_QUICKREPORT|196, _("Quick Report"));

		return array($security_areas, $security_sections);
	}
}
