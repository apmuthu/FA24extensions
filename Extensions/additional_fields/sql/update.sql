DROP TABLE IF EXISTS `0_addfields_cust`;
CREATE TABLE IF NOT EXISTS `0_addfields_cust` (
    `cust_debtor_no` int(11) NOT NULL,
    `cust_city` varchar(30) DEFAULT NULL,
    `cust_department` varchar(30) DEFAULT NULL,
    `cust_country` varchar(30) DEFAULT NULL,
    `cust_postcode` varchar(15) DEFAULT NULL,
    `cust_doc_type` int(11) DEFAULT NULL,
    `cust_valid_digit` int(1) DEFAULT NULL,
    `cust_start_date` date NOT NULL,
    `cust_sector` varchar(30) DEFAULT NULL,
    `cust_class` varchar(30) DEFAULT NULL,
    `cust_custom_one` tinytext DEFAULT NULL,
    `cust_custom_two` tinytext DEFAULT NULL,
    `cust_custom_three` tinytext DEFAULT NULL,
    `cust_custom_four` tinytext DEFAULT NULL,
    PRIMARY KEY (`cust_debtor_no`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_addfields_item`;
CREATE TABLE IF NOT EXISTS `0_addfields_item` (
    `item_stock_id` varchar(20) NOT NULL,
    `item_bin_num` varchar(30) DEFAULT NULL,
    `item_prime_supp` int(11) DEFAULT NULL,
    `item_prime_supp_no` varchar(30) DEFAULT NULL,
    `item_alternative_part_no` varchar(30) DEFAULT NULL,
    `item_manu_part_no` varchar(20) DEFAULT NULL,
    `item_start_date` date NOT NULL,
    `item_custom_one` tinytext DEFAULT NULL,
    `item_custom_two` tinytext DEFAULT NULL,
    `item_custom_three` tinytext DEFAULT NULL,
    `item_custom_four` tinytext DEFAULT NULL,
    PRIMARY KEY (`item_stock_id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_addfields_supp`;
CREATE TABLE IF NOT EXISTS `0_addfields_supp` (
    `supp_supplier_id` int(11) NOT NULL,
    `supp_city` varchar(30) DEFAULT NULL,
    `supp_department` varchar(30) DEFAULT NULL,
    `supp_country` varchar(30) DEFAULT NULL,
    `supp_postcode` varchar(15) DEFAULT NULL,
    `supp_doc_type` varchar(20) DEFAULT NULL,
    `supp_valid_digit` int(1) DEFAULT NULL,
    `supp_start_date` date NOT NULL,
    `supp_sector` varchar(30) DEFAULT NULL,
    `supp_class` varchar(30) DEFAULT NULL,
    `supp_custom_one` tinytext DEFAULT NULL,
    `supp_custom_two` tinytext DEFAULT NULL,
    `supp_custom_three` tinytext DEFAULT NULL,
    `supp_custom_four` tinytext DEFAULT NULL,
    PRIMARY KEY (`supp_supplier_id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_addfields_doc_type`;
CREATE TABLE `0_addfields_doc_type` (
  `doc_type_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`doc_type_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_areas` ###

INSERT INTO `0_addfields_doc_type` VALUES
('1', 'Identity Card', '0'),
('2', 'Passport', '0');


DROP TABLE IF EXISTS `0_addfields_cust_class`;
CREATE TABLE `0_addfields_cust_class` (
  `cust_class_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cust_class_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_areas` ###

INSERT INTO `0_addfields_cust_class` VALUES
('1', 'Company', '0'),
('2', 'Public', '0');


DROP TABLE IF EXISTS `0_addfields_departments`;
CREATE TABLE `0_addfields_departments` (
  `departments_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `codigo` char(3) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`departments_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_areas` ###

INSERT INTO `0_addfields_departments` VALUES
('1', 'Cornwall', '01', '0'),
('2', 'Devon', '02', '0'),
('3', 'Dorset', '03', '0'),
('4', 'Essex', '04', '0'),
('5', 'Somerset', '05', '0'),
('6', 'Shropshire', '06', '0'),
('7', 'Wiltshire', '07', '0');

DROP TABLE IF EXISTS `0_addfields_city`;
CREATE TABLE `0_addfields_city` (
  `city_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `codigo` char(3) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`city_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_city` ###

INSERT INTO `0_addfields_city` VALUES
('1', 'Brighton', '001', '0'),
('2', 'Chester', '002', '0'),
('3', 'Harwich', '003', '0'),
('4', 'Plymouth', '004', '0'),
('5', 'Swindon', '005', '0'),
('6', 'Truro', '006', '0'),
('7', 'York', '007', '0');

### Structure of table `0_addfields_country` ###

DROP TABLE IF EXISTS `0_addfields_country`;
CREATE TABLE `0_addfields_country` (
  `country_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `codigo` char(3) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`country_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_country` ###

INSERT INTO `0_addfields_country` VALUES
('1', 'Australia', 'au', '0'),
('2', 'Colombia', 'co', '0'),
('3', 'France', 'fr', '0'),
('4', 'Italy', 'it', '0'),
('5', 'Spain', 'es', '0'),
('6', 'USA', 'us', '0'),
('7', 'UK', 'uk', '0');


DROP TABLE IF EXISTS `0_addfields_sectors`;
CREATE TABLE `0_addfields_sectors` (
  `sectors_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `codigo` char(4) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sectors_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_sectors` ###

INSERT INTO `0_addfields_sectors` VALUES
('1', 'Business & Consumer Services', '01', '0'),
('2', 'Clothing, Footwear & Fashion', '02', '0'),
('3', 'Construction', '03', '0'),
('4', 'Financial & Professional Services', '04', '0'),
('5', 'IT', '05', '0'),
('6', 'Leisure & Tourism', '06', '0'),
('7', 'Transport', '07', '0');


DROP TABLE IF EXISTS `0_addfields_cust_custom_labels`;
CREATE TABLE `0_addfields_cust_custom_labels` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_cust_custom_labels` ###

INSERT INTO `0_addfields_cust_custom_labels` VALUES
('1', 'Custom Customer Label One'),
('2', 'Custom Customer Label Two'),
('3', 'Custom Customer Label Three'),
('4', 'Custom Customer Label Four');


DROP TABLE IF EXISTS `0_addfields_item_custom_labels`;
CREATE TABLE `0_addfields_item_custom_labels` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_item_custom_labels` ###

INSERT INTO `0_addfields_item_custom_labels` VALUES
('1', 'Custom Item Label One'),
('2', 'Custom Item Label Two'),
('3', 'Custom Item Label Three'),
('4', 'Custom Item Label Four');


DROP TABLE IF EXISTS `0_addfields_supp_custom_labels`;
CREATE TABLE `0_addfields_supp_custom_labels` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

### Data of table `0_addfields_supp_custom_labels` ###

INSERT INTO `0_addfields_supp_custom_labels` VALUES
('1', 'Custom Supplier Label One'),
('2', 'Custom Supplier Label Two'),
('3', 'Custom Supplier Label Three'),
('4', 'Custom Supplier Label Four');