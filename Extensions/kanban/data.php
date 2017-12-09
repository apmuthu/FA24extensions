<?php
/*=======================================================\
|                        FrontKanban                     |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   01-12-2017                                  |
|   Description: Frontaccounting Project Management Ext  |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/

$page_security = 'SA_MANAGER';
$path_to_root  = '../..';
include_once($path_to_root . "/includes/session.inc");
add_access_extensions();

define('DATA_FILE', "$path_to_root/modules/kanban/data/".$_SESSION['project']);

function save($data) {
	$encoded = json_encode($data);
	$fh = fopen(DATA_FILE, 'w') or die ("could not open file");
	fwrite($fh, $encoded);
	fclose($fh);
}

function load() {
	$fh = fopen(DATA_FILE, 'r');
	$data = fread($fh, filesize(DATA_FILE));
	print $data;
}
function get_all_users() {
	$result = array();
	foreach(get_users() as $row) {
	    $result[] = $row;
	};
    echo json_encode($result);
}

if (function_exists($_POST['action'])) {
	$actionVar = $_POST['action'];
	@$actionVar($_POST['data']);
}
