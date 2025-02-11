<?php

function get_fa_db_connection() {
    // Connect to the external database
    $conn = new mysqli(FA_DB_HOST, FA_DB_USER, FA_DB_PASSWORD, FA_DB_NAME);

    // Check the connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
  return $conn;
}

// Function to fetch customer name from the accounting database
function get_customer_name($customer_id) {
    $db = get_fa_db_connection();
    $sql = "SELECT name FROM " . TB_PREF . "debtors_master WHERE debtor_no = ?";
    $stmt = $db->prepare($sql);
    if ($stmt === false) {
        die('MySQL prepare error: ' . $db->error);
    }
    $stmt->bind_param('i', $customer_id); // 'i' indicates the type is integer
    $stmt->execute();
    $stmt->bind_result($name);
    if ($stmt->fetch()) {
        return $name;
    } else {
        return 'Not Found';
    }
}

function get_customer_details($customer_id, $to = null, $all = true) {
    $conn = get_fa_db_connection(); // Get the database connection

    if ($to == null) {
        $todate = date("Y-m-d");
    } else {
        $todate = date('Y-m-d', strtotime($to));
    }
    $past1 = 30; // Replace with your own logic if needed
    $past2 = 2 * $past1;

    $sign = "IF(trans.type IN(" . implode(',', [ST_CUSTCREDIT, ST_CUSTPAYMENT, ST_BANKDEPOSIT]) . "), -1, 1)";
    $value = "$sign * (IF(trans.prep_amount, trans.prep_amount,
        ABS(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount)) " . ($all ? '' : "- trans.alloc") . ")";

    $due = "IF (trans.type=" . ST_SALESINVOICE . ", trans.due_date, trans.tran_date)";
    $sql = "SELECT debtor.name, debtor.curr_code, terms.terms,
        debtor.credit_limit, credit_status.dissallow_invoices, credit_status.reason_description,

        SUM(IFNULL($value, 0)) AS Balance,
        SUM(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= 0, $value, 0)) AS Due,
        SUM(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= $past1, $value, 0)) AS Overdue1,
        SUM(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= $past2, $value, 0)) AS Overdue2

        FROM " . TB_PREF . "debtors_master debtor
        LEFT JOIN " . TB_PREF . "debtor_trans trans ON trans.tran_date <= '$todate' AND debtor.debtor_no = trans.debtor_no AND trans.type <> " . ST_CUSTDELIVERY . ",
        " . TB_PREF . "payment_terms terms,
        " . TB_PREF . "credit_status credit_status

        WHERE debtor.payment_terms = terms.terms_indicator
            AND debtor.credit_status = credit_status.id";

    if ($customer_id) {
        $sql .= " AND debtor.debtor_no = " . intval($customer_id); // Sanitize input
    }

    if (!$all) {
        $sql .= " AND ABS(IF(trans.prep_amount, trans.prep_amount, ABS(trans.ov_amount) + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) - trans.alloc) > " . FLOAT_COMP_DELTA;
    }

    $sql .= " GROUP BY
            debtor.name,
            terms.terms,
            terms.days_before_due,
            terms.day_in_following_month,
            debtor.credit_limit,
            credit_status.dissallow_invoices,
            credit_status.reason_description";

    $result = $conn->query($sql);

    // Check for errors
    if ($conn->error) {
        return 'Error fetching customer details: ' . $conn->error;
    }

    $customer_record = $result->fetch_assoc();
    $conn->close(); // Close the connection

    return $customer_record;
}

function get_shipper_by_name($shipper_name) {
    // Establish the database connection
    $conn = get_fa_db_connection();
    if ($conn === false) {
        return false;
    }

    // Ensure the shipper name is safe to use in the query
    $shipper_name = $conn->real_escape_string($shipper_name);

    // Prepare the SQL query to search by shipper_name
    $sql = "SELECT * FROM ".TB_PREF."shippers WHERE shipper_name = '$shipper_name'";

    // Execute the query
    $result = $conn->query($sql);
    if ($result === false) {
        error_log("Query failed: " . $conn->error);
        return false;
    }

    // Fetch the results
    $shipper = $result->fetch_assoc();

    // Close the connection
    $conn->close();

    return $shipper;
}

