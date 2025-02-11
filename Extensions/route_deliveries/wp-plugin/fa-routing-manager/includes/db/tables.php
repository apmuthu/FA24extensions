<?php
function check_and_create_route_delivery_gps_table() {
  // Get Front Accounting database connection
  $conn = get_fa_db_connection();

  // Define the table name
  $table_name = TB_PREF . 'route_delivery_gps';

  // Define the expected columns
  $expected_columns = [
    'id',
    'debtor_no',
    'branch_no',
    'latitude',
    'longitude',
    'last_updated',
    'created_at'
  ];

  // Check if the table exists
  $sql = "SHOW TABLES LIKE '$table_name'";
  $result = $conn->query($sql);

  if ($result->num_rows === 0) {
    // Table doesn't exist, create it
    $sql_create = "
        CREATE TABLE $table_name (
            `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
            `debtor_no` INT NOT NULL,
    `branch_no` INT NOT NULL,
            `latitude` DECIMAL(10, 6) NOT NULL,
            `longitude` DECIMAL(11, 6) NOT NULL,
            `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )";
    if ($conn->query($sql_create) === TRUE) {
      return 'Table created successfully.';
    } else {
      return 'Error creating table: ' . $conn->error;
    }
  } else {
    // Table exists, check columns
    $sql_describe = "DESCRIBE $table_name";
    $result = $conn->query($sql_describe);

    if ($result) {
      $current_columns = [];
      while ($row = $result->fetch_assoc()) {
        $current_columns[] = $row['Field'];
      }

      // Compare current columns with expected columns
      $missing_columns = array_diff($expected_columns, $current_columns);
      $extra_columns = array_diff($current_columns, $expected_columns);

      if (empty($missing_columns) && empty($extra_columns)) {
        return 'Table structure matches the expected schema.';
      } else {
        $status_message = '';
        if (!empty($missing_columns)) {
          $status_message .= 'Missing columns: ' . implode(', ', $missing_columns) . '. ';
        }
        if (!empty($extra_columns)) {
          $status_message .= 'Extra columns: ' . implode(', ', $extra_columns) . '.';
        }
        return $status_message;
      }
    } else {
        return 'Error fetching table structure: ' . $conn->error;
    }
  }
}

