<?php
define ('SS_SGW_SALES', 121<<8);

class hooks_sgw_sales extends hooks {

	function __construct() {
		$this->module_name = 'sgw_sales';
	}
	
	/*
		Install additonal menu options provided by module
		*/
	function install_options($app) {
		global $path_to_root;
		$module_relative_path = 'modules/' . $this->module_name . '/';
		switch($app->id) {
			case 'orders': // id tag for sales
				$app->enabled = true;
//				var_dump($app);
				$app->modules[0]->lappfunctions[1] = new app_function(
					_("Sales &Order Entry"),
					$module_relative_path.'sales_order_entry.php?NewOrder=Yes',
					'SA_SGW_SALES_ORDER',
					MENU_TRANSACTION
				);
				$app->modules[0]->rappfunctions[2] = new app_function(
					_("&Generate Recurring Invoices"),
					$module_relative_path.'generate_recurring_invoices.php',
					'SA_SGW_GENERATE_RECURRING_INVOICES',
					MENU_TRANSACTION
				);
				$app->modules[1]->lappfunctions[1] = new app_function(
					_("Sales Order &Inquiry"),
					$module_relative_path.'inquiry/sales_orders_view.php?type=30',
					'SA_SGW_SALES_INQUIRY',
					MENU_INQUIRY
				);
				$this->remove_menu_item($app->modules[2]->lappfunctions, 3);
				
				break;
			case 'GL':
				break;
//				$app->add_rapp_function(2, _('Import &Transactions'),
//				$path_to_root.'/modules/import_transactions/import_transactions.php', 'SA_CSVTRANSACTIONS');
		}
	}

	function install_access()
	{
		$security_sections[SS_SGW_SALES] =	_("SayGo Sales");

		$security_areas['SA_SGW_SALES_ORDER'] = array(
			SS_SGW_SALES|1, _("Sales Order Entry")
		);
		$security_areas['SA_SGW_GENERATE_RECURRING_INVOICES'] = array(
			SS_SGW_SALES|2, _("Generate Recurring Invoices")
		);
		$security_areas['SA_SGW_SALES_INQUIRY'] = array(
			SS_SGW_SALES|21, _("Sales Order Inquiry")
		);
		
		return array($security_areas, $security_sections);
	}
	
	/* This method is called on extension activation for company.   */
	function activate_extension($company, $check_only = true)
	{
		global $db_connections;
	
		$updates = array(
			'update_1.0.sql' => array('sales_recurring')
		);
	
		return $this->update_databases($company, $updates, $check_only);
	}
	
	private function remove_menu_item(&$items, $offset) {
		array_splice($items, $offset, 1);
	}
}
