<?php
/**
 * Plugin Name: FA Routing Manager
 * Description: A routing software plugin for FrontAccounting, includes routing management features via shortcodes and JavaScript.
 * Version:     1.0
 * Author:      Jason March
 * Author URI:  https://trafficpestsolutions.com
 * License:     GPL2
 */

define('BASE_PATH', plugin_dir_path(__FILE__)); // Using plugin_dir_path for better portability

// Including the bootstrap file
require_once plugin_dir_path(__FILE__) . 'includes/bootstrap.php';

// Hook to add settings menu in WordPress admin (as a subpage under Settings)
add_action('admin_menu', 'faroutingmanager_add_admin_submenu');
add_action('admin_init', 'faroutingmanager_settings_init');

// Add the settings page as a subpage under "Settings"
function faroutingmanager_add_admin_submenu() {
    add_options_page(
        'FA Routing Manager Settings',           // Page title
        'FA Routing Manager',                    // Menu title
        'manage_options',                        // Capability
        'faroutingmanager',                      // Menu slug
        'faroutingmanager_settings_page'         // Callback function to display the settings page
    );
}

// Initialize settings
function faroutingmanager_settings_init() {
    register_setting('faroutingmanager', 'faroutingmanager_options');

    // Add the settings section
    add_settings_section(
        'faroutingmanager_db_section', 
        'Database Settings', 
        'faroutingmanager_db_section_callback', 
        'faroutingmanager'
    );
    add_settings_section(
        'faroutingmanager_section', 
        'General Settings', 
        'faroutingmanager_section_callback', 
        'faroutingmanager'
    );

    // Add settings fields
    add_settings_field(
        'fa_db_host', 
        'FA DB Host', 
        'faroutingmanager_db_host_render', 
        'faroutingmanager', 
        'faroutingmanager_db_section'
    );
    add_settings_field(
        'fa_db_user', 
        'FA DB User', 
        'faroutingmanager_db_user_render', 
        'faroutingmanager', 
        'faroutingmanager_db_section'
    );
    add_settings_field(
        'fa_db_password', 
        'FA DB Password', 
        'faroutingmanager_db_password_render', 
        'faroutingmanager', 
        'faroutingmanager_db_section'
    );
    add_settings_field(
        'fa_db_name', 
        'FA DB Name', 
        'faroutingmanager_db_name_render', 
        'faroutingmanager', 
        'faroutingmanager_db_section'
    );
    add_settings_field(
        'tb_pref', 
        'FA TB Pref', 
        'faroutingmanager_tb_pref_render', 
        'faroutingmanager', 
        'faroutingmanager_db_section'
    );
    add_settings_field(
        'start_lat', 
        'Starting Latitude', 
        'faroutingmanager_start_lat_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );
    add_settings_field(
        'start_lon', 
        'Starting Longitude', 
        'faroutingmanager_start_lon_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );
    add_settings_field(
        'shipper_dash_url', 
        'Shipper Dashboard URL', 
        'faroutingmanager_shipper_dash_url_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );    
    add_settings_field(
        'shipper_support_email', 
        'Shipper Support Email', 
        'faroutingmanager_shipper_support_email_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );
    add_settings_field(
        'fa_timezone_display', 
        'Display Timezone', 
        'faroutingmanager_fa_timezone_display_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );
    add_settings_field(
        'fa_timezone_sql', 
        'SQL Server Timezone', 
        'faroutingmanager_fa_timezone_sql_render', 
        'faroutingmanager', 
        'faroutingmanager_section'
    );
}

// Callback for section description
function faroutingmanager_section_callback() {
    echo '<p>Enter your configuration settings for FA Routing Manager below:</p>';
}
function faroutingmanager_db_section_callback() {
    echo '<p>Enter your FrontAccounting database settings for connection:</p>';
}

// Render the FA DB Host input field
function faroutingmanager_db_host_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[fa_db_host]" value="<?php echo isset($options['fa_db_host']) ? esc_attr($options['fa_db_host']) : ''; ?>" />
    <?php
}

// Render the FA DB User input field
function faroutingmanager_db_user_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[fa_db_user]" value="<?php echo isset($options['fa_db_user']) ? esc_attr($options['fa_db_user']) : ''; ?>" />
    <?php
}

// Render the FA DB Password input field
function faroutingmanager_db_password_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="password" name="faroutingmanager_options[fa_db_password]" value="<?php echo isset($options['fa_db_password']) ? esc_attr($options['fa_db_password']) : ''; ?>" />
    <?php
}

// Render the FA DB Name input field
function faroutingmanager_db_name_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[fa_db_name]" value="<?php echo isset($options['fa_db_name']) ? esc_attr($options['fa_db_name']) : ''; ?>" />
    <?php
}

// Render the FA DB Name input field
function faroutingmanager_tb_pref_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[tb_pref]" value="<?php echo isset($options['tb_pref']) ? esc_attr($options['tb_pref']) : ''; ?>" />
    <?php
}

