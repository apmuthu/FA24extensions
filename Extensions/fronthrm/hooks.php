<?php
/*=======================================================\
|                        FrontHrm                        |
|--------------------------------------------------------| 
|   Creator: Phương                                      |
|   Date :   09-Jul-2017                                 |
|   Description: Frontaccounting Payroll & Hrm Module    |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/ 
define ('SS_HRM', 251<<8);

class FrontHrm_app extends application {
	
    function __construct() {
        global $path_to_root;
        
       parent::__construct("FrontHrm", _($this->help_context = "&Human Resources"));
        
        $this->add_module(_("Transactions"));
		$this->add_lapp_function(0, _('&Attendance'), $path_to_root.'/modules/FrontHrm/manage/attendance.php', 'SA_EMPL', MENU_TRANSACTION);
        $this->add_lapp_function(0, _('Pays&lip Entry'), $path_to_root.'/modules/FrontHrm/manage/payslip.php?NewPayslip=Yes', 'SA_EMPL', MENU_TRANSACTION);
        $this->add_rapp_function(0, _('Payment Ad&vice'), $path_to_root.'/modules/FrontHrm/manage/pay_advice.php?NewPaymentAdvice=Yes', 'SA_EMPL', MENU_TRANSACTION);
   
        $this->add_module(_("Inquiries and Reports"));
		$this->add_lapp_function(1, _('&Timesheet'), $path_to_root.'/modules/FrontHrm/inquiry/time_sheet.php', 'SA_EMPL', MENU_INQUIRY);
	    $this->add_lapp_function(1, _('Employee Transaction &Inquiry'), $path_to_root.'/modules/FrontHrm/inquiry/emp_inquiry.php?', 'SA_EMPL', MENU_INQUIRY);
        
        $this->add_module(_("Maintenance"));
		$this->add_lapp_function(2, _('&Employees'), $path_to_root.'/modules/FrontHrm/manage/employee.php', 'SA_EMPL', MENU_ENTRY);
		$this->add_lapp_function(2, _('&Departments'), $path_to_root.'/modules/FrontHrm/manage/department.php', 'SA_HRSETUP', MENU_MAINTENANCE);
		$this->add_lapp_function(2, _('&Overtime Rates'), $path_to_root.'/modules/FrontHrm/manage/overtime.php', 'SA_HRSETUP', MENU_MAINTENANCE);
        $this->add_lapp_function(2, _('Default &Settings'), $path_to_root.'/modules/FrontHrm/manage/default_setup.php', 'SA_HRSETUP', MENU_MAINTENANCE);
		
        $this->add_rapp_function(2, _('Salary &Schemes'), $path_to_root.'/modules/FrontHrm/manage/salaryscale.php', 'SA_HRSETUP', MENU_MAINTENANCE);
		$this->add_rapp_function(2, _('Allowance & Deduction &Accounts'), $path_to_root.'/modules/FrontHrm/manage/accounts.php', 'SA_HRSETUP', MENU_MAINTENANCE);
		$this->add_rapp_function(2, _('Allowance & Deduction &Rules'), $path_to_root.'/modules/FrontHrm/manage/payroll_rules.php', 'SA_HRSETUP', MENU_MAINTENANCE);
        $this->add_rapp_function(2, _('Salary &GL Postings'), $path_to_root.'/modules/FrontHrm/manage/salary_structure.php', 'SA_HRSETUP', MENU_MAINTENANCE);
		$this->add_extensions();
    }
}

class hooks_FrontHrm extends hooks {
    function __construct() {
 		$this->module_name = 'FrontHrm';
 	}
    
    function install_tabs($app) {
        $app->add_application(new FrontHrm_app);
    }
    
    function install_access() {
        $security_sections[SS_HRM] =  _("Human Resources");
        $security_areas['SA_EMPL'] = array(SS_HRM|1, _("Hrm entry"));
        $security_areas['SA_HRSETUP'] = array(SS_HRM|1, _("Hrm setup"));
        return array($security_areas, $security_sections);
    }
    
    function activate_extension($company, $check_only=true) {
        global $db_connections;
        
        $updates = array( 'update.sql' => array('fronthrm'));
 
        return $this->update_databases($company, $updates, $check_only);
    }
	
    function deactivate_extension($company, $check_only=true) {
        global $db_connections;

        $updates = array('remove.sql' => array('fronthrm'));

        return $this->update_databases($company, $updates, $check_only);
    }
}
