# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 17:05
# Built by FrontAccounting 2.4.RC1
# http://frontaccounting.com
# Company: Training Co.
# User: 

# Compatibility: 2.4.1


SET NAMES utf8;


### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('1', 'Spain', '0');

### Structure of table `0_attachments` ###

DROP TABLE IF EXISTS `0_attachments`;

CREATE TABLE `0_attachments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `type_no` int(11) NOT NULL DEFAULT '0',
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `unique_name` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `filename` varchar(60) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `filetype` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=InnoDB ;

### Data of table `0_attachments` ###


### Structure of table `0_audit_trail` ###

DROP TABLE IF EXISTS `0_audit_trail`;

CREATE TABLE `0_audit_trail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `user` smallint(6) unsigned NOT NULL DEFAULT '0',
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(60) DEFAULT NULL,
  `fiscal_year` int(11) NOT NULL DEFAULT '0',
  `gl_date` date NOT NULL DEFAULT '0000-00-00',
  `gl_seq` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Seq` (`fiscal_year`,`gl_date`,`gl_seq`),
  KEY `Type_and_Number` (`type`,`trans_no`)
) ENGINE=InnoDB ;

### Data of table `0_audit_trail` ###


### Structure of table `0_bank_accounts` ###

DROP TABLE IF EXISTS `0_bank_accounts`;

CREATE TABLE `0_bank_accounts` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_type` smallint(6) NOT NULL DEFAULT '0',
  `bank_account_name` varchar(60) NOT NULL DEFAULT '',
  `bank_account_number` varchar(100) NOT NULL DEFAULT '',
  `bank_name` varchar(60) NOT NULL DEFAULT '',
  `bank_address` tinytext,
  `bank_curr_code` char(3) NOT NULL DEFAULT '',
  `dflt_curr_act` tinyint(1) NOT NULL DEFAULT '0',
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `bank_charge_act` varchar(15) NOT NULL DEFAULT '',
  `last_reconciled_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ending_reconcile_balance` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bank_account_name` (`bank_account_name`),
  KEY `bank_account_number` (`bank_account_number`),
  KEY `account_code` (`account_code`)
) ENGINE=InnoDB ;

### Data of table `0_bank_accounts` ###


### Structure of table `0_bank_trans` ###

DROP TABLE IF EXISTS `0_bank_trans`;

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `bank_act` varchar(15) NOT NULL DEFAULT '',
  `ref` varchar(40) DEFAULT NULL,
  `trans_date` date NOT NULL DEFAULT '0000-00-00',
  `amount` double DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) NOT NULL DEFAULT '0',
  `person_id` tinyblob,
  `reconciled` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bank_act` (`bank_act`,`ref`),
  KEY `type` (`type`,`trans_no`),
  KEY `bank_act_2` (`bank_act`,`reconciled`),
  KEY `bank_act_3` (`bank_act`,`trans_date`)
) ENGINE=InnoDB ;

### Data of table `0_bank_trans` ###


### Structure of table `0_bom` ###

DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` char(20) NOT NULL DEFAULT '',
  `component` char(20) NOT NULL DEFAULT '',
  `workcentre_added` int(11) NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `quantity` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`parent`,`component`,`workcentre_added`,`loc_code`),
  KEY `component` (`component`),
  KEY `id` (`id`),
  KEY `loc_code` (`loc_code`),
  KEY `parent` (`parent`,`loc_code`),
  KEY `workcentre_added` (`workcentre_added`)
) ENGINE=InnoDB ;

### Data of table `0_bom` ###


### Structure of table `0_budget_trans` ###

DROP TABLE IF EXISTS `0_budget_trans`;

CREATE TABLE `0_budget_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `Account` (`account`,`tran_date`,`dimension_id`,`dimension2_id`)
) ENGINE=InnoDB ;

### Data of table `0_budget_trans` ###


### Structure of table `0_chart_class` ###

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
  `cid` varchar(3) NOT NULL,
  `class_name` varchar(60) NOT NULL DEFAULT '',
  `ctype` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB ;

### Data of table `0_chart_class` ###

INSERT INTO `0_chart_class` VALUES
('1', 'Assets', '1', '0'),
('2', 'Liabilities', '2', '0'),
('3', 'Income', '4', '0'),
('4', 'Costs', '6', '0'),
('5', 'Equity', '3', '0');

### Structure of table `0_chart_master` ###

DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_code2` varchar(15) NOT NULL DEFAULT '',
  `account_name` varchar(100) NOT NULL DEFAULT '',
  `account_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB ;

### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES
('100', '100', 'Capital social', '10', '0'),
('101', '101', 'Fondo social', '10', '0'),
('102', '102', 'Capital', '10', '0'),
('103', '103', 'Socios por desembolsos no exigidos', '103', '0'),
('1030', '1030', 'Socios por desembolsos no exigidos capital social', '103', '0'),
('1034', '1034', 'Socios por desembolsos no exigidos capital pendiente de inscripción', '103', '0'),
('104', '104', 'Socios por aportaciones no dinerarias pendientes', '104', '0'),
('1040', '1040', 'Socios por aportaciones no dinerarias pendientes capital social', '104', '0'),
('1044', '1044', 'Socios por aportaciones no dinerarias pendientes capital pendiente de inscripción', '104', '0'),
('108', '108', 'Acciones o participaciones propias en situaciones especiales', '10', '0'),
('109', '109', 'Acciones o participaciones propias para reducción de capital', '10', '0'),
('110', '110', 'Prima de emisión o asunción', '11', '0'),
('112', '112', 'Reserva legal', '11', '0'),
('113', '113', 'Reserva voluntaria', '11', '0'),
('114', '114', 'Reservas especiales', '114', '0'),
('1140', '1140', 'Reservas para acciones o participaciones de la sociedad dominante', '114', '0'),
('1141', '1141', 'Reservas estatutarias', '114', '0'),
('1142', '1142', 'Reservas por capital amortizado', '114', '0'),
('1144', '1144', 'Reservas por acciones propias aceptadas en garantía', '114', '0'),
('118', '118', 'Aportaciones de socios y propietarios', '11', '0'),
('119', '119', 'Diferencias por ajuste del capital a euros', '11', '0'),
('120', '120', 'Remanente', '12', '0'),
('121', '121', 'Resultados negativos de ejercicios anteriores', '12', '0'),
('129', '129', 'Resultado del ejercicio', '12', '0'),
('130', '130', 'Subvenciones oficiales de capital', '13', '0'),
('131', '131', 'Donaciones y legados de capital', '13', '0'),
('132', '132', 'Otras subvenciones donaciones y legados', '13', '0'),
('137', '137', 'Ingresos fiscales a distribuir en varios ejercicios', '137', '0'),
('1370', '1370', 'Ingresos fiscales por diferencias permanentes a distribuir en varios ejercicios', '137', '0'),
('1371', '1371', 'Ingresos fiscales por deducciones y bonificaciones a distribuir en varios ejercicios', '137', '0'),
('140', '140', 'Provisión por retribuciones a largo plazo al personal', '14', '0'),
('141', '141', 'Provisión para impuestos', '14', '0'),
('142', '142', 'Provisión para otras responsabilidades', '14', '0'),
('143', '143', 'Provisión por desmantelamiento retiro o rehabilitación del inmovilizado', '14', '0'),
('145', '145', 'Provisión por actuaciones medioambientales', '14', '0'),
('150', '150', 'Acciones o participaciones a largo plazo consideradas como pasivos financieros', '15', '0'),
('153', '153', 'Desembolsos no exigidos por acciones o participaciones consideradas como pasivos financieros', '153', '0'),
('1533', '1533', 'Desembolsos no exigidos empresas del grupo', '153', '0'),
('1534', '1534', 'Desembolsos no exigidos empresas asociadas', '153', '0'),
('1535', '1535', 'Desembolsos no exigidos otras partes vinculadas', '153', '0'),
('1536', '1536', 'Otros desembolsos no exigidos', '153', '0'),
('154', '154', 'Aportaciones no dinerarias pendientes por acciones o participaciones consideradas como pasivos finan', '154', '0'),
('1543', '1543', 'Aportaciones no dinerarias pendientes empresas del grupo', '154', '0'),
('1544', '1544', 'Aportaciones no dinerarias pendientes empresas asociadas', '154', '0'),
('1545', '1545', 'Aportaciones no dinerarias pendientes otras partes vinculadas', '154', '0'),
('1546', '1546', 'Otras aportaciones no dinerarias pendientes', '154', '0'),
('160', '160', 'Deudas a largo plazo con entidades de crédito vinculadas', '160', '0'),
('1603', '1603', 'Deudas a largo plazo con entidades de crédito empresas del grupo', '160', '0'),
('1604', '1604', 'Deudas a largo plazo con entidades de crédito empresas asociadas', '160', '0'),
('1605', '1605', 'Deudas a largo plazo con otras entidades de crédito vinculadas', '160', '0'),
('161', '161', 'Proveedores de inmovilizado a largo plazo partes vinculadas', '161', '0'),
('1613', '1613', 'Proveedores de inmovilizado a largo plazo empresas del grupo', '161', '0'),
('1614', '1614', 'Proveedores de inmovilizado a largo plazo empresas asociadas', '161', '0'),
('1615', '1615', 'Proveedores de inmovilizado a largo plazo otras partes vinculadas', '161', '0'),
('162', '162', 'Acreedores por arrendamiento financiero a largo plazo partes vinculadas', '162', '0'),
('1623', '1623', 'Acreedores por arrendamiento financiero a largo plazo empresas del grupo', '162', '0'),
('1624', '1624', 'Acreedores por arrendamiento financiero a largo plazo empresas asociadas', '162', '0'),
('1625', '1625', 'Acreedores por arrendamiento financiero a largo plazo otras partes vinculadas', '162', '0'),
('163', '163', 'Otras deudas a largo plazo con partes vinculadas', '163', '0'),
('1633', '1633', 'Otras deudas a largo plazo empresas del grupo', '163', '0'),
('1634', '1634', 'Otras deudas a largo plazo empresas asociadas', '163', '0'),
('1635', '1635', 'Otras deudas a largo plazo con otras partes vinculadas', '163', '0'),
('170', '170', 'Deudas a largo plazo con entidades de crédito', '17', '0'),
('171', '171', 'Deudas a largo plazo', '17', '0'),
('172', '172', 'Deudas a largo plazo transformables en subvenciones donaciones y legados', '17', '0'),
('173', '173', 'Proveedores de inmovilizado a largo plazo', '17', '0'),
('174', '174', 'Acreedores por arrendamiento financiero a largo plazo', '17', '0'),
('175', '175', 'Efectos a pagar a largo plazo', '17', '0'),
('176', '176', 'Pasivos por derivados financieros a largo plazo', '17', '0'),
('177', '177', 'Obligaciones y bonos', '17', '0'),
('179', '179', 'Deudas representadas en otros valores negociables', '17', '0'),
('180', '180', 'Fianzas recibidas a largo plazo', '18', '0'),
('181', '181', 'Anticipos recibidos por ventas o prestaciones de servicios a largo plazo', '18', '0'),
('185', '185', 'Depósitos recibidos a largo plazo', '18', '0'),
('190', '190', 'Acciones o participaciones emitidas', '19', '0'),
('192', '192', 'Subscriptores de acciones', '19', '0'),
('194', '194', 'Capital emitido pendiente de inscripción', '19', '0'),
('195', '195', 'Acciones o participaciones emitidas consideradas como pasivos financieros', '19', '0'),
('197', '197', 'Subscriptores de acciones consideradas como pasivos financieros', '19', '0'),
('199', '199', 'Acciones o participaciones emitidas consideradas como pasivos financieros pendientes de inscripción', '19', '0'),
('200', '200', 'Investigación', '20', '0'),
('201', '201', 'Desarrollo', '20', '0'),
('202', '202', 'Concesiones administrativas', '20', '0'),
('203', '203', 'Propiedad industrial', '20', '0'),
('205', '205', 'Derechos de traspaso', '20', '0'),
('206', '206', 'Aplicaciones informáticas', '20', '0'),
('209', '209', 'Anticipos para inmovilizaciones intangibles', '20', '0'),
('210', '210', 'Terrenos y bienes naturales', '21', '0'),
('211', '211', 'Construcciones', '21', '0'),
('212', '212', 'Instalaciones técnicas', '21', '0'),
('213', '213', 'Maquinaria', '21', '0'),
('214', '214', 'Utillaje', '21', '0'),
('215', '215', 'Otras instalaciones', '21', '0'),
('216', '216', 'Mobiliario', '21', '0'),
('217', '217', 'Equipos para procesos de información', '21', '0'),
('218', '218', 'Elementos de transporte', '21', '0'),
('219', '219', 'Otro inmovilizado material', '21', '0'),
('220', '220', 'Inversiones en terrenos y bienes naturales', '22', '0'),
('221', '221', 'Inversiones en construcciones', '22', '0'),
('230', '230', 'Adaptación de terrenos y bienes naturales', '23', '0'),
('231', '231', 'Construcciones en curso', '23', '0'),
('232', '232', 'Instalaciones técnicas en montaje', '23', '0'),
('233', '233', 'Maquinaria en montaje', '23', '0'),
('237', '237', 'Equipos para proceso de información en montaje', '23', '0'),
('239', '239', 'Anticipos para inmovilizaciones materiales', '23', '0'),
('240', '240', 'Participaciones a largo plazo en partes vinculadas', '240', '0'),
('2403', '2403', 'Participaciones a largo plazo en empresas del grupo', '240', '0'),
('2404', '2404', 'Participaciones a largo plazo en empresas asociadas', '240', '0'),
('2405', '2405', 'Participaciones a largo plazo en otras partes vinculadas', '240', '0'),
('241', '241', 'Valores representativos de deuda a largo plazo de partes vinculadas', '241', '0'),
('2413', '2413', 'Valores representativos de deuda a largo plazo de empresas del grupo', '241', '0'),
('2414', '2414', 'Valores representativos de deuda a largo plazo de empresas asociadas', '241', '0'),
('2415', '2415', 'Valores representativos de deuda a largo plazo de otras partes vinculadas', '241', '0'),
('242', '242', 'Créditos a largo plazo a partes vinculadas', '242', '0'),
('2423', '2423', 'Créditos a largo plazo a empresas del grupo', '242', '0'),
('2424', '2424', 'Créditos a largo plazo a empresas asociadas', '242', '0'),
('2425', '2425', 'Créditos a largo plazo a otras partes vinculadas', '242', '0'),
('249', '249', 'Desembolsos pendientes sobre participaciones a largo plazo en partes vinculadas', '249', '0'),
('2493', '2493', 'Desembolsos pendientes sobre participaciones a largo plazo en empresas del grupo', '249', '0'),
('2494', '2494', 'Desembolsos pendientes sobre participaciones a largo plazo en empresas asociadas', '249', '0'),
('2495', '2495', 'Desembolsos pendientes sobre participaciones a largo plazo en otras partes vinculadas', '249', '0'),
('250', '250', 'Inversiones financieras a largo plazo en instrumentos de patrimonio', '25', '0'),
('251', '251', 'Valores representativos de deuda a largo plazo', '25', '0'),
('252', '252', 'Créditos a largo plazo', '25', '0'),
('253', '253', 'Créditos a largo plazo por enajenación de inmovilizado', '25', '0'),
('254', '254', 'Créditos a largo plazo al personal', '25', '0'),
('255', '255', 'Activos por derivados financieros a largo plazo', '25', '0'),
('258', '258', 'Imposiciones a largo plazo', '25', '0'),
('259', '259', 'Desembolsos pendientes sobre participaciones en el patrimonio neto a largo plazo', '25', '0'),
('260', '260', 'Fianzas constituidas a largo plazo', '26', '0'),
('265', '265', 'Depósitos constituidos a largo plazo', '26', '0'),
('280', '280', 'Amortización acumulada del inmovilizado intangible', '280', '0'),
('2800', '2800', 'Amortización acumulada de investigación', '280', '0'),
('2801', '2801', 'Amortización acumulada de desarrollo', '280', '0'),
('2802', '2802', 'Amortización acumulada de concesiones administrativas', '280', '0'),
('2803', '2803', 'Amortización acumulada de propiedad industrial', '280', '0'),
('2805', '2805', 'Amortización acumulada de derechos de traspaso', '280', '0'),
('2806', '2806', 'Amortización acumulada de aplicaciones informáticas', '280', '0'),
('281', '281', 'Amortización acumulada del inmovilizado material', '281', '0'),
('2811', '2811', 'Amortización acumulada de construcciones', '281', '0'),
('2812', '2812', 'Amortización acumulada de instalaciones técnicas', '281', '0'),
('2813', '2813', 'Amortización acumulada de maquinaria', '281', '0'),
('2814', '2814', 'Amortización acumulada de utillaje', '281', '0'),
('2815', '2815', 'Amortización acumulada de otras instalaciones', '281', '0'),
('2816', '2816', 'Amortización acumulada de mobiliario', '281', '0'),
('2817', '2817', 'Amortización acumulada de equipos para procesos de información', '281', '0'),
('2818', '2818', 'Amortización acumulada de elementos de trasporte', '281', '0'),
('2819', '2819', 'Amortización acumulada de otro inmovilizado material', '281', '0'),
('282', '282', 'Amortización acumulada de las inversiones inmobiliarias', '28', '0'),
('290', '290', 'Deterioro de valor del inmovilizado intangible', '290', '0'),
('2900', '2900', 'Deterioro de valor de investigación', '290', '0'),
('2901', '2901', 'Deterioro del valor de desarrollo', '290', '0'),
('2902', '2902', 'Deterioro de valor de concesiones administrativas', '290', '0'),
('2903', '2903', 'Deterioro de valor de propiedad industrial', '290', '0'),
('2905', '2905', 'Deterioro de valor de derechos de traspaso', '290', '0'),
('2906', '2906', 'Deterioro de valor de aplicaciones informáticas', '290', '0'),
('291', '291', 'Deterioro de valor del inmovilizado material', '291', '0'),
('2910', '2910', 'Deterioro de valor de terrenos y bienes naturales', '291', '0'),
('2911', '2911', 'Deterioro de valor de las construcciones', '291', '0'),
('2912', '2912', 'Deterioro de valor de instalaciones técnicas', '291', '0'),
('2913', '2913', 'Deterioro de valor de maquinaria', '291', '0'),
('2914', '2914', 'Deterioro de valor de utillaje', '291', '0'),
('2915', '2915', 'Deterioro de valor de otras instalaciones materiales', '291', '0'),
('2916', '2916', 'Deterioro de valor de mobiliario', '291', '0'),
('2917', '2917', 'Deterioro de valor de equipos para procesos de información', '291', '0'),
('2918', '2918', 'Deterioro de valor de elementos de transporte', '291', '0'),
('2919', '2919', 'Deterioro de valor de otro inmovilizado material', '291', '0'),
('292', '292', 'Deterioro de valor de las inversiones inmobiliarias', '292', '0'),
('2920', '2920', 'Deterioro de valor de los terrenos y bienes naturales', '292', '0'),
('2921', '2921', 'Deterioro de valor de construcciones', '292', '0'),
('293', '293', 'Deterioro de valor de participaciones a largo plazo en partes vinculadas', '293', '0'),
('2933', '2933', 'Deterioro de valor de participaciones a largo plazo en empresas del grupo', '293', '0'),
('2934', '2934', 'Deterioro de valor de participaciones a largo plazo en empresas asociadas', '293', '0'),
('2935', '2935', 'Deterioro de valor de participaciones a largo plazo en otras partes vinculadas', '293', '0'),
('294', '294', 'Deterioro de valores representativos de deuda a largo plazo en otras partes vinculadas', '294', '0'),
('2943', '2943', 'Deterioro de valores representativos de deuda a largo plazo de empresas del grupo', '294', '0'),
('2944', '2944', 'Deterioro de valores representativos de deuda a largo plazo de empresas asociadas', '294', '0'),
('2945', '2945', 'Deterioro de valores representativos de deuda a largo plazo de otras partes vinculadas', '294', '0'),
('295', '295', 'Deterioro de valor de créditos a largo plazo a partes vinculadas', '295', '0'),
('2953', '2953', 'Deterioro de valor de créditos a largo plazo a empresas del grupo', '295', '0'),
('2954', '2954', 'Deterioro de valor de créditos a largo plazo a empresas asociadas', '295', '0'),
('2955', '2955', 'Deterioro de valor de créditos a largo plazo a otras partes vinculadas', '295', '0'),
('297', '297', 'Deterioro de valor de valores representativos de deuda a largo plazo', '29', '0'),
('298', '298', 'Deterioro de valor de créditos a largo plazo', '29', '0'),
('300', '300', 'Mercaderías A', '30', '0'),
('301', '301', 'Mercaderías B', '30', '0'),
('310', '310', 'Materias primas A', '31', '0'),
('311', '311', 'Materias primas B', '31', '0'),
('320', '320', 'Elementos y conjuntos incorporables', '32', '0'),
('321', '321', 'Combustibles', '32', '0'),
('322', '322', 'Repuestos', '32', '0'),
('325', '325', 'Materiales diversos', '32', '0'),
('326', '326', 'Embalajes', '32', '0'),
('327', '327', 'Envases', '32', '0'),
('328', '328', 'Material de oficina', '32', '0'),
('330', '330', 'Productos en curso A', '33', '0'),
('331', '331', 'Productos en curso B', '33', '0'),
('340', '340', 'Productos semiterminados A', '34', '0'),
('341', '341', 'Productos semiterminados B', '34', '0'),
('350', '350', 'Productos terminados A', '35', '0'),
('351', '351', 'Productos terminados B', '35', '0'),
('360', '360', 'Subproductos A', '36', '0'),
('361', '361', 'Subproductos B', '36', '0'),
('365', '365', 'Residuos A', '36', '0'),
('366', '366', 'Residuos B', '36', '0'),
('368', '368', 'Materiales recuperados A', '36', '0'),
('369', '369', 'Materiales recuperados B', '36', '0'),
('390', '390', 'Deterioro de valor de las mercaderías', '39', '0'),
('391', '391', 'Deterioro de valor de las materias primas', '39', '0'),
('392', '392', 'Deterioro de valor de otros aprovisionamientos', '39', '0'),
('393', '393', 'Deterioro de valor de los productos en curso', '39', '0'),
('394', '394', 'Deterioro de valor de los productos semiterminados', '39', '0'),
('395', '395', 'Deterioro de valor de los productos terminados', '39', '0'),
('396', '396', 'Deterioro de valor de los subproductos residuo y materiales recuperados', '39', '0'),
('400', '400', 'Proveedores', '400', '0'),
('4000', '4000', 'Proveedores (euros)', '400', '0'),
('4004', '4004', 'Proveedores (moneda extranjera)', '400', '0'),
('4009', '4009', 'Proveedores facturas pendientes de recibir o de formalizar', '400', '0'),
('401', '401', 'Proveedores efectos comerciales a pagar', '40', '0'),
('403', '403', 'Proveedores empresas del grupo', '403', '0'),
('4030', '4030', 'Proveedores empresas del grupo (euros)', '403', '0'),
('4031', '4031', 'Efectos comerciales a pagar empresas del grupo', '403', '0'),
('4034', '4034', 'Proveedores empresas del grupo (moneda extranjera)', '403', '0'),
('4036', '4036', 'Envases y embalajes a devolver a proveedores empresas del grupo', '403', '0'),
('4039', '4039', 'Proveedores empresas del grupo facturas pendientes de recibir o de formalizar', '403', '0'),
('404', '404', 'Proveedores empresas asociadas', '40', '0'),
('405', '405', 'Proveedores otras partes vinculadas', '40', '0'),
('406', '406', 'Envases y embalajes a devolver a proveedores', '40', '0'),
('407', '407', 'Anticipos a proveedores', '40', '0'),
('410', '410', 'Acreedores por prestación de servicio', '410', '0'),
('4100', '4100', 'Acreedores por prestaciones de servicios (euros)', '410', '0'),
('4104', '4104', 'Acreedores por prestaciones de servicios (moneda extranjera)', '410', '0'),
('4109', '4109', 'Acreedores por prestaciones de servicios facturas pendientes de recibir o formalizar', '410', '0'),
('411', '411', 'Acreedores efectos comerciales a cobrar', '41', '0'),
('419', '419', 'Acreedores por operaciones en común', '41', '0'),
('430', '430', 'Clientes', '430', '0'),
('4300', '4300', 'Clientes (euros)', '430', '0'),
('43001', '43001', 'Clientes de Servicios (Euros)', '430', '0'),
('4304', '4304', 'Clientes (moneda extranjera)', '430', '0'),
('4309', '4309', 'Clientes facturas pendientes de formalizar', '430', '0'),
('431', '431', 'Clientes efectos comerciales a cobrar', '431', '0'),
('4310', '4310', 'Efectos comerciales en cartera', '431', '0'),
('4311', '4311', 'Efectos comerciales descontados', '431', '0'),
('4312', '4312', 'Efectos comerciales en gestión de cobro', '431', '0'),
('4315', '4315', 'Efectos comerciales impagados', '431', '0'),
('432', '432', 'Clientes operaciones de factoring', '43', '0'),
('433', '433', 'Clientes empresas del grupo', '433', '0'),
('4330', '4330', 'Clientes empresas del grupo (euros)', '433', '0'),
('4331', '4331', 'Efectos comerciales a cobrar empresas del grupo', '433', '0'),
('4332', '4332', 'Clientes empresas del grupo operaciones de factoring', '433', '0'),
('4334', '4334', 'Clientes empresas del grupo (moneda extranjera)', '433', '0'),
('4336', '4336', 'Clientes empresas del grupo de dudoso cobro', '433', '0'),
('4337', '4337', 'Envases y embalajes a devolver a clientes empresas del grupo', '433', '0'),
('4339', '4339', 'Clientes empresas del grupo facturas pendientes de formalizar', '433', '0'),
('434', '434', 'Clientes empresas asociadas', '43', '0'),
('435', '435', 'Clientes otras partes vinculadas', '43', '0'),
('436', '436', 'Clientes de dudoso cobro', '43', '0'),
('437', '437', 'Envases y embalajes a devolver por clientes', '43', '0'),
('438', '438', 'Anticipos de clientes', '438', '0'),
('440', '440', 'Deudores', '440', '0'),
('4400', '4400', 'Deudores (euros)', '440', '0'),
('4404', '4404', 'Deudores (moneda extranjera)', '440', '0'),
('4409', '4409', 'Deudores facturas pendientes de formalizar', '440', '0'),
('441', '441', 'Deudores efectos comerciales a cobrar', '441', '0'),
('4410', '4410', 'Deudores efectos comerciales en cartera', '441', '0'),
('4411', '4411', 'Deudores efectos comerciales descontados', '441', '0'),
('4412', '4412', 'Deudores efectos comerciales en gestión de cobro', '441', '0'),
('4415', '4415', 'Deudores efectos comerciales impagados', '441', '0'),
('446', '446', 'Deudores de dudoso cobro', '44', '0'),
('449', '449', 'Deudores por operaciones en común', '44', '0'),
('460', '460', 'Anticipos de remuneraciones', '46', '0'),
('465', '465', 'Remuneraciones pendientes de pago', '465', '0'),
('470', '470', 'Hacienda Publica deudora por diversos conceptos', '470', '0'),
('4700', '4700', 'Hacienda Publica deudora por iva', '470', '0'),
('4708', '4708', 'Hacienda Publica deudora por subvenciones concedidas', '470', '0'),
('4709', '4709', 'Hacienda Publica deudora por devolución de impuestos', '470', '0'),
('471', '471', 'Organismos de la Seguridad Social deudores', '47', '0'),
('472', '472', 'Hacienda Publica IVA soportado', '47', '0'),
('47204', '47204', 'Hacienda Publica IVA soportado  4%', '472', '0'),
('47207', '47207', 'Hacienda Publica IVA soportado  7%', '472', '0'),
('47208', '47208', 'Hacienda Publica IVA soportado  8%', '472', '0'),
('47210', '47210', 'Hacienda Publica IVA soportado 10%', '472', '0'),
('47216', '47216', 'Hacienda Publica IVA soportado 16%', '472', '0'),
('47218', '47218', 'Hacienda Publica IVA soportado 18%', '472', '0'),
('47221', '47221', 'Hacienda Publica IVA soportado 21%', '472', '0'),
('473', '473', 'Hacienda publica retenciones y pagos a cuenta', '47', '0'),
('474', '474', 'Activos por impuesto diferido', '474', '0'),
('4740', '4740', 'Activos por diferencias temporarias deducibles', '474', '0'),
('4742', '4742', 'Derechos por deducciones y bonificaciones pendientes de aplicar', '474', '0'),
('4745', '4745', 'Crédito por pérdidas a compensar del ejercicio', '474', '0'),
('475', '475', 'Hacienda publica acreedora por conceptos fiscales', '475', '0'),
('4750', '4750', 'Hacienda publica acreedora por IVA', '475', '0'),
('4751', '4751', 'Hacienda Publica acreedora por retenciones practicadas', '475', '0'),
('4752', '4752', 'Hacienda Publica acreedora por impuesto sobre sociedades', '475', '0'),
('4758', '4758', 'Hacienda Publica acreedora por subvenciones a reintegrar', '475', '0'),
('476', '476', 'Organismos de las Seguridad Social acreedores', '476', '0'),
('477', '477', 'Hacienda Publica IVA Repercutido', '477', '0'),
('47704', '47704', 'Hacienda Publica IVA Repercutido  4%', '477', '0'),
('47707', '47707', 'Hacienda Publica IVA Repercutido  7%', '477', '0'),
('47708', '47708', 'Hacienda Publica IVA Repercutido  8%', '477', '0'),
('47710', '47710', 'Hacienda Publica IVA Repercutido 10%', '477', '0'),
('47716', '47716', 'Hacienda Publica IVA Repercutido 16%', '477', '0'),
('47718', '47718', 'Hacienda Publica IVA Repercutido 18%', '477', '0'),
('47721', '47721', 'Hacienda Publica IVA Repercutido 21%', '477', '0'),
('479', '479', 'Pasivos por diferencias temporarias imponibles', '479', '0'),
('480', '480', 'Gastos anticipados', '48', '0'),
('485', '485', 'Ingresos anticipados', '485', '0'),
('490', '490', 'Deterioro de valor de créditos por operaciones comerciales', '49', '0'),
('493', '493', 'Deterioro de valor de créditos por operaciones comerciales con partes vinculadas', '493', '0'),
('4933', '4933', 'Deterioro de valor de créditos por operaciones comerciales con empresas del grupo', '493', '0'),
('4934', '4934', 'Deterioro de valor de créditos por operaciones comerciales con empresas asociadas', '493', '0'),
('4935', '4935', 'Deterioro de valor de créditos por operaciones comerciales con otras partes vinculadas', '493', '0'),
('499', '499', 'Provisión para operaciones comerciales', '499', '0'),
('4994', '4994', 'Provisión por contratos onerosos', '499', '0'),
('4999', '4999', 'Provisión para otras operaciones comerciales', '499', '0'),
('500', '500', 'Obligaciones y bonos a corto plazo', '50', '0'),
('502', '502', 'Acciones o participaciones a corto plazo consideradas como pasivos financieros', '50', '0'),
('505', '505', 'Deudas representadas en otros valores negociables a plazo', '50', '0'),
('506', '506', 'Intereses de empréstitos y otras emisiones análogas', '50', '0'),
('507', '507', 'Dividendos de emisiones consideradas como pasivos financieros', '50', '0'),
('509', '509', 'Valores negociables amortizados', '509', '0'),
('5090', '5090', 'Obligaciones y bonos amortizados', '509', '0'),
('5095', '5095', 'Otros valores negociables amortizados', '509', '0'),
('510', '510', 'Deudas a corto plazo con entidades de crédito vinculadas', '510', '0'),
('5103', '5103', 'Deudas a corto plazo con entidades de crédito empresas del grupo', '510', '0'),
('5104', '5104', 'Deudas a corto plazo con entidades de crédito empresas asociados', '510', '0'),
('5105', '5105', 'Deudas a corto plazo con otras entidades de crédito vinculadas', '510', '0'),
('511', '511', 'Proveedores de inmovilizado a corto plazo partes vinculadas', '511', '0'),
('5113', '5113', 'Proveedores de inmovilizado a corto plazo empresas del grupo', '511', '0'),
('5114', '5114', 'Proveedores de inmovilizado a corto plazo empresas asociadas', '511', '0'),
('5115', '5115', 'Proveedores de inmovilizado a corto plazo otras partes vinculadas', '511', '0'),
('512', '512', 'Acreedores por arrendamiento financiero a corto plazo partes vinculadas', '512', '0'),
('5123', '5123', 'Acreedores por arrendamiento financiero a corto plazo empresas del grupo', '512', '0'),
('5124', '5124', 'Acreedores por arrendamiento financiero a corto plazo empresas asociadas', '512', '0'),
('5125', '5125', 'Acreedores por arrendamiento financiero a corto plazo con otras partes vinculadas', '512', '0'),
('513', '513', 'Otras deudas a corto plazo con partes vinculadas', '513', '0'),
('5133', '5133', 'Otras deudas a corto plazo con empresas del grupo', '513', '0'),
('5134', '5134', 'Otras deudas a corto plazo con empresas asociadas', '513', '0'),
('5135', '5135', 'Otras deudas a corto plazo con otras partes vinculadas', '513', '0'),
('514', '514', 'Intereses a corto plazo de deudas con partes vinculadas', '514', '0'),
('5143', '5143', 'Intereses a corto plazo de deudas empresas del grupo', '514', '0'),
('5144', '5144', 'Intereses a corto plazo de deudas empresas asociadas', '514', '0'),
('5145', '5145', 'Intereses a corto plazo de deudas otras partes vinculadas', '514', '0'),
('520', '520', 'Deudas a corto plazo con entidades de crédito', '520', '0'),
('5200', '5200', 'Prestamos a corto plazo de entidades de crédito', '520', '0'),
('5201', '5201', 'Deudas a corto plazo por crédito dispuesto', '520', '0'),
('5208', '5208', 'Deudas por efectos descontados', '520', '0'),
('5209', '5209', 'Deudas por operaciones de factoring', '520', '0'),
('521', '521', 'Deudas a corto plazo', '52', '0'),
('522', '522', 'Deudas a corto plazo transformables en subvenciones donaciones y legados', '52', '0'),
('523', '523', 'Proveedores de inmovilizado a corto plazo', '52', '0'),
('524', '524', 'Acreedores por arrendamiento financiero a corto plazo', '52', '0'),
('525', '525', 'Efectos a pagar a corto plazo', '52', '0'),
('526', '526', 'Dividendo activo a pagar', '52', '0'),
('527', '527', 'Intereses a corto plazo de deudas con entidades de crédito', '52', '0'),
('528', '528', 'Intereses a corto plazo de deudas', '52', '0'),
('529', '529', 'Provisiones a corto plazo', '529', '0'),
('5291', '5291', 'Provisión a corto plazo para impuestos', '529', '0'),
('5292', '5292', 'Provisión a corto plazo para otras responsabilidades', '529', '0'),
('5293', '5293', 'Provisión a corto plazo por desmantelamiento retiro o rehabilitación de inmovilizado', '529', '0'),
('5295', '5295', 'Provisión a corto plazo para actuaciones medioambientales', '529', '0'),
('530', '530', 'Participaciones a corto plazo en partes vinculadas', '530', '0'),
('5303', '5303', 'Participaciones a corto plazo en empresas del grupo', '530', '0'),
('5304', '5304', 'Participaciones a corto plazo en empresas asociadas', '530', '0'),
('5305', '5305', 'Participaciones a corto plazo en otras partes vinculadas', '530', '0'),
('531', '531', 'Valores representativos de deuda a corto plazo de partes vinculadas', '531', '0'),
('5313', '5313', 'Valores representativos de deuda a corto plazo de empresas del grupo', '531', '0'),
('5314', '5314', 'Valores representativos de deuda corto plazo de empresas asociadas', '531', '0'),
('5315', '5315', 'Valores representativos de deuda a corto plazo de otras partes vinculadas', '531', '0'),
('532', '532', 'Créditos a corto plazo a partes vinculadas', '532', '0'),
('5323', '5323', 'Créditos a corto plazo a empresas del grupo', '532', '0'),
('5324', '5324', 'Créditos a corto plazo a empresas asociadas', '532', '0'),
('5325', '5325', 'Créditos a corto plazo a a otras partes vinculadas', '532', '0'),
('533', '533', 'Intereses a corto plazo de valores representativos de deuda de empresas de partes vinculadas', '533', '0'),
('5333', '5333', 'Intereses a corto plazo de valores representativos de deuda de empresas del grupo', '533', '0'),
('5334', '5334', 'Intereses a corto plazo de valores representativos de deuda de empresas asociadas', '533', '0'),
('5335', '5335', 'Intereses a corto plazo de valores representativos de deuda de otras partes vinculadas', '533', '0'),
('534', '534', 'Intereses a corto plazo de créditos a partes vinculadas', '534', '0'),
('5343', '5343', 'Intereses a corto plazo de créditos a empresas del grupo', '534', '0'),
('5344', '5344', 'Intereses a corto plazo de créditos a empresas asociadas', '534', '0'),
('5345', '5345', 'Intereses a corto plazo de créditos a otras partes vinculadas', '534', '0'),
('535', '535', 'Dividendo a cobrar de inversiones financieras en partes vinculadas', '535', '0'),
('5353', '5353', 'Dividendo a cobrar de empresas del grupo', '535', '0'),
('5354', '5354', 'Dividendo a cobrar de empresas asociadas', '535', '0'),
('5355', '5355', 'Dividendo a cobrar de otras partes vinculadas', '535', '0'),
('539', '539', 'Desembolsos pendientes sobre participaciones a corto plazo en partes vinculadas', '539', '0'),
('5393', '5393', 'Desembolsos pendientes sobre participaciones a corto plazo en empresas del grupo', '539', '0'),
('5394', '5394', 'Desembolsos pendientes sobre participaciones a corto plazo en empresas asociadas', '539', '0'),
('5395', '5395', 'Desembolsos pendientes sobre participaciones a corto plazo en otras partes vinculadas', '539', '0'),
('540', '540', 'Inversiones financieras a corto plazo en instrumentos del patrimonio', '54', '0'),
('541', '541', 'Valores representativos de deuda a corto plazo', '54', '0'),
('542', '542', 'Créditos a corto plazo', '54', '0'),
('543', '543', 'Créditos a corto plazo por enajenación de inmovilizado', '54', '0'),
('544', '544', 'Créditos a corto plazo al personal', '54', '0'),
('545', '545', 'Dividendo a cobrar', '54', '0'),
('546', '546', 'Intereses a corto plazo de valores representativos de deuda', '54', '0'),
('547', '547', 'Intereses a corto plazo de creditos', '54', '0'),
('548', '548', 'Imposiciones a corto plazo', '54', '0'),
('549', '549', 'Desembolsos pendientes sobre participaciones en el patrimonio neto a corto plazo', '54', '0'),
('550', '550', 'Titular de la explotación', '55', '0'),
('551', '551', 'Cuenta corriente con socios y administradores', '55', '0'),
('552', '552', 'Cuenta corriente con otras personas y entidades vinculadas', '552', '0'),
('5523', '5523', 'Cuenta corriente con empresas del grupo', '552', '0'),
('5524', '5524', 'Cuenta corriente con empresas asociadas', '552', '0'),
('5525', '5525', 'Cuenta corriente con otras partes vinculadas', '552', '0'),
('554', '554', 'Cuenta corriente con uniones temporales de empresas y comunidades de bienes', '55', '0'),
('555', '555', 'Partidas pendientes de aplicación', '555', '0'),
('55501', '55501', 'Partidas pendientes de aplicación ingreso en banco sin identificar', '55', '0'),
('55502', '55502', 'Diferencias en arqueo de caja', '55', '0'),
('55503', '55503', 'Partidas pendientes de aplicación pagos por caja sin identificar', '55', '0'),
('55504', '55504', 'Partidas pendientes de aplicación cobros por caja sin identificar', '55', '0'),
('55505', '55505', 'Partidas pendientes de aplicación por falta de asignación de contrapartida', '55', '0'),
('55509', '55509', 'Otras partidas pdtes. de aplicación', '55', '0'),
('556', '556', 'Desembolsos exigidos sobre participaciones en el patrimonio neto', '556', '0'),
('5563', '5563', 'Desembolsos exigidos sobre participaciones empresas del grupo', '556', '0'),
('5564', '5564', 'Desembolsos exigidos sobre participaciones empresas asociadas', '556', '0'),
('5565', '5565', 'Desembolsos exigidos sobre participaciones otras partes vinculadas', '556', '0'),
('5566', '5566', 'Desembolsos exigidos sobre participaciones de otras empresas', '556', '0'),
('557', '557', 'Dividendo activo a cuenta', '557', '0'),
('558', '558', 'Socios por desembolsos exigidos', '558', '0'),
('5580', '5580', 'Socios por desembolsos exigidos sobre acciones o participaciones ordinarias', '558', '0'),
('5585', '5585', 'Socios por desembolsos exigidos sobre acciones o participaciones consideradas como pasivos financier', '558', '0'),
('559', '559', 'Derivados financieros a corto plazo', '559', '0'),
('5590', '5590', 'Activos por derivados financieros a corto plazo cartera de negociación', '559', '0'),
('5595', '5595', 'Pasivos por derivados financieros a corto plazo cartera de negociación', '5595', '0'),
('560', '560', 'Fianzas recibidas a corto plazo', '560', '0'),
('561', '561', 'Depósitos recibidos a corto plazo', '561', '0'),
('565', '565', 'Fianzas constituidas a corto plazo', '56', '0'),
('566', '566', 'Depósitos constituidos a corto plazo', '56', '0'),
('567', '567', 'Intereses pagados por anticipado', '56', '0'),
('568', '568', 'Intereses cobrados por anticipado', '568', '0'),
('570', '570', 'Caja Euros', '57', '0'),
('5701', '5701', 'Cuenta puente para pagos en efectivo por caja', '57', '0'),
('571', '571', 'Caja moneda extranjera', '57', '0'),
('572', '572', 'Bancos e instituciones de crédito CC vista euros', '57', '0'),
('573', '573', 'Bancos e instituciones de crédito CC moneda extranjera', '57', '0'),
('574', '574', 'Bancos e instituciones de créditos cuentas ahorro euros', '57', '0'),
('575', '575', 'Bancos e instituciones de crédito cuentas de ahorro moneda extranjera', '57', '0'),
('576', '576', 'Inversiones a corto plazo de gran liquidez', '57', '0'),
('593', '593', 'Deterioro de valor de participaciones a corto plazo en partes vinculadas', '593', '0'),
('5933', '5933', 'Deterioro de valor de participaciones a corto plazo empresas del grupo', '593', '0'),
('5934', '5934', 'Deterioro de valor de participaciones a corto plazo en empresas asociadas', '593', '0'),
('5935', '5935', 'Deterioro de valor de participaciones a corto plazo en otras partes vinculadas', '593', '0'),
('594', '594', 'Deterioro de valor de valores representativos de deuda a corto plazo de partes vinculadas', '594', '0'),
('5943', '5943', 'Deterioro de valor de valores representativos de deuda a corto plazo de empresas del grupo', '594', '0'),
('5944', '5944', 'Deterioro de valor de valores representativos de deuda a corto plazo de empresas asociadas', '594', '0'),
('5945', '5945', 'Deterioro de valor de valores representativos de deuda a corto plazo de otras partes vinculadas', '594', '0'),
('595', '595', 'Deterioro de valor de créditos a corto plazo a partes vinculadas', '595', '0'),
('5953', '5953', 'Deterioro de valor de créditos a corto plazo a empresas del grupo', '595', '0'),
('5954', '5954', 'Deterioro de valor de créditos a corto plazo a empresas asociadas', '595', '0'),
('5955', '5955', 'Deterioro de valor de créditos a corto plazo a otras partes vinculadas', '595', '0'),
('596', '596', 'Deterioro de valor de participaciones a corto plazo', '59', '0'),
('597', '597', 'Deterioro de valor de valores representativos de deuda a corto plazo', '59', '0'),
('598', '598', 'Deterioro de valor de créditos a corto plazo', '59', '0'),
('600', '600', 'Compras de mercaderías', '60', '0'),
('601', '601', 'Compras de materias primas', '60', '0'),
('602', '602', 'Compras de otros aprovisionamientos', '60', '0'),
('606', '606', 'Descuento sobre compras por pronto pago', '606', '0'),
('6060', '6060', 'Descuentos sobre compras por pronto pago de mercaderías', '606', '0'),
('6061', '6061', 'Descuentos sobre compras por pronto pago de materias primas', '606', '0'),
('6062', '6062', 'Descuentos sobre compras por pronto pago de otros aprovisionamientos', '606', '0'),
('607', '607', 'Trabajos realizados por otras empresas', '60', '0'),
('608', '608', 'Devoluciones de compras y operaciones similares', '608', '0'),
('6080', '6080', 'Devoluciones de compras de mercaderías', '608', '0'),
('6081', '6081', 'Devoluciones de compras de materias primas', '608', '0'),
('6082', '6082', 'Devoluciones de compras de otros aprovisionamientos', '608', '0'),
('609', '609', 'Rappels por compras', '609', '0'),
('6090', '6090', 'Rappels por compras de mercaderías', '609', '0'),
('6091', '6091', 'Rappels por compras de materias primas', '609', '0'),
('6092', '6092', 'Rappels por compras de otros aprovisionamientos', '609', '0'),
('610', '610', 'Variación de existencias de mercaderías', '61', '0'),
('611', '611', 'Variación de existencias de materias primas', '61', '0'),
('612', '612', 'Variación de existencias de otros aprovisionamientos', '61', '0'),
('620', '620', 'Gastos en investigación y desarrollo del ejercicio', '62', '0'),
('621', '621', 'Arrendamientos y cánones', '62', '0'),
('622', '622', 'Reparaciones y conservación', '62', '0'),
('623', '623', 'Servicios de profesionales independientes', '62', '0'),
('624', '624', 'Transportes', '62', '0'),
('625', '625', 'Primas de seguros', '62', '0'),
('626', '626', 'Servicios bancarios y similares', '62', '0'),
('627', '627', 'Publicidad propaganda y relaciones publicas', '62', '0'),
('628', '628', 'Suministros', '62', '0'),
('629', '629', 'Otros servicios', '62', '0'),
('630', '630', 'Impuesto sobre beneficios', '630', '0'),
('6300', '6300', 'Impuesto corriente', '630', '0'),
('6301', '6301', 'Impuesto diferido', '630', '0'),
('631', '631', 'Otros tributos', '63', '0'),
('633', '633', 'Ajustes negativos en la imposición sobre beneficios', '63', '0'),
('634', '634', 'Ajustes negativos en la imposición indirecta', '634', '0'),
('6341', '6341', 'Ajustes negativos en IVA de activo corriente', '634', '0'),
('6342', '6342', 'Ajustes negativos en IVA de inversiones', '634', '0'),
('636', '636', 'Devolución de impuestos', '63', '0'),
('638', '638', 'Ajustes positivos en la imposición sobre beneficios', '63', '0'),
('639', '639', 'Ajustes positivos en la imposición indirecta', '639', '0'),
('6391', '6391', 'Ajustes positivos en IVA de activo corriente', '639', '0'),
('6392', '6392', 'Ajustes positivos en IVA de inversiones', '639', '0'),
('640', '640', 'Sueldos y salarios', '64', '0'),
('641', '641', 'Indemnizaciones', '64', '0'),
('642', '642', 'Seguridad social a cargo de la empresa', '64', '0'),
('649', '649', 'Otros gastos sociales', '64', '0'),
('650', '650', 'Pérdidas de créditos comerciales incobrables', '65', '0'),
('651', '651', 'Resultados de operaciones en común', '651', '0'),
('6510', '6510', 'Beneficio trasferido (gestor)', '651', '0'),
('6511', '6511', 'Pérdida soportada (participe o asociado no gestor)', '651', '0'),
('659', '659', 'Otras pérdidas de Gestión corriente', '65', '0'),
('660', '660', 'Gastos financieros por actualización de provisiones', '66', '0'),
('661', '661', 'Intereses de obligaciones y bonos', '661', '0'),
('6610', '6610', 'Intereses de obligaciones y bonos a largo plazo empresas del grupo', '661', '0'),
('6611', '6611', 'Intereses de obligaciones y bonos a largo plazo empresas asociadas', '661', '0'),
('6612', '6612', 'Intereses de obligaciones y bonos a largo plazo otras partes vinculadas', '661', '0'),
('6613', '6613', 'Intereses de obligaciones y bonos a largo plazo otras empresas', '661', '0'),
('6615', '6615', 'Intereses de obligaciones y bonos a corto plazo empresas del grupo', '661', '0'),
('6616', '6616', 'Intereses de obligaciones y bonos a corto plazo empresas asociadas', '661', '0'),
('6617', '6617', 'Intereses de obligaciones y bonos a corto plazo otras partes vinculadas', '661', '0'),
('6618', '6618', 'Intereses de obligaciones y bonos a corto plazo otras empresas', '661', '0'),
('662', '662', 'Intereses de deudas', '662', '0'),
('6620', '6620', 'Intereses de deudas empresas del grupo', '662', '0'),
('6621', '6621', 'Intereses de deudas empresas asociadas', '662', '0'),
('6622', '6622', 'Intereses de deudas otras partes vinculadas', '662', '0'),
('6623', '6623', 'Intereses de deudas con entidades de crédito', '662', '0'),
('6624', '6624', 'Intereses de deudas otras empresas', '662', '0'),
('663', '663', 'Pérdidas por valoración de instrumentos financieros por su valor razonable', '66', '0'),
('664', '664', 'Dividendos de acciones o participaciones contabilizadas como pasivos', '664', '0'),
('6640', '6640', 'Dividendos de pasivos empresas del grupo', '664', '0'),
('6641', '6641', 'Dividendos de pasivos empresas asociadas', '664', '0'),
('6642', '6642', 'Dividendos de pasivos otras partes vinculadas', '664', '0'),
('6643', '6643', 'Dividendos de pasivos otras empresas', '664', '0'),
('665', '665', 'Intereses por descuento de efectos y operaciones de factoring', '665', '0'),
('6650', '6650', 'Intereses por descuento de efectos en entidades de crédito del grupo', '665', '0'),
('6651', '6651', 'Intereses por descuento de efectos en entidades de crédito asociadas', '665', '0'),
('6652', '6652', 'Intereses por descuento de efectos en otras entidades de crédito vinculadas', '665', '0'),
('6653', '6653', 'Intereses por descuento de efectos en otras entidades de crédito', '665', '0'),
('6654', '6654', 'Intereses por operaciones de factoring con entidades de crédito del grupo', '665', '0'),
('6655', '6655', 'Intereses por operaciones de factoring con entidades de crédito asociadas', '665', '0'),
('6656', '6656', 'Intereses por operaciones de factoring con entidades de crédito vinculadas', '665', '0'),
('6657', '6657', 'Intereses por operaciones de factoring con otras entidades de crédito', '665', '0'),
('666', '666', 'Pérdidas en participaciones y valores representativos de deuda', '666', '0'),
('6660', '6660', 'Pérdidas en valores representativos de deuda a largo plazo empresas del grupo', '666', '0'),
('6661', '6661', 'Pérdidas en valores representativos de deuda a largo plazo empresas asociadas', '666', '0'),
('6662', '6662', 'Pérdidas en valores representativos de deuda a largo plazo otras partes vinculadas', '666', '0'),
('6663', '6663', 'Pérdidas en participaciones y valores representativos de deuda a largo plazo otras empresas', '666', '0'),
('6665', '6665', 'Pérdidas en participaciones y valores representativos de deuda a corto plazo empresas del grupo', '666', '0'),
('6666', '6666', 'Pérdidas en participaciones y valores representativos de deuda a corto plazo empresas asociadas', '666', '0'),
('6667', '6667', 'Pérdidas en participaciones y valores representativos de deuda a corto plazo otras partes vinculada', '666', '0'),
('6668', '6668', 'Pérdidas en participaciones y valores representativos de deuda a corto plazo otras empresas', '666', '0'),
('667', '667', 'Pérdidas de créditos no comerciales', '667', '0'),
('6670', '6670', 'Pérdidas de créditos a largo plazo empresas del grupo', '667', '0'),
('6671', '6671', 'Pérdidas de créditos a largo plazo empresas asociadas', '667', '0'),
('6672', '6672', 'Pérdidas de créditos a largo plazo otras partes vinculadas', '667', '0'),
('6673', '6673', 'Pérdidas de créditos a largo plazo otras empresas', '667', '0'),
('6675', '6675', 'Pérdidas de créditos a corto plazo empresas del grupo', '667', '0'),
('6676', '6676', 'Pérdidas de créditos a corto plazo empresas asociadas', '667', '0'),
('6677', '6677', 'Pérdidas de créditos a corto plazo otras partes vinculadas', '667', '0'),
('6678', '6678', 'Pérdidas de créditos a corto plazo otras empresas', '667', '0'),
('668', '668', 'Diferencias negativas de cambio', '66', '0'),
('669', '669', 'Otros gastos financieros', '66', '0'),
('670', '670', 'Pérdidas procedentes del inmovilizado intangible', '67', '0'),
('671', '671', 'Pérdidas procedentes del inmovilizado material', '67', '0'),
('672', '672', 'Pérdidas procedentes de inversiones inmobiliarias', '67', '0'),
('673', '673', 'Pérdidas procedentes de participaciones a largo plazo en partes vinculadas', '673', '0'),
('6733', '6733', 'Pérdidas procedentes de participaciones a largo plazo empresas del grupo', '673', '0'),
('6734', '6734', 'Pérdidas procedentes de participaciones a largo plazo empresas asociadas', '673', '0'),
('6735', '6735', 'Pérdidas procedentes de participaciones a largo plazo otras partes vinculadas', '673', '0'),
('675', '675', 'Pérdidas por operaciones con obligaciones propias', '67', '0'),
('678', '678', 'Gastos excepcionales', '67', '0'),
('680', '680', 'Amortización del inmovilizado intangible', '68', '0'),
('681', '681', 'Amortización del inmovilizado material', '68', '0'),
('682', '682', 'Amortización de las inversiones inmobiliarias', '68', '0'),
('690', '690', 'Pérdidas por deterioro del inmovilizado intangible', '69', '0'),
('691', '691', 'Pérdidas por deterioro del inmovilizado material', '69', '0'),
('692', '692', 'Pérdidas por deterioro de las inversiones inmobiliarias', '69', '0'),
('693', '693', 'Pérdidas por deterioro de existencias', '693', '0'),
('6930', '6930', 'Pérdidas por deterioro de productos terminados y en curso de fabricación', '693', '0'),
('6931', '6931', 'Pérdidas por deterioro de mercaderías', '693', '0'),
('6932', '6932', 'Pérdidas por deterioro de materias primas', '693', '0'),
('6933', '6933', 'Pérdidas por deterioro de otros aprovisionamientos', '693', '0'),
('694', '694', 'Pérdidas por deterioro de créditos por operaciones comerciales', '69', '0'),
('695', '695', 'Dotación a la provisión para operaciones comerciales', '695', '0'),
('6954', '6954', 'Dotación a la provisión por contratos onerosos', '695', '0'),
('6959', '6959', 'Dotación a la provisión para otras operaciones comerciales', '695', '0'),
('696', '696', 'Pérdidas por deterioro de participaciones y valores representativos de deuda a largo plazo', '696', '0'),
('6960', '6960', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo empresas', '696', '0'),
('6961', '6961', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo empresas', '696', '0'),
('6962', '6962', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo otras pa', '696', '0'),
('6963', '6963', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo otras em', '696', '0'),
('6965', '6965', 'Pérdidas en valores representativos de deuda a largo plazo empresas del grupo', '696', '0'),
('6966', '6966', 'Pérdidas en valores representativos de deuda a largo plazo empresas asociadas', '696', '0'),
('6967', '6967', 'Pérdidas en valores representativos de deuda a largo plazo otras partes vinculadas', '696', '0'),
('6968', '6968', 'Pérdidas en valores representativos de deuda a largo plazo otras empresas', '696', '0'),
('697', '697', 'Pérdidas por deterioro de créditos a largo plazo', '697', '0'),
('6970', '6970', 'Pérdidas por deterioro de créditos a largo plazo empresas del grupo', '697', '0'),
('6971', '6971', 'Pérdidas por deterioro de créditos a largo plazo empresas asociadas', '697', '0'),
('6972', '6972', 'Pérdidas por deterioro de créditos a largo plazo otras partes vinculadas', '697', '0'),
('6973', '6973', 'Pérdidas por deterioro de créditos a largo plazo otras empresas', '697', '0'),
('698', '698', 'Pérdidas por deterioro de participaciones y valores representativos de deuda a corto plazo', '698', '0'),
('6980', '6980', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo empresas', '698', '0'),
('6981', '6981', 'Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo empresas', '698', '0'),
('6985', '6985', 'Pérdidas por deterioro en valores representativos de deuda a corto plazo empresas del grupo', '698', '0'),
('6986', '6986', 'Pérdidas por deterioro en valores representativos de deuda a corto plazo empresas asociadas', '698', '0'),
('6987', '6987', 'Pérdidas por deterioro en valores representativos de deuda a corto plazo otras partes vinculadas', '698', '0'),
('6988', '6988', 'Pérdidas por deterioro en valores representativos de deuda a corto plazo otras empresas', '698', '0'),
('699', '699', 'Pérdidas por deterioro de créditos a corto plazo', '699', '0'),
('6990', '6990', 'Pérdidas por deterioro de créditos a corto plazo empresas del grupo', '699', '0'),
('6991', '6991', 'Pérdidas por deterioro de créditos a corto plazo empresas asociadas', '699', '0'),
('6992', '6992', 'Pérdidas por deterioro de créditos a corto plazo otras partes vinculadas', '699', '0'),
('6993', '6993', 'Pérdidas por deterioro de créditos a corto plazo otras empresas', '699', '0'),
('700', '700', 'Venta de mercaderías', '70', '0'),
('701', '701', 'Ventas de productos terminados', '70', '0'),
('702', '702', 'Venta de productos semiterminados', '70', '0'),
('703', '703', 'Venta de subproductos y residuos', '70', '0'),
('704', '704', 'Ventas de envases y embalajes', '70', '0'),
('705', '705', 'Prestaciones de servicios', '70', '0'),
('706', '706', 'Descuentos sobre ventas por pronto pago', '706', '0'),
('7060', '7060', 'Descuentos sobre ventas por pronto pago de mercaderías', '706', '0'),
('7061', '7061', 'Descuentos sobre ventas por pronto pago de productos terminados', '706', '0'),
('7062', '7062', 'Descuentos sobre ventas por pronto pago de productos semiterminados', '706', '0'),
('7063', '7063', 'Descuentos sobre ventas por pronto pago de subproductos y residuos', '706', '0'),
('708', '708', 'Devoluciones de ventas y operaciones similares', '708', '0'),
('7080', '7080', 'Devoluciones de venta de mercaderías', '708', '0'),
('7081', '7081', 'Devoluciones de ventas de productos terminados', '708', '0'),
('7082', '7082', 'Devoluciones de ventas de productos semiterminados', '708', '0'),
('7083', '7083', 'Devoluciones de ventas de subproductos y residuos', '708', '0'),
('7084', '7084', 'Devoluciones de ventas de envases y embalajes', '708', '0'),
('709', '709', 'Rappels sobre ventas', '709', '0'),
('7090', '7090', 'Rappels sobre ventas de mercaderías', '709', '0'),
('7091', '7091', 'Rappels sobre ventas de productos terminados', '709', '0'),
('7092', '7092', 'Rappels sobre ventas de productos semiterminados', '709', '0'),
('7093', '7093', 'Rappels sobre ventas de subproductos y residuos', '709', '0'),
('7094', '7094', 'Rappels sobre ventas de envases y embalajes', '709', '0'),
('710', '710', 'Variación de existencias de productos en curso', '71', '0'),
('711', '711', 'Variación de existencias de productos semiterminados', '71', '0');
INSERT INTO `0_chart_master` VALUES
('712', '712', 'Variación de existencias de productos terminados', '71', '0'),
('713', '713', 'Variación de existencias de subproductos residuos y materiales recuperados', '71', '0'),
('730', '730', 'Trabajos realizados para el inmovilizado intangible', '73', '0'),
('731', '731', 'Trabajos realizados para el inmovilizado material', '73', '0'),
('732', '732', 'Trabajos realizados en inversiones inmobiliarias', '73', '0'),
('733', '733', 'Trabajos realizados para el inmovilizado material en curso', '73', '0'),
('740', '740', 'Subvenciones donaciones y legados a la explotación', '74', '0'),
('746', '746', 'Subvenciones donaciones y legados de capital trasferidas al resultado del ejercicio', '74', '0'),
('747', '747', 'Otras subvenciones donaciones y legados trasferidos al resultado del ejercicio', '74', '0'),
('751', '751', 'Resultado de operaciones en común', '751', '0'),
('7510', '7510', 'Pérdida transferida (gestor)', '751', '0'),
('7511', '7511', 'Beneficio atribuido (participe o asociado no gestor)', '751', '0'),
('752', '752', 'Ingresos por arrendamientos', '75', '0'),
('753', '753', 'Ingresos de propiedad industrial cedida en explotación', '75', '0'),
('754', '754', 'Ingresos por comisiones', '75', '0'),
('755', '755', 'Ingresos por servicios al personal', '75', '0'),
('759', '759', 'Ingresos por servicios diversos', '75', '0'),
('760', '760', 'Ingresos de participaciones en instrumentos de patrimonio', '760', '0'),
('7600', '7600', 'Ingresos de participaciones en instrumentos de patrimonio empresas del grupo', '760', '0'),
('7601', '7601', 'Ingresos de participaciones en instrumentos de patrimonio empresas asociadas', '760', '0'),
('7602', '7602', 'Ingresos de participaciones en instrumentos de patrimonio otras partes vinculadas', '760', '0'),
('7603', '7603', 'Ingresos de participaciones en instrumentos de patrimonio otras empresas', '760', '0'),
('761', '761', 'Ingresos de valores representativos de deuda', '761', '0'),
('7610', '7610', 'Ingresos de valores representativos de deuda empresas del grupo', '761', '0'),
('7611', '7611', 'Ingresos de valores representativos de deuda empresas asociadas', '761', '0'),
('7612', '7612', 'Ingresos de valores representativos de deuda otras partes vinculadas', '761', '0'),
('7613', '7613', 'Ingresos de valores representativos de deuda otras empresas', '761', '0'),
('762', '762', 'Ingresos de créditos', '762', '0'),
('7620', '7620', 'Ingresos de créditos a largo plazo', '7620', '0'),
('76200', '76200', 'Ingresos de créditos a largo plazo empresas del grupo', '7620', '0'),
('76201', '76201', 'Ingresos de créditos a largo plazo empresas asociadas', '7620', '0'),
('76202', '76202', 'Ingresos de créditos a largo plazo otras partes vinculadas', '7620', '0'),
('76203', '76203', 'Ingresos de créditos a largo plazo otras empresas', '7620', '0'),
('7621', '7621', 'Ingresos de créditos a corto plazo', '7621', '0'),
('76210', '76210', 'Ingresos de créditos a corto plazo empresas del grupo', '7621', '0'),
('76211', '76211', 'Ingresos de créditos a corto plazo empresas asociadas', '7621', '0'),
('76212', '76212', 'Ingresos de créditos a corto plazo otras partes vinculadas', '7621', '0'),
('76213', '76213', 'Ingresos de créditos a corto plazo otras empresas', '7621', '0'),
('7623', '7623', 'Ingreso de intereses de cuentas corrientes en entidades bancarias', '762', '0'),
('763', '763', 'Beneficios por la valoración de instrumentos financieros por su valor razonable', '76', '0'),
('766', '766', 'Beneficios en participaciones y valores representativos de deuda', '766', '0'),
('7660', '7660', 'Beneficios en valores representativos de deuda a largo plazo empresas del grupo', '766', '0'),
('7661', '7661', 'Beneficios en valores representativos de deuda a largo plazo empresas asociadas', '766', '0'),
('7662', '7662', 'Beneficios en valores representativos de deuda a largo plazo otras partes vinculadas', '766', '0'),
('7663', '7663', 'Beneficios en participaciones y valores representativos de deuda a largo plazo otras empresas', '766', '0'),
('7665', '7665', 'Beneficios en participaciones y valores representativos de deuda a corto plazo empresas del grupo', '766', '0'),
('7666', '7666', 'Beneficios en participaciones y valores representativos de deuda a corto plazo empresas asociadas', '766', '0'),
('7667', '7667', 'Beneficios en valores representativos de deuda a corto plazo otras partes vinculadas', '766', '0'),
('7668', '7668', 'Beneficios en valores representativos de deuda a corto plazo otras empresas', '766', '0'),
('768', '768', 'Diferencias positivas de cambio', '76', '0'),
('769', '769', 'Otros ingresos financieros', '76', '0'),
('770', '770', 'Beneficios procedentes del inmovilizado intangible', '77', '0'),
('771', '771', 'Beneficios procedentes del inmovilizado material', '77', '0'),
('772', '772', 'Beneficios procedentes de las inversiones inmobiliarias', '77', '0'),
('773', '773', 'Beneficios procedentes de participaciones a largo plazo en partes vinculadas', '773', '0'),
('7733', '7733', 'Beneficios procedentes de participaciones a largo plazo empresas del grupo', '773', '0'),
('7734', '7734', 'Beneficios procedentes de participaciones a largo plazo empresas asociadas', '773', '0'),
('7735', '7735', 'Beneficios procedentes de participaciones a largo plazo otras partes vinculadas', '773', '0'),
('775', '775', 'Beneficios por operaciones con obligaciones propias', '77', '0'),
('778', '778', 'Ingresos excepcionales', '77', '0'),
('790', '790', 'Reversión del deterioro del inmovilizado intangible', '79', '0'),
('791', '791', 'Reversión del deterioro del inmovilizado material', '79', '0'),
('792', '792', 'Reversión del deterioro de las inversiones inmobiliarias', '79', '0'),
('793', '793', 'Reversión del deterioro de existencias', '793', '0'),
('7930', '7930', 'Reversión del deterioro de productos terminados y en curso de fabricación', '793', '0'),
('7931', '7931', 'Reversión del deterioro de mercaderías', '793', '0'),
('7932', '7932', 'Reversión del deterioro de materias primas', '793', '0'),
('7933', '7933', 'Reversión del deterioro de otros aprovisionamientos', '793', '0'),
('794', '794', 'Reversión del deterioro de créditos comerciales', '79', '0'),
('795', '795', 'Exceso de provisiones', '795', '0'),
('7951', '7951', 'Exceso de provisión para impuestos', '795', '0'),
('7952', '7952', 'Exceso de provisión para otras responsabilidades', '795', '0'),
('7954', '7954', 'Exceso de provisión para operaciones comerciales', '7954', '0'),
('79544', '79544', 'Exceso de provision por contratos onerosos', '7954', '0'),
('79549', '79549', 'Exceso de provision para otras operaciones comerciales', '7954', '0'),
('7955', '7955', 'Exceso de provisión para actuaciones medioambientales', '795', '0'),
('796', '796', 'Reversión del deterioro de participaciones y valores representativos de deuda a largo plazo', '796', '0'),
('7960', '7960', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a largo plazo empres', '796', '0'),
('7961', '7961', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a largo plazo empres', '796', '0'),
('7962', '7962', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a largo plazo otras ', '796', '0'),
('7963', '7963', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a largo plazo otras ', '796', '0'),
('7965', '7965', 'Reversión del deterioro de valores representativos de deuda a largo plazo empresas del grupo', '796', '0'),
('7966', '7966', 'Reversión del deterioro de valores representativos de deuda a largo plazo empresas asociadas', '796', '0'),
('7967', '7967', 'Reversión del deterioro de valores representativos de deuda a largo plazo otras partes vinculadas', '796', '0'),
('7968', '7968', 'Reversión del deterioro de valores representativos de deuda a largo plazo otras empresas', '796', '0'),
('797', '797', 'Reversión del deterioro de créditos a largo plazo', '797', '0'),
('7970', '7970', 'Reversión del deterioro de créditos a largo plazo empresas del grupo', '797', '0'),
('7971', '7971', 'Reversión del deterioro de créditos a largo plazo empresas asociadas', '797', '0'),
('7972', '7972', 'Reversión del deterioro de créditos a largo plazo otras partes vinculadas', '797', '0'),
('7973', '7973', 'Reversión del deterioro de créditos a largo plazo otras empresas', '797', '0'),
('798', '798', 'Reversión del deterioro de participaciones y valores representativos de deuda a corto plazo', '798', '0'),
('7980', '7980', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a corto plazo empres', '798', '0'),
('7981', '7981', 'Reversión del deterioro de participaciones en instrumentos del patrimonio neto a corto plazo empres', '798', '0'),
('7985', '7985', 'Reversión del deterioro de valores representativos de deuda a corto plazo empresas del grupo', '798', '0'),
('7986', '7986', 'Reversión del deterioro de valores representativos de deuda a corto plazo empresas asociadas', '798', '0'),
('7987', '7987', 'Reversión del deterioro de valores representativos de deuda a corto plazo otras partes vinculadas', '798', '0'),
('7988', '7988', 'Reversión del deterioro de valores representativos de deuda a corto plazo otras empresas', '798', '0'),
('799', '799', 'Reversión del deterioro de créditos a corto plazo', '799', '0'),
('7990', '7990', 'Reversión del deterioro de créditos a corto plazo empresas del grupo', '799', '0'),
('7991', '7991', 'Reversión del deterioro de créditos a corto plazo empresas asociadas', '799', '0'),
('7992', '7992', 'Reversión del deterioro de créditos a corto plazo otras partes vinculadas', '799', '0'),
('7993', '7993', 'Reversión del deterioro de créditos a corto plazo otras empresas', '799', '0');

### Structure of table `0_chart_types` ###

DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `class_id` varchar(3) NOT NULL DEFAULT '',
  `parent` varchar(10) NOT NULL DEFAULT '-1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=InnoDB ;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('1', 'FINANCIACION BASICA', '5', '', '0'),
('10', 'CAPITAL', '5', '1', '0'),
('103', 'Socios por desembolsos no exigidos', '5', '10', '0'),
('104', 'Socios por aportaciones no dinerarias pendientes', '5', '10', '0'),
('11', 'RESERVAS', '5', '1', '0'),
('114', 'Reservas especiales', '5', '11', '0'),
('12', 'RESULTADOS PENDIENTES DE APLICACION', '5', '1', '0'),
('13', 'SUBVENCIONES DONACIONES Y AJUSTES POR CAMBIOS DE VALOR', '5', '1', '0'),
('137', 'Ingresos fiscales a distribuir en varios ejercicios', '5', '13', '0'),
('14', 'PROVISIONES', '2', '1', '0'),
('15', 'DEUDAS A LARGO PLAZO CON CARACTERISTICAS ESPECIALES', '2', '1', '0'),
('153', 'Desembolsos no exigidos por acciones o participaciones consideradas como pasivos financier', '2', '15', '0'),
('154', 'Aportaciones no dinerarias pendientes por acciones o participaciones consideradas como pas', '2', '15', '0'),
('16', 'DEUDAS A LARGO PLAZO CON PARTES VINCULADAS', '2', '1', '0'),
('160', 'Deudas a largo plazo con entidades de crédito vinculadas', '2', '16', '0'),
('161', 'Proveedores de inmovilizado a largo plazo partes vinculadas', '2', '16', '0'),
('162', 'Acreedores por arrendamiento financiero a largo plazo partes vinculadas', '2', '16', '0'),
('163', 'Otras deudas a largo plazo con partes vinculadas', '2', '16', '0'),
('17', 'DEUDAS A LARGO PLAZO POR PRESTAMOS RECIBIDOS Y OTROS CONCEPTOS', '2', '1', '0'),
('18', 'PASIVOS POR FIANZAS Y GARANTIAS A LARGO PLAZO', '2', '1', '0'),
('19', 'SITUACIONES TRANSITORIAS DE FINANCIACION', '2', '1', '0'),
('2', 'INMOVILIZADO', '1', '0', '0'),
('20', 'INMOVILIZACIONES INTANGIBLES', '1', '2', '0'),
('21', 'INMOVILIZACIONES MATERIALES', '1', '2', '0'),
('22', 'INVERSIONES INMOVILIARIAS', '1', '2', '0'),
('23', 'INMOVILIZACIONES MATERIALES EN CURSO', '1', '2', '0'),
('24', 'INVERSIONES FINANCIERAS EN PARTES VINCULADAS', '1', '2', '0'),
('240', 'Participaciones a largo plazo en partes vinculadas', '1', '24', '0'),
('241', 'Valores representativos de deuda a largo plazo de partes vinculadas', '1', '24', '0'),
('242', 'Créditos a largo plazo a partes vinculadas', '1', '24', '0'),
('249', 'Desembolsos pendientes sobre participaciones a largo plazo en partes vinculadas', '1', '24', '0'),
('25', 'OTRAS INVERSIONES FINANCIERAS A LARGO PLAZO', '1', '2', '0'),
('26', 'FIANZAS Y DEPOSITOS CONSTITUTIDOS A LARGO PLAZO', '1', '2', '0'),
('28', 'AMORTIZACION ACUMULADA DEL INMOVILIZADO', '1', '2', '0'),
('280', 'Amortización acumulada del inmovilizado intangible', '1', '28', '0'),
('281', 'Amortización acumulada del inmovilizado material', '1', '28', '0'),
('29', 'DETERIORO DE VALOR DEL INMOVILIZADO', '1', '2', '0'),
('290', 'Deterioro de valor del inmovilizado intangible', '1', '29', '0'),
('291', 'Deterioro de valor del inmovilizado material', '1', '29', '0'),
('292', 'Deterioro de valor de las inversiones inmobiliarias', '1', '29', '0'),
('293', 'Deterioro de valor de participaciones a largo plazo en partes vinculadas', '1', '29', '0'),
('294', 'Deterioro de valores representativos de deuda a largo plazo en otras partes vinculadas', '1', '29', '0'),
('295', 'Deterioro de valor de créditos a largo plazo a partes vinculadas', '1', '29', '0'),
('3', 'EXISTENCIAS', '1', '0', '0'),
('30', 'COMERCIALES', '1', '3', '0'),
('31', 'MATERIAS PRIMAS', '1', '3', '0'),
('32', 'OTROS APROVISIONAMIENTOS', '1', '3', '0'),
('33', 'PRODUCTOS EN CURSO', '1', '3', '0'),
('34', 'PRODUCTOS SEMITERMINADOS', '1', '3', '0'),
('35', 'PRODUCTOS TERMINADOS', '1', '3', '0'),
('36', 'SUBPRODUCTOS RESIDUOS Y MATERIALES RECUPERADOS', '1', '3', '0'),
('39', 'DETERIORO DE VALOR DE LAS EXISTENCIAS', '1', '3', '0'),
('4', 'ACREEDORES Y DEUDORES POR OPERACIONES COMERCIALES', '1', '0', '0'),
('40', 'PROVEEDORES', '2', '4', '0'),
('400', 'Proveedores', '2', '40', '0'),
('403', 'Proveedores empresas del grupo', '2', '40', '0'),
('41', 'ACREEDORES VARIOS', '2', '4', '0'),
('410', 'Acreedores por prestación de servicio', '2', '41', '0'),
('43', 'CLIENTES', '1', '4', '0'),
('430', 'Clientes', '1', '43', '0'),
('431', 'Clientes efectos comerciales a cobrar', '1', '43', '0'),
('433', 'Clientes empresas del grupo', '1', '43', '0'),
('438', 'Anticipos de clientes', '2', '43', '0'),
('44', 'DEUDORES VARIOS', '1', '4', '0'),
('440', 'Deudores', '1', '44', '0'),
('441', 'Deudores efectos comerciales a cobrar', '1', '44', '0'),
('46', 'PERSONAL', '1', '4', '0'),
('465', 'Remuneraciones pendientes de pago', '2', '46', '0'),
('47', 'Administraciones publicas', '1', '4', '0'),
('470', 'Hacienda Publica deudora por diversos conceptos', '1', '47', '0'),
('472', 'Hacienda Publica IVA Soportado', '1', '47', '0'),
('474', 'Activos por impuesto diferido', '1', '47', '0'),
('475', 'Hacienda publica acreedora por conceptos fiscales', '2', '47', '0'),
('476', 'Organismos de las Seguridad Social acreedores', '2', '47', '0'),
('477', 'Hacienda Publica IVA Repercutido', '2', '47', '0'),
('479', 'Pasivos por diferencias temporarias imponibles', '2', '47', '0'),
('48', 'AJUSTES POR PERIODIFICACION', '1', '4', '0'),
('485', 'Ingresos anticipados', '2', '47', '0'),
('49', 'DETERIORO DE VALOR DE CREDITOS COMERCIALES Y PROVISIONES A  CORTO PLAZO', '1', '4', '0'),
('493', 'Deterioro de valor de créditos por operaciones comerciales con partes vinculadas', '1', '49', '0'),
('499', 'Provisión para operaciones comerciales', '2', '49', '0'),
('5', 'CUENTAS FINANCIERAS', '1', '0', '0'),
('50', 'EMPRESTITOS DEUDAS CON CARACTERISTICAS ESPECIALES Y OTRAS EMISIONES ANALOGAS A CORTO PLAZO', '2', '5', '0'),
('509', 'Valores negociables amortizados', '2', '50', '0'),
('51', 'DEUDAS A CORTO PLAZO CON PARTES VINCULADAS', '2', '5', '0'),
('510', 'Deudas a corto plazo con entidades de crédito vinculadas', '2', '51', '0'),
('511', 'Proveedores de inmovilizado a corto plazo partes vinculadas', '2', '51', '0'),
('512', 'Acreedores por arrendamiento financiero a corto plazo partes vinculadas', '2', '51', '0'),
('513', 'Otras deudas a corto plazo con partes vinculadas', '2', '51', '0'),
('514', 'Intereses a corto plazo de deudas con partes vinculadas', '2', '51', '0'),
('52', 'DEUDAS A CORTO PLAZO POR PRESTAMOS RECIBIDOS Y OTROS CONCEPTOS', '2', '5', '0'),
('520', 'Deudas a corto plazo con entidades de crédito', '2', '52', '0'),
('529', 'Provisiones a corto plazo', '2', '52', '0'),
('53', 'INVERSIONES FINANCIERAS ACORTO PLAZO EN PARTES VINCULADAS', '1', '5', '0'),
('530', 'Participaciones a corto plazo en partes vinculadas', '1', '53', '0'),
('531', 'Valores representativos de deuda a corto plazo de partes vinculadas', '1', '53', '0'),
('532', 'Créditos a corto plazo a partes vinculadas', '1', '53', '0'),
('533', 'Intereses a corto plazo de valores representativos de deuda de empresas de partes vinculad', '1', '53', '0'),
('534', 'Intereses a corto plazo de créditos a partes vinculadas', '1', '53', '0'),
('535', 'Dividendo a cobrar de inversiones financieras en partes vinculadas', '1', '53', '0'),
('539', 'Desembolsos pendientes sobre participaciones a corto plazo en partes vinculadas', '1', '53', '0'),
('54', 'OTRAS INVERSIONES FINANCIERAS A CORTO PLAZO', '1', '5', '0'),
('55', 'OTRAS CUENTAS NO BANCARIAS', '1', '5', '0'),
('552', 'Cuenta corriente con otras personas y entidades vinculadas', '1', '55', '0'),
('555', 'Partidas pendientes de aplicación\r\n', '2', '55', '0'),
('556', 'Desembolsos exigidos sobre participaciones en el patrimonio neto', '2', '55', '0'),
('557', 'Dividendo activo a cuenta', '2', '55', '0'),
('558', 'Socios por desembolsos exigidos', '1', '55', '0'),
('559', 'Derivados financieros a corto plazo', '1', '55', '0'),
('5595', 'Pasivos por derivados financieros a corto plazo cartera de negociación', '2', '559', '0'),
('56', 'FIANZAS Y DEPOSITOS RECIBIDOS Y CONSTITUIDOS A CORTO PLAZO Y AJUSTES POR PERIODIFICACION', '1', '5', '0'),
('560', 'Fianzas recibidas a corto plazo', '2', '56', '0'),
('561', 'Depósitos recibidos a corto plazo', '2', '56', '0'),
('568', 'Intereses cobrados por anticipado', '2', '56', '0'),
('57', 'TESORERIA', '1', '5', '0'),
('59', 'DETERIORO DEL VALOR DE INVERSIONES FINANCIERAS A CORTO PLAZO', '1', '5', '0'),
('593', 'Deterioro de valor de participaciones a corto plazo en partes vinculadas', '1', '59', '0'),
('594', 'Deterioro de valor de valores representativos de deuda a corto plazo de partes vinculadas', '1', '59', '0'),
('595', 'Deterioro de valor de créditos a corto plazo a partes vinculadas', '1', '59', '0'),
('6', 'COMPRAS Y GASTOS', '4', '0', '0'),
('60', 'COMPRAS', '4', '6', '0'),
('606', 'Descuento sobre compras por pronto pago', '4', '60', '0'),
('608', 'Devoluciones de compras y operaciones similares', '4', '60', '0'),
('609', 'Rappels por compras', '4', '60', '0'),
('61', 'VARIACION DE EXISTENCIAS', '4', '6', '0'),
('62', 'SERVICIOS EXTERIORES', '4', '6', '0'),
('63', 'TRIBUTOS', '4', '6', '0'),
('630', 'Impuesto sobre beneficios', '4', '63', '0'),
('634', 'Ajustes negativos en la imposición indirecta', '4', '63', '0'),
('639', 'Ajustes positivos en la imposición indirecta', '4', '63', '0'),
('64', 'GASTOS DE PERSONAL', '4', '6', '0'),
('65', 'OTROS GASTOS DE GESTION', '4', '6', '0'),
('651', 'Resultados de operaciones en común', '4', '65', '0'),
('66', 'GASTOS FINANCIEROS', '4', '6', '0'),
('661', 'Intereses de obligaciones y bonos', '4', '66', '0'),
('662', 'Intereses de deudas', '4', '66', '0'),
('664', 'Dividendos de acciones o participaciones contabilizadas como pasivos', '4', '66', '0'),
('665', 'Intereses por descuento de efectos y operaciones de factoring', '4', '66', '0'),
('666', 'Pérdidas en participaciones y valores representativos de deuda', '4', '66', '0'),
('667', 'Pérdidas de créditos no comerciales', '4', '66', '0'),
('67', 'PérdidaS PROCEDENTES DE ACTIVOS NO CORRIENTES Y GASTOS EXCEPCIONALES', '4', '6', '0'),
('673', 'Pérdidas procedentes de participaciones a largo plazo en partes vinculadas', '4', '67', '0'),
('68', 'DOTACIONES PARA AMORTIZACIONES', '4', '6', '0'),
('69', 'PérdidaS POR DETERIORO Y OTRAS DOTACIONES', '4', '6', '0'),
('693', 'Pérdidas por deterioro de existencias', '4', '69', '0'),
('695', 'Dotación a la provisión para operaciones comerciales', '4', '69', '0'),
('696', 'Pérdidas por deterioro de participaciones y valores representativos de deuda a largo plazo', '4', '69', '0'),
('697', 'Pérdidas por deterioro de créditos a largo plazo', '4', '69', '0'),
('698', 'Pérdidas por deterioro de participaciones y valores representativos de deuda a corto plazo', '4', '69', '0'),
('699', 'Pérdidas por deterioro de créditos a corto plazo', '4', '69', '0'),
('7', 'VENTAS E INGRESOS', '3', '0', '0'),
('70', 'VENTAS DE MERCADERIAS DE PRODUCCION PROPIA DE SERVICIOS ETC', '3', '7', '0'),
('706', 'Descuentos sobre ventas por pronto pago', '3', '70', '0'),
('708', 'Devoluciones de ventas y operaciones similares', '3', '70', '0'),
('709', 'Rappels sobre ventas', '3', '70', '0'),
('71', 'VARIACION DE EXISTENCIAS', '3', '7', '0'),
('73', 'TRABAJOS REALIZADOS PARA LA EMPRESA', '3', '7', '0'),
('74', 'SUBVENCIONES DONACIONES Y LEGADOS', '3', '7', '0'),
('75', 'OTROS INGRESOS DE GESTION', '3', '7', '0'),
('751', 'Resultado de operaciones en común', '3', '75', '0'),
('76', 'INGRESOS FINANCIEROS', '3', '7', '0'),
('760', 'Ingresos de participaciones en instrumentos de patrimonio', '3', '76', '0'),
('761', 'Ingresos de valores representativos de deuda', '3', '76', '0'),
('762', 'Ingresos de créditos', '3', '76', '0'),
('7620', 'Ingresos de créditos a largo plazo', '3', '762', '0'),
('7621', 'Ingresos de créditos a corto plazo', '3', '762', '0'),
('766', 'Beneficios en participaciones y valores representativos de deuda', '3', '76', '0'),
('77', 'BENEFICIOS PROCEDENTES DE ACTIVOS NO CORRIENTES E INGRESOS EXCEPCIONALES', '3', '7', '0'),
('773', 'Beneficios procedentes de participaciones a largo plazo en partes vinculadas', '3', '77', '0'),
('79', 'EXCESOS Y APLICACIONES DE PROVISIONES Y PérdidaS POR DETERIORO', '3', '7', '0'),
('793', 'Reversión del deterioro de existencias', '3', '79', '0'),
('795', 'Exceso de provisiones', '3', '79', '0'),
('7954', 'Exceso de provisión para operaciones comerciales', '3', '795', '0'),
('796', 'Reversión del deterioro de participaciones y valores representativos de deuda a largo plaz', '3', '79', '0'),
('797', 'Reversión del deterioro de créditos a largo plazo', '3', '79', '0'),
('798', 'Reversión del deterioro de participaciones y valores representativos de deuda a corto plaz', '3', '79', '0'),
('799', 'Reversión del deterioro de créditos a corto plazo', '3', '79', '0');

### Structure of table `0_comments` ###

DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date DEFAULT '0000-00-00',
  `memo_` tinytext,
  KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB ;

### Data of table `0_comments` ###


### Structure of table `0_credit_status` ###

DROP TABLE IF EXISTS `0_credit_status`;

CREATE TABLE `0_credit_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason_description` char(100) NOT NULL DEFAULT '',
  `dissallow_invoices` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_description` (`reason_description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES
('1', 'Buen Historial', '0', '0'),
('3', 'No más trabajo hasta que se reciban los pagos', '1', '0'),
('4', 'En liquidación', '1', '0');

### Structure of table `0_crm_categories` ###

DROP TABLE IF EXISTS `0_crm_categories`;

CREATE TABLE `0_crm_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'pure technical key',
  `type` varchar(20) NOT NULL,
  `action` varchar(20) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` tinytext NOT NULL,
  `system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'nonzero for core system usage',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`action`),
  UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 ;

### Data of table `0_crm_categories` ###

INSERT INTO `0_crm_categories` VALUES
('1', 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', '1', '0'),
('2', 'cust_branch', 'invoice', 'Invoices', 'Invoice posting (overrides company setting)', '1', '0'),
('3', 'cust_branch', 'order', 'Orders', 'Order confirmation (overrides company setting)', '1', '0'),
('4', 'cust_branch', 'delivery', 'Deliveries', 'Delivery coordination (overrides company setting)', '1', '0'),
('5', 'customer', 'general', 'General', 'General contact data for customer', '1', '0'),
('6', 'customer', 'order', 'Orders', 'Order confirmation', '1', '0'),
('7', 'customer', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('8', 'customer', 'invoice', 'Invoices', 'Invoice posting', '1', '0'),
('9', 'supplier', 'general', 'General', 'General contact data for supplier', '1', '0'),
('10', 'supplier', 'order', 'Orders', 'Order confirmation', '1', '0'),
('11', 'supplier', 'delivery', 'Deliveries', 'Delivery coordination', '1', '0'),
('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0');

### Structure of table `0_crm_contacts` ###

DROP TABLE IF EXISTS `0_crm_contacts`;

CREATE TABLE `0_crm_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL DEFAULT '0' COMMENT 'foreign key to crm_contacts',
  `type` varchar(20) NOT NULL,
  `action` varchar(20) NOT NULL,
  `entity_id` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`action`)
) ENGINE=InnoDB ;

### Data of table `0_crm_contacts` ###


### Structure of table `0_crm_persons` ###

DROP TABLE IF EXISTS `0_crm_persons`;

CREATE TABLE `0_crm_persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ref` varchar(30) NOT NULL,
  `name` varchar(60) NOT NULL,
  `name2` varchar(60) DEFAULT NULL,
  `address` tinytext,
  `phone` varchar(30) DEFAULT NULL,
  `phone2` varchar(30) DEFAULT NULL,
  `fax` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `lang` char(5) DEFAULT NULL,
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ref` (`ref`)
) ENGINE=InnoDB ;

### Data of table `0_crm_persons` ###


### Structure of table `0_currencies` ###

DROP TABLE IF EXISTS `0_currencies`;

CREATE TABLE `0_currencies` (
  `currency` varchar(60) NOT NULL DEFAULT '',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `curr_symbol` varchar(10) NOT NULL DEFAULT '',
  `country` varchar(100) NOT NULL DEFAULT '',
  `hundreds_name` varchar(15) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `auto_update` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`curr_abrev`)
) ENGINE=InnoDB ;

### Data of table `0_currencies` ###

INSERT INTO `0_currencies` VALUES
('Euro', 'EUR', '?', 'Europa', 'Centimos', '0', '1'),
('Pounds', 'GBP', '?', 'Inglaterra', 'Pence', '0', '1'),
('US Dollars', 'USD', '$', 'Estados Unidos', 'Cents', '0', '1');

### Structure of table `0_cust_allocations` ###

DROP TABLE IF EXISTS `0_cust_allocations`;

CREATE TABLE `0_cust_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id` (`person_id`,`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB ;

### Data of table `0_cust_allocations` ###


### Structure of table `0_cust_branch` ###

DROP TABLE IF EXISTS `0_cust_branch`;

CREATE TABLE `0_cust_branch` (
  `branch_code` int(11) NOT NULL AUTO_INCREMENT,
  `debtor_no` int(11) NOT NULL DEFAULT '0',
  `br_name` varchar(60) NOT NULL DEFAULT '',
  `br_address` tinytext NOT NULL,
  `area` int(11) DEFAULT NULL,
  `salesman` int(11) NOT NULL DEFAULT '0',
  `default_location` varchar(5) NOT NULL DEFAULT '',
  `tax_group_id` int(11) DEFAULT NULL,
  `sales_account` varchar(15) NOT NULL DEFAULT '',
  `sales_discount_account` varchar(15) NOT NULL DEFAULT '',
  `receivables_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `default_ship_via` int(11) NOT NULL DEFAULT '1',
  `br_post_address` tinytext NOT NULL,
  `group_no` int(11) NOT NULL DEFAULT '0',
  `notes` tinytext,
  `bank_account` varchar(60) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `branch_ref` varchar(30) NOT NULL,
  PRIMARY KEY (`branch_code`,`debtor_no`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=InnoDB ;

### Data of table `0_cust_branch` ###


### Structure of table `0_debtor_trans` ###

DROP TABLE IF EXISTS `0_debtor_trans`;

CREATE TABLE `0_debtor_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `debtor_no` int(11) unsigned NOT NULL DEFAULT '0',
  `branch_code` int(11) NOT NULL DEFAULT '-1',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `tpe` int(11) NOT NULL DEFAULT '0',
  `order_` int(11) NOT NULL DEFAULT '0',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `ov_freight` double NOT NULL DEFAULT '0',
  `ov_freight_tax` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `prep_amount` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `ship_via` int(11) DEFAULT NULL,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  `tax_included` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`type`,`trans_no`,`debtor_no`),
  KEY `debtor_no` (`debtor_no`,`branch_code`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_debtor_trans` ###


### Structure of table `0_debtor_trans_details` ###

DROP TABLE IF EXISTS `0_debtor_trans_details`;

CREATE TABLE `0_debtor_trans_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `debtor_trans_no` int(11) DEFAULT NULL,
  `debtor_trans_type` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  `standard_cost` double NOT NULL DEFAULT '0',
  `qty_done` double NOT NULL DEFAULT '0',
  `src_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Transaction` (`debtor_trans_type`,`debtor_trans_no`),
  KEY `src_id` (`src_id`)
) ENGINE=InnoDB ;

### Data of table `0_debtor_trans_details` ###


### Structure of table `0_debtors_master` ###

DROP TABLE IF EXISTS `0_debtors_master`;

CREATE TABLE `0_debtors_master` (
  `debtor_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `address` tinytext,
  `tax_id` varchar(55) NOT NULL DEFAULT '',
  `curr_code` char(3) NOT NULL DEFAULT '',
  `sales_type` int(11) NOT NULL DEFAULT '1',
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `credit_status` int(11) NOT NULL DEFAULT '0',
  `payment_terms` int(11) DEFAULT NULL,
  `discount` double NOT NULL DEFAULT '0',
  `pymt_discount` double NOT NULL DEFAULT '0',
  `credit_limit` float NOT NULL DEFAULT '1000',
  `notes` tinytext,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `debtor_ref` varchar(30) NOT NULL,
  PRIMARY KEY (`debtor_no`),
  UNIQUE KEY `debtor_ref` (`debtor_ref`),
  KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_debtors_master` ###


### Structure of table `0_dimensions` ###

DROP TABLE IF EXISTS `0_dimensions`;

CREATE TABLE `0_dimensions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `type_` tinyint(1) NOT NULL DEFAULT '1',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `date_` (`date_`),
  KEY `due_date` (`due_date`),
  KEY `type_` (`type_`)
) ENGINE=InnoDB ;

### Data of table `0_dimensions` ###


### Structure of table `0_exchange_rates` ###

DROP TABLE IF EXISTS `0_exchange_rates`;

CREATE TABLE `0_exchange_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curr_code` char(3) NOT NULL DEFAULT '',
  `rate_buy` double NOT NULL DEFAULT '0',
  `rate_sell` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `curr_code` (`curr_code`,`date_`)
) ENGINE=InnoDB ;

### Data of table `0_exchange_rates` ###


### Structure of table `0_fiscal_year` ###

DROP TABLE IF EXISTS `0_fiscal_year`;

CREATE TABLE `0_fiscal_year` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `begin` date DEFAULT '0000-00-00',
  `end` date DEFAULT '0000-00-00',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `begin` (`begin`),
  UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES
('1', '2018-01-01', '2018-12-31', '0');

### Structure of table `0_gl_trans` ###

DROP TABLE IF EXISTS `0_gl_trans`;

CREATE TABLE `0_gl_trans` (
  `counter` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `type_no` int(11) NOT NULL DEFAULT '0',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `account` varchar(15) NOT NULL DEFAULT '',
  `memo_` tinytext NOT NULL,
  `amount` double NOT NULL DEFAULT '0',
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  `person_type_id` int(11) DEFAULT NULL,
  `person_id` tinyblob,
  PRIMARY KEY (`counter`),
  KEY `Type_and_Number` (`type`,`type_no`),
  KEY `dimension_id` (`dimension_id`),
  KEY `dimension2_id` (`dimension2_id`),
  KEY `tran_date` (`tran_date`),
  KEY `account_and_tran_date` (`account`,`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_gl_trans` ###


### Structure of table `0_grn_batch` ###

DROP TABLE IF EXISTS `0_grn_batch`;

CREATE TABLE `0_grn_batch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `purch_order_no` int(11) DEFAULT NULL,
  `reference` varchar(60) NOT NULL DEFAULT '',
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `loc_code` varchar(5) DEFAULT NULL,
  `rate` double DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `delivery_date` (`delivery_date`),
  KEY `purch_order_no` (`purch_order_no`)
) ENGINE=InnoDB ;

### Data of table `0_grn_batch` ###


### Structure of table `0_grn_items` ###

DROP TABLE IF EXISTS `0_grn_items`;

CREATE TABLE `0_grn_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grn_batch_id` int(11) DEFAULT NULL,
  `po_detail_item` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `qty_recd` double NOT NULL DEFAULT '0',
  `quantity_inv` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `grn_batch_id` (`grn_batch_id`)
) ENGINE=InnoDB ;

### Data of table `0_grn_items` ###


### Structure of table `0_groups` ###

DROP TABLE IF EXISTS `0_groups`;

CREATE TABLE `0_groups` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_groups` ###

INSERT INTO `0_groups` VALUES
('1', 'Pequeño', '0'),
('2', 'Mediano', '0'),
('3', 'Grande', '0');

### Structure of table `0_item_codes` ###

DROP TABLE IF EXISTS `0_item_codes`;

CREATE TABLE `0_item_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_code` varchar(20) NOT NULL,
  `stock_id` varchar(20) NOT NULL,
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_id` smallint(6) unsigned NOT NULL,
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=InnoDB ;

### Data of table `0_item_codes` ###


### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB ;

### Data of table `0_item_tax_type_exemptions` ###


### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_item_tax_types` ###


### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `decimals` tinyint(2) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES
('ud.', 'Unidades', '0', '0');

### Structure of table `0_journal` ###

DROP TABLE IF EXISTS `0_journal`;

CREATE TABLE `0_journal` (
  `type` smallint(6) NOT NULL DEFAULT '0',
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `tran_date` date DEFAULT '0000-00-00',
  `reference` varchar(60) NOT NULL DEFAULT '',
  `source_ref` varchar(60) NOT NULL DEFAULT '',
  `event_date` date DEFAULT '0000-00-00',
  `doc_date` date NOT NULL DEFAULT '0000-00-00',
  `currency` char(3) NOT NULL DEFAULT '',
  `amount` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_journal` ###


### Structure of table `0_loc_stock` ###

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
  `loc_code` char(5) NOT NULL DEFAULT '',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `reorder_level` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`,`stock_id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB ;

### Data of table `0_loc_stock` ###


### Structure of table `0_locations` ###

DROP TABLE IF EXISTS `0_locations`;

CREATE TABLE `0_locations` (
  `loc_code` varchar(5) NOT NULL DEFAULT '',
  `location_name` varchar(60) NOT NULL DEFAULT '',
  `delivery_address` tinytext NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `contact` varchar(30) NOT NULL DEFAULT '',
  `fixed_asset` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loc_code`)
) ENGINE=InnoDB ;

### Data of table `0_locations` ###

INSERT INTO `0_locations` VALUES
('DEF', 'Predeterminado', 'N/A', '', '', '', '', '', '0', '0');

### Structure of table `0_payment_terms` ###

DROP TABLE IF EXISTS `0_payment_terms`;

CREATE TABLE `0_payment_terms` (
  `terms_indicator` int(11) NOT NULL AUTO_INCREMENT,
  `terms` char(80) NOT NULL DEFAULT '',
  `days_before_due` smallint(6) NOT NULL DEFAULT '0',
  `day_in_following_month` smallint(6) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terms_indicator`),
  UNIQUE KEY `terms` (`terms`)
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', 'Primera quincena del mes próximo', '0', '17', '0'),
('2', 'Final del mes próximo', '0', '30', '0'),
('3', 'A 10 días', '10', '0', '0'),
('4', 'Contado', '1', '0', '0'),
('5', 'A 30 días', '30', '0', '0'),
('6', 'A 15 días', '15', '0', '0');

### Structure of table `0_prices` ###

DROP TABLE IF EXISTS `0_prices`;

CREATE TABLE `0_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `sales_type_id` int(11) NOT NULL DEFAULT '0',
  `curr_abrev` char(3) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `price` (`stock_id`,`sales_type_id`,`curr_abrev`)
) ENGINE=InnoDB ;

### Data of table `0_prices` ###


### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) NOT NULL,
  `report` varchar(5) DEFAULT NULL,
  `printer` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=InnoDB AUTO_INCREMENT=10 ;

### Data of table `0_print_profiles` ###

INSERT INTO `0_print_profiles` VALUES
('1', 'Fuera de la oficina', NULL, '0'),
('2', 'Departamento de ventas', NULL, '0'),
('3', 'Central', NULL, '2'),
('4', 'Departamento de ventas', '104', '2'),
('5', 'Departamento de ventas', '105', '2'),
('6', 'Departamento de ventas', '107', '2'),
('7', 'Departamento de ventas', '109', '2'),
('8', 'Departamento de ventas', '110', '2'),
('9', 'Departamento de ventas', '201', '2');

### Structure of table `0_printers` ###

DROP TABLE IF EXISTS `0_printers`;

CREATE TABLE `0_printers` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(60) NOT NULL,
  `queue` varchar(20) NOT NULL,
  `host` varchar(40) NOT NULL,
  `port` smallint(11) unsigned NOT NULL,
  `timeout` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_printers` ###

INSERT INTO `0_printers` VALUES
('1', 'QL500', 'Impresora de etiquetas', 'QL500', 'server', '127', '20'),
('2', 'Samsung', 'Impresora en red', 'scx4521F', 'server', '515', '5'),
('3', 'Local', 'Servidor de impresion local en la IP del usuario', 'lp', '', '515', '10');

### Structure of table `0_purch_data` ###

DROP TABLE IF EXISTS `0_purch_data`;

CREATE TABLE `0_purch_data` (
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `price` double NOT NULL DEFAULT '0',
  `suppliers_uom` char(50) NOT NULL DEFAULT '',
  `conversion_factor` double NOT NULL DEFAULT '1',
  `supplier_description` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`supplier_id`,`stock_id`)
) ENGINE=InnoDB ;

### Data of table `0_purch_data` ###


### Structure of table `0_purch_order_details` ###

DROP TABLE IF EXISTS `0_purch_order_details`;

CREATE TABLE `0_purch_order_details` (
  `po_detail_item` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `qty_invoiced` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `act_price` double NOT NULL DEFAULT '0',
  `std_cost_unit` double NOT NULL DEFAULT '0',
  `quantity_ordered` double NOT NULL DEFAULT '0',
  `quantity_received` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`po_detail_item`),
  KEY `order` (`order_no`,`po_detail_item`),
  KEY `itemcode` (`item_code`)
) ENGINE=InnoDB ;

### Data of table `0_purch_order_details` ###


### Structure of table `0_purch_orders` ###

DROP TABLE IF EXISTS `0_purch_orders`;

CREATE TABLE `0_purch_orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL DEFAULT '0',
  `comments` tinytext,
  `ord_date` date NOT NULL DEFAULT '0000-00-00',
  `reference` tinytext NOT NULL,
  `requisition_no` tinytext,
  `into_stock_location` varchar(5) NOT NULL DEFAULT '',
  `delivery_address` tinytext NOT NULL,
  `total` double NOT NULL DEFAULT '0',
  `prep_amount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`order_no`),
  KEY `ord_date` (`ord_date`)
) ENGINE=InnoDB ;

### Data of table `0_purch_orders` ###


### Structure of table `0_quick_entries` ###

DROP TABLE IF EXISTS `0_quick_entries`;

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(60) NOT NULL,
  `usage` varchar(120) DEFAULT NULL,
  `base_amount` double NOT NULL DEFAULT '0',
  `base_desc` varchar(60) DEFAULT NULL,
  `bal_type` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_quick_entries` ###

INSERT INTO `0_quick_entries` VALUES
('1', '1', 'Mantenimiento', NULL, '0', 'Cantidad', '0'),
('2', '1', 'Telefono', NULL, '0', 'Cantidad', '0'),
('3', '2', 'Ventas al contado', NULL, '0', 'Cantidad', '0');

### Structure of table `0_quick_entry_lines` ###

DROP TABLE IF EXISTS `0_quick_entry_lines`;

CREATE TABLE `0_quick_entry_lines` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `qid` smallint(6) unsigned NOT NULL,
  `amount` double DEFAULT '0',
  `memo` tinytext NOT NULL,
  `action` varchar(2) NOT NULL,
  `dest_id` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` smallint(6) unsigned DEFAULT NULL,
  `dimension2_id` smallint(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qid` (`qid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_quick_entry_lines` ###

INSERT INTO `0_quick_entry_lines` VALUES
('1', '1', '0', '', '=', '6600', '0', '0'),
('2', '2', '0', '', '=', '6730', '0', '0'),
('3', '3', '0', '', '=', '3000', '0', '0');

### Structure of table `0_recurrent_invoices` ###

DROP TABLE IF EXISTS `0_recurrent_invoices`;

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `order_no` int(11) unsigned NOT NULL,
  `debtor_no` int(11) unsigned DEFAULT NULL,
  `group_no` smallint(6) unsigned DEFAULT NULL,
  `days` int(11) NOT NULL DEFAULT '0',
  `monthly` int(11) NOT NULL DEFAULT '0',
  `begin` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `last_sent` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB ;

### Data of table `0_recurrent_invoices` ###


### Structure of table `0_reflines` ###

DROP TABLE IF EXISTS `0_reflines`;

CREATE TABLE `0_reflines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_type` int(11) NOT NULL,
  `prefix` char(5) NOT NULL DEFAULT '',
  `pattern` varchar(35) NOT NULL DEFAULT '1',
  `description` varchar(60) NOT NULL DEFAULT '',
  `default` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `prefix` (`trans_type`,`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=32 ;

### Data of table `0_reflines` ###

INSERT INTO `0_reflines` VALUES
('1', '0', '', '1', '', '1', '0'),
('2', '1', '', '1', '', '1', '0'),
('3', '2', '', '1', '', '1', '0'),
('4', '4', '', '1', '', '1', '0'),
('5', '10', '', '1', '', '1', '0'),
('6', '11', '', '1', '', '1', '0'),
('7', '12', '', '1', '', '1', '0'),
('8', '13', '', '1', '', '1', '0'),
('9', '16', '', '1', '', '1', '0'),
('10', '17', '', '1', '', '1', '0'),
('11', '18', '', '1', '', '1', '0'),
('12', '20', '', '1', '', '1', '0'),
('13', '21', '', '1', '', '1', '0'),
('14', '22', '', '1', '', '1', '0'),
('15', '25', '', '1', '', '1', '0'),
('16', '26', '', '1', '', '1', '0'),
('17', '28', '', '1', '', '1', '0'),
('18', '29', '', '1', '', '1', '0'),
('19', '30', '', '1', '', '1', '0'),
('20', '32', '', '1', '', '1', '0'),
('21', '35', '', '1', '', '1', '0'),
('22', '40', '', '1', '', '1', '0');

### Structure of table `0_refs` ###

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
  `id` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`type`),
  KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB ;

### Data of table `0_refs` ###


### Structure of table `0_sales_order_details` ###

DROP TABLE IF EXISTS `0_sales_order_details`;

CREATE TABLE `0_sales_order_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL DEFAULT '0',
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `stk_code` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `qty_sent` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `invoiced` double NOT NULL DEFAULT '0',
  `discount_percent` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sorder` (`trans_type`,`order_no`),
  KEY `stkcode` (`stk_code`)
) ENGINE=InnoDB ;

### Data of table `0_sales_order_details` ###


### Structure of table `0_sales_orders` ###

DROP TABLE IF EXISTS `0_sales_orders`;

CREATE TABLE `0_sales_orders` (
  `order_no` int(11) NOT NULL,
  `trans_type` smallint(6) NOT NULL DEFAULT '30',
  `version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `debtor_no` int(11) NOT NULL DEFAULT '0',
  `branch_code` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) NOT NULL DEFAULT '',
  `customer_ref` tinytext NOT NULL,
  `comments` tinytext,
  `ord_date` date NOT NULL DEFAULT '0000-00-00',
  `order_type` int(11) NOT NULL DEFAULT '0',
  `ship_via` int(11) NOT NULL DEFAULT '0',
  `delivery_address` tinytext NOT NULL,
  `contact_phone` varchar(30) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `deliver_to` tinytext NOT NULL,
  `freight_cost` double NOT NULL DEFAULT '0',
  `from_stk_loc` varchar(5) NOT NULL DEFAULT '',
  `delivery_date` date NOT NULL DEFAULT '0000-00-00',
  `payment_terms` int(11) DEFAULT NULL,
  `total` double NOT NULL DEFAULT '0',
  `prep_amount` double NOT NULL DEFAULT '0',
  `alloc` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`trans_type`,`order_no`)
) ENGINE=InnoDB ;

### Data of table `0_sales_orders` ###


### Structure of table `0_sales_pos` ###

DROP TABLE IF EXISTS `0_sales_pos`;

CREATE TABLE `0_sales_pos` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `pos_name` varchar(30) NOT NULL,
  `cash_sale` tinyint(1) NOT NULL,
  `credit_sale` tinyint(1) NOT NULL,
  `pos_location` varchar(5) NOT NULL,
  `pos_account` smallint(6) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_sales_pos` ###

INSERT INTO `0_sales_pos` VALUES
('1', 'Predeterminado', '1', '1', 'DEF', '1', '0');

### Structure of table `0_sales_types` ###

DROP TABLE IF EXISTS `0_sales_types`;

CREATE TABLE `0_sales_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sales_type` char(50) NOT NULL DEFAULT '',
  `tax_included` int(1) NOT NULL DEFAULT '0',
  `factor` double NOT NULL DEFAULT '1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_sales_types` ###

INSERT INTO `0_sales_types` VALUES
('1', 'Al por menor', '0', '1', '0'),
('2', 'Al por mayor', '0', '1', '0');

### Structure of table `0_salesman` ###

DROP TABLE IF EXISTS `0_salesman`;

CREATE TABLE `0_salesman` (
  `salesman_code` int(11) NOT NULL AUTO_INCREMENT,
  `salesman_name` char(60) NOT NULL DEFAULT '',
  `salesman_phone` char(30) NOT NULL DEFAULT '',
  `salesman_fax` char(30) NOT NULL DEFAULT '',
  `salesman_email` varchar(100) NOT NULL DEFAULT '',
  `provision` double NOT NULL DEFAULT '0',
  `break_pt` double NOT NULL DEFAULT '0',
  `provision2` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`salesman_code`),
  UNIQUE KEY `salesman_name` (`salesman_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES
('1', 'Comercial de ventas', '', '', '', '5', '20000', '4', '0');

### Structure of table `0_security_roles` ###

DROP TABLE IF EXISTS `0_security_roles`;

CREATE TABLE `0_security_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(30) NOT NULL,
  `description` varchar(50) DEFAULT NULL,
  `sections` text,
  `areas` text,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=11 ;

### Data of table `0_security_roles` ###

INSERT INTO `0_security_roles` VALUES
('1', 'Inquiries', 'Inquiries', '768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;773;774;2822;3073;3075;3076;3077;3329;3330;3331;3332;3333;3334;3335;5377;5633;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8450;8451;10497;10753;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15622;15623;15624;15625;15626;15873;15882;16129;16130;16131;16132;775', '0'),
('2', 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;16129;16130;16131;16132;775', '0'),
('3', 'Salesman', 'Salesman', '768;3072;5632;8192;15872', '773;774;3073;3075;3081;5633;8194;15873;775', '0'),
('4', 'Stock Manager', 'Stock Manager', '2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15872;16128;768', '775', '0'),
('5', 'Production Manager', 'Production Manager', '512;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128;768', '775', '0'),
('6', 'Purchase Officer', 'Purchase Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128;768', '775', '0'),
('7', 'AR Officer', 'AR Officer', '512;768;2816;3072;3328;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '521;523;524;771;773;774;2818;2819;2820;2821;2822;2823;3073;3073;3074;3075;3076;3077;3078;3079;3080;3081;3081;3329;3330;3330;3330;3331;3331;3332;3333;3334;3335;5633;5633;5634;5637;5638;5639;5640;5640;5889;5890;5891;8193;8194;8194;8196;8197;8450;8451;10753;10755;11009;11010;11012;13313;13315;15617;15619;15620;15621;15624;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132;775', '0'),
('8', 'AP Officer', 'AP Officer', '512;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128;768', '775', '0'),
('9', 'Accountant', 'New Accountant', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13313;13315;15617;15618;15619;15620;15621;15624;15873;15876;15877;15878;15880;15882;16129;16130;16131;16132;775', '0'),
('10', 'Sub Admin', 'Sub Admin', '512;768;2816;3072;3328;5376;5632;5888;8192;8448;10752;11008;13312;15616;15872;16128', '257;258;259;260;521;523;524;771;772;773;774;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5637;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8196;8197;8449;8450;8451;10497;10753;10755;11009;11010;11012;13057;13313;13315;15617;15619;15620;15621;15624;15873;15874;15876;15877;15878;15879;15880;15882;16129;16130;16131;16132;775', '0');

### Structure of table `0_shippers` ###

DROP TABLE IF EXISTS `0_shippers`;

CREATE TABLE `0_shippers` (
  `shipper_id` int(11) NOT NULL AUTO_INCREMENT,
  `shipper_name` varchar(60) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `phone2` varchar(30) NOT NULL DEFAULT '',
  `contact` tinytext NOT NULL,
  `address` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipper_id`),
  UNIQUE KEY `name` (`shipper_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_shippers` ###

INSERT INTO `0_shippers` VALUES
('1', 'Predeterminado', '', '', '', '', '0');

### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL,
  `msg` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

### Data of table `0_sql_trail` ###


### Structure of table `0_stock_category` ###

DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_tax_type` int(11) NOT NULL DEFAULT '1',
  `dflt_units` varchar(20) NOT NULL DEFAULT 'each',
  `dflt_mb_flag` char(1) NOT NULL DEFAULT 'B',
  `dflt_sales_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_cogs_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_inventory_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_adjustment_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_wip_act` varchar(15) NOT NULL DEFAULT '',
  `dflt_dim1` int(11) DEFAULT NULL,
  `dflt_dim2` int(11) DEFAULT NULL,
  `dflt_no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_no_purchase` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES
('1', 'Componentes', '0', '1', 'each', 'B', '700000000', '600000000', '300000000', '300000000', '300000000', '0', '0', '0', '0'),
('2', 'Cargos', '0', '1', 'each', 'B', '700000000', '600000000', '300000000', '300000000', '300000000', '0', '0', '0', '0'),
('3', 'Sistemas', '0', '1', 'each', 'B', '700000000', '600000000', '300000000', '300000000', '300000000', '0', '0', '0', '0'),
('4', 'Servicios', '0', '1', 'each', 'B', '700000000', '600000000', '300000000', '300000000', '300000000', '0', '0', '0', '0');

### Structure of table `0_stock_fa_class` ###

DROP TABLE IF EXISTS `0_stock_fa_class`;

CREATE TABLE `0_stock_fa_class` (
  `fa_class_id` varchar(20) NOT NULL DEFAULT '',
  `parent_id` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `depreciation_rate` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`fa_class_id`)
) ENGINE=InnoDB ;

### Data of table `0_stock_fa_class` ###


### Structure of table `0_stock_master` ###

DROP TABLE IF EXISTS `0_stock_master`;

CREATE TABLE `0_stock_master` (
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `description` varchar(200) NOT NULL DEFAULT '',
  `long_description` tinytext NOT NULL,
  `units` varchar(20) NOT NULL DEFAULT 'each',
  `mb_flag` char(1) NOT NULL DEFAULT 'B',
  `sales_account` varchar(15) NOT NULL DEFAULT '',
  `cogs_account` varchar(15) NOT NULL DEFAULT '',
  `inventory_account` varchar(15) NOT NULL DEFAULT '',
  `adjustment_account` varchar(15) NOT NULL DEFAULT '',
  `wip_account` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` int(11) DEFAULT NULL,
  `dimension2_id` int(11) DEFAULT NULL,
  `purchase_cost` double NOT NULL DEFAULT '0',
  `material_cost` double NOT NULL DEFAULT '0',
  `labour_cost` double NOT NULL DEFAULT '0',
  `overhead_cost` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `no_purchase` tinyint(1) NOT NULL DEFAULT '0',
  `editable` tinyint(1) NOT NULL DEFAULT '0',
  `depreciation_method` char(1) NOT NULL DEFAULT 'S',
  `depreciation_rate` double NOT NULL DEFAULT '0',
  `depreciation_factor` double NOT NULL DEFAULT '0',
  `depreciation_start` date NOT NULL DEFAULT '0000-00-00',
  `depreciation_date` date NOT NULL DEFAULT '0000-00-00',
  `fa_class_id` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`stock_id`)
) ENGINE=InnoDB ;

### Data of table `0_stock_master` ###


### Structure of table `0_stock_moves` ###

DROP TABLE IF EXISTS `0_stock_moves`;

CREATE TABLE `0_stock_moves` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `price` double NOT NULL DEFAULT '0',
  `reference` char(40) NOT NULL DEFAULT '',
  `qty` double NOT NULL DEFAULT '1',
  `standard_cost` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`trans_id`),
  KEY `type` (`type`,`trans_no`),
  KEY `Move` (`stock_id`,`loc_code`,`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_stock_moves` ###


### Structure of table `0_supp_allocations` ###

DROP TABLE IF EXISTS `0_supp_allocations`;

CREATE TABLE `0_supp_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `amt` double unsigned DEFAULT NULL,
  `date_alloc` date NOT NULL DEFAULT '0000-00-00',
  `trans_no_from` int(11) DEFAULT NULL,
  `trans_type_from` int(11) DEFAULT NULL,
  `trans_no_to` int(11) DEFAULT NULL,
  `trans_type_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id` (`person_id`,`trans_type_from`,`trans_no_from`,`trans_type_to`,`trans_no_to`),
  KEY `From` (`trans_type_from`,`trans_no_from`),
  KEY `To` (`trans_type_to`,`trans_no_to`)
) ENGINE=InnoDB ;

### Data of table `0_supp_allocations` ###


### Structure of table `0_supp_invoice_items` ###

DROP TABLE IF EXISTS `0_supp_invoice_items`;

CREATE TABLE `0_supp_invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_trans_no` int(11) DEFAULT NULL,
  `supp_trans_type` int(11) DEFAULT NULL,
  `gl_code` varchar(15) NOT NULL DEFAULT '',
  `grn_item_id` int(11) DEFAULT NULL,
  `po_detail_item_id` int(11) DEFAULT NULL,
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` tinytext,
  `quantity` double NOT NULL DEFAULT '0',
  `unit_price` double NOT NULL DEFAULT '0',
  `unit_tax` double NOT NULL DEFAULT '0',
  `memo_` tinytext,
  `dimension_id` int(11) NOT NULL DEFAULT '0',
  `dimension2_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `Transaction` (`supp_trans_type`,`supp_trans_no`,`stock_id`)
) ENGINE=InnoDB ;

### Data of table `0_supp_invoice_items` ###


### Structure of table `0_supp_trans` ###

DROP TABLE IF EXISTS `0_supp_trans`;

CREATE TABLE `0_supp_trans` (
  `trans_no` int(11) unsigned NOT NULL DEFAULT '0',
  `type` smallint(6) unsigned NOT NULL DEFAULT '0',
  `supplier_id` int(11) unsigned NOT NULL DEFAULT '0',
  `reference` tinytext NOT NULL,
  `supp_reference` varchar(60) NOT NULL DEFAULT '',
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
  `due_date` date NOT NULL DEFAULT '0000-00-00',
  `ov_amount` double NOT NULL DEFAULT '0',
  `ov_discount` double NOT NULL DEFAULT '0',
  `ov_gst` double NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '1',
  `alloc` double NOT NULL DEFAULT '0',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type`,`trans_no`,`supplier_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_supp_trans` ###


### Structure of table `0_suppliers` ###

DROP TABLE IF EXISTS `0_suppliers`;

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_name` varchar(60) NOT NULL DEFAULT '',
  `address` tinytext NOT NULL,
  `supp_address` tinytext NOT NULL,
  `gst_no` varchar(25) NOT NULL DEFAULT '',
  `contact` varchar(60) NOT NULL DEFAULT '',
  `supp_account_no` varchar(40) NOT NULL DEFAULT '',
  `website` varchar(100) NOT NULL DEFAULT '',
  `bank_account` varchar(60) NOT NULL DEFAULT '',
  `curr_code` char(3) DEFAULT NULL,
  `payment_terms` int(11) DEFAULT NULL,
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  `dimension_id` int(11) DEFAULT '0',
  `dimension2_id` int(11) DEFAULT '0',
  `tax_group_id` int(11) DEFAULT NULL,
  `credit_limit` double NOT NULL DEFAULT '0',
  `purchase_account` varchar(15) NOT NULL DEFAULT '',
  `payable_account` varchar(15) NOT NULL DEFAULT '',
  `payment_discount_account` varchar(15) NOT NULL DEFAULT '',
  `notes` tinytext NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `supp_ref` varchar(30) NOT NULL,
  PRIMARY KEY (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=InnoDB ;

### Data of table `0_suppliers` ###


### Structure of table `0_sys_prefs` ###

DROP TABLE IF EXISTS `0_sys_prefs`;

CREATE TABLE `0_sys_prefs` (
  `name` varchar(35) NOT NULL DEFAULT '',
  `category` varchar(30) DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `length` smallint(6) DEFAULT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`name`),
  KEY `category` (`category`)
) ENGINE=InnoDB ;

### Data of table `0_sys_prefs` ###

INSERT INTO `0_sys_prefs` VALUES
('accounts_alpha', 'glsetup.general', 'tinyint', '1', '0'),
('accumulate_shipping', 'glsetup.customer', 'tinyint', '1', '0'),
('add_pct', 'setup.company', 'int', '5', '-1'),
('allow_negative_prices', 'glsetup.inventory', 'tinyint', '1', '1'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', '1', '0'),
('alternative_tax_include_on_docs', 'setup.company', 'tinyint', '1', '0'),
('auto_curr_reval', 'setup.company', 'smallint', '6', '1'),
('bank_charge_act', 'glsetup.general', 'varchar', '15', '1430'),
('base_sales', 'setup.company', 'int', '11', '-1'),
('bcc_email', 'setup.company', 'varchar', '100', ''),
('coy_logo', 'setup.company', 'varchar', '100', ''),
('coy_name', 'setup.company', 'varchar', '60', 'Company name'),
('coy_no', 'setup.company', 'varchar', '25', ''),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '600000000'),
('curr_default', 'setup.company', 'char', '3', 'EUR'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '700000000'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '300000000'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '600000000'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '700000000'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '300000000'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '700000000'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', '6', '30'),
('default_receival_required', 'glsetup.purchase', 'smallint', '6', '10'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '700000000'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '700000000'),
('default_wip_act', 'glsetup.items', 'varchar', '15', '300000000'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', ''),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('domicile', 'setup.company', 'varchar', '55', ''),
('email', 'setup.company', 'varchar', '100', ''),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '700000000'),
('f_year', 'setup.company', 'int', '11', '1'),
('fax', 'setup.company', 'varchar', '30', ''),
('freight_act', 'glsetup.customer', 'varchar', '15', '600000000'),
('gl_closing_date', 'setup.closing_date', 'date', '8', ''),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '0'),
('gst_no', 'setup.company', 'varchar', '25', ''),
('legal_text', 'glsetup.customer', 'tinytext', '0', ''),
('loc_notification', 'glsetup.inventory', 'tinyint', '1', '0'),
('login_tout', 'setup.company', 'smallint', '6', '600'),
('no_customer_list', 'setup.company', 'tinyint', '1', '0'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('no_zero_lines_amount', 'glsetup.sales', 'tinyint', '1', '1'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('phone', 'setup.company', 'varchar', '30', ''),
('po_over_charge', 'glsetup.purchase', 'int', '11', '10'),
('po_over_receive', 'glsetup.purchase', 'int', '11', '10'),
('postal_address', 'setup.company', 'tinytext', '0', 'N/A'),
('print_invoice_no', 'glsetup.sales', 'tinyint', '1', '0'),
('print_item_images_on_quote', 'glsetup.inventory', 'tinyint', '1', '0'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '600000000'),
('ref_no_auto_increase','setup.company', 'tinyint', 1, '0'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '2050'),
('round_to', 'setup.company', 'int', '5', '1'),
('show_po_item_codes', 'glsetup.purchase', 'tinyint', '1', '0'),
('suppress_tax_rates', 'setup.company', 'tinyint', '1', '0'),
('tax_algorithm', 'glsetup.customer', 'tinyint', '1', '1'),
('tax_last', 'setup.company', 'int', '11', '1'),
('tax_prd', 'setup.company', 'int', '11', '1'),
('time_zone', 'setup.company', 'tinyint', '1', '0'),
('use_dimension', 'setup.company', 'tinyint', '1', '1'),
('use_fixed_assets', 'setup.company', 'tinyint', '1', '1'),
('use_manufacturing', 'setup.company', 'tinyint', '1', '1'),
('version_id', 'system', 'varchar', '11', '2.4.1');


### Structure of table `0_tag_associations` ###

DROP TABLE IF EXISTS `0_tag_associations`;

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=InnoDB ;

### Data of table `0_tag_associations` ###


### Structure of table `0_tags` ###

DROP TABLE IF EXISTS `0_tags`;

CREATE TABLE `0_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=InnoDB ;

### Data of table `0_tags` ###


### Structure of table `0_tax_group_items` ###

DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
  `tax_group_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_shipping` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB ;

### Data of table `0_tax_group_items` ###


### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_tax_groups` ###


### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rate` double NOT NULL DEFAULT '0',
  `sales_gl_code` varchar(15) NOT NULL DEFAULT '',
  `purchasing_gl_code` varchar(15) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`rate`)
) ENGINE=InnoDB AUTO_INCREMENT=11 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('2', '4', '47204', '47704', 'IVA', '0'),
('3', '7', '47207', '47707', 'IVA', '0'),
('4', '16', '47216', '47716', 'IVA', '0'),
('7', '8', '47208', '47708', 'IVA', '0'),
('8', '18', '47218', '47718', 'IVA', '0'),
('9', '10', '47210', '47710', 'IVA', '0'),
('10', '21', '47221', '47721', 'IVA', '0');

### Structure of table `0_trans_tax_details` ###

DROP TABLE IF EXISTS `0_trans_tax_details`;

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `tran_date` date NOT NULL,
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  `rate` double NOT NULL DEFAULT '0',
  `ex_rate` double NOT NULL DEFAULT '1',
  `included_in_price` tinyint(1) NOT NULL DEFAULT '0',
  `net_amount` double NOT NULL DEFAULT '0',
  `amount` double NOT NULL DEFAULT '0',
  `memo` tinytext,
  `reg_type` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Type_and_Number` (`trans_type`,`trans_no`),
  KEY `tran_date` (`tran_date`)
) ENGINE=InnoDB ;

### Data of table `0_trans_tax_details` ###


### Structure of table `0_useronline` ###

DROP TABLE IF EXISTS `0_useronline`;

CREATE TABLE `0_useronline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(15) NOT NULL DEFAULT '0',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `file` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB ;

### Data of table `0_useronline` ###


### Structure of table `0_users` ###

DROP TABLE IF EXISTS `0_users`;

CREATE TABLE `0_users` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(60) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `real_name` varchar(100) NOT NULL DEFAULT '',
  `role_id` int(11) NOT NULL DEFAULT '1',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `date_format` tinyint(1) NOT NULL DEFAULT '0',
  `date_sep` tinyint(1) NOT NULL DEFAULT '0',
  `tho_sep` tinyint(1) NOT NULL DEFAULT '0',
  `dec_sep` tinyint(1) NOT NULL DEFAULT '0',
  `theme` varchar(20) NOT NULL DEFAULT 'default',
  `page_size` varchar(20) NOT NULL DEFAULT 'A4',
  `prices_dec` smallint(6) NOT NULL DEFAULT '2',
  `qty_dec` smallint(6) NOT NULL DEFAULT '2',
  `rates_dec` smallint(6) NOT NULL DEFAULT '4',
  `percent_dec` smallint(6) NOT NULL DEFAULT '1',
  `show_gl` tinyint(1) NOT NULL DEFAULT '1',
  `show_codes` tinyint(1) NOT NULL DEFAULT '0',
  `show_hints` tinyint(1) NOT NULL DEFAULT '0',
  `last_visit_date` datetime DEFAULT NULL,
  `query_size` tinyint(1) unsigned NOT NULL DEFAULT '10',
  `graphic_links` tinyint(1) DEFAULT '1',
  `pos` smallint(6) DEFAULT '1',
  `print_profile` varchar(30) NOT NULL DEFAULT '1',
  `rep_popup` tinyint(1) DEFAULT '1',
  `sticky_doc_date` tinyint(1) DEFAULT '0',
  `startup_tab` varchar(20) NOT NULL DEFAULT 'orders',
  `transaction_days` int(6) NOT NULL DEFAULT '30' COMMENT 'Transaction days',
  `save_report_selections` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Save Report Selection Days',
  `use_date_picker` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Use Date Picker for all Date Values',
  `def_print_destination` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Default Report Destination',
  `def_print_orientation` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Default Report Orientation',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2008-04-04 12:34:29', '10', '1', '1', '1', '1', '0', 'orders', '30', '0', '1', '0', '0', '0');

### Structure of table `0_voided` ###

DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
  `type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `memo_` tinytext NOT NULL,
  UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB ;

### Data of table `0_voided` ###


### Structure of table `0_wo_costing` ###

DROP TABLE IF EXISTS `0_wo_costing`;

CREATE TABLE `0_wo_costing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `cost_type` tinyint(1) NOT NULL DEFAULT '0',
  `trans_type` int(11) NOT NULL DEFAULT '0',
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `factor` double NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

### Data of table `0_wo_costing` ###


### Structure of table `0_wo_issue_items` ###

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` varchar(40) DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `qty_issued` double DEFAULT NULL,
  `unit_cost` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

### Data of table `0_wo_issue_items` ###


### Structure of table `0_wo_issues` ###

DROP TABLE IF EXISTS `0_wo_issues`;

CREATE TABLE `0_wo_issues` (
  `issue_no` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `loc_code` varchar(5) DEFAULT NULL,
  `workcentre_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`issue_no`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB ;

### Data of table `0_wo_issues` ###


### Structure of table `0_wo_manufacture` ###

DROP TABLE IF EXISTS `0_wo_manufacture`;

CREATE TABLE `0_wo_manufacture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) DEFAULT NULL,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '0',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB ;

### Data of table `0_wo_manufacture` ###


### Structure of table `0_wo_requirements` ###

DROP TABLE IF EXISTS `0_wo_requirements`;

CREATE TABLE `0_wo_requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workorder_id` int(11) NOT NULL DEFAULT '0',
  `stock_id` char(20) NOT NULL DEFAULT '',
  `workcentre` int(11) NOT NULL DEFAULT '0',
  `units_req` double NOT NULL DEFAULT '1',
  `unit_cost` double NOT NULL DEFAULT '0',
  `loc_code` char(5) NOT NULL DEFAULT '',
  `units_issued` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB ;

### Data of table `0_wo_requirements` ###


### Structure of table `0_workcentres` ###

DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL DEFAULT '',
  `description` char(50) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_workcentres` ###


### Structure of table `0_workorders` ###

DROP TABLE IF EXISTS `0_workorders`;

CREATE TABLE `0_workorders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wo_ref` varchar(60) NOT NULL DEFAULT '',
  `loc_code` varchar(5) NOT NULL DEFAULT '',
  `units_reqd` double NOT NULL DEFAULT '1',
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `date_` date NOT NULL DEFAULT '0000-00-00',
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `required_by` date NOT NULL DEFAULT '0000-00-00',
  `released_date` date NOT NULL DEFAULT '0000-00-00',
  `units_issued` double NOT NULL DEFAULT '0',
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `released` tinyint(1) NOT NULL DEFAULT '0',
  `additional_costs` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB ;

### Data of table `0_workorders` ###
