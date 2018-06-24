<?php
namespace FAAPI;

include_once (FA_ROOT . "/purchasing/includes/db/supp_trans_db.inc");

class Purchases {
    // Get Items
    public function get($rest) {
        $req = $rest->request();

        $page = $req->get("page");

        $sql = get_sql_for_supplier_inquiry(ALL_TEXT, '1/1/0000', '1/1/9999');
        $result = db_query($sql, 'oops');
        
        $body = array();
        while ($row = db_fetch_assoc($result)) {
            $body[] = $row;
        }
        
        api_success_response(json_encode($body));
    }
    
    public function getByType($rest, $trans_type) {
        $req = $rest->request();

        $page = $req->get("page");

        $sql = get_sql_for_supplier_inquiry(ALL_TEXT, '0000-01-01', '9999-12-31');
        $result = db_query($sql, 'oops');
        
//         if ($page == null) {
//             sales_all($trans_type);
//         } else {
//             // If page = 1 the value will be 0, if page = 2 the value will be 1, ...
//             $from = -- $page * RESULTS_PER_PAGE;
//             sales_all($trans_type, $from);
//         }
    }

    // Get Specific Item by Id
    public function getById($rest, $trans_no, $trans_type) {
        include_once (API_ROOT . "/purchases.inc");
        sales_get($trans_no, $trans_type);
    }

    // Add Item
    public function post($rest) {
        include_once (API_ROOT . "/purchases.inc");
        sales_add();
    }

    // Edit Specific Item
    public function put($rest, $trans_no, $trans_type) {
        include_once (API_ROOT . "/purchases.inc");
        sales_edit($trans_no, $trans_type);
    }

    // Delete Specific Item
    public function delete($rest, $branch_id, $uuid) {
        include_once (API_ROOT . "/purchases.inc");
        sales_cancel($branch_id, $uuid);
    }
}
