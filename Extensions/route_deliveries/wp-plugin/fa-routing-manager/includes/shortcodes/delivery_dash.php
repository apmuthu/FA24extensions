<?php
function restrict_shipper_dashboard_access() {
  // Check if user is 'fa_shipper' role
  if (is_page('technician-dashboard') && !current_user_can('fa_shipper') ) {
      wp_redirect(home_url()); 
      exit;
  }
}

function display_shipper_dash_welcome() {
  $output = '<p>Here you can track your daily tasks, mark jobs as complete, '
    .'and log service details to ensure proper invoicing and job completion '
    .'records.</p>';
  return $output;
}

function display_shipper_help_info() {
  $output = '<h2 class="wp-block-heading">Need Assistance?</h2>';
  $output .= '<p>If you have any questions or need to report an issue, please '
            .'contact our support team:</p>';
  $output .= '<p><strong>Email: </strong>' 
            .'<a href="mailto:'.SHIPPER_SUPPORT_EMAIL.'">'
            .SHIPPER_SUPPORT_EMAIL.'</a></p>';
  $output .= '<p>Thank you for your hard work!</>';
  return $output;
}

function technician_dashboard_shipper_details() {
  // Get the current user
  $user = wp_get_current_user();
  
    // Get the shipper_name from the user meta
    $shipper_name = get_user_meta($user->ID, 'shipper_name', true);
    
    // If shipper_name is not empty, fetch the shipper details
    if (!empty($shipper_name)) {
      $shipper_details = get_shipper_by_name($shipper_name);
      
      if ($shipper_details) {
        // Format and display the shipper details
        $output = '<div class="shipper-info">';
        $output .= '<h3>Shipper Details</h3>';
        $output .= '<p><strong>Shipper Name:</strong> ' 
          . esc_html($shipper_details['shipper_name']) . '</p>';
        $output .= '<p><strong>Address:</strong> ' 
          . esc_html($shipper_details['address']) . '</p>';
        $output .= '<p><strong>Phone:</strong> ' 
          . esc_html($shipper_details['phone']) . '</p>';
        $output .= '<p><strong>Alt Phone:</strong> ' 
          . esc_html($shipper_details['phone2']) . '</p>';
        $output .= '<p><strong>Shipper ID:</strong> ' 
          . esc_html($shipper_details['shipper_id']) . '</p></div>';
        
        return $output;
      } else {
        return '<p>No shipper details found for this technician.</p>';
      }
    } else {
      return '<p>No shipper name set for this technician.</p>';
    }
}

