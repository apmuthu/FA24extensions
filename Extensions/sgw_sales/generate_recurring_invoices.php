<?php
/**********************************************************************
	Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
	See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/

use SGW_Sales\db\GenerateRecurringModel;
use SGW_Sales\controller\GenerateRecurring;

$page_security = 'SA_SALESINVOICE';

include_once(__DIR__ . '/vendor/autoload.php');

$path_to_root = "../..";
$path_to_module = __DIR__;

include_once($path_to_root . "/sales/includes/cart_class.inc");
include_once($path_to_root . "/includes/session.inc");
//include_once($path_to_root . "/sales/includes/ui/sales_order_ui.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/db_pager_view.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");

class GenerateRecurringView {

	/**
	 * @var GenerateRecurring
	 */
	public $controller;
	
	public function viewList() {
		start_form();
		
		start_table(TABLESTYLE_NOBORDER);
		start_row();

		check_cells('Show All', 'show_all', null, true);
		submit_cells('GenerateInvoices', _("Generate Invoices"),'',_('Select orders'), 'default');
		
		end_row();
		end_table(1);
		
		start_table(TABLESTYLE, "width=70%");
		table_header(array(
			checkbox('', 'select_all', null, true),
			_("#"),
			_("Ref"),
			_("Customer"),
			_("Branch"),
			_("Start"),
			_("End"),
			_("Repeats"),
			_("Every"),
			_("On"),
			_("Last Invoice"),
			_("Next Invoice"),
			"",
			""
		));
		
		$due = false;
		
		$this->controller->table();
		
		end_table();
		end_form();
		if ($due)
			display_note(_("Marked items are due."), 1, 0, "class='overduefg'");
			else
				display_note(_("No recurrent invoices are due."), 1, 0);
		
				br();
	}
	
	/**
	 * @param GenerateRecurringModel $model
	 * @param int
	 */
	public function tableRow($model, &$k) {
		//	if ($myrow['overdue'])
		//	{
		//		start_row("class='overduebg'");
		//		$due = true;
		//	}
		//	else
		alt_table_row_color($k);
	
		check_cells('', 's_' . $model->orderNo);
		label_cell(viewer_link($model->orderNo, 'modules/sgw_sales/view/view_sales_order.php?trans_no=' . $model->orderNo));
		label_cell($model->reference);
		label_cell($model->name);
		label_cell($model->brName);
		label_cell(sql2date($model->dtStart), "align='center'");
		label_cell(sql2date($model->dtEnd), "align='center'");
		label_cell($model->repeats);
		label_cell($model->every);
		label_cell($model->occur);
		label_cell(sql2date($model->dtLast), "align='center'");
		label_cell(sql2date($model->dtNext), "align='center'");
		label_cell(pager_link(_("Invoice"), '/modules/sgw_sales/sales_order_entry.php?NewInvoice=' . $model->orderNo, ICON_DOC));
		label_cell(pager_link(_('Edit'), '/modules/sgw_sales/sales_order_entry.php?ModifyOrderNumber=' . $model->orderNo, ICON_EDIT), "align=center");
		
		//  	if ($myrow['overdue'])
			//  	{
			// 		$count = recurrent_invoice_count($myrow['id']);
			//  		if ($count)
				//  		{
				// 			button_cell("create".$myrow["id"], sprintf(_("Create %s Invoice(s)"), $count), "", ICON_DOC, 'process');
				// 		} else {
				// 			label_cell('');
				// 		}
				// 	}
		//  	else
			//  		label_cell("");
		end_row();
	}
	
	public function generatedInvoice($orderNo) {
		echo 'Generated invoice for order ' . $orderNo;
		echo '<br/>';
	}
	
}

$view = new GenerateRecurringView();
$controller = new GenerateRecurring($view);
$view->controller = $controller;

$js = "";
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(900, 600);

if (user_use_date_picker())
	$js .= get_js_date_picker();

page(_($help_context = "Create and Print Recurrent Invoices"), false, false, "", $js);

$controller->run();

end_page();
