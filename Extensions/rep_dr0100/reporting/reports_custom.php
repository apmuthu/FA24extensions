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

function report_type($param, $type)
{
    if ($type == 'REPORT_TYPE') {

        $items = array();
        $items['0'] = _("Summary");
        $items['1'] = _("DR0100 PDF");
        $items['2'] = _("DR0100 XML");
        $items['3'] = _("DR0098");

        return array_selector($param, null, $items,
        array(
            'select_submit'=> false,
            'async' => false ) ); // FIX?
    }
}
$reports->register_controls("report_type");


global $reports, $dim;

$reports->addReport(RC_CUSTOMER, "_dr0100",_('&Colorado DR0100 Sales Tax Form'),
    array(  _('Period (YYYY-MM)') => 'TEXT',
        ('Report Type') => 'REPORT_TYPE',
        ('Use Test Case Data') => 'TEST_CASE',
        ('New SUTS System') => 'YES_NO',
));
?>