function display_deliveries_today_shortcode() {
  $result = get_logged_in_shipper();

  if (isset($result['error'])) {
      return $result['error'];
  }

  $shipper = $result['shipper'];  

  // Fetch the status messages for route delivery tables
  $log_status_message = check_and_create_delivery_log_table();
  
  $output = '';

  // Display table status messages if available
  if (!empty($log_status_message) && 
    $log_status_message != 'Table structure matches the expected schema.') {
      $output .= '<div class="status-message"><p>Log Table: ' 
        . esc_html($log_status_message) . '</p></div>';
  }

  // Fetch deliveries for the shipper
  $sql = get_sql_for_deliveries($shipper['shipper_id'], current_time('Y-m-d'));
  $conn = get_fa_db_connection();
  $result = $conn->query($sql);

  if (!$result) {
      return 'Error fetching deliveries: ' . $conn->error;
  }

  $delivery_count = 0;   // Initialize the delivery count
  $osrm_index = 0;
  $total_amount_sum = 0;

  // Build the delivery table
  $output .= "<h2>Today's Deliveries for " . esc_html($shipper['shipper_name']) . '</h2>';
  $output .= '<div class="delivery-table-container">';
  $output .= '<button type="button" id="optimizeRouteBtn" class="optimize-route-btn wp-element-button">Optimize Route</button>';
  $output .= '<table id="today-delivery-table" class="delivery-table">';
  $output .= '<tr>
          <th>Name</th>
          <th>Address</th>
          <th>Total Amount</th>
          <th>Notes</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>';


  if ($result->num_rows === 0) {
    $output .= '<tr><td colspan="6">No deliveries scheduled for today.</td></tr>';
  } else {
    // Initialize an array to store all GPS coordinates
    $coordinates = [];

    // Add the starting point to the coordinates array
    $coordinates[] = ['lat' => START_LAT, 'lng' => START_LON];

    while ($row = $result->fetch_assoc()) {
      $latitude = $row['latitude'];
      $longitude = $row['longitude'];
      $delivery_status = $row['delivery_status'];
      $timestamp = ($delivery_status === 'Pending') ? null : $row['status_timestamp'];
      $logged_gps = ($delivery_status === 'Pending') ? null : $row['gps_coordinates'];
      $map_link = 'https://www.google.com/maps?q=' . $latitude . ',' . $longitude;
      /* Create a link to OpenStreetMap for individual stop
      $map_link = 'https://www.openstreetmap.org/?mlat=' . $latitude . '&mlon=' 
        . $longitude . '#map=16/' . $latitude . '/' . $longitude;*/
      
      // Calculate the Total Amount
      $delivery_count++; 
      $total_amount = $row['TotalAmount'];
      $total_amount_sum += $total_amount; // Add to the sum

      // Store the coordinates with status and timestamp for js map display
      $coordinates[] = [
          'lat' => $latitude,
          'lng' => $longitude,
          'status' => $delivery_status,
          'timestamp' => $timestamp,
          'logged_gps' => $logged_gps
      ];

      // Create a row for each delivery
      $output .= '<tr class="delivery-row" id="delivery-row-'  . esc_attr($row['trans_no']) . '"'; 
      if ($row['delivery_status'] === 'Pending') {
        $osrm_index++;
        $output .= ' data-osrm="' . esc_attr($osrm_index) . '"';
      }
      $output .= ' data-lat="' . esc_attr($latitude) . '" data-lng="' 
        . esc_attr($longitude) . '" data-index="' . $delivery_count 
        . '" data-status="' . esc_attr($delivery_status) . '" data-timestamp="' 
        . esc_attr($timestamp)  . '" data-row-id="' . esc_attr($row['trans_no']) . '">';
      $output .= '<td><a href="tel:' . esc_html($row['phone1']) . '">' 
        . esc_html($row['branch_name']) . '</a></td>';
      $output .= '<td><a href="' . esc_url($map_link) . '" target="_blank">' 
        . esc_html($row['branch_address']) . '</a></td>';
      $output .= '<td>' . esc_html(number_format((float)$total_amount, 2)) 
        . '</td>';  // Display total amount
      $output .= '<td>' . esc_html($row['trans_memo']) . '</td>';
      $output .= '<td>' . esc_html($row['delivery_status']) . '</td>';
      $output .= '<td>';
      if ($row['delivery_status'] === 'Pending') {
            $output .= '<button type="button" class="edit-btn" data-row-id="' 
                . htmlspecialchars($row['trans_no']) . '">Edit</button>';
        } else {
            $output .= '<span class="no-edit">Not Editable</span>';
        }
      $output .= '</td>';
      $output .= '</tr>';

      // Add hidden form row for editing
      $output .= '<tr class="edit-form-row" id="edit-form-' . esc_attr($row['trans_no']) 
        . '" data-row-id="' . esc_attr($row['trans_no']) . '" style="display: none;">
              <td colspan="6">
              <form class="edit-delivery-form" action="' . plugins_url("../update/update-delivery.php", __FILE__) . '" method="POST">
                <input type="hidden" name="wp-datetime" value="' 
                . esc_attr(current_time('Y-m-d')) . '">
                <input type="hidden" name="trans_no" value="' 
                . esc_attr($row['trans_no']) . '">
                <input type="hidden" name="type" value="' 
                . esc_attr($row['type']) . '">
                <input type="hidden" name="debtor_no" value="' 
                . esc_attr($row['debtor_no']) . '">
                <input type="hidden" name="branch_code" value="' 
                . esc_attr($row['branch_code']) . '">
                <input type="hidden" name="shipper_id" value="' 
                . esc_attr($shipper['shipper_id']) . '">
                <input type="hidden" id="gps_coordinates" name="gps_coordinates">
                <div>
                <label for="delivery_status">Delivery Status:</label>
                    <select id="delivery_status" name="delivery_status">
                        <option value="delivered">Delivered</option>
                        <option value="rescheduled">Rescheduled</option>
                        <option value="failed">Failed</option>
                    </select>
                </div>
                <div>
    <label for="payment_received">Payment Received:</label>
      <select id="payment_received" name="payment_received">
          <option value="none">None</option>
          <option value="cash">Cash</option>
          <option value="check">Check</option>
          <option value="card">Card</option>
          <option value="other">Other</option>
      </select>
                </div>
                <div>
      <label for="payment_amount">Payment Amount:</label>
      <input type="number" step="0.01" id="payment_amount" name="payment_amount">
                </div>
                <div>
  <label for="notes">Notes:</label>
    <textarea id="notes" name="notes"></textarea>
                </div>
                <div>
                  <button type="submit">Update</button>
                  <button type="button" class="cancel-btn">Cancel</button>
                </div>
                </form>
              </td>
            </tr>';
    }
  }

// Add the footer row
  $output .= '<tr class="final-row">
          <td colspan="1" style="text-align: right; font-weight: bold;">Total:</td>
          <td style="font-weight: bold;">' . esc_html(number_format($total_amount_sum, 2)) . '</td>
          <td colspan="1" style="text-align: right; font-weight: bold;">Remaing:</td>
          <td style="font-weight: bold;">' . esc_html($osrm_index) . '</td>
          <td colspan="1" style="text-align: right; font-weight: bold;">Total Deliveries:</td>
          <td style="font-weight: bold;">' . esc_html($delivery_count) . '</td>
        </tr>';

  $output .= '</table>';
  $output .= '</div>';

//Javascript sort
$output .= '<script type="text/javascript">
document.getElementById("optimizeRouteBtn").addEventListener("click", function () {
    const coordinates = ' . json_encode($coordinates) . ';

    // Home point is always the first coordinate
    const homePoint = coordinates[0];
    let source = homePoint;
    let destination = homePoint;
    let pendingCoordinates = [];
    let lastDelivered = null;

    // Process the coordinates array
    for (let i = 1; i < coordinates.length; i++) {
        const coord = coordinates[i];

        if (coord.status === "Pending") {
            pendingCoordinates.push(coord);
        }

        if (coord.status === "delivered") {
            // Find the most recent delivered using timestamp
            if (!lastDelivered || new Date(coord.timestamp) > new Date(lastDelivered.timestamp)) {
                lastDelivered = coord;
            }
        }
    }

    // Determine source and destination based on conditions
    if (pendingCoordinates.length === 0) {
        alert("No pending stops left.");
        return; // Exit if no pending stops
    }

    if (lastDelivered) {
        source = { lat: lastDelivered.logged_gps.split(",")[0], lng: lastDelivered.logged_gps.split(",")[1] };
    }

    destination = homePoint;

    // Prepare the coordinates list
    const routeCoordinates = [
        source,
        ...pendingCoordinates,
        destination
    ];

    const osrmCoordinates = routeCoordinates.map(coord => `${coord.lng},${coord.lat}`).join(";");
    const url = `https://router.project-osrm.org/trip/v1/car/${osrmCoordinates}?roundtrip=false&source=first&destination=last`;

    // Fetch the optimized route from OSRM
    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.code === "Ok" && data.waypoints && data.waypoints.length > 0) {
                const optimizedOrder = data.waypoints.map(waypoint => waypoint.waypoint_index);
                reorderTableRows(optimizedOrder);
            } else {
                alert("No optimized route found.");
            }
        })
        .catch(error => {
            console.error("Error fetching the optimized route:", error);
            alert("There was an error fetching the optimized route.");
        });
});

