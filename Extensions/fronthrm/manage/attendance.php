<?php
/*=======================================================\
|                        FrontHrm                        |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   09-Jul-2017                                  |
|   Description: Frontaccounting Payroll & Hrm Module    |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/

$page_security = 'SA_EMPL';
$path_to_root  = '../../..';

include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

$js = "";
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(900, 500);
if (user_use_date_picker())
	$js .= get_js_date_picker();

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/modules/FrontHrm/includes/frontHrm_db.inc");
include_once($path_to_root . "/modules/FrontHrm/includes/frontHrm_ui.inc");

//--------------------------------------------------------------------------

function can_process() {

	if (!is_date($_POST['AttDate'])) {

		display_error(_("The entered date is invalid."));
		set_focus('AttDate');
		return false;
	}
	if (date_comp($_POST['AttDate'], Today()) > 0) {

		display_error(_("Cannot make attendance for the date in the future."));
		set_focus('AttDate');
		return false;
	}
	
	foreach(get_employees(false, get_post('DeptId')) as $emp) {
		$val = trim(get_post(get_post($emp['emp_id'].'-0')));
		if(strlen($val) != 0 && !preg_match("/^(?(?=\d{2})(?:2[0-3]|[01][0-9])|[0-9]):[0-5][0-9]$/", $val) && (!is_numeric($val) || $val >= 24)) {
			display_error(_("Attendance input data must be less than 24 hours and formatted in <b>HH:MM</b> or <b>Integer</b>, example - 02:25 , 2:25, 8, 23:59 ..."));
			set_focus($emp['emp_id'].'-0');
			return false;
		}
		foreach(db_query(get_overtime()) as $ot) {
			$val = trim(get_post(get_post($emp['emp_id'].'-'.$ot['overtime_id'])));
			if(strlen($val) != 0 && !preg_match("/^\s*(?(?=\d{2})(?:2[0-3]|[01][0-9])|[0-9]):[0-5][0-9]$/", $val) && (!is_numeric($val) || $val >= 24)) {
				display_error(_("Attendance input data must be less than 24 hours and formatted in <b>HH:MM</b> or <b>Integer</b>, example - 02:25 , 2:25, 8, 23:59 ..."));
				set_focus($emp['emp_id'].'-'.$ot['overtime_id']);
				return false;
			}
		}
	}
	return true;
}

//--------------------------------------------------------------------------

page(_($help_context = "Employees Attendance"), false, false, "", $js);

//--------------------------------------------------------------------------

if(!db_has_employee())
	display_error(_("There are no employees for attendance."));

if(isset($_POST['addatt'])) {
	
	if(!can_process())
		return;

	$att = get_attendance_data(get_post('AttDate'), get_post('DeptId'));
    $att_items = 0; $emp_id = 0; $skip_paid = false;

    while($data = db_fetch($att)) {
    	if ($data['emp_id'] != $emp_id)
    	{
    		$emp_id = $data['emp_id'];
    		$skip_paid = check_date_paid($emp_id, $_POST['AttDate']);
		}
		if ($skip_paid)
			 continue;
		if (write_attendance($emp_id, $data['overtime_id'] ? $data['overtime_id'] : 0,
			time_to_float(get_post($data['emp_id'].'-'.$data['overtime_id'])), get_post('AttDate')))
        $att_items ++;
	}

	if($att_items > 0)
		display_notification(_('Attendance has been saved.'.$att_items));
	else
		display_notification(_('Nothing added'));
}

if (input_changed('AttDate') || list_updated('DeptId')) {
	$Ajax->activate('att_table');}

start_form();

start_table(TABLESTYLE_NOBORDER);
start_row();
date_cells(_("Date:"), 'AttDate', null, null, 0,0,0,null, true);
department_list_cells(_("For department:"), "DeptId", null, _("All departments"), true);
end_row();
end_table(1);


div_start('att_table');
start_table(TABLESTYLE2);

$th = array("ID", _("Employee"), _("Regular time"));

$overtimes = db_query(get_overtime());
while($overtime = db_fetch($overtimes)) {
    $th[] = $overtime['overtime_name'];
}

table_header($th);

$k=0;

$att = get_attendance_data(get_post('AttDate'), get_post('DeptId'));
$emp_id = 0;
$editable = 0;
while($data = db_fetch($att)) {
	if ($data['emp_id'] != $emp_id)
	{
		if ($emp_id)
			end_row();
		$emp_id = $data['emp_id'];
		$editable = !check_date_paid($emp_id, get_post('AttDate'));
		start_row($emp_id);
		label_cell($data['emp_id']);
		label_cell($data['name']);
		$k++;
	}

	$hours = float_to_time($data['hours_no']);
	if ($editable)
		text_cells(null, $data['emp_id'].'-'.$data['overtime_id'], $hours, 10, 10);
	else
		label_cell(float_to_time($hours));
}
end_row();
end_table(1);
div_end('att_table');

submit_center('addatt', _("Save attendance"), true, '', 'default');

end_form();
end_page();
