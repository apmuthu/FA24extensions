<?php

global $reports, $dim;

$reports->addReport(RC_GL, "_fixed_assets",_('&Fixed Assets Report'),
    array(
        _('Start Date') => 'DATEBEGIN',
        _('End Date') => 'DATEEND',
        _('Account') => 'GL_ACCOUNTS',
        _('Dimensions') => 'DIMENSIONS',
        _('Exclude Dimension') => 'YES_NO',
        _('Detail') => 'YES_NO',
        _('Comments') => 'TEXT',
        _('Orientation') => 'ORIENTATION',
        _('Destination') => 'DESTINATION'
));
?>
