<?php

function get_all_branches_for_batch() {
    $sql = "SELECT b.branch_code, b.debtor_no, b.br_post_address, c.name AS customer_name, b.br_name
            FROM ".TB_PREF."cust_branch b
            JOIN ".TB_PREF."debtors_master c ON b.debtor_no = c.debtor_no";
    return db_query($sql);
}

function update_branch_address($branch_code, $br_post_address) {
    $sql = "UPDATE ".TB_PREF."cust_branch 
            SET br_post_address = ".db_escape($br_post_address)."
            WHERE branch_code = ".db_escape($branch_code);
    db_query($sql, "The branch address could not be updated");
}

