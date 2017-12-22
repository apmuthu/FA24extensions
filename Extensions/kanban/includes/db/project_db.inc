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

function write_project($id=false, $name, $desc, $type, $created_date, $closed_date, $begin_date, $end_date, $owner, $closed=false) {
    if(!$id)
	    $sql = "INSERT INTO ".TB_PREF."projects VALUES("
	    .db_escape($id).", "
	    .db_escape($name).", "
	    .db_escape($desc).", "
	    .db_escape($type).", '"
	    .date2sql($created_date)."', '"
	    .date2sql($closed_date)."', '"
	    .date2sql($begin_date)."', '"
	    .date2sql($end_date)."', "
	    .db_escape($owner).", "
	    .db_escape($closed)
	    .")";
	else
	    $sql = "UPDATE ".TB_PREF."projects SET 
	    proj_id = ".db_escape($id).", 
	    proj_name = ".db_escape($name).", 
	    proj_description = ".db_escape($desc).", 
	    proj_type = ".db_escape($type).", 
	    created_date = '".date2sql($created_date)."', 
	    closed_date = '".date2sql($closed_date)."', 
	    begin_date = '".date2sql($begin_date)."', 
	    end_date = '".date2sql($end_date)."', 
	    owner_id = ".db_escape($owner)." 
	    closed = ".db_escape($closed)." 
	    WHERE proj_id = ".db_escape($id);

	db_query($sql, "could not write project data");
}

//--------------------------------------------------------------------------

function get_projects($id = false, $all = false, $type = false) {
	
	$sql = "SELECT * FROM ".TB_PREF."projects";
	$where = array();
	
	if(!$all)
		$where[] = "!closed";
	if($id)
		$where[] = "proj_id=".db_escape($id);
	if($type)
		$where[] = "proj_type = ".db_escape($type);
		
	if(count($where))
		$sql .= ' WHERE '.implode(' AND ', $where);
	else
		$sql .= ' WHERE 1';

	$result = db_query($sql, "Could not get project data.");
	
	if($id)
		return db_fetch($result);
	else
		return $sql;
}

//--------------------------------------------------------------------------

function delete_project($id) {
    $sql = "DELETE FROM ".TB_PREF."projects WHERE proj_id = ".db_escape($id);
    db_query($sql, _('could not delete project data'));
}

//--------------------------------------------------------------------------

function get_last_project() {
	$sql = "SELECT MAX(proj_id) FROM ".TB_PREF."projects WHERE !closed";
	$result = db_query($sql, _('could not get project data.'));
	 return db_fetch($result);
}

//--------------------------------------------------------------------------



//--------------------------------------------------------------------------

function add_project_data_file($id) {
    global $path_to_root;

	$content = "{}";
    $fp = fopen("$path_to_root/modules/kanban/data/".$id, "wb");
    fwrite($fp, $content);
    fclose($fp);

    if(file_exists("$path_to_root/modules/kanban/data/".$id))
        return true;
    else
        return false;
}
