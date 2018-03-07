<?php
/**********************************************
Author: Joe Hunt
Author: Tom Moulton - added Export of many types and import of the same
Name: Import of CSV formatted items
Free software under GNU GPL
***********************************************/
$page_security = 'SA_BANKAUTORECONCILE';
$path_to_root="../..";

include($path_to_root . "/includes/session.inc");

add_access_extensions();

include_once($path_to_root . "/includes/ui.inc");

function csv_format_list($name, $selected_id=null, $submit_on_change=false) {
    $items = array();
    $items['0'] =  _("A: Date, Amount, Unused, Check Number, Comment");
    $items['1'] =  _("B: Unused, Date, Unused, Comment, Amount");

    return array_selector($name, $selected_id, $items,
        array(
              'select_submit'=> $submit_on_change,
              'async' => false
        )
    ); // FIX?
}

function csv_format_list_cells($label, $name, $selected_id=null, $submit_on_change=false) {
    if ($label != null)
        echo "<td>$label</td>\n";
    echo "<td>";
    echo csv_format_list($name, $selected_id, $submit_on_change);
    echo "</td>\n";
}

function csv_format_list_row($label, $name, $selected_id=null, $submit_on_change=false) {
    echo "<tr><td class='label'>$label</td>";
    csv_format_list_cells(null, $name, $selected_id, $submit_on_change);
    echo "</tr>\n";
}

function show_balance($total_new, $total_miss, $reconciled) {
    $result = get_max_reconciled($_POST['reconcile_date'], $_POST['bank_account']);

    if ($row = db_fetch($result)) {
        $total = $row["total"];
        $_POST["reconciled"] = price_format($row["end_balance"]-$row["beg_balance"]);
        if (!isset($_POST["beg_balance"])) { // new selected account/statement
            $_POST["last_date"] = sql2date($row["last_date"]);
            $_POST["beg_balance"] = price_format($row["beg_balance"]);
        }
        echo "<hr>";

        div_start('summary');

        start_table(TABLESTYLE);
        $th = array(_("Reconcile Date"), _("Beginning<br>Balance"), 
            _("Ending<br>Balance"), _("Current<br>Balance"),_("Reconciled<br>Amount"), _("Difference"));
        table_header($th);
        start_row();

        echo "<td>" . $_POST['reconcile_date'] . "</td>";
        echo "<td>" . $_POST['beg_balance'] . "</td>";
        $end_balance = user_numeric($_POST['beg_balance']);
        $end_balance += $total_new;
        $_POST["end_balance"] = price_format($end_balance);

        amount_cell($end_balance);
        amount_cell($total);
        amount_cell($reconciled);
        amount_cell($total_miss, false, '', "difference");

        end_row();
        end_table();
        div_end();
        echo "<hr>";
    }
}

function get_bank_transaction($account, $amount, $check, $current) {
    $sql = "SELECT b.* FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type and c.id = b.trans_no
            WHERE b.bank_act = '$account'
            AND amount = '$amount'
            AND ISNULL(b.reconciled)";
    if ($check != '')
        $sql .= " AND LOCATE('$check', memo_) != 0";
    foreach ($current as $key => $value)
        $sql .= " AND b.id != $key ";
    // display_notification($sql);

    return db_query($sql,"The transactions for '$account' could not be retrieved");
}

