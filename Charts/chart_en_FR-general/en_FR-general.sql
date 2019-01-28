# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 17:06
# Built by FrontAccounting 2.4.RC1
# http://frontaccounting.com
# Company: Training Co.
# User: 

# Compatibility: 2.4.1


SET NAMES latin1;


### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('2', 'France', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('531100', '3', 'Bank', '', '', NULL, 'EUR', '0', '1', '1430', '0000-00-00 00:00:00', '0', '0'),
('512100', '1', 'Bank', '', '', NULL, 'EUR', '0', '2', '1430', '0000-00-00 00:00:00', '0', '0');

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
('1', '1 Capital', '3', '0'),
('2', '2 Fixed assets', '1', '0'),
('3', '3 Stocks and work in progress', '1', '0'),
('4', '4 Debts receivable and payable', '2', '0'),
('5', '5 Financial', '1', '0'),
('6', '6 Expenses', '6', '0'),
('7', '7 Income', '4', '0');

### Structure of table `0_chart_master` ###

DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
  `account_code` varchar(15) NOT NULL DEFAULT '',
  `account_code2` varchar(15) NOT NULL DEFAULT '',
  `account_name` varchar(60) NOT NULL DEFAULT '',
  `account_type` varchar(10) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_code`),
  KEY `account_name` (`account_name`),
  KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=InnoDB ;

### Data of table `0_chart_master` ###

INSERT INTO `0_chart_master` VALUES
('100000', '', 'Capital and reserves', '10', '0'),
('101000', '', 'Capital', '101', '0'),
('101100', '', 'Subscribed capital uncalled', '1011', '0'),
('101200', '', 'Subscribed capital - called up, unpaid', '1012', '0'),
('101300', '', 'Subscribed capital - called up, paid', '1013', '0'),
('101310', '', 'Capital not written off', '10131', '0'),
('101320', '', 'Capital written off', '10132', '0'),
('101800', '', 'Subscribed capital subject to particular regulations', '1018', '0'),
('104000', '', 'Premiums on share capital', '104', '0'),
('104100', '', 'Share premiums', '1041', '0'),
('104200', '', 'Merger premiums', '1042', '0'),
('104300', '', 'Contribution premiums', '1043', '0'),
('104400', '', 'Premiums on conversion of bonds into shares', '1044', '0'),
('104500', '', 'Equity warrants', '1045', '0'),
('105000', '', 'Revaluation differences', '105', '0'),
('105100', '', 'Special revaluation reserve', '1051', '0'),
('105200', '', 'Voluntary revaluation difference', '1052', '0'),
('105300', '', 'Revaluation reserve', '1053', '0'),
('105500', '', 'Revaluation differences (other legal transactions)', '1055', '0'),
('105700', '', 'Other revaluation differences in France', '1057', '0'),
('105800', '', 'Other revaluation differences outside France', '1058', '0'),
('106000', '', 'Reserves', '106', '0'),
('106100', '', 'Legal reserve', '1061', '0'),
('106110', '', 'Basic legal reserve', '10611', '0'),
('106120', '', 'Net long-term capital gains', '10612', '0'),
('106200', '', 'Undistributable reserves', '1062', '0'),
('106300', '', 'Statutory or contractual reserves', '1063', '0'),
('106400', '', 'Tax-regulated reserves', '1064', '0'),
('106410', '', 'Net long-term capital gains', '10641', '0'),
('106430', '', 'Reserves consequent on award of investment grants', '10643', '0'),
('106480', '', 'Other tax-regulated reserves', '10648', '0'),
('106800', '', 'Other reserves', '1068', '0'),
('106810', '', 'Self-insurance reserve', '10681', '0'),
('106880', '', 'Sundry reserves', '10688', '0'),
('107000', '', 'Difference on equity accounted investments', '107', '0'),
('108000', '', 'Drawings account', '108', '0'),
('109000', '', 'Shareholders: Subscribed capital uncalled', '109', '0'),
('110000', '', 'Profit carried forward', '110', '0'),
('119000', '', 'Loss carried forward', '119', '0'),
('120000', '', 'Profit for the financial year', '120', '0'),
('129000', '', 'Loss for the financial year', '129', '0'),
('130000', '', 'Investment grants', '13', '0'),
('131000', '', 'Equipment grants', '131', '0'),
('131100', '', 'State', '1311', '0'),
('131200', '', 'Regions', '1312', '0'),
('131300', '', 'Departments', '1313', '0'),
('131400', '', 'Municipalities', '1314', '0'),
('131500', '', 'Public authorities', '1315', '0'),
('131600', '', 'Public enterprises', '1316', '0'),
('131700', '', 'Enterprises and private bodies', '1317', '0'),
('131800', '', 'Other', '1318', '0'),
('138000', '', 'Other investment grants (same allocation as for Account 131)', '138', '0'),
('139000', '', 'Investment grants credited to the profit and loss account', '139', '0'),
('139100', '', 'Equipment grants', '1391', '0'),
('139110', '', 'State', '13911', '0'),
('139120', '', 'Regions', '13912', '0'),
('139130', '', 'Departments', '13913', '0'),
('139140', '', 'Municipalities', '13914', '0'),
('139150', '', 'Public authorities', '13915', '0'),
('139160', '', 'Public enterprises', '13916', '0'),
('139170', '', 'Enterprises and private bodies', '13917', '0'),
('139180', '', 'Other', '13918', '0'),
('139800', '', 'Other investment grants (same allocation as for Account 1391', '1398', '0'),
('140000', '', 'Tax-regulated provisions', '14', '0'),
('142000', '', 'Fixed assets', '142', '0'),
('142300', '', 'Provisions for reconstitution of mining and petroleum deposi', '1423', '0'),
('142400', '', 'Provisions for investment (employee profit share)', '1424', '0'),
('143000', '', 'Stocks', '143', '0'),
('143100', '', 'Price increase', '1431', '0'),
('143200', '', 'Exchange rate fluctuations', '1432', '0'),
('144000', '', 'Other asset components', '144', '0'),
('145000', '', 'Depreciation by derogation', '145', '0'),
('146000', '', 'Special revaluation provision', '146', '0'),
('147000', '', 'Capital gains reinvested', '147', '0'),
('148000', '', 'Other tax-regulated provisions', '148', '0'),
('150000', '', 'Provisions for liabilities and charges', '15', '0'),
('151000', '', 'Provisions for liabilities', '151', '0'),
('151100', '', 'Provisions for litigation', '1511', '0'),
('151200', '', 'Provisions for customer warranties', '1512', '0'),
('151300', '', 'Provisions for losses on futures', '1513', '0'),
('151400', '', 'Provisions for fines and penalties', '1514', '0'),
('151500', '', 'Provisions for foreign exchange losses', '1515', '0'),
('151800', '', 'Other provisions for liabilities', '1518', '0'),
('153000', '', 'Provisions for pensions and similar obligations', '153', '0'),
('155000', '', 'Provisions for taxation', '155', '0'),
('156000', '', 'Provisions for fixed asset renewal (concession entities)', '156', '0'),
('157000', '', 'Provisions for deferred charges', '157', '0'),
('157200', '', 'Provisions for major repairs', '1572', '0'),
('158000', '', 'Other provisions for charges', '158', '0'),
('158200', '', 'Provisions for social security and tax charges on holiday pa', '1582', '0'),
('160000', '', 'Loans and similar debts payable', '16', '0'),
('161000', '', 'Convertible debenture loans', '161', '0'),
('163000', '', 'Other debenture loans', '163', '0'),
('164000', '', 'Loans from credit institutions', '164', '0'),
('165000', '', 'Deposits and sureties received', '165', '0'),
('165100', '', 'Deposits', '1651', '0'),
('165500', '', 'Sureties', '1655', '0'),
('166000', '', 'Employee profit share', '166', '0'),
('166100', '', 'Blocked accounts', '1661', '0'),
('166200', '', 'Profit share funds', '1662', '0'),
('167000', '', 'Loans and debts payable subject to particular conditions', '167', '0'),
('167100', '', 'Issues of non-voting shares', '1671', '0'),
('167400', '', 'Advances by the state subject to conditions', '1674', '0'),
('167500', '', 'Participating loans', '1675', '0'),
('168000', '', 'Other loans and similar debts payable', '168', '0'),
('168100', '', 'Other loans', '1681', '0'),
('168500', '', 'Capitalised life annuities', '1685', '0'),
('168700', '', 'Other debts payable', '1687', '0'),
('168800', '', 'Accrued interest', '1688', '0'),
('168810', '', 'On convertible debenture loans', '16881', '0'),
('168830', '', 'On other debenture loans', '16883', '0'),
('168840', '', 'On loans from credit institutions', '16884', '0'),
('168850', '', 'On deposits and sureties received', '16885', '0'),
('168860', '', 'On employee profit share', '16886', '0'),
('168870', '', 'On loans and debts payable subject to particular conditions', '16887', '0'),
('168880', '', 'On other loans and similar debts payable', '16888', '0'),
('169000', '', 'Debt redemption premiums', '169', '0'),
('170000', '', 'Debts payable related to participating interests', '17', '0'),
('171000', '', 'Debts payable related to participating interests (group)', '171', '0'),
('174000', '', 'Debts payable related to participating interests (apart from', '174', '0'),
('178000', '', 'Debts payable related to joint ventures', '178', '0'),
('178100', '', 'Principal', '1781', '0'),
('178800', '', 'Accrued interest', '1788', '0'),
('180000', '', 'Reciprocal branch and joint venture accounts', '18', '0'),
('181000', '', 'Reciprocal branch accounts', '181', '0'),
('186000', '', 'Goods and services exchanged between establishments (charges', '186', '0'),
('187000', '', 'Goods and services exchanged between establishments (income)', '187', '0'),
('188000', '', 'Reciprocal joint venture accounts', '188', '0'),
('200000', '', 'Intangible fixed assets', '20', '0'),
('201000', '', 'Establishment costs', '201', '0'),
('201100', '', 'Incorporation costs', '2011', '0'),
('201200', '', 'Start-up costs', '2012', '0'),
('201210', '', 'Commercial assessment costs', '20121', '0'),
('201220', '', 'Marketing costs', '20122', '0'),
('201300', '', 'Capital increase and sundry transaction costs (mergers, deme', '2013', '0'),
('203000', '', 'Research and development costs', '203', '0'),
('205000', '', 'Concessions and similar rights, patents, licences, trade mar', '205', '0'),
('206000', '', 'Lease premium', '206', '0'),
('207000', '', 'Goodwill', '207', '0'),
('208000', '', 'Other intangible fixed assets', '208', '0'),
('210000', '', 'Tangible fixed assets', '21', '0'),
('211000', '', 'Land', '211', '0'),
('211100', '', 'Undeveloped land', '2111', '0'),
('211200', '', 'Serviced land', '2112', '0'),
('211300', '', 'Underground and aboveground sites', '2113', '0'),
('211400', '', 'Mining sites', '2114', '0'),
('211410', '', 'Quarries', '21141', '0'),
('211500', '', 'Developed land', '2115', '0'),
('211510', '', 'Industrial property complexes (A, B...)', '21151', '0'),
('211550', '', 'Administrative and commercial property complexes (A, B...)', '21155', '0'),
('211580', '', 'Other property complexes', '21158', '0'),
('211581', '', 'Property assigned to normal entity operations (A, B...)', '211581', '0'),
('211588', '', 'Property assigned to other than normal entity operations (A,', '211588', '0'),
('211600', '', 'Suspense account for non-depreciable fixed assets revalued i', '2116', '0'),
('212000', '', 'Site development (same allocation as for Account 211)', '212', '0'),
('213000', '', 'Constructions', '213', '0'),
('213100', '', 'Buildings', '2131', '0'),
('213110', '', 'Industrial property complexes (A, B...)', '21311', '0'),
('213150', '', 'Administrative and commercial property complexes (A, B...)', '21315', '0'),
('213180', '', 'Other property complexes', '21318', '0'),
('213181', '', 'Property assigned to normal entity operations (A, B...)', '213181', '0'),
('213188', '', 'Property assigned to other than normal entity operations (A,', '213188', '0'),
('213500', '', 'Building fixtures and fittings', '2135', '0'),
('213800', '', 'Infrastructure development', '2138', '0'),
('213810', '', 'Roadways', '21381', '0'),
('213820', '', 'Railways', '21382', '0'),
('213830', '', 'Water channels', '21383', '0'),
('213840', '', 'Dams', '21384', '0'),
('213850', '', 'Airfields', '21385', '0'),
('214000', '', 'Constructions on third-party sites (same allocation as for A', '214', '0'),
('215000', '', 'Technical installations, plant and machinery, equipment and ', '215', '0'),
('215100', '', 'Specialised complex installations', '2151', '0'),
('215110', '', 'On own site', '21511', '0'),
('215140', '', 'On third-party site', '21514', '0'),
('215300', '', 'Installations of specific nature', '2153', '0'),
('215310', '', 'On own site', '21531', '0'),
('215340', '', 'On third-party site', '21534', '0'),
('215400', '', 'Plant and machinery', '2154', '0'),
('215500', '', 'Equipment and fixtures', '2155', '0'),
('215700', '', 'Fixtures and fittings for plant and machinery, equipment and', '2157', '0'),
('218000', '', 'Other tangible fixed assets', '218', '0'),
('218100', '', 'Sundry general fixtures and fittings', '2181', '0'),
('218200', '', 'Transport equipment', '2182', '0'),
('218300', '', 'Office and computing equipment', '2183', '0'),
('218400', '', 'Furnishings', '2184', '0'),
('218500', '', 'Livestock', '2185', '0'),
('218600', '', 'Recoverable packaging', '2186', '0'),
('220000', '', 'Fixed assets in concession', '22', '0'),
('230000', '', 'Fixed assets in progress', '23', '0'),
('231000', '', 'Tangible fixed assets in progress', '231', '0'),
('231200', '', 'Land', '2312', '0'),
('231300', '', 'Constructions', '2313', '0'),
('231500', '', 'Technical installations, plant and machinery, equipment and ', '2315', '0'),
('231800', '', 'Other tangible fixed assets', '2318', '0'),
('232000', '', 'Intangible fixed assets in progress', '232', '0'),
('237000', '', 'Payments on account on intangible fixed assets', '237', '0'),
('238000', '', 'Payments on account on orders for tangible fixed assets', '238', '0'),
('238200', '', 'Land', '2382', '0'),
('238300', '', 'Constructions', '2383', '0'),
('238500', '', 'Technical installations, plant and machinery, equipment and ', '2385', '0'),
('238800', '', 'Other tangible fixed assets', '2388', '0'),
('250000', '', 'Shares in and receivables due from affiliated entities', '25', '0'),
('260000', '', 'Participating interests and related debts receivable', '26', '0'),
('261000', '', 'Long-term equity interests', '261', '0'),
('261100', '', 'Shares', '2611', '0'),
('261800', '', 'Other securities', '2618', '0'),
('266000', '', 'Other categories of participating interest', '266', '0'),
('267000', '', 'Debts receivable related to participating interests', '267', '0'),
('267100', '', 'Debts receivable related to participating interests (group)', '2671', '0'),
('267400', '', 'Debts receivable related to participating interests (apart f', '2674', '0'),
('267500', '', 'Payments representing non-capitalised contributions (call fo', '2675', '0'),
('267600', '', 'Long-term capital advances', '2676', '0'),
('267700', '', 'Other debts receivable related to participating interests', '2677', '0'),
('267800', '', 'Accrued interest', '2678', '0'),
('268000', '', 'Debts receivable related to joint ventures', '268', '0'),
('268100', '', 'Principal', '2681', '0'),
('268800', '', 'Accrued interest', '2688', '0'),
('269000', '', 'Unpaid instalments on unpaid long-term equity interests', '269', '0'),
('270000', '', 'Other financial fixed assets', '27', '0'),
('271000', '', 'Long-term investment equity securities other than portfolio ', '271', '0'),
('271100', '', 'Shares', '2711', '0'),
('271800', '', 'Other securities', '2718', '0'),
('272000', '', 'Long-term investment debt securities', '272', '0'),
('272100', '', 'Bonds', '2721', '0'),
('272200', '', 'Warrants', '2722', '0'),
('273000', '', 'Portfolio long-term investment securities', '273', '0'),
('274000', '', 'Loans', '274', '0'),
('274100', '', 'Participating loans', '2741', '0'),
('274200', '', 'Loans to partners/associates', '2742', '0'),
('274300', '', 'Loans to personnel', '2743', '0'),
('274800', '', 'Other loans', '2748', '0'),
('275000', '', 'Deposits and sureties advanced', '275', '0'),
('275100', '', 'Deposits', '2751', '0'),
('275500', '', 'Sureties', '2755', '0'),
('276000', '', 'Other capitalised debts receivable', '276', '0'),
('276100', '', 'Sundry debts receivable', '2761', '0'),
('276800', '', 'Accrued interest', '2768', '0'),
('276820', '', 'Long-term investment debt securities', '27682', '0'),
('276840', '', 'Loans', '27684', '0'),
('276850', '', 'Deposits and sureties', '27685', '0'),
('276880', '', 'On sundry debts receivable', '27688', '0'),
('277000', '', '(Own shares)', '277', '0'),
('277100', '', 'Own shares', '2771', '0'),
('277200', '', 'Own shares in process of cancellation', '2772', '0'),
('279000', '', 'Unpaid instalments on unpaid long-term investment securities', '279', '0'),
('280000', '', 'Depreciation on intangible fixed assets', '280', '0'),
('280100', '', 'Establishment costs (same allocation as for Account 201)', '2801', '0'),
('280300', '', 'Research and development costs', '2803', '0'),
('280500', '', 'Concessions and similar rights, patents, licences, software,', '2805', '0'),
('280700', '', 'Goodwill', '2807', '0'),
('280800', '', 'Other intangible fixed assets', '2808', '0'),
('281000', '', 'Depreciation on tangible fixed assets', '281', '0'),
('281100', '', 'Mining sites', '2811', '0'),
('281200', '', 'Site development (same allocation as for Account 212)', '2812', '0'),
('281300', '', 'Constructions (same allocation as for Account 213)', '2813', '0'),
('281400', '', 'Constructions on third-party site (same allocation as for Ac', '2814', '0'),
('281500', '', 'Technical installations, plant and machinery, equipment and ', '2815', '0'),
('281800', '', 'Other tangible fixed assets (same allocation as for Account ', '2818', '0'),
('282000', '', 'Depreciation on fixed assets in concession', '282', '0'),
('290000', '', 'Intangible fixed assets', '290', '0'),
('290500', '', 'rade marks, processes, rights and similar assets', '2905', '0'),
('290600', '', 'Lease premium', '2906', '0'),
('290700', '', 'Goodwill', '2907', '0'),
('290800', '', 'Other intangible fixed assets', '2908', '0'),
('291000', '', 'Tangible fixed assets (same allocation as for Account 21)', '291', '0'),
('291100', '', 'Land (other than mining sites)', '2911', '0'),
('292000', '', 'Fixed assets in concession', '292', '0'),
('293000', '', 'Fixed assets in progress', '293', '0'),
('293100', '', 'Tangible fixed assets in progress', '2931', '0'),
('293200', '', 'Intangible fixed assets in progress', '2932', '0'),
('296000', '', 'Participating interests and related debts receivable', '296', '0'),
('296100', '', 'Long-term equity interests', '2961', '0'),
('296600', '', 'Other categories of participating interests', '2966', '0'),
('296700', '', 'Debts receivable related to participating interests (same al', '2967', '0'),
('296800', '', 'Debts receivable related to joint ventures (same allocation ', '2968', '0'),
('297000', '', 'Other financial fixed assets', '297', '0'),
('297100', '', 'Long-term investment equity securities other than portfolio ', '2971', '0'),
('297200', '', 'Long-term investment debt securities (same allocation as for', '2972', '0'),
('297300', '', 'Portfolio long-term investment securities', '2973', '0'),
('297400', '', 'Loans (same allocation as for Account 274)', '2974', '0'),
('297500', '', 'Deposits and sureties advanced (same allocation as for Accou', '2975', '0'),
('297600', '', 'Other debts receivable (same allocation as for Account 276)', '2976', '0'),
('310000', '', 'Raw materials (and supplies)', '31', '0'),
('311000', '', 'Materials (or group) A', '311', '0'),
('312000', '', 'Materials (or group) B', '312', '0'),
('317000', '', 'Supplies A, B, C, ...', '317', '0'),
('320000', '', 'Other consumables', '32', '0'),
('321000', '', 'Consumable materials', '321', '0'),
('321100', '', 'Materials (or group) C', '3211', '0'),
('321200', '', 'Materials (or group) D', '3212', '0'),
('322000', '', 'Consumable supplies', '322', '0'),
('322100', '', 'Fuels', '3221', '0'),
('322200', '', 'Cleaning products', '3222', '0'),
('322300', '', 'Workshop and factory supplies', '3223', '0'),
('322400', '', 'Store supplies', '3224', '0'),
('322500', '', 'Office supplies', '3225', '0'),
('326000', '', 'Packaging', '326', '0'),
('326100', '', 'Non-returnable packaging', '3261', '0'),
('326500', '', 'Unidentifiable recoverable packaging', '3265', '0'),
('326700', '', 'Mixed usage packaging', '3267', '0'),
('330000', '', 'Work in progress (goods)', '33', '0'),
('331000', '', 'Products in progress (goods)', '331', '0'),
('331100', '', 'Products in progress P 1', '3311', '0'),
('331200', '', 'Products in progress P 2', '3312', '0'),
('335000', '', 'Works in progress', '335', '0'),
('335100', '', 'Works in progress T 1', '3351', '0'),
('335200', '', 'Works in progress T 2', '3352', '0'),
('340000', '', 'Work in progress (services)', '34', '0'),
('341000', '', 'Project studies in progress', '341', '0'),
('341100', '', 'Project studies in progress E 1', '3411', '0'),
('341200', '', 'Project studies in progress E 2', '3412', '0'),
('345000', '', 'Supply of services in progress', '345', '0'),
('345100', '', 'Supply of services in progress S 1', '3451', '0'),
('345200', '', 'Supply of services in progress S 2', '3452', '0'),
('350000', '', 'Product stocks', '35', '0'),
('351000', '', 'Semi-finished products', '351', '0'),
('351100', '', 'Semi-finished products (or group) A', '3511', '0'),
('351200', '', 'Semi-finished products (or group) B', '3512', '0'),
('355000', '', 'Finished products', '355', '0'),
('355100', '', 'Finished products (or group) A', '3551', '0'),
('355200', '', 'Finished products (or group) B', '3552', '0'),
('358000', '', 'Residual products (or recoverable materials)', '358', '0'),
('358100', '', 'Waste', '3581', '0'),
('358500', '', 'Refuse', '3585', '0'),
('358600', '', 'Recoverable materials', '3586', '0'),
('360000', '', '(Account to be opened, as applicable, under the title, Stock', '36', '0'),
('370000', '', 'Stocks of goods for resale', '37', '0'),
('371000', '', 'Goods for resale (or group) A', '371', '0'),
('372000', '', 'Goods for resale (or group) B', '372', '0'),
('380000', '', '(Where an entity maintains a perpetual inventory in its fina', '38', '0'),
('390000', '', 'Provisions for diminution in value of stocks and work in pro', '39', '0'),
('391000', '', 'Raw materials (and supplies)', '391', '0'),
('391100', '', 'Materials (or group) A', '3911', '0'),
('391200', '', 'Materials (or group) B', '3912', '0'),
('391700', '', 'Supplies A, B, C, ...', '3917', '0'),
('392000', '', 'Other consumables', '392', '0'),
('392100', '', 'Consumable materials (same allocation as for Account 321)', '3921', '0'),
('392200', '', 'Consumable supplies (same allocation as for Account 322)', '3922', '0'),
('392600', '', 'Packaging (same allocation as for Account 326)', '3926', '0'),
('393000', '', 'Work in progress (goods)', '393', '0'),
('393100', '', 'Products in progress (same allocation as for Account 331)', '3931', '0'),
('393500', '', 'Works in progress (same allocation as for Account 335)', '3935', '0'),
('394000', '', 'Work in progress (services)', '394', '0'),
('394100', '', 'Project studies in progress (same allocation as for Account ', '3941', '0'),
('394500', '', 'Supply of services in progress (same allocation as for Accou', '3945', '0'),
('395000', '', 'Product stocks', '395', '0'),
('395100', '', 'Semi-finished products (same allocation as for Account 351)', '3951', '0'),
('395500', '', 'Finished products (same allocation as for Account 355)', '3955', '0'),
('397000', '', 'Goods for resale', '397', '0'),
('397100', '', 'Goods for resale (or group) A', '3971', '0'),
('397200', '', 'Goods for resale (or group) B', '3972', '0'),
('400000', '', 'Suppliers and related accounts', '40', '0'),
('401000', '', 'Suppliers', '401', '0'),
('401100', '', 'Suppliers - Purchases of goods and services', '4011', '0'),
('401700', '', 'Suppliers - Contract performance holdbacks', '4017', '0'),
('403000', '', 'Suppliers - Bills payable', '403', '0'),
('404000', '', 'Fixed asset suppliers', '404', '0'),
('404100', '', 'Suppliers - Fixed asset purchases', '4041', '0'),
('404700', '', 'Fixed asset suppliers - Contract performance holdbacks', '4047', '0'),
('405000', '', 'Fixed asset suppliers - Bills payable', '405', '0'),
('408000', '', 'Suppliers - Invoices outstanding', '408', '0'),
('408100', '', 'Suppliers', '4081', '0'),
('408400', '', 'Fixed asset suppliers', '4084', '0'),
('408800', '', 'Suppliers - Accrued interest', '4088', '0'),
('409000', '', 'Suppliers in debit', '409', '0'),
('409100', '', 'Suppliers - Payments on account on orders', '4091', '0'),
('409600', '', 'Suppliers - Debts receivable for returnable packaging and eq', '4096', '0'),
('409700', '', 'Suppliers - Other debits', '4097', '0'),
('409710', '', 'Operating suppliers', '40971', '0'),
('409740', '', 'Fixed asset suppliers', '40974', '0'),
('409800', '', 'Purchase rebates, discounts, allowances and other outstandin', '4098', '0'),
('410000', '', 'Customers and related accounts', '41', '0'),
('411000', '', 'Customers', '411', '0'),
('411100', '', 'Customers - Sales of goods and services', '4111', '0'),
('411700', '', 'Customers - Contract performance holdbacks', '4117', '0'),
('413000', '', 'Customers - Bills receivable', '413', '0'),
('416000', '', 'Doubtful or contested customer accounts', '416', '0'),
('417000', '', 'Future debts receivable for work not yet chargeable', '417', '0'),
('418000', '', 'Customers - Charges not yet invoiced', '418', '0'),
('418100', '', 'Customers - Invoices to be made out', '4181', '0'),
('418800', '', 'Customers - Accrued interest', '4188', '0'),
('419000', '', 'Customers in credit', '419', '0'),
('419100', '', 'Customers - Payments on account received on orders', '4191', '0'),
('419600', '', 'Customers - Debts payable for returnable packaging and equip', '4196', '0'),
('419700', '', 'Customers - Other credits', '4197', '0'),
('419800', '', 'Sales rebates, discounts, allowances and other credits not y', '4198', '0'),
('420000', '', 'Personnel and related accounts', '42', '0'),
('421000', '', 'Remuneration payable', '421', '0'),
('422000', '', 'Enterprise/establishment consultative committees', '422', '0'),
('424000', '', 'Employee profit share', '424', '0'),
('424600', '', 'Special reserve (Art. L. 442-2, Code du travail)', '4246', '0'),
('424800', '', 'Current accounts', '4248', '0'),
('425000', '', 'Payments on account', '425', '0'),
('426000', '', 'Deposits', '426', '0'),
('427000', '', 'Stoppages of payment', '427', '0'),
('428000', '', 'Accrued charges payable and income receivable', '428', '0'),
('428200', '', 'Accrued charges payable for holiday pay', '4282', '0'),
('428400', '', 'Accrued charges payable for employee profit share', '4284', '0'),
('428600', '', 'Other accrued charges payable', '4286', '0'),
('428700', '', 'Accrued income receivable', '4287', '0'),
('430000', '', 'Social security and other social agencies', '43', '0'),
('431000', '', 'Social security', '431', '0'),
('437000', '', 'Other social agencies', '437', '0'),
('438000', '', 'Social agencies - Accrued charges payable and income receiva', '438', '0'),
('438200', '', 'Contributions for holiday pay', '4382', '0'),
('438600', '', 'Other accrued charges payable', '4386', '0'),
('438700', '', 'Accrued income receivable', '4387', '0'),
('440000', '', 'State and other public authorities', '44', '0'),
('441000', '', 'Grants receivable', '441', '0'),
('441100', '', 'Investment grants', '4411', '0'),
('441700', '', 'Operating grants', '4417', '0'),
('441800', '', 'Deficit grants', '4418', '0'),
('441900', '', 'Grant advances', '4419', '0'),
('442000', '', 'Taxes and levies recoverable from third parties', '442', '0'),
('442400', '', 'Bondholders', '4424', '0'),
('442500', '', 'Partners/associates', '4425', '0'),
('443000', '', 'Particular transactions with the state, public authorities, ', '443', '0'),
('443100', '', 'Debts receivable from the state resulting from abolition of ', '4431', '0'),
('443800', '', 'Accrued interest on debts receivable recorded in Account 443', '4438', '0'),
('444000', '', 'Income tax', '444', '0'),
('445000', '', 'Turnover tax', '445', '0'),
('445200', '', 'Value added tax due within the European Union', '4452', '0'),
('445500', '', 'Turnover tax payable', '4455', '0'),
('445510', '', 'Value added tax to be disbursed', '44551', '0'),
('445580', '', 'Taxes in the same category as value added tax', '44558', '0'),
('445600', '', 'Turnover tax deductible', '4456', '0'),
('445620', '', 'Value added tax on fixed assets', '44562', '0'),
('445630', '', 'Value added tax transferred by other entities', '44563', '0'),
('445660', '', 'Value added tax on other goods and services', '44566', '0'),
('445670', '', 'Value added tax credit to be carried forward', '44567', '0'),
('445680', '', 'Taxes in the same category as value added tax', '44568', '0'),
('445700', '', 'Turnover tax collected by the entity', '4457', '0'),
('445710', '', 'Value added tax collected', '44571', '0'),
('445780', '', 'Taxes in the same category as value added tax', '44578', '0'),
('445800', '', 'Turnover tax to be settled or in suspense', '4458', '0'),
('445810', '', 'Instalments - Simplified tax regime', '44581', '0'),
('445820', '', 'Instalments - Substituted assessment of estimated turnover', '44582', '0'),
('445830', '', 'Requested reimbursement of turnover tax', '44583', '0'),
('445840', '', 'Value added tax recovered in advance', '44584', '0'),
('445860', '', 'Turnover tax on invoices outstanding', '44586', '0'),
('445870', '', 'Turnover tax on invoices to be made out', '44587', '0'),
('446000', '', 'Guaranteed bonds', '446', '0'),
('447000', '', 'Other taxes, levies and similar payments', '447', '0'),
('448000', '', 'Accrued charges payable and income receivable', '448', '0'),
('448200', '', 'Tax charges on holiday pay', '4482', '0'),
('448600', '', 'Accrued charges payable', '4486', '0'),
('448700', '', 'Accrued income receivable', '4487', '0'),
('450000', '', 'Group and partners/associates', '45', '0'),
('451000', '', 'Group', '451', '0'),
('455000', '', 'Partners/associates - Current accounts', '455', '0'),
('455100', '', 'Principal', '4551', '0'),
('455800', '', 'Accrued interest', '4558', '0'),
('456000', '', 'Partners/associates - Capital transactions', '456', '0'),
('456100', '', 'Partners/associates - Company contribution accounts', '4561', '0'),
('456110', '', 'Contributions in kind', '45611', '0'),
('456150', '', 'Contributions in money', '45615', '0'),
('456200', '', 'Contributors - Capital called up, unpaid', '4562', '0'),
('456210', '', 'Shareholders - Subscribed capital called up, unpaid', '45621', '0'),
('456250', '', 'Partners/associates - Capital called up, unpaid', '45625', '0'),
('456300', '', 'Partners/associates - Payments received for capital increase', '4563', '0'),
('456400', '', 'Partners/associates - Advance payments', '4564', '0'),
('456600', '', 'Defaulting shareholders', '4566', '0'),
('456700', '', 'Partners/associates - Capital to be reimbursed', '4567', '0'),
('457000', '', 'Partners/associates - Dividends payable', '457', '0'),
('458000', '', 'Partners/associates - Joint and Economic Interest Group tran', '458', '0'),
('458100', '', 'Current transactions', '4581', '0'),
('458800', '', 'Accrued interest', '4588', '0'),
('460000', '', 'Sundry debts receivable and payable', '46', '0'),
('462000', '', 'Debts receivable on realisation of fixed assets', '462', '0'),
('464000', '', 'Debts payable on purchases of short-term investment securiti', '464', '0'),
('465000', '', 'Debts receivable on realisation of short-term investment sec', '465', '0'),
('467000', '', 'Other debtors or creditors', '467', '0'),
('468000', '', 'Sundry - Accrued charges payable and income receivable', '468', '0'),
('468600', '', 'Accrued charges payable', '4686', '0'),
('468700', '', 'Accrued income receivable', '4687', '0'),
('470000', '', 'Provisional or suspense accounts', '47', '0'),
('471000', '', '475 - Suspense accounts', '471', '0'),
('476000', '', 'Realisable currency exchange losses', '476', '0'),
('476100', '', 'Decrease in debts receivable', '4761', '0'),
('476200', '', 'Increase in debts payable', '4762', '0'),
('476800', '', 'Differences offset by foreign currency hedging', '4768', '0'),
('477000', '', 'Realisable currency exchange gains', '477', '0'),
('477100', '', 'Increase in debts receivable', '4771', '0'),
('477200', '', 'Decrease in debts payable', '4772', '0'),
('477800', '', 'Differences offset by foreign currency hedging', '4778', '0'),
('478000', '', 'Other provisional accounts', '478', '0'),
('480000', '', 'Accrual accounts', '48', '0'),
('481000', '', 'Charges to be allocated to more than one period', '481', '0'),
('481100', '', 'Deferred charges', '4811', '0'),
('481200', '', 'Fixed asset acquisition costs', '4812', '0'),
('481600', '', 'Loan issue costs', '4816', '0'),
('481800', '', 'Charges to be apportioned', '4818', '0'),
('486000', '', 'Prepayments', '486', '0'),
('487000', '', 'Deferred income', '487', '0'),
('488000', '', 'Periodic allocation of charges and income', '488', '0'),
('488600', '', 'Charges', '4886', '0'),
('488700', '', 'Income', '4887', '0'),
('490000', '', 'Provisions for doubtful debts', '49', '0'),
('491000', '', 'Provisions for doubtful trade debts', '491', '0'),
('495000', '', 'Provisions for group and partners/associates doubtful debts', '495', '0'),
('495100', '', 'Group accounts', '4951', '0'),
('495500', '', 'Current accounts of partners/associates', '4955', '0'),
('495800', '', 'Joint and Economic Interest Group transactions', '4958', '0'),
('496000', '', 'Provisions for sundry doubtful debts', '496', '0'),
('496200', '', 'Debts receivable on realisation of fixed assets', '4962', '0'),
('496500', '', 'Debts receivable on realisation of short-term investment sec', '4965', '0'),
('496700', '', 'Other debtor accounts', '4967', '0'),
('500000', '', 'Short-term investment securities', '50', '0'),
('501000', '', 'Shares in affiliated entities', '501', '0'),
('502000', '', 'Own shares', '502', '0'),
('503000', '', 'Shares', '503', '0'),
('503100', '', 'Quoted shares', '5031', '0'),
('503500', '', 'Unquoted shares', '5035', '0'),
('504000', '', 'Other equity securities', '504', '0'),
('505000', '', 'Own bonds and warrants bought back', '505', '0'),
('506000', '', 'Bonds', '506', '0'),
('506100', '', 'Quoted bonds', '5061', '0'),
('506500', '', 'Unquoted bonds', '5065', '0'),
('507000', '', 'Treasury bills and short-term notes', '507', '0'),
('508000', '', 'Other short-term investment securities and similar debts rec', '508', '0'),
('508100', '', 'Other securities', '5081', '0'),
('508200', '', 'Equity and bond warrants', '5082', '0'),
('508800', '', 'Accrued interest on bonds, warrants and similar securities', '5088', '0'),
('509000', '', 'Unpaid instalments on unpaid short-term investment securitie', '509', '0'),
('510000', '', 'Banks, financial and similar institutions', '51', '0'),
('511000', '', 'Financial instruments for collection', '511', '0'),
('511100', '', 'Outstanding coupons for collection', '5111', '0'),
('511200', '', 'Cheques for collection', '5112', '0'),
('511300', '', 'Bills for collection', '5113', '0'),
('511400', '', 'Bills for discount', '5114', '0'),
('512000', '', 'Banks', '512', '0'),
('512100', '', 'French accounts in euros', '5121', '0'),
('512400', '', 'Accounts in foreign currencies', '5124', '0'),
('514000', '', 'Postal cheques', '514', '0'),
('515000', '', 'Treasury and public agency accounts', '515', '0'),
('516000', '', 'Stockbrokers', '516', '0'),
('517000', '', 'Other financial bodies', '517', '0'),
('518000', '', 'Accrued interest', '518', '0'),
('518100', '', 'Accrued interest payable', '5181', '0'),
('518800', '', 'Accrued interest receivable', '5188', '0'),
('519000', '', 'Current bank advances', '519', '0'),
('519100', '', 'Credit for assignment of commercial debts receivable', '5191', '0'),
('519300', '', 'Assignment of debts receivable originating outside France', '5193', '0'),
('519800', '', 'Accrued interest on current bank advances', '5198', '0'),
('520000', '', 'Short-term financial instruments', '52', '0'),
('530000', '', 'Cash on hand', '53', '0'),
('531000', '', 'Head office cash', '531', '0'),
('531100', '', 'Cash in euros', '5311', '0'),
('531400', '', 'Cash in foreign currencies', '5314', '0'),
('532000', '', 'Cash at branch (or factory) A', '532', '0'),
('533000', '', 'Cash at branch (or factory) B', '533', '0'),
('540000', '', 'Expenditure authorisations and letters of credit', '54', '0'),
('580000', '', 'Internal transfers', '58', '0'),
('590000', '', 'Short-term investment securities', '590', '0'),
('590300', '', 'Shares', '5903', '0'),
('590400', '', 'Other equity securities', '5904', '0'),
('590600', '', 'Bonds', '5906', '0'),
('590800', '', 'Other short-term investment securities and similar debts rec', '5908', '0'),
('600000', '', 'Purchases (except 603)', '60', '0'),
('601000', '', 'Inventory item purchases - Raw materials (and supplies)', '601', '0'),
('601100', '', 'Materials (or group) A', '6011', '0'),
('601200', '', 'Materials (or group) B', '6012', '0'),
('601700', '', 'Supplies A, B, C...', '6017', '0'),
('602000', '', 'Inventory item purchases - Other consumables', '602', '0'),
('602100', '', 'Consumable materials', '6021', '0'),
('602110', '', 'Materials (or group) C', '60211', '0'),
('602120', '', 'Materials (or group) D', '60212', '0'),
('602200', '', 'Consumable supplies', '6022', '0'),
('602210', '', 'Fuels', '60221', '0'),
('602220', '', 'Maintenance products', '60222', '0'),
('602230', '', 'Workshop and factory supplies', '60223', '0'),
('602240', '', 'Store supplies', '60224', '0'),
('602250', '', 'Office supplies', '60225', '0'),
('602600', '', 'Packaging', '6026', '0'),
('602610', '', 'Non-returnable packaging', '60261', '0'),
('602650', '', 'Unidentifiable recoverable packaging', '60265', '0'),
('603000', '', 'Change in stocks (consumables and goods for resale)', '603', '0'),
('603100', '', 'Change in stocks of raw materials (and supplies)', '6031', '0'),
('603200', '', 'Change in stocks of other consumables', '6032', '0'),
('603700', '', 'Change in stocks of goods for resale', '6037', '0'),
('604000', '', 'Purchases of project studies and services', '604', '0'),
('605000', '', 'Purchases of equipment, facilities and works', '605', '0'),
('606000', '', 'Non-inventory materials and supplies', '606', '0'),
('606100', '', 'Non-inventoriable supplies (eg. water, energy)', '6061', '0'),
('606300', '', 'Maintenance and minor equipment supplies', '6063', '0'),
('606400', '', 'Administrative supplies', '6064', '0'),
('606800', '', 'Other materials and supplies', '6068', '0'),
('607000', '', 'Purchases of goods for resale', '607', '0'),
('607100', '', 'Goods for resale (or group) A', '6071', '0'),
('607200', '', 'Goods for resale (or group) B', '6072', '0'),
('608000', '', '(Account reserved, as applicable, for recapitulation of anci', '608', '0'),
('609000', '', 'Purchase rebates, discounts, allowances on:', '609', '0'),
('609100', '', 'Raw materials (and supplies)', '6091', '0'),
('609200', '', 'Other inventory item consumables', '6092', '0'),
('609400', '', 'Project studies and services supplied', '6094', '0'),
('609500', '', 'Equipment, facilities and works', '6095', '0'),
('609600', '', 'Non-inventory consumables', '6096', '0'),
('609700', '', 'Goods for resale', '6097', '0'),
('609800', '', 'Unallocated rebates, discounts, allowances', '6098', '0'),
('610000', '', 'External services', '61', '0'),
('611000', '', 'General subcontracting', '611', '0'),
('612000', '', 'Lease instalments', '612', '0'),
('612200', '', 'Movable property leases', '6122', '0'),
('612500', '', 'Real property leases', '6125', '0'),
('613000', '', 'Rental', '613', '0'),
('613200', '', 'Real property rental', '6132', '0'),
('613500', '', 'Movable property rental', '6135', '0'),
('613600', '', 'Surchages on packaging', '6136', '0'),
('614000', '', 'Rental and joint ownership property costs', '614', '0'),
('615000', '', 'Maintenance and repairs', '615', '0'),
('615200', '', 'On real property items', '6152', '0'),
('615500', '', 'On movable property items', '6155', '0'),
('615600', '', 'Maintenance', '6156', '0'),
('616000', '', 'Insurance premiums', '616', '0'),
('616100', '', 'Comprehensive risk', '6161', '0'),
('616200', '', 'Compulsory construction loss insurance', '6162', '0'),
('616300', '', 'Transport insurance', '6163', '0'),
('616360', '', 'Purchases', '61636', '0'),
('616370', '', 'Sales', '61637', '0'),
('616380', '', 'Other items', '61638', '0'),
('616400', '', 'Operating risks', '6164', '0'),
('616500', '', 'Customer insolvency', '6165', '0'),
('617000', '', 'Project studies, surveys, assessments', '617', '0'),
('618000', '', 'Sundry', '618', '0'),
('618100', '', 'General documentation', '6181', '0'),
('618300', '', 'Technical documentation', '6183', '0'),
('618500', '', 'Colloquium, seminar, conference costs', '6185', '0'),
('619000', '', 'Purchase rebates, discounts, allowances on external services', '619', '0'),
('620000', '', 'Other external services', '62', '0'),
('621000', '', 'Personnel external to the entity', '621', '0'),
('621100', '', 'Temporary personnel', '6211', '0'),
('621400', '', 'Personnel on secondment or loan to the entity', '6214', '0'),
('622000', '', 'Agents remuneration and fees', '622', '0'),
('622100', '', 'Purchase commission and brokerage', '6221', '0'),
('622200', '', 'Sales commission and brokerage', '6222', '0'),
('622400', '', 'Payments to forwarding agents', '6224', '0'),
('622500', '', 'Payments for factoring', '6225', '0'),
('622600', '', 'Fees', '6226', '0'),
('622700', '', 'Legal and litigation fees', '6227', '0'),
('622800', '', 'Sundry', '6228', '0'),
('623000', '', 'Advertising, publications, public relations', '623', '0'),
('623100', '', 'Announcements and advertisements', '6231', '0'),
('623200', '', 'Samples', '6232', '0'),
('623300', '', 'Fairs and exhibitions', '6233', '0'),
('623400', '', 'Gifts to customers', '6234', '0'),
('623500', '', 'Premiums', '6235', '0'),
('623600', '', 'Catalogues and printed material', '6236', '0'),
('623700', '', 'Publications', '6237', '0'),
('623800', '', 'Sundry (eg. tips, standard donations)', '6238', '0'),
('624000', '', 'Transport of goods and collective personnel transport', '624', '0'),
('624100', '', 'Freight in', '6241', '0'),
('624200', '', 'Freight out', '6242', '0'),
('624300', '', 'Transport between establishments or construction sites', '6243', '0'),
('624400', '', 'Administrative transport', '6244', '0'),
('624700', '', 'Collective transport of personnel', '6247', '0'),
('624800', '', 'Sundry', '6248', '0'),
('625000', '', 'usiness travel, missions and receptions', '625', '0'),
('625100', '', 'Journeys and business travel', '6251', '0'),
('625500', '', 'Relocation costs', '6255', '0'),
('625600', '', 'Missions', '6256', '0'),
('625700', '', 'Receptions', '6257', '0'),
('626000', '', 'Postal and telecommunication costs', '626', '0'),
('627000', '', 'Banking and similar services', '627', '0'),
('627100', '', 'Securities costs (purchase, sale, safe custody)', '6271', '0'),
('627200', '', 'Commissions and loan issue costs', '6272', '0'),
('627500', '', 'Charges on bills', '6275', '0'),
('627600', '', 'Rental of safes', '6276', '0'),
('627800', '', 'Other expenses and commissions on services supplied', '6278', '0'),
('628000', '', 'Sundry', '628', '0'),
('628100', '', 'Sundry assistance (eg. contributions)', '6281', '0'),
('628400', '', 'Personnel recruitment costs', '6284', '0'),
('629000', '', 'Purchase rebates, discounts, allowances on other external se', '629', '0'),
('630000', '', 'Taxes, levies and similar payments', '63', '0'),
('631000', '', 'Taxes, levies and similar payments on wages and salaries (to', '631', '0'),
('631100', '', 'Tax on salaries', '6311', '0'),
('631200', '', 'Apprenticeship tax', '6312', '0'),
('631300', '', 'Employer participation in ongoing personnel training and dev', '6313', '0'),
('631400', '', 'Default contribution for compulsory investment in constructi', '6314', '0'),
('631800', '', 'Other', '6318', '0'),
('633000', '', 'Taxes, levies and similar payments on wages and salaries (to', '633', '0'),
('633100', '', 'Transport expenditures', '6331', '0'),
('633110', '', 'Business entity tax', '63311', '0'),
('633200', '', 'Accommodation allowances', '6332', '0'),
('633300', '', 'Employer participation in ongoing personnel training and dev', '6333', '0'),
('633400', '', 'Employer participation in construction projects', '6334', '0'),
('633500', '', 'Discharge payments entitling exemption from apprenticeship t', '6335', '0'),
('633800', '', 'Other', '6338', '0'),
('635000', '', 'Other taxes, levies and similar payments (to the tax adminis', '635', '0'),
('635100', '', 'Direct taxes (except income tax)', '6351', '0'),
('635120', '', 'Property taxes', '63512', '0'),
('635130', '', 'Other local rates and taxes', '63513', '0'),
('635140', '', 'Tax on company vehicles', '63514', '0'),
('635200', '', 'Non-recoverable turnover tax', '6352', '0'),
('635300', '', 'Indirect taxes', '6353', '0'),
('635400', '', 'Registration and stamp duties', '6354', '0'),
('635410', '', 'Transfer duty', '63541', '0'),
('635800', '', 'Other duties', '6358', '0'),
('637000', '', 'Other taxes, levies and similar payments (to other bodies)', '637', '0'),
('637100', '', 'Social solidarity contribution chargeable to companies', '6371', '0'),
('637200', '', 'Taxes collected by international public bodies', '6372', '0'),
('637400', '', 'Taxes and levies due for payment outside France', '6374', '0'),
('637800', '', 'Sundry taxes', '6378', '0'),
('640000', '', 'Personnel costs', '64', '0'),
('641000', '', 'Personnel wages and salaries', '641', '0'),
('641100', '', 'Salaries, emoluments', '6411', '0'),
('641200', '', 'Holiday pay', '6412', '0'),
('641300', '', 'Premiums and bonuses', '6413', '0'),
('641400', '', 'Allowances and sundry benefits', '6414', '0'),
('641500', '', 'Family income supplement', '6415', '0'),
('644000', '', 'Owner remuneration', '644', '0'),
('645000', '', 'Social security and provident fund contributions', '645', '0'),
('645100', '', 'Social Security Collection Office (URSSAF) contributions', '6451', '0'),
('645200', '', 'Mutual organisation contributions', '6452', '0'),
('645300', '', 'Pension fund contributions', '6453', '0'),
('645400', '', 'Association for Industrial and Commercial Employment (ASSEDI', '6454', '0'),
('645800', '', 'Contributions to other social agencies', '6458', '0'),
('646000', '', 'Owner social security contributions', '646', '0'),
('647000', '', 'Other welfare costs', '647', '0'),
('647100', '', 'Direct allowances', '6471', '0'),
('647200', '', 'Payments to enterprise/establishment consultative committees', '6472', '0'),
('647300', '', 'Payments to health and occupational safety committees', '6473', '0'),
('647400', '', 'Payments to other company benefit schemes', '6474', '0'),
('647500', '', 'Occupational medicine, pharmacy', '6475', '0'),
('648000', '', 'Other personnel costs', '648', '0'),
('650000', '', 'Other current operating charges', '65', '0'),
('651000', '', 'Royalties and licence fees for concessions, patents, licence', '651', '0'),
('651100', '', 'Concessions, patents, licences, trade marks, processes, soft', '6511', '0'),
('651600', '', 'Author and reproduction royalties', '6516', '0'),
('651800', '', 'Other royalties and similar assets', '6518', '0'),
('653000', '', 'Directors fees', '653', '0'),
('654000', '', 'Bad debts written off', '654', '0'),
('654100', '', 'Debts receivable for the financial year', '6541', '0'),
('654400', '', 'Debts receivable for previous financial years', '6544', '0'),
('655000', '', 'Share of joint venture profit or loss', '655', '0'),
('655100', '', 'Share of profit transferred (accounts of the managing entity', '6551', '0'),
('655500', '', 'Share of loss (accounts of non-managing partners/associates)', '6555', '0'),
('658000', '', 'Sundry current operating charges', '658', '0'),
('660000', '', 'Financial charges', '66', '0'),
('661000', '', 'Interest charges', '661', '0'),
('661100', '', 'Loan and debt interest', '6611', '0'),
('661160', '', 'Loans and similar debts payable', '66116', '0'),
('661170', '', 'Debts payable related to participating interests', '66117', '0'),
('661500', '', 'Current account and credit deposit interest', '6615', '0'),
('661600', '', 'Bank and financing transaction interest (eg. discounting)', '6616', '0'),
('661700', '', 'Interest on guaranteed bonds', '6617', '0'),
('661800', '', 'Interest on other debts payable', '6618', '0'),
('661810', '', 'Commercial debts payable', '66181', '0'),
('661880', '', 'Sundry debts payable', '66188', '0'),
('664000', '', 'Losses on debts receivable related to participating interest', '664', '0'),
('665000', '', 'Discounts allowed', '665', '0'),
('666000', '', 'Exchange losses', '666', '0'),
('667000', '', 'Net charges on realisation of short-term investment securiti', '667', '0'),
('668000', '', 'Other financial charges', '668', '0'),
('670000', '', 'Extraordinary charges', '67', '0'),
('671000', '', 'Extraordinary charges on operating transactions', '671', '0'),
('671100', '', 'Market penalties (and forfeits on purchases and sales)', '6711', '0'),
('671200', '', 'Fines, tax and criminal penalties', '6712', '0'),
('671300', '', 'Gifts and donations', '6713', '0'),
('671400', '', 'Bad debts written off for the financial year', '6714', '0'),
('671500', '', 'Grants awarded', '6715', '0'),
('671700', '', 'Additional taxes assessed (other than income tax)', '6717', '0'),
('671800', '', 'Other extraordinary operating charges', '6718', '0'),
('672000', '', '(Account available to entities to record prior period charge', '672', '0'),
('675000', '', 'Book values of realised assets', '675', '0'),
('675100', '', 'Intangible fixed assets', '6751', '0'),
('675200', '', 'Tangible fixed assets', '6752', '0'),
('675600', '', 'Financial fixed assets', '6756', '0'),
('675800', '', 'Other asset components', '6758', '0'),
('678000', '', 'Other extraordinary charges', '678', '0'),
('678100', '', 'Surcharges resulting from escalation clauses', '6781', '0'),
('678200', '', 'Prizes', '6782', '0'),
('678300', '', 'Deficits resulting from own shares and bonds bought back by ', '6783', '0'),
('678800', '', 'Sundry extraordinary charges', '6788', '0'),
('680000', '', 'Appropriations to depreciation and provisions', '68', '0'),
('681000', '', 'Operating charges', '681', '0'),
('681100', '', 'Appropriations to depreciation on intangible and tangible fi', '6811', '0'),
('681110', '', 'Intangible fixed assets', '68111', '0'),
('681120', '', 'Tangible fixed assets', '68112', '0'),
('681200', '', 'Amortisation of deferred operating charges', '6812', '0'),
('681500', '', 'Appropriations to provisions for operating liabilities and c', '6815', '0'),
('681600', '', 'Appropriations to provisions for diminution in value of inta', '6816', '0'),
('681610', '', 'Intangible fixed assets', '68161', '0'),
('681620', '', 'Tangible fixed assets', '68162', '0'),
('681700', '', 'Appropriations to provisions for diminution in value of curr', '6817', '0'),
('681730', '', 'Stocks and work in progress', '68173', '0'),
('681740', '', 'Debts receivable', '68174', '0'),
('686000', '', 'Financial charges', '686', '0'),
('686100', '', 'Appropriations to amortisation of premiums on redemption of ', '6861', '0'),
('686500', '', 'Appropriations to provisions for financial liabilities and c', '6865', '0'),
('686600', '', 'Appropriations to provisions for diminution in value of fina', '6866', '0'),
('686620', '', 'Financial fixed assets', '68662', '0'),
('686650', '', 'Short-term investment securities', '68665', '0'),
('686800', '', 'Other appropriations', '6868', '0'),
('687000', '', 'Extraordinary charges', '687', '0'),
('687100', '', 'Appropriations to extraordinary fixed asset depreciation', '6871', '0'),
('687200', '', 'Appropriations to tax-regulated provisions (fixed assets)', '6872', '0'),
('687250', '', 'Depreciation by derogation', '68725', '0'),
('687300', '', 'Appropriations to tax-regulated provisions (stocks)', '6873', '0'),
('687400', '', 'Appropriations to other tax-regulated provisions', '6874', '0'),
('687500', '', 'Appropriations to provisions for extraordinary liabilities a', '6875', '0'),
('687600', '', 'Appropriations to provisions for extraordinary diminution in', '6876', '0'),
('690000', '', 'Employee profit share - Income and similar taxes', '69', '0'),
('691000', '', 'Employee profit share', '691', '0'),
('695000', '', 'Income tax', '695', '0'),
('695100', '', 'Income tax due in France', '6951', '0'),
('695200', '', 'Additional contribution to income tax', '6952', '0'),
('695400', '', 'Income tax due outside France', '6954', '0'),
('696000', '', 'Supplementary company tax related to profit distributions', '696', '0'),
('697000', '', 'Annual company imputed tax', '697', '0'),
('698000', '', 'Group tax', '698', '0'),
('698100', '', 'Group tax - Charges', '6981', '0'),
('698900', '', 'Group tax - Income', '6989', '0'),
('699000', '', 'Income - Carry-back of losses', '699', '0'),
('700000', '', 'Sales of manufactured products, services, goods for resale', '70', '0'),
('701000', '', 'Sales of finished products', '701', '0'),
('701100', '', 'Finished products (or group) A', '7011', '0');
INSERT INTO `0_chart_master` VALUES
('701200', '', 'Finished products (or group) B', '7012', '0'),
('702000', '', 'Sales of semi-finished products', '702', '0'),
('703000', '', 'Sales of residual products', '703', '0'),
('704000', '', 'Works', '704', '0'),
('704100', '', 'Works of category (or activity) A', '7041', '0'),
('704200', '', 'Works of category (or activity) B', '7042', '0'),
('705000', '', 'Project studies', '705', '0'),
('706000', '', 'Services supplied', '706', '0'),
('707000', '', 'Sales of goods for resale', '707', '0'),
('707100', '', 'Goods for resale (or group) A', '7071', '0'),
('707200', '', 'Goods for resale (or group) B', '7072', '0'),
('708000', '', 'Income from related activities', '708', '0'),
('708100', '', 'Income from services operated in the interest of personnel', '7081', '0'),
('708200', '', 'Commission and brokerage', '7082', '0'),
('708300', '', 'Sundry rentals', '7083', '0'),
('708400', '', 'Personnel charged out', '7084', '0'),
('708500', '', 'Carriage and ancillary costs invoiced', '7085', '0'),
('708600', '', 'Surplus on recovery of returnable packaging', '7086', '0'),
('708700', '', 'Bonuses obtained from customers and sales premiums', '7087', '0'),
('708800', '', 'Other income from ancillary activities (eg. disposal of cons', '7088', '0'),
('709000', '', 'Sales rebates, discounts, allowances granted by the entity', '709', '0'),
('709100', '', 'Sales of finished products', '7091', '0'),
('709200', '', 'Sales of semi-finished products', '7092', '0'),
('709400', '', 'Works', '7094', '0'),
('709500', '', 'Project studies', '7095', '0'),
('709600', '', 'Services supplied', '7096', '0'),
('709700', '', 'Sales of goods for resale', '7097', '0'),
('709800', '', 'Income from ancillary activities', '7098', '0'),
('710000', '', 'Change in stocks of finished products and work in progress', '71', '0'),
('713000', '', 'Change in stocks (work in progress, products)', '713', '0'),
('713300', '', 'Change in work in progress (goods)', '7133', '0'),
('713310', '', 'Products in progress', '71331', '0'),
('713350', '', 'Works in progress', '71335', '0'),
('713400', '', 'Change in work in progress (services)', '7134', '0'),
('713410', '', 'Project studies in progress', '71341', '0'),
('713450', '', 'Supply of services in progress', '71345', '0'),
('713500', '', 'Change in product stocks', '7135', '0'),
('713510', '', 'Semi-finished products', '71351', '0'),
('713550', '', 'Finished products', '71355', '0'),
('713580', '', 'Residual products', '71358', '0'),
('720000', '', 'Own work capitalised', '72', '0'),
('721000', '', 'Intangible fixed assets', '721', '0'),
('722000', '', 'Tangible fixed assets', '722', '0'),
('730000', '', 'Net period income from long-term transactions', '73', '0'),
('731000', '', 'Net period income on transactions in progress (to be subdivi', '731', '0'),
('739000', '', 'Net period income on completed transactions', '739', '0'),
('740000', '', 'Operating grants', '74', '0'),
('750000', '', 'Other current operating income', '75', '0'),
('751000', '', 'Royalties and licence fees for concessions, patents, licence', '751', '0'),
('751100', '', 'Concessions, patents, licences, trade marks, processes, soft', '7511', '0'),
('751600', '', 'Author and reproduction royalties', '7516', '0'),
('751800', '', 'Other royalties and similar assets', '7518', '0'),
('752000', '', 'Revenues from buildings not allocated to professional activi', '752', '0'),
('753000', '', 'Directors fees and remuneration (eg. administrators, manager', '753', '0'),
('754000', '', 'Rebates from cooperatives (resulting from surpluses)', '754', '0'),
('755000', '', 'Share of joint venture profit or loss', '755', '0'),
('755100', '', 'Share of loss transferred (accounts of the managing entity)', '7551', '0'),
('755500', '', 'Share of profit (accounts of non-managing partners/associate', '7555', '0'),
('758000', '', 'Sundry current operating income', '758', '0'),
('760000', '', 'Financial income', '76', '0'),
('761000', '', 'Income from participating interests', '761', '0'),
('761100', '', 'Income from long-term equity interests', '7611', '0'),
('761600', '', 'Income from other forms of participating interests', '7616', '0'),
('761700', '', 'Income from debts receivable related to participating intere', '7617', '0'),
('762000', '', 'Income from other financial fixed assets', '762', '0'),
('762100', '', 'Income from long-term investment securities', '7621', '0'),
('762600', '', 'Income from loans', '7626', '0'),
('762700', '', 'Income from capitalised debts receivable', '7627', '0'),
('763000', '', 'Income from other debts receivable', '763', '0'),
('763100', '', 'Income from commercial debts receivable', '7631', '0'),
('763800', '', 'Income from sundry debts receivable', '7638', '0'),
('764000', '', 'Income from short-term investment securities', '764', '0'),
('765000', '', 'Discounts obtained', '765', '0'),
('766000', '', 'Exchange gains', '766', '0'),
('767000', '', 'Net income on realisation of short-term investment securitie', '767', '0'),
('768000', '', 'Other financial income', '768', '0'),
('770000', '', 'Extraordinary income', '77', '0'),
('771000', '', 'Extraordinary income on operating transactions', '771', '0'),
('771100', '', 'Forfeits and penalties on purchases and sales', '7711', '0'),
('771300', '', 'Donations received', '7713', '0'),
('771400', '', 'Collection of debts receivable written off', '7714', '0'),
('771500', '', 'Deficit grants', '7715', '0'),
('771700', '', 'Tax allowances other than income tax', '7717', '0'),
('771800', '', 'Other extraordinary income on operating transactions', '7718', '0'),
('772000', '', '(Account available to entities to record prior period income', '772', '0'),
('775000', '', 'Income from asset realisation', '775', '0'),
('775100', '', 'Intangible fixed assets', '7751', '0'),
('775200', '', 'Tangible fixed assets', '7752', '0'),
('775600', '', 'Financial fixed assets', '7756', '0'),
('775800', '', 'Other asset components', '7758', '0'),
('777000', '', 'Share of investment grants transferred to profit or loss for', '777', '0'),
('778000', '', 'Other extraordinary income', '778', '0'),
('778100', '', 'Surpluses resulting from escalation clauses', '7781', '0'),
('778200', '', 'Prizes', '7782', '0'),
('778300', '', 'Surpluses resulting from own shares and bonds bought back by', '7783', '0'),
('778800', '', 'Sundry extraordinary income', '7788', '0'),
('780000', '', 'Depreciation and provisions written back', '78', '0'),
('781000', '', 'Depreciation and provisions written back (to be entered in o', '781', '0'),
('781100', '', 'Depreciation of intangible and tangible fixed assets written', '7811', '0'),
('781110', '', 'Intangible fixed assets', '78111', '0'),
('781120', '', 'Tangible fixed assets', '78112', '0'),
('781500', '', 'Provisions for operating liabilities and charges written bac', '7815', '0'),
('781600', '', 'Provisions for diminution in value of intangible and tangibl', '7816', '0'),
('781610', '', 'Intangible fixed assets', '78161', '0'),
('781620', '', 'Tangible fixed assets', '78162', '0'),
('781700', '', 'Provisions for diminution in value of current assets written', '7817', '0'),
('781730', '', 'Stocks and work in progress', '78173', '0'),
('781740', '', 'Debts receivable', '78174', '0'),
('786000', '', 'Provisions for liabilities written back (to be entered in fi', '786', '0'),
('786500', '', 'Provisions for financial liabilities and charges written bac', '7865', '0'),
('786600', '', 'Provisions for diminution in value of financial components w', '7866', '0'),
('786620', '', 'Financial fixed assets', '78662', '0'),
('786650', '', 'Short-term investment securities', '78665', '0'),
('787000', '', 'Provisions written back (to be entered in extraordinary inco', '787', '0'),
('787200', '', 'Tax-regulated provisions written back (fixed assets)', '7872', '0'),
('787250', '', 'Depreciation by derogation', '78725', '0'),
('787260', '', 'Special revaluation provision', '78726', '0'),
('787270', '', 'Reinvested capital gain', '78727', '0'),
('787300', '', 'Tax-regulated provisions written back (stocks)', '7873', '0'),
('787400', '', 'Other tax-regulated provisions written back', '7874', '0'),
('787500', '', 'Provisions for extraordinary liabilities and charges written', '7875', '0'),
('787600', '', 'Provisions for extraordinary diminution in value written bac', '7876', '0'),
('790000', '', 'Charges transferred', '79', '0'),
('791000', '', 'Operating charges transferred', '791', '0'),
('796000', '', 'Financial charges transferred', '796', '0'),
('797000', '', 'Extraordinary charges transferred', '797', '0');

### Structure of table `0_chart_types` ###

DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
  `id` varchar(10) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `class_id` varchar(3) NOT NULL DEFAULT '',
  `parent` varchar(10) NOT NULL DEFAULT '-1',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `class_id` (`class_id`)
) ENGINE=InnoDB ;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('10', '10 Capital and reserves', '1', '', '0'),
('101', '101 Capital', '1', '101', '0'),
('1011', '1011 Subscribed capital uncalled', '1', '101', '0'),
('1012', '1012 Subscribed capital called up, unpaid', '1', '101', '0'),
('1013', '1013 Subscribed capital called up, paid', '1', '101', '0'),
('10131', '10131 Capital not written off', '1', '1013', '0'),
('10132', '10132 Capital written off', '1', '1013', '0'),
('1018', '1018 Subscribed capital subject to particular regulations', '1', '101', '0'),
('104', '104 Premiums on share capital', '1', '10', '0'),
('1041', '1041 Share premiums', '1', '104', '0'),
('1042', '1042 Merger premiums', '1', '104', '0'),
('1043', '1043 Contribution premiums', '1', '104', '0'),
('1044', '1044 Premiums on conversion of bonds into shares', '1', '104', '0'),
('1045', '1045 Equity warrants', '1', '104', '0'),
('105', '105 Revaluation differences', '1', '10', '0'),
('1051', '1051 Special revaluation reserve', '1', '105', '0'),
('1052', '1052 Voluntary revaluation difference', '1', '105', '0'),
('1053', '1053 Revaluation reserve', '1', '105', '0'),
('1055', '1055 Revaluation differences (other legal transactions)', '1', '105', '0'),
('1057', '1057 Other revaluation differences in France', '1', '105', '0'),
('1058', '1058 Other revaluation differences outside France', '1', '105', '0'),
('106', '106 Reserves', '1', '10', '0'),
('1061', '1061 Legal reserve', '1', '106', '0'),
('10611', '10611 Basic legal reserve', '1', '1061', '0'),
('10612', '10612 Net long-term capital gains', '1', '1061', '0'),
('1062', '1062 Undistributable reserves', '1', '106', '0'),
('1063', '1063 Statutory or contractual reserves', '1', '106', '0'),
('1064', '1064 Tax-regulated reserves', '1', '106', '0'),
('10641', '10641 Net long-term capital gains', '1', '1064', '0'),
('10643', '10643 Reserves consequent on award of investment grants', '1', '1064', '0'),
('10648', '10648 Other tax-regulated reserves', '1', '1064', '0'),
('1068', '1068 Other reserves', '1', '106', '0'),
('10681', '10681 Self-insurance reserve', '1', '1068', '0'),
('10688', '10688 Sundry reserves', '1', '1068', '0'),
('107', '107 Difference on equity accounted investments', '1', '10', '0'),
('108', '108 Drawings account', '1', '10', '0'),
('109', '109 Shareholders: Subscribed capital uncalled', '1', '10', '0'),
('11', '11 Profit or loss carried forward (debit or credit balance)', '1', '', '0'),
('110', '110 Profit carried forward', '1', '11', '0'),
('119', '119 Loss carried forward', '1', '11', '0'),
('12', '12 Profit or loss for the financial year', '1', '', '0'),
('120', '120 Profit for the financial year', '1', '12', '0'),
('129', '129 Loss for the financial year', '1', '12', '0'),
('13', '13 Investment grants', '1', '', '0'),
('131', '131 Equipment grants', '1', '13', '0'),
('1311', '1311 State', '1', '131', '0'),
('1312', '1312 Regions', '1', '131', '0'),
('1313', '1313 Departments', '1', '131', '0'),
('1314', '1314 Municipalities', '1', '131', '0'),
('1315', '1315 Public authorities', '1', '131', '0'),
('1316', '1316 Public enterprises', '1', '131', '0'),
('1317', '1317 Enterprises and private bodies', '1', '131', '0'),
('1318', '1318 Other', '1', '131', '0'),
('138', '138 Other investment grants (same allocation as for Account ', '1', '13', '0'),
('139', '139 Investment grants credited to the profit and loss accoun', '1', '13', '0'),
('1391', '1391 Equipment grants', '1', '139', '0'),
('13911', '13911 State', '1', '1391', '0'),
('13912', '13912 Regions', '1', '1391', '0'),
('13913', '13913 Departments', '1', '1391', '0'),
('13914', '13914 Municipalities', '1', '1391', '0'),
('13915', '13915 Public authorities', '1', '1391', '0'),
('13916', '13916 Public enterprises', '1', '1391', '0'),
('13917', '13917 Enterprises and private bodies', '1', '1391', '0'),
('13918', '13918 Other', '1', '1391', '0'),
('1398', '1398 Other investment grants (same allocation as for Account', '1', '139', '0'),
('14', '14 Tax-regulated provisions', '1', '', '0'),
('142', '142 Fixed assets', '1', '14', '0'),
('1423', '1423 Provisions for reconstitution of mining and petroleum d', '1', '142', '0'),
('1424', '1424 Provisions for investment (employee profit share)', '1', '142', '0'),
('143', '143 Stocks', '1', '14', '0'),
('1431', '1431 Price increase', '1', '143', '0'),
('1432', '1432 Exchange rate fluctuations', '1', '143', '0'),
('144', '144 Other asset components', '1', '14', '0'),
('145', '145 Depreciation by derogation', '1', '14', '0'),
('146', '146 Special revaluation provision', '1', '14', '0'),
('147', '147 Capital gains reinvested', '1', '14', '0'),
('148', '148 Other tax-regulated provisions', '1', '14', '0'),
('15', '15 Provisions for liabilities and charges', '1', '', '0'),
('151', '151 Provisions for liabilities', '1', '15', '0'),
('1511', '1511 Provisions for litigation', '1', '151', '0'),
('1512', '1512 Provisions for customer warranties', '1', '151', '0'),
('1513', '1513 Provisions for losses on futures', '1', '151', '0'),
('1514', '1514 Provisions for fines and penalties', '1', '151', '0'),
('1515', '1515 Provisions for foreign exchange losses', '1', '151', '0'),
('1518', '1518 Other provisions for liabilities', '1', '151', '0'),
('153', '153 Provisions for pensions and similar obligations', '1', '15', '0'),
('155', '155 Provisions for taxation', '1', '15', '0'),
('156', '156 Provisions for fixed asset renewal (concession entities)', '1', '15', '0'),
('157', '157 Provisions for deferred charges', '1', '15', '0'),
('1572', '1572 Provisions for major repairs', '1', '157', '0'),
('158', '158 Other provisions for charges', '1', '15', '0'),
('1582', '1582 Provisions for social security and tax charges on holid', '1', '158', '0'),
('16', '16 Loans and similar debts payable', '1', '', '0'),
('161', '161 Convertible debenture loans', '1', '16', '0'),
('163', '163 Other debenture loans', '1', '16', '0'),
('164', '164 Loans from credit institutions', '1', '16', '0'),
('165', '165 Deposits and sureties received', '1', '16', '0'),
('1651', '1651 Deposits', '1', '165', '0'),
('1655', '1655 Sureties', '1', '165', '0'),
('166', '166 Employee profit share', '1', '16', '0'),
('1661', '1661 Blocked accounts', '1', '166', '0'),
('1662', '1662 Profit share funds', '1', '166', '0'),
('167', '167 Loans and debts payable subject to particular conditions', '1', '16', '0'),
('1671', '1671 Issues of non-voting shares', '1', '167', '0'),
('1674', '1674 Advances by the state subject to conditions', '1', '167', '0'),
('1675', '1675 Participating loans', '1', '167', '0'),
('168', '168 Other loans and similar debts payable', '1', '16', '0'),
('1681', '1681 Other loans', '1', '168', '0'),
('1685', '1685 Capitalised life annuities', '1', '168', '0'),
('1687', '1687 Other debts payable', '1', '168', '0'),
('1688', '1688 Accrued interest', '1', '168', '0'),
('16881', '16881 On convertible debenture loans', '1', '1688', '0'),
('16883', '16883 On other debenture loans', '1', '1688', '0'),
('16884', '16884 On loans from credit institutions', '1', '1688', '0'),
('16885', '16885 On deposits and sureties received', '1', '1688', '0'),
('16886', '16886 On employee profit share', '1', '1688', '0'),
('16887', '16887 On loans and debts payable subject to particular condi', '1', '1688', '0'),
('16888', '16888 On other loans and similar debts payable', '1', '1688', '0'),
('169', '169 Debt redemption premiums', '1', '16', '0'),
('17', '17 Debts payable related to participating interests', '1', '', '0'),
('171', '171 Debts payable related to participating interests (group)', '1', '17', '0'),
('174', '174 Debts payable related to participating interests (apart ', '1', '17', '0'),
('178', '178 Debts payable related to joint ventures', '1', '17', '0'),
('1781', '1781 Principal', '1', '178', '0'),
('1788', '1788 Accrued interest', '1', '178', '0'),
('18', '18 Reciprocal branch and joint venture accounts', '1', '', '0'),
('181', '181 Reciprocal branch accounts', '1', '18', '0'),
('186', '186 Goods and services exchanged between establishments (cha', '1', '18', '0'),
('187', '187 Goods and services exchanged between establishments (inc', '1', '18', '0'),
('188', '188 Reciprocal joint venture accounts', '1', '18', '0'),
('20', '20 Intangible fixed assets', '2', '', '0'),
('201', '201 Establishment costs', '2', '20', '0'),
('2011', '2011 Incorporation costs', '2', '201', '0'),
('2012', '2012 Start-up costs', '2', '201', '0'),
('20121', '20121 Commercial assessment costs', '2', '2012', '0'),
('20122', '20122 Marketing costs', '2', '2012', '0'),
('2013', '2013 Capital increase and sundry transaction costs (mergers,', '2', '201', '0'),
('203', '203 Research and development costs', '2', '20', '0'),
('205', '205 Concessions and similar rights, patents, licences, trade', '2', '20', '0'),
('206', '206 Lease premium', '2', '20', '0'),
('207', '207 Goodwill', '2', '20', '0'),
('208', '208 Other intangible fixed assets', '2', '20', '0'),
('21', '21 Tangible fixed assets', '2', '', '0'),
('211', '211 Land', '2', '21', '0'),
('2111', '2111 Undeveloped land', '2', '211', '0'),
('2112', '2112 Serviced land', '2', '211', '0'),
('2113', '2113 Underground and aboveground sites', '2', '211', '0'),
('2114', '2114 Mining sites', '2', '211', '0'),
('21141', '21141 Quarries', '2', '2114', '0'),
('2115', '2115 Developed land', '2', '211', '0'),
('21151', '21151 Industrial property complexes (A, B...)', '2', '2115', '0'),
('21155', '21155 Administrative and commercial property complexes (A, B', '2', '2115', '0'),
('21158', '21158 Other property complexes', '2', '2115', '0'),
('211581', '211581 Property assigned to normal entity operations (A, B..', '2', '21158', '0'),
('211588', '211588 Property assigned to other than normal entity operati', '2', '21158', '0'),
('2116', '2116 Suspense account for non-depreciable fixed assets reval', '2', '211', '0'),
('212', '212 Site development (same allocation as for Account 211)', '2', '21', '0'),
('213', '213 Constructions', '2', '21', '0'),
('2131', '2131 Buildings', '2', '213', '0'),
('21311', '21311 Industrial property complexes (A, B...)', '2', '2131', '0'),
('21315', '21315 Administrative and commercial property complexes (A, B', '2', '2131', '0'),
('21318', '21318 Other property complexes', '2', '2131', '0'),
('213181', '213181 Property assigned to normal entity operations (A, B..', '2', '21318', '0'),
('213188', '213188 Property assigned to other than normal entity operati', '2', '21318', '0'),
('2135', '2135 Building fixtures and fittings', '2', '213', '0'),
('2138', '2138 Infrastructure development', '2', '213', '0'),
('21381', '21381 Roadways', '2', '2138', '0'),
('21382', '21382 Railways', '2', '2138', '0'),
('21383', '21383 Water channels', '2', '2138', '0'),
('21384', '21384 Dams', '2', '2138', '0'),
('21385', '21385 Airfields', '2', '2138', '0'),
('214', '214 Constructions on third-party sites (same allocation as f', '2', '21', '0'),
('215', '215 Technical installations, plant and machinery, equipment ', '2', '21', '0'),
('2151', '2151 Specialised complex installations', '2', '215', '0'),
('21511', '21511 On own site', '2', '2151', '0'),
('21514', '21514 On third-party site', '2', '2151', '0'),
('2153', '2153 Installations of specific nature', '2', '215', '0'),
('21531', '21531 On own site', '2', '2153', '0'),
('21534', '21534 On third-party site', '2', '2153', '0'),
('2154', '2154 Plant and machinery', '2', '215', '0'),
('2155', '2155 Equipment and fixtures', '2', '215', '0'),
('2157', '2157 Fixtures and fittings for plant and machinery, equipmen', '2', '215', '0'),
('218', '218 Other tangible fixed assets', '2', '21', '0'),
('2181', '2181 Sundry general fixtures and fittings', '2', '218', '0'),
('2182', '2182 Transport equipment', '2', '218', '0'),
('2183', '2183 Office and computing equipment', '2', '218', '0'),
('2184', '2184 Furnishings', '2', '218', '0'),
('2185', '2185 Livestock', '2', '218', '0'),
('2186', '2186 Recoverable packaging', '2', '218', '0'),
('22', '22 Fixed assets in concession', '2', '', '0'),
('23', '23 Fixed assets in progress', '2', '', '0'),
('231', '231 Tangible fixed assets in progress', '2', '23', '0'),
('2312', '2312 Land', '2', '231', '0'),
('2313', '2313 Constructions', '2', '231', '0'),
('2315', '2315 Technical installations, plant and machinery, equipment', '2', '231', '0'),
('2318', '2318 Other tangible fixed assets', '2', '231', '0'),
('232', '232 Intangible fixed assets in progress', '2', '23', '0'),
('237', '237 Payments on account on intangible fixed assets', '2', '23', '0'),
('238', '238 Payments on account on orders for tangible fixed assets', '2', '23', '0'),
('2382', '2382 Land', '2', '238', '0'),
('2383', '2383 Constructions', '2', '238', '0'),
('2385', '2385 Technical installations, plant and machinery, equipment', '2', '238', '0'),
('2388', '2388 Other tangible fixed assets', '2', '238', '0'),
('25', '25 Shares in and receivables due from affiliated entities', '2', '', '0'),
('26', '26 Participating interests and related debts receivable', '2', '', '0'),
('261', '261 Long-term equity interests', '2', '26', '0'),
('2611', '2611 Shares', '2', '261', '0'),
('2618', '2618 Other securities', '2', '261', '0'),
('266', '266 Other categories of participating interest', '2', '26', '0'),
('267', '267 Debts receivable related to participating interests', '2', '26', '0'),
('2671', '2671 Debts receivable related to participating interests (gr', '2', '267', '0'),
('2674', '2674 Debts receivable related to participating interests (ap', '2', '267', '0'),
('2675', '2675 Payments representing non-capitalised contributions (ca', '2', '267', '0'),
('2676', '2676 Long-term capital advances', '2', '267', '0'),
('2677', '2677 Other debts receivable related to participating interes', '2', '267', '0'),
('2678', '2678 Accrued interest', '2', '267', '0'),
('268', '268 Debts receivable related to joint ventures', '2', '26', '0'),
('2681', '2681 Principal', '2', '268', '0'),
('2688', '2688 Accrued interest', '2', '268', '0'),
('269', '269 Unpaid instalments on unpaid long-term equity interests', '2', '26', '0'),
('27', '27 Other financial fixed assets', '2', '', '0'),
('271', '271 Long-term investment equity securities other than portfo', '2', '27', '0'),
('2711', '2711 Shares', '2', '271', '0'),
('2718', '2718 Other securities', '2', '271', '0'),
('272', '272 Long-term investment debt securities', '2', '27', '0'),
('2721', '2721 Bonds', '2', '272', '0'),
('2722', '2722 Warrants', '2', '272', '0'),
('273', '273 Portfolio long-term investment securities', '2', '27', '0'),
('274', '274 Loans', '2', '27', '0'),
('2741', '2741 Participating loans', '2', '274', '0'),
('2742', '2742 Loans to partners/associates', '2', '274', '0'),
('2743', '2743 Loans to personnel', '2', '274', '0'),
('2748', '2748 Other loans', '2', '274', '0'),
('275', '275 Deposits and sureties advanced', '2', '27', '0'),
('2751', '2751 Deposits', '2', '275', '0'),
('2755', '2755 Sureties', '2', '275', '0'),
('276', '276 Other capitalised debts receivable', '2', '27', '0'),
('2761', '2761 Sundry debts receivable', '2', '276', '0'),
('2768', '2768 Accrued interest', '2', '276', '0'),
('27682', '27682 Long-term investment debt securities', '2', '2768', '0'),
('27684', '27684 Loans', '2', '2768', '0'),
('27685', '27685 Deposits and sureties', '2', '2768', '0'),
('27688', '27688 On sundry debts receivable', '2', '2768', '0'),
('277', '277 (Own shares)', '2', '27', '0'),
('2771', '2771 Own shares', '2', '277', '0'),
('2772', '2772 Own shares in process of cancellation', '2', '277', '0'),
('279', '279 Unpaid instalments on unpaid long-term investment securi', '2', '27', '0'),
('28', '28 Cumulative depreciation on fixed assets', '2', '', '0'),
('280', '280 Depreciation on intangible fixed assets', '2', '28', '0'),
('2801', '2801 Establishment costs (same allocation as for Account 201', '2', '280', '0'),
('2803', '2803 Research and development costs', '2', '280', '0'),
('2805', '2805 Concessions and similar rights, patents, licences, soft', '2', '280', '0'),
('2807', '2807 Goodwill', '2', '280', '0'),
('2808', '2808 Other intangible fixed assets', '2', '280', '0'),
('281', '281 Depreciation on tangible fixed assets', '2', '28', '0'),
('2811', '2811 Mining sites', '2', '281', '0'),
('2812', '2812 Site development (same allocation as for Account 212)', '2', '281', '0'),
('2813', '2813 Constructions (same allocation as for Account 213)', '2', '281', '0'),
('2814', '2814 Constructions on third-party site (same allocation as f', '2', '281', '0'),
('2815', '2815 Technical installations, plant and machinery, equipment', '2', '281', '0'),
('2818', '2818 Other tangible fixed assets (same allocation as for Acc', '2', '281', '0'),
('282', '282 Depreciation on fixed assets in concession', '2', '28', '0'),
('29', '29 Provisions for diminution in value of fixed assets', '2', '', '0'),
('290', '290 Intangible fixed assets', '2', '29', '0'),
('2905', '2905 -Trade marks, processes, rights and similar assets', '2', '290', '0'),
('2906', '2906 Lease premium', '2', '290', '0'),
('2907', '2907 Goodwill', '2', '290', '0'),
('2908', '2908 Other intangible fixed assets', '2', '290', '0'),
('291', '291 Tangible fixed assets (same allocation as for Account 21', '2', '29', '0'),
('2911', '2911 Land (other than mining sites)', '2', '291', '0'),
('292', '292 Fixed assets in concession', '2', '29', '0'),
('293', '293 Fixed assets in progress', '2', '29', '0'),
('2931', '2931 Tangible fixed assets in progress', '2', '293', '0'),
('2932', '2932 Intangible fixed assets in progress', '2', '293', '0'),
('296', '296 Participating interests and related debts receivable', '2', '29', '0'),
('2961', '2961 Long-term equity interests', '2', '296', '0'),
('2966', '2966 Other categories of participating interests', '2', '296', '0'),
('2967', '2967 Debts receivable related to participating interests (sa', '2', '296', '0'),
('2968', '2968 Debts receivable related to joint ventures (same alloca', '2', '296', '0'),
('297', '297 Other financial fixed assets', '2', '29', '0'),
('2971', '2971 Long-term investment equity securities other than portf', '2', '297', '0'),
('2972', '2972 Long-term investment debt securities (same allocation a', '2', '297', '0'),
('2973', '2973 Portfolio long-term investment securities', '2', '297', '0'),
('2974', '2974 Loans (same allocation as for Account 274)', '2', '297', '0'),
('2975', '2975 Deposits and sureties advanced (same allocation as for ', '2', '297', '0'),
('2976', '2976 Other debts receivable (same allocation as for Account ', '2', '297', '0'),
('31', '31 Raw materials (and supplies)', '3', '', '0'),
('311', '311 Materials (or group) A', '3', '31', '0'),
('312', '312 Materials (or group) B', '3', '31', '0'),
('317', '317 Supplies A, B, C, ...', '3', '31', '0'),
('32', '32 Other consumables', '3', '', '0'),
('321', '321 Consumable materials', '3', '32', '0'),
('3211', '3211 Materials (or group) C', '3', '321', '0'),
('3212', '3212 Materials (or group) D', '3', '321', '0'),
('322', '322 Consumable supplies', '3', '32', '0'),
('3221', '3221 Fuels', '3', '322', '0'),
('3222', '3222 Cleaning products', '3', '322', '0'),
('3223', '3223 Workshop and factory supplies', '3', '322', '0'),
('3224', '3224 Store supplies', '3', '322', '0'),
('3225', '3225 Office supplies', '3', '322', '0'),
('326', '326 Packaging', '3', '32', '0'),
('3261', '3261 Non-returnable packaging', '3', '326', '0'),
('3265', '3265 Unidentifiable recoverable packaging', '3', '326', '0'),
('3267', '3267 Mixed usage packaging', '3', '326', '0'),
('33', '33 Work in progress (goods)', '3', '', '0'),
('331', '331 Products in progress (goods)', '3', '33', '0'),
('3311', '3311 Products in progress P 1', '3', '331', '0'),
('3312', '3312 Products in progress P 2', '3', '331', '0'),
('335', '335 Works in progress', '3', '33', '0'),
('3351', '3351 Works in progress T 1', '3', '335', '0'),
('3352', '3352 Works in progress T 2', '3', '335', '0'),
('34', '34 Work in progress (services)', '3', '', '0'),
('341', '341 Project studies in progress', '3', '34', '0'),
('3411', '3411 Project studies in progress E 1', '3', '341', '0'),
('3412', '3412 Project studies in progress E 2', '3', '341', '0'),
('345', '345 Supply of services in progress', '3', '34', '0'),
('3451', '3451 Supply of services in progress S 1', '3', '345', '0'),
('3452', '3452 Supply of services in progress S 2', '3', '345', '0'),
('35', '35 Product stocks', '3', '', '0'),
('351', '351 Semi-finished products', '3', '35', '0'),
('3511', '3511 Semi-finished products (or group) A', '3', '351', '0'),
('3512', '3512 Semi-finished products (or group) B', '3', '351', '0'),
('355', '355 Finished products', '3', '35', '0'),
('3551', '3551 Finished products (or group) A', '3', '355', '0'),
('3552', '3552 Finished products (or group) B', '3', '355', '0'),
('358', '358 Residual products (or recoverable materials)', '3', '35', '0'),
('3581', '3581 Waste', '3', '358', '0'),
('3585', '3585 Refuse', '3', '358', '0'),
('3586', '3586 Recoverable materials', '3', '358', '0'),
('36', '36 (Account to be opened, as applicable, under the title, St', '3', '', '0'),
('37', '37 Stocks of goods for resale', '3', '', '0'),
('371', '371 Goods for resale (or group) A', '3', '37', '0'),
('372', '372 Goods for resale (or group) B', '3', '37', '0'),
('38', '38 (Where an entity maintains a perpetual inventory in its f', '3', '', '0'),
('39', '39 Provisions for diminution in value of stocks and work in ', '3', '', '0'),
('391', '391 Raw materials (and supplies)', '3', '39', '0'),
('3911', '3911 Materials (or group) A', '3', '391', '0'),
('3912', '3912 Materials (or group) B', '3', '391', '0'),
('3917', '3917 Supplies A, B, C, ...', '3', '391', '0'),
('392', '392 Other consumables', '3', '39', '0'),
('3921', '3921 Consumable materials (same allocation as for Account 32', '3', '392', '0'),
('3922', '3922 Consumable supplies (same allocation as for Account 322', '3', '392', '0'),
('3926', '3926 Packaging (same allocation as for Account 326)', '3', '392', '0'),
('393', '393 Work in progress (goods)', '3', '39', '0'),
('3931', '3931 Products in progress (same allocation as for Account 33', '3', '393', '0'),
('3935', '3935 Works in progress (same allocation as for Account 335)', '3', '393', '0'),
('394', '394 Work in progress (services)', '3', '39', '0'),
('3941', '3941 Project studies in progress (same allocation as for Acc', '3', '394', '0'),
('3945', '3945 Supply of services in progress (same allocation as for ', '3', '394', '0'),
('395', '395 Product stocks', '3', '39', '0'),
('3951', '3951 Semi-finished products (same allocation as for Account ', '3', '395', '0'),
('3955', '3955 Finished products (same allocation as for Account 355)', '3', '395', '0'),
('397', '397 Goods for resale', '3', '39', '0'),
('3971', '3971 Goods for resale (or group) A', '3', '397', '0'),
('3972', '3972 Goods for resale (or group) B', '3', '397', '0'),
('40', '40 Suppliers and related accounts', '4', '', '0'),
('401', '401 Suppliers', '4', '40', '0'),
('4011', '4011 Suppliers Purchases of goods and services', '4', '401', '0'),
('4017', '4017 Suppliers Contract performance holdbacks', '4', '401', '0'),
('403', '403 Suppliers Bills payable', '4', '40', '0'),
('404', '404 Fixed asset suppliers', '4', '40', '0'),
('4041', '4041 Suppliers Fixed asset purchases', '4', '404', '0'),
('4047', '4047 Fixed asset suppliers Contract performance holdbacks', '4', '404', '0'),
('405', '405 Fixed asset suppliers Bills payable', '4', '40', '0'),
('408', '408 Suppliers Invoices outstanding', '4', '40', '0'),
('4081', '4081 Suppliers', '4', '408', '0'),
('4084', '4084 Fixed asset suppliers', '4', '408', '0'),
('4088', '4088 Suppliers Accrued interest', '4', '408', '0'),
('409', '409 Suppliers in debit', '4', '40', '0'),
('4091', '4091 Suppliers Payments on account on orders', '4', '409', '0'),
('4096', '4096 Suppliers Debts receivable for returnable packaging and', '4', '409', '0'),
('4097', '4097 Suppliers Other debits', '4', '409', '0'),
('40971', '40971 Operating suppliers', '4', '4097', '0'),
('40974', '40974 Fixed asset suppliers', '4', '4097', '0'),
('4098', '4098 Purchase rebates, discounts, allowances and other outst', '4', '409', '0'),
('41', '41 Customers and related accounts', '4', '', '0'),
('411', '411 Customers', '4', '41', '0'),
('4111', '4111 Customers Sales of goods and services', '4', '411', '0'),
('4117', '4117 Customers Contract performance holdbacks', '4', '411', '0'),
('413', '413 Customers Bills receivable', '4', '41', '0'),
('416', '416 Doubtful or contested customer accounts', '4', '41', '0'),
('417', '417 Future debts receivable for work not yet chargeable', '4', '41', '0'),
('418', '418 Customers Charges not yet invoiced', '4', '41', '0'),
('4181', '4181 Customers Invoices to be made out', '4', '418', '0'),
('4188', '4188 Customers Accrued interest', '4', '418', '0'),
('419', '419 Customers in credit', '4', '41', '0'),
('4191', '4191 Customers Payments on account received on orders', '4', '419', '0'),
('4196', '4196 Customers Debts payable for returnable packaging and eq', '4', '419', '0'),
('4197', '4197 Customers Other credits', '4', '419', '0'),
('4198', '4198 Sales rebates, discounts, allowances and other credits ', '4', '419', '0'),
('42', '42 Personnel and related accounts', '4', '', '0'),
('421', '421 Remuneration payable', '4', '42', '0'),
('422', '422 Enterprise/establishment consultative committees', '4', '42', '0'),
('424', '424 Employee profit share', '4', '42', '0'),
('4246', '4246 Special reserve (Art. L. 442-2, Code du travail)', '4', '424', '0'),
('4248', '4248 Current accounts', '4', '424', '0'),
('425', '425 Payments on account', '4', '42', '0'),
('426', '426 Deposits', '4', '42', '0'),
('427', '427 Stoppages of payment', '4', '42', '0'),
('428', '428 Accrued charges payable and income receivable', '4', '42', '0'),
('4282', '4282 Accrued charges payable for holiday pay', '4', '428', '0'),
('4284', '4284 Accrued charges payable for employee profit share', '4', '428', '0'),
('4286', '4286 Other accrued charges payable', '4', '428', '0'),
('4287', '4287 Accrued income receivable', '4', '428', '0'),
('43', '43 Social security and other social agencies', '4', '', '0'),
('431', '431 Social security', '4', '43', '0'),
('437', '437 Other social agencies', '4', '43', '0'),
('438', '438 Social agencies Accrued charges payable and income recei', '4', '43', '0'),
('4382', '4382 Contributions for holiday pay', '4', '438', '0'),
('4386', '4386 Other accrued charges payable', '4', '438', '0'),
('4387', '4387 Accrued income receivable', '4', '438', '0'),
('44', '44 State and other public authorities', '4', '', '0'),
('441', '441 Grants receivable', '4', '44', '0'),
('4411', '4411 Investment grants', '4', '441', '0'),
('4417', '4417 Operating grants', '4', '441', '0'),
('4418', '4418 Deficit grants', '4', '441', '0'),
('4419', '4419 Grant advances', '4', '441', '0'),
('442', '442 Taxes and levies recoverable from third parties', '4', '44', '0'),
('4424', '4424 Bondholders', '4', '442', '0'),
('4425', '4425 Partners/associates', '4', '442', '0'),
('443', '443 Particular transactions with the state, public authoriti', '4', '44', '0'),
('4431', '4431 Debts receivable from the state resulting from abolitio', '4', '443', '0'),
('4438', '4438 Accrued interest on debts receivable recorded in Accoun', '4', '443', '0'),
('444', '444 Income tax', '4', '44', '0'),
('445', '445 Turnover tax', '4', '44', '0'),
('4452', '4452 Value added tax due within the European Union', '4', '445', '0'),
('4455', '4455 Turnover tax payable', '4', '445', '0'),
('44551', '44551 Value added tax to be disbursed', '4', '4455', '0'),
('44558', '44558 Taxes in the same category as value added tax', '4', '4455', '0'),
('4456', '4456 Turnover tax deductible', '4', '445', '0'),
('44562', '44562 Value added tax on fixed assets', '4', '4456', '0'),
('44563', '44563 Value added tax transferred by other entities', '4', '4456', '0'),
('44566', '44566 Value added tax on other goods and services', '4', '4456', '0'),
('44567', '44567 Value added tax credit to be carried forward', '4', '4456', '0'),
('44568', '44568 Taxes in the same category as value added tax', '4', '4456', '0'),
('4457', '4457 Turnover tax collected by the entity', '4', '445', '0'),
('44571', '44571 Value added tax collected', '4', '4457', '0'),
('44578', '44578 Taxes in the same category as value added tax', '4', '4457', '0'),
('4458', '4458 Turnover tax to be settled or in suspense', '4', '445', '0'),
('44581', '44581 Instalments Simplified tax regime', '4', '4458', '0'),
('44582', '44582 Instalments Substituted assessment of estimated turnov', '4', '4458', '0'),
('44583', '44583 Requested reimbursement of turnover tax', '4', '4458', '0'),
('44584', '44584 Value added tax recovered in advance', '4', '4458', '0'),
('44586', '44586 Turnover tax on invoices outstanding', '4', '4458', '0'),
('44587', '44587 Turnover tax on invoices to be made out', '4', '4458', '0'),
('446', '446 Guaranteed bonds', '4', '44', '0'),
('447', '447 Other taxes, levies and similar payments', '4', '44', '0'),
('448', '448 Accrued charges payable and income receivable', '4', '44', '0'),
('4482', '4482 Tax charges on holiday pay', '4', '448', '0'),
('4486', '4486 Accrued charges payable', '4', '448', '0'),
('4487', '4487 Accrued income receivable', '4', '448', '0'),
('45', '45 Group and partners/associates', '4', '', '0'),
('451', '451 Group', '4', '45', '0'),
('455', '455 Partners/associates Current accounts', '4', '45', '0'),
('4551', '4551 Principal', '4', '455', '0'),
('4558', '4558 Accrued interest', '4', '455', '0'),
('456', '456 Partners/associates Capital transactions', '4', '45', '0'),
('4561', '4561 Partners/associates Company contribution accounts', '4', '456', '0'),
('45611', '45611 Contributions in kind', '4', '4561', '0'),
('45615', '45615 Contributions in money', '4', '4561', '0'),
('4562', '4562 Contributors Capital called up, unpaid', '4', '456', '0'),
('45621', '45621 Shareholders Subscribed capital called up, unpaid', '4', '4562', '0'),
('45625', '45625 Partners/associates Capital called up, unpaid', '4', '4562', '0'),
('4563', '4563 Partners/associates Payments received for capital incre', '4', '456', '0'),
('4564', '4564 Partners/associates Advance payments', '4', '456', '0'),
('4566', '4566 Defaulting shareholders', '4', '456', '0'),
('4567', '4567 Partners/associates Capital to be reimbursed', '4', '456', '0'),
('457', '457 Partners/associates Dividends payable', '4', '45', '0'),
('458', '458 Partners/associates Joint and Economic Interest Group tr', '4', '45', '0'),
('4581', '4581 Current transactions', '4', '458', '0'),
('4588', '4588 Accrued interest', '4', '458', '0'),
('46', '46 Sundry debts receivable and payable', '4', '', '0'),
('462', '462 Debts receivable on realisation of fixed assets', '4', '46', '0'),
('464', '464 Debts payable on purchases of short-term investment secu', '4', '46', '0'),
('465', '465 Debts receivable on realisation of short-term investment', '4', '46', '0'),
('467', '467 Other debtors or creditors', '4', '46', '0'),
('468', '468 Sundry Accrued charges payable and income receivable', '4', '46', '0'),
('4686', '4686 Accrued charges payable', '4', '468', '0'),
('4687', '4687 Accrued income receivable', '4', '468', '0'),
('47', '47 Provisional or suspense accounts', '4', '', '0'),
('471', '471 475 Suspense accounts', '4', '47', '0'),
('476', '476 Realisable currency exchange losses', '4', '47', '0'),
('4761', '4761 Decrease in debts receivable', '4', '476', '0'),
('4762', '4762 Increase in debts payable', '4', '476', '0'),
('4768', '4768 Differences offset by foreign currency hedging', '4', '476', '0'),
('477', '477 Realisable currency exchange gains', '4', '47', '0'),
('4771', '4771 Increase in debts receivable', '4', '477', '0'),
('4772', '4772 Decrease in debts payable', '4', '477', '0'),
('4778', '4778 Differences offset by foreign currency hedging', '4', '477', '0'),
('478', '478 Other provisional accounts', '4', '47', '0'),
('48', '48 Accrual accounts', '4', '', '0'),
('481', '481 Charges to be allocated to more than one period', '4', '48', '0'),
('4811', '4811 Deferred charges', '4', '481', '0'),
('4812', '4812 Fixed asset acquisition costs', '4', '481', '0'),
('4816', '4816 Loan issue costs', '4', '481', '0'),
('4818', '4818 Charges to be apportioned', '4', '481', '0'),
('486', '486 Prepayments', '4', '48', '0'),
('487', '487 Deferred income', '4', '48', '0'),
('488', '488 Periodic allocation of charges and income', '4', '48', '0'),
('4886', '4886 Charges', '4', '488', '0'),
('4887', '4887 Income', '4', '488', '0'),
('49', '49 Provisions for doubtful debts', '4', '', '0'),
('491', '491 Provisions for doubtful trade debts', '4', '49', '0'),
('495', '495 Provisions for group and partners/associates doubtful de', '4', '49', '0'),
('4951', '4951 Group accounts', '4', '495', '0'),
('4955', '4955 Current accounts of partners/associates', '4', '495', '0'),
('4958', '4958 Joint and Economic Interest Group transactions', '4', '495', '0'),
('496', '496 Provisions for sundry doubtful debts', '4', '49', '0'),
('4962', '4962 Debts receivable on realisation of fixed assets', '4', '496', '0'),
('4965', '4965 Debts receivable on realisation of short-term investmen', '4', '496', '0'),
('4967', '4967 Other debtor accounts', '4', '496', '0'),
('50', '50 Short-term investment securities', '5', '', '0'),
('501', '501 Shares in affiliated entities', '5', '50', '0'),
('502', '502 Own shares', '5', '50', '0'),
('503', '503 Shares', '5', '50', '0'),
('5031', '5031 Quoted shares', '5', '503', '0'),
('5035', '5035 Unquoted shares', '5', '503', '0'),
('504', '504 Other equity securities', '5', '50', '0'),
('505', '505 Own bonds and warrants bought back', '5', '50', '0'),
('506', '506 Bonds', '5', '50', '0'),
('5061', '5061 Quoted bonds', '5', '506', '0'),
('5065', '5065 Unquoted bonds', '5', '506', '0'),
('507', '507 Treasury bills and short-term notes', '5', '50', '0'),
('508', '508 Other short-term investment securities and similar debts', '5', '50', '0'),
('5081', '5081 Other securities', '5', '508', '0'),
('5082', '5082 Equity and bond warrants', '5', '508', '0'),
('5088', '5088 Accrued interest on bonds, warrants and similar securit', '5', '508', '0'),
('509', '509 Unpaid instalments on unpaid short-term investment secur', '5', '50', '0'),
('51', '51 Banks, financial and similar institutions', '5', '', '0'),
('511', '511 Financial instruments for collection', '5', '51', '0'),
('5111', '5111 Outstanding coupons for collection', '5', '511', '0'),
('5112', '5112 Cheques for collection', '5', '511', '0'),
('5113', '5113 Bills for collection', '5', '511', '0'),
('5114', '5114 Bills for discount', '5', '511', '0'),
('512', '512 Banks', '5', '51', '0'),
('5121', '5121 Accounts in French francs/euros', '5', '512', '0'),
('5124', '5124 Accounts in foreign currencies', '5', '512', '0'),
('514', '514 Postal cheques', '5', '51', '0'),
('515', '515 Treasury and public agency accounts', '5', '51', '0'),
('516', '516 Stockbrokers', '5', '51', '0'),
('517', '517 Other financial bodies', '5', '51', '0'),
('518', '518 Accrued interest', '5', '51', '0'),
('5181', '5181 Accrued interest payable', '5', '518', '0'),
('5188', '5188 Accrued interest receivable', '5', '518', '0'),
('519', '519 Current bank advances', '5', '51', '0'),
('5191', '5191 Credit for assignment of commercial debts receivable', '5', '519', '0'),
('5193', '5193 Assignment of debts receivable originating outside Fran', '5', '519', '0'),
('5198', '5198 Accrued interest on current bank advances', '5', '519', '0'),
('52', '52 Short-term financial instruments', '5', '', '0'),
('53', '53 Cash on hand', '5', '', '0'),
('531', '531 Head office cash', '5', '53', '0'),
('5311', '5311 Cash in French francs/euros', '5', '531', '0'),
('5314', '5314 Cash in foreign currencies', '5', '531', '0'),
('532', '532 Cash at branch (or factory) A', '5', '53', '0'),
('533', '533 Cash at branch (or factory) B', '5', '53', '0'),
('54', '54 Expenditure authorisations and letters of credit', '5', '', '0'),
('58', '58 Internal transfers', '5', '', '0'),
('59', '59 Provisions for diminution in value of financial assets', '5', '', '0'),
('590', '590 Short-term investment securities', '5', '59', '0'),
('5903', '5903 Shares', '5', '590', '0'),
('5904', '5904 Other equity securities', '5', '590', '0'),
('5906', '5906 Bonds', '5', '590', '0'),
('5908', '5908 Other short-term investment securities and similar debt', '5', '590', '0'),
('60', '60 Purchases (except 603)', '6', '', '0'),
('601', '601 Inventory item purchases Raw materials (and supplies)', '6', '60', '0'),
('6011', '6011 Materials (or group) A', '6', '601', '0'),
('6012', '6012 Materials (or group) B', '6', '601', '0'),
('6017', '6017 Supplies A, B, C...', '6', '601', '0'),
('602', '602 Inventory item purchases Other consumables', '6', '60', '0'),
('6021', '6021 Consumable materials', '6', '602', '0'),
('60211', '60211 Materials (or group) C', '6', '6021', '0'),
('60212', '60212 Materials (or group) D', '6', '6021', '0'),
('6022', '6022 Consumable supplies', '6', '602', '0'),
('60221', '60221 Fuels', '6', '6022', '0'),
('60222', '60222 Maintenance products', '6', '6022', '0'),
('60223', '60223 Workshop and factory supplies', '6', '6022', '0'),
('60224', '60224 Store supplies', '6', '6022', '0'),
('60225', '60225 Office supplies', '6', '6022', '0'),
('6026', '6026 Packaging', '6', '602', '0'),
('60261', '60261 Non-returnable packaging', '6', '6026', '0'),
('60265', '60265 Unidentifiable recoverable packaging', '6', '6026', '0'),
('603', '603 Change in stocks (consumables and goods for resale)', '6', '60', '0'),
('6031', '6031 Change in stocks of raw materials (and supplies)', '6', '603', '0'),
('6032', '6032 Change in stocks of other consumables', '6', '603', '0'),
('6037', '6037 Change in stocks of goods for resale', '6', '603', '0'),
('604', '604 Purchases of project studies and services', '6', '60', '0'),
('605', '605 Purchases of equipment, facilities and works', '6', '60', '0'),
('606', '606 Non-inventory materials and supplies', '6', '60', '0'),
('6061', '6061 Non-inventoriable supplies (eg. water, energy)', '6', '606', '0'),
('6063', '6063 Maintenance and minor equipment supplies', '6', '606', '0'),
('6064', '6064 Administrative supplies', '6', '606', '0'),
('6068', '6068 Other materials and supplies', '6', '606', '0'),
('607', '607 Purchases of goods for resale', '6', '60', '0'),
('6071', '6071 Goods for resale (or group) A', '6', '607', '0'),
('6072', '6072 Goods for resale (or group) B', '6', '607', '0'),
('608', '608 (Account reserved, as applicable, for recapitulation of ', '6', '60', '0'),
('609', '609 Purchase rebates, discounts, allowances on:', '6', '60', '0'),
('6091', '6091 Raw materials (and supplies)', '6', '609', '0'),
('6092', '6092 Other inventory item consumables', '6', '609', '0'),
('6094', '6094 Project studies and services supplied', '6', '609', '0'),
('6095', '6095 Equipment, facilities and works', '6', '609', '0'),
('6096', '6096 Non-inventory consumables', '6', '609', '0'),
('6097', '6097 Goods for resale', '6', '609', '0'),
('6098', '6098 Unallocated rebates, discounts, allowances', '6', '609', '0'),
('61', '61 External services', '6', '', '0'),
('611', '611 General subcontracting', '6', '61', '0'),
('612', '612 Lease instalments', '6', '61', '0'),
('6122', '6122 Movable property leases', '6', '612', '0'),
('6125', '6125 Real property leases', '6', '612', '0'),
('613', '613 Rental', '6', '61', '0'),
('6132', '6132 Real property rental', '6', '613', '0'),
('6135', '6135 Movable property rental', '6', '613', '0'),
('6136', '6136 Surchages on packaging', '6', '613', '0'),
('614', '614 Rental and joint ownership property costs', '6', '61', '0'),
('615', '615 Maintenance and repairs', '6', '61', '0'),
('6152', '6152 On real property items', '6', '615', '0'),
('6155', '6155 On movable property items', '6', '615', '0'),
('6156', '6156 Maintenance', '6', '615', '0'),
('616', '616 Insurance premiums', '6', '61', '0'),
('6161', '6161 Comprehensive risk', '6', '616', '0'),
('6162', '6162 Compulsory construction loss insurance', '6', '616', '0'),
('6163', '6163 Transport insurance', '6', '616', '0'),
('61636', '61636 Purchases', '6', '6163', '0'),
('61637', '61637 Sales', '6', '6163', '0'),
('61638', '61638 Other items', '6', '6163', '0'),
('6164', '6164 Operating risks', '6', '616', '0'),
('6165', '6165 Customer insolvency', '6', '616', '0'),
('617', '617 Project studies, surveys, assessments', '6', '61', '0'),
('618', '618 Sundry', '6', '61', '0'),
('6181', '6181 General documentation', '6', '618', '0'),
('6183', '6183 Technical documentation', '6', '618', '0'),
('6185', '6185 Colloquium, seminar, conference costs', '6', '618', '0'),
('619', '619 Purchase rebates, discounts, allowances on external serv', '6', '61', '0'),
('62', '62 Other external services', '6', '', '0'),
('621', '621 Personnel external to the entity', '6', '62', '0'),
('6211', '6211 Temporary personnel', '6', '621', '0'),
('6214', '6214 Personnel on secondment or loan to the entity', '6', '621', '0'),
('622', '622 Agents remuneration and fees', '6', '62', '0'),
('6221', '6221 Purchase commission and brokerage', '6', '622', '0'),
('6222', '6222 Sales commission and brokerage', '6', '622', '0'),
('6224', '6224 Payments to forwarding agents', '6', '622', '0'),
('6225', '6225 Payments for factoring', '6', '622', '0'),
('6226', '6226 Fees', '6', '622', '0'),
('6227', '6227 Legal and litigation fees', '6', '622', '0'),
('6228', '6228 Sundry', '6', '622', '0'),
('623', '623 Advertising, publications, public relations', '6', '62', '0'),
('6231', '6231 Announcements and advertisements', '6', '623', '0'),
('6232', '6232 Samples', '6', '623', '0'),
('6233', '6233 Fairs and exhibitions', '6', '623', '0'),
('6234', '6234 Gifts to customers', '6', '623', '0'),
('6235', '6235 Premiums', '6', '623', '0'),
('6236', '6236 Catalogues and printed material', '6', '623', '0'),
('6237', '6237 Publications', '6', '623', '0'),
('6238', '6238 Sundry (eg. tips, standard donations)', '6', '623', '0'),
('624', '624 Transport of goods and collective personnel transport', '6', '62', '0'),
('6241', '6241 Freight in', '6', '624', '0'),
('6242', '6242 Freight out', '6', '624', '0'),
('6243', '6243 Transport between establishments or construction sites', '6', '624', '0'),
('6244', '6244 Administrative transport', '6', '624', '0'),
('6247', '6247 Collective transport of personnel', '6', '624', '0'),
('6248', '6248 Sundry', '6', '624', '0'),
('625', '625 -Business travel, missions and receptions', '6', '62', '0'),
('6251', '6251 Journeys and business travel', '6', '625', '0'),
('6255', '6255 Relocation costs', '6', '625', '0'),
('6256', '6256 Missions', '6', '625', '0'),
('6257', '6257 Receptions', '6', '625', '0'),
('626', '626 Postal and telecommunication costs', '6', '62', '0'),
('627', '627 Banking and similar services', '6', '62', '0'),
('6271', '6271 Securities costs (purchase, sale, safe custody)', '6', '627', '0'),
('6272', '6272 Commissions and loan issue costs', '6', '627', '0'),
('6275', '6275 Charges on bills', '6', '627', '0'),
('6276', '6276 Rental of safes', '6', '627', '0'),
('6278', '6278 Other expenses and commissions on services supplied', '6', '627', '0'),
('628', '628 Sundry', '6', '62', '0'),
('6281', '6281 Sundry assistance (eg. contributions)', '6', '628', '0'),
('6284', '6284 Personnel recruitment costs', '6', '628', '0'),
('629', '629 Purchase rebates, discounts, allowances on other externa', '6', '62', '0'),
('63', '63 Taxes, levies and similar payments', '6', '', '0'),
('631', '631 Taxes, levies and similar payments on wages and salaries', '6', '63', '0'),
('6311', '6311 Tax on salaries', '6', '631', '0'),
('6312', '6312 Apprenticeship tax', '6', '631', '0'),
('6313', '6313 Employer participation in ongoing personnel training an', '6', '631', '0'),
('6314', '6314 Default contribution for compulsory investment in const', '6', '631', '0'),
('6318', '6318 Other', '6', '631', '0'),
('633', '633 Taxes, levies and similar payments on wages and salaries', '6', '63', '0'),
('6331', '6331 Transport expenditures', '6', '633', '0'),
('63311', '63311 Business entity tax', '6', '6331', '0'),
('6332', '6332 Accommodation allowances', '6', '633', '0'),
('6333', '6333 Employer participation in ongoing personnel training an', '6', '633', '0'),
('6334', '6334 Employer participation in construction projects', '6', '633', '0'),
('6335', '6335 Discharge payments entitling exemption from apprentices', '6', '633', '0'),
('6338', '6338 Other', '6', '633', '0'),
('635', '635 Other taxes, levies and similar payments (to the tax adm', '6', '63', '0'),
('6351', '6351 Direct taxes (except income tax)', '6', '635', '0'),
('63512', '63512 Property taxes', '6', '6351', '0'),
('63513', '63513 Other local rates and taxes', '6', '6351', '0'),
('63514', '63514 Tax on company vehicles', '6', '6351', '0'),
('6352', '6352 Non-recoverable turnover tax', '6', '635', '0'),
('6353', '6353 Indirect taxes', '6', '635', '0'),
('6354', '6354 Registration and stamp duties', '6', '635', '0'),
('63541', '63541 Transfer duty', '6', '6354', '0'),
('6358', '6358 Other duties', '6', '635', '0'),
('637', '637 Other taxes, levies and similar payments (to other bodie', '6', '63', '0'),
('6371', '6371 Social solidarity contribution chargeable to companies', '6', '637', '0'),
('6372', '6372 Taxes collected by international public bodies', '6', '637', '0'),
('6374', '6374 Taxes and levies due for payment outside France', '6', '637', '0'),
('6378', '6378 Sundry taxes', '6', '637', '0'),
('64', '64 Personnel costs', '6', '', '0'),
('641', '641 Personnel wages and salaries', '6', '64', '0'),
('6411', '6411 Salaries, emoluments', '6', '641', '0'),
('6412', '6412 Holiday pay', '6', '641', '0'),
('6413', '6413 Premiums and bonuses', '6', '641', '0'),
('6414', '6414 Allowances and sundry benefits', '6', '641', '0'),
('6415', '6415 Family income supplement', '6', '641', '0'),
('644', '644 Owner remuneration', '6', '64', '0'),
('645', '645 Social security and provident fund contributions', '6', '64', '0'),
('6451', '6451 Social Security Collection Office (URSSAF) contribution', '6', '645', '0'),
('6452', '6452 Mutual organisation contributions', '6', '645', '0'),
('6453', '6453 Pension fund contributions', '6', '645', '0'),
('6454', '6454 Association for Industrial and Commercial Employment (A', '6', '645', '0'),
('6458', '6458 Contributions to other social agencies', '6', '645', '0'),
('646', '646 Owner social security contributions', '6', '64', '0'),
('647', '647 Other welfare costs', '6', '64', '0'),
('6471', '6471 Direct allowances', '6', '647', '0'),
('6472', '6472 Payments to enterprise/establishment consultative commi', '6', '647', '0'),
('6473', '6473 Payments to health and occupational safety committees', '6', '647', '0'),
('6474', '6474 Payments to other company benefit schemes', '6', '647', '0'),
('6475', '6475 Occupational medicine, pharmacy', '6', '647', '0'),
('648', '648 Other personnel costs', '6', '64', '0'),
('65', '65 Other current operating charges', '6', '', '0'),
('651', '651 Royalties and licence fees for concessions, patents, lic', '6', '65', '0'),
('6511', '6511 Concessions, patents, licences, trade marks, processes,', '6', '651', '0'),
('6516', '6516 Author and reproduction royalties', '6', '651', '0'),
('6518', '6518 Other royalties and similar assets', '6', '651', '0'),
('653', '653 Directors fees', '6', '65', '0'),
('654', '654 Bad debts written off', '6', '65', '0'),
('6541', '6541 Debts receivable for the financial year', '6', '654', '0'),
('6544', '6544 Debts receivable for previous financial years', '6', '654', '0'),
('655', '655 Share of joint venture profit or loss', '6', '65', '0'),
('6551', '6551 Share of profit transferred (accounts of the managing e', '6', '655', '0'),
('6555', '6555 Share of loss (accounts of non-managing partners/associ', '6', '655', '0'),
('658', '658 Sundry current operating charges', '6', '65', '0'),
('66', '66 Financial charges', '6', '', '0'),
('661', '661 Interest charges', '6', '66', '0'),
('6611', '6611 Loan and debt interest', '6', '661', '0'),
('66116', '66116 Loans and similar debts payable', '6', '6611', '0'),
('66117', '66117 Debts payable related to participating interests', '6', '6611', '0'),
('6615', '6615 Current account and credit deposit interest', '6', '661', '0'),
('6616', '6616 Bank and financing transaction interest (eg. discountin', '6', '661', '0'),
('6617', '6617 Interest on guaranteed bonds', '6', '661', '0'),
('6618', '6618 Interest on other debts payable', '6', '661', '0'),
('66181', '66181 Commercial debts payable', '6', '6618', '0'),
('66188', '66188 Sundry debts payable', '6', '6618', '0'),
('664', '664 Losses on debts receivable related to participating inte', '6', '66', '0'),
('665', '665 Discounts allowed', '6', '66', '0'),
('666', '666 Exchange losses', '6', '66', '0'),
('667', '667 Net charges on realisation of short-term investment secu', '6', '66', '0'),
('668', '668 Other financial charges', '6', '66', '0'),
('67', '67 Extraordinary charges', '6', '', '0'),
('671', '671 Extraordinary charges on operating transactions', '6', '67', '0'),
('6711', '6711 Market penalties (and forfeits on purchases and sales)', '6', '671', '0'),
('6712', '6712 Fines, tax and criminal penalties', '6', '671', '0'),
('6713', '6713 Gifts and donations', '6', '671', '0'),
('6714', '6714 Bad debts written off for the financial year', '6', '671', '0'),
('6715', '6715 Grants awarded', '6', '671', '0'),
('6717', '6717 Additional taxes assessed (other than income tax)', '6', '671', '0'),
('6718', '6718 Other extraordinary operating charges', '6', '671', '0'),
('672', '672 (Account available to entities to record prior period ch', '6', '67', '0'),
('675', '675 Book values of realised assets', '6', '67', '0'),
('6751', '6751 Intangible fixed assets', '6', '675', '0'),
('6752', '6752 Tangible fixed assets', '6', '675', '0'),
('6756', '6756 Financial fixed assets', '6', '675', '0'),
('6758', '6758 Other asset components', '6', '675', '0'),
('678', '678 Other extraordinary charges', '6', '67', '0'),
('6781', '6781 Surcharges resulting from escalation clauses', '6', '678', '0'),
('6782', '6782 Prizes', '6', '678', '0'),
('6783', '6783 Deficits resulting from own shares and bonds bought bac', '6', '678', '0'),
('6788', '6788 Sundry extraordinary charges', '6', '678', '0'),
('68', '68 Appropriations to depreciation and provisions', '6', '', '0'),
('681', '681 Operating charges', '6', '68', '0'),
('6811', '6811 Appropriations to depreciation on intangible and tangib', '6', '681', '0'),
('68111', '68111 Intangible fixed assets', '6', '6811', '0'),
('68112', '68112 Tangible fixed assets', '6', '6811', '0'),
('6812', '6812 Amortisation of deferred operating charges', '6', '681', '0'),
('6815', '6815 Appropriations to provisions for operating liabilities ', '6', '681', '0'),
('6816', '6816 Appropriations to provisions for diminution in value of', '6', '681', '0'),
('68161', '68161 Intangible fixed assets', '6', '6816', '0'),
('68162', '68162 Tangible fixed assets', '6', '6816', '0'),
('6817', '6817 Appropriations to provisions for diminution in value of', '6', '681', '0'),
('68173', '68173 Stocks and work in progress', '6', '6817', '0'),
('68174', '68174 Debts receivable', '6', '6817', '0'),
('686', '686 Financial charges', '6', '68', '0'),
('6861', '6861 Appropriations to amortisation of premiums on redemptio', '6', '686', '0'),
('6865', '6865 Appropriations to provisions for financial liabilities ', '6', '686', '0');
INSERT INTO `0_chart_types` VALUES
('6866', '6866 Appropriations to provisions for diminution in value of', '6', '686', '0'),
('68662', '68662 Financial fixed assets', '6', '6866', '0'),
('68665', '68665 Short-term investment securities', '6', '6866', '0'),
('6868', '6868 Other appropriations', '6', '686', '0'),
('687', '687 Extraordinary charges', '6', '68', '0'),
('6871', '6871 Appropriations to extraordinary fixed asset depreciatio', '6', '687', '0'),
('6872', '6872 Appropriations to tax-regulated provisions (fixed asset', '6', '687', '0'),
('68725', '68725 Depreciation by derogation', '6', '6872', '0'),
('6873', '6873 Appropriations to tax-regulated provisions (stocks)', '6', '687', '0'),
('6874', '6874 Appropriations to other tax-regulated provisions', '6', '687', '0'),
('6875', '6875 Appropriations to provisions for extraordinary liabilit', '6', '687', '0'),
('6876', '6876 Appropriations to provisions for extraordinary diminuti', '6', '687', '0'),
('69', '69 Employee profit share Income and similar taxes', '6', '', '0'),
('691', '691 Employee profit share', '6', '69', '0'),
('695', '695 Income tax', '6', '69', '0'),
('6951', '6951 Income tax due in France', '6', '695', '0'),
('6952', '6952 Additional contribution to income tax', '6', '695', '0'),
('6954', '6954 Income tax due outside France', '6', '695', '0'),
('696', '696 Supplementary company tax related to profit distribution', '6', '69', '0'),
('697', '697 Annual company imputed tax', '6', '69', '0'),
('698', '698 Group tax', '6', '69', '0'),
('6981', '6981 Group tax Charges', '6', '698', '0'),
('6989', '6989 Group tax Income', '6', '698', '0'),
('699', '699 Income Carry-back of losses', '6', '69', '0'),
('70', '70 Sales of manufactured products, services, goods for resal', '7', '', '0'),
('701', '701 Sales of finished products', '7', '70', '0'),
('7011', '7011 Finished products (or group) A', '7', '701', '0'),
('7012', '7012 Finished products (or group) B', '7', '701', '0'),
('702', '702 Sales of semi-finished products', '7', '70', '0'),
('703', '703 Sales of residual products', '7', '70', '0'),
('704', '704 Works', '7', '70', '0'),
('7041', '7041 Works of category (or activity) A', '7', '704', '0'),
('7042', '7042 Works of category (or activity) B', '7', '704', '0'),
('705', '705 Project studies', '7', '70', '0'),
('706', '706 Services supplied', '7', '70', '0'),
('707', '707 Sales of goods for resale', '7', '70', '0'),
('7071', '7071 Goods for resale (or group) A', '7', '707', '0'),
('7072', '7072 Goods for resale (or group) B', '7', '707', '0'),
('708', '708 Income from related activities', '7', '70', '0'),
('7081', '7081 Income from services operated in the interest of person', '7', '708', '0'),
('7082', '7082 Commission and brokerage', '7', '708', '0'),
('7083', '7083 Sundry rentals', '7', '708', '0'),
('7084', '7084 Personnel charged out', '7', '708', '0'),
('7085', '7085 Carriage and ancillary costs invoiced', '7', '708', '0'),
('7086', '7086 Surplus on recovery of returnable packaging', '7', '708', '0'),
('7087', '7087 Bonuses obtained from customers and sales premiums', '7', '708', '0'),
('7088', '7088 Other income from ancillary activities (eg. disposal of', '7', '708', '0'),
('709', '709 Sales rebates, discounts, allowances granted by the enti', '7', '70', '0'),
('7091', '7091 Sales of finished products', '7', '709', '0'),
('7092', '7092 Sales of semi-finished products', '7', '709', '0'),
('7094', '7094 Works', '7', '709', '0'),
('7095', '7095 Project studies', '7', '709', '0'),
('7096', '7096 Services supplied', '7', '709', '0'),
('7097', '7097 Sales of goods for resale', '7', '709', '0'),
('7098', '7098 Income from ancillary activities', '7', '709', '0'),
('71', '71 Change in stocks of finished products and work in progres', '7', '', '0'),
('713', '713 Change in stocks (work in progress, products)', '7', '71', '0'),
('7133', '7133 Change in work in progress (goods)', '7', '713', '0'),
('71331', '71331 Products in progress', '7', '7133', '0'),
('71335', '71335 Works in progress', '7', '7133', '0'),
('7134', '7134 Change in work in progress (services)', '7', '713', '0'),
('71341', '71341 Project studies in progress', '7', '7134', '0'),
('71345', '71345 Supply of services in progress', '7', '7134', '0'),
('7135', '7135 Change in product stocks', '7', '713', '0'),
('71351', '71351 Semi-finished products', '7', '7135', '0'),
('71355', '71355 Finished products', '7', '7135', '0'),
('71358', '71358 Residual products', '7', '7135', '0'),
('72', '72 Own work capitalised', '7', '', '0'),
('721', '721 Intangible fixed assets', '7', '72', '0'),
('722', '722 Tangible fixed assets', '7', '72', '0'),
('73', '73 Net period income from long-term transactions', '7', '', '0'),
('731', '731 Net period income on transactions in progress (to be sub', '7', '73', '0'),
('739', '739 Net period income on completed transactions', '7', '73', '0'),
('74', '74 Operating grants', '7', '', '0'),
('75', '75 Other current operating income', '7', '', '0'),
('751', '751 Royalties and licence fees for concessions, patents, lic', '7', '75', '0'),
('7511', '7511 Concessions, patents, licences, trade marks, processes,', '7', '751', '0'),
('7516', '7516 Author and reproduction royalties', '7', '751', '0'),
('7518', '7518 Other royalties and similar assets', '7', '751', '0'),
('752', '752 Revenues from buildings not allocated to professional ac', '7', '75', '0'),
('753', '753 Directors fees and remuneration (eg. administrators, man', '7', '75', '0'),
('754', '754 Rebates from cooperatives (resulting from surpluses)', '7', '75', '0'),
('755', '755 Share of joint venture profit or loss', '7', '75', '0'),
('7551', '7551 Share of loss transferred (accounts of the managing ent', '7', '755', '0'),
('7555', '7555 Share of profit (accounts of non-managing partners/asso', '7', '755', '0'),
('758', '758 Sundry current operating income', '7', '75', '0'),
('76', '76 Financial income', '7', '', '0'),
('761', '761 Income from participating interests', '7', '76', '0'),
('7611', '7611 Income from long-term equity interests', '7', '761', '0'),
('7616', '7616 Income from other forms of participating interests', '7', '761', '0'),
('7617', '7617 Income from debts receivable related to participating i', '7', '761', '0'),
('762', '762 Income from other financial fixed assets', '7', '76', '0'),
('7621', '7621 Income from long-term investment securities', '7', '762', '0'),
('7626', '7626 Income from loans', '7', '762', '0'),
('7627', '7627 Income from capitalised debts receivable', '7', '762', '0'),
('763', '763 Income from other debts receivable', '7', '76', '0'),
('7631', '7631 Income from commercial debts receivable', '7', '763', '0'),
('7638', '7638 Income from sundry debts receivable', '7', '763', '0'),
('764', '764 Income from short-term investment securities', '7', '76', '0'),
('765', '765 Discounts obtained', '7', '76', '0'),
('766', '766 Exchange gains', '7', '76', '0'),
('767', '767 Net income on realisation of short-term investment secur', '7', '76', '0'),
('768', '768 Other financial income', '7', '76', '0'),
('77', '77 Extraordinary income', '7', '', '0'),
('771', '771 Extraordinary income on operating transactions', '7', '77', '0'),
('7711', '7711 Forfeits and penalties on purchases and sales', '7', '771', '0'),
('7713', '7713 Donations received', '7', '771', '0'),
('7714', '7714 Collection of debts receivable written off', '7', '771', '0'),
('7715', '7715 Deficit grants', '7', '771', '0'),
('7717', '7717 Tax allowances other than income tax', '7', '771', '0'),
('7718', '7718 Other extraordinary income on operating transactions', '7', '771', '0'),
('772', '772 (Account available to entities to record prior period in', '7', '77', '0'),
('775', '775 Income from asset realisation', '7', '77', '0'),
('7751', '7751 Intangible fixed assets', '7', '775', '0'),
('7752', '7752 Tangible fixed assets', '7', '775', '0'),
('7756', '7756 Financial fixed assets', '7', '775', '0'),
('7758', '7758 Other asset components', '7', '775', '0'),
('777', '777 Share of investment grants transferred to profit or loss', '7', '77', '0'),
('778', '778 Other extraordinary income', '7', '77', '0'),
('7781', '7781 Surpluses resulting from escalation clauses', '7', '778', '0'),
('7782', '7782 Prizes', '7', '778', '0'),
('7783', '7783 Surpluses resulting from own shares and bonds bought ba', '7', '778', '0'),
('7788', '7788 Sundry extraordinary income', '7', '778', '0'),
('78', '78 Depreciation and provisions written back', '7', '', '0'),
('781', '781 Depreciation and provisions written back (to be entered ', '7', '78', '0'),
('7811', '7811 Depreciation of intangible and tangible fixed assets wr', '7', '781', '0'),
('78111', '78111 Intangible fixed assets', '7', '7811', '0'),
('78112', '78112 Tangible fixed assets', '7', '7811', '0'),
('7815', '7815 Provisions for operating liabilities and charges writte', '7', '781', '0'),
('7816', '7816 Provisions for diminution in value of intangible and ta', '7', '781', '0'),
('78161', '78161 Intangible fixed assets', '7', '7816', '0'),
('78162', '78162 Tangible fixed assets', '7', '7816', '0'),
('7817', '7817 Provisions for diminution in value of current assets wr', '7', '781', '0'),
('78173', '78173 Stocks and work in progress', '7', '7817', '0'),
('78174', '78174 Debts receivable', '7', '7817', '0'),
('786', '786 Provisions for liabilities written back (to be entered i', '7', '78', '0'),
('7865', '7865 Provisions for financial liabilities and charges writte', '7', '786', '0'),
('7866', '7866 Provisions for diminution in value of financial compone', '7', '786', '0'),
('78662', '78662 Financial fixed assets', '7', '7866', '0'),
('78665', '78665 Short-term investment securities', '7', '7866', '0'),
('787', '787 Provisions written back (to be entered in extraordinary ', '7', '78', '0'),
('7872', '7872 Tax-regulated provisions written back (fixed assets)', '7', '787', '0'),
('78725', '78725 Depreciation by derogation', '7', '7872', '0'),
('78726', '78726 Special revaluation provision', '7', '7872', '0'),
('78727', '78727 Reinvested capital gain', '7', '7872', '0'),
('7873', '7873 Tax-regulated provisions written back (stocks)', '7', '787', '0'),
('7874', '7874 Other tax-regulated provisions written back', '7', '787', '0'),
('7875', '7875 Provisions for extraordinary liabilities and charges wr', '7', '787', '0'),
('7876', '7876 Provisions for extraordinary diminution in value writte', '7', '787', '0'),
('79', '79 Charges transferred', '7', '', '0'),
('791', '791 Operating charges transferred', '7', '79', '0'),
('796', '796 Financial charges transferred', '7', '79', '0'),
('797', '797 Extraordinary charges transferred', '7', '79', '0');

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
('1', 'Good History', '0', '0'),
('3', 'No more work until payment received', '1', '0'),
('4', 'In liquidation', '1', '0');

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
('CA Dollars', 'CAD', '', '', '', '0', '1'),
('Euro', 'EUR', '?', 'Europe', 'Cents', '0', '1'),
('Pounds', 'GBP', '?', 'England', 'Pence', '0', '1'),
('US Dollars', 'USD', '$', 'United States', 'Cents', '0', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

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
('1', 'Small', '0'),
('2', 'Medium', '0'),
('3', 'Large', '0');

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
('d', 'days', '1', '0'),
('ea.', 'Each', '0', '0');

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
('DEF', 'Default', 'N/A', '', '', '', '', '', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', 'Due 15th Of the Following Month', '0', '17', '0'),
('2', 'Due By End Of The Following Month', '0', '30', '0'),
('3', 'Payment due within 10 days', '10', '0', '0'),
('4', 'Cash Only', '1', '0', '0'),
('5', 'Prepaid', -1, 0, 0);

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
('1', 'Out of office', NULL, '0'),
('2', 'Sales Department', NULL, '0'),
('3', 'Central', NULL, '2'),
('4', 'Sales Department', '104', '2'),
('5', 'Sales Department', '105', '2'),
('6', 'Sales Department', '107', '2'),
('7', 'Sales Department', '109', '2'),
('8', 'Sales Department', '110', '2'),
('9', 'Sales Department', '201', '2');

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
('1', 'QL500', 'Label printer', 'QL500', 'server', '127', '20'),
('2', 'Samsung', 'Main network printer', 'scx4521F', 'server', '515', '5'),
('3', 'Local', 'Local print server at user IP', 'lp', '', '515', '10');

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
('1', '1', 'Maintenance', NULL, '0', 'Amount', '0'),
('2', '1', 'Phone', NULL, '0', 'Amount', '0'),
('3', '2', 'Cash Sales', NULL, '0', 'Amount', '0');

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
('20', '35', '', '1', '', '1', '0'),
('21', '40', '', '1', '', '1', '0'),
('22', '32', '', '1', '', '1', '0');

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
('1', 'Default', '1', '1', 'DEF', '1', '0');

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
('1', 'Retail', '0', '1', '0'),
('2', 'Wholesale', '0', '1', '0');

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
('1', 'Sales Person', '', '', '', '5', '20000', '4', '0');

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
('1', 'Default', '', '', '', '', '0');

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
('1', 'Components', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0', '0'),
('2', 'Charges', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0', '0'),
('3', 'Systems', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0', '0'),
('4', 'Services', '0', '1', 'each', 'B', '701100', '601100', '311000', '603100', '658000', '0', '0', '0', '0');

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
('base_sales', 'setup.company', 'int', '11', '0'),
('bcc_email', 'setup.company', 'varchar', '100', ''),
('coy_logo', 'setup.company', 'varchar', '100', ''),
('coy_name', 'setup.company', 'varchar', '60', 'Company name'),
('coy_no', 'setup.company', 'varchar', '25', ''),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '401100'),
('curr_default', 'setup.company', 'char', '3', 'EUR'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '411100'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '603100'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '601100'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '701100'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '311000'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '709100'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', '6', '30'),
('default_receival_required', 'glsetup.purchase', 'smallint', '6', '10'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', ''),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '709100'),
('default_wip_act', 'glsetup.items', 'varchar', '15', '658000'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', '487000'),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('domicile', 'setup.company', 'varchar', '55', ''),
('email', 'setup.company', 'varchar', '100', ''),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '666000'),
('f_year', 'setup.company', 'int', '11', '1'),
('fax', 'setup.company', 'varchar', '30', ''),
('freight_act', 'glsetup.customer', 'varchar', '15', '624200'),
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
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '609100'),
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

INSERT INTO `0_tax_group_items` VALUES
('4', '7', '0'),
('5', '9', '0'),
('6', '6', '0'),
('7', '8', '0');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('2', 'No VAT', '0'),
('4', '19.6 collected VAT', '0'),
('5', '5.5 VAT deductible goods/services', '0'),
('6', '19.6 VAT deductible goods/services', '0'),
('7', '19.6 VAT deductible assets', '0');

### Structure of table `0_tax_types` ###

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rate` double NOT NULL DEFAULT '0',
  `sales_gl_code` varchar(15) NOT NULL DEFAULT '',
  `purchasing_gl_code` varchar(15) NOT NULL DEFAULT '',
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('6', '19.6', '445710', '445660', '19.6 VAT deductible goods/services', '0'),
('7', '19.6', '445710', '445660', '19.6 collected VAT', '0'),
('8', '19.6', '445620', '445710', '19.6 VAT deductible assets', '0'),
('9', '5.5', '445660', '445710', '5.5 VAT deductible goods/services', '0'),
('10', '0', '445660', '445710', 'No VAT', '0');

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
  `startup_tab` varchar(20) NOT NULL DEFAULT '',
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
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_GB', '1', '0', '2', '1', 'cool', 'A4', '2', '2', '4', '2', '1', '1', '0', '2009-02-05 15:28:03', '10', '1', '1', '1', '1', '0', 'orders', '30', '0', '1', '0', '0', '0');

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