function check_and_create_delivery_log_table() {
    // Get Front Accounting database connection
    $conn = get_fa_db_connection();

    // Define the table name
    $table_name = TB_PREF . 'route_delivery_log';

    // Define the expected columns
    $expected_columns = [
      'log_id',
      'shipper_id',
      'transaction_no',
      'type',
      'debtor_no',
      'branch_code',
      'gps_coordinates',
      'delivery_status',
      'notes',
      'payment_received',
      'payment_amount',
      'photo_proof',
      'customer_acknowledged',
      'timestamp'
    ];

    // Check if the table exists
    $sql = "SHOW TABLES LIKE '$table_name'";
    $result = $conn->query($sql);

    if ($result->num_rows === 0) {
        // Table doesn't exist, create it
        $sql_create = "
            CREATE TABLE $table_name (
              `log_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
              `shipper_id` INT NOT NULL,
              `transaction_no` INT NOT NULL,
              `type` SMALLINT UNSIGNED NOT NULL,
              `debtor_no` INT UNSIGNED DEFAULT NULL,
              `branch_code` INT NOT NULL,
              `gps_coordinates` VARCHAR(255) DEFAULT NULL,
              `delivery_status` ENUM('delivered', 'rescheduled', 'failed') NOT NULL DEFAULT 'delivered',
              `notes` TEXT DEFAULT NULL,
              `payment_received` ENUM('none', 'cash', 'check', 'card', 'other') DEFAULT 'none',
              `payment_amount` DECIMAL(10,2) DEFAULT NULL,
              `photo_proof` VARCHAR(255) DEFAULT NULL,
              `customer_acknowledged` BOOLEAN DEFAULT FALSE,
              `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE INDEX (`type`, `transaction_no`),
        INDEX (`debtor_no`, `branch_code`),
        INDEX (`timestamp`),
        INDEX (`shipper_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        ";
        if ($conn->query($sql_create) === TRUE) {
            return 'Table created successfully.';
        } else {
            return 'Error creating table: ' . $conn->error;
        }
    } else {
        // Table exists, check columns
        $sql_describe = "DESCRIBE $table_name";
        $result = $conn->query($sql_describe);

        if ($result) {
            $current_columns = [];
            while ($row = $result->fetch_assoc()) {
                $current_columns[] = $row['Field'];
            }

            // Compare current columns with expected columns
            $missing_columns = array_diff($expected_columns, $current_columns);
            $extra_columns = array_diff($current_columns, $expected_columns);

            if (empty($missing_columns) && empty($extra_columns)) {
                return 'Table structure matches the expected schema.';
            } else {
                $status_message = '';
                if (!empty($missing_columns)) {
                    $status_message .= 'Missing columns: ' . implode(', ', $missing_columns) . '. ';
                }
                if (!empty($extra_columns)) {
                    $status_message .= 'Extra columns: ' . implode(', ', $extra_columns) . '.';
                }
                return $status_message;
            }
        } else {
            return 'Error fetching table structure: ' . $conn->error;
        }
    }
}

function check_and_create_route_delivery_recurrent_table() {
    // Get Front Accounting database connection
    $conn = get_fa_db_connection();

    // Define the table name
    $table_name = TB_PREF . 'route_delivery_recurrent';

    // Define the expected columns and structure
    $expected_columns = [
        'id',
        'debtor_no',
        'order_no',
        'description',
        'start_date',
        'end_date',
        'recurrence_type',
        'custom_interval',
        'days_of_week',
        'day_of_month',
        'month_of_year',
        'week_of_month',
        'time_of_day',
        'next_occurrence',
        'is_active',
        'created_at',
        'updated_at',
    ];

    // Check if the table exists
    $sql = "SHOW TABLES LIKE '$table_name'";
    $result = $conn->query($sql);

    if ($result->num_rows === 0) {
        // Table doesn't exist, create it
        $sql_create = "
            CREATE TABLE $table_name (
                `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                `debtor_no` INT NOT NULL,
                `order_no` INT NOT NULL,
                `description` VARCHAR(255) NOT NULL,
                `start_date` DATE NOT NULL,
                `end_date` DATE DEFAULT NULL,
                `recurrence_type` ENUM('daily', 'weekly', 'monthly', 'yearly') DEFAULT NULL,
                `custom_interval` INT DEFAULT 1 CHECK (custom_interval > 0),
                `days_of_week` SET('1', '2', '3', '4', '5', '6', '7') DEFAULT NULL,
                `day_of_month` TINYINT DEFAULT NULL CHECK (day_of_month BETWEEN 1 AND 31),
                `month_of_year` TINYINT DEFAULT NULL CHECK (month_of_year BETWEEN 1 AND 12),
                `week_of_month` TINYINT DEFAULT NULL CHECK (week_of_month BETWEEN 1 AND 5),
                `time_of_day` TIME DEFAULT NULL,
                `next_occurrence` DATETIME DEFAULT NULL,
                `is_active` BOOLEAN DEFAULT TRUE,
                `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                INDEX (`debtor_no`, `order_no`),
                INDEX (`start_date`),
                INDEX (`next_occurrence`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
        ";

        if ($conn->query($sql_create) === TRUE) {
            return 'Table created successfully.';
        } else {
            return 'Error creating table: ' . $conn->error;
        }
    } else {
        // Table exists, check columns
        $sql_describe = "DESCRIBE $table_name";
        $result = $conn->query($sql_describe);

        if ($result) {
            $current_columns = [];
            while ($row = $result->fetch_assoc()) {
                $current_columns[] = $row['Field'];
            }

            // Compare current columns with expected columns
            $missing_columns = array_diff($expected_columns, $current_columns);
            $extra_columns = array_diff($current_columns, $expected_columns);

            if (empty($missing_columns) && empty($extra_columns)) {
                return 'Table structure matches the expected schema.';
            } else {
                $status_message = '';
                if (!empty($missing_columns)) {
                    $status_message .= 'Missing columns: ' . implode(', ', $missing_columns) . '. ';
                }
                if (!empty($extra_columns)) {
                    $status_message .= 'Extra columns: ' . implode(', ', $extra_columns) . '.';
                }
                return $status_message;
            }
        } else {
            return 'Error fetching table structure: ' . $conn->error;
        }
    }
}

