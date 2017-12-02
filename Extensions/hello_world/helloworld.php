<?php
/**********************************************************************
// Creator: Ap.Muthu
// date_:   2017-10-19
// Title:   Hello World application
// Free software under GNU GPL
***********************************************************************/

class helloworld_app extends application
{

	function __construct()
	{
		parent::__construct("hello", _($this->help_context = "&Hello World"));

		$this->add_module(_("Transactions"));

		$this->add_module(_("Inquiries and Reports"));
				$this->add_rapp_function(1, "",""); // provide a menu spacer in right menu of second (1) section
				$this->add_rapp_function(1, _('Hello World'), 
					$path_to_root.'/modules/hello_world/hello_world.php', 'SA_OPEN', MENU_INQUIRY); // menu icons defined in applications/application.php

		$this->add_module(_("Maintenance"));

        $this->add_extensions();

	}

}
?>