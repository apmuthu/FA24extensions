<?php
define ('SS_SQUARE', 108<<8);

class hooks_square extends hooks {

	function __construct() {
		$this->module_name = 'square';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('Square POS Connector'), 
					$path_to_root.'/modules/'.$this->module_name.'/square.php', 'SA_SQUARE');
		}
	}

	function install_access()
	{
		$security_sections[SS_SQUARE] =	_("Square POS Connector");

		$security_areas['SA_SQUARE'] = array(SS_SQUARE|108, _("Square POS Connector"));

		return array($security_areas, $security_sections);
	}
}
