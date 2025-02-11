<?php
function add_fa_customer($CustName, $cust_ref, $address, $tax_id, $curr_code,
    $dimension_id, $dimension2_id, $credit_status, $payment_terms, $discount, $pymt_discount, 
    $credit_limit, $sales_type, $notes)
{
    // Get the database connection
    $conn = get_fa_db_connection();

    // Escape the string inputs to prevent SQL injection
    $CustName = $conn->real_escape_string($CustName);
    $cust_ref = $conn->real_escape_string($cust_ref);
    $address = $conn->real_escape_string($address);
    $tax_id = $conn->real_escape_string($tax_id);
    $curr_code = $conn->real_escape_string($curr_code);
    $notes = $conn->real_escape_string($notes);

    // Make sure numerical values are not enclosed in quotes
    $dimension_id = (int)$dimension_id;
    $dimension2_id = (int)$dimension2_id;
    $credit_status = (int)$credit_status;
    $payment_terms = isset($payment_terms) ? (int)$payment_terms : 'NULL'; // Allow NULL for payment_terms
    $sales_type = (int)$sales_type;
    $discount = (float)$discount;
    $pymt_discount = (float)$pymt_discount;
    $credit_limit = (float)$credit_limit;

    // Prepare the SQL statement with proper data types
    $sql = "INSERT INTO ".TB_PREF."debtors_master (
        name, debtor_ref, address, tax_id, dimension_id, dimension2_id, curr_code, 
        credit_status, payment_terms, discount, pymt_discount, credit_limit, sales_type, notes
    ) VALUES (
        '$CustName', '$cust_ref', '$address', '$tax_id', $dimension_id, $dimension2_id, '$curr_code', 
        $credit_status, $payment_terms, $discount, $pymt_discount, $credit_limit, $sales_type, '$notes'
    )";

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        // Retrieve and return the auto-incremented debtor_no
        $debtor_no = $conn->insert_id;
        $conn->close();
        return $debtor_no;
    } else {
        // Handle the error and return null on failure
        $conn->close();
        return null;
    }

    // Close the connection
    $conn->close();
}

function add_fa_branch($customer_id, $br_name, $br_ref, $br_address, $salesman, $area, 
    $tax_group_id, $sales_account, $sales_discount_account, $receivables_account, 
    $payment_discount_account, $default_location, $br_post_address, $group_no,
    $default_ship_via, $notes, $bank_account)
{
    // Get the database connection
    $conn = get_fa_db_connection();

    // Escape the string inputs to prevent SQL injection
    $br_name = $conn->real_escape_string($br_name);
    $br_ref = $conn->real_escape_string($br_ref);
    $br_address = $conn->real_escape_string($br_address);
    $sales_account = $conn->real_escape_string($sales_account);
    $sales_discount_account = $conn->real_escape_string($sales_discount_account);
    $receivables_account = $conn->real_escape_string($receivables_account);
    $payment_discount_account = $conn->real_escape_string($payment_discount_account);
    $default_location = $conn->real_escape_string($default_location);
    $br_post_address = $conn->real_escape_string($br_post_address);
    $notes = $conn->real_escape_string($notes);
    $bank_account = isset($bank_account) ? $conn->real_escape_string($bank_account) : 'NULL'; // Allow NULL for bank_account

    // Make sure numerical values are not enclosed in quotes
    $customer_id = (int)$customer_id;
    $salesman = (int)$salesman;
    $area = isset($area) ? (int)$area : 'NULL'; // Allow NULL for area
    $tax_group_id = isset($tax_group_id) ? (int)$tax_group_id : 'NULL'; // Allow NULL for tax_group_id
    $group_no = (int)$group_no;
    $default_ship_via = (int)$default_ship_via;

    // Prepare the SQL statement with proper data types
    $sql = "INSERT INTO ".TB_PREF."cust_branch (
        debtor_no, br_name, branch_ref, br_address, salesman, area, tax_group_id, 
        sales_account, receivables_account, payment_discount_account, sales_discount_account, 
        default_location, br_post_address, group_no, default_ship_via, notes, bank_account
    ) VALUES (
        $customer_id, '$br_name', '$br_ref', '$br_address', $salesman, $area, $tax_group_id, 
        '$sales_account', '$receivables_account', '$payment_discount_account', '$sales_discount_account', 
        '$default_location', '$br_post_address', $group_no, $default_ship_via, '$notes', $bank_account
    )";

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        // Retrieve and return the auto-incremented branch_code
        $branch_code = $conn->insert_id;
        $conn->close();
        return $branch_code;
    } else {
        // Handle the error and return null on failure
        $conn->close();
        return null;
    }
    // Close the connection
    $conn->close();
}

