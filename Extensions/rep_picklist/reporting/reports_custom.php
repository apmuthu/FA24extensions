<?php

global $reports, $dim;

$reports->addReport(RC_CUSTOMER, "_picklist", _('Print Deliveries Picklist'),
    array(  _('Start Date') => 'DATEBEGINM',
            _('End Date') => 'DATEENDM',
            _('Inventory Category') => 'CATEGORIES',
            _('Stock Location') => 'LOCATIONS',
            _('Back Orders Only') => 'YES_NO',
            _('Comments') => 'TEXTBOX',
            _('Orientation') => 'ORIENTATION',
            _('Destination') => 'DESTINATION'));

