<?php
/**********************************************************************
// Creator: Ap.Muthu
// date_:   2017-10-19
// Title:   Hello World application
// Free software under GNU GPL
***********************************************************************/

class helloworld_app extends application
{

	function helloworld_app()
	{
		$this->application("hello", _($this->help_context = "&Hello World"));

		$this->add_module(_("Transactions"));

		$this->add_module(_("Inquiries and Reports"));

		$this->add_module(_("Maintenance"));

        $this->add_extensions();

	}

}
?>