function add_fa_crm_person($ref, $name, $name2, $address, $phone, $phone2, $fax, $email, $lang, $notes, $cat_ids=null, $entity=null)
{
    // Get the database connection
    $conn = get_fa_db_connection();

    // Escape the string inputs to prevent SQL injection
    $ref = $conn->real_escape_string($ref);
    $name = $conn->real_escape_string($name);
    $name2 = isset($name2) ? $conn->real_escape_string($name2) : 'NULL';
    $address = isset($address) ? $conn->real_escape_string($address) : 'NULL';
    $phone = isset($phone) ? $conn->real_escape_string($phone) : 'NULL';
    $phone2 = isset($phone2) ? $conn->real_escape_string($phone2) : 'NULL';
    $fax = isset($fax) ? $conn->real_escape_string($fax) : 'NULL';
    $email = isset($email) ? $conn->real_escape_string($email) : 'NULL';
    $lang = isset($lang) ? "'".$conn->real_escape_string($lang)."'" : 'NULL'; // Quotes for char(5) field
    $notes = $conn->real_escape_string($notes);

    // Prepare the SQL statement with proper handling for optional fields
    $sql = "INSERT INTO ".TB_PREF."crm_persons (
        ref, name, name2, address, phone, phone2, fax, email, lang, notes
    ) VALUES (
        '$ref', '$name', 
        " . ($name2 === 'NULL' ? "NULL" : "'$name2'") . ", 
        " . ($address === 'NULL' ? "NULL" : "'$address'") . ", 
        " . ($phone === 'NULL' ? "NULL" : "'$phone'") . ", 
        " . ($phone2 === 'NULL' ? "NULL" : "'$phone2'") . ", 
        " . ($fax === 'NULL' ? "NULL" : "'$fax'") . ", 
        " . ($email === 'NULL' ? "NULL" : "'$email'") . ", 
        $lang, '$notes'
    )";

    // Begin transaction
    $conn->begin_transaction();

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        // Get the last inserted ID
        $id = $conn->insert_id;

        // Check if there are categories to update
        if ($cat_ids) {
            if (!update_person_contacts($id, $cat_ids, $entity)) {
                $conn->rollback();
                return null;
            }
        }

        // Commit the transaction
        $conn->commit();
        return $id;
    } else {
        // Handle the error
        $conn->rollback();
        return null;
    }
}


function add_fa_crm_contact($type, $action, $entity_id, $person_id)
{
    // Get the database connection
    $conn = get_fa_db_connection();

    // Escape the inputs to prevent SQL injection
    $type = $conn->real_escape_string($type);
    $action = $conn->real_escape_string($action);
    $person_id = intval($person_id);  // Ensure person_id is an integer
    $entity_id = isset($entity_id) ? "'".$conn->real_escape_string($entity_id)."'" : 'NULL';  // Handle NULL for entity_id

    // Prepare the SQL statement
    $sql = "INSERT INTO ".TB_PREF."crm_contacts (person_id, type, action, entity_id)
            VALUES ($person_id, '$type', '$action', $entity_id)";

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        return $conn->insert_id; // Return the ID of the newly inserted contact
    } else {
        // Handle the error
        echo "Error: " . $sql . "<br>" . $conn->error;
        return null; // Return null on failure
    }
}

