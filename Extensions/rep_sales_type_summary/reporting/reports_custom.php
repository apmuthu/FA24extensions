<?php

global $reports, $dim;

function sales_types($param, $type)
{
    if ($type == 'SALES_TYPES')
        return sales_types_list($param, null, null, true);
}
$reports->register_controls("sales_types");

function item_type($param, $type)
{
    if ($type == 'ITEM_TYPE')
        return yesno_list($param, "All Item Types", "Manufactured Only", "All Item Types");
}
$reports->register_controls("item_type");

			
$reports->addReport(RC_INVENTORY,"_sales_type_summary",_('&Item Sales Report By Quantity, Supplier and Type'),
	array(	_('Start Date') => 'DATEBEGINM',
			_('End Date') => 'DATEENDM',
			_('Category') => 'CATEGORIES',
			_('Suppliers') => 'SUPPLIERS_NO_FILTER',
			_('Sales Types') => 'SALES_TYPES',
			_('Item Type') => 'ITEM_TYPE',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION',
			_('Destination') => 'DESTINATION'));				