// Render the Starting Latitude input field
function faroutingmanager_start_lat_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[start_lat]" value="<?php echo isset($options['start_lat']) ? esc_attr($options['start_lat']) : ''; ?>" />
    <?php
}

// Render the Starting Longitude input field
function faroutingmanager_start_lon_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[start_lon]" value="<?php echo isset($options['start_lon']) ? esc_attr($options['start_lon']) : ''; ?>" />
    <?php
}

// Render the Shipper Dashboard URL input field
function faroutingmanager_shipper_dash_url_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[shipper_dash_url]" value="<?php echo isset($options['shipper_dash_url']) ? esc_attr($options['shipper_dash_url']) : ''; ?>" />
    <?php
}

function faroutingmanager_shipper_support_email_render() {
    $options = get_option('faroutingmanager_options');
    ?>
    <input type="text" name="faroutingmanager_options[shipper_support_email]" value="<?php echo isset($options['shipper_support_email']) ? esc_attr($options['shipper_support_email']) : ''; ?>" />
    <?php
}

function faroutingmanager_fa_timezone_display_render() {
    $options = get_option('faroutingmanager_options');
    $fa_timezone_display = isset($options['fa_timezone_display']) ? esc_attr($options['fa_timezone_display']) : '';

    // Get all available timezones using PHP's DateTimeZone class
    $timezone_identifiers = DateTimeZone::listIdentifiers();
    ?>
    <select name="faroutingmanager_options[fa_timezone_display]">
        <?php
        foreach ($timezone_identifiers as $timezone) {
            // Set the selected option
            $selected = ($fa_timezone_display === $timezone) ? 'selected' : '';
            echo "<option value='$timezone' $selected>$timezone</option>";
        }
        ?>
    </select>
    <?php
}

function faroutingmanager_fa_timezone_sql_render() {
    $options = get_option('faroutingmanager_options');
    $fa_timezone_sql = isset($options['fa_timezone_sql']) ? esc_attr($options['fa_timezone_sql']) : '';

    // Get all available timezones using PHP's DateTimeZone class
    $timezone_identifiers = DateTimeZone::listIdentifiers();
    ?>
    <select name="faroutingmanager_options[fa_timezone_sql]">
        <?php
        foreach ($timezone_identifiers as $timezone) {
            // Set the selected option
            $selected = ($fa_timezone_sql === $timezone) ? 'selected' : '';
            echo "<option value='$timezone' $selected>$timezone</option>";
        }
        ?>
    </select>
    <?php
}

// Display settings page content
function faroutingmanager_settings_page() {
    ?>
    <form action="options.php" method="post">
        <?php
        settings_fields('faroutingmanager');
        do_settings_sections('faroutingmanager');
        submit_button();
        ?>
    </form>
    <?php
}

// Hook to save configuration settings to the config file
add_action('update_option_faroutingmanager_options', 'faroutingmanager_save_to_config_file', 10, 2);

// Save settings to plugin config file
function faroutingmanager_save_to_config_file($option_name, $new_value) {
    $config_file_path = BASE_PATH . 'plugin-config.php';

    // Start writing the new config content
    $config_content = "<?php\n";
    $config_content .= "/**\n * Plugin Configuration File\n * Auto-generated by FA Routing Manager\n */\n\n";

    foreach ($new_value as $key => $value) {
        // Add each config setting to the file
        $config_content .= "define('" . strtoupper($key) . "', '" . esc_sql($value) . "');\n";
    }

    // Write the new config file
    file_put_contents($config_file_path, $config_content);
}

