# FrontKanban

* [Kanban Projects Management Extension](https://github.com/notrinos/FrontKanban) for [FrontAccounting](http://frontaccounting.com/)
* [FA Forum Discussion Post](http://frontaccounting.com/punbb/viewtopic.php?id=7162)
* [DEMO](http://notrinos.webstarterz.com/act/index.php)

Requirement
-----------
- FrontAccounting 2.4.x

Installation
------------
- Rename folder *FrontKanban-master* to *kanban* then copy folder to the FA modules directory.
- Install and activate the module if you have incorporated the [non-versioned module install fix](http://frontaccounting.com/punbb/viewtopic.php?id=6986).
- Otherwise, do the following:

* Comment out block of codes from lines 215 to 220 of "*admin/inst_module.php*".
* Install and activate the module.
* Uncomment lines 215-220 of "*admin/inst_module.php*".
