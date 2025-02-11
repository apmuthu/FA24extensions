<?php
$page_security = 'SA_CUSTOMER';
$path_to_root = "../../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/sales/includes/db/customers_db.inc");
include_once($path_to_root . "/modules/route_deliveries/includes/route_delivery.inc");

page(_($help_context = "Batch Geocode Update"));

function show_batch_results_table($geocode_results, $current_page = 1, $rows_per_page = 100) {
    // Calculate total rows and total pages
    $total_rows = count($geocode_results);
    $total_pages = ceil($total_rows / $rows_per_page);

    // Ensure current page is within bounds
    $current_page = max(1, min($total_pages, $current_page));

    // Calculate the offset for the current page
    $offset = ($current_page - 1) * $rows_per_page;

    // Extract rows for the current page
    $page_results = array_slice($geocode_results, $offset, $rows_per_page);

    // Start table
    div_start("geocode_tbl");
    start_table(TABLESTYLE, "width=80%");
    $th = [_("Branch ID"), _("Customer Name"), _("Branch Name"), _("Address"), _("Latitude"), _("Longitude"), _("Actions")];
    table_header($th);

    foreach ($page_results as $result) {
        $branch_id = $result['branch_id'] ?? null;
        $customer_name = $result['customer_name'] ?? '';
        $branch_name = $result['branch_name'] ?? '';
        $address = $result['address'] ?? '';
        $latitude = $result['latitude'] ?? '';
        $longitude = $result['longitude'] ?? '';

        start_row();
        label_cell($branch_id);
        label_cell($customer_name);
        label_cell($branch_name);
        textarea_cells(null, "address_$branch_id", $address, 25, 4);
        text_cells(null, "latitude_$branch_id", $latitude, 10, 20, 'readonly');
        text_cells(null, "longitude_$branch_id", $longitude, 10, 20, 'readonly');
        select_button_cell("save_row_".$branch_id, true);
        end_row();
    }

    end_table();
    div_end();

    // Add pagination controls below the table
    echo '<div class="pagination" style="text-align:center; margin:10px;">';

    // Previous Page Link
    if ($current_page > 1) {
        $prev_page = $current_page - 1;
        echo "<a href='?page=$prev_page'>&laquo; Previous</a> ";
    }

    // Page Number Links
    for ($i = 1; $i <= $total_pages; $i++) {
        if ($i == $current_page) {
            echo "<strong>$i</strong> ";
        } else {
            echo "<a href='?page=$i'>$i</a> ";
        }
    }

    // Next Page Link
    if ($current_page < $total_pages) {
        $next_page = $current_page + 1;
        echo "<a href='?page=$next_page'>Next &raquo;</a>";
    }

    echo '</div>';
}


function generate_download_link($file_path, $file_name) {
    // Move the file to FrontAccounting's reporting directory
    $report_dir = company_path() . '/reporting/';
    $new_file_path = $report_dir . $file_name;

    if (!rename($file_path, $new_file_path)) {
        display_error(_("Failed to move the CSV file to the reporting directory."));
        return '';
    }

    // Generate the download link
    return "<a href='$new_file_path' target='_blank'>" . _("Download CSV File") . "</a>";
}

function create_csv_for_page() {
  // Fetch all branches for batch processing
  $branches = get_all_branches_for_batch();
  $branch_data = [];

  while ($branch = db_fetch($branches)) {

      $branch_data[$branch['branch_code']] = [
          'branch_id' => $branch['branch_code'],
          'customer_id' => $branch['debtor_no'],
          'customer_name' => $branch['customer_name'],
          'branch_name' => $branch['br_name'],
          'address' => $branch['br_post_address'],
      ];
  }

  // Generate a CSV file for batch geocoding
  $csv_file_path = generate_census_batch_csv($branch_data, true);

  if ($csv_file_path) {
      $download_link = generate_download_link($csv_file_path, "batch_geocodes.csv");

  display_notification(_("CSV file created successfully. You can download it -> " . $download_link));
  } else {
      display_error(_("Failed to generate CSV file for geocoding."));
  }

  // End processing after CSV creation
  end_page();
  exit;
}