function get_similar_bank_transaction($account, $search, $sign) {
    $bank_gl_account=get_bank_gl_account($account);
    $sql = "SELECT b.*, gl.account, cm.account_name, gl.dimension_id as dim1, gl.dimension2_id as dim2 FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type AND c.id = b.trans_no
            LEFT JOIN ".TB_PREF."gl_trans gl
            ON b.type=gl.type AND b.trans_no=gl.type_no
            LEFT JOIN ".TB_PREF."chart_master cm
            ON gl.account=cm.account_code
            WHERE b.bank_act = '$account'
            AND gl.account != '$bank_gl_account'
            AND SIGN(b.amount) = $sign
            AND (b.type != '" . ST_JOURNAL .
            "') AND LOCATE('$search', c.memo_) != 0
            ORDER BY b.id DESC LIMIT 1";
// display_notification($sql);
    return db_query($sql,"The transactions for '$account' could not be retrieved");
}

function get_similar_bank_trans($id, $bank_account_gl_code) {
    $sql = "SELECT b.*, gl.account, cm.account_name, gl.dimension_id as dim1, gl.dimension2_id as dim2 FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type AND c.id = b.trans_no
            LEFT JOIN ".TB_PREF."gl_trans gl
            ON b.type=gl.type AND b.trans_no=gl.type_no
            LEFT JOIN ".TB_PREF."chart_master cm
            ON gl.account=cm.account_code
            WHERE b.id = '$id'
            AND (b.type != '" . ST_JOURNAL .
                "') AND gl.account != $bank_account_gl_code
            GROUP BY b.id";
    return db_query($sql,"The transaction for '$id' could not be retrieved");
}

function auto_reconcile($current)
{
    $newdate=$_POST['reconcile_date'];
    $reconcile_value =  ("'".date2sql($_POST['reconcile_date']) ."'");
    foreach ($current as $key => $comment) {
        update_reconciled_values($key, $reconcile_value, $newdate, input_num('end_balance'), $_POST['bank_account']);

        $sql = "SELECT b.type, b.trans_no, memo_ FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type and c.id = b.trans_no
            WHERE b.id = '$key'";
        $result = db_query($sql,"The transaction for '$key' could not be retrieved");
        $row = db_fetch($result);
        update_comments($row['type'], $row['trans_no'], null, $row['memo_'] . " " . $comment);
    }
    display_notification("Success");
}

function customer_exist($person_id) {
    $sql = "SELECT debtor_no FROM " . TB_PREF . "debtors_master WHERE debtor_no=" . db_escape($person_id);
    $result = db_query($sql, _("Could not query debtors master table"));
    if (db_num_rows($result) > 0) {
        return true;
    } else {
        return false;
    }
}

function customer_name($person_id) {
    $sql = "SELECT name FROM " . TB_PREF . "debtors_master WHERE debtor_no=" . db_escape($person_id);
    $result = db_query($sql, _("Could not query debtors master table"));
    $row = db_fetch($result);
    $custname = $row['name'];
    if (!$row) {
        display_error(_("Person id $person_id not found"));
    }
    return $custname;
}

function bank_inclusive_tax($type, $reference, $date, $bank_account, $bank_account_gl_code, $curEntryId, $code, $dim1, $dim2, $memo, $amt, $person_type_id, $person_id, $BranchNo) { // extra inclusive of tax column in csv

    $inclusive_amt = $amt;
    $taxamt = 0;

    add_bank_trans($type, $curEntryId, $bank_account, $reference, $date, $inclusive_amt, $person_type_id, $person_id, $currency = "", $err_msg = "", $rate = 0);
    $id = db_insert_id();

    display_notification_centered(_("Added to table 'bank_trans': $curEntryId, $bank_account, $reference, $date, $inclusive_amt, $person_type_id, $person_id"));

    add_gl_trans($type, $curEntryId, $date, $code, $dim1, $dim2, $memo, -$inclusive_amt, $currency = null, $person_type_id, $person_id, $err_msg = "", $rate = 0);
    add_audit_trail($type, $curEntryId, $date);
    display_notification_centered(_("Added to table 'gl_trans Credit:': $curEntryId, $date, $code, $dim1, $dim2, -$inclusive_amt, $memo, $person_type_id, $person_id"));

    if ($person_type_id == PT_CUSTOMER) {
        write_customer_trans($type, $curEntryId, $person_id, $BranchNo, $date, $reference, $inclusive_amt);
        if ($inclusive_amt > 0)
            display_notification_centered(_("Added to table 'debtor_trans Credit: Payment from customer': $inclusive_amt"));
        else
            display_notification_centered(_("Added to table 'debtor_trans Debit:' Customer over-payment reimbursed -$inclusive_amt"));
    }
    if ($person_type_id == PT_SUPPLIER) {
        write_supp_trans($type, $curEntryId, $person_id, $date, $due_date = "", $reference, $supp_reference = "", $inclusive_amt, $amount_tax = 0, $discount = 0);
        if ($inclusive_amt < 0)
            display_notification_centered(_("Added to table 'supp_trans' Debit: Supplier paid -$inclusive_amt"));
        else
            display_notification_centered(_("Added to table 'supp_trans Credit: Our over-payment amount reimbursed': $inclusive_amt"));
    }

    add_gl_trans($type, $curEntryId, $date, $bank_account_gl_code, $dim1, $dim2, $memo, $inclusive_amt, $currency = null, $person_type_id, $person_id, $err_msg = "", $rate = 0);
    add_audit_trail($type, $curEntryId, $date);
    display_notification_centered(_("Added to table 'gl_trans' Debit bank account: $curEntryId, $date, $bank_account_gl_code, $dim1, $dim2, $inclusive_amt, $memo, $person_type_id, $person_id"));

    return $id;
}

function auto_create($current) {
    global $Refs;

    $newdate=$_POST['reconcile_date'];
    $reconcile_value =  ("'".date2sql($_POST['reconcile_date']) ."'");
    $bank_account_gl_code = get_bank_gl_account($_POST['bank_account']);
    $BranchNo = "";

    foreach ($current as $key => $data) {
        $sim_id = $data[0];
        $amt = $data[1];
        $comment = $data[2];
        $result = get_similar_bank_trans($sim_id, $bank_account_gl_code);

// only simple (non-split) recurrent transactions can be auto-created

        if (db_num_rows($result) == 1) {
            $sim = db_fetch($result);
            $reference = $Refs->get_next($sim['type'], null, array('date' => $_POST['reconcile_date']));
            $trans_no = get_next_trans_no($sim['type']);

            $id = bank_inclusive_tax($sim['type'], $reference, $newdate, $_POST['bank_account'], $bank_account_gl_code, $trans_no, $sim['account'], $sim['dim1'], $sim['dim2'], "", $amt, $sim['person_type_id'], $sim['person_id'], $BranchNo);

            update_reconciled_values($id, $reconcile_value, $newdate, input_num('end_balance'), $_POST['bank_account']);

            add_comments($sim['type'], $trans_no, $_POST['reconcile_date'], $comment);

        } else
            display_error("$id $amt not found");
    }
}

function my_offset($text) {
    preg_match('/ \d/', $text, $m, PREG_OFFSET_CAPTURE);
    if (sizeof($m))
        return $m[0][1];

    preg_match('/ #/', $text, $m, PREG_OFFSET_CAPTURE);
    if (sizeof($m))
        return $m[0][1];

    // the case when there's no numbers in the string
    return strlen($text);
}

function sign( $number ) {
    return ( $number > 0 ) ? 1 : ( ( $number < 0 ) ? -1 : 0 );
} 

$js = "";
$js .= get_js_date_picker();
if ($SysPrefs->use_popup_windows)
    $js .= get_js_open_window(800, 500);
$help_context="Bank Auto Reconcile";
page(_($help_context), false, false, "", $js);


if (isset($_POST['import'])) {
    if (isset($_FILES['imp']) && $_FILES['imp']['name'] != '') {
        $current = array();
        $auto = array();
        $total_miss = 0;
        $total_current = 0;
        $total = 0;

        // do checks first, then auto deducts
        for ($i=0; $i < 2; $i++) {
            $filename = $_FILES['imp']['tmp_name'];
            $fp = @fopen($filename, "r");
            if (!$fp)
                die("can not open file $filename");

            while ($data = fgetcsv($fp, 4096, ",")) {
                if ($data[0] == null)   // blank line
                    continue;

                if ($_POST['csv_format'] == 0) {
                    $date = $data[0];
                    $amount = $data[1];
                    $checkno = $data[3];
                    $comment = $data[4];
                } else {
                    $date = $data[2];
                    $amount = $data[4];
                    $comment = $data[3];
                    $checkno = "";
                }

                if (($checkno != "" && $i == 1)
                    || ($checkno == "" && $i == 0))
                    continue;

                $result = get_bank_transaction($_POST['bank_account'], $amount, $checkno, $current);
                $row = db_fetch($result);
                if ($row[0] == 0) {

        // search for recurrent transactions for auto payments

                    if ($checkno == ""
                        && $comment != "") {
                        $result = get_similar_bank_transaction($_POST['bank_account'], substr($comment, 0, my_offset($comment)), sign($amount));

        // only simple (non-split) recurrent transactions can be auto-created

                        if (db_num_rows($result) == 1) {
                            $sim = db_fetch($result);
                            display_notification("$date:$amount:$checkno:$comment will be created using account " . $sim['account'] . " " . $sim['account_name'] . " dimension " . $sim['dim1']); 
                            $auto[] = array($sim['id'], $amount, $comment);
                            $total_current += $amount;
                            $total += $amount;
                            continue;
                        }
                    }

                    display_notification("$date : $amount for $comment");
                    $total_miss += $amount;
                    $total += $amount;
                } else {
                    $current[$row['id']] = $comment;
                    $total_current += $row['amount'];
                    $total += $row['amount'];
                }
            } // while
            @fclose($fp);
        }
        show_balance($total, $total_miss, $total_current);

        if ($total_miss == 0) {
            $trial = (isset($_POST['trial']) ? $_POST['trial'] : false);
            if ($trial == true)
                display_notification("Success.  Unclick trial run and rerun to auto reconcile.");
            else {
                auto_create($auto);
                auto_reconcile($current);
            }
        }

    } else
        display_error("No CSV file selected");
}

start_form(true);
start_table(TABLESTYLE2, "width=60%");

table_section_title("Bank Auto Reconcile");
bank_accounts_list_row("Bank Account", 'bank_account');
check_row("Trial Run", 'trial', 1);
date_row("Reconciliation Date:", 'reconcile_date');
csv_format_list_row("CSV Format", 'csv_format');
label_row('CSV Bank Statement Import File', "<input type='file' id='imp' name='imp'>");

end_table(1);

submit_center('import', "Auto Reconcile");

end_form();

end_page();
