<?php
// ----------------------------------------------------------------
// $ Revision:  1.0 $
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   UI functions for dashboard
// Free software under GNU GPL
// ----------------------------------------------------------------

function widget_list_row($widgets, $label, $name, $selected_id=null, $submit_on_change=false)
{
    echo "<tr><td class='label'>$label</td><td>";
    echo array_selector($name, $selected_id, $widgets,
        array(
            'select_submit'=> $submit_on_change
        ) );
    echo "</td></tr>\n";
}

function select_row($label, $name, $selected_id=null, $items, $options)
{
    // add missing function for generic selector row
    echo "<tr><td class='label'>$label</td><td>";
    echo array_selector($name, $selected_id, $items, $options);
    echo "</td></tr>\n";
}

function start_cell()
{
    echo "<td>";
}

function end_cell()
{
    echo "</td>";
}
?>