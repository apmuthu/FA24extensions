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
function submit_cust_update($add=true, $title=false, $async=false, $clone=false)
{
	$cancel = $async;

	if ($async === 'both') {
		$async = 'default'; $cancel = 'cancel';
	}
	elseif ($async === 'upgrade') {
		$async = 'default nonajax process'; $cancel = 'cancel';
	}
	elseif ($async === 'default')
		$cancel = true;
	elseif ($async === 'cancel')
		$async = true;
	if ($add)
		submit('ADD_ITEM', _("Add new"), null, $title, $async);
	else {
		submit('UPDATE_ITEM', _("Update"), true, _('Submit changes'), $async);
		if ($clone) submit('CLONE', _("Clone"), true, 
			_('Edit new record with current data'), $async);
		submit('RESET', _("Cancel"), true, _('Cancel edition'), $cancel);
	}
}

function submit_cust_update_center($add=true, $title=false, $async=false, $clone=false)
{
	echo "<center>";
	submit_cust_update($add, $title, $async, $clone);
	echo "</center>";
}

