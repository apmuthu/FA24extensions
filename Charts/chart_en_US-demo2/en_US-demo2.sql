# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 17:02
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
('1', 'USA', '0'),
('2', 'UK', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('10000', '0', 'Fixed Deposit', '111-111111', 'Fixed Dposit', 'Fixed Deposit', 'USD', '0', '3', '14000', '0000-00-00 00:00:00', '0', '0'),
('11000', '1', 'Bank Current Account', '222-222222', 'Bank Current Account', 'Bank Current Account', 'USD', '0', '4', '14000', '0000-00-00 00:00:00', '0', '0'),
('10100', '3', 'Cash', 'N/A', 'Cash', 'Cash', 'USD', '0', '5', '14000', '0000-00-00 00:00:00', '0', '0'),
('10200', '3', 'Petty Cash', 'N/A', 'Petty Cash', 'Petty Cash', 'USD', '0', '6', '14000', '0000-00-00 00:00:00', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 ;

### Data of table `0_bank_trans` ###

INSERT INTO `0_bank_trans` VALUES
('1', '2', '5', '4', '1', '2019-01-01', '100000', '0', '0', '0', 'Capital Paid', '0000-00-00'),
('2', '1', '8', '4', '1', '2019-01-02', '-6000', '0', '0', '0', 'Mechanical Co. - Purchasing Machieries ', '0000-00-00'),
('3', '1', '9', '4', '2', '2019-01-10', '-55', '0', '0', '0', 'Miscellaneous', '0000-00-00'),
('4', '1', '10', '4', '3', '2019-01-19', '-23', '0', '0', '0', 'Labour and Manufacturing ', '0000-00-00'),
('5', '12', '7', '4', '1', '2019-01-25', '15', '0', '0', '2', '1', '0000-00-00');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 ;

### Data of table `0_bom` ###

INSERT INTO `0_bom` VALUES
('1', 'FG-01', 'RM-01', '1', 'DEF', '2'),
('5', 'FG-01', 'RM-01', '1', 'WH01', '3'),
('6', 'FG-01', 'RM-02', '1', 'WH01', '2'),
('2', 'FG-01', 'RM-03', '1', 'DEF', '3'),
('3', 'FG-02', 'RM-02', '1', 'DEF', '5'),
('7', 'FG-02', 'RM-02', '2', 'WH01', '4'),
('4', 'FG-02', 'RM-03', '1', 'DEF', '3'),
('8', 'FG-02', 'RM-03', '2', 'WH02', '4');

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
('1', 'L1 - Assets', '1', '0'),
('2', 'L1 - Liabilities', '2', '0'),
('3', 'L1 - Owner&#039;s Equity', '3', '0'),
('4', 'L1 - Income', '4', '0'),
('5', 'L1 - Cost of Sales', '5', '0'),
('6', 'L1 - Expenses', '6', '0');

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
('10000', '', 'Bank Deposit Account', '101', '0'),
('10100', '', 'Cash', '101', '0'),
('10200', '', 'Petty Cash', '101', '0'),
('11000', '', 'Bank Current Account', '102', '0'),
('12000', '', 'Accounts Receivable', '103', '0'),
('12001', '', 'Sundry Debtors', '103', '0'),
('13000', '', 'Other Debtors', '104', '0'),
('14000', '', 'Stock of Raw Material', '105', '0'),
('14001', '', 'Work in Progress', '105', '0'),
('14002', '', 'Finished Goods', '105', '0'),
('15000', '', 'Prepayments', '106', '0'),
('19000', '', 'Freehold Property', '151', '0'),
('19001', '', 'Freehold Property - Accumulated Depreciation', '151', '0'),
('19002', '', 'Leasehold Property', '151', '0'),
('19003', '', 'Leasehold Property - Accumulated Depreciation', '151', '0'),
('19100', '', 'Plant and Machinery', '152', '0'),
('19101', '', 'Plant &amp; Machinery - Accumulated Depreciation', '152', '0'),
('19200', '', 'Office Equipment', '153', '0'),
('19201', '', 'Office Equipment - Accumulated Depreciation', '153', '0'),
('19300', '', 'Furniture and Fixtures', '154', '0'),
('19301', '', 'Furniture and Fixtures - Accumulated Depreciation', '154', '0'),
('19400', '', 'Motor Vehicles', '155', '0'),
('19401', '', 'Motor Vehicles - Accumulated Depreciation', '155', '0'),
('20000', '', 'Accounts Payable', '201', '0'),
('20001', '', 'Sundry Creditors', '201', '0'),
('21000', '', 'Other Creditors', '202', '0'),
('22000', '', 'Accrued Wages', '203', '0'),
('22001', '', 'Accrued Overheads', '203', '0'),
('22700', '', 'Sales Tax - 0%', '203', '0'),
('22710', '', 'Sales Tax - 5%', '203', '0'),
('22720', '', 'Sales Tax - 10%', '203', '0'),
('22750', '', 'Purchase Tax - 0%', '203', '0'),
('22760', '', 'Purchase Tax - 5%', '203', '0'),
('22770', '', 'Purchase Tax - 10%', '203', '0'),
('22800', '', 'VAT Liability', '203', '0'),
('30000', '', 'Ordinary Shares', '301', '0'),
('30010', '', 'Preference Shares', '301', '0'),
('31100', '', 'Profit &amp; Loss Account', '322', '0'),
('32100', '', 'Appropriation of Retained Earnings', '341', '0'),
('32101', '', 'Capital Reserve', '341', '0'),
('32102', '', 'Statutory Reserve', '341', '0'),
('40000', '', 'Sales Type A', '401', '0'),
('40001', '', 'Sales Discount Type A', '401', '0'),
('40002', '', 'Prompt Payment Discount for Sales Type A', '401', '0'),
('49000', '', 'Bank Interest Received', '421', '0'),
('50000', '', 'Cost of Goods Sold', '501', '0'),
('50001', '', 'Discount Taken', '501', '0'),
('50002', '', 'Packaging', '501', '0'),
('50003', '', 'Carriage', '501', '0'),
('50004', '', 'Import Duty (Customs)', '501', '0'),
('50005', '', 'Transport Insurance', '501', '0'),
('50006', '', 'Inventory Adjustments', '501', '0'),
('60000', '', 'Productive Labour', '521', '0'),
('60001', '', 'Overhead Costs', '521', '0'),
('61000', '', 'Sales Commissions', '522', '0'),
('62000', '', 'Sales Promotions', '523', '0'),
('69000', '', 'Advertising', '540', '0'),
('69001', '', 'Gifts and Samples', '540', '0'),
('69002', '', 'Literature &amp; Brochures', '540', '0'),
('70000', '', 'Directors Salaries', '601', '0'),
('70001', '', 'Directors Remuneration', '601', '0'),
('70002', '', 'Staff Salaries', '601', '0'),
('70003', '', 'Wages - Regular', '601', '0'),
('70004', '', 'Wages - Casual', '601', '0'),
('70005', '', 'Severance Pay Expenses', '601', '0'),
('70006', '', 'Vacation Salaries', '601', '0'),
('70007', '', 'Recruitment Expenses', '601', '0'),
('71000', '', 'Rent - Head Office', '602', '0'),
('72000', '', 'Communications - Telephone , Fax , Internet', '603', '0'),
('73000', '', 'Water , Elecricity and Sewerage', '604', '0'),
('74000', '', 'Vehicles Licenses', '605', '0'),
('74001', '', 'Vehicle Insurance', '605', '0'),
('75000', '', 'Repairs and Renewals', '606', '0'),
('75001', '', 'Cleaning', '606', '0'),
('75002', '', 'Premises Expenses', '606', '0'),
('76000', '', 'Printing', '607', '0'),
('76001', '', 'Office Stationery', '607', '0'),
('77000', '', 'Travelling', '608', '0'),
('77001', '', 'Car Hire', '608', '0'),
('77002', '', 'Hotels', '608', '0'),
('77003', '', 'Entertainment', '608', '0'),
('78000', '', 'Equipment Hire', '609', '0'),
('79000', '', 'Audit and Accountancy Fees', '610', '0'),
('79001', '', 'Legal Fees', '610', '0'),
('79002', '', 'Consultancy Fees', '610', '0'),
('79003', '', 'Professional Fees', '610', '0'),
('80000', '', 'Exchange Rate Variance', '611', '0'),
('80001', '', 'Bank Charges', '611', '0'),
('80002', '', 'Loan Interest Paid', '611', '0'),
('81000', '', 'Freehold Property Depreciation', '612', '0'),
('81001', '', 'Leasehold Property Depreciation', '612', '0'),
('81002', '', 'Plant and Machinery Depreciation', '612', '0'),
('81003', '', 'Office Equipment Depreciation', '612', '0'),
('81004', '', 'Furniture and Fixtures Depreciation', '612', '0'),
('81005', '', 'Motor Vehicles Depreciation', '612', '0'),
('82000', '', 'Bad Debt Write Off', '613', '0'),
('82001', '', 'Bad Debt Provision', '613', '0'),
('98000', '', 'Donations', '650', '0'),
('98001', '', 'Subscriptions', '650', '0'),
('98002', '', 'Clothing Costs', '650', '0'),
('98003', '', 'Training Costs', '650', '0'),
('99000', '', 'Suspense Account', '651', '0');

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
('1', 'L2 - Current Assets', '1', '', '0'),
('10', 'L2 - Revenues', '4', '', '0'),
('101', 'L3 - (10000-10999) - Deposits &amp; Cash', '1', '1', '0'),
('102', 'L3 - (11000-11999) - Banks', '1', '1', '0'),
('103', 'L3 - (12000-12999) - Debtors', '1', '1', '0'),
('104', 'L3 - (13000-13999) - Other Debtors', '1', '1', '0'),
('105', 'L3 - (14000-14999) - Stock', '1', '1', '0'),
('106', 'L3 - (15000-15999) - Prepayments', '1', '1', '0'),
('11', 'L2 - Other Income', '4', '', '0'),
('12', 'L2 - Cost of Goods Sold', '5', '', '0'),
('13', 'L2 - Direct Expenses', '5', '', '0'),
('14', 'L2 - Overheads', '6', '', '0'),
('150', 'L3 - (18000-18999) - Other Assets', '1', '1', '0'),
('151', 'L3 - (19000-19099) - Properties', '1', '2', '0'),
('152', 'L3 - (19100-19199) - Plant and Machinery', '1', '2', '0'),
('153', 'L3 - (19200-19299) - Office Equipment', '1', '2', '0'),
('154', 'L3 - (19300-19399) - Furniture and Fixtures', '1', '2', '0'),
('155', 'L3 - (19400-19499) - Motor Vehicles', '1', '2', '0'),
('2', 'L2 - Long-Term Assets', '1', '', '0'),
('201', 'L3 - (20000-20999) - Creditors - Short Term', '2', '5', '0'),
('202', 'L3 - (21000-21999) - Other Creditors', '2', '5', '0'),
('203', 'L3 - (22000-22999) - Accruals', '2', '5', '0'),
('251', 'L3 - (29000-29099) - Creditors - Long Term', '2', '6', '0'),
('3', 'L2 - Intangible Assets', '1', '', '0'),
('301', 'L3 - (30000-30099) - Stated Capital', '3', '7', '0'),
('302', 'L3 - (30100-30199) - Partners Current Accounts', '3', '7', '0'),
('321', 'L3 - (31000-31099) - Previous Years R.E.', '3', '8', '0'),
('322', 'L3 - (31100-31199) - Current Year R.E.', '3', '8', '0'),
('341', 'L3 - (32100-32199) - Reserves &amp; Provesions', '3', '9', '0'),
('4', 'L2 - Other Assets', '1', '', '0'),
('401', 'L3 - (40000-40999) - Sales to Customers', '4', '10', '0'),
('402', 'L3 - (41000-41999) - Sales to Sister Companies', '4', '10', '0'),
('421', 'L3 - (49000-49999) - Other Revenues', '4', '11', '0'),
('5', 'L2 - Current Liabilities', '2', '', '0'),
('501', 'L3 - (50000-50999) - C.O.G.S to Trade Customers', '5', '12', '0'),
('502', 'L3 - (51000-51999) - C.O.G.S to Sister Companies', '5', '12', '0'),
('521', 'L3 - (60000-60999) - Production Costs', '5', '13', '0'),
('522', 'L3 - (61000-61999) - Commissions &amp; Marketing Wages', '5', '13', '0'),
('523', 'L3 - (62000-62999) - Sales Promotions', '5', '13', '0'),
('540', 'L3 - (69000-69999) - Miscellaneous Direct Expenses', '5', '13', '0'),
('6', 'L2 - Long-Term Liabilities', '2', '', '0'),
('601', 'L3 - (70000-70999) - Salaries &amp; Wages', '6', '14', '0'),
('602', 'L3 - (71000-71999) - Rent and Rates', '6', '14', '0'),
('603', 'L3 - (72000-72999) - Telephone , Fax &amp; Internet', '6', '14', '0'),
('604', 'L3 - (73000-73999) - Heat , Light , Power &amp; Water', '6', '14', '0'),
('605', 'L3 - (74000-74999) - Motor Expenses', '6', '14', '0'),
('606', 'L3 - (75000-75999) - Maintenance', '6', '14', '0'),
('607', 'L3 - (76000-76999) - Printing &amp; Stationery', '6', '14', '0'),
('608', 'L3 - (77000-77999) - Travelling &amp; Entertainment', '6', '14', '0'),
('609', 'L3 - (78000-78999) - Equipment Hire and Rental', '6', '14', '0'),
('610', 'L3 - (79000-79999) - Professional Fees', '6', '14', '0'),
('611', 'L3 - (80000-80999) - Bank Charges and Interest', '6', '14', '0'),
('612', 'L3 - (81000-81999) - Depreciation', '6', '14', '0'),
('613', 'L3 - (82000-82999) - Bad Debts', '6', '14', '0'),
('650', 'L3 - (98000-98999) - General Expenses', '6', '14', '0'),
('651', 'L3 - (99000-99999) - Suspense &amp; Mispostings', '6', '14', '0'),
('7', 'L2 - Capital', '3', '', '0'),
('8', 'L2 - Retained Earnings', '3', '', '0'),
('9', 'L2 - Reserves &amp; Provisions', '3', '', '0');

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

INSERT INTO `0_comments` VALUES
('40', '1', '2019-01-01', 'Department - A'),
('40', '2', '2019-01-01', 'Department - B'),
('2', '5', '2019-01-01', 'Capital Paid by Check No. 2233'),
('1', '8', '2019-01-02', 'Mechanical Co. - Purchasing Machieries - Check No. 1'),
('20', '7', '2019-01-07', 'Supplier Invoice No. 4758 Against Order 1'),
('20', '8', '2019-01-09', 'Supplier Invoice No. 9687 Against Order 2'),
('26', '1', '2019-01-15', 'Work Order No. 1'),
('26', '1', '2019-01-06', 'Work Order No. 1'),
('29', '1', '2019-01-16', 'Work Order No. 1'),
('0', '18', '2019-01-08', 'Costs related to work order no. 1'),
('1', '9', '2019-01-10', 'Payment Against Wages and Overheads of Work Order no. 1'),
('0', '19', '2019-01-16', 'Closing of work order  no. 1'),
('26', '2', '2019-01-20', 'Work Order No. 2'),
('26', '2', '2019-01-08', 'Work Order No. 2'),
('16', '3', '2019-01-09', 'Internal Transfer'),
('28', '1', '2019-01-09', 'Additional Material Issued for Work Order No. 2'),
('29', '2', '2019-01-18', 'Partial Production Against Work Order No. 2'),
('0', '20', '2019-01-18', 'Finished Goods of Work Order No. 2'),
('0', '21', '2019-01-17', 'Labour and Manufacturing Overheads of Work Order No.2'),
('1', '10', '2019-01-19', 'Labour and Manufacturing Costs '),
('0', '22', '2019-01-18', 'Stock Adjustment to reconcile with stock report'),
('0', '23', '2019-01-16', 'Closing of work order no. 1'),
('0', '24', '2019-01-18', 'Finished goods of work order no. 2'),
('0', '25', '2019-06-24', 'stock adjustment'),
('12', '7', '2019-01-25', 'Check no. 101'),
('0', '26', '2019-01-20', 'Stock Adjustment to rectify the setup of inventory at the beginning of demo data process '),
('0', '27', '2019-01-20', 'fraction adjustment');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 ;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'customer', 'general', '1'),
('2', '2', 'customer', 'general', '2'),
('3', '3', 'cust_branch', 'general', '12'),
('4', '4', 'cust_branch', 'general', '13'),
('5', '5', 'cust_branch', 'general', '14'),
('6', '6', 'cust_branch', 'general', '4'),
('7', '7', 'supplier', 'general', '5'),
('8', '8', 'supplier', 'general', '6');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 ;

### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES
('1', 'Customer - A', '', NULL, NULL, NULL, NULL, NULL, 'customera@gmail.com', NULL, '', '0'),
('2', 'Customer - B', '', NULL, NULL, NULL, NULL, NULL, 'customerb@hotmail.com', NULL, '', '0'),
('3', 'Branch - B', 'Sub Branch', NULL, NULL, '2222', NULL, '3333', 'customera@gmail.com', NULL, '', '0'),
('4', 'Branch - A', 'Main Branch', NULL, 'USA', '222', NULL, '333', 'customerb@hotmail.com', NULL, '', '0'),
('5', 'Branch - B', 'Main Branch', NULL, 'USA', '222', NULL, '333', 'customerb@hotmail.com', NULL, '', '0'),
('6', 'Branch - A', 'Main Branch', NULL, 'UK', '444', NULL, '555', 'customera@gmail.com', NULL, '', '0'),
('7', 'Supplier - A', 'Supplier Person', NULL, NULL, '22222', NULL, '3333', 'suppliera@gmail.com', NULL, '', '0'),
('8', 'Supplier - B', 'Supplier Person', NULL, NULL, '22222', NULL, '3333', 'supplierb@gmail.com', NULL, '', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_cust_allocations` ###

INSERT INTO `0_cust_allocations` VALUES
('1', '1', '15', '2019-06-24', '7', '12', '17', '10');

### Structure of table `0_cust_branch` ###

DROP TABLE IF EXISTS `0_cust_branch`;

CREATE TABLE `0_cust_branch` (
  `branch_code` int(11) NOT NULL AUTO_INCREMENT,
  `debtor_no` int(11) NOT NULL DEFAULT '0',
  `br_name` varchar(60) NOT NULL DEFAULT '',
  `branch_ref` varchar(30) NOT NULL,
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
  PRIMARY KEY (`branch_code`,`debtor_no`),
  KEY `branch_ref` (`branch_ref`),
  KEY `group_no` (`group_no`)
) ENGINE=InnoDB AUTO_INCREMENT=15 ;

### Data of table `0_cust_branch` ###

INSERT INTO `0_cust_branch` VALUES
('4', '1', 'Branch - A', 'UK', '2', '2', 'WH01', '4', '40000', '40001', '12000', '40002', '1', 'UK', '2', NULL, NULL, '0', 'Branch - A'),
('12', '1', 'Branch - B', '', '2', '2', 'WH01', '3', '40000', '40001', '12000', '40002', '1', '', '2', NULL, NULL, '0', 'Branch - B'),
('13', '2', 'Branch - A', 'USA', '2', '2', 'WH02', '2', '', '40001', '12000', '40002', '1', 'USA', '0', NULL, NULL, '0', 'Branch - A'),
('14', '2', 'Branch - B', 'USA', '2', '2', 'WH02', '2', '', '40001', '12000', '40002', '1', 'USA', '0', NULL, NULL, '0', 'Branch - B');

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

INSERT INTO `0_debtor_trans` VALUES
('17', '10', '0', '1', '4', '2019-01-20', '2019-01-21', '1', '1', '1', '76', '7.6', '15', '0', '0', '15', '0', '1', '1', '0', '0', '4', '0'),
('7', '12', '0', '1', '4', '2019-01-25', '0000-00-00', '1', '0', '0', '15', '0', '0', '0', '0', '15', '0', '1', '0', '0', '0', '4', '0'),
('2', '13', '1', '1', '4', '2019-01-20', '2019-01-20', '1', '1', '1', '76', '7.6', '15', '0', '0', '0', '0', '1', '1', '0', '0', '4', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_debtor_trans_details` ###

INSERT INTO `0_debtor_trans_details` VALUES
('1', '2', '13', 'FG-01', 'Finished Goods - 01', '25', '2.5', '2', '0.05', '15.05900621118', '2', '3'),
('2', '2', '13', 'FG-02', 'Finished Goods - 02', '30', '3', '1', '0.05', '23.98695652172', '1', '4'),
('3', '17', '10', 'FG-01', 'Finished Goods - 01', '25', '2.5', '2', '0.05', '15.05900621118', '0', '1'),
('4', '17', '10', 'FG-02', 'Finished Goods - 02', '30', '3', '1', '0.05', '23.98695652172', '0', '2');

### Structure of table `0_debtors_master` ###

DROP TABLE IF EXISTS `0_debtors_master`;

CREATE TABLE `0_debtors_master` (
  `debtor_no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `debtor_ref` varchar(30) NOT NULL,
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
  PRIMARY KEY (`debtor_no`),
  UNIQUE KEY `debtor_ref` (`debtor_ref`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_debtors_master` ###

INSERT INTO `0_debtors_master` VALUES
('1', 'Customer - A', 'UK', '555', 'USD', '1', '0', '0', '1', '4', '0.05', '0.05', '1000', NULL, '0', 'Customer - A'),
('2', 'Customer - B', 'USA', '6666', 'USD', '2', '0', '0', '1', '1', '0.02', '0.03', '2000', NULL, '0', 'Customer - B');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_dimensions` ###

INSERT INTO `0_dimensions` VALUES
('1', '1', 'Department - A', '1', '0', '2019-01-01', '2015-12-31'),
('2', '2', 'Department - B', '1', '0', '2019-01-01', '2015-12-31');

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
('1', '2018-01-01', '2018-12-31', '1'),
('2', '2019-01-01', '2019-12-31', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=73 ;

### Data of table `0_gl_trans` ###

INSERT INTO `0_gl_trans` VALUES
('1', '2', '5', '2019-01-01', '30000', 'Capital Paid', '-100000', '0', '0', NULL, NULL),
('2', '2', '5', '2019-01-01', '11000', 'Capital Paid by Check No. 2233', '100000', '0', '0', NULL, NULL),
('3', '1', '8', '2019-01-02', '19100', 'Mechanical Co. - Purchasing Machieries ', '6000', '0', '0', NULL, NULL),
('4', '1', '8', '2019-01-02', '11000', 'Mechanical Co. - Purchasing Machieries - Check No. 1', '-6000', '0', '0', NULL, NULL),
('5', '20', '7', '2019-01-07', '20000', '', '-710', '0', '0', '3', '5'),
('6', '20', '7', '2019-01-07', '14000', '', '200', '0', '0', NULL, NULL),
('7', '20', '7', '2019-01-07', '14000', '', '60', '0', '0', NULL, NULL),
('8', '20', '7', '2019-01-07', '14000', '', '450', '0', '0', NULL, NULL),
('9', '20', '7', '2019-01-07', '14000', '', '0', '0', '0', NULL, NULL),
('10', '20', '8', '2019-01-09', '20000', '', '-575', '0', '0', '3', '6'),
('11', '20', '8', '2019-01-09', '14000', '', '100', '0', '0', NULL, NULL),
('12', '20', '8', '2019-01-09', '14000', '', '300', '0', '0', NULL, NULL),
('13', '20', '8', '2019-01-09', '14000', '', '175', '0', '0', NULL, NULL),
('14', '20', '8', '2019-01-09', '14000', '', '0', '0', '0', NULL, NULL),
('15', '26', '1', '2019-01-08', '60000', 'Labour Cost', '-35', '0', '0', NULL, NULL),
('16', '26', '1', '2019-01-08', '14001', 'Labour Cost', '35', '0', '0', NULL, NULL),
('17', '26', '1', '2019-01-08', '60001', 'Overhead Cost', '-20', '0', '0', NULL, NULL),
('18', '26', '1', '2019-01-08', '14001', 'Overhead Cost', '20', '0', '0', NULL, NULL),
('19', '26', '1', '2019-01-16', '14000', '', '-64.29', '0', '0', NULL, NULL),
('20', '26', '1', '2019-01-16', '14000', '', '-31.3', '0', '0', NULL, NULL),
('21', '26', '1', '2019-01-16', '14001', '', '95.59', '0', '0', NULL, NULL),
('22', '0', '18', '2019-01-08', '60000', 'Work Order No. 1', '35', '0', '0', NULL, NULL),
('23', '0', '18', '2019-01-08', '60001', 'Work Order No. 1', '20', '0', '0', NULL, NULL),
('24', '0', '18', '2019-01-08', '22000', 'Work Order No. 1', '-35', '0', '0', NULL, NULL),
('25', '0', '18', '2019-01-08', '22001', 'Work Order No. 1', '-20', '0', '0', NULL, NULL),
('26', '1', '9', '2019-01-10', '22000', 'wages against work order no. 1', '35', '0', '0', NULL, NULL),
('27', '1', '9', '2019-01-10', '22001', 'overheads against work order no. 1', '20', '0', '0', NULL, NULL),
('28', '1', '9', '2019-01-10', '11000', 'Payment Against Wages and Overheads of Work Order no. 1', '-55', '0', '0', NULL, NULL),
('29', '0', '19', '2019-01-16', '14000', 'Closing of work order  no. 1', '0', '0', '0', NULL, NULL),
('30', '0', '19', '2019-01-16', '14001', 'Closing of work order  no. 1', '0', '0', '0', NULL, NULL),
('31', '26', '2', '2019-01-10', '60000', 'Labour Cost', '-14', '0', '0', NULL, NULL),
('32', '26', '2', '2019-01-10', '14001', 'Labour Cost', '14', '0', '0', NULL, NULL),
('33', '26', '2', '2019-06-15', '60001', 'Overhead Cost', '-9', '0', '0', NULL, NULL),
('34', '26', '2', '2019-06-15', '14001', 'Overhead Cost', '9', '0', '0', NULL, NULL),
('35', '26', '2', '2019-01-18', '14000', '', '-18.78', '0', '0', NULL, NULL),
('36', '26', '2', '2019-01-18', '14000', '', '-37.5', '0', '0', NULL, NULL),
('37', '26', '2', '2019-01-18', '14000', '', '-1.88', '0', '0', NULL, NULL),
('38', '26', '2', '2019-01-18', '14001', '', '58.16', '0', '0', NULL, NULL),
('39', '0', '20', '2019-01-18', '14000', 'Finished Goods of Work Order No. 2', '0', '0', '0', NULL, NULL),
('40', '0', '20', '2019-01-18', '14001', 'Finished Goods of Work Order No. 2', '0', '0', '0', NULL, NULL),
('41', '0', '21', '2019-01-17', '60000', 'Labour of Work Order No. 2', '14', '0', '0', NULL, NULL),
('42', '0', '21', '2019-01-17', '60001', 'Manufacturing Overheads of Work Order No. 2', '9', '0', '0', NULL, NULL),
('43', '0', '21', '2019-01-17', '22000', 'Labour of Work Order No. 2', '-14', '0', '0', NULL, NULL),
('44', '0', '21', '2019-01-17', '22001', 'Manufacturing Overheads of Work Order No. 2', '-9', '0', '0', NULL, NULL),
('45', '1', '10', '2019-01-19', '22000', 'Labour of Work Order No. 2', '14', '0', '0', NULL, NULL),
('46', '1', '10', '2019-01-19', '22001', 'Manufacturing Overheads of Work Order No. 2', '9', '0', '0', NULL, NULL),
('47', '1', '10', '2019-01-19', '11000', 'Labour and Manufacturing Costs ', '-23', '0', '0', NULL, NULL),
('48', '0', '22', '2019-01-18', '14001', 'Stock Adjustment', '0', '0', '0', NULL, NULL),
('49', '0', '22', '2019-01-18', '14000', 'Stock Adjusmtent', '0', '0', '0', NULL, NULL),
('50', '0', '23', '2019-01-16', '14000', 'Closing of work order no. 1', '150.59', '0', '0', NULL, NULL),
('51', '0', '23', '2019-01-16', '14001', 'Closing of work order no. 1', '-150.59', '0', '0', NULL, NULL),
('52', '0', '24', '2019-01-18', '14000', 'Finished Goods of Work Order No. 2', '81.16', '0', '0', NULL, NULL),
('53', '0', '24', '2019-01-18', '14001', 'Finished Goods of Work Order No. 2', '-81.16', '0', '0', NULL, NULL),
('54', '0', '25', '2019-06-24', '14001', 'stock adjustment', '10.45', '0', '0', NULL, NULL),
('55', '0', '25', '2019-06-24', '14000', 'Stock Adjusmtent', '-10.45', '0', '0', NULL, NULL),
('56', '13', '2', '2019-01-20', '50000', '', '30.12', '0', '0', NULL, NULL),
('57', '13', '2', '2019-01-20', '14002', '', '-30.12', '0', '0', NULL, NULL),
('58', '13', '2', '2019-01-20', '50000', '', '23.99', '0', '0', NULL, NULL),
('59', '13', '2', '2019-01-20', '14002', '', '-23.99', '0', '0', NULL, NULL),
('60', '10', '17', '2019-01-20', '40000', '', '-50', '0', '0', NULL, NULL),
('61', '10', '17', '2019-01-20', '40001', '', '2.5', '0', '0', NULL, NULL),
('62', '10', '17', '2019-01-20', '40000', '', '-30', '0', '0', NULL, NULL),
('63', '10', '17', '2019-01-20', '40001', '', '1.5', '0', '0', NULL, NULL),
('64', '10', '17', '2019-01-20', '12000', '', '98.6', '0', '0', '2', '1'),
('65', '10', '17', '2019-01-20', '50003', '', '-15', '0', '0', NULL, NULL),
('66', '10', '17', '2019-01-20', '22720', '', '-7.6', '0', '0', NULL, NULL),
('67', '12', '7', '2019-01-25', '11000', '', '15', '0', '0', NULL, NULL),
('68', '12', '7', '2019-01-25', '12000', '', '-15', '0', '0', '2', '1'),
('69', '0', '26', '2019-01-20', '14002', 'Stock Adjustment to rectify the setup of inventory', '222.56', '0', '0', NULL, NULL),
('70', '0', '26', '2019-01-20', '14000', 'Stock Adjustment to rectify the setup of inventory', '-222.56', '0', '0', NULL, NULL),
('71', '0', '27', '2019-01-20', '14000', 'fraction adjustment', '0.01', '0', '0', NULL, NULL),
('72', '0', '27', '2019-01-20', '14001', 'fraction adjustment', '-0.01', '0', '0', NULL, NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_grn_batch` ###

INSERT INTO `0_grn_batch` VALUES
('1', '5', '1', '1', '2019-01-07', 'WH01', '1'),
('2', '6', '2', '2', '2019-01-09', 'WH02', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_grn_items` ###

INSERT INTO `0_grn_items` VALUES
('1', '1', '1', 'RM-01', 'RM-01-A', '100', '100'),
('2', '1', '2', 'RM-02', 'RM-02-A', '30', '30'),
('3', '1', '3', 'RM-03', 'RM-03-A', '150', '150'),
('4', '2', '4', 'RM-01', 'RM-01-B', '40', '40'),
('5', '2', '5', 'RM-02', 'RM-02-B', '200', '200'),
('6', '2', '6', 'RM-03', 'RM-03-B', '50', '50');

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
  `item_code` varchar(20) NOT NULL DEFAULT '',
  `stock_id` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(200) NOT NULL DEFAULT '',
  `category_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  `quantity` double NOT NULL DEFAULT '1',
  `is_foreign` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stock_id` (`stock_id`,`item_code`),
  KEY `item_code` (`item_code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 ;

### Data of table `0_item_codes` ###

INSERT INTO `0_item_codes` VALUES
('1', 'RM-01', 'RM-01', 'Raw Material - 01', '1', '1', '0', '0'),
('2', 'RM-02', 'RM-02', 'Raw Material - 02', '1', '1', '0', '0'),
('3', 'RM-03', 'RM-03', 'Raw Material - 03', '1', '1', '0', '0'),
('4', 'FG-01', 'FG-01', 'Finished Goods - 01', '2', '1', '0', '0'),
('5', 'FG-02', 'FG-02', 'Finished Goods - 02', '2', '1', '0', '0'),
('6', '12345678', 'RM-01', 'Raw Material - 01', '1', '1', '1', '0'),
('7', '23456789', 'RM-02', 'Raw Material - 02', '1', '1', '1', '0'),
('8', '34567891', 'RM-03', 'Raw Material - 03', '1', '1', '1', '0'),
('9', 'COV-01', 'FG-01', 'Covering - 01', '3', '1', '0', '0'),
('10', 'COV-02', 'FG-02', 'Covering - 02', '3', '1', '0', '0');

### Structure of table `0_item_tax_type_exemptions` ###

DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
  `item_tax_type_id` int(11) NOT NULL DEFAULT '0',
  `tax_type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB ;

### Data of table `0_item_tax_type_exemptions` ###

INSERT INTO `0_item_tax_type_exemptions` VALUES
('2', '1'),
('2', '3'),
('3', '1'),
('3', '2');

### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('1', 'Tax Exempt', '1', '0'),
('2', 'Tax - 5%', '0', '0'),
('3', 'Tax - 10%', '0', '0');

### Structure of table `0_item_units` ###

DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
  `abbr` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `decimals` tinyint(2) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`abbr`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

### Data of table `0_item_units` ###

INSERT INTO `0_item_units` VALUES
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

INSERT INTO `0_journal` VALUES
('0', '18', '2019-01-08', '1', '', '2019-01-08', '2019-01-08', 'USD', '55', '1'),
('0', '19', '2019-01-16', '2', '', '2019-01-16', '2019-01-16', 'USD', '0', '1'),
('0', '20', '2019-01-18', '3', '', '2019-01-18', '2019-01-18', 'USD', '0', '1'),
('0', '21', '2019-01-17', '4', '', '2019-01-17', '2019-01-17', 'USD', '23', '1'),
('0', '22', '2019-01-18', '5', '', '2019-01-18', '2019-01-18', 'USD', '0', '1'),
('0', '23', '2019-01-16', '6', '', '2019-01-16', '2019-01-16', 'USD', '150.59', '1'),
('0', '24', '2019-01-18', '7', '', '2019-01-18', '2019-01-18', 'USD', '81.16', '1'),
('0', '25', '2019-06-24', '8', '', '2019-06-24', '2019-06-24', 'USD', '10.45', '1'),
('0', '26', '2019-01-20', '9', '', '2019-01-20', '2019-01-20', 'USD', '222.56', '1'),
('0', '27', '2019-01-20', '10', '', '2019-01-20', '2019-01-20', 'USD', '0.01', '1');

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

INSERT INTO `0_loc_stock` VALUES
('WH01', 'FG-01', '0'),
('WH01', 'FG-02', '0'),
('WH01', 'RM-01', '25'),
('WH01', 'RM-02', '6'),
('WH01', 'RM-03', '15'),
('WH02', 'FG-01', '0'),
('WH02', 'FG-02', '0'),
('WH02', 'RM-01', '10'),
('WH02', 'RM-02', '40'),
('WH02', 'RM-03', '5');

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
('WH01', 'Warehouse - 01', 'USA', '2222', '', '3333', 'warehouse1@company.com', 'Store Keeper - 01', '0', '0'),
('WH02', 'Warehouse - 02', 'UK', '33333', '', '44444', 'warehouse2@company.com', 'Store Keeper - 02', '0', '0');

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
('4', 'Cash Only', '1', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES
('1', 'FG-01', '1', 'USD', '25'),
('2', 'FG-01', '2', 'USD', '21'),
('3', 'FG-02', '1', 'USD', '30'),
('4', 'FG-02', '2', 'USD', '24');

### Structure of table `0_print_profiles` ###

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) NOT NULL DEFAULT '',
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
  `name` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(60) NOT NULL DEFAULT '',
  `queue` varchar(20) NOT NULL DEFAULT '',
  `host` varchar(40) NOT NULL DEFAULT '',
  `port` smallint(11) unsigned NOT NULL DEFAULT '0',
  `timeout` tinyint(3) unsigned NOT NULL DEFAULT '0',
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

INSERT INTO `0_purch_data` VALUES
('5', 'RM-01', '2', 'ea', '1', 'RM-01-A'),
('5', 'RM-02', '2', 'ea', '1', 'RM-02-A'),
('5', 'RM-03', '3', 'ea', '1', 'RM-03-A'),
('6', 'RM-01', '2.5', 'ea', '1', 'RM-01-B'),
('6', 'RM-02', '1.5', 'ea', '1', 'RM-02-B'),
('6', 'RM-03', '3.5', 'ea', '1', 'RM-03-B');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_purch_order_details` ###

INSERT INTO `0_purch_order_details` VALUES
('1', '1', 'RM-01', 'Raw Material - 01', '2019-01-07', '100', '2', '2', '2', '100', '100'),
('2', '1', 'RM-02', 'Raw Material - 02', '2019-01-07', '30', '2', '2', '2', '30', '30'),
('3', '1', 'RM-03', 'Raw Material - 03', '2019-01-07', '150', '3', '3', '3', '150', '150'),
('4', '2', 'RM-01', 'Raw Material - 01', '2019-01-08', '40', '2.5', '2.5', '2.14285714286', '40', '40'),
('5', '2', 'RM-02', 'Raw Material - 02', '2019-01-08', '200', '1.5', '1.5', '1.5652173913', '200', '200'),
('6', '2', 'RM-03', 'Raw Material - 03', '2019-01-08', '50', '3.5', '3.5', '3.125', '50', '50');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_purch_orders` ###

INSERT INTO `0_purch_orders` VALUES
('1', '5', 'This is the first order', '2019-01-03', '1', '3333', 'WH01', 'USA', '575', '0', '0', '0'),
('2', '6', 'This is the second order', '2019-01-04', '2', '7788', 'WH02', 'UK', '575', '0', '0', '0');

### Structure of table `0_quick_entries` ###

DROP TABLE IF EXISTS `0_quick_entries`;

CREATE TABLE `0_quick_entries` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(60) NOT NULL DEFAULT '',
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
  `qid` smallint(6) unsigned NOT NULL DEFAULT '0',
  `amount` double DEFAULT '0',
  `memo` tinytext NOT NULL,
  `action` char(2) NOT NULL DEFAULT '',
  `dest_id` varchar(15) NOT NULL DEFAULT '',
  `dimension_id` smallint(6) unsigned DEFAULT NULL,
  `dimension2_id` smallint(6) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qid` (`qid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_quick_entry_lines` ###

INSERT INTO `0_quick_entry_lines` VALUES
('1', '1', '0', '', '=', '75000', '0', '0'),
('2', '2', '0', '', '=', '72000', '0', '0'),
('4', '3', '0', '', '=', '11000', '0', '0');

### Structure of table `0_recurrent_invoices` ###

DROP TABLE IF EXISTS `0_recurrent_invoices`;

CREATE TABLE `0_recurrent_invoices` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `order_no` int(11) unsigned NOT NULL DEFAULT '0',
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
('1', '0', '', '11', '', '1', '0'),
('2', '1', '', '4', '', '1', '0'),
('3', '2', '', '2', '', '1', '0'),
('4', '4', '', '1', '', '1', '0'),
('5', '10', '', '2', '', '1', '0'),
('6', '11', '', '1', '', '1', '0'),
('7', '12', '', '2', '', '1', '0'),
('8', '13', '', '2', '', '1', '0'),
('9', '16', '', '2', '', '1', '0'),
('10', '17', '', '1', '', '1', '0'),
('11', '18', '', '3', '', '1', '0'),
('12', '20', '', '3', '', '1', '0'),
('13', '21', '', '1', '', '1', '0'),
('14', '22', '', '1', '', '1', '0'),
('15', '25', '', '3', '', '1', '0'),
('16', '26', '', '3', '', '1', '0'),
('17', '28', '', '2', '', '1', '0'),
('18', '29', '', '3', '', '1', '0'),
('19', '30', '', '1', '', '1', '0'),
('20', '32', '', '1', '', '1', '0'),
('21', '35', '', '1', '', '1', '0'),
('22', '40', '', '3', '', '1', '0');

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

INSERT INTO `0_refs` VALUES
('18', '0', '1'),
('27', '0', '10'),
('19', '0', '2'),
('20', '0', '3'),
('21', '0', '4'),
('22', '0', '5'),
('23', '0', '6'),
('24', '0', '7'),
('25', '0', '8'),
('26', '0', '9'),
('8', '1', '1'),
('9', '1', '2'),
('10', '1', '3'),
('5', '2', '1'),
('17', '10', '1'),
('7', '12', '1'),
('2', '13', '1'),
('3', '16', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_sales_order_details` ###

INSERT INTO `0_sales_order_details` VALUES
('3', '1', '30', 'FG-01', 'Finished Goods - 01', '2', '25', '2', '2', '0.05'),
('4', '1', '30', 'FG-02', 'Finished Goods - 02', '1', '30', '1', '1', '0.05');

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

INSERT INTO `0_sales_orders` VALUES
('1', '30', '3', '0', '1', '4', '1', '', NULL, '2019-01-15', '1', '1', 'UK', '444', NULL, 'Branch - A', '15', 'WH01', '2019-01-20', '4', '91', '0', '0');

### Structure of table `0_sales_pos` ###

DROP TABLE IF EXISTS `0_sales_pos`;

CREATE TABLE `0_sales_pos` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `pos_name` varchar(30) NOT NULL DEFAULT '',
  `cash_sale` tinyint(1) NOT NULL DEFAULT '0',
  `credit_sale` tinyint(1) NOT NULL DEFAULT '0',
  `pos_location` varchar(5) NOT NULL DEFAULT '',
  `pos_account` smallint(6) unsigned NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pos_name` (`pos_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_sales_pos` ###

INSERT INTO `0_sales_pos` VALUES
('1', 'Default', '1', '1', 'DEF', '5', '0');

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
  `salesman_name` varchar(60) NOT NULL DEFAULT '',
  `salesman_phone` varchar(30) NOT NULL DEFAULT '',
  `salesman_fax` varchar(30) NOT NULL DEFAULT '',
  `salesman_email` varchar(100) NOT NULL DEFAULT '',
  `provision` double NOT NULL DEFAULT '0',
  `break_pt` double NOT NULL DEFAULT '0',
  `provision2` double NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`salesman_code`),
  UNIQUE KEY `salesman_name` (`salesman_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_salesman` ###

INSERT INTO `0_salesman` VALUES
('2', 'Sales Man - 1', '111222', '333444', 'salesman1@hotmail.com', '1', '70000', '2', '0'),
('3', 'Sales Man - 2', '555666', '777888', 'salesman2@hotmail.com', '4', '25000', '5', '0');

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
) ENGINE=InnoDB ;

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
('1', 'International Shipping Co.', '111222333', '', 'Shipper', 'USA', '0');

### Structure of table `0_sql_trail` ###

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text NOT NULL,
  `result` tinyint(1) NOT NULL DEFAULT '0',
  `msg` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

### Data of table `0_sql_trail` ###


### Structure of table `0_stock_category` ###

DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
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
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_no_sale` tinyint(1) NOT NULL DEFAULT '0',
  `dflt_no_purchase` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES
('1', 'Raw Material', '0', '1', 'each', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '0'),
('2', 'Finished Goods', '0', '1', 'each', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '0'),
('3', 'Services', '0', '1', 'each', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '0');

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

INSERT INTO `0_stock_master` VALUES
('FG-01', '2', '1', 'Finished Goods - 01', 'Finished Goods - 01', 'ea.', 'M', '40000', '50000', '14002', '50006', '14001', '0', '0', '0', '15.05900621118', '3.5', '2', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', ''),
('FG-02', '2', '2', 'Finished Goods - 02', 'Finished Goods - 02', 'ea.', 'M', '40000', '50000', '14002', '50006', '14001', '0', '0', '0', '23.98695652172', '2.8', '1.8', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', ''),
('RM-01', '1', '2', 'Raw Material - 01', 'Raw Material - 01', 'ea.', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '2.14285714286', '0', '0', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', ''),
('RM-02', '1', '1', 'Raw Material - 02', 'Raw Material - 02', 'ea.', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '1.5652173913', '0', '0', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', ''),
('RM-03', '1', '2', 'Raw Material - 03', 'Raw Material - 03', 'ea.', 'B', '40000', '50000', '14000', '50006', '14001', '0', '0', '0', '3.125', '0', '0', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=18 ;

### Data of table `0_stock_moves` ###

INSERT INTO `0_stock_moves` VALUES
('1', '1', 'RM-01', '25', 'WH01', '2019-01-07', '2', '', '100', '2.14285714286'),
('2', '1', 'RM-02', '25', 'WH01', '2019-01-07', '2', '', '30', '1.5652173913'),
('3', '1', 'RM-03', '25', 'WH01', '2019-01-07', '3', '', '150', '3.125'),
('4', '2', 'RM-01', '25', 'WH02', '2019-01-09', '2.5', '', '40', '2.14285714286'),
('5', '2', 'RM-02', '25', 'WH02', '2019-01-09', '1.5', '', '200', '1.5652173913'),
('6', '2', 'RM-03', '25', 'WH02', '2019-01-09', '3.5', '', '50', '3.125'),
('7', '1', 'RM-01', '26', 'WH01', '2019-01-16', '0', '', '-30', '0'),
('8', '1', 'RM-02', '26', 'WH01', '2019-01-16', '0', '', '-20', '0'),
('9', '1', 'FG-01', '29', 'WH01', '2019-01-16', '0', 'Work Order No. 1', '10', '0'),
('10', '3', 'RM-02', '16', 'WH02', '2019-01-09', '0', '1', '-40', '0'),
('11', '3', 'RM-02', '16', 'WH01', '2019-01-09', '0', '1', '40', '0'),
('12', '1', 'RM-02', '28', 'WH01', '2019-01-09', '0', 'Additional Material Issued for Work Orde', '-2', '0'),
('13', '2', 'RM-02', '26', 'WH01', '2019-01-18', '0', '', '-12', '0'),
('14', '2', 'RM-03', '26', 'WH02', '2019-01-18', '0', '', '-12', '0'),
('15', '2', 'FG-02', '29', 'WH01', '2019-01-18', '0', 'Partial Production Against Work Order No', '3', '0'),
('16', '2', 'FG-01', '13', 'WH01', '2019-01-20', '23.75', '1', '-2', '15.05900621118'),
('17', '2', 'FG-02', '13', 'WH01', '2019-01-20', '28.5', '1', '-1', '23.98695652172');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_supp_invoice_items` ###

INSERT INTO `0_supp_invoice_items` VALUES
('1', '7', '20', '0', '1', '1', 'RM-01', 'RM-01-A', '100', '2', '0', NULL, '0', '0'),
('2', '7', '20', '0', '2', '2', 'RM-02', 'RM-02-A', '30', '2', '0', NULL, '0', '0'),
('3', '7', '20', '0', '3', '3', 'RM-03', 'RM-03-A', '150', '3', '0', NULL, '0', '0'),
('4', '8', '20', '0', '4', '4', 'RM-01', 'RM-01-B', '40', '2.5', '0', NULL, '0', '0'),
('5', '8', '20', '0', '5', '5', 'RM-02', 'RM-02-B', '200', '1.5', '0', NULL, '0', '0'),
('6', '8', '20', '0', '6', '6', 'RM-03', 'RM-03-B', '50', '3.5', '0', NULL, '0', '0');

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

INSERT INTO `0_supp_trans` VALUES
('7', '20', '5', '1', '4758', '2019-01-07', '2019-02-17', '710', '0', '0', '1', '0', '0'),
('8', '20', '6', '2', '9687', '2019-01-09', '2019-03-02', '575', '0', '0', '1', '0', '0');

### Structure of table `0_suppliers` ###

DROP TABLE IF EXISTS `0_suppliers`;

CREATE TABLE `0_suppliers` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supp_name` varchar(60) NOT NULL DEFAULT '',
  `supp_ref` varchar(30) NOT NULL DEFAULT '',
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
  PRIMARY KEY (`supplier_id`),
  KEY `supp_ref` (`supp_ref`)
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES
('5', 'Supplier - A', '', '', '5566', 'Supplier Person', '5233', 'www.suppliera.com', 'National Bank', 'USD', '1', '0', '0', '0', '2', '3000', '14000', '20000', '50001', '', '0', 'Supplier - A'),
('6', 'Supplier - B', '', '', '7788', 'Supplier Person', '5233', 'www.supplierb.com', 'International Bank', 'USD', '2', '0', '0', '0', '2', '5000', '14000', '20000', '50001', '', '0', 'Supplier - B');

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
('bank_charge_act', 'glsetup.general', 'varchar', '15', '14000'),
('base_sales', 'setup.company', 'int', '11', '0'),
('bcc_email', 'setup.company', 'varchar', '100', ''),
('coy_logo', 'setup.company', 'varchar', '100', ''),
('coy_name', 'setup.company', 'varchar', '60', 'Modern Factory Co.'),
('coy_no', 'setup.company', 'varchar', '25', '55555555'),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '20000'),
('curr_default', 'setup.company', 'char', '3', 'USD'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '12000'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '50006'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '50000'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '40000'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '14000'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '40002'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', '6', '30'),
('default_receival_required', 'glsetup.purchase', 'smallint', '6', '10'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '40000'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '40001'),
('default_wip_act', 'glsetup.items', 'varchar', '15', '14001'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', ''),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('domicile', 'setup.company', 'varchar', '55', 'USA'),
('email', 'setup.company', 'varchar', '100', 'admin@modernfactory.com'),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '80000'),
('f_year', 'setup.company', 'int', '11', '2'),
('fax', 'setup.company', 'varchar', '30', '44444566'),
('freight_act', 'glsetup.customer', 'varchar', '15', '50003'),
('gl_closing_date', 'setup.closing_date', 'date', '8', ''),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '0'),
('gst_no', 'setup.company', 'varchar', '25', '31232132'),
('legal_text', 'glsetup.customer', 'tinytext', '0', 'Goods once sold will not be return back .'),
('loc_notification', 'glsetup.inventory', 'tinyint', '1', '0'),
('login_tout', 'setup.company', 'smallint', '6', '600'),
('no_customer_list', 'setup.company', 'tinyint', '1', '0'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('no_zero_lines_amount', 'glsetup.sales', 'tinyint', '1', '1'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('phone', 'setup.company', 'varchar', '30', '22223333'),
('po_over_charge', 'glsetup.purchase', 'int', '11', '10'),
('po_over_receive', 'glsetup.purchase', 'int', '11', '10'),
('postal_address', 'setup.company', 'tinytext', '0', 'USA\r\n'),
('print_invoice_no', 'glsetup.sales', 'tinyint', '1', '0'),
('print_item_images_on_quote', 'glsetup.inventory', 'tinyint', '1', '0'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '9990'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '50001'),
('ref_no_auto_increase','setup.company', 'tinyint', 1, '0'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '31100'),
('round_to', 'setup.company', 'int', '5', '1'),
('show_po_item_codes', 'glsetup.purchase', 'tinyint', '1', '0'),
('suppress_tax_rates', 'setup.company', 'tinyint', '1', '0'),
('tax_algorithm', 'glsetup.customer', 'tinyint', '1', '1'),
('tax_last', 'setup.company', 'int', '11', '1'),
('tax_prd', 'setup.company', 'int', '11', '12'),
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
('2', '1', '0'),
('3', '2', '0'),
('4', '3', '0');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('2', 'Tax Exempt', '0'),
('3', 'Tax - 5%', '0'),
('4', 'Tax - 10%', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('1', '0', '22700', '22750', 'Tax Exempt', '0'),
('2', '5', '22710', '22760', 'Tax - 5%', '0'),
('3', '10', '22720', '22770', 'Tax - 10%', '0');

### Structure of table `0_trans_tax_details` ###

DROP TABLE IF EXISTS `0_trans_tax_details`;

CREATE TABLE `0_trans_tax_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `tran_date` date NOT NULL DEFAULT '0000-00-00',
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
) ENGINE=InnoDB AUTO_INCREMENT=8 ;

### Data of table `0_trans_tax_details` ###

INSERT INTO `0_trans_tax_details` VALUES
('1', '20', '7', '2019-01-07', '1', '0', '1', '0', '650', '0', '4758', '1'),
('2', '20', '8', '2019-01-09', '1', '0', '1', '0', '275', '0', '9687', '1'),
('3', '0', '19', '2019-01-16', '1', '0', '1', '0', '0', '0', 'Closing of work order  no. 1', NULL),
('4', '0', '20', '2019-01-18', '1', '0', '1', '0', '0', '0', 'Finished Goods of Work Order No. 2', NULL),
('5', '0', '22', '2019-01-18', '1', '0', '1', '0', '0', '0', 'Stock Adjustment to reconcile with stock report', NULL),
('6', '13', '2', '2019-01-20', '3', '10', '1', '0', '76', '7.6', '1', NULL),
('7', '10', '17', '2019-01-20', '3', '10', '1', '0', '76', '7.6', '1', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_US', '1', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2019-06-24 20:28:10', '10', '1', '1', '', '1', '0', 'orders', '30', '0', '1', '0', '0', '0'),
('2', 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', '2', '', NULL, 'en_US', '1', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2019-06-24 17:39:42', '10', '1', '1', '', '1', '0', 'orders', '30', '0', '1', '0', '0', '0');

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

INSERT INTO `0_voided` VALUES
('0', '19', '2019-01-16', 'for tax report'),
('0', '20', '2019-01-18', 'for tax report'),
('0', '22', '2019-01-18', 'for tax report');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_wo_issue_items` ###

INSERT INTO `0_wo_issue_items` VALUES
('1', 'RM-02', '1', '2', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_wo_issues` ###

INSERT INTO `0_wo_issues` VALUES
('1', '2', '1', '2019-01-09', 'WH01', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_wo_manufacture` ###

INSERT INTO `0_wo_manufacture` VALUES
('1', '1', '1', '10', '2019-01-16'),
('2', '2', '2', '3', '2019-01-18');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_wo_requirements` ###

INSERT INTO `0_wo_requirements` VALUES
('1', '1', 'RM-01', '1', '3', '0', 'WH01', '0'),
('2', '1', 'RM-02', '1', '2', '0', 'WH01', '0'),
('3', '2', 'RM-02', '2', '4', '0', 'WH01', '0'),
('4', '2', 'RM-03', '2', '4', '0', 'WH02', '0');

### Structure of table `0_workcentres` ###

DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(40) NOT NULL DEFAULT '',
  `description` char(50) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_workcentres` ###

INSERT INTO `0_workcentres` VALUES
('1', 'Production Line - 01', 'Production Line - 01', '0'),
('2', 'Production Line - 02', 'Production Line - 02', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_workorders` ###

INSERT INTO `0_workorders` VALUES
('1', '1', 'WH01', '10', 'FG-01', '2019-01-06', '2', '2019-01-15', '2019-01-06', '10', '1', '1', '0'),
('2', '2', 'WH01', '5', 'FG-02', '2019-01-08', '2', '2019-01-20', '2019-01-08', '3', '0', '1', '0');