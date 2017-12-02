<?php
define ('SS_IMPORTTRANSACTIONS', 101<<8);

class hooks_import_transactions extends hooks {

	function __construct() {
		$this->module_name = 'import_transactions';
	}

    /*
        Install additional menu options provided by module
    */
    function install_options($app) {
        global $path_to_root;

        switch($app->id) {
            case 'GL':
                $app->add_rapp_function(2, _('Import &Transactions'), 
                    $path_to_root.'/modules/'.$this->module_name.'/import_transactions.php', 'SA_CSVTRANSACTIONS');
        }
    }

    function install_access()
    {
        $security_sections[SS_IMPORTTRANSACTIONS] =    _("Import Transactions");

        $security_areas['SA_CSVTRANSACTIONS'] = array(SS_IMPORTTRANSACTIONS|101, _("Import Transactions"));

        return array($security_areas, $security_sections);
    }
}

