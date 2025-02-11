<?php

// page template shortcode
add_shortcode('fa_shipper_dash_page', 'display_shipper_dash_page');

// individual short codes
add_shortcode('fa_shipper_welcome', 'display_shipper_dash_welcome');
add_shortcode('fa_shipper_details', 'technician_dashboard_shipper_details');
add_shortcode('fa_unlogged_deliveries_table', 'display_unlogged_deliveries_shortcode');
add_shortcode('fa_deliveries_today_table', 'display_deliveries_today_shortcode');
add_shortcode('fa_recent_delivery_table', 'recent_delivery_history_shortcode');
add_shortcode('fa_shipper_help_message', 'display_shipper_help_info');
add_shortcode('fa_delivery_dash_js', 'load_delivery_dash_js' );

// adding wp actions
add_action('template_redirect', 'restrict_shipper_dashboard_access');
