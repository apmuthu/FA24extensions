<?php

$path_to_root = "../..";
$page_security = 'SA_OPEN';

include_once($path_to_root . "/includes/session.inc"); // loggen in user credentials for use in the script
include_once($path_to_root . "/includes/ui/ui_main.inc"); // page(), end_page(), includes ui_controls.inc that has start_table(),  end_table(), br()
include_once($path_to_root . "/includes/ui/ui_input.inc"); // label_cell()
// include_once($path_to_root . "/includes/date_functions.inc");
// include_once($path_to_root . "/includes/data_checks.inc");

$js = "";

page(_($help_context = "HelloWorld"), false, false, "", $js);

br(2); // 2 line breaks
start_table(); // centred table begins
label_cell("<b class=\"headingtext\">This is the Hello World extension to <a href=\"http://www.frontaccounting.com\">FrontAccounting</a>.</b>");
end_table(2); // with 2 line breaks after centred table ends

end_page();
