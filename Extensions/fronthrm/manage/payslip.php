<?php
/*=======================================================\
|                        FrontHrm                        |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   09-07-2017                                  |
|   Description: Frontaccounting Payroll & Hrm Module    |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/

$page_security = 'SA_EMPL';
$path_to_root = "../../..";

include_once($path_to_root . "/includes/ui/items_cart.inc");
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

$js = '';
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(900, 500);
if (user_use_date_picker())
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/modules/FrontHrm/includes/frontHrm_db.inc");
include_once($path_to_root . "/modules/FrontHrm/includes/frontHrm_ui.inc");

if (isset($_GET['ModifyPaySlip'])) {
	$_SESSION['page_title'] = sprintf(_("Modifying Employee Payslip # %d."), 
		$_GET['trans_no']);
	$help_context = "Modifying Employee Payslip";
} else
	$_SESSION['page_title'] = _($help_context = "Employee Payslip Entry");

page($_SESSION['page_title'], false, false, "", $js);

//--------------------------------------------------------------------------

function line_start_focus() {
    global $Ajax;
    $Ajax->activate('items_table');
    set_focus('_code_id_edit');
}

//--------------------------------------------------------------------------

if (isset($_GET['AddedID'])) {
    
	$trans_no = $_GET['AddedID'];
	$trans_type = ST_JOURNAL;

   	display_notification_centered( _("Payslip #$trans_no has been entered"));
    display_note(get_gl_view_str($trans_type, $trans_no, _("&View this Employee Payslip")));

	reset_focus();
	hyperlink_params($_SERVER['PHP_SELF'], _("Enter &New Payslip"), "NewPayslip=Yes");

	hyperlink_params("$path_to_root/admin/attachments.php", _("Add an Attachment"), "filterType=$trans_type&trans_no=$trans_no");

	display_footer_exit();
} 
elseif (isset($_GET['UpdatedID'])) {
    
	$trans_no = $_GET['UpdatedID'];
	$trans_type = ST_JOURNAL;

   	display_notification_centered( _("Employee Payslip has been updated") . " #$trans_no");
    display_note(get_gl_view_str($trans_type, $trans_no, _("&View this Journal Entry")));

   	hyperlink_no_params($path_to_root."/gl/inquiry/payslip_inquiry.php", _("Return to Payslip &Inquiry"));

	display_footer_exit();
}

//--------------------------------------------------------------------------

if (isset($_GET['NewPayslip'])) {
	create_cart(0,0);
} 
elseif (isset($_GET['ModifyPaySlip'])) {
    check_is_editable($_GET['trans_type'], $_GET['trans_no']);
    
	if (!isset($_GET['trans_type']) || $_GET['trans_type']!= 0) {
		display_error(_("You can edit directly only journal entries created via Journal Entry page."));
		hyperlink_params("$path_to_root/gl/gl_journal.php", _("Entry &New Journal Entry"), "NewJournal=Yes");
		display_footer_exit();
	}
	create_cart($_GET['trans_type'], $_GET['trans_no']);
}

//--------------------------------------------------------------------------

function create_cart($type=0, $trans_no=0) {
	global $Refs;

	if (isset($_SESSION['journal_items']))
		unset($_SESSION['journal_items']);
    
    check_is_closed($type, $trans_no);
	$cart = new items_cart($type);
    $cart->order_id = $trans_no;

	$cart->paytype = PT_EMPLOYEE;

	if ($trans_no) {
        $header = get_journal($type, $trans_no);
        $cart->tran_date = sql2date($header['tran_date']);
        
		$result = get_gl_trans($type, $trans_no);

		if ($result) {
			while ($row = db_fetch($result)) {
                $curr_amount = $cart->rate ? round($row['amount']/$cart->rate, $_SESSION["wa_current_user"]->prefs->price_dec()) : $row['amount'];
                if ($curr_amount)
					$cart->add_gl_item($row['account'], $row['dimension_id'], $row['dimension2_id'], $curr_amount, $row['memo_'], '', $row['person_id']);
			}
		}
		$cart->memo_ = get_comments_string($type, $trans_no);
        $cart->reference = $header['reference'];
	} 
    else {
        $cart->tran_date = new_doc_date();
		if (!is_date_in_fiscalyear($cart->tran_date))
			$cart->tran_date = end_fiscalyear();
		$cart->reference = $Refs->get_next(ST_JOURNAL, null, $cart->tran_date);
	}

	$_POST['memo_'] = $cart->memo_;
	$_POST['ref'] = $cart->reference;
	$_POST['date_'] = $cart->tran_date;
	$_POST['from_date'] = '';
	$_POST['to_date'] = '';
	$_POST['leaves'] = '';
	$_POST['deductableleaves'] = '';
    $_POST['workdays'] = '';

	$_SESSION['journal_items'] = &$cart;
}

//--------------------------------------------------------------------------

function validate_payslip_generation() {

	if (!$_POST['person_id']) {
		display_error(_("Employee not selected"));
		set_focus('person_id');
		return false;
	} 
	if (!is_date($_POST['from_date'])) {
		display_error(_("The entered date is invalid."));
		set_focus('from_date');
		return false;
	}
	if (!is_date($_POST['to_date'])) {
		display_error(_("The entered date is invalid."));
		set_focus('to_date');
		return false;
	}
	if(payslip_generated_for_date($_POST['from_date'], $_POST['person_id'])) {
        display_error("Selected date has already paid for this person");
        set_focus('from_date');
        return false;
    }
    if(payslip_generated_for_date($_POST['to_date'], $_POST['person_id'])) {
        display_error("Selected date has already paid for this person");
        set_focus('to_date');
        return false;
    }
    if(payslip_generated_for_period($_POST['from_date'], $_POST['to_date'], $_POST['person_id'])) {
    	display_error("Selected period contains a period that has already been paid for this person");
        set_focus('from_date');
        return false;
    }
    if(date_comp($_POST['from_date'], $_POST['to_date']) > 0) {
        display_error("End date cannot be before the start date");
        set_focus('from_date');
        return false;
    }
    if (date_comp($_POST['from_date'], Today()) > 0) {
		display_error(_("Cannot pay for the date in the future."));
		set_focus('from_date');
		return false;
	}
	if (date_comp($_POST['to_date'], Today()) > 0) {
		display_error(_("Cannot pay for the date in the future."));
		set_focus('to_date');
		return false;
	}
    if(!check_employee_hired($_POST['person_id'], $_POST['from_date'])) {
        display_error("Cannot pay before hired date");
        set_focus('from_date');
        return false;
    }
    // The following two cases need to be set in correct order
    if(!employee_has_salary_scale($_POST['person_id'])) {
    	display_error("Selected Employee does not have a Salary Scale, please define it first.");
    	set_focus('person_id');
    	return false;
    }
    else if(!emp_salaryscale_has_structure($_POST['person_id'])) {
    	display_error("the Employee's Salary Scale does not have a structure, please define Salary Structure");
    	set_focus('person_id');
    	return false;
    }
    
	return true;
}

//--------------------------------------------------------------------------

if(isset($_POST['GeneratePayslip']) && validate_payslip_generation())
	generate_gl_items($_SESSION['journal_items']);
	
//--------------------------------------------------------------------------

if (isset($_POST['Process'])) {
	$input_error = 0;

	if ($_SESSION['journal_items']->count_gl_items() < 1) {
		display_error(_("You must enter at least one journal line."));
		set_focus('code_id');
		$input_error = 1;
	}
	if (abs($_SESSION['journal_items']->gl_items_total()) > 0.0001) {
		display_error(_("The journal must balance (debits equal to credits) before it can be processed."));
		set_focus('code_id');
		$input_error = 1;
	}
	if (!is_date($_POST['date_'])) {
		display_error(_("The entered date is invalid."));
		set_focus('date_');
		$input_error = 1;
	} 
	elseif (!is_date_in_fiscalyear($_POST['date_'])) {
		display_error(_("The entered date is out of fiscal year or is closed for further data entry."));
		set_focus('date_');
		$input_error = 1;
	} 
	if (!check_reference($_POST['ref'], ST_JOURNAL, $_SESSION['journal_items']->order_id)) {
   		set_focus('ref');
   		$input_error = 1;
	}
	if($_SESSION['journal_items']->empty_payment) {
		display_error(_('Employee cannot getting paid for non-working period.'));
		set_focus('from_date');
		$input_error = 1;
	}
	if ($input_error == 1)
		unset($_POST['Process']);
}

if (isset($_POST['Process'])) {
	$cart = &$_SESSION['journal_items'];
	$new = $cart->order_id == 0;
    
    $cart->reference = $_POST['ref'];
    $cart->tran_date = $_POST['date_'];
	$cart->person_id = $_POST['person_id'];
    if (isset($_POST['memo_']))
		$cart->memo_ = $_POST['memo_'];
    
    
	$cart->to_the_order_of = $_POST['to_the_order_of'];
	$cart->payslip_no = $_POST['PaySlipNo'];


	$cart->from_date = $_POST['from_date'];
	$cart->to_date = $_POST['to_date'];
	$cart->leaves = $_POST['leaves'];
	$cart->deductable_leaves = $_POST['deductableleaves'];
    $cart->work_days = $_POST['workdays'];
	
	$trans_no = write_payslip($cart, check_value('Reverse'));

	$cart->clear_items();
	new_doc_date($_POST['date_']);
	unset($_SESSION['journal_items']);
	if($new)
		meta_forward($_SERVER['PHP_SELF'], "AddedID=$trans_no");
	else
		meta_forward($_SERVER['PHP_SELF'], "UpdatedID=$trans_no");
}

//--------------------------------------------------------------------------

if (isset($_POST['CancelOrder']) || !isset($_POST['person_id'])) {
	$_SESSION['journal_items']->clear_items();
	$_POST['leaves'] = $_POST['deductableleaves'] = $_POST['workdays'] = '';
	$Ajax->activate('_page_body');
}

//--------------------------------------------------------------------------

function check_item_data() {
	if (isset($_POST['dimension_id']) && $_POST['dimension_id'] != 0 && dimension_is_closed($_POST['dimension_id'])) {
		display_error(_("Dimension is closed."));
		set_focus('dimension_id');
		return false;
	}
	if (isset($_POST['dimension2_id']) && $_POST['dimension2_id'] != 0 && dimension_is_closed($_POST['dimension2_id'])) {
		display_error(_("Dimension is closed."));
		set_focus('dimension2_id');
		return false;
	}
	if (!(input_num('AmountDebit')!=0 ^ input_num('AmountCredit')!=0) ) {
		display_error(_("You must enter either a debit amount or a credit amount."));
		set_focus('AmountDebit');
    		return false;
  	}
	if (strlen($_POST['AmountDebit']) && !check_num('AmountDebit', 0)) {
        display_error(_("The debit amount entered is not a valid number or is less than zero."));
		set_focus('AmountDebit');
        return false;
  	}
    elseif (strlen($_POST['AmountCredit']) && !check_num('AmountCredit', 0)) {
        display_error(_("The credit amount entered is not a valid number or is less than zero."));
		set_focus('AmountCredit');
        return false;
  	}
	if (!is_tax_gl_unique(get_post('code_id'))) {
   		display_error(_("Cannot post to GL account used by more than one tax type."));
		set_focus('code_id');
   		return false;
	}
	if (!$_SESSION["wa_current_user"]->can_access('SA_BANKJOURNAL') && is_bank_account($_POST['code_id'])) {
		display_error(_("You cannot make a journal entry for a bank account. Please use one of the banking functions for bank transactions."));
		set_focus('code_id');
		return false;
	}
   	return true;
}

//--------------------------------------------------------------------------

function handle_update_item() {
    
    if($_POST['UpdateItem'] != "" && check_item_data()) {
    	if (input_num('AmountDebit') > 0)
    		$amount = input_num('AmountDebit');
    	else
    		$amount = -input_num('AmountCredit');

    	$_SESSION['journal_items']->update_gl_item($_POST['Index'], $_POST['code_id'], 
    	    $_POST['dimension_id'], $_POST['dimension2_id'], $amount, $_POST['LineMemo'], '', get_post('person_id'));
    }
	line_start_focus();
}

function handle_delete_item($id) {
	$_SESSION['journal_items']->remove_gl_item($id);
	line_start_focus();
}

function handle_new_item() {
	if (!check_item_data())
		return;

	if (input_num('AmountDebit') > 0)
		$amount = input_num('AmountDebit');
	else
		$amount = -input_num('AmountCredit');
	
	$_SESSION['journal_items']->add_gl_item($_POST['code_id'], $_POST['dimension_id'],
		$_POST['dimension2_id'], $amount, $_POST['LineMemo'], '', get_post('person_id'));
	line_start_focus();
}

//--------------------------------------------------------------------------

$id = find_submit('Delete');
if ($id != -1)
	handle_delete_item($id);

if (isset($_POST['AddItem'])) 
	handle_new_item();

if (isset($_POST['UpdateItem'])) 
	handle_update_item();
	
if (isset($_POST['CancelItemChanges']))
	line_start_focus();

if (isset($_POST['go'])) {
	display_quick_entries($_SESSION['journal_items'], $_POST['person_id'], input_num('totamount'), QE_JOURNAL);
	$_POST['totamount'] = price_format(0); $Ajax->activate('totamount');
	line_start_focus();
}

//--------------------------------------------------------------------------

start_form();

display_payslip_header($_SESSION['journal_items']);

if (!count($_SESSION['journal_items']->gl_items)) {
	br();
	submit_center('GeneratePayslip', _("Generate Payslip"), _('Generate Payslip For Process'), false);
	br();
}

div_start('payslip_trans');
	if (count($_SESSION['journal_items']->gl_items)) {
		start_table(TABLESTYLE_NOBORDER, "width='90%'", 10);
		start_row();
		echo "<td>";
		display_gl_items(_("Rows"), $_SESSION['journal_items']);
		gl_options_controls();
		echo "</td>";
		end_row();
		end_table(1);

		submit_center_first('Process', _("Process PaySlip"), _('Process journal entry only if debits equal to credits'));

		submit_center_last('CancelOrder', _("Cancel"), _('Cancels document entry or removes Gl items'), true);
	}
div_end();

// highlight_string("<?php\n" . var_export($_SESSION['journal_items'], true));

end_form();
end_page();
