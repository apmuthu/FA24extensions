<?php

class hooks_barcode_sales_helper extends hooks
{
    function install_options($app)
    {
        global $path_to_root;

        switch ($app->id) {
            case 'orders': // Sales module
                $app->modules[0]->lappfunctions[3] = new app_function(
                    _('Direct Invoice (Barcode)'),
                    'modules/barcode_sales_helper/sales_order_entry.php?NewInvoice=0',
                    'SA_SALESINVOICE',
                    MENU_TRANSACTION
                );
                break;
        }
    }

    function install_tabs($app) {
        return null;
    }
}
