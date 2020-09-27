<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/

define ('IMPULSE_SHIPMENT_TRACKING', 251<<8);


class hooks_shipment_tracking extends hooks {

	function __construct() {
		$this->module_name = 'shipment_tracking';
	}
	
	function install_access() {
		$security_sections[IMPULSE_SHIPMENT_TRACKING] =  _("Shipment Tracking");
        $security_areas['PULSE_TRACKING'] = array(IMPULSE_SHIPMENT_TRACKING|1, _('Tracking Information'));
        return array($security_areas, $security_sections);
	}

	function install_options($app) {
		global $path_to_root;
		switch($app->id) {
			case 'orders':
				$app->add_rapp_function(0, _("Shipment Tracking"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/tracking.php?', 'PULSE_TRACKING', MENU_TRANSACTION);
				break;
		}
	}

	

	function activate_extension($company, $check_only=true) {
		global $db_connections;
		
		$updates = array( 'update.sql' => array('frontadd'));
 
		return $this->update_databases($company, $updates, $check_only);
	}
	
	function deactivate_extension($company, $check_only=true) {
		global $db_connections;

		$updates = array('remove.sql' => array('frontadd'));

		return $this->update_databases($company, $updates, $check_only);
	}

}
