<?php
$page_security = 'SA_TAXRATE';
$path_to_root  = "../..";

include($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/ui.inc");

add_access_extensions();

$js = "";
$js .= get_js_date_picker();
if ($SysPrefs->use_popup_windows)
    $js .= get_js_open_window(800, 500);
$help_context="Tax Rate Lookup";
page(_($help_context), false, false, "", $js);

set_posts(array('address'));

$rates=array();
if (isset($_POST['address'])
    && isset($_POST['tax_group_id']))
    $rates = get_tax_group_items_as_array($_POST['tax_group_id'], $_POST['address']);

    start_form(true);
    start_table(TABLESTYLE2, "width=60%");

    table_section_title("Tax Rate Lookup");
    textarea_row(_("Address:"), 'address', @$_POST['address'], 35, 5);
    tax_groups_list_row(_("Tax Group:"), 'tax_group_id');
    foreach ($rates as $rate)
        if ($rate['rate'] != '')
            label_row($rate[1] . ":", $rate['rate']);

    end_table(1);

    submit_center('lookup', "Lookup Tax Rate");

    end_form();

end_page();

?>
