<?php
define ('SS_IMPORTCSVITEMS', 105<<8);
class hooks_import_items extends hooks {

	function __construct() {
		$this->module_name = 'import_items';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'stock':
				$app->add_rapp_function(2, _('Import CSV Items'), 
					$path_to_root.'/modules/'.$this->module_name.'/import_items.php', 'SA_CSVIMPORT');
		}
	}

	function install_access()
	{
		$security_sections[SS_IMPORTCSVITEMS] =	_("Import CSV Items");

		$security_areas['SA_CSVIMPORT'] = array(SS_IMPORTCSVITEMS|105, _("Import CSV Items"));

		return array($security_areas, $security_sections);
	}
}
