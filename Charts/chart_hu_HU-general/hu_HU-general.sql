# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 16:55
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
('1', 'USA', '0');

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
('4', 'Costs', '6', '0');

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
('1111', '', 'Alapítás, átszervezés aktivált értéke', '11', '0'),
('1131', '', 'Vagyoni értékű jogok', '11', '0'),
('1141', '', 'Szellemi termékek', '114', '0'),
('1171', '', 'Immateriális javak értékhelyesbítése', '117', '0'),
('1181', '', 'Immateriális javak terven felüli értékcsökkenése', '118', '0'),
('1191', '', 'Alapitás, átszervezés elszámolt értékcsökkenése', '119', '0'),
('1193', '', 'Vagyoni értékű jogok elszámolt értékcsökkenése', '119', '0'),
('1194', '', 'Szellemi termékek elszámolt értékcsökkenése', '119', '0'),
('1311', '', 'Termelő gépek, berendezések', '131', '0'),
('1321', '', 'Járművek', '132', '0'),
('1371', '', 'Műszaki gépek, berendezések, járművek értékhelyesbít', '137', '0'),
('1381', '', '', '138', '0'),
('1391', '', 'Termelő gépek, berendezések elszámolt értékcsökkenés', '139', '0'),
('1392', '', 'Járművek értékcsökkenése', '139', '0'),
('1411', '', 'Egyéb gép, berendezése, szerszám', '141', '0'),
('1421', '', 'Egyéb járművek', '142', '0'),
('1431', '', 'Irodai, igazgatási berendezés, felszerelés', '143', '0'),
('1451', '', 'Kisértékű gép, berendezés, felszerelés', '145', '0'),
('1452', '', 'Kisértékű irodai, igazgatási berendezés, felszerelés', '145', '0'),
('1471', '', 'Egyéb gép, berendezés, szerszám értékhelyesbítése', '147', '0'),
('1472', '', 'Egyéb járművek értékhelyesbítése', '147', '0'),
('1473', '', 'Irodai, igazgatási berendezés, felszerelés értékhelyesb', '147', '0'),
('1481', '', 'Egyéb gép, berendezés, felszerelés terven felüli érté', '148', '0'),
('1482', '', 'Egyéb járművek terven felüli értékcsökkenése', '148', '0'),
('1483', '', 'Irodai, igazgatási berendezések terven felüli értékcsö', '148', '0'),
('1491', '', 'Egyéb gép, berendezés, szerszám elszámolt értékcsökk', '149', '0'),
('1492', '', 'Egyéb járművek elszámolt értékcsökkenése', '149', '0'),
('1493', '', 'Irodai, igazgatási berendezés, felszerelés elszámolt ér', '149', '0'),
('1495', '', 'Kisértékű tárgyi eszközök értékcsökkenése', '149', '0'),
('1611', '', 'Befejezetlen beruházás', '161', '0'),
('2610', '', 'Áruk beszerzési áron', '26', '0'),
('2690', '', 'Uton levo keszlet', '26', '0'),
('3111', '', 'Belföldi vevők', '311', '0'),
('3150', '', 'Belföldi követelések értékvesztése és visszairása', '311', '0'),
('3161', '', 'Külföldi vevők', '316', '0'),
('3190', '', 'Külföldi követelések értékvesztése és visszairása', '316', '0'),
('3211', '', 'Követelések anyavállalattal szemben', '321', '0'),
('3251', '', 'Jegyzett, de még be nem fizetett tőke', '325', '0'),
('3291', '', 'Követelések értékvesztése ', '329', '0'),
('3311', '', 'Követelések egyéb részesedési viszonyban lévő vállal', '331', '0'),
('3321', '', 'Jegyzett, de még be nem fizetett tőke', '332', '0'),
('3391', '', 'Egyéb részesedési viszonyban lévő vállakozással szemb', '339', '0'),
('3410', '', 'Belföldi váltókövetelések', '34', '0'),
('3460', '', 'Külföldi váltókövetelések', '34', '0'),
('3510', '', 'Immateriális javakra adott előleg', '35', '0'),
('3520', '', 'Beruházásokra adott előleg', '35', '0'),
('3530', '', 'Készletekre adott előleg', '35', '0'),
('3540', '', 'Osztalék előleg', '35', '0'),
('3550', '', 'VPOP ÁFA elszámolási számla', '35', '0'),
('3560', '', 'Egyéb előlegek', '35', '0'),
('3610', '', 'Munkavállalókkal szembeni követelés', '36', '0'),
('3620', '', 'Költségvetési kiutálási igények', '36', '0'),
('3630', '', 'Költségvetési kiutalási igények teljesitése', '36', '0'),
('3640', '', 'Vevőtől kapott előleg ÁFÁ-ja', '36', '0'),
('3661', '', 'Rövid lejáratra adott pénzkölcsön', '366', '0'),
('3662', '', 'Rövid lejáratú betétek', '366', '0'),
('3680', '', 'Egyéb követelések', '366', '0'),
('3690', '', 'Egyéb követelések értékvesztése és visszairása', '366', '0'),
('3710', '', 'Részesedés kapcsolt vállakozásban', '37', '0'),
('3720', '', 'Egyéb részesedés', '37', '0'),
('3790', '', 'Értékpapirok értékvesztése és visszairása', '37', '0'),
('3811', '', 'Főpénztár', '381', '0'),
('3821', '', 'EURO valutapénztár', '382', '0'),
('3822', '', 'USD valutapénztár', '382', '0'),
('3841', '', 'Bankszámla (Ft)', '384', '0'),
('3861', '', 'Bankszámla (EUR)', '386', '0'),
('3862', '', 'Deviza betétszámla USD', '386', '0'),
('3891', '', 'Átvezetés Bank (HUF) - Pénztár (HUF)', '389', '0'),
('3892', '', 'Átvezetés Bank (EUR) - Pénztár (EUR)', '389', '0'),
('3893', '', 'Átvezetés Bank (HUF) - Bank (EUR)', '389', '0'),
('3894', '', 'Átvezetés Pénztár (HUF) - Pénztár (EUR)', '389', '0'),
('3895', '', 'Átvezetés Bank (HUF) - Bank (USD)', '389', '0'),
('3896', '', 'Bankkártya átvezetés', '389', '0'),
('3910', '', 'Bevételek aktiv időbeli elhatárolása', '39', '0'),
('3920', '', 'Költségek ráforditások aktiv időbeli elhatárolása', '39', '0'),
('3930', '', 'Halasztott ráforditások', '39', '0'),
('4110', '', 'Jegyzett tőke', '41', '0'),
('4120', '', 'Tőketartalék', '41', '0'),
('4130', '', 'Eredménytartalék', '41', '0'),
('4140', '', 'Lekötött tartalék', '41', '0'),
('4170', '', 'Értékelési tartalék', '41', '0'),
('4190', '', 'Mérleg szerinti eredmény', '41', '0'),
('4210', '', 'Céltartalékok várható kötelezettségekre', '42', '0'),
('4220', '', 'Céltartalékok a jövőbeni költségekre', '42', '0'),
('4230', '', 'Egyéb céltartalékok', '42', '0'),
('4421', '', 'Hosszú lejáratra kapott kölcsönök', '442', '0'),
('4431', '', 'Beruházási és fejlesztési hitelek', '443', '0'),
('4441', '', 'Egyéb hosszú lejáratú hitel', '444', '0'),
('4461', '', 'Tartós kötelezettség', '446', '0'),
('4471', '', 'Tartós kötelezettség egyéb vállakozással szemben', '447', '0'),
('4491', '', 'Egyéb hosszú lejáratú kötelezettség', '449', '0'),
('4511', '', 'Vevőktől kapott előleg', '451', '0'),
('4541', '', 'Belföldi szállítók', '454', '0'),
('4542', '', 'Külföldi szállítók', '454', '0'),
('4551', '', 'Pénzügyi lízing (éven belüli)', '455', '0'),
('4561', '', 'Rövid lejáratú kötelezettség', '456', '0'),
('4571', '', 'Rövid lejáratú kötelezettség egyéb', '457', '0'),
('4591', '', 'Egyéb rövid lejáratú kötelezettség', '459', '0'),
('4611', '', 'Társasági adó', '461', '0'),
('4619', '', 'Társasági adó megfizetése', '461', '0'),
('4621', '', 'Munkaviszonyból származó SZJA', '462', '0'),
('4629', '', 'SZJA befizetés', '462', '0'),
('4631', '', 'Nyugdíjbiztosítás', '463', '0'),
('4632', '', 'Egészségbiztosítás', '463', '0'),
('4633', '', 'Munkaadói járulék', '463', '0'),
('4634', '', 'Munkavállalói járulék', '463', '0'),
('4635', '', 'Szakképzési hozzájárulás', '463', '0'),
('4636', '', 'Rehabilitációs hozzájárulás', '463', '0'),
('4637', '', 'EHO', '463', '0'),
('4638', '', 'Önellenörzési, késedelmi pótlék', '463', '0'),
('4641', '', 'Nyugdíjbiztosítás teljesitése', '464', '0'),
('4642', '', 'EEgészségbiztosítás teljesitése', '464', '0'),
('4643', '', 'Munkaadói járulék teljesitése', '464', '0'),
('4644', '', 'Munkavállalói járulék teljesitése', '464', '0'),
('4645', '', 'Szakképzési hozzájárulás teljesitése', '464', '0'),
('4646', '', 'Rehabilitációs hozzájárulás teljesitése', '464', '0'),
('4647', '', 'EHO teljesitése', '464', '0'),
('4648', '', 'Önellenörzési, késedelmi pótlék teljesitése', '464', '0'),
('4651', '', 'VPOP elszámolási számla', '465', '0'),
('4661', '', 'Előzetesen felszámítottt ÁFA 20%', '466', '0'),
('4662', '', 'Előzetesen felszámítottt ÁFA 5%', '466', '0'),
('4663', '', 'Előzetesen felszámítottt ÁFA 0%', '466', '0'),
('4664', '', 'Előzetesen felszámítottt ÁFA adómentes', '466', '0'),
('4671', '', 'Fizetendő ÁFA 20%', '467', '0'),
('4672', '', 'Fizetendő ÁFA 5%', '467', '0'),
('4673', '', 'Fizetendő ÁFA 0%', '467', '0'),
('4674', '', 'Fizetendő ÁFA adómentes', '467', '0'),
('4680', '', 'ÁFA elszámolási számla', '467', '0'),
('4691', '', 'Iparűzési adó', '469', '0'),
('4692', '', 'Gépjárműadó', '469', '0'),
('4693', '', 'Kommunális adó', '469', '0'),
('47101', '', 'Jövedelem elszámolás január', '471', '0'),
('47102', '', 'Jövedelem elszámolás február', '471', '0'),
('47103', '', 'Jövedelem elszámolás március', '471', '0'),
('47104', '', 'Jövedelem elszámolás április', '471', '0'),
('47105', '', 'Jövedelem elszámolás május', '471', '0'),
('47106', '', 'Jövedelem elszámolás június', '471', '0'),
('47107', '', 'Jövedelem elszámolás július', '471', '0'),
('47108', '', 'Jövedelem elszámolás augusztus', '471', '0'),
('47109', '', 'Jövedelem elszámolás szeptember', '471', '0'),
('47110', '', 'Jövedelem elszámolás október', '471', '0'),
('47111', '', 'Jövedelem elszámolás november', '471', '0'),
('47112', '', 'Jövedelem elszámolás december', '471', '0'),
('4721', '', 'Fel nem vett járandóság', '472', '0'),
('47311', '', 'Nyugdíjbiztosítási Alap kötelezettség', '4731', '0'),
('47319', '', 'Nyugdíjbiztosítási Alap kötelezettség teljesitése', '4731', '0'),
('47321', '', 'Egészségbiztosítási Alap kötelezettség', '4731', '0'),
('47329', '', 'Egészségbiztosítási Alap kötelezettség teljesitése', '4732', '0'),
('47331', '', 'Magánnyugdíjpénztár', '4733', '0'),
('4781', '', 'Osztalék', '478', '0'),
('4799', '', 'Technikai számla', '479', '0'),
('4810', '', 'Költségek, ráforditások passzív időbeli elhatárolása', '48', '0'),
('4820', '', 'Árbevételek passzív időbeli elhatárolása', '48', '0'),
('4830', '', 'Halasztott bevételek', '48', '0'),
('4910', '', 'Nyitómérleg számla', '48', '0'),
('4920', '', 'Záró mérleg számla', '49', '0'),
('4930', '', 'Adózott eredmény elszámolási számla', '49', '0'),
('5110', '', 'Anyagköltség', '51', '0'),
('5120', '', 'Energia, szemét, közüzemi díj', '51', '0'),
('5130', '', 'Üzemanyag', '51', '0'),
('5140', '', 'Nyomtatványok, irodaszerek', '51', '0'),
('5150', '', 'Tisztítószer', '51', '0'),
('5160', '', 'Szakkönyv, folyóirat', '51', '0'),
('5190', '', 'Egyéb anyagköltség', '51', '0'),
('5211', '', 'Belföldi szállítási költség', '521', '0'),
('5212', '', 'Külföldi szállítási költség', '521', '0'),
('5221', '', 'Irodabérleti díj', '522', '0'),
('5241', '', 'Belföldi utazási költség', '524', '0'),
('5242', '', 'Külföldi utazási költség', '524', '0'),
('5251', '', 'Reklám költség', '525', '0'),
('5252', '', 'Hirdetés költsége', '525', '0'),
('5261', '', 'Oktatás költsége', '526', '0'),
('5271', '', 'Posta költség', '527', '0'),
('5281', '', 'Telefonköltség', '528', '0'),
('5282', '', 'Internet költség', '528', '0'),
('52901', '', 'Könyvvezetés költsége', '529', '0'),
('52902', '', 'Ügyvédi költség', '529', '0'),
('52903', '', 'Tanácsadás', '529', '0'),
('52904', '', 'Vámügyintézés', '529', '0'),
('5299', '', 'Egyéb igénybevett szolgáltatás', '529', '0'),
('5311', '', 'Illetékek, tagdíjak', '531', '0'),
('5321', '', 'Bankköltség', '532', '0'),
('5331', '', 'Vagyonbiztosítás', '533', '0'),
('5391', '', 'Faktordíj', '539', '0'),
('5410', '', 'Bérköltség (munkavállaló, tag)', '54', '0'),
('5420', '', 'Megbizási jogviszony költsége', '54', '0'),
('5450', '', 'Prémium', '54', '0'),
('5510', '', 'Étkezési jegy', '55', '0'),
('5520', '', 'Reprezentáció', '55', '0'),
('5590', '', 'Egyéb személyi jellegű kifizetés', '55', '0'),
('5611', '', 'Nyugdíjbiztosítási járulék', '561', '0'),
('5612', '', 'Egészségbiztosítási járulék', '561', '0'),
('5621', '', 'Tételes EHO', '562', '0'),
('5622', '', 'Százalékos EHO', '562', '0'),
('5630', '', 'Munkaadói járulék', '562', '0'),
('5640', '', 'Szakképzési hozzájárulás', '562', '0'),
('5650', '', 'Rehabilitációs hozzájárulás', '562', '0'),
('5690', '', 'Egyéb bérjárulékok', '562', '0'),
('5710', '', 'Terv szerinti értékcsökkenési leirás', '57', '0'),
('5720', '', 'Kisértékű eszközök értékcsökkenése', '57', '0'),
('8110', '', 'Anyagköltség', '81', '0'),
('8120', '', 'Igénybevett szolgáltatás', '81', '0'),
('8130', '', 'Eladott szolgáltatások értéke', '81', '0'),
('8140', '', 'ELÁBÉ', '81', '0'),
('8150', '', 'Eladott (közvetitett) szolgáltatás értéke', '81', '0'),
('8611', '', 'Értékesitett immateriális javak nyilvántartási értéke', '861', '0'),
('8612', '', 'Értékesitett tárgyi eszközök nyilvántartási értéke', '861', '0'),
('8631', '', 'késedelmi kamatok', '863', '0'),
('8641', '', 'Céltartalék képzése', '864', '0'),
('8651', '', 'Követelések értékvesztése', '865', '0'),
('8652', '', 'Immateriális javak terven felüli értékcsökkenése', '865', '0'),
('8653', '', 'Tárgyi eszközök terven felüli értékcsökkenése', '865', '0'),
('8661', '', 'Iparűzési adó', '866', '0'),
('8662', '', 'Gépjárműadó', '866', '0'),
('8663', '', 'Kommunális adó', '866', '0'),
('8681', '', 'Le nem vonható ÁFA', '868', '0'),
('8682', '', 'Önellenörzési pótlék', '868', '0'),
('8691', '', 'Káresemények', '869', '0'),
('8694', '', 'Előző évet terhelő ráforditások', '869', '0'),
('8698', '', 'Kerekitési különbözet', '869', '0'),
('8699', '', 'Egyéb ráforditások', '869', '0'),
('8710', '', 'Fizetett osztalék, részesedés', '87', '0'),
('8720', '', 'Részesedések, értékpapirok, bankbetétek értékvesztés', '87', '0'),
('8730', '', 'Befektett pénzügyi eszközök árfolyam vesztesége', '87', '0'),
('8741', '', 'Fizetett kamatok kapcsolt vállakozásnak', '874', '0'),
('8742', '', 'Fizetett kamatok egyéb vállakozásoknak', '874', '0'),
('8743', '', 'Pénzintézetnek fizetett kamatok', '874', '0'),
('8744', '', 'Magénszemélyeknek fizetett kamatok', '874', '0'),
('8761', '', 'Deviza és valutakészletek átváltási árfolyamveszteség', '876', '0'),
('8762', '', 'Követelések és kötelezettségek árfolyamvesztesége', '876', '0'),
('8791', '', 'Faktordíj', '879', '0'),
('8820', '', 'Társaságba bevitt vagyontárgyak nyilvántartás szerinti ', '881', '0'),
('8830', '', 'Véglegesen átadott pénzeszköz', '881', '0'),
('8840', '', 'Elengedett követelés', '881', '0'),
('8890', '', 'Egyéb rendkívüli ráforditások', '881', '0'),
('8910', '', 'Társasági adó', '89', '0'),
('9111', '', 'Belföldi termekértékesítés árbevétele', '911', '0'),
('9112', '', 'Belföldi szolgáltatás árbevétele', '911', '0'),
('9311', '', 'Export termekértékesítés árbevétele', '931', '0'),
('9312', '', 'Export szolgáltatás árbevétele', '931', '0'),
('9611', '', 'Értékesitett immateriális javak bevétele', '961', '0'),
('9612', '', 'Értékesitett tárgyi eszközök bevétele', '961', '0'),
('9631', '', 'Kapott késedelmi kamatok', '963', '0'),
('9641', '', 'Céltartalék képzése', '964', '0'),
('9651', '', 'Követelések értékvesztésének visszairása', '965', '0'),
('9652', '', 'Immateriális javak terven felüli értékcsökkenésének v', '965', '0'),
('9653', '', 'Tárgyi eszközök terven felüli érétkcsökkenésének vi', '965', '0'),
('9691', '', 'Káresemények bevételei', '965', '0'),
('9698', '', 'Kerekítési különbözet', '965', '0'),
('9699', '', 'Egyéb bevételek', '969', '0'),
('9710', '', 'Kapott osztalék, részesedés', '97', '0'),
('9720', '', 'Részesedések, értékpapirok, bankbetétek értékvesztés', '97', '0'),
('9730', '', 'Befektetett pénzügyi eszközök árfolyam nyeresége', '97', '0'),
('9741', '', 'Kapott kamatok kapcsolt vállalkozástól', '974', '0'),
('9742', '', 'Kapott kamatok egyéb vállakozástól', '974', '0'),
('9743', '', 'Kapott kamatok pénzintézettől', '974', '0'),
('9744', '', 'Magánszemélytől kapott kamatok', '974', '0'),
('9761', '', 'Deviza és valutakészlet átváltási árfolyamnyeresége', '976', '0'),
('9762', '', 'Követelések és kötelezettségek árfolyamnyeresége', '976', '0'),
('9791', '', 'Egyéb pénzügyi bevételek', '979', '0'),
('9810', '', 'Ellenérték nélkül kapott eszközök értéke', '98', '0'),
('9820', '', 'Társaságba bevitt vagyontárgyak szerződés szerinti ért', '98', '0'),
('9830', '', 'Véglegesen kapott pénzeszköz', '98', '0'),
('9840', '', 'Elengedett kötelezettség', '98', '0'),
('9890', '', 'Egyéb rendkívüli bevételek', '98', '0');

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
('11', 'Immateriális javak', '1', '', '0'),
('114', 'Szellemi termékek', '1', '', '0'),
('117', 'Immateriális javak értékhelyesbítése', '1', '', '0'),
('118', 'Immateriális javak terven felüli értékcsökkenése', '1', '', '0'),
('119', 'Immateriális javak értékcsökkenése', '1', '', '0'),
('12', 'Ingatlanok', '1', '', '0'),
('13', 'Műszaki gépek, berendezések, járművek', '1', '', '0'),
('131', 'Termelő gépek, berendezések', '1', '13', '0'),
('132', 'Járművek', '1', '13', '0'),
('137', 'Műszaki gépek, berendezések járművek értékhelyesb.', '1', '13', '0'),
('138', 'Műszaki gépek, berendezések, járművek terven felüli é', '1', '13', '0'),
('139', 'Műszaki gépek, berendezések, járművek értékcsökk.', '1', '13', '0'),
('14', 'Egyéb gépek, berendezések, járművek', '1', '', '0'),
('141', 'Egyéb gép, berendezés, szerszám', '1', '14', '0'),
('142', 'Egyéb járművek', '1', '14', '0'),
('143', 'Irodai, igazgatási berendezés, felszerelés', '1', '14', '0'),
('145', 'Kisértékű tárgyi eszköz', '1', '14', '0'),
('147', 'Egyéb gépek, berendezések, járművek értékhelyesbíté', '1', '14', '0'),
('148', 'Egyéb gépek, berendezések, járművek terven felüli ért', '1', '', '0'),
('149', 'Egyéb gépek, berendezések, járművek elszámolt értékc', '1', '14', '0'),
('15', 'Beruházások', '1', '', '0'),
('161', 'Befejezetlen beruházások', '1', '15', '0'),
('21', 'Anyagok', '1', '', '0'),
('26', 'Kereskedelmi áruk', '1', '', '0'),
('31', 'Követelések áruszállításból, szolgáltatásból', '1', '', '0'),
('311', 'Belföldi vevők', '1', '31', '0'),
('316', 'Külföldi vevők', '1', '31', '0'),
('32', 'Követelések kapcsolt vállakozással szemben', '1', '', '0'),
('321', 'Követelések', '1', '32', '0'),
('325', 'Jegyzett de be nem fizetett tőke', '1', '32', '0'),
('329', 'Követelések értékvesztése', '1', '32', '0'),
('33', 'Követelések egyéb részesedési viszonyban lévő vállal', '1', '', '0'),
('331', 'Követelések egyéb részesedési viszonyban lévő vállal', '1', '33', '0'),
('332', 'Jegyzett, de még be nem fizetett tőke egyéb részesedési', '1', '33', '0'),
('339', 'Egyéb részesedési viszonyban lévő vállakozással szemb', '1', '33', '0'),
('34', 'Váltókövetelések', '1', '', '0'),
('35', 'Adott előlegek', '1', '', '0'),
('36', 'Egyéb követelések', '1', '', '0'),
('366', 'Rövid lejáratra adott pénzkölcsönök', '1', '36', '0'),
('37', 'Értékpapirok', '1', '', '0'),
('38', 'Pénzeszközök', '1', '', '0'),
('381', 'Pénztárak', '1', '38', '0'),
('382', 'Valutapénztárak', '1', '38', '0'),
('384', 'Elszámolási betétszámlák (Ft)', '1', '38', '0'),
('386', 'Deviza betétszámlák', '1', '38', '0'),
('389', 'Átvezetési számlák', '1', '38', '0'),
('39', 'Aktiv időbeli elhatárolások', '1', '', '0'),
('41', 'Saját tőke', '2', '', '0'),
('42', 'Céltartalékok', '2', '', '0'),
('43', 'Hátrasorolt kötelezettségek', '2', '', '0'),
('44', 'Hosszú lejáratú kötelezettségek', '2', '', '0'),
('442', 'Hosszú lejáratra kapott kölcsönök', '2', '44', '0'),
('443', 'Beruházási fejlesztési hitelek', '2', '44', '0'),
('444', 'Egyéb hosszú lejáratú hitelek', '2', '44', '0'),
('446', 'Tartós kötelezettség kapcsolt vállalkozással szemben', '2', '44', '0'),
('447', 'Tartós kötelezettség egyéb vállalkozással szemben', '2', '44', '0'),
('449', 'Egyéb hosszú lejáratú kötelezettség', '2', '44', '0'),
('45', 'Rövid lejáratú kötelezettségek', '2', '', '0'),
('451', 'Vevőktől kapott előlegek', '2', '45', '0'),
('452', 'Rövid lejáratú kölcsönök', '2', '45', '0'),
('453', 'Rövid lejáratú hitelek', '2', '45', '0'),
('454', 'Kötelezettségek áruszállításból és szolgáltatás ny', '2', '45', '0'),
('455', 'Pénzügyi lízing miatti kötelezettség', '2', '45', '0'),
('456', 'Rövid lejáratú kötelezettség kapcsolt vállalkozással ', '2', '45', '0'),
('457', 'Rövid lejáratú kötelezettség egyéb vállakozással sze', '2', '45', '0'),
('459', 'Egyéb rövid lejáratú kötelezettség', '2', '45', '0'),
('46', 'Adóhatósággal szembeni kötelezettségek', '2', '', '0'),
('461', 'Társasági adó elszámolása', '2', '46', '0'),
('462', 'SZJA elszámolás', '2', '46', '0'),
('463', 'Költségvetési befizetési kötelezettség', '2', '46', '0'),
('464', 'Költségvetési befizetési kötelezettség teljesitése', '2', '46', '0'),
('465', 'VPOP elszámolási számla', '2', '46', '0'),
('466', 'Előzetesen felszámítottt ÁFA', '2', '46', '0'),
('467', 'Fizetendő ÁFA', '2', '46', '0'),
('469', 'Helyi adók elszámolási számla', '2', '46', '0'),
('47', 'Egyéb kötelezettségek', '2', '', '0'),
('471', 'Jövedelem elszámolási számla', '2', '47', '0'),
('472', 'Fel nem vett járandóság', '2', '47', '0'),
('473', 'Nyugdíj- és egészségbiztosítás', '2', '47', '0'),
('4731', 'Nyugdíjbiztosítási Alap', '2', '473', '0'),
('4732', 'Egészségbiztosítási Alap', '2', '473', '0'),
('4733', 'Magánnyugdíjpénztár', '2', '473', '0'),
('478', 'Osztalékelszámolási számla', '2', '47', '0'),
('479', 'Egyéb rövid lejáratú kötelezettség', '2', '47', '0'),
('48', 'Passzív időbeli elhatárolások', '2', '', '0'),
('49', 'Évi mérlegszámlák', '2', '', '0'),
('51', 'Anyagjellegű költségek', '4', '', '0'),
('52', 'Igénybevett szolgáltatások költségei', '4', '', '0'),
('521', 'Szállítási, rakodási költség', '4', '52', '0'),
('522', 'Bérleti díjak', '4', '52', '0'),
('524', 'Utazási és szállás költség', '4', '52', '0'),
('525', 'Hirdetés és reklám költség', '4', '52', '0'),
('526', 'Oktatás, továbbképzés költsége', '4', '52', '0'),
('527', 'Posta költség', '4', '52', '0'),
('528', 'Kommunikációs költségek', '4', '52', '0'),
('529', 'Egyéb igénybevett szolgáltatások', '4', '52', '0'),
('53', 'Egyéb szolgáltatások költségei', '4', '', '0'),
('531', 'Hatósági, igazgatási, szolg. illeték', '4', '53', '0'),
('532', 'Bankköltség', '4', '53', '0'),
('533', 'Biztosítási díjak', '4', '53', '0'),
('539', 'Egyéb szolgáltatások ', '4', '53', '0'),
('54', 'Bérköltség', '4', '', '0'),
('55', 'Személyi jellegű egyéb kifizetés', '4', '', '0'),
('56', 'Bérjárulékok', '4', '', '0'),
('561', 'Nyugdíj és egészségbiztosítás', '4', '56', '0'),
('562', 'EHO', '4', '56', '0'),
('57', 'Értékcsökkenési leirás', '4', '', '0'),
('81', 'Anyagjellegű ráforditások', '4', '', '0'),
('86', 'Egyéb ráforditások', '4', '', '0'),
('861', 'Értékesitett eszközök nyilvántartási értéke', '4', '86', '0'),
('863', 'Egyéb eredményt csökkentő tételek', '4', '86', '0'),
('864', 'Céltartalék képzése', '4', '86', '0'),
('865', 'Értékvesztés, terven felüli értékcsökkenés', '4', '86', '0'),
('866', 'Önkormányzatokkal elszámolt adók, illetékek', '4', '86', '0'),
('868', 'Állami költségvetéssel elszámolt adók', '4', '86', '0'),
('869', 'Különféle egyéb ráforditások', '4', '86', '0'),
('87', 'Pénzügyi műveletek ráforditásai', '4', '', '0'),
('874', 'Fizetendő kamatok és kamatjellegű ráforditások', '4', '87', '0'),
('876', 'Átváltáskori és értékesitéskori árfolyamveszteségek', '4', '87', '0'),
('879', 'Egyéb pénzügyi ráforditások', '4', '87', '0'),
('88', 'Rendkivüli ráforditások', '4', '', '0'),
('881', 'Térités nélkül átadott eszközök nyilvántartási ért', '4', '88', '0'),
('89', 'Nyereséget terhelő adók', '4', '', '0'),
('91', 'Értékesités árbevétele', '3', '', '0'),
('911', 'Belföldi értékesités árbevétele', '3', '91', '0'),
('93', 'Export értékesités árbevétele', '3', '', '0'),
('931', 'Export értékesités árbevétele', '3', '93', '0'),
('96', 'Egyéb bevételek', '3', '', '0'),
('961', 'Értékesitett eszközök bevétele', '3', '96', '0'),
('963', 'Egyéb eredményt növelő tételek', '3', '96', '0'),
('964', 'Céltartalék képzése', '3', '96', '0'),
('965', '', '3', '96', '0'),
('969', 'Különféle egyéb bevételek', '3', '96', '0'),
('97', 'Pénzügyi bevételek', '3', '', '0'),
('974', 'Kapott kamatok és kamatjellegű ráforditások', '3', '97', '0'),
('976', 'Átváltáskori és értékesitéskori árfolyamnyereség', '3', '97', '0'),
('979', 'Egyéb pénzügyi bevételek', '3', '97', '0'),
('98', 'Rendkivüli bevételek', '3', '', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'customer', 'general', '1'),
('2', '2', 'customer', 'general', '2'),
('3', '3', 'cust_branch', 'general', '1'),
('4', '4', 'cust_branch', 'general', '2'),
('5', '5', 'cust_branch', 'general', '3'),
('6', '6', 'supplier', 'general', '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 ;

### Data of table `0_crm_persons` ###

INSERT INTO `0_crm_persons` VALUES
('1', 'Kiss Anna', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('2', 'Kis Virág', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('3', 'Kis Virág', 'Main Branch', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('4', 'Kis Virág', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0'),
('5', 'Kiss Anna', 'Main Branch', NULL, 'Budapest 1042', NULL, NULL, NULL, NULL, NULL, '', '0'),
('6', 'Adoniss', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '0');

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
('Hungarian Forint', 'HUF', 'Ft', 'Magyarország', 'fillér', '0', '1'),
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
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_cust_branch` ###

INSERT INTO `0_cust_branch` VALUES
('1', '2', 'Kis Virág', '', '1', '1', 'DEF', '2', '9111', '9111', '3111', '9111', '1', '', '0', NULL, NULL, '0', 'Kis Virág'),
('2', '2', 'Kis Virág', '', '1', '1', 'DEF', '3', '9111', '9111', '3111', '9111', '1', '', '0', NULL, NULL, '0', 'Kis Virág'),
('3', '1', 'Kiss Anna', 'Budapest 1042', '1', '1', 'DEF', '3', '', '9111', '3111', '9111', '1', 'Budapest 1042', '0', NULL, NULL, '0', 'Kiss Anna');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_debtors_master` ###

INSERT INTO `0_debtors_master` VALUES
('1', 'Kiss Anna', 'Budapest 1042', '', 'HUF', '1', '0', '0', '1', '4', '0', '0', '1000', NULL, '0', 'Kiss Anna'),
('2', 'Kis Virág', NULL, '', 'HUF', '1', '0', '0', '1', '4', '0', '0', '1000', NULL, '0', 'Kis Virág');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_item_codes` ###

INSERT INTO `0_item_codes` VALUES
('1', '1', '1', 'Kék papír', '1', '1', '0', '0');

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
('3', '1'),
('4', '1'),
('5', '1');

### Structure of table `0_item_tax_types` ###

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `exempt` tinyint(1) NOT NULL DEFAULT '0',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 ;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('1', 'Fizetendő áfamentes 0%', '1', '0'),
('2', 'Előzetesen felszámított EU 20%', '0', '0'),
('3', 'Előzetesen felszámított 20%', '0', '0'),
('4', 'Fizetendő 20%', '0', '0'),
('5', 'Előzetesen felszámított BFOR20', '0', '0');

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
('db/pc', 'darab', '0', '0'),
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

INSERT INTO `0_loc_stock` VALUES
('DEF', '1', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_prices` ###

INSERT INTO `0_prices` VALUES
('1', '1', '1', 'HUF', '0'),
('2', '1', '1', 'EUR', '0');

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
('1', 'Components', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0'),
('2', 'Charges', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0'),
('3', 'Systems', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0'),
('4', 'Services', '0', '1', 'each', 'B', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0');

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
('1', '1', '3', 'Kék papír', '', 'ea.', 'M', '9111', '8140', '2690', '2690', '2690', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'S', '0', '0', '0000-00-00', '0000-00-00', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_suppliers` ###

INSERT INTO `0_suppliers` VALUES
('1', 'Adoniss', '', '', '', '', '', '', '', 'HUF', '4', '0', '0', '0', '2', '0', '8140', '4541', '8140', '', '0', 'Adoniss');

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
('creditors_act', 'glsetup.purchase', 'varchar', '15', '4541'),
('curr_default', 'setup.company', 'char', '3', 'HUF'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '3111'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '2690'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '8140'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '9111'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '2690'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '9111'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', '6', '30'),
('default_receival_required', 'glsetup.purchase', 'smallint', '6', '10'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '9111'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '9111'),
('default_wip_act', 'glsetup.items', 'varchar', '15', '2690'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', ''),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('domicile', 'setup.company', 'varchar', '55', ''),
('email', 'setup.company', 'varchar', '100', ''),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '9111'),
('f_year', 'setup.company', 'int', '11', '1'),
('fax', 'setup.company', 'varchar', '30', ''),
('freight_act', 'glsetup.customer', 'varchar', '15', '8140'),
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
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '8140'),
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
('2', '1', '0'),
('3', '1', '0');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('2', 'Előzetesen felszámított 20%', '0'),
('3', 'Fizetendő 20%', '0');

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
('1', '20', '4661', '4671', 'VAT', '0'),
('2', '5', '4662', '4667', 'VAT', '0'),
('3', '0', '4663', '4673', 'VAT', '0');

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
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'info@startit.hu', 'hu_HU', '2', '2', '0', '0', 'default', 'A4', '2', '2', '6', '1', '1', '1', '1', '2009-06-27 14:27:12', '10', '1', '1', '', '1', '0', 'orders', '30', '0', '1', '0', '0', '0');

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
