<?php

global $reports, $dim;

function sales_types($param, $type)
{
    if ($type == 'SALES_TYPES')
        return sales_types_list($param, null, null, true);
}
$reports->register_controls("sales_types");

			
$reports->addReport(RC_INVENTORY,"_sales_type_summary",_('&Sales Type Summary Report'),
	array(	_('Start Date') => 'DATEBEGINM',
			_('End Date') => 'DATEENDM',
			_('Inventory Category') => 'CATEGORIES',
			_('Sales Types') => 'SALES_TYPES',
			_('Comments') => 'TEXTBOX',
			_('Orientation') => 'ORIENTATION',
			_('Destination') => 'DESTINATION'));				
