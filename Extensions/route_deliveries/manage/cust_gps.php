<?php
/**********************************************************************
  Copyright (C) FrontAccounting, LLC.
  Released under the terms of the GNU General Public License, GPL, 
  as published by the Free Software Foundation, either version 3 
  of the License, or (at your option) any later version.
***********************************************************************/
$page_security = 'SA_CUSTOMER';
$path_to_root = "../../..";

include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if (user_use_date_picker())
    $js .= get_js_date_picker();

page(_($help_context = "Customer Geocode Management"), false, false, "", $js);

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/modules/route_deliveries/includes/route_delivery.inc");

$selected_customer = isset($_GET['customer_id']) ? $_GET['customer_id'] : get_post('customer_id', '');
$selected_branch = isset($_GET['branch_id']) ? $_GET['branch_id'] : get_post('branch_id', '');

if (list_updated('customer_id')) {
    $Ajax->activate('branch_id');
    $selected_branch = '';
}
if (list_updated('branch_id')) {
    $Ajax->activate('_page_body');
}
//display_error(json_encode($_POST));
//display_error(json_encode($selected_customer));
//display_error(json_encode($selected_branch));


//------------------------------------------------------------------------------

function geocode_settings($customer_id, $branch_id) {
    if ($customer_id && $branch_id) {
        $geocode_info = get_geocode_info($customer_id, $branch_id);
        $cust_info = get_geocode_address($customer_id, $branch_id);
        $_POST['latitude'] = $geocode_info['latitude'] ?? '';
        $_POST['longitude'] = $geocode_info['longitude'] ?? '';
        $formatted_address = str_replace(["\r\n", "\n", "\r"], ', ',$cust_info['br_post_address']);
        $url1 = 'https://google.com/maps/search/'.urlencode($formatted_address);
        $url2 = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?'
          .'address='.urlencode($formatted_address)
          .'&benchmark=Public_AR_Current';
        if (isset($_GET['census']) && $_GET['census'] == '1') {
          $census_data = fetch_geocode_from_census($cust_info['br_post_address']);
          if ($census_data) {
            $_POST['latitude'] = $census_data['latitude'];
            $_POST['longitude'] = $census_data['longitude'];
          }
        }
    }

    start_outer_table(TABLESTYLE2);
    table_section(1);

    table_section_title(_("Customer and Branch Information"));
    label_row(_("Customer ID:"), $customer_id);
    label_row(_("Branch ID:"), $branch_id);
    label_row(_("Customer Name:"), $cust_info['name']);
    label_row(_("Branch Name:"), $cust_info['br_name']);
    label_row(_("Shipping Address:"), $formatted_address);
    table_section_title(_("GPS Information"));
    label_row(_("Google Maps:"), '<a href="'.$url1.'" target="_blank">Lookup</a>');
    label_row(_("US Census:"), '<a href="'.$url2.'" target="_blank">Lookup</a> - <a href="' . $_SERVER['PHP_SELF'] . '?customer_id=' . $customer_id . 
    '&branch_id=' . $branch_id . '&census=1">Fetch</a>');
    text_row(_("Latitude:"), 'latitude', null, 20, 20);
    text_row(_("Longitude:"), 'longitude', null, 20, 20);

    end_outer_table(1);

    div_start('controls');
    if ($customer_id && $branch_id) {
        submit_center_first('submit', _("Save Geocode"), _('Save geocode information for this branch'), 'default');
        submit_center_last('delete', _("Delete Geocode"), _('Delete geocode information for this branch'), true);
    }
    div_end();
}

//------------------------------------------------------------------------------

if (isset($_POST['submit'])) {
    if ($selected_customer && $selected_branch) {
        update_geocode_info(
            $selected_customer, 
            $selected_branch, 
            $_POST['latitude'], 
            $_POST['longitude']
        );
        display_notification(_("Geocode information has been updated."));
    } else {
        display_error(_("Please select both a customer and a branch."));
    }
} elseif (isset($_POST['delete'])) {
    if ($selected_customer && $selected_branch) {
        delete_geocode_info($selected_customer, $selected_branch);
        display_notification(_("Geocode information has been deleted."));
        $Ajax->activate('_page_body');
    } else {
        display_error(_("Please select both a customer and a branch."));
    }
}

//------------------------------------------------------------------------------
start_form();

// DEBUGGING POST DATA
//display_error(json_encode($_POST));

if (db_has_customers()) {
    start_table(TABLESTYLE_NOBORDER);

    // Customer selection
    start_row();
    customer_list_cells(_("Select a customer: "), 'customer_id', $selected_customer, _('Select a customer'), true);
    end_row();

    // Branch selection
    if ($selected_customer) {
        start_row();
        customer_branches_list_cells(
            _("Select a branch: "), 
            $selected_customer, 
            'branch_id', 
            $selected_branch, 
            true, true, true, true
        );
        end_row();
    }

    end_table();

    // Geocode settings form
    if ($selected_customer && $selected_branch) {
        geocode_settings($selected_customer, $selected_branch);
    } else {
        display_notification(_("Please select a customer and a branch."));
    }
} else {
    display_notification(_("No customers found."));
}

end_form();
end_page();

