<?php
define ('SS_TAXRATE', 109<<8);

include "get_tax_rate.inc";

class hooks_tax_rate extends hooks {

	function __construct() {
		$this->module_name = 'tax_rate';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('Tax Rate'), 
					$path_to_root.'/modules/'.$this->module_name.'/tax_rate.php', 'SA_TAXRATE');
		}
	}

	function install_access()
	{
		$security_sections[SS_TAXRATE] =	_("Tax Rate");

		$security_areas['SA_TAXRATE'] = array(SS_TAXRATE|109, _("Tax Rate"));

		return array($security_areas, $security_sections);
	}

    function retrieve_tax_rate($tax_group_name, $address)
    {
        return get_tax_rate($tax_group_name, $address);
    }
}