function fetch_geocodes_for_page() {
  // Fetch all branches for batch processing
  $branches = get_all_branches_for_batch();
  $branch_data = [];

  while ($branch = db_fetch($branches)) {
      // Format the address into a single line

      $branch_data[$branch['branch_code']] = [
          'branch_id' => $branch['branch_code'],
          'customer_id' => $branch['debtor_no'],
          'customer_name' => $branch['customer_name'],
          'branch_name' => $branch['br_name'],
          'address' => $branch['br_post_address'],
      ];
  }

  // Generate a CSV file for batch geocoding
  $csv_file_path = generate_census_batch_csv($branch_data, false);

  if ($csv_file_path) {
      // Fetch geocode results from the Census API
      $geocode_results = fetch_batch_from_census($csv_file_path);

      // Delete the temporary CSV file after use
      unlink($csv_file_path);

      if ($geocode_results) {
        // Map geocode results by branch_id
        foreach ($geocode_results as $geocode) {
            if (isset($geocode[0]) && isset($geocode[5])) { // Ensure branch_id and coordinates exist
                $branch_id = $geocode[0]; // Assuming column 0 contains branch_id
                $split_geocode = explode(',', $geocode[5]); // Column 5 contains lat/long
                foreach ($branch_data as &$branch) {
                    if ($branch['branch_id'] === $branch_id) {
                        $branch['latitude'] = $split_geocode[0]; // Latitude
                        $branch['longitude'] = $split_geocode[1]; // Longitude
                        break; // Stop searching once matched
                    }
                }
            }
        }

          // Store results in the session for review
          $_SESSION['geocode_results'] = $branch_data;
          display_notification(_("Geocode results fetched successfully. Review and save them below."));
      } else {
          display_error(_("Failed to fetch geocode results. Please try again later."));
      }
  } else {
      display_error(_("Failed to generate CSV file for geocoding."));
  }
}

function batch_update_geocodes_page() {
  global $Ajax;

    if (isset($_POST['create_csv'])) {
      create_csv_for_page();
    }

    if (isset($_POST['fetch_geocodes'])) {
      fetch_geocodes_for_page();
    }

  if (isset($_POST['save_geocodes'])) {  
    foreach ($_POST as $key => $value) {
      // Check if the key starts with "latitude_"
      if (strpos($key, 'latitude_') === 0) {
        $branch_id = str_replace('latitude_', '', $key); // Extract branch ID

        $latitudeKey = "latitude_" . $branch_id;
        $longitudeKey = "longitude_" . $branch_id;
        $addressKey = "address_" . $branch_id;

        if (isset($_POST[$latitudeKey]) && isset($_POST[$longitudeKey]) && isset($_POST[$addressKey])) {
          $latitude = $_POST[$latitudeKey];
          $longitude = $_POST[$longitudeKey];
          $address = $_POST[$addressKey];

          if (is_numeric($latitude) && is_numeric($longitude)) {
            if (isset($_SESSION['geocode_results'][$branch_id])) { // Check if branch_id exists in session
              $customer_id = $_SESSION['geocode_results'][$branch_id]['customer_id'];
              update_geocode_info($customer_id, $branch_id, $latitude, $longitude, $address);
            } else {
              // Log an error, skip this record, or handle it as needed.
              display_error("Branch ID $branch_id not found in session!");
              continue; // Skip to the next iteration
            }

          }
        }
      }
    }
    display_notification(_("Geocode data saved successfully."));
  }

    // Handle individual save_row button clicks
    foreach ($_POST as $key => $value) {
      if (strpos($key, 'save_row_') === 0) { // Check if button name starts with 'save_row_'
        $branch_id = str_replace('save_row_', '', $key); // Extract branch ID
        $br_post_address = get_post('address_'.$branch_id);
        $latitude = get_post("latitude_$branch_id");
        $longitude = get_post("longitude_$branch_id");

        if (is_numeric($latitude) && is_numeric($longitude)) {
          update_branch_address($branch_id, $br_post_address);
          update_geocode_info($_SESSION['geocode_results'][$branch_id]['customer_id'], $branch_id, $latitude, $longitude);

        if (isset($_SESSION['geocode_results'][$branch_id])) {
          $_SESSION['geocode_results'][$branch_id]['latitude'] = $latitude;
          $_SESSION['geocode_results'][$branch_id]['longitude'] = $longitude;
          $_SESSION['geocode_results'][$branch_id]['address'] = $br_post_address;
        }

        display_notification(_("Geocode data saved for Branch ID: ") . $branch_id);
        } else {
          display_error(_("Invalid latitude or longitude for Branch ID: ") . $branch_id);
        }

        $Ajax->activate('_page_body');
        break; // Stop loop after finding the pressed button
      }
    }

    if (isset($_POST['cancel_geocodes'])) {
        unset($_SESSION['geocode_results']); // Clear session on cancel
        display_notification(_("Batch geocode update canceled."));
        $Ajax->activate('_page_body');
    }

    // Debug
    //display_notification(json_encode($_POST));
    //display_notification(json_encode($_SESSION['geocode_results']));
    //display_notification(json_encode(isset($_SESSION['geocode_results'])));

    start_form();

    if (isset($_SESSION['geocode_results'])) {
        // Show the results table for review and editing
        show_batch_results_table($_SESSION['geocode_results'], $_GET['page'] ?? null);
        submit_center_first('save_geocodes', _("Save Page Changes"), '', _('Save all geocode updates.'));
        submit_center_last('cancel_geocodes', _("Cancel"), '', _('Cancel the batch geocode process.'));
          $Ajax->activate('_page_body');
    } else {
        // Show the button to fetch geocode data
        submit_center_first('fetch_geocodes', _("Fetch Geocode Data"), true, _('Fetch geocode data for all branches.'));
        submit_center_last('create_csv', _("Create CSV"), true, _('Create CSV for census.'));
    }
    end_form();
    end_page();

}

batch_update_geocodes_page();