function get_logged_in_shipper() {
    // Check if the user is logged in
    if (!is_user_logged_in()) {
        return array('error' => 'Please log in to view your delivery history.');
    }

    // Get the current user
    $current_user = wp_get_current_user();

    // Get the shipper name from user meta
    $shipper_name = get_user_meta($current_user->ID, 'shipper_name', true);
    if (empty($shipper_name)) {
        return array('error' => 'Shipper name not found in your profile.');
    }

    // Get the shipper ID by name
    $shipper = get_shipper_by_name($shipper_name);
    if (!$shipper) {
        return array('error' => 'Shipper not found for the given name.');
    }

    return array('shipper' => $shipper);
}

function get_sql_for_customer_inquiry($from, $to, $cust_id = null, $filter = null, $show_voided = 0) {
    // Get the database connection
    $conn = get_fa_db_connection();

    // Format the dates for SQL
    $date_after = date('Y-m-d', strtotime($from));
    $date_to = date('Y-m-d', strtotime($to));

    $sql = "SELECT 
            trans.type, 
            trans.trans_no, 
            trans.order_, 
            trans.reference,
            trans.tran_date, 
            trans.due_date, 
            debtor.name, 
            branch.br_name,
            debtor.curr_code,
            IF(prep_amount, prep_amount, trans.ov_amount + trans.ov_gst + trans.ov_freight 
                + trans.ov_freight_tax + trans.ov_discount) AS TotalAmount, 
            IF(trans.type IN (" . implode(',', array(ST_CUSTCREDIT, ST_CUSTPAYMENT, ST_BANKDEPOSIT)) . "), -1, 1)
                * (IF(prep_amount, prep_amount, trans.ov_amount + trans.ov_gst + trans.ov_freight 
                + trans.ov_freight_tax + trans.ov_discount) - trans.alloc) AS Balance, 
            debtor.debtor_no,
            trans.alloc AS Allocated,
            ((trans.type = " . ST_SALESINVOICE . " OR trans.type = " . ST_JOURNAL . ")
                AND trans.due_date < '" . date('Y-m-d') . "') AS OverDue,
            SUM(line.quantity - line.qty_done) AS Outstanding,
            SUM(line.qty_done) AS HasChild,
            prep_amount
            FROM " . TB_PREF . "debtor_trans AS trans
            LEFT JOIN " . TB_PREF . "debtor_trans_details AS line
                ON trans.trans_no = line.debtor_trans_no AND trans.type = line.debtor_trans_type
            LEFT JOIN " . TB_PREF . "voided AS v
                ON trans.trans_no = v.id AND trans.type = v.type
            LEFT JOIN " . TB_PREF . "audit_trail AS audit ON (trans.type = audit.type AND trans.trans_no = audit.trans_no)
            LEFT JOIN " . TB_PREF . "users AS user ON (audit.user = user.id)
            LEFT JOIN " . TB_PREF . "cust_branch AS branch ON trans.branch_code = branch.branch_code,
            " . TB_PREF . "debtors_master AS debtor
            WHERE debtor.debtor_no = trans.debtor_no";

    if (!$show_voided) {
        $sql .= " AND ISNULL(v.date_) AND (trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) != 0";
    }

    if ($filter === '2') {
        $sql .= " AND ABS(IF(prep_amount, prep_amount, ABS(trans.ov_amount) + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) - trans.alloc) > " . FLOAT_COMP_DELTA;
    } else {
        $sql .= " AND trans.tran_date >= '$date_after'
                  AND trans.tran_date <= '$date_to'";
    }

    if ($cust_id !== null) {
        $sql .= " AND trans.debtor_no = " . $conn->real_escape_string($cust_id);
    }

    if ($filter !== null) {
        if ($filter == '1') {
            $sql .= " AND (trans.type = " . ST_SALESINVOICE . ")";
        } elseif ($filter == '2') {
            $sql .= " AND (trans.type <> " . ST_CUSTDELIVERY . ")";
        } elseif ($filter == '3') {
            $sql .= " AND (trans.type = " . ST_CUSTPAYMENT 
                    . " OR trans.type = " . ST_BANKDEPOSIT . " OR trans.type = " . ST_BANKPAYMENT . ")";
        } elseif ($filter == '4') {
            $sql .= " AND trans.type = " . ST_CUSTCREDIT;
        } elseif ($filter == '5') {
            $sql .= " AND trans.type = " . ST_CUSTDELIVERY;
        } elseif ($filter == '6') {
            $sql .= " AND trans.type = " . ST_JOURNAL;
        }

        if ($filter == '2') {
            $today = date('Y-m-d');
            $sql .= " AND trans.due_date < '$today'
                      AND (ABS(trans.ov_amount) + trans.ov_gst + trans.ov_freight_tax + 
                      trans.ov_freight + trans.ov_discount - trans.alloc > 0)";
        }
    }

$sql .= " GROUP BY trans.trans_no, trans.type, trans.debtor_no ORDER BY tran_date DESC";

    return $sql;
}

