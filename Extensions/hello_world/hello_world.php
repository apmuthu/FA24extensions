<?php

$path_to_root = "../..";
$page_security = 'SA_OPEN';

include_once($path_to_root . "/includes/session.inc"); // logged in user credentials for use in the script
include_once($path_to_root . "/includes/ui/main.inc"); // page, end_page
include_once($path_to_root . "/includes/ui/ui_input.inc"); // label_cell
include_once($path_to_root . "/includes/ui/ui_controls.inc"); // start_table,  end_table, br, start_form, end_form, start_row, end_row, alt_table_row_color
// include_once($path_to_root . "/includes/date_functions.inc");
// include_once($path_to_root . "/includes/data_checks.inc");

$js = "";

page(_($help_context = "Hello World"), false, false, "", $js);

br(2); // 2 line breaks
start_table(); // centred table begins
start_row();
label_cell("<b class=\"headingtext\">This is the Hello World extension to <a href=\"http://www.frontaccounting.com\">FrontAccounting</a>.</b><br>");
end_row();
//start_row();
//label_cell(print_r(array_keys($_SESSION['App']->applications)));
//end_row();

end_table(2); // with 2 line breaks after centred table ends

end_page();