function reorderTableRows(optimizedOrder) {
    const table = document.getElementById("today-delivery-table");
    const rows = Array.from(table.querySelectorAll("tr.delivery-row"));
    const finalRow = table.querySelector("tr.final-row");

    if (!optimizedOrder || optimizedOrder.length < 2) {
        console.error("Optimized order is invalid:", optimizedOrder);
        return;
    }

    // Remove the first and last element from optimizedOrder
    optimizedOrder = optimizedOrder.slice(1, -1);

    const pendingRows = rows.filter(row => row.getAttribute("data-status") === "Pending");

    // Map pending rows with OSRM waypoints
    const osrmWaypoints = pendingRows.map(row => {
        const osrmIndex = parseInt(row.getAttribute("data-osrm"), 10);
        const rowId = row.getAttribute("data-row-id");
        const editRow = document.querySelector(`tr.edit-form-row[data-row-id="${rowId}"]`);
        const waypointIndex = optimizedOrder[osrmIndex - 1];

        if (waypointIndex === -1) {
            console.warn(`OSRM index ${osrmIndex} not found in optimized order`);
        }

        return { osrmIndex, waypointIndex, row, editRow };
    });

    // Sort based on waypointIndex, ignoring missing indices (-1)
    const sortedOsrmWaypoints = osrmWaypoints.filter(item => item.waypointIndex >= 0)
        .sort((a, b) => a.waypointIndex - b.waypointIndex);

    // Clear pending rows from the table
    pendingRows.forEach(row => row.remove());

    // Use DocumentFragment for efficient DOM manipulation
    const fragment = document.createDocumentFragment();

    // Append each sorted row and its corresponding editRow
    sortedOsrmWaypoints.forEach(({ row, editRow }) => {
        fragment.appendChild(row);
        if (editRow) {
            fragment.appendChild(editRow);
        }
    });

    const nonPendingRows = rows.filter(row => row.getAttribute("data-status") !== "Pending");
    const sortedNonPendingRows = nonPendingRows.sort((a, b) => {
        const timestampA = new Date(a.getAttribute("data-timestamp"));
        const timestampB = new Date(b.getAttribute("data-timestamp"));
        return timestampA - timestampB;
    });

    // Append non-pending row
    sortedNonPendingRows.forEach(nonPendingRow => table.appendChild(nonPendingRow));
    //rows.filter(row => row.getAttribute("data-status") !== "Pending")
      //  .forEach(nonPendingRow => table.appendChild(nonPendingRow));

    // Append sorted rows and non-pending rows back to the table
    table.appendChild(fragment);

    // Append the final row, if present
    if (finalRow) table.appendChild(finalRow);
}
</script>';


    $conn->close();

    return $output;
}