function get_sql_for_deliveries($shipper_id = null, $start_date = null, $end_date = null) {
    // Get the database connection
    $conn = get_fa_db_connection();

    // Build shipper condition
    $shipper_condition = $shipper_id !== null 
        ? "trans.ship_via = " . intval($shipper_id) 
        : "1=1";

    // Build date condition
    if ($start_date !== null && $end_date !== null) {
        $date_condition = "trans.tran_date BETWEEN '" . $conn->real_escape_string($start_date) . "' AND '" . $conn->real_escape_string($end_date) . "'";
    } elseif ($start_date !== null) {
        $date_condition = "trans.tran_date = '" . $conn->real_escape_string($start_date) . "'";
    } elseif ($end_date !== null) {
        $date_condition = "trans.tran_date = '" . $conn->real_escape_string($end_date) . "'";
    } else {
        $date_condition = "trans.tran_date = CURDATE()";
    }

    // SQL Query
    $sql = "
        SELECT 
            trans.type, 
            trans.trans_no, 
            trans.debtor_no,
            trans.branch_code,
            trans.reference, 
            trans.tran_date, 
            trans.due_date, 
      comments.memo_ AS trans_memo,
            debtor.name AS customer_name, 
            branch.br_name AS branch_name, 
            branch.br_post_address AS branch_address, 
            debtor.curr_code,
            (trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) AS TotalAmount,
            (trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount - trans.alloc) AS Balance,
            trans.alloc AS Allocated,
            IFNULL(log.delivery_status, 'Pending') AS delivery_status,
            log.shipper_id,
            log.gps_coordinates,
            log.timestamp AS status_timestamp,
            log.customer_acknowledged,
            log.photo_proof,
            log.notes,
            log.payment_received,
            log.payment_amount,
            gps.latitude,
            gps.longitude,
            gps.last_updated AS gps_last_updated,
            persons.phone AS phone1, 
            persons.phone2 AS phone2,
            persons.email AS email
        FROM " . TB_PREF . "debtor_trans AS trans
        LEFT JOIN " . TB_PREF . "cust_branch AS branch 
            ON trans.branch_code = branch.branch_code
        LEFT JOIN " . TB_PREF . "debtors_master AS debtor 
            ON trans.debtor_no = debtor.debtor_no
        LEFT JOIN " . TB_PREF . "route_delivery_log AS log
            ON trans.trans_no = log.transaction_no
            AND trans.type = log.type
        LEFT JOIN " . TB_PREF . "route_delivery_gps AS gps
            ON debtor.debtor_no = gps.debtor_no
            AND branch.branch_code = gps.branch_no
    LEFT JOIN " . TB_PREF . "crm_contacts AS contacts
        ON branch.branch_code = contacts.entity_id
        AND contacts.type = 'cust_branch'
    LEFT JOIN " . TB_PREF . "crm_persons AS persons
        ON contacts.person_id = persons.id
    LEFT JOIN " . TB_PREF . "comments AS comments
          ON trans.trans_no = comments.id
          AND comments.type = " . ST_CUSTDELIVERY . "
        WHERE trans.type = " . ST_CUSTDELIVERY . "
          AND $date_condition 
          AND $shipper_condition
        GROUP BY branch.br_name, trans.tran_date
        ORDER BY branch.br_name ASC, trans.tran_date DESC";

    return $sql;
}

