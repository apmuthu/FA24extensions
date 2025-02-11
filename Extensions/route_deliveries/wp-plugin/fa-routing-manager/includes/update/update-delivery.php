<?php
// includes/update/update-delivery.php

// Include necessary files
require_once('../../plugin-config.php');
require_once('../db/fa_constants.php');
require_once('../db/get-functions.php');

// Get the database connection
$conn = get_fa_db_connection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the POST data
    $wp_currenttime = $_POST['wp-datetime']; // WordPress time (Y-m-d)
    $shipper_id = $_POST['shipper_id'];
    $trans_no = $_POST['trans_no'];
    $type = $_POST['type'];
    $delivery_status = $_POST['delivery_status'];
    $payment_received = $_POST['payment_received'];
    $payment_amount = $_POST['payment_amount'];
    $notes = $_POST['notes'];
    $gps_coordinates = $_POST['gps_coordinates']; // Contains lat,lon
    $debtor_no = $_POST['debtor_no'];
    $branch_code = $_POST['branch_code'];
    $photo_proof = null; // For proof of delivery add in future
    $customer_acknowledged = null; // Explicitly setting NULL for this value

    // Define the table name with the TB_PREF prefix
    $table_name = TB_PREF . 'route_delivery_log';

    // Prepare the insert query
    $query = "INSERT INTO $table_name (
      shipper_id, transaction_no, type, debtor_no, branch_code, 
      gps_coordinates, delivery_status, notes, payment_received, payment_amount, 
      photo_proof, customer_acknowledged
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // Prepare and execute the query
    if ($stmt = $conn->prepare($query)) {
        // Bind parameters
        $stmt->bind_param(
          'iiiisssssdsb',
          $shipper_id,        // INT
          $trans_no,         // INT
          $type,             // SMALLINT
          $debtor_no,        // INT
          $branch_code,      // INT
          $gps_coordinates,  // VARCHAR
          $delivery_status,  // ENUM
          $notes,            // TEXT
          $payment_received, // ENUM
          $payment_amount,   // DECIMAL
          $photo_proof,      // VARCHAR
          $customer_acknowledged // BOOLEAN (set to NULL)
        );

        // Execute the query
        if ($stmt->execute()) {
            $message = "Record successfully inserted!";
        } else {
            $message = "Error inserting record: " . $stmt->error;
        }

        // Close the statement
        $stmt->close();
    } else {
        $message = "Error preparing query: " . $conn->error;
    }

$backLink = isset($_SERVER['HTTP_REFERER']) ? htmlspecialchars($_SERVER['HTTP_REFERER']) : '#';
    
    // Display the result to the user
    echo <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Update</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            line-height: 1.6;
            background-color: #f9f9f9;
        }
        .message {
            padding: 20px;
            background-color: #e7f3fe;
            border: 1px solid #b3d7ff;
            color: #31708f;
            border-radius: 5px;
        }
        .back-link {
            margin-top: 20px;
            display: inline-block;
            padding: 10px 15px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="message">
        $message
    </div>
    <a href="$backLink" class="back-link">Go Back</a>
</body>
</html>
HTML;
}

