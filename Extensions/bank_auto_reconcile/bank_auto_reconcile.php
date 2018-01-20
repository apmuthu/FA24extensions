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


function show_balance($total_new, $total_miss, $reconciled)
{
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

function get_bank_transaction($account, $amount, $check, $current)
{
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

function get_similar_bank_transaction($account, $search)
{
    $sql = "SELECT b.*, gl.account, cm.account_name FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type AND c.id = b.trans_no
            LEFT JOIN ".TB_PREF."gl_trans gl
            ON b.type=gl.type AND b.trans_no=gl.type_no
            LEFT JOIN ".TB_PREF."chart_master cm
            ON gl.account=cm.account_code
            WHERE b.bank_act = '$account'
            AND gl.amount > 0
            AND LOCATE('$search', c.memo_) != 0
            ORDER BY b.id DESC LIMIT 1";
    return db_query($sql,"The transactions for '$account' could not be retrieved");
}

function auto_reconcile($current)
{
    $newdate=$_POST['reconcile_date'];
    $reconcile_value =  ("'".date2sql($_POST['reconcile_date']) ."'");
    foreach ($current as $key => $value) {
/*
        update_reconciled_values($key, $reconcile_value, $newdate, input_num('end_balance'), $_POST['bank_account']);

        $sql = "SELECT b.type, b.trans_no, memo_ FROM ".TB_PREF."bank_trans b
            LEFT JOIN ".TB_PREF."comments c
            ON b.type=c.type and c.id = b.trans_no
            WHERE id = '$key'";
        $result = db_query($sql,"The transaction for '$id' could not be retrieved");
        $row = db_fetch($result);
        add_comments($row['type'], $row['tran_no'], $reconcile_value, $row['memo_'] + " " + $value);
*/
        display_notification("Updated $key");
    }
}

$js = "";
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

                $amount = $data[1];
                $checkno = $data[3];
                if ($i == 1)
                    $comment = $data[4];
                else
                    $comment = "";

                 if (($checkno != "" && $i == 1)
                    || ($checkno == "" && $i == 0))
                    continue;

                $result = get_bank_transaction($_POST['bank_account'], $amount, $checkno, $current);
                $row = db_fetch($result);
                if ($row[0] == 0) {

        // search for recurrent transactions for auto payments

                    if ($checkno == ""
                        && $comment != "") {
                        $result = get_similar_bank_transaction($_POST['bank_account'], substr($comment, 0, 12));

        // only simple (non-split) recurrent transactions can be auto-reconciled

                        if (db_num_rows($result) == 1) {
                            $sim = db_fetch($result);
                            display_notification("$data[0]:$data[1]:$data[3]:$data[4] will be created using account " . $sim['account'] . " " . $sim['account_name']);
                            $auto[$sim['id']] = $comment;
                            $total_current += $amount;
                            $total += $amount;
                            continue;
                        }
                    }

                    display_notification("$data[0]:$data[1]:$data[3]:$data[4]");
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
            else
                auto_reconcile($current);
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
    label_row('CSV Bank Statement Import File', "<input type='file' id='imp' name='imp'>");

    end_table(1);

    submit_center('import', "Auto Reconcile");

    end_form();

end_page();
