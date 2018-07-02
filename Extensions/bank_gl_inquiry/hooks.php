<?php
define ('SS_BANK_GL_INQUIRY', 197<<8);
class hooks_bank_gl_inquiry extends hooks {

	function __construct() {
		$this->module_name = 'bank_gl_inquiry';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'GL':
				$app->add_lapp_function(1, _('Bank Account G/L Inquiry'), 
					$path_to_root.'/modules/'.$this->module_name.'/bank_gl_inquiry.php', 'SA_BANK_GL_INQUIRY', MENU_INQUIRY);
		}
	}

	function install_access()
	{
		$security_sections[SS_BANK_GL_INQUIRY] =	_("Bank Account G/L Inquiry");

		$security_areas['SA_BANK_GL_INQUIRY'] = array(SS_BANK_GL_INQUIRY|198, _("Bank Account G/L Inquiry"));

		return array($security_areas, $security_sections);
	}
}
