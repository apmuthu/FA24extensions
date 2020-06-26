<?php
// include_once($path_to_root . "/includes/ui/ui_lists.inc");

function test_case($param, $type)
{
    if ($type == 'TEST_CASE') {

        $items = array();
        $items['0'] = _("None");
        $items['1'] = _("Test 1");
        $items['2'] = _("Test 2");

        return array_selector($param, null, $items,
        array(
            'select_submit'=> false,
            'async' => false ) ); // FIX?
    }
}

$reports->register_controls("test_case");

global $reports, $dim;

$reports->addReport(RC_CUSTOMER, "_dr0100",_('&Colorado DR0100 Sales Tax Form'),
    array(  _('Period (YYYY-MM)') => 'TEXT',
        ('DR0098 Only') => 'YES_NO',
        ('Test Case') => 'TEST_CASE',
        ('XML') => 'YES_NO',
));
?>
