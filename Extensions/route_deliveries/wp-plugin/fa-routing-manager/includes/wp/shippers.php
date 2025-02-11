<?php
// Function to add the 'FA Shipper' role if it doesn't exist
function add_fa_shipper_role_if_needed() {
    if (!get_role('fa_shipper')) {
        // Add the 'FA Shipper' role with read-only access
        add_role('fa_shipper', 'FA Shipper', array(
            'read' => true, // Allow read access
        ));
    }
}
add_action('init', 'add_fa_shipper_role_if_needed');

// Redirect 'FA Shipper' roles away from wp-admin
function restrict_fa_shipper_dashboard_access() {
    if (is_user_logged_in() && is_admin()) {
        if (current_user_can('fa_shipper')) {
            // Redirect FA Shippers to their dashboard
            wp_redirect(home_url(SHIPPER_DASH_URL)); 
            exit;
        }
    }
}
add_action('admin_init', 'restrict_fa_shipper_dashboard_access');

// Disable admin bar for 'FA Shipper'
function hide_admin_bar_for_fa_shipper() {
    if (current_user_can('fa_shipper')) {
        show_admin_bar(false);
    }
}
add_action('after_setup_theme', 'hide_admin_bar_for_fa_shipper');

// Display 'shipper_name' field in user profile for 'FA Shipper' role
function show_shipper_in_user_profile($user) {
    if (in_array('fa_shipper', (array) $user->roles)) {
        ?>
        <h3>Front Accounting Shipper Information</h3>
        <table class="form-table">
            <tr>
                <th><label for="shipper_name">Shipper Name</label></th>
                <td>
                    <input type="text" name="shipper_name" id="shipper_name" value="<?php echo esc_attr(get_user_meta($user->ID, 'shipper_name', true)); ?>" class="regular-text" />
                </td>
            </tr>
        </table>
        <?php
    }
}
add_action('show_user_profile', 'show_shipper_in_user_profile');
add_action('edit_user_profile', 'show_shipper_in_user_profile');

// Save 'shipper_name' field for 'FA Shipper' role
function save_shipper_name_user_meta($user_id) {
    // Ensure the user is a FA Shipper and the current user has permission to edit
    if (current_user_can('edit_user', $user_id)) {
        $user = get_user_by('id', $user_id);
        
        // Only update if the user has the 'FA Shipper' role
        if (in_array('fa_shipper', (array) $user->roles)) {
            // Check if 'shipper_name' is set and not empty
            if (isset($_POST['shipper_name']) && !empty($_POST['shipper_name'])) {
                // Sanitize and save the 'shipper_name'
                update_user_meta($user_id, 'shipper_name', sanitize_text_field($_POST['shipper_name']));
            }
        }
    }
}
add_action('personal_options_update', 'save_shipper_name_user_meta');
add_action('edit_user_profile_update', 'save_shipper_name_user_meta');

// Custom login redirect for 'Customer' and 'Technician' roles
function shipper_login_redirect($redirect_to, $request, $user) {
    if (isset($user->roles)) {
        if (in_array('fa_shipper', $user->roles)) {
            return home_url(SHIPPER_DASH_URL); // Redirect technicians to their dashboard
        }
    }
    return $redirect_to; // Default redirect for other roles
}
add_filter('login_redirect', 'shipper_login_redirect', 10, 3);