function display_unlogged_deliveries_shortcode() {
    $result = get_logged_in_shipper();

    if (isset($result['error'])) {
        return $result['error'];
    }

    $shipper = $result['shipper'];

    // Get the date range: yesterday and 7 days before
    $end_date = date('Y-m-d', strtotime('yesterday'));
    $start_date = date('Y-m-d', strtotime('-7 days', strtotime($end_date)));

    // Fetch deliveries for the shipper within the date range
    $sql = get_sql_for_deliveries($shipper['shipper_id'], $start_date, $end_date);
    $conn = get_fa_db_connection();
    $result = $conn->query($sql);

    if (!$result) {
        return 'Error fetching deliveries: ' . $conn->error;
    }

    // Prepare the output
    $output = '<h2>Past Due (unlogged) Deliveries for ' . esc_html($shipper['shipper_name']) . '</h2>';
    $output .= '<div class="delivery-table-container">';
    $output .= '<table class="delivery-table">';
    $output .= '<tr>
                <th>Date</th>
                <th>Trans</th>
                <th>Name</th>
                <th>Address</th>
                <th>Notes</th>
                <th>Actions</th>
                </tr>';

    $pending_found = false;

    if ($result->num_rows === 0) {
        $output .= '<tr><td colspan="5">No deliveries found in the last 7 days.</td></tr>';
    } else {
        while ($row = $result->fetch_assoc()) {
            // Check for Pending deliveries
            if ($row['delivery_status'] === 'Pending') {
                $pending_found = true;
                $output .= '<tr class="not-delivered">';
                $output .= '<td>' . esc_html($row['tran_date']) . '</td>';
                $output .= '<td>' . esc_attr($row['trans_no']) . '</td>';
                $output .= '<td>' . esc_html($row['branch_name']) . '</td>';
                $output .= '<td>' . esc_html($row['branch_address']) . '</td>';
                $output .= '<td>' . esc_html($row['trans_memo']) . '</td>';
                $output .= '<td><button type="button" class="edit-btn" data-row-id="' 
                    . htmlspecialchars($row['trans_no']) . '">Edit</button></td>';
                //$output .= '<td>' . esc_html($row['delivery_status']) . '</td>';
                $output .= '</tr>';
      // Add hidden form row for editing
      $output .= '<tr class="edit-form-row" id="edit-form-' 
        . esc_attr($row['trans_no']) . '" style="display: none;">
              <td colspan="6">
              <form class="edit-delivery-form" action="' . plugins_url("../update/update-delivery.php", __FILE__) . '" method="POST">
                <input type="hidden" name="wp-datetime" value="' 
                . esc_attr(current_time('Y-m-d')) . '">
                <input type="hidden" name="trans_no" value="' 
                . esc_attr($row['trans_no']) . '">
                <input type="hidden" name="type" value="' 
                . esc_attr($row['type']) . '">
                <input type="hidden" name="debtor_no" value="' 
                . esc_attr($row['debtor_no']) . '">
                <input type="hidden" name="branch_code" value="' 
                . esc_attr($row['branch_code']) . '">
                <input type="hidden" name="shipper_id" value="' 
                . esc_attr($shipper['shipper_id']) . '">
                <input type="hidden" id="gps_coordinates" name="gps_coordinates">
                <div>
                <label for="delivery_status">Delivery Status:</label>
                    <select id="delivery_status" name="delivery_status">
                        <option value="delivered">Delivered</option>
                        <option value="rescheduled">Rescheduled</option>
                        <option value="failed">Failed</option>
                    </select>
                </div>
                <div>
    <label for="payment_received">Payment Received:</label>
      <select id="payment_received" name="payment_received">
          <option value="none">None</option>
          <option value="cash">Cash</option>
          <option value="check">Check</option>
          <option value="card">Card</option>
          <option value="other">Other</option>
      </select>
                </div>
                <div>
      <label for="payment_amount">Payment Amount:</label>
      <input type="number" step="0.01" id="payment_amount" name="payment_amount">
                </div>
                <div>
  <label for="notes">Notes:</label>
    <textarea id="notes" name="notes"></textarea>
                </div>
                <div>
                  <button type="submit">Update</button>
                  <button type="button" class="cancel-btn">Cancel</button>
                </div>
                </form>
              </td>
            </tr>';
            }
        }

        if (!$pending_found) {
            $output .= '<tr><td colspan="5">No deliveries missing logs in the last 7 days.</td></tr>';
        }
    }

    $output .= '</table>';
    $output .= '</div>';

    $conn->close();

    return $output;
}

