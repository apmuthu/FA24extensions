<?php
/*=====================================================================
    Module Name: Shipment Tracking For Frontaccounting
    Developer: Mohsin Firoz Mujawar
    Company: Impulse Solutions, Pune
    Email: contact@impulsesolutions.in
=====================================================================*/

function invoice_list($name, $selected_id=null)
{
	$ref = ($GLOBALS['SysPrefs']->prefs['print_invoice_no'] == 1 ? "trans_no" : "reference");
	$sql = "SELECT concat(debtor_trans.trans_no, '-', debtor_trans.type) AS TNO
				 , concat(debtor_trans.$ref,' ', debtor.name) as IName
			FROM ".TB_PREF."debtors_master debtor INNER JOIN "
				.TB_PREF."debtor_trans USING (debtor_no) LEFT JOIN "
				.TB_PREF."voided AS vd ON (debtor_trans.type=vd.type AND debtor_trans.trans_no=vd.id)
			WHERE debtor_trans.type=".ST_SALESINVOICE." AND ISNULL(vd.id)
			ORDER BY debtor_trans.trans_no DESC";

		return combo_input($name, $selected_id, $sql, 'TNO', 'IName',array('order'=>false));
}

function invoice_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo invoice_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function invoice_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	invoice_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

function shipper_list($name, $selected_id=null)
{
	$sql = "SELECT * FROM ".TB_PREF."shippers WHERE !inactive";

		return combo_input($name, $selected_id, $sql, 'shipper_id', 'shipper_name',array('order'=>true));
}

function shipper_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo shipper_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function shipper_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	shipper_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

function uom_list($name, $selected_id=null)
{
	$sql = "SELECT * FROM ".TB_PREF."item_units WHERE !inactive";

		return combo_input($name, $selected_id, $sql, 'abbr', 'name',array('order'=>true));
}

function uom_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo uom_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function uom_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	uom_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}

function status_list($name, $selected_id=null)
{
$field = "shipments.shipment_status";
	$sql = "SELECT option_id
	             , column_value AS shipment_status 
			FROM ".TB_PREF."options 
			WHERE table_name='shipments' AND column_name='shipment_status' AND !inactive";

		return combo_input($name, $selected_id, $sql, 'option_id', 'shipment_status',array('order'=>false));
}

function status_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<td>$label</td>\n";
	echo "<td>";
	echo status_list($name, $selected_id, $submit_on_change, $special_option);
	echo "</td>\n";
}

function status_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr><td class='label'>$label</td>";
	status_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</tr>\n";
}