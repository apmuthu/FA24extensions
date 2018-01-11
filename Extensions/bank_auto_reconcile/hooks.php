<?php
define ('SS_BANKAUTORECONCILE', 199<<8);
class hooks_bank_auto_reconcile extends hooks {

	function __construct() {
		$this->module_name = 'bank_auto_reconcile';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_rapp_function(2, _('Bank Auto Reconcile'), 
					$path_to_root.'/modules/'.$this->module_name.'/bank_auto_reconcile.php', 'SA_BANKAUTORECONCILE');
		}
	}

	function install_access()
	{
		$security_sections[SS_BANKAUTORECONCILE] =	_("Bank Auto Reconcile");

		$security_areas['SA_BANKAUTORECONCILE'] = array(SS_BANKAUTORECONCILE|199, _("Bank Auto Reconcile"));

		return array($security_areas, $security_sections);
	}
}
