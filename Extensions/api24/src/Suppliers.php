<?php
namespace FAAPI;

$path_to_root = "../..";

include_once ($path_to_root . "/purchasing/includes/db/suppliers_db.inc");
include_once ($path_to_root . "/includes/db/crm_contacts_db.inc");

class Suppliers {
	// Get Suppliers
	public function get($rest) {
		$req = $rest->request();
		$page = $req->get("page");

		$this->supplier_all($page);
	}

	// Get Specific Supplier by Id
	public function getById($rest, $id) {
		$sup = get_supplier($id);
		api_success_response(json_encode(api_ensureAssociativeArray($sup)));
	}

	// Add Supplier
	public function post($rest) {
		$req = $rest->request();
		$info = $req->post();

		// Validate Required Fields
		if (! isset($info['supp_name'])) {
			api_error(412, 'Supplier Name is required [supp_name]');
		}
		if (! isset($info['supp_ref'])) {
			api_error(412, 'Supplier Reference is required [supp_ref]');
		}
		if (! isset($info['address'])) {
			api_error(412, 'Address is required [address]');
		}
		if (! isset($info['supp_address'])) {
			api_error(412, 'Supplier Address 2 is required [supp_address]');
		}
		if (! isset($info['gst_no'])) {
			api_error(412, 'GST No. is required [gst_no]');
		}
		if (! isset($info['supp_account_no'])) {
			api_error(412, 'Supplier Account Number is required [supp_account_no]');
		}
		if (! isset($info['bank_account'])) {
			api_error(412, 'Bank Account is required [bank_account]');
		}
		if (! isset($info['credit_limit'])) {
			api_error(412, 'Credit Limir is required [credit_limit]');
		}
		if (! isset($info['curr_code'])) {
			api_error(412, 'Currency Code is required [curr_code]');
		}
		if (! isset($info['payment_terms'])) {
			api_error(412, 'Payment Terms is required [payment_terms]');
		}
		if (! isset($info['payable_account'])) {
			api_error(412, 'Payable Account is required [payable_account]');
		}
		if (! isset($info['purchase_account'])) {
			api_error(412, 'Purchase Account is required [purchase_account]');
		}
		if (! isset($info['payment_discount_account'])) {
			api_error(412, 'Payment Discount Account is required [payment_discount]');
		}
		if (! isset($info['tax_group_id'])) {
			api_error(412, 'Tax Group Id is required [tax_group_id]');
		}
		if (! isset($info['tax_included'])) {
			api_error(412, 'Tax Included is required [tax_included]');
		}
		if (! isset($info['website'])) {
			$info['website'] = '';
		}
		if (! isset($info['notes'])) {
			$info['notes'] = '';
		}

		/*
		 * $supp_name, $supp_ref, $address, $supp_address, $gst_no, $website, $supp_account_no, $bank_account,
		 * $credit_limit, $dimension_id, $dimension2_id, $curr_code, $payment_terms, $payable_account,
		 * $purchase_account, $payment_discount_account, $notes, $tax_group_id, $tax_included
		 */
		add_supplier($info['supp_name'], $info['supp_ref'], $info['address'], $info['supp_address'], $info['gst_no'], $info['website'], $info['supp_account_no'], $info['bank_account'], $info['credit_limit'], 0, 0, $info['curr_code'], $info['payment_terms'], $info['payable_account'], $info['purchase_account'], $info['payment_discount_account'], $info['notes'], $info['tax_group_id'], $info['tax_included']);

		$id = db_insert_id();
		$sup = get_supplier($id);

		if ($sup != null) {
			api_create_response(json_encode($sup));
		} else {
			api_error(500, 'Could Not Save to Database');
		}
	}

