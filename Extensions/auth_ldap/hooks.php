<?php
/*******************************************************************************
 * Copyright (c) 2013
 *
 * Released under the terms of the GNU General Public License, GPL, 
 * as published by the Free Software Foundation, either version 3 
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 * See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
 *
 * Authors       msquared
 * Date Created  Nov 8, 2013
 ******************************************************************************/

include dirname(__FILE__).'/config_ldap.php';
include dirname(__FILE__).'/lib/ldap_authenticator.php';

class hooks_auth_ldap extends hooks
{

	function __construct() {
		$this->module_name = 'auth_ldap';
	}

    function authenticate($username, $password)
    {
        global $_ldap_config;  // import from config_ldap
        $authenticator = ldap_authenticator::create()
            ->setConfiguration($_ldap_config)
            ->setCompany($_SESSION['wa_current_user']->company);
        if (!$authenticator->isEnabled()) {
            return null;
        }
        return $authenticator->login($username, $password);
    }

    function activate_extension($company, $check_only=true)
    {
        if (!function_exists('ldap_connect')) {
            if (!$check_only)
                display_error(_('Auth_LDAP module cannot be activated. Please enable LDAP module in your PHP configuration.'));
            return false;
        }
        return true;
    }
}
