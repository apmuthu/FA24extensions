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

function time_to_float($time) {
    if(strpos($time,':') != false) {
        sscanf($time, "%d:%d", $hours, $minutes);
        $time_in_float = $hours + $minutes/60;
    }
    else
        $time_in_float = $time;

	return $time_in_float;
}

function float_to_time($hours) {
	return $hours ? sprintf( "%2d:%02d", floor($hours), round(($hours-floor($hours))*60)) : '';
}

//--------------------------------------------------------------------------

function check_attended($emp_id, $overtime_id, $att_date) {
    $sql = "SELECT * FROM ".TB_PREF."attendance WHERE emp_id = ".db_escape($emp_id)." AND overtime_id = ".db_escape($overtime_id)." AND att_date = '".date2sql($att_date)."'";
    
    return check_empty_result($sql);
}

//--------------------------------------------------------------------------

function write_attendance($emp_id, $overtime_id, $hours_no=null, $att_date) {

    if (isset($hours_no) && $hours_no != 0) {

		$rate = $overtime_id ? get_overtime($overtime_id)['overtime_rate'] : 1;
		$sql = "REPLACE INTO ".TB_PREF."attendance (emp_id, overtime_id, att_date, hours_no, rate)"
		. " SELECT ".db_escape($emp_id).",".db_escape($overtime_id).",'".date2sql($att_date)."',".db_escape($hours_no).",".($overtime_id ? "'rate'": 1);

		if ($overtime_id)
			$sql .= " FROM ".TB_PREF."overtime WHERE overtime_id=".db_escape($overtime_id);
    } else
    	$sql = "DELETE FROM ".TB_PREF."attendance WHERE att_date = '".date2sql($att_date)."'"
    		." AND emp_id = ".db_escape($emp_id)." AND overtime_id = ".db_escape($overtime_id);

    return db_query($sql, _('Could not add time clock'));
}

//--------------------------------------------------------------------------

function check_date_paid($person_id, $att_date) {
	return check_empty_result("SELECT payslip_no, emp_id, from_date, to_date FROM ".TB_PREF."payslip WHERE emp_id = ".db_escape($person_id)." AND '".date2sql($att_date)."' BETWEEN from_date AND to_date");
}

//--------------------------------------------------------------------------

function get_attendance($from, $to, $emp_id = 0, $department = 0, $ot_id = 0) {

    $from = DateTime::createFromFormat('Y-m-d', date2sql($from));
    $to = DateTime::createFromFormat('Y-m-d', date2sql($to));

	$sql = "SELECT emp.emp_id, CONCAT(emp_first_name,' ',emp_last_name)";

	if($emp_id == 0 && $department == 0) {
	    while(sql_date_comp($from->format('Y-m-d'),$to->format('Y-m-d')) <= 0) {
	        $sql .= ",MAX(CASE WHEN att.att_date = '".$from->format('Y-m-d')."' AND emp.emp_id = att.emp_id AND att.overtime_id = ".$ot_id." THEN CASE hours_no WHEN '0' THEN '<span style=color:red>x</span>' ELSE hours_no END END)";
	        $from->modify('+1 day');
	    }
	    $sql .= " FROM ".TB_PREF."employee emp, ".TB_PREF."attendance att WHERE !emp.inactive GROUP BY emp.emp_id";
	}
	else if($emp_id != 0) {
	    while(sql_date_comp($from->format('Y-m-d'),$to->format('Y-m-d')) <= 0) {
	        $sql .= ",MAX(CASE WHEN emp.emp_id = ".$emp_id." AND att.att_date = '".$from->format('Y-m-d')."' AND emp.emp_id = att.emp_id AND att.overtime_id = ".$ot_id." THEN hours_no END)";
	        $from->modify('+1 day');
	    }
	    $sql .= " FROM ".TB_PREF."employee emp, ".TB_PREF."attendance att WHERE emp.emp_id = '".$emp_id."' GROUP BY emp.emp_id";
	}
	else {
        while(sql_date_comp($from->format('Y-m-d'),$to->format('Y-m-d')) <= 0) {
            $sql .= ",MAX(CASE WHEN att.att_date = '".$from->format('Y-m-d')."' AND emp.emp_id = att.emp_id AND att.overtime_id = ".$ot_id." THEN hours_no END)";
            $from->modify('+1 day');
        }
        $sql .= " FROM ".TB_PREF."employee emp, ".TB_PREF."attendance att WHERE emp.department_id = ".$department." AND !emp.inactive GROUP BY emp.emp_id";
	}
	return $sql;
}

/*
	Returns attendance data for employees selected by department on date $date
*/
function get_attendance_data($date, $department=0) {

	$sql = "SELECT t.emp_id, t.name, t.overtime_id, hours_no, rate
	FROM ( # attendance form
		SELECT o.id overtime_id, emp_id, CONCAT(e.emp_first_name,' ', e.emp_last_name) name, department_id FROM 
			(SELECT 0 id UNION (SELECT overtime_id id FROM 0_overtime) ) o,
			0_employee e) t
	LEFT JOIN 0_attendance a ON t.emp_id=a.emp_id and t.overtime_id=a.overtime_id AND a.att_date='".date2sql($date)."'";

	if ($department)
		$sql .= " WHERE t.department_id=".db_escape($department);

	$sql .= " ORDER BY t.emp_id, t.overtime_id";

	return db_query($sql, "cannot retrieve attendance data");
}
