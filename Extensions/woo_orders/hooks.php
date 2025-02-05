<?php
define ('SS_WOOORDERS', 107<<8);
class hooks_woo_orders extends hooks {
	var $module_name = 'WooCommerce Order Import'; 

	/*
		Install additonal menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;

		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(2, _('WooCommerce Import'), 
					$path_to_root.'/modules/woo_orders/WooCommerce.php', 'SA_WOOORDERS');
		}
	}

	function install_access()
	{
		$security_sections[SS_WOOORDERS] =	_("WooCommerce Order Import");

		$security_areas['SA_WOOORDERS'] = array(SS_WOOORDERS|107, _("WooCommerce Order Import"));

		return array($security_areas, $security_sections);
	}
}
