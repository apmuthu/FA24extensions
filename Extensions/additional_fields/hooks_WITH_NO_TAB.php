<?php
/**********************************************************************
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
	See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.

	================================================================
	Front Additional Fields
	================================================================
	
***********************************************************************/

define ('SS_ADDFLD_C', 141<<8);
define ('SS_ADDFLD', 142<<8);
define ('SS_ADDFLD_A', 143<<8);

class hooks_additional_fields extends hooks {

	function __construct() {
		$this->module_name = 'additional_fields';
	}
	
	function install_access() {
		$security_sections[SS_ADDFLD_C] =  _("Additional Fields Configuration");
		$security_sections[SS_ADDFLD] =  _("Additional Fields Transactions");
		$security_sections[SS_ADDFLD_A] =  _("Additional Fields Analytics");
		$security_areas['SA_ADD_FIELDS_SECTOR'] = array(SS_ADDFLD_C|101, _("AddFields Sector"));
		$security_areas['SA_ADD_FIELDS_COUNTRY'] = array(SS_ADDFLD_C|102, _("AddFields Country"));
		$security_areas['SA_ADD_FIELDS_CITY'] = array(SS_ADDFLD_C|103, _("AddFields City"));
		$security_areas['SA_ADD_FIELDS_DEPARTMENT'] = array(SS_ADDFLD_C|104, _("AddFields Departments"));
		$security_areas['SA_ADD_FIELDS_BEN_CLASSES'] = array(SS_ADDFLD_C|105, _("AddFields Beneficiary Classes"));
		$security_areas['SA_ADD_FIELDS_DOC_TYPES'] = array(SS_ADDFLD_C|106, _("AddFields Document Types"));
		$security_areas['SA_ADD_FIELDS_ITEM_LABELS'] = array(SS_ADDFLD_C|107, _("AddFields Item Custom Field Labels"));
		$security_areas['SA_ADD_FIELDS_SUPP_LABELS'] = array(SS_ADDFLD_C|108, _("AddFields Supplier Custom Field Labels"));
		$security_areas['SA_ADD_FIELDS_CUST_LABELS'] = array(SS_ADDFLD_C|109, _("AddFields Customer Custom Field Labels"));
		return array($security_areas, $security_sections);
	}

	function install_options($app) {
		global $path_to_root;
		switch($app->id) {
			case 'orders':
				$app->add_lapp_function(2, _("Additional &Customer Information"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/add_customers.php?', 'SA_CUSTOMER', MENU_ENTRY);
				$app->add_rapp_function(2, _("Customer Custom Field Labels"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/cust_customer_labels.php?', 'SA_ADD_FIELDS_CUST_LABELS', MENU_MAINTENANCE);
				break;
			case 'AP':
				$app->add_lapp_function(2, _("Additional &Supplier Information"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/add_suppliers.php?', 'SA_CUSTOMER', MENU_ENTRY);
				$app->add_rapp_function(2, _("Supplier Custom Field Labels"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/cust_supplier_labels.php?', 'SA_ADD_FIELDS_SUPP_LABELS', MENU_MAINTENANCE);
				break;
			case 'stock':
				$app->add_lapp_function(2, _("Additional &Item Information"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/add_items.php?', 'SA_CUSTOMER', MENU_ENTRY);
				$app->add_rapp_function(2, _("Item Custom Field Labels"), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/cust_item_labels.php?', 'SA_ADD_FIELDS_ITEM_LABELS', MENU_MAINTENANCE);
				break;
			case 'system':
				$app->add_lapp_function(1, _('Manage Document Types'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/document_types.php?', 'SA_ADD_FIELDS_DOC_TYPES', MENU_MAINTENANCE);
				$app->add_lapp_function(1, _('Manage Beneficiary Classes'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/customer_class.php?', 'SA_ADD_FIELDS_BEN_CLASSES', MENU_MAINTENANCE);
				$app->add_lapp_function(1, _('Manage Sectors'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/sectors_add_info.php?', 'SA_ADD_FIELDS_SECTOR', MENU_MAINTENANCE);

				$app->add_rapp_function(1, _('Manage Countries'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/country.php?', 'SA_ADD_FIELDS_COUNTRY', MENU_MAINTENANCE);
				$app->add_rapp_function(1, _('Manage Departments'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/department_add_info.php?', 'SA_ADD_FIELDS_DEPARTMENT', MENU_MAINTENANCE);
				$app->add_rapp_function(1, _('Manage Cities'), 
					$path_to_root.'/modules/'.$this->module_name.'/manage/city_add_info.php?', 'SA_ADD_FIELDS_CITY', MENU_MAINTENANCE);
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
