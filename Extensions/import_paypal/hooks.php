<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2011-10-22
// Title:   Paypal import hook
// Free software under GNU GPL
// ----------------------------------------------------------------
define ('SS_IMPORTPAYPALITEMS', 107<<8);
class hooks_import_paypal extends hooks {

	function __construct() {
		$this->module_name = 'import_paypal';
	}

	/*
		Install additional menu options provided by module
	*/
	function install_options($app) {
		global $path_to_root;
		$module_relative_path = 'modules/' . $this->module_name . '/';
		switch($app->id) {
			case 'GL':
				$app->add_lapp_function(0, _('Import Paypal Transactions'), 
				$module_relative_path.'import_paypal.php', 'SA_PAYPALIMPORT', MENU_TRANSACTION);
				break;
			case 'system':
				$app->add_lapp_function(1, _('Paypal Import Setup'), 
				$module_relative_path.'paypal_setup.php', 'SA_PAYPALSETUP', MENU_MAINTENANCE);
				break;
		}
	}

	function install_access()
	{
        $security_sections[SS_IMPORTPAYPALITEMS] =  _("Import Paypal Items");
        
        $security_areas['SA_PAYPALIMPORT'] = array(SS_IMPORTPAYPALITEMS|107, _("Import Paypal Items"));
        $security_areas['SA_PAYPALSETUP'] = array(SS_IMPORTPAYPALITEMS|108, _("Setup Paypal Import"));
        
		return array($security_areas, $security_sections);
	}

    /* This method is called on extension activation for company.   */
    function activate_extension($company, $check_only=true)
    {
        global $db_connections;

        $updates = array(
            'update.sql' => array('import_paypal')
        );

        return $this->update_databases($company, $updates, $check_only);
    }
}
