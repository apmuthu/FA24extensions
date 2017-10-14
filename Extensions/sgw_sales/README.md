# FrontAccounting Module: sgw_sales

[![Build Status](https://travis-ci.org/saygoweb/frontaccounting-module-sgw_sales.svg?branch=master)](https://travis-ci.org/saygoweb/frontaccounting-module-sgw_sales)

A module for Front Accounting that provides recurring invoicing for sales orders.

## Order Entry ##

 - A modified Sales Order Entry screen that allows for orders to be marked as recurring.
 - Start and optional end date can be specified.
 - Yearly and Monthly recurring intervals.
 - Set the date in the year, or date in month on which the recurring invoice should be triggered.

![Order Entry](/docs/OrderEntry.png?raw=true "Sales Order Entry")

## Invoice Generation ##

 - Shows a list of orders that are due to be invoiced.
 - Some or all invoices can be generated.
 - Can email invoices when they are generated.
 - Delivery notes are automatically generated.
 - Invoices are recorded against the Sales Order.

![Invoice Generation](/docs/GenerateInvoices.png?raw=true "Invoice Generation")

## installed_extensions.php stanza ##
````
  1 => 
  array (
    'package' => 'sgw_sales',
    'name' => 'sgw_sales',
    'version' => '2.4.2-1',
    'available' => '',
    'type' => 'extension',
    'path' => 'modules/sgw_sales',
    'active' => false,
  ),
````

