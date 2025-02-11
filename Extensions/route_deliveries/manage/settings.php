<?php
/**********************************************************************
  Plugin Settings Page for Route Config
***********************************************************************/

$path_to_root = "../../..";
$page_security = 'SA_CUSTOMER';

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/ui.inc");

page(_($help_context = "Route Plugin Settings"));

$config_file_path = $path_to_root . "/modules/route_deliveries/route_config.php";

// Default settings
$default_config = array(
    'home_point_long' => '-118.000000',
    'home_point_lat' => '34.000000',
    'osrm_url' => 'http://router.project-osrm.org/trip/v1/car/',
    'km' => false,
);

// Load existing settings
$current_config = $default_config;
if (file_exists($config_file_path)) {
    $current_config = include($config_file_path);
}

// Handle form submission
if (isset($_POST['save'])) {
    $home_point_long = $_POST['home_point_long'];
    $home_point_lat = $_POST['home_point_lat'];
    $osrm_url = $_POST['osrm_url'];
    $km = !empty($_POST['km']) ? true : false;

    // Validate inputs
    if (!is_numeric($home_point_long) || !is_numeric($home_point_lat)) {
        display_error(_("Home point coordinates must be numeric."));
    } elseif (empty($osrm_url)) {
        display_error(_("OSRM URL cannot be empty."));
    } else {
        // Generate the config file content
        $config_content = "<?php\n\nreturn array(\n";
        $config_content .= "  'home_point_long' => '" . addslashes($home_point_long) . "',\n";
        $config_content .= "  'home_point_lat' => '" . addslashes($home_point_lat) . "',\n";
        $config_content .= "  'osrm_url' => '" . addslashes($osrm_url) . "',\n";
        $config_content .= "  'km' => " . ($km ? 'true' : 'false') . ",\n";
        $config_content .= ");\n";

        // Write to file
        if (file_put_contents($config_file_path, $config_content)) {
            display_notification(_("Configuration file has been updated successfully."));
        } else {
            display_error(_("Failed to write to the configuration file."));
        }
    }
}

// Display form
start_form();

start_outer_table(TABLESTYLE2);

table_section(1);
table_section_title(_("Route Plugin Settings"));

text_row(_("Home Point Longitude:"), 'home_point_long', $current_config['home_point_long'], 50, 100);
text_row(_("Home Point Latitude:"), 'home_point_lat', $current_config['home_point_lat'], 50, 100);
text_row(_("OSRM URL:"), 'osrm_url', $current_config['osrm_url'], 100, 200);
check_row(_("Use Kilometers:"), 'km', $current_config['km']);

table_section_title(_("US Census"));
label_row(_("Geocode Help:"), '<a href="' . $path_to_root 
  . '/modules/route_deliveries/manage/batch_geocode.php">Batch Geocode Update'
  .'</a>');
end_outer_table(1);

div_start('controls');
submit_center('save', _("Save Settings"), true, '', 'default');
div_end();

end_form();

end_page();