function get_delivery_metrics($shipper_id, $start_date, $end_date) {
    // Start building the SQL query
    $sql = "
        SELECT 
            COUNT(*) AS total_stops, -- Total stops
            SUM(CASE WHEN log.delivery_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_status, -- Delivered
            SUM(CASE WHEN log.delivery_status = 'Rescheduled' THEN 1 ELSE 0 END) AS rescheduled_status, -- Rescheduled
            SUM(CASE WHEN log.delivery_status = 'Failed' THEN 1 ELSE 0 END) AS failed_status, -- Failed
            AVG(stops.diff_minutes) AS avg_time_between_stops, -- Average time between stops
            SUM(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount) AS production -- Total delivery production
        FROM (
            SELECT 
                log.shipper_id,
                log.transaction_no,
                log.type,
                log.delivery_status,
                TIMESTAMPDIFF(
                    MINUTE,
                    LAG(log.status_timestamp) OVER (PARTITION BY DATE(log.status_timestamp), log.shipper_id ORDER BY log.status_timestamp), 
                    log.status_timestamp
                ) AS diff_minutes
            FROM " . TB_PREF . "route_delivery_log AS log
            WHERE log.tran_date BETWEEN '" . addslashes($start_date) . "' AND '" . addslashes($end_date) . "'
              AND log.shipper_id = " . intval($shipper_id) . "
        ) AS stops
        LEFT JOIN " . TB_PREF . "debtor_trans AS trans
            ON trans.type = stops.type 
            AND trans.trans_no = stops.transaction_no
        WHERE stops.diff_minutes IS NOT NULL;
    ";

    // Get the database connection
    $conn = get_fa_db_connection();

    // Execute the query
    $result = $conn->query($sql);

    // Check for errors
    if (!$result) {
        throw new Exception("Database query failed: " . $conn->error);
    }

    // Fetch the results as an associative array
    $metrics = $result->fetch_assoc();

    // Close the database connection
    $conn->close();

    return $metrics; // Return the metrics
}


function fetch_customer_crm_info($debtor_no) {
    // Connect to the CRM database
    $conn = get_fa_db_connection(); // Ensure this function is defined to connect to the appropriate database

    // Prepare SQL query to fetch customer CRM data
    $sql = "SELECT p.name, p.name2, p.address, p.phone, p.phone2, p.email, r.id AS contact_id 
            FROM 2_crm_persons p
            JOIN 2_crm_contacts r ON p.id = r.person_id
            JOIN 2_crm_categories t ON r.type = t.type AND r.action = t.action
            WHERE t.type = 'customer' AND r.entity_id = '" . $conn->real_escape_string($debtor_no) . "' 
            ORDER BY contact_id LIMIT 1";

    // Execute the query
    $result = $conn->query($sql);

    // Check for errors
    if (!$result || $result->num_rows === 0) {
        return false; // Return false if no account information found
    }

    // Fetch the row from the result
    $row = $result->fetch_assoc();

    // Close the database connection
    $conn->close();

    return $row; // Return the row data
}

function get_deliveries_due($start_date, $end_date) {
    // Get Front Accounting database connection
    $conn = get_fa_db_connection();

    // Define the table name
    $table_name = TB_PREF . 'route_delivery_recurrent';

    // Prepare the SQL query
    $sql = "
        SELECT
            `id`,
            `debtor_no`,
            `order_no`,
            `description`,
            `start_date`,
            `end_date`,
            `recurrence_type`,
            `custom_interval`,
            `days_of_week`,
            `day_of_month`,
            `month_of_year`,
            `week_of_month`,
            `time_of_day`
        FROM $table_name
        WHERE
            `is_active` = 1 AND
            (
                (
                    `recurrence_type` IS NULL AND `start_date` BETWEEN ? AND ?
                ) OR
                (
                    `recurrence_type` = 'daily' AND
                    `start_date` <= ? AND
                    ( `end_date` IS NULL OR `end_date` >= ? )
                ) OR
                (
                    `recurrence_type` = 'weekly' AND
                    `start_date` <= ? AND
                    ( `end_date` IS NULL OR `end_date` >= ? )
                ) OR
                (
                    `recurrence_type` = 'monthly' AND
                    `start_date` <= ? AND
                    ( `end_date` IS NULL OR `end_date` >= ? )
                ) OR
                (
                    `recurrence_type` = 'yearly' AND
                    `start_date` <= ? AND
                    ( `end_date` IS NULL OR `end_date` >= ? )
                )
            )
    ";

    // Prepare the statement
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        return 'Error preparing query: ' . $conn->error;
    }

    // Bind parameters
    $stmt->bind_param('ssssssssss', $start_date, $end_date, $end_date, $start_date, $end_date, $start_date, $end_date, $start_date, $end_date, $start_date);

    // Execute the query
    if (!$stmt->execute()) {
        return 'Error executing query: ' . $stmt->error;
    }

    // Fetch results
    $result = $stmt->get_result();
    $deliveries = [];
    while ($row = $result->fetch_assoc()) {
        // Process recurrence dynamically
        $due_dates = calculate_due_dates($row, $start_date, $end_date);
        foreach ($due_dates as $due_date) {
            $deliveries[] = array_merge($row, ['due_date' => $due_date]);
        }
    }

    return $deliveries;
}