function load_delivery_dash_js() {
    wp_enqueue_style(
        'delivery-dash-style',
        plugins_url( '../../assets/css/delivery-dash.css', __FILE__ ), 
        array(), // Dependencies (if any)
        '1.0.10' // Version of your file
    );
    wp_enqueue_script( 'delivery-dash-script', 
        plugins_url( '../../assets/js/delivery-dash.js', __FILE__ ), 
        array( 'jquery' ), '1.08', true );
}


function recent_delivery_history_shortcode() {
  $result = get_logged_in_shipper();

  if (isset($result['error'])) {
      return $result['error'];
  }

  $shipper = $result['shipper'];

    // Form handling for date range
    $start_date = isset($_GET['start_date']) ? $_GET['start_date'] : '';
    $end_date = isset($_GET['end_date']) ? $_GET['end_date'] : '';
    $error_message = '';

    if (!empty($start_date) && !empty($end_date)) {
        $start_timestamp = strtotime($start_date);
        $end_timestamp = strtotime($end_date);

        if ($start_timestamp === false || $end_timestamp === false || $start_timestamp > $end_timestamp) {
            $error_message = 'Invalid date range.';
        } elseif (($end_timestamp - $start_timestamp) > (30 * 86400)) { // Limit range to 1 month
            $error_message = 'Date range exceeds the maximum allowed range of 1 month.';
        }
    }

    // Output the form
    $output = '<h2>Recent Delivery History for ' . esc_html($shipper['shipper_name']) . '</h2>';
    $output .= '<form class="date-start-end-form" method="GET">';
    $output .= '<label for="start_date">Start Date:</label>';
    $output .= '<input type="date" id="start_date" name="start_date" value="' . esc_attr($start_date) . '">';
    $output .= '<label for="end_date">End Date:</label>';
    $output .= '<input type="date" id="end_date" name="end_date" value="' . esc_attr($end_date) . '">';
    $output .= '<button type="submit">Filter</button>';
    $output .= '</form>';

    if (!empty($error_message)) {
        $output .= '<p style="color:red;">' . esc_html($error_message) . '</p>';
        return $output; // Stop processing if there's an error
    }

    if (!empty($start_date) && !empty($end_date)) {
        // Fetch deliveries within the date range for the shipper
        $sql = get_sql_for_deliveries(intval($shipper['shipper_id']), esc_sql($start_date), esc_sql($end_date));
        $conn = get_fa_db_connection();
        $result = $conn->query($sql);

        if (!$result) {
            return 'Error fetching deliveries: ' . $conn->error;
        }

        $delivery_count = 0;
        $missed_count = 0; 
        $total_amount_sum = 0;

        // Build the table
        $output .= '<table class="delivery-table">';
        $output .= '<tr>
                <th>Id</th>
                <th>Stamp</th>
                <th>Customer</th>
                <th>Address</th>
                <th>GPS</th>
                <th>Tech Note</th>
                <th>Status</th>
                <th>Amount</th>
            </tr>';

        if ($result->num_rows === 0) {
            $output .= '<tr><td colspan="4">No deliveries found for the selected range.</td></tr>';
        } else {
            while ($row = $result->fetch_assoc()) {
              if ($row['delivery_status'] === 'delivered') {
                $delivery_count++;
                $total_amount_sum += $row['TotalAmount'];
                list($lat, $long) = explode(',', $row['gps_coordinates']);
                $timestamp = new DateTime($row['status_timestamp'],new DateTimeZone(FA_TIMEZONE_SQL));
                $timestamp->setTimezone(new DateTimeZone(FA_TIMEZONE_DISPLAY));
                $local_time = $timestamp->format('Y-m-d H:i');

                $output .= '<tr>';
                $output .= '<td>' . esc_attr($row['trans_no']) . '</td>';
                $output .= '<td>' . esc_html($local_time) . '</td>';
                $output .= '<td>' . esc_html($row['branch_name']) . '</td>';
                $output .= '<td>' . esc_html($row['branch_address']) . '</td>';
                $output .= '<td><a href="https://maps.google.com/?q='.$lat.','.$long.'" target="_blank">Here</a></td>';
                $output .= '<td>' . esc_html($row['notes']) . '</td>';
                $output .= '<td>' . esc_html($row['delivery_status']) . '</td>';
                $output .= '<td>' . esc_html(number_format((float)$row['TotalAmount'], 2)) . '</td>';
                $output .= '</tr>';
            } else {
                $missed_count++;
                $output .= '<tr class="not-delivered">';
                $output .= '<td>' . esc_attr($row['trans_no']) . '</td>';
                $output .= '<td>' . esc_html($row['status_timestamp']) . '</td>';
                $output .= '<td>' . esc_html($row['branch_name']) . '</td>';
                $output .= '<td>' . esc_html($row['branch_address']) . '</td>';
                $output .= '<td><a href="https://maps.google.com/?q='.$lat.','.$long.'" target="_blank">N/A</a></td>';
                $output .= '<td>' . esc_html($row['notes']) . '</td>';
                $output .= '<td>' . esc_html($row['delivery_status']) . '</td>';
                $output .= '<td>' . esc_html(number_format((float)$row['TotalAmount'], 2)) . '</td>';
                $output .= '</tr>';
              }
            }
        }

        // Calculate percentages
        $total_deliveries = $delivery_count + $missed_count;
        $made_percentage = $total_deliveries > 0 ? ($delivery_count / $total_deliveries) * 100 : 0;
        $missed_percentage = $total_deliveries > 0 ? ($missed_count / $total_deliveries) * 100 : 0;

        // Add summary rows
        $output .= '<tfoot>';
        $output .= '<tr>
                <td colspan="7" style="text-align:right; font-weight:bold;">Total Deliveries:</td>
                <td style="font-weight:bold;">' . esc_html($delivery_count) . '</td>
            </tr>';
        $output .= '<tr>
                <td colspan="7" style="text-align:right; font-weight:bold;">Missed Deliveries:</td>
                <td style="font-weight:bold;">' . esc_html($missed_count) . '</td>
            </tr>';
        $output .= '<tr>
                <td colspan="7" style="text-align:right; font-weight:bold;">Made Percentage:</td>
                <td style="font-weight:bold;">' . esc_html(number_format($made_percentage, 2)) . '%</td>
            </tr>';
        $output .= '<tr>
                <td colspan="7" style="text-align:right; font-weight:bold;">Missed Percentage:</td>
                <td style="font-weight:bold;">' . esc_html(number_format($missed_percentage, 2)) . '%</td>
            </tr>';
        $output .= '<tr>
                <td colspan="7" style="text-align:right; font-weight:bold;">Total Amount (Delivered):</td>
                <td style="font-weight:bold;">' . esc_html(number_format((float)$total_amount_sum, 2)) . '</td>
            </tr>';
        $output .= '</tfoot>';
        $output .= '</table>';

        $conn->close();
    }

    return $output;
}

function display_shipper_dash_page() {
  $output = do_shortcode('[fa_shipper_welcome]');  
  $output .= do_shortcode('[fa_shipper_details]');  
  $output .= do_shortcode('[fa_unlogged_deliveries_table]');  
  $output .= do_shortcode('[fa_deliveries_today_table]');  
  $output .= do_shortcode('[fa_recent_delivery_table]');  
  $output .= do_shortcode('[fa_shipper_help_message]');  
  $output .= do_shortcode('[fa_delivery_dash_js]');  

  return $output;
}
