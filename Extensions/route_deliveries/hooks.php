<?php
/**********************************************************************
    Released under the terms of the GNU General Public License, GPL, 
    as published by the Free Software Foundation, either version 3 
    of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.

    =================================================================
    Customer Geocode Management
    =================================================================
***********************************************************************/

define('SS_ROUTING', 145<<8);

class hooks_route_deliveries extends hooks {

    function __construct() {
        $this->module_name = 'route_deliveries';
    }

    function install_options($app) {
        global $path_to_root;

        switch ($app->id) {
          case 'system':
          $app->add_rapp_function(0, _("Route Delivery Config"),
            $path_to_root."/modules/".$this->module_name."/manage/settings.php?", 
            'SA_MANAGE_GPS_CONFIG', MENU_SETTINGS);
          break;
            case 'orders':
                $app->add_lapp_function(2, _("Manage Customer GPS"), 
                    $path_to_root.'/modules/'.$this->module_name.'/manage/cust_gps.php', 
                    'SA_MANAGE_GPS', MENU_ENTRY);
                break;
        }
    }

    function install_access() {
        $security_sections[SS_ROUTING] = _("Route Deliveries");

        $security_areas['SA_MANAGE_GPS'] = array(SS_ROUTING | 1, _("Manage Customer GPS"));
        $security_areas['SA_MANAGE_GPS_CONFIG'] = array(SS_ROUTING | 2, _("Manage GPS Config"));


        return array($security_areas, $security_sections);
    }

    function activate_extension($company, $check_only=true) {
		    global $db_connections;
        $updates = array('install_geocode.sql' => array('frontadd'));
        return $this->update_databases($company, $updates, $check_only);
    }

    function deactivate_extension($company, $check_only=true) {
		    global $db_connections;
        // Do not remove tables, only mark extension as inactive
        $updates = array(); // No table removal SQL
        return $this->update_databases($company, $updates, $check_only);
    }
}


