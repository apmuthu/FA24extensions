<?php

// Fetch geocode information for a specific customer and branch
function get_geocode_info($debtor_no, $branch_no) {
  $sql ="SELECT * FROM ".TB_PREF."route_delivery_gps 
    WHERE branch_no = ".db_escape($branch_no)."
      AND  debtor_no = ".db_escape($debtor_no);

    return db_fetch(db_query($sql, "Could not retrieve geocode information"));
}

function get_geocode_address($debtor_no, $branch_no) {
  $sql ="SELECT branch.br_post_address, branch.br_name,
         debtor.name
         FROM ".TB_PREF."cust_branch AS branch
         JOIN ".TB_PREF."debtors_master AS debtor 
            ON branch.debtor_no = debtor.debtor_no
         WHERE branch.branch_code = ".db_escape($branch_no)."
            AND branch.debtor_no = ".db_escape($debtor_no);

    return db_fetch(db_query($sql, "Could not retrieve address information"));

}

// Add or update geocode information for a customer branch
function update_geocode_info($debtor_no, $branch_no, $latitude, $longitude) {
    $sql = "INSERT INTO ".TB_PREF."route_delivery_gps (debtor_no, branch_no, latitude, longitude, last_updated, created_at)
            VALUES (".db_escape($debtor_no).", ".db_escape($branch_no).", ".db_escape($latitude).", ".db_escape($longitude).", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            ON DUPLICATE KEY UPDATE 
                latitude = VALUES(latitude),
                longitude = VALUES(longitude),
                last_updated = CURRENT_TIMESTAMP";
    db_query($sql, "Could not update geocode information");
}

// Delete geocode information for a specific customer branch
function delete_geocode_info($debtor_no, $branch_no) {
    $sql = "DELETE FROM ".TB_PREF."route_delivery_gps 
            WHERE debtor_no = ".db_escape($debtor_no)." AND branch_no = ".db_escape($branch_no);
    db_query($sql, "Could not delete geocode information");
}

