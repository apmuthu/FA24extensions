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

$page_security = 'SA_SALESORDER';
$path_to_root="../..";
include_once($path_to_root . "/includes/session.inc");

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/includes/db/crm_contacts_db.inc");

// ---------------------------------------------------------------------

// set_posts(array('stock_id', 'sales_type', 'debtor_no', 'noheader', 'action'));

add_css_file('https://unpkg.com/leaflet@1.3.1/dist/leaflet.css');
// does not work
// add_css_file('https://github.com/apmuthu/FA24extensions/files/2130882/leaflet.css.txt');

function getTransactions($from, $to, $sales_type, $stock_id)
{
    if (!empty($from)) {
        $fromdate = date2sql($from);
        $todate = date2sql($to);
    }

    $sql = "SELECT d.debtor_no, d.name AS cust_name, st.sales_type, dt.type, dt.trans_no,  dt.tran_date, sm.latlong, cb.br_address, cb.br_post_address, dt.branch_code
        FROM ".TB_PREF."debtor_trans dt
            LEFT JOIN ".TB_PREF."debtors_master d ON d.debtor_no=dt.debtor_no
            LEFT JOIN ".TB_PREF."sales_types st ON d.sales_type=st.id
            LEFT JOIN ".TB_PREF."cust_branch cb ON dt.branch_code=cb.branch_code
            LEFT JOIN ".TB_PREF."sales_map sm ON dt.branch_code=sm.branch_code
            LEFT JOIN ".TB_PREF."sales_order_details sod ON dt.order_ = sod.order_no
        WHERE (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.") ";

    if (!empty($stock_id))
        $sql .= "AND stk_code=".db_escape($stock_id) . " ";

    if (!empty($from))
        $sql .= "AND dt.tran_date >=".db_escape($fromdate)." AND dt.tran_date<=".db_escape($todate);

    if (!empty($sales_type))
        $sql .= " AND sales_type = '" . $sales_type . "'";

    $sql .= " GROUP BY debtor_no ORDER BY cust_name";

    return db_query($sql,"No transactions were returned");
}

function getSalesItems($cat, $debtor_no = null, $from = null, $to = null)
{
    if (!empty($from)) {
        $fromdate = date2sql($from);
        $todate = date2sql($to);
    }

    $sql = "SELECT d.debtor_no, d.name AS cust_name, dt.type, dt.trans_no,  dt.tran_date, stk_code, sm.description
        FROM ".TB_PREF."debtor_trans dt
            LEFT JOIN ".TB_PREF."voided as v
                ON dt.trans_no=v.id AND dt.type=v.type
            LEFT JOIN ".TB_PREF."debtors_master d
                ON d.debtor_no=dt.debtor_no
            LEFT JOIN ".TB_PREF."sales_order_details sod
                ON dt.order_ = sod.order_no
            LEFT JOIN ".TB_PREF."stock_master sm
                ON sm.stock_id = sod.stk_code

        WHERE ISNULL(v.date_)
            AND (dt.type=".ST_SALESINVOICE." OR dt.type=".ST_CUSTCREDIT.") ";

        if (!empty($debtor_no))
            $sql .= " AND d.debtor_no = " . db_escape($debtor_no);

        if (!empty($cat))
            $sql .= " AND sm.category_id = " . db_escape($cat);

    if (!empty($from))
        $sql .= "AND dt.tran_date >=".db_escape($fromdate)." AND dt.tran_date<=".db_escape($todate);

    $sql .= " GROUP BY stk_code ORDER BY description";

    return db_query($sql,"No transactions were returned");
}

function clientarray_string($stock_id)
{
	$clientArray="var clientArray = new Array();\n";

	$count=0;

    $res = getTransactions(null, null, get_post('sales_type'), get_post('stock_id'));
    while ($cust=db_fetch($res)) {

        $old_address = $cust["br_address"];
        $address = preg_replace("/^[^0-9]*/", "", $old_address);
        if ($old_address != $address) {
            display_notification("old $old_address");
            display_notification("new $address");
        }
        $address = trim($address);
        $address = str_replace(array("\n", "\r"), ' ', $address);
        $lastchar = substr($address, strlen($address)-1,1);
        if (!is_numeric($lastchar)) {
            // No zip code? Skipping address
            continue;
        }

        if ($cust["latlong"] == "" || $cust["latlong"] == ",") {
            $request_url = "https://nominatim.openstreetmap.org/search?q=" . urlencode($address) . "&format=xml";

            // this should work but not with openstreet
            // $xml = simplexml_load_file($request_url) or die("url not loading");

            // instead use curl
            $ch = curl_init($request_url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

            // Identify the request User Agent as Chrome - any real browser, or perhaps any value may work
            // depending on the resource you are trying to hit
            curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0');

            $feed = curl_exec($ch);
            $xml = new SimpleXMLElement($feed);

    //display_notification($request_url);
    //display_notification(print_r($xml, true));

            if (isset($xml->place)) {
              // Successful geocode
              $geocode_pending = false;
              $lat = $xml->place['lat'];
              $lng = $xml->place['lon'];

              $sql = "INSERT ".TB_PREF."sales_map (branch_code, latlong) VALUES('" . $cust["branch_code"] . "','" . $lat . "," . $lng . "')";
              db_query($sql,"No transactions were returned");
           } else {
            display_notification("bad geocode for " . $cust["cust_name"] . " at " . $address . ";" . $status);
            // syslog(LOG_NOTICE, "sales_map: bad geocode for " . $cust["cust_name"] . " at " . $address . ";" . $status);
            continue;
           }
        } else {
            $foo = explode(",", $cust["latlong"]);
            $lat = $foo[0];
            $lng = $foo[1];
        }

        $crm = get_customer_contacts($cust["debtor_no"]);

        $clientArray .= "clientArray[" . $count . "] = new Array(";
        $clientArray .= "\"" . $cust["cust_name"] . "\","; 
        $clientArray .= "\"" . $address . "\","; 
        $clientArray .= "\"" . $lat . "\","; 
        $clientArray .= "\"" . $lng . "\","; 
        $clientArray .= "\"" . $crm[0]["phone"] . "\",";
        $clientArray .= "\"" . $cust["debtor_no"] . "\"";
        $clientArray .= ");\n";


        $count++;
    }

	return str_replace("'", "\\'", $clientArray);
}

// ---------------------------------------------------------------------

global $db; // Allow access to the FA database connection
$debug_sql = 0;

global $db_connections;
$cur_prefix = $db_connections[$_SESSION["wa_current_user"]->cur_con]['tbpref'];

$sql          = "SHOW TABLES";
$result       = db_query($sql, "could not show tables");
$found        = 0;
$config_found = 0;
while (($row = db_fetch_row($result))) {
    if ($row[0] == $cur_prefix."sales_map") $found = 1;
    if ($row[0] == $cur_prefix."sales_map_config") $config_found = 1;
}

if (!$found) {
        $sql = "DROP TABLE IF EXISTS ".TB_PREF."sales_map";
        db_query($sql, "Error dropping table");
        $sql = "CREATE TABLE ".TB_PREF."sales_map (
            `branch_code` int(11) NOT NULL,
            `latlong` varchar(32) NOT NULL default '',
            PRIMARY KEY  (`branch_code`)) ENGINE=InnoDB";
        db_query($sql, "Error creating table");
}

if ($config_found) {
    // Get Configuration variables
    $sql     = "SELECT * FROM ".TB_PREF."sales_map_config WHERE name = 'tile_server'";
    $result  = db_query($sql, "could not get tile server");
    $row     = db_fetch_row($result);
    if ($row)
        $tile_Server = $row[1];

    $sql     = "SELECT * FROM ".TB_PREF."sales_map_config WHERE name = 'center_lat'";
    $result  = db_query($sql, "could not get map center latitude");
    $row     = db_fetch_row($result);
    if ($row)
        $center_Lat = $row[1];

    $sql     = "SELECT * FROM ".TB_PREF."sales_map_config WHERE name = 'center_long'";
    $result  = db_query($sql, "could not get map center longitude");
    $row     = db_fetch_row($result);
    if ($row)
        $center_Long = $row[1];

    $sql     = "SELECT * FROM ".TB_PREF."sales_map_config WHERE name = 'cat'";
    $result  = db_query($sql, "could not get category");
    $row     = db_fetch_row($result);
    if ($row)
        $cat_ = $row[1];
}

// -----------------------------------------------------------------


    // Create Table
    if (get_post('action') == 'create') {
        $sql = "DROP TABLE IF EXISTS ".TB_PREF."sales_map_config";
        db_query($sql, "Error dropping table");
        $sql = "CREATE TABLE ".TB_PREF."sales_map_config ( `name` char(15) NOT NULL default '', " .
               " `value` varchar(256) NOT NULL default '', PRIMARY KEY  (`name`)) ENGINE=InnoDB";
        db_query($sql, "Error creating table");
        header("Location: sales_map.php?action=show");
    }

    if (get_post('action') == 'update') {

            $centerLat = get_post('centerLat');
            $centerLong = get_post('centerLong');
            $tileServer = get_post('tileServer');
            $cat = get_post('category');

            if ($centerLat == "") $sql = "DELETE FROM ".TB_PREF."sales_map_config WHERE name = 'center_lat'";
            else if (!isset($center_Lat)) $sql = "INSERT INTO ".TB_PREF."sales_map_config (name, value) VALUES ('center_lat', ".db_escape($centerLat).")";
            else $sql = "UPDATE  ".TB_PREF."sales_map_config SET value = ".db_escape($centerLat)." WHERE name = 'center_lat'";
            db_query($sql, "Update 'center_lat'");

            if ($centerLong == '') $sql = "DELETE FROM ".TB_PREF."sales_map_config WHERE name = 'center_long'";
            else if (!isset($center_Long)) $sql = "INSERT INTO ".TB_PREF."sales_map_config (name, value) VALUES ('center_long', ".db_escape($centerLong).")";
            else $sql = "UPDATE  ".TB_PREF."sales_map_config SET value = ".db_escape($centerLong)." WHERE name = 'center_long'";
            db_query($sql, "Update 'center_long'");

            if ($tileServer == '') $sql = "DELETE FROM ".TB_PREF."sales_map_config WHERE name = 'tile_server'";
            else if (!isset($tile_Server)) $sql = "INSERT INTO ".TB_PREF."sales_map_config (name, value) VALUES ('tile_server', ".db_escape($tileServer).")";
            else $sql = "UPDATE  ".TB_PREF."sales_map_config SET value = ".db_escape($tileServer)." WHERE name = 'tile_server'";
            db_query($sql, "Update 'tile_server'");

            if ($cat == '') $sql = "DELETE FROM ".TB_PREF."sales_map_config WHERE name = 'cat'";
            else if (!isset($cat_)) $sql = "INSERT INTO ".TB_PREF."sales_map_config (name, value) VALUES ('cat', ".db_escape($cat).")";
            else $sql = "UPDATE  ".TB_PREF."sales_map_config SET value = ".db_escape($cat)." WHERE name = 'cat'";
            db_query($sql, "Update 'cat'");

    } else {

// Default Configuration:
// Most importantly, you MUST change the tile server
// (read the usage terms).
        if (isset($tile_Server))
            $tileServer = $tile_Server;
        else
            $tileServer = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
        if (isset($center_Lat))
            $centerLat = $center_Lat;
        else
            $centerLat = 39.066667;
        if (isset($center_Long))
            $centerLong = $center_Long;
        else
            $centerLong = -108.566667;
        if (isset($cat_))
            $cat = $cat_;
        else
            $cat = "";
    }

// ----------------------------------------------------------------

define ('SCRIPT', '
' . clientarray_string(get_post('stock_id')) . '
  var side_bar_html = "<DIV id=\'title\'></DIV>";

function map_init()
{
    var map = L.map("map_canvas").setView([' . "$centerLat, $centerLong" . '], 13);

    L.tileLayer("' . $tileServer . '", {
        attribution: "&copy; <a href=\"https://www.openstreetmap.org/copyright\">OpenStreetMap</a> contributors"
    }).addTo(map);

    for (var i = 0; i < clientArray.length; i++)
        codeAddress(map, i);

	//side bar html into side bar div
	document.getElementById("side_bar").innerHTML = side_bar_html;
}

function popup(mylink, windowname)
{
if (! window.focus)return true;
var href;
if (typeof(mylink) == \'string\')
   href=mylink;
else
   href=mylink.href;
window.open(href, windowname, \'width=500,height=400,scrollbars=yes\');
return false;
}


var markers = [];

function clickList(i) {
    markers[i].openPopup();
}


function codeAddress(map, i) {
	var htmlListing = "<P><H2 onclick=clickList(" + i + ") style=\'margin-bottom:2px;\'><a href=" + window.location.href +"#title>" + clientArray[i][0] + "</a></H2>"	//name
					+ clientArray[i][1] +  "<br>"  //address
					+ clientArray[i][4] + "<br>" // phone
 + "<a href=" + location.protocol + "//" + location.host + location.pathname + "?debtor_no=" + clientArray[i][5] + " onClick=\'return popup(this, \"Items Carried\")\'>Items Carried</a>" ;

	side_bar_html += htmlListing;	
    										
	var markerText =  "<div STYLE=\'background-color:#00068f;font-weight:bold\'><font size=3 face=\'trebuchet MS\' color=white>&nbsp;"
		        + clientArray[i][0] + "<font size=2 color=blue></div>" 
						        + clientArray[i][1] + "<br>"
						        + clientArray[i][4] + "</font>";
    										
    marker = L.marker([clientArray[i][2], clientArray[i][3]]);
    marker.addTo(map)
        .bindPopup(markerText)
        .openPopup();

    markers[i] = marker;    // store for list click
}

function stockFilter()
{
    var ddl = document.getElementById("stock_id");
    var stock_id = ddl.options[ddl.selectedIndex].value;
    window.location.href = location.protocol + "//" + location.host + location.pathname + "?stock_id=" + stock_id;
}

Behaviour.addLoadEvent(map_init);

');

$js = "";
if ($SysPrefs->use_popup_windows)
	$js .= get_js_open_window(800, 500);
if (user_use_date_picker())
	$js .= get_js_date_picker();
$js .= file_get_contents("https://unpkg.com/leaflet@1.3.1/dist/leaflet.js");
//$js .= get_js_history(array('debtor_no', 'stock_id'));
$js .= SCRIPT;


page(_($help_context = "Sales Map"), get_post('noheader'), false, "", $js);

if (get_post('debtor_no')) {
    
    $res = getSalesItems($cat, get_post('debtor_no'));
    while ($item=db_fetch($res)) {
			print $item['description'] . "<br>";
	}
    exit();
}

// ----------------------------------------------------------------

if (get_post('action') == 'show') {
    start_form(true);
    start_table(TABLESTYLE);

    $th = array("Function", "Description");
    table_header($th);

    $k = 0;

    alt_table_row_color($k);

    label_cell("Table Status");
    if ($config_found) $table_st = "Found";
    else $table_st = "<font color=red>Not Found</font>";
    label_cell($table_st);
    end_row();

    if ($config_found) {
        text_row("Tile Server<br>(See usage policy)", 'tileServer', $tileServer, 40, 100);
        text_row("Map Center Latitude", 'centerLat', $centerLat, 20, 40);
        text_row("Map Center Longitude", 'centerLong', $centerLong, 20, 40);
        stock_categories_list_row("Item Category", 'category', $cat, "All Categories");
    }

    end_table(1);

    if (!$config_found) {
        hidden('action', 'create');
        submit_center('create', 'Create Table');
    } else {
        hidden('action', 'update');
        submit_center('update', 'Update Mysql');
    }

    end_form();

    end_page();
    exit();
}


start_form();
start_table(TABLESTYLE);

// Ajax does not work with map_canvas, so use direct javascript

$sel = "<select id=\"stock_id\" name=\"stock_id\" onchange=\"stockFilter()\">";
    $sel .= "<option value=\"\">All Items\n";
$res = getSalesItems($cat);
while ($item=db_fetch($res)) {
        if ($item['stk_code'] == get_post('stock_id'))
            $selected = " selected";
        else
            $selected = "";
        $sel .= "<option value=\"" . $item['stk_code'] . "\"" . $selected . ">" . $item['description'] . "\n";
}

$sel .= "</select>";

table_header(array("Stock Locations", ($cat == "" ? "All Categories" : get_category_name($cat)) . " " . $sel));
?>


<tr><td class="infoBox" valign=top>
  <div id="side_bar" style="OVERFLOW: auto; WIDTH: 200px; HEIGHT: 500px; BACKGROUND-COLOR: #ffffff"></div>
</td>
<td valign=top>
<style>
.map_canvas {
    height: 500px;
    width: 600px;
}
</style>

<?php
div_start("map_canvas");
div_end();
?>
</td></tr>

<tr>
<td class="infoBoxHeading" vAlign="top" align="center" colSpan="2">
Click and hold to drag map.
Click on marker for more information.
</td>
</tr>

<tbody id="config">
<tr><td align="center" colspan=2>
<?php
    hyperlink_params($_SERVER['PHP_SELF'], _("Configuration"), "action=show", false);
?>
</td></tr>
</tbody>
<?php

end_table(1);

end_page(get_post('noheader'));

?>
