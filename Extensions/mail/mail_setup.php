<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
$page_security = 'SA_SETUPCOMPANY';
$path_to_root="../..";
include($path_to_root . "/includes/session.inc");

page(_($help_context = "Mail Setup"));

include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/admin/db/company_db.inc");

//-------------------------------------------------------------------------------------------------
// initialize stuff just in case
$init = 0;
if (get_company_pref('mail_type') === null) {
	set_company_pref('mail_type', 'system.mail', 'varchar', 10, 'MAIL');
	$init++;
}

if (get_company_pref('smtp_host') === null) {
	set_company_pref('smtp_host', 'system.mail', 'varchar', 60, 'localhost');
	$init++;
}

if (get_company_pref('smtp_port') === null) {
	set_company_pref('smtp_port', 'system.mail', 'int', 11, 25);
	$init++;
}

if (get_company_pref('smtp_username') === null) {
	set_company_pref('smtp_username', 'system.mail', 'varchar', 60, '');
	$init++;
}

if (get_company_pref('smtp_password') === null) {
	set_company_pref('smtp_password', 'system.mail', 'varchar', 60, '');
	$init++;
}

if (get_company_pref('smtp_secure') === null) {
	set_company_pref('smtp_secure', 'system.mail', 'varchar', 10, 'none');
	$init++;
}

if ($init)
    refresh_sys_prefs();


function can_process() {
    if ($_POST['mail_type'] == 'MAIL')
		return true;

    $errors = 0;

    if ($_POST['mail_type'] == 'SMTP') {
		if (empty($_POST['smtp_host'])) {
			$errors++;
			display_error(_("The SMTP host must be entered."));
		}

		if (!check_num('smtp_port', 1)) {
			$errors++;
			display_error(_("The SMTP port must be a positive number."));
		}

		if (empty($_POST['smtp_username'])) {
			$errors++;
			display_error(_("The SMTP username must be entered."));
		}

		if (empty($_POST['smtp_password'])) {
			$errors++;
			display_error(_("The SMTP password must be entered."));
		}
    }
    return ($errors == 0);

}


//-------------------------------------------------------------------------------------------------

if (isset($_POST['submit']) && can_process()) {
	update_company_prefs( get_post( array( 
		'mail_type'
	  , 'smtp_host'
	  , 'smtp_port'
	  , 'smtp_auth'
	  , 'smtp_secure'
	  , 'smtp_username'
	  , 'smtp_password'
	)));

	display_notification(_("The mail sending settings has been updated."));

} /* end of if submit */

if (list_updated('mail_type')) {
	$Ajax->activate('details');
}

$prefs = get_company_prefs();

if (!isset($_POST['mail_type'])) {
    $_POST['mail_type'] = $prefs['mail_type'];
}

$_POST['smtp_host']     = $prefs['smtp_host'];
$_POST['smtp_port']     = $prefs['smtp_port'];
$_POST['smtp_secure']   = $prefs['smtp_secure'];
$_POST['smtp_username'] = $prefs['smtp_username'];
$_POST['smtp_password'] = $prefs['smtp_password'];
//-------------------------------------------------------------------------------------------------

start_form();

start_table(TABLESTYLE_NOBORDER);
start_row();
$_selector = array_selector(
    'mail_type',
    $_POST['mail_type'],
    array('MAIL' => 'PHP\'s mail function', 'SMTP' => 'SMTP server'),
    array('select_submit' => true)
);
label_cells(_("Mail type:"), $_selector);
end_row();
end_table();
echo "<hr>";


div_start('details');
if ($_POST['mail_type'] != 'MAIL') {
    start_table(TABLESTYLE2);
    text_row(_("SMTP Host:"), 'smtp_host', $_POST['smtp_host'], 50, 52);
    text_row(_("SMTP Port:"), 'smtp_port', $_POST['smtp_port'], 10, 12);

    //smtp auth row
    echo "<tr><td class='label'>" . _("SMTP Secure:") . "</td><td>";
    echo array_selector('smtp_secure'
	                  , $_POST['smtp_secure']
					  , array('none' => 'None', 'tls' => 'TLS', 'ssl' => 'SSL')
					  );
    echo "</td></tr>\n";

    text_row(_("Username:"), 'smtp_username', $_POST['smtp_username'], 60, 62);
    text_row(_("Password:"), 'smtp_password', $_POST['smtp_password'], 60, 62);
    end_table(1);
}
div_end();


submit_center('submit', _("Update"), true, '', 'default');

end_form(2);

//-------------------------------------------------------------------------------------------------

end_page();

?>