	// Edit Specific Supplier
	public function put($rest, $id) {
		$req = $rest->request();
		$info = $req->post();

		$sup = get_supplier($id);
		if ($sup == null) {
			api_error(400, 'Invalid Supplier ID');
		}

		// Validate Required Fields
		if (! isset($info['supp_name'])) {
			api_error(412, 'Supplier Name is required [supp_name]');
		}
		if (! isset($info['supp_ref'])) {
			api_error(412, 'Supplier Reference is required [supp_ref]');
		}
		if (! isset($info['address'])) {
			api_error(412, 'Address is required [address]');
		}
		if (! isset($info['supp_address'])) {
			api_error(412, 'Supplier Address 2 is required [supp_address]');
		}
		if (! isset($info['gst_no'])) {
			api_error(412, 'GST No. is required [gst_no]');
		}
		if (! isset($info['supp_account_no'])) {
			api_error(412, 'Supplier Account Number is required [supp_account_no]');
		}
		if (! isset($info['bank_account'])) {
			api_error(412, 'Bank Account is required [bank_account]');
		}
		if (! isset($info['credit_limit'])) {
			api_error(412, 'Credit Limir is required [credit_limit]');
		}
		if (! isset($info['curr_code'])) {
			api_error(412, 'Currency Code is required [curr_code]');
		}
		if (! isset($info['payment_terms'])) {
			api_error(412, 'Payment Terms is required [payment_terms]');
		}
		if (! isset($info['payable_account'])) {
			api_error(412, 'Payable Account is required [payable_account]');
		}
		if (! isset($info['purchase_account'])) {
			api_error(412, 'Purchase Account is required [purchase_account]');
		}
		if (! isset($info['payment_discount_account'])) {
			api_error(412, 'Payment Discount Account is required [payment_discount]');
		}
		if (! isset($info['tax_group_id'])) {
			api_error(412, 'Tax Group Id is required [tax_group_id]');
		}
		if (! isset($info['tax_included'])) {
			api_error(412, 'Tax Included is required [tax_included]');
		}
		if (! isset($info['website'])) {
			$info['website'] = '';
		}
		if (! isset($info['notes'])) {
			$info['notes'] = '';
		}

		/*
		 * $supplier_id, $supp_name, $supp_ref, $address, $supp_address, $gst_no, $website, $supp_account_no,
		 * $bank_account, $credit_limit, $dimension_id, $dimension2_id, $curr_code, $payment_terms, $payable_account,
		 * $purchase_account, $payment_discount_account, $notes, $tax_group_id, $tax_included
		 */
		update_supplier($id, $info['supp_name'], $info['supp_ref'], $info['address'], $info['supp_address'], $info['gst_no'], $info['website'], $info['supp_account_no'], $info['bank_account'], $info['credit_limit'], 0, 0, $info['curr_code'], $info['payment_terms'], $info['payable_account'], $info['purchase_account'], $info['payment_discount_account'], $info['notes'], $info['tax_group_id'], $info['tax_included']);

		api_success_response("Supplier has been updated");
	}

	// Delete Specific Supplier
	public function delete($rest, $id) {
		$req = $rest->request();
		$info = $req->post();

		$sup = get_supplier($id);
		if ($sup == null) {
			api_error(400, 'Invalid Supplier ID');
		}

		delete_supplier($id);

		$sup = null;
		$sup = get_supplier($id);

		if ($sup != null) {
			api_error(500, 'Could Not Delete from Database');
		} else {
			api_success_response("Supplier has been deleted");
		}
	}

	public function getContacts($rest, $id) {
		$contacts = get_supplier_contacts($id, null);
		api_success_response(json_encode($contacts));
	}

	private function supplier_all($from = null) {
		if ($from == null)
			$from = 0;

		$sql = "SELECT * FROM " . TB_PREF . "suppliers LIMIT " . $from . ", " . RESULTS_PER_PAGE;

		$query = db_query($sql, "error");

		$info = array();

		while ($data = db_fetch_assoc($query, "error")) {
			$info[] = $data;
		}

		api_success_response(json_encode($info));
	}
}