# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 17:03
# Built by FrontAccounting 2.4.RC1
# http://frontaccounting.com
# Company: Training Co.
# User: 

# Compatibility: 2.4.1


SET NAMES latin2;


### Structure of table `0_areas` ###

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
  `area_code` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`area_code`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_areas` ###

INSERT INTO `0_areas` VALUES
('1', 'DE', '0'),
('2', 'SI', '0'),
('3', 'BL', '0');

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
  KEY `account_code` (`account_code`),
  KEY `account_code_2` (`account_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

### Data of table `0_bank_accounts` ###

INSERT INTO `0_bank_accounts` VALUES
('110', '0', 'Delavska Hranilnica', 'SI56 6100 0000 8754 209', 'Delavska hranilnica d. d. Ljubljana', 'Delavska hranilnica d. d. Ljubljana\nMiklo�i�eva 5\n1000 Ljubljana', 'EUR', '1', '1', '415', '2014-12-31 00:00:00', '-362.91', '0');

### Structure of table `0_bank_trans` ###

DROP TABLE IF EXISTS `0_bank_trans`;

CREATE TABLE `0_bank_trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) DEFAULT NULL,
  `trans_no` int(11) DEFAULT NULL,
  `bank_act` varchar(15) NOT NULL DEFAULT '',
  `ref` varchar(40) DEFAULT NULL,
  `trans_date` date NOT NULL DEFAULT '0000-00-00',
  `bank_trans_type_id` int(10) unsigned DEFAULT NULL,
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
  KEY `bank_act_3` (`bank_act`,`trans_date`),
  KEY `bank_act_4` (`bank_act`,`reconciled`),
  KEY `bank_act_5` (`bank_act`,`trans_date`)
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
('1', 'Sredstva', '1', '0'),
('2', 'Obveznost do virov sredstev', '2', '0'),
('3', 'Prihodki', '4', '0'),
('4', 'Poslovni izid', '5', '0'),
('5', 'Kapital', '3', '0'),
('6', 'Odhodki', '6', '0');

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
('002', 'NS', 'Odlo�eni stro�ki razvijanja', '00', '0'),
('003', 'NS', 'Premo�enjske pravice', '00', '0'),
('005', 'NS', 'Druga NS', '00', '0'),
('007', 'DA�R', 'DA�R', '00', '0'),
('008', 'NS', 'Popravek vrednosti neopredmetenih sredstev zaradi amortizira', '00', '0'),
('009', 'NS', 'Oslabitev vrednosti neopredmetenih sredstev', '00', '0'),
('010', 'NN', 'NN, vrednotene po modelu nabavne vrednosti', '01', '0'),
('011', 'NN', 'NN, vrednotene po modelu po�tene vrednosti', '01', '0'),
('015', 'NN', 'Popravek vrednosti nalo�benih nepremi?nin zaradi amortiziran', '01', '0'),
('019', 'NN', 'Oslabitev vrednosti nalo�benih nepremi?nin', '01', '0'),
('020', '', 'Zemlji��a, vrednotena po modelu nabavne vrednosti', '02', '0'),
('021', 'OOS', 'Zgradbe, vrednotene po modelu nabavne vrednosti', '02', '0'),
('022', 'OOS', 'Zemlji��a, vrednotena po modelu prevrednotenja', '02', '0'),
('023', 'OOS', 'Zgradbe, vrednotene po modelu prevrednotenja', '02', '0'),
('027', 'OOS', 'Nepremi�nine v gradnji oziroma izdelavi', '02', '0'),
('031', 'OOS', 'Oslabitev vrednosti zemlji��', '03', '0'),
('035', 'OOS', 'Popravek vrednosti zgradb zaradi amortiziranja', '03', '0'),
('039', 'OOS', 'Oslabitev vrednosti zgradb', '03', '0'),
('040', 'OOS', 'Oprema in nadomestni deli, vrednoteni po modelu nabavne vred', '04', '0'),
('041', 'OOS', 'Drobni inventar', '04', '0'),
('042', 'OOS', 'Oprema in nadomestni deli, vrednoteni po modelu prevrednoten', '04', '0'),
('043', 'OOS', 'Biolo?ka sredstva', '04', '0'),
('044', 'OOS', 'Vlaganja v OOS v tuji lasti', '04', '0'),
('045', 'OOS', 'Druga OOS', '04', '0'),
('047', 'OOS', 'Oprema in druga OOS v gradnji oziroma izdelavi', '04', '0'),
('050', 'OOS', 'Popravek vrednosti opreme in nadomestnih delov zaradi amorti', '05', '0'),
('051', 'OOS', 'Popravek vrednosti drobnega inventarja zaradi amortiziranja', '05', '0'),
('052', 'OOS', 'Oslabitev vrednosti opreme in nadomestnih delov', '05', '0'),
('053', 'OOS', 'Popravek vrednosti biolo�kih sredstev', '05', '0'),
('054', 'OOS', 'Popravek vrednosti vlaganj v OOS v tuji lasti', '05', '0'),
('055', 'OOS', 'Popravek vrednosti drugih opredmetenih osnovnih sredstev zar', '05', '0'),
('059', 'OOS', 'Oslabitev vrednosti drugih opredmetenih osnovnih sredstev', '05', '0'),
('060', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e dru�b', '06', '0'),
('061', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e dru�b', '06', '0'),
('062', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e dru�b', '06', '0'),
('063', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e pridru�enih', '06', '0'),
('064', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e pridru�enih', '06', '0'),
('065', 'DFNRP', 'Dolgoro�ne finan�ne nalo�be v delnice in dele�e pridru�enih ', '06', '0'),
('069', 'DFNRP', 'Oslabitev vrednosti dolgoro�nih finan�nih nalo�b', '06', '0'),
('070', 'DP', 'DP, dana na podlagi posojilnih pogodb', '07', '0'),
('071', 'DP', 'DP, dana z odkupom obveznic', '07', '0'),
('072', 'DP', 'Druga dolgoro�no vlo�ena sredstva', '07', '0'),
('073', 'DP', 'Dani dolgoro�ni   depoziti', '07', '0'),
('075', 'DP', 'Dolgoro?ne terjatve iz finan�nega najema', '07', '0'),
('079', 'DP', 'Oslabitev vrednosti danih dolgoro�no posojil', '07', '0'),
('080', 'DPT', 'dolgoro�ni   blagovni krediti, dani v dr�avi', '08', '0'),
('081', 'DPT', 'dolgoro�ni   blagovni krediti, dani v tujini', '08', '0'),
('082', 'DPT', 'Dani dolgoro�ni   potro�ni�ki krediti', '08', '0'),
('083', 'DPT', 'Dani dolgoro�ni   predujmi', '08', '0'),
('084', 'DPT', 'Dane dolgoro�ne var��ine', '08', '0'),
('086', 'DPT', 'Druge DPT', '08', '0'),
('089', 'DPT', 'Oslabitev vrednosti dolgoro�nih poslovnih terjatev', '08', '0'),
('090', 'TDP', 'Terjatve za odlo�eni davek iz odbitnih za�asnih razlik', '09', '0'),
('100', 'DS', 'DS v blagajni, razen deviznih sredstev', '10', '0'),
('101', 'DS', 'Devizna sredstva v blagajni', '10', '0'),
('102', 'DS', 'Izdani �eki (odbitna postavka)', '10', '0'),
('103', 'DS', 'Prejeti �eki', '10', '0'),
('104', 'DS', 'Netvegani takoj udenarljivi dol�ni�ki vrednostni papirji', '10', '0'),
('109', 'DS', 'Denar na poti', '10', '0'),
('110', 'DS', 'DS na ra�unih, razen deviznih', '11', '0'),
('111', 'DS', 'Kratkoro�ni depoziti oziroma depoziti na odpoklic, razen dev', '11', '0'),
('112', 'DS', 'Devizna sredstva na ra�unih', '11', '0'),
('113', 'DS', 'Kratkoro�ni devizni depoziti oziroma devizni depozit na odpo', '11', '0'),
('114', 'DS', 'DS na posebnih ra�unih oziroma za posebne namene', '11', '0'),
('120', 'KPT', 'Kratkoro�ne terjatve do kupcev v dr�avi', '12', '0'),
('121', 'KPT', 'Kratkoro�ne terjatve do kupcev v tujini', '12', '0'),
('122', 'KPT', 'Kratkoro�ni blagovni krediti, dani kupcem v dr�avi', '12', '0'),
('123', 'KPT', 'Kratkoro�ni blagovni krediti, dani kupcem v tujini', '12', '0'),
('124', 'KPT', 'Kratkoro�ni potro�ni�ki krediti, dani kupcem v dr�avi', '12', '0'),
('129', 'KPT', 'Oslabitev vrednosti kratkoro�nih terjatev do kupcev', '12', '0'),
('130', 'OOS', 'Kratkoro�ni predujmi, dani za OOS', '13', '0'),
('131', 'OOS', 'Kratkoro�ni predujmi, dani za NS', '13', '0'),
('132', 'OOS', 'Kratkoro�ni predujmi, dani za ZLG materiala in blaga', '13', '0'),
('133', 'OOS', 'Drugi dani kratkoro�ni predujmi in prepla�ila', '13', '0'),
('134', 'OOS', 'Dane kratkoro�ne var��ine', '13', '0'),
('139', 'OOS', 'Oslabitev vrednosti danih kratkoro�nih predujmov', '13', '0'),
('140', 'KPT', 'Kratkoro�ne terjatve do izvoznikov', '14', '0'),
('141', 'KPT', 'Kratkoro�ne terjatve iz uvoza za tuj ra�un', '14', '0'),
('142', 'KPT', 'Kratkoro�ne terjatve iz komisijske in konsignacijske ', '14', '0'),
('145', 'KPT', 'Druge kratkoro�ne terjatve iz poslovanja za tuj ra�un', '15', '0'),
('149', 'KPT', 'Oslabitev vrednosti kratkoro�nih terjatev iz poslovanja ', '14', '0'),
('150', 'KPT', 'Kratkoro�ne terjatve za obresti', '15', '0'),
('151', 'KPT', 'Kratkoro�ne terjatve za dividende', '15', '0'),
('152', 'KPT', 'Kratkoro�ne terjatve za druge dele�e v dobi�ku', '15', '0'),
('155', 'KPT', 'Druge kratkoro�ne terjatve, povezane s  finan�nimi prihodki', '15', '0'),
('159', 'KPT', 'Oslabitev vrednosti kratkoro�nih terjatev, povezanih', '15', '0'),
('160', 'KPT', 'Kratkoro�ne terjatve za odbitni DDV', '16', '0'),
('161', 'KPT', 'Kratkoro�ne terjatve za davek od dohodka, dose�enega ', '16', '0'),
('162', 'KPT', 'Druge Kratkoro�ne terjatve do dr�avnih in drugih in�titucij', '16', '0'),
('165', 'KPT', 'Ostale Kratkoro�ne terjatve', '16', '0'),
('166', 'KPT', 'Kratkoro�ne terjatve za DDV, vrnjen tujcem', '16', '0'),
('167', 'KPT', 'Kratkoro�ne terjatve za DDV, pla?an v tujini', '16', '0'),
('169', 'KPT', 'Oslabitev vrednosti drugih kratkoro�nih terjatev', '16', '0'),
('170', 'KFNRP', 'Kratkoro�ne finan�ne nalo�be v delnice in dele�e podjetij', '17', '0'),
('171', 'KFNRP', 'Kratkoro�ne finan�ne nalo�be v delnice in dele�e podjetij', '17', '0'),
('172', 'KFNRP', 'Kratkoro�ne finan�ne nalo�be v delnice in dele�e podjetij', '17', '0'),
('173', 'KFNRP', 'Druge Kratkoro�ne finan�ne nalo�be, razporejene ', '17', '0'),
('174', 'KFNRP', 'Druge Kratkoro�ne finan�ne nalo�be, razporejene', '17', '0'),
('175', 'KFNRP', 'Druge Kratkoro�ne finan�ne nalo�be, razporejene', '17', '0'),
('179', 'KFNRP', 'Oslabitev vrednosti kratkoro�nih finan�nih nalo�b', '17', '0'),
('180', 'KP', 'KP, dana na podlagi posojilnih pogodb', '18', '0'),
('181', 'KP', 'Kratkoro�ni depoziti v bankah in drugih finan�nih organizaci', '18', '0'),
('182', 'KP', 'Prejete menice', '18', '0'),
('189', 'KP', 'Oslabitev vrednosti kratkoro�nih posojil', '18', '0'),
('190', 'KA�R', 'Kratkoro�no odlo�eni stro�ki oziroma odhodki', '19', '0'),
('191', 'KA�R', 'Kratkoro�no nezara�unani prihodki', '19', '0'),
('192', 'KA?R', 'Vrednotnice', '19', '0'),
('195', 'KA?R', 'DDV od prejetih predujmov', '19', '0'),
('210', 'OVSO', 'Obveznosti, vklju�ene v skupine za odtujitev', '21', '0'),
('220', 'KPO', 'Kratkoro�ne obveznosti (dolgovi) do dobaviteljev v dr�avi', '22', '0'),
('221', 'KPO', 'Kratkoro�ne obveznosti (dolgovi) do dobaviteljev v tujini', '22', '0'),
('222', 'KPO', 'Kratkoro�ni blagovni krediti, prejeti v dr�avi', '22', '0'),
('223', 'KPO', 'Kratkoro�ni blagovni krediti, prejeti v tujini', '22', '0'),
('224', 'KPO', 'Kratkoro�ne obveznosti (dolgovi) za nezara�unane blago', '22', '0'),
('230', 'KPO', 'Prejeti Kratkoro�ni predujmi', '23', '0'),
('231', 'KPO', 'Prejete Kratkoro�ne var��ine', '23', '0'),
('240', 'KPO', 'Kratkoro�ne obveznosti iz izvoza za tuj ra�un', '24', '0'),
('241', 'KPO', 'Kratkoro�ne obveznosti do uvoznikov', '24', '0'),
('242', 'KPO', 'Kratkoro�ne obveznosti iz komisijske in konsignacijske proda', '24', '0'),
('245', 'KPO', 'Druge Kratkoro�ne obveznosti iz poslovanja za tuj ra�un', '24', '0'),
('250', 'KPO', 'Kratkoro�ne obveznosti za vra�unane in neobra�unane', '25', '0'),
('251', 'KPO', 'Kratkoro�ne obveznosti za �iste pla�e in nadomestila pla', '25', '0'),
('253', 'KPO', 'Kratkoro�ne obveznosti za prispevke iz kosmatih pla� in nado', '25', '0'),
('254', 'KPO', 'Kratkoro�ne obveznosti za davke iz kosmatih pla� in nadomest', '25', '0'),
('255', 'KPO', 'Kratkoro�ne obveznosti za druge prejemke iz delovnega razmer', '25', '0'),
('256', 'KPO', 'Kratkoro�ne obveznosti za prispevke iz drugih prejemkov', '25', '0'),
('257', 'KPO', 'Kratkoro�ne obveznosti za davek iz drugih prejemkov iz delov', '25', '0'),
('260', 'KPO', 'Obveznosti za obra�unani DDV', '26', '0'),
('261', 'KPO', 'Obveznosti za DDV, carino in druge dajatve od uvo�enega blag', '26', '0'),
('262', 'KPO', 'Obveznosti za prispevke izpla�evalca', '26', '0'),
('263', 'KPO', 'Obveznosti za davek od izpla�anih pla', '26', '0'),
('264', 'KPO', 'Obveznosti za davek od dohodka, dose�enega z opravljanjem de', '26', '0'),
('265', 'KPO', 'Obveznosti za dav�ni odtegljaj', '26', '0'),
('266', 'KPO', 'Druge Kratkoro�ne obveznosti do dr�avnih in drugih', '26', '0'),
('270', 'KFO', 'KP, dobljena pri podjetjih v dr�avi', '27', '0'),
('271', 'KFO', 'KP, dobljena pri podjetjih v tujini', '27', '0'),
('272', 'KFO', 'KP, dobljena pri bankah v dr�avi', '27', '0'),
('273', 'KFO', 'KP, dobljena pri bankah v tujini', '27', '0'),
('274', 'KFO', 'KFO v zvezi z obveznicami', '27', '0'),
('275', 'KFO', 'KFO do fizi�nih oseb', '27', '0'),
('279', 'KFO', 'Druge KFO', '27', '0'),
('280', 'KPO', 'Kratkoro�ne obveznosti za obresti', '28', '0'),
('281', 'KPO', 'Kratkoro�ne obveznosti v zvezi z odtegljaji od pla�', '28', '0'),
('282', 'KPO', 'Kratkoro�ne obveznosti za prispevke za socialno varnost podj', '28', '0'),
('283', 'KPO', 'Kratkoro�ne meni�ne obveznosti', '28', '0'),
('285', 'KPO', 'Ostale KPO', '28', '0'),
('290', 'KP?R', 'Vnaprej vra�unani stro�ki oziroma odhodki', '29', '0'),
('291', 'KP?R', 'Kratkoro�no odlo�eni prihodki', '29', '0'),
('295', 'KP?R', 'DDV od danih predujmov', '29', '0'),
('300', 'ZLG', 'Vrednost surovin in materiala po obra�unih dobaviteljev', '30', '0'),
('301', 'ZLG', 'Odvisni stro�ki nabave surovin in materiala', '30', '0'),
('302', 'ZLG', 'Carina in druge uvozne dav��ine od surovin in materiala', '30', '0'),
('303', 'ZLG', 'DDV in druge dav��ine od surovin in materiala', '30', '0'),
('309', 'ZLG', 'Obra�un nabave surovin in materiala', '30', '0'),
('310', 'ZLG', 'ZLG surovin in materiala v skladi��', '31', '0'),
('312', 'ZLG', 'ZLG surovin in materiala na poti', '31', '0'),
('316', 'ZLG', 'ZLG surovin in materiala v dodelavi in predelavi', '31', '0'),
('319', 'ZLG', 'Odmiki od cen zalog surovin in materiala', '31', '0'),
('320', 'ZLG', 'ZLG drobnega inventarja in embala�e v skladi��u', '32', '0'),
('321', 'ZLG', 'ZLG drobnega inventarja in embala�e, dane v uporabo', '32', '0'),
('329', 'ZLG', 'Odmiki od cen drobnega inventarja in embala�e', '32', '0'),
('400', 'NVPM', 'stro�ki materiala', '40', '0'),
('401', 'NVPM', 'stro�ki pomo�nega materiala', '40', '0'),
('402', 'NVPM', 'stro�ki energije', '40', '0'),
('403', 'NVPM', 'stro�ki nadomestnih delov za osnovna sredstva in materiala z', '40', '0'),
('404', 'NVPM', 'Odpis drobnega inventarja in embala�e', '40', '0'),
('405', 'NVPM', 'Uskladitev stro�kov materiala in drobnega inventarja zaradi ', '40', '0'),
('406', 'NVPM', 'stro�ki pisarni�kega materiala in strokovne literature', '40', '0'),
('407', 'NVPM', 'Drugi stro�ki materiala', '40', '0'),
('410', 'SS', 'SS pri ustvarjanju proizvodov in opravljanju storitev', '41', '0'),
('411', 'SS', 'stro�ki transportnih storitev', '41', '0'),
('412', 'SS', 'SS v zvezi z vzdr�evanjem', '41', '0'),
('413', 'SS', 'Najemnine', '41', '0'),
('414', 'SS', 'Povra�ila stro�kov zaposlencem v zvezi z delom', '41', '0'),
('415', 'SS', 'STP-pla�ilnega prometa, stro�ki ban�nih storitev,  ', '41', '0'),
('416', 'SS', 'stro�ki intelektualnih in osebnih storitev', '41', '0'),
('417', 'SS', 'stro�ki sejmov, reklame in reprezentance', '41', '0'),
('418', 'SS', 'SS fizi�nih oseb, ki ne opravljajo dejavnosti, skupaj z daja', '41', '0'),
('419', 'SS', 'stro�ki drugih storitev', '41', '0'),
('430', 'AMOR', 'AMOR neopredmetenih sredstev', '43', '0'),
('431', 'AMOR', 'AMOR zgradb', '43', '0'),
('432', 'AMOR', 'AMOR opreme in nadomestnih delov', '43', '0'),
('433', 'AMOR', 'AMOR drobnega inventarja', '43', '0'),
('434', 'AMOR', 'AMOR drugih opredmetenih osnovnih sredstev', '43', '0'),
('435', 'AMOR', 'AMOR nalo�benih nepremi�nin', '43', '0'),
('440', 'DPO', 'REZ za stro�ke reorganizacije podjetja', '44', '0'),
('441', 'DPO', 'REZ za dana jamstva', '44', '0'),
('442', 'DPO', 'REZ za ko�ljive pogodbe', '44', '0'),
('443', 'DPO', 'REZ za pokojnine, jubilejne nagrade in odpravnine ob upokoji', '44', '0'),
('449', 'DPO', 'REZ za pokrivanje drugih obveznosti iz preteklega poslovanja', '44', '0'),
('450', '', 'stro�ki obresti', '45', '0'),
('470', 'STP', 'Pla�e zaposlencev', '47', '0'),
('471', 'STP', 'Nadomestila pla� zaposlencev', '47', '0'),
('472', 'STPZ', 'stro�ki dodatnega pokojninskega zavarovanja zaposlencev', '47', '0'),
('473', 'DSTD', 'Regres za letni dopust, bonitete, povra�ila (za prevoz na de', '47', '0'),
('474', 'STPZ', 'Delodajal�evi prispevki od pla�, nadomestil pla�, bonitet', '47', '0'),
('475', 'DSTD', 'Druge delodajal�eve dajatve od pla�, nadomestil pla�, bonite', '47', '0'),
('476', 'DSTD', 'Nagrade vajencem skupaj z dajatvami, ki bremenijo podjetje', '47', '0'),
('480', 'DPO', 'Dajatve, ki niso odvisne od stro�kov dela ali drugih vrst st', '48', '0'),
('481', 'DPO', 'Izdatki za varstvo okolja', '48', '0'),
('482', 'DPO', 'Nagrade dijakom in �tudentom na delovni praksi skupaj ', '48', '0'),
('483', 'DPO', '�tipendije dijakom in �tudentom', '48', '0'),
('484', 'DPO', 'Prispevki za socialno varnost podjetnika', '48', '0'),
('485', 'DPO', 'Povra�ila stro�kov podjetnika', '48', '0'),
('489', 'DPO', 'Ostali stro�ki', '48', '0'),
('490', '', 'Prenos stro�kov v ZLG', '49', '0'),
('491', '', 'Prenos stro�kov neposredno v odhodke', '49', '0'),
('5', '', 'Uporaba tega razreda je prosta.', '5', '0'),
('600', 'ZLG', 'Nedokon�ana proizvodnja', '60', '0'),
('601', 'ZLG', 'Nedokon�ane storitve', '60', '0'),
('602', 'ZLG', 'Polizdelki', '60', '0'),
('604', 'ZLG', 'Proizvodnja v dodelavi in predelavi', '60', '0'),
('609', 'ZLG', 'Odmiki od cen nedokon?ane proizvodnje in storitev', '60', '0'),
('630', 'ZLG', 'Proizvodi v lastnem skladi��u', '63', '0'),
('631', 'ZLG', 'Proizvodi v tujem skladi��u', '63', '0'),
('632', 'ZLG', 'Proizvodi na poti', '63', '0'),
('633', 'ZLG', 'Proizvodi v lastni prodajalni', '63', '0'),
('634', 'ZLG', 'Vra�unani DDV od proizvodov v prodajalni', '63', '0'),
('635', 'ZLG', 'Proizvodi v dodelavi in predelavi', '63', '0'),
('639', 'ZLG', 'Odmiki od cen proizvodov', '63', '0'),
('650', 'ZLG', 'Vrednost blaga po obra�unih dobaviteljev', '65', '0'),
('651', 'ZLG', 'Odvisni stro�ki nabave blaga', '65', '0'),
('652', 'ZLG', 'Carina in druge uvozne dav��ine od blaga', '65', '0'),
('653', 'ZLG', 'DDV in druge dav��ine od blaga', '65', '0'),
('659', 'ZLG', 'Obra�un nabave blaga', '65', '0'),
('660', 'ZLG', 'Blago v lastnem skladi��u', '66', '0'),
('661', 'ZLG', 'Blago v tujem skladi��u', '66', '0'),
('662', 'ZLG', 'Blago na poti', '66', '0'),
('663', 'ZLG', 'Blago v prodajalni', '66', '0'),
('664', 'ZLG', 'DDV, vra�unan v zalogah blaga', '66', '0'),
('669', 'ZLG', 'Vra�unana razlika v cenah zalog blaga', '66', '0'),
('670', '', 'OOS, namenjena prodaji', '67', '0'),
('671', '', 'NN, vrednotene po modelu nabavne vrednosti, namenjene prodaj', '67', '0'),
('672', '', 'Druga nekratkoro�na sredstva, namenjena prodaji', '67', '0'),
('673', '', 'Sredstva dela denar ustvarjajo�e enote, namenjena prodaji', '67', '0'),
('674', '', 'Sredstva denar ustvarjajo�e enote, namenjena prodaji', '67', '0'),
('700', '', 'Vrednost prodanih poslovnih u�inkov', '70', '0'),
('701', '', 'Vrednost usredstvenih lastnih proizvodov in storitev', '70', '0'),
('702', '', 'Nabavna vrednost prodanih materiala in blaga', '70', '0'),
('703', '', 'Drugi poslovni odhodki', '70', '0'),
('710', 'NVPM', 'Nabavna vrednost prodanega materiala', '71', '0'),
('711', 'NVPM', 'Nabavna vrednost prodanega blaga', '71', '0'),
('720', 'PPONS', 'Prevrednotovalni poslovni odhodki v zvezi z neopredmetenimi ', '72', '0'),
('721', 'PPOOS', 'Prevrednotovalni poslovni odhodki v zvezi z zalogami', '72', '0'),
('722', 'PPONS', 'PPO kot posle.prevr.zaradi oslab- v zvezi s poslovnimi terja', '72', '0'),
('723', 'PPONS', 'PPO kot posledica odpisov v zvezi s poslovnimi terjatvami', '72', '0'),
('724', 'PPONS', 'DPPO v zvezi s kratkoro�.sred., razen s finan�nimi nalo�bami', '72', '0'),
('725', 'PPONS', 'Prevrednotovalni poslovni odhodki v zvezi s stro�ki dela', '72', '0'),
('740', 'FOFO', 'Odhodki iz posojil', '74', '0'),
('741', 'FOFO', 'Odhodki iz drugih finan�nih obveznosti', '74', '0'),
('742', 'FOPO', 'Odhodki iz obveznosti do dobaviteljev in meni�nih obveznosti', '74', '0'),
('743', 'FOPO', 'Odhodki iz drugih poslovnih obveznosti', '74', '0'),
('747', 'FOOOFN', 'Odhodki iz sredstev, razporejenih po po�teni vrednosti prek ', '74', '0'),
('748', 'FOOOFN', 'Odhodki iz oslabitve finan�nih nalo�b', '74', '0'),
('749', 'FOOOFN', 'Odhodki iz odprave pripoznanja finan�nih nalo�b', '74', '0'),
('750', 'DO', 'Odhodki iz vrednotenja nalo�benih nepremi�nin po modelu po�t', '75', '0'),
('751', 'DO', 'Odhodki iz odtujitve nalo�benih nepremi�nin, izmerjenih', '75', '0'),
('752', 'DO', 'Denarne kazni, ki niso povezane s poslovnimi u�inki', '75', '0'),
('753', 'DO', 'Od�kodnine, ki niso povezane s poslovnimi u�inki', '75', '0'),
('754', 'DO', 'Donacije', '75', '0'),
('758', 'DO', 'Negativne evrske izravnave', '75', '0'),
('759', 'DO', 'Ostali odhodki', '75', '0'),
('760', '�PP', 'Prihodki od prodaje proizvodov in storitev na doma�em trgu', '76', '0'),
('761', '�PP', 'Prihodki od prodaje proizvodov in storitev na tujem trgu', '76', '0'),
('762', '�PP', 'Prihodki od prodaje trgovskega blaga in materiala na doma�em', '76', '0'),
('763', '�PP', 'Prihodki od prodaje trgovskega blaga in materiala na tujem t', '76', '0'),
('764', '�PP', 'Prihodki iz vrednotenja biolo�kih sredstev', '76', '0'),
('765', '�PP', 'Prihodki od najemnin', '76', '0'),
('766', 'DPP', 'Prihodki od odprave rezervacij', '76', '0'),
('768', 'DPP', 'DPH, povezani s poslovnimi u�inki (subvencije, dotacije, reg', '76', '0'),
('769', 'DPP', 'Prevrednotovalni poslovni prihodki', '76', '0'),
('770', 'FPD', 'FPD v podjetjih', '77', '0'),
('771', 'FPDP', 'FPDP (tudi od depozitov)', '77', '0'),
('772', 'FPDP', 'FPDP', '77', '0'),
('778', 'FPD', ' finan�ni prihodki iz finan�nih sredstev, razporejenih po po', '77', '0'),
('780', 'DPH', 'Prihodki iz vrednotenja nalo�benih nepremi�nin po po�teni vr', '78', '0'),
('781', 'DPH', 'Prihodki iz odtujitve nalo�benih nepremi�nin, izmerjenih po ', '78', '0'),
('784', 'DPH', 'Donacije', '78', '0'),
('785', 'DPH', 'Subvencije, dotacije in podobni prihodki, ki niso povezani s', '78', '0'),
('786', 'DPH', 'Od�kodnine, ki niso povezane s poslovnimi u�inki', '78', '0'),
('787', 'DPH', 'Kazni, ki niso povezane s poslovnimi u�inki', '78', '0'),
('788', 'DPH', 'Pozitivne evrske izravnave', '78', '0'),
('789', 'DPH', 'Ostali prihodki', '78', '0'),
('800', 'P-H', 'Prenos prihodkov in prenos odhodkov', '80', '0'),
('801', 'P-H', 'Ugotovitev in prenos podjetnikovega dohodka', '80', '0'),
('802', 'NPI', 'Ugotovitev in prenos negativnega poslovnega izida', '80', '0'),
('803', 'NPI', 'Ugotovitev in prenos negativnega poslovnega izida', '80', '0'),
('811', 'NPI', 'Davek od dohodka iz dejavnosti', '81', '0'),
('816', 'NPI', 'Prenos �istega dohodka', '81', '0'),
('829', 'NPI', 'Prenos neuporabljenega dela �istega dobi�ka oziroma', '82', '0'),
('900', 'PKP', 'Osnovni delni�ki kapital-delnice', '90', '0'),
('901', 'PKP', 'Osnovni kapital-kapitalski dele�i ali kapitalska vloga', '90', '0'),
('902', 'PKP', 'Za�etni kapital samostojnih podjetnikov posameznikov', '90', '0'),
('910', 'PKP', 'Prenosi vrednosti stvarnega premo�enja med opravljanjem deja', '91', '0'),
('918', 'PKP', 'Prenosi stvarnega premo�enja med opravljanjem dejavnosti', '91', '0'),
('919', 'PKP', 'Pritoki in odtoki denarnih sredstev', '91', '0'),
('920', 'PKP', 'Zakonske rezerve', '92', '0'),
('930', 'PKP', 'Podjetnikov dohodek', '93', '0'),
('931', 'PKP', 'Negativni poslovni izid', '93', '0'),
('932', 'PKP', 'Davek od dohodka, dose�enega z opravljanjem dejavnosti', '93', '0'),
('934', 'PKP', 'Prenos iz prese�ka iz prevrednotenja', '93', '0'),
('935', 'PKP', 'Dohodki samostojnih podjetnikov posameznikov', '95', '0'),
('950', 'PKP', 'Prese�ek iz prevrednotenja zemlji��', '95', '0'),
('951', 'PKP', 'Prese�ek iz prevrednotenja zgradb', '95', '0'),
('952', 'PKP', 'Prese�ek iz prevrednotenja opreme', '93', '0'),
('953', 'PKP', 'Prese�ek iz prevrednotenja neopredmetenih sredstev', '95', '0'),
('954', 'PKP', 'Prese�ek iz prevrednotenja dolgoro�nih finan�nih nalo�b', '95', '0'),
('955', 'PKP', 'Prese�ek iz prevrednotenja kratkoro�nih finan�nih nalo�b', '95', '0'),
('960', 'REZ', 'REZ za stro�ke reorganizacije podjetja', '96', '0'),
('961', 'REZ', 'REZ za pokrivanje prihodnjih stro�kov oziroma odhodkov zarad', '96', '0'),
('962', 'REZ', 'Rzervacije za ko�ljive pogodbe', '96', '0'),
('963', 'REZ', 'REZ za pokojnine, jubilejne nagrade in odpravnine ob upokoji', '96', '0'),
('964', 'REZ', 'REZ za dana jamstva', '96', '0'),
('965', 'REZ', 'Druge REZ iz naslova dolgoro�no vnaprej vra�unanih stro�kov', '96', '0'),
('966', 'DP�R', 'Prejete dr�avne podpore', '96', '0'),
('967', 'DP?R', 'Prejete donacije', '96', '0'),
('968', 'DP�R', 'Druge dolgoro�ne pasivne �asovne razmejitve', '96', '0'),
('970', 'DFO', 'DP, dobljena pri podjetjih v dr�avi', '97', '0'),
('971', 'DFO', 'DP, dobljena pri podjetjih v tujini', '97', '0'),
('972', 'DFO', 'DP, dobljena pri bankah v dr�avi', '97', '0'),
('973', 'DFO', 'DP, dobljena pri bankah v tujini', '97', '0'),
('974', 'DFO', 'DFO v zvezi z obveznicami', '97', '0'),
('975', 'DFO', 'dolgoro�ni   dolgovi iz finan�nega najema', '97', '0'),
('976', 'DFO', 'DFO do fizi�nih oseb', '97', '0'),
('979', 'DFO', 'Druge DFO', '97', '0'),
('980', 'DPO', 'Prejeti dolgoro�ni   predujmi', '98', '0'),
('981', 'DPO', 'Prejete dolgoro�ne var��ine', '98', '0'),
('982', 'DPO', 'dolgoro�ni   krediti, dobljeni od doma�ih dobaviteljev', '98', '0'),
('983', 'DPO', 'dolgoro�ni   krediti, dobljeni od tujih dobaviteljev', '98', '0'),
('985', 'DPO', 'Dolgoro�ne meni�ne obveznosti', '98', '0'),
('989', 'DPO', 'Druge DPO', '98', '0'),
('990', '', 'Najeta, izposojena in zakupljena (tuja) sredstva-AKTIVNI', '99', '0'),
('991', '', 'Menice in drugi vrednostni papirji, prejeti za zava.-AKTIVNI', '99', '0'),
('992', '', 'Blago, prejeto v komisijsko in konsignacijsko prod.-AKTIVNI', '99', '0'),
('993', '', 'Vrednotnice, izdane za obra�unavanje-AKTIVNI', '99', '0'),
('994', '', 'Drugi aktivni zunajbilan�ni konti-AKTIVNI', '99', '0'),
('995', '', 'Lastniki najetih, izposojenih in zakupljenih sred.-PASIVNI', '99', '0'),
('996', '', 'Dol�niki, ki so zavarovali pla�ila z menicami-PASIVNI', '99', '0'),
('997', '', 'Obveznosti iz blaga, prejetega v komisijsko-PASIVNI', '99', '0'),
('998', '', '998-Nominalna vrednost vrednotnic, izdanih za-PASIVNI', '99', '0'),
('999', '', 'Drugi pasivni zunajbilan�ni konti-PASIVNI', '99', '0');

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
  KEY `class_id` (`class_id`),
  KEY `class_id_2` (`class_id`)
) ENGINE=InnoDB ;

### Data of table `0_chart_types` ###

INSERT INTO `0_chart_types` VALUES
('0', 'RAZRED 0-DOLGORO�NA SREDSTVA', '1', '', '0'),
('00', '01-Neopredmetena sredstva', '1', '0', '0'),
('01', '01-Nalo�bene nepremi�nine', '1', '0', '0'),
('02', '02-Nepremi�nine', '1', '0', '0'),
('03', '03-Popravek in oslabitev vrednosti nepremi�nin', '1', '0', '0'),
('04', '04-Oprema in druga opredmetena osnovna sredstva', '1', '0', '0'),
('05', '05-Popravek in oslabitev vrednosti opreme', '1', '0', '0'),
('06', '06-Dolgoro�ne finan�ne nalo�be, razen posojil', '1', '0', '0'),
('07', '07-Dana dolgoro�na posojila in terjatve', '1', '0', '0'),
('08', '08-Dolgoro�ne poslovne terjatve', '1', '0', '0'),
('09', '09-Terjatve za odlo�eni davek', '1', '0', '0'),
('1', 'RAZRED 1-KRATKORO�NA SREDSTVA, RAZEN ZALOG', '1', '', '0'),
('10', '10-Denarna sredstva v blagajni', '1', '1', '0'),
('11', '11-Dobroimetje pri bankah in drugih finan�nih in', '1', '1', '0'),
('12', '12-Kratkoro�ne terjatve do kupcev', '1', '1', '0'),
('13', '13-Dani kratkoro�ni predujmi in var��ine', '1', '1', '0'),
('14', '14-Kratkoro�ne terjatve iz poslovanja za tuj ra�', '1', '1', '0'),
('15', '15 - Kratkoro�ne terjatve, povezane s finan�nimi', '1', '1', '0'),
('16', '16-Druge kratkoro�ne terjatve', '1', '1', '0'),
('17', '17-Kratkoro�ne finan�ne nalo�be, razen posojil', '1', '1', '0'),
('18', '18-Kratkoro�na posojila in kratkoro�ne terjatve', '1', '1', '0'),
('19', '19-Kratkoro�ne aktivne �asovne razmejitve', '1', '1', '0'),
('2', 'RAZRED 2-KRATKORO�NE OBVEZNOSTI ', '2', '', '0'),
('21', '21-Obveznosti, vklju�ene v skupine za odtujitev', '2', '2', '0'),
('22', '22-Kratkoro�ne obveznosti (dolgovi) do dobavitel', '2', '2', '0'),
('23', '23-Prejeti kratkoro�ni predujmi in var��ine', '2', '2', '0'),
('24', '24-Kratkoro�ne obveznosti iz poslovanja za tuj r', '2', '2', '0'),
('25', '25-Kratkoro�ne obveznosti za pla�e', '2', '2', '0'),
('26', '26-Obveznosti do dr�avnih in drugih in�titucij', '2', '2', '0'),
('27', '27-Kratkoro�ne finan�ne obveznosti', '2', '2', '0'),
('28', '28-Druge kratkoro�ne obveznosti', '2', '2', '0'),
('29', '29-Kratkoro�ne pasivne �asovne razmejitve', '2', '2', '0'),
('3', 'RAZRED 3-ZALOGE SUROVIN IN MATERIALA', '1', '', '0'),
('30', '30-Obra�un nabave surovin in materiala tudi drob', '1', '3', '0'),
('31', '31-Zaloge surovin in materiala', '1', '3', '0'),
('32', '32-Zaloge drobnega inventarja in embala�e', '2', '3', '0'),
('4', 'RAZRED 4-STRO�KI', '6', '', '0'),
('40', '40-Stro�ki materiala', '6', '4', '0'),
('41', '41-Stro�ki storitev', '6', '4', '0'),
('43', '43-Amortizacija', '6', '4', '0'),
('44', '44-Rezervacije', '6', '4', '0'),
('45', '45-Stro�ki obresti', '6', '4', '0'),
('47', '47-Stro�ki dela', '6', '4', '0'),
('48', '48-Drugi stro�ki', '6', '4', '0'),
('49', '49-Prenos stro�kov', '6', '4', '0'),
('5', 'RAZRED 5-PROSTO SE NE UPORABLJA', '5', '', '0'),
('6', 'RAZRED 6-ZALOGE PROIZVODOV, STORITEV', '1', '', '0'),
('60', '60-Nedokon�ane proizvodnja in storitve', '1', '6', '0'),
('63', '63-Proizvodi', '1', '6', '0'),
('65', '65-Obra�un nabave blaga', '1', '6', '0'),
('66', '66-Zaloge blaga', '1', '6', '0'),
('67', '67-Nekratkoro�na sredstva', '1', '6', '0'),
('7', 'RAZRED 7-ODHODKI IN PRIHODKI', '3', '', '0'),
('70', '70-Poslovni odhodki I. razli�ica', '6', '7', '0'),
('71', '71-Poslovni odhodki II. Razli�ica', '6', '7', '0'),
('72', '72-Prevrednotovalni poslovni odhodki', '6', '7', '0'),
('74', '74-Finan�ni odhodki iz finan�nih nalo�b', '6', '7', '0'),
('75', '75-Drugi finan�ni odhodki in ostali odhodki', '6', '7', '0'),
('76', '76-Poslovni prihodki', '3', '7', '0'),
('77', '77-Finan�ni prihodki iz finan�nih nalo�b', '3', '7', '0'),
('78', '78-Drugi finan�ni prihodki in ostali prihodki', '3', '7', '0'),
('79', '79-Usredstveni lastni proizvodi in lastne storit', '3', '7', '0'),
('8', 'RAZRED 8-POSLOVNI IZID', '4', '', '0'),
('80', '80-Poslovni izid pred obdav�itvijo', '3', '8', '0'),
('81', '81-Razporeditev dobi�ka oziroma dohodka', '3', '8', '0'),
('82', '82-Razporeditev �istega dobi�ka poslovnega leta', '3', '8', '0'),
('89', '89-�ista izguba oziroma �isti prese�ek odhodkov', '3', '8', '0'),
('9', 'RAZRED 9-KAPITAL, DOLGORO�NE OBVEZNOSTI', '5', '', '0'),
('90', '90-Vpoklicani in za�etni kapital ter ustanovitve', '5', '9', '0'),
('91', '91-Kapitalske rezerve in prenosi sredstev', '5', '9', '0'),
('92', '92-Rezerve iz dobi�ka oziroma razporejeni �isti', '5', '9', '0'),
('93', '93-�isti dobi�ek ali �ista izguba oziroma', '5', '9', '0'),
('95', '95-Prese�ek iz prevrednotenja', '5', '9', '0'),
('96', '96-Rezervacije in dolgoro�ne pasivne', '5', '9', '0'),
('97', '97-Dolgoro�ne finan�ne obveznosti', '5', '9', '0'),
('98', '98-Dolgoro�ne poslovne obveznosti', '5', '9', '0'),
('99', 'Zunajbilan�ni konti', '5', '', '0'),
('991', 'Pasivni zunajbilan�ni konti', '5', '', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 ;

### Data of table `0_credit_status` ###

INSERT INTO `0_credit_status` VALUES
('1', 'Dober pla�nik', '0', '0'),
('3', 'Samo preko Predpla�ila', '0', '0'),
('4', 'Podjetje v Likvidaciji', '1', '0'),
('5', 'Pla�nik z zamudo do 30 dni', '0', '0'),
('6', 'Pla�nik z zamudo �ez 30 dni', '0', '0'),
('7', 'Slab pla�nik z zamudo �ez 90 dni', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=158 ;

### Data of table `0_crm_contacts` ###

INSERT INTO `0_crm_contacts` VALUES
('1', '1', 'cust_branch', 'general', '2'),
('3', '2', 'customer', 'general', '2'),
('6', '5', 'customer', 'general', '1'),
('7', '6', 'cust_branch', 'general', '3'),
('9', '7', 'customer', 'order', '3'),
('11', '9', 'supplier', 'general', '2'),
('12', '10', 'supplier', 'general', '2'),
('14', '11', 'supplier', 'order', '2'),
('15', '12', 'supplier', 'general', '3'),
('16', '13', 'supplier', 'general', '4'),
('17', '14', 'customer', 'general', '3'),
('18', '15', 'cust_branch', 'general', '4'),
('20', '16', 'customer', 'order', '4'),
('21', '17', 'cust_branch', 'general', '5'),
('24', '19', 'customer', 'order', '5'),
('26', '20', 'cust_branch', 'general', '6'),
('28', '21', 'customer', 'general', '6'),
('29', '22', 'cust_branch', 'general', '7'),
('31', '23', 'customer', 'general', '7'),
('34', '20', 'customer', 'general', '6'),
('35', '15', 'customer', 'general', '4'),
('36', '17', 'customer', 'general', '5'),
('38', '18', 'customer', 'general', '5'),
('40', '8', 'customer', 'order', '3'),
('42', '6', 'customer', 'general', '3'),
('43', '22', 'customer', 'general', '7'),
('45', '24', 'customer', 'order', '7'),
('47', '4', 'customer', 'order', '1'),
('48', '1', 'customer', 'general', '2'),
('50', '3', 'customer', 'order', '2'),
('51', '25', 'supplier', 'general', '5'),
('52', '26', 'supplier', 'general', '6'),
('53', '27', 'cust_branch', 'general', '8'),
('54', '27', 'customer', 'general', '8'),
('55', '28', 'supplier', 'general', '7'),
('56', '29', 'supplier', 'general', '8'),
('57', '30', 'cust_branch', 'general', '9'),
('58', '30', 'customer', 'general', '9'),
('59', '31', 'customer', 'general', '9'),
('60', '32', 'cust_branch', 'general', '10'),
('61', '32', 'customer', 'general', '10'),
('62', '33', 'cust_branch', 'general', '11'),
('65', '34', 'customer', 'general', '11'),
('66', '35', 'cust_branch', 'general', '12'),
('67', '35', 'customer', 'general', '12'),
('68', '36', 'supplier', 'general', '9'),
('72', '33', 'customer', 'general', '11'),
('73', '38', 'cust_branch', 'general', '13'),
('74', '38', 'customer', 'general', '13'),
('75', '39', 'customer', 'general', '13'),
('76', '40', 'cust_branch', 'general', '14'),
('77', '40', 'customer', 'general', '14'),
('78', '37', 'customer', 'general', '11'),
('79', '41', 'supplier', 'general', '10'),
('80', '42', 'supplier', 'general', '10'),
('81', '43', 'cust_branch', 'general', '15'),
('82', '43', 'customer', 'general', '15'),
('83', '44', 'customer', 'general', '15'),
('84', '45', 'cust_branch', 'general', '16'),
('86', '45', 'customer', 'general', '16'),
('87', '46', 'cust_branch', 'general', '17'),
('88', '46', 'customer', 'general', '17'),
('89', '47', 'customer', 'order', '17'),
('90', '48', 'supplier', 'general', '11'),
('91', '49', 'supplier', 'general', '12'),
('92', '50', 'cust_branch', 'general', '18'),
('95', '50', 'customer', 'general', '18'),
('96', '51', 'cust_branch', 'general', '19'),
('97', '51', 'customer', 'general', '19'),
('98', '52', 'cust_branch', 'general', '20'),
('99', '52', 'customer', 'general', '20'),
('100', '53', 'cust_branch', 'general', '21'),
('101', '53', 'customer', 'general', '21'),
('105', '54', 'customer', 'general', '22'),
('106', '54', 'cust_branch', 'general', '22'),
('107', '55', 'cust_branch', 'general', '23'),
('108', '55', 'customer', 'general', '23'),
('109', '56', 'cust_branch', 'general', '24'),
('110', '56', 'customer', 'general', '24'),
('111', '57', 'cust_branch', 'order', '24'),
('112', '58', 'supplier', 'general', '13'),
('113', '59', 'supplier', 'general', '14'),
('114', '60', 'cust_branch', 'general', '25'),
('115', '60', 'customer', 'general', '25'),
('116', '61', 'supplier', 'general', '15'),
('119', '62', 'customer', 'general', '26'),
('120', '62', 'cust_branch', 'general', '26'),
('121', '63', 'supplier', 'general', '16'),
('122', '64', 'supplier', 'general', '17'),
('123', '65', 'supplier', 'general', '18'),
('124', '66', 'cust_branch', 'general', '27'),
('125', '66', 'customer', 'general', '27'),
('127', '68', 'cust_branch', 'general', '29'),
('128', '68', 'customer', 'general', '28'),
('129', '69', 'cust_branch', 'general', '30'),
('130', '70', 'cust_branch', 'general', '31'),
('131', '70', 'customer', 'general', '29'),
('132', '71', 'cust_branch', 'general', '32'),
('133', '71', 'customer', 'general', '30'),
('134', '72', 'cust_branch', 'general', '33'),
('135', '72', 'customer', 'general', '31'),
('136', '73', 'supplier', 'general', '19'),
('137', '74', 'cust_branch', 'general', '34'),
('138', '74', 'customer', 'general', '32'),
('139', '75', 'cust_branch', 'general', '35'),
('140', '76', 'cust_branch', 'general', '36'),
('141', '76', 'customer', 'general', '33'),
('142', '77', 'supplier', 'general', '20'),
('143', '78', 'supplier', 'general', '21'),
('144', '79', 'cust_branch', 'general', '37'),
('145', '79', 'customer', 'general', '34'),
('146', '80', 'cust_branch', 'general', '38'),
('147', '80', 'customer', 'general', '35'),
('148', '81', 'supplier', 'general', '22'),
('149', '82', 'supplier', 'general', '23'),
('150', '83', 'supplier', 'general', '24'),
('151', '84', 'cust_branch', 'general', '39'),
('152', '84', 'customer', 'general', '36'),
('153', '85', 'cust_branch', 'general', '40'),
('154', '85', 'customer', 'general', '37'),
('155', '86', 'cust_branch', 'general', '41'),
('156', '86', 'customer', 'general', '38'),
('157', '87', 'supplier', 'general', '25');

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
('Euro', 'EUR', '?', 'Europe', 'Cents', '0', '1'),
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
  KEY `tran_date` (`tran_date`),
  KEY `tran_date_2` (`tran_date`)
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
  KEY `src_id` (`src_id`),
  KEY `src_id_2` (`src_id`)
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
  KEY `name` (`name`),
  KEY `debtor_ref_2` (`debtor_ref`)
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
  KEY `type_` (`type_`),
  KEY `date__2` (`date_`),
  KEY `due_date_2` (`due_date`),
  KEY `type__2` (`type_`)
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
  UNIQUE KEY `end` (`end`),
  UNIQUE KEY `begin_2` (`begin`),
  UNIQUE KEY `end_2` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=14 ;

### Data of table `0_fiscal_year` ###

INSERT INTO `0_fiscal_year` VALUES
('7', '2014-01-01', '2014-12-31', '1'),
('8', '2015-01-01', '2015-12-31', '0'),
('9', '2016-01-01', '2016-12-31', '0'),
('10', '2017-01-01', '2017-12-31', '0'),
('11', '2018-01-01', '2018-12-31', '0'),
('12', '2019-01-01', '2019-12-31', '0'),
('13', '2020-01-01', '2020-12-31', '0');

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
  KEY `purch_order_no` (`purch_order_no`),
  KEY `delivery_date_2` (`delivery_date`),
  KEY `purch_order_no_2` (`purch_order_no`)
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
  KEY `grn_batch_id` (`grn_batch_id`),
  KEY `grn_batch_id_2` (`grn_batch_id`)
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
('1', 'Velika', '0'),
('2', 'Srednja', '0'),
('3', 'Mala', '0');

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
  KEY `item_code` (`item_code`),
  KEY `item_code_2` (`item_code`)
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
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

### Data of table `0_item_tax_types` ###

INSERT INTO `0_item_tax_types` VALUES
('1', '-/-', '1', '0'),
('2', 'DDV-22%', '0', '0'),
('3', 'DDV-9.5%', '0', '0');

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
('dnv', 'Dnevnica', '2', '0'),
('h', 'Ura', '2', '0'),
('km', 'Kilometer', '0', '0'),
('Kos', 'Kos', '2', '0'),
('Kpl', 'Komplet', '2', '0'),
('Lit', 'Liter', '2', '0'),
('m', 'Meter', '2', '0'),
('Set', 'Set', '2', '0'),
('St.', 'St�ck', '0', '0'),
('t', 'Tona', '3', '0');

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
('DEF', 'Skladi��e 1', 'Privzeti', '', '', '', '', '', '0', '0'),
('KDW', 'K1', 'Privzeti', '', '', '', '', '', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 ;

### Data of table `0_payment_terms` ###

INSERT INTO `0_payment_terms` VALUES
('1', 'Valuta 14 dni', '14', '0', '0'),
('2', 'Valuta 30 dni', '30', '0', '0'),
('3', 'Valuta 60 dni', '60', '0', '0'),
('5', 'Valuta 90 dni', '90', '0', '0'),
('6', 'Valuta 180 dni', '180', '0', '0'),
('7', 'Predpla�ilo', '-1', '0', '0');

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
  KEY `ord_date` (`ord_date`),
  KEY `ord_date_2` (`ord_date`)
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
) ENGINE=InnoDB AUTO_INCREMENT=13 ;

### Data of table `0_quick_entries` ###

INSERT INTO `0_quick_entries` VALUES
('1', '1', 'Po�ta Ra�un �t.:', NULL, '0', 'Znesek', '0'),
('2', '3', 'Samoobdav�itev 160-K , 260-D', NULL, '0', '002', '0'),
('3', '2', 'Pritoki iz gospodinjstva', NULL, '0', 'Znesek', '0'),
('4', '1', 'Petrol', NULL, '0', 'Osnovni znesek', '0'),
('5', '1', 'Merkur', NULL, '0', 'Osnovni znesek', '0'),
('6', '1', 'Dajatve podjetnika', NULL, '222.14', 'Znesek', '0'),
('7', '1', 'Obrtna zbornica �lanarina', NULL, '18', '�lanarina', '0'),
('8', '1', 'Provizija prenosov sredstev', NULL, '0.3', 'PROVIZIJA', '0'),
('9', '1', 'Pretoki v gospodinjstvo', NULL, '0', 'Znesek', '0'),
('10', '1', 'Nabava orodja drobni inventar R.�t:', NULL, '0', 'Nabava orodja drobni inventar R.�t:', '0'),
('11', '1', 'Akontacija dohodnine 264', NULL, '0', 'Akontacija dohodnine 264', '0'),
('12', '2', 'Vra�ilo dohodnine dohodnine 161', NULL, '0', 'Vra�ilo dohodnine dohodnine 161', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=26 ;

### Data of table `0_quick_entry_lines` ###

INSERT INTO `0_quick_entry_lines` VALUES
('2', '2', '0', '', 'a', '160', '41', '42'),
('7', '3', '0', '', 'a', '919', '14', '16'),
('8', '1', '0', '', 'a', '415', '27', '38'),
('9', '4', '0', '', 'a', '489', '33', '37'),
('10', '5', '0', '', 'a', '407', '33', '13'),
('11', '6', '122.91', '', 'a', '484', '30', '31'),
('12', '6', '96.08', '', 'a', '484', '30', '31'),
('13', '6', '1.57', '', 'a', '484', '30', '31'),
('14', '6', '1.58', '', 'a', '484', '30', '31'),
('15', '7', '18', '', 'a', '416', '27', '32'),
('16', '8', '0', '', 'a', '415', '27', '40'),
('17', '9', '0', '', '=', '919', '14', '15'),
('18', '1', '0', '', 'a', '260', '41', '42'),
('19', '2', '0', '', 'a', '260', '41', '43'),
('21', '10', '0', '', 'a', '407', '22', '46'),
('22', '10', '0', '', 'a', '260', '41', '42'),
('23', '11', '0', '', '=', '264', '47', '48'),
('25', '12', '0', '', '=', '161', '47', '49');

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
('1', '0', '', '20150001', '', '1', '0'),
('2', '1', '', '20150001', '', '1', '0'),
('3', '2', '', '20150001', '', '1', '0'),
('4', '4', '', '20150001', '', '1', '0'),
('5', '10', '', '20150001', '', '1', '0'),
('6', '11', '', '20150001', '', '1', '0'),
('7', '12', '', '20150001', '', '1', '0'),
('8', '13', '', '20150001', '', '1', '0'),
('9', '16', '', '20150001', '', '1', '0'),
('10', '17', '', '20150001', '', '1', '0'),
('11', '18', '', '20150001', '', '1', '0'),
('12', '20', '', '20150001', '', '1', '0'),
('13', '21', '', '20150001', '', '1', '0'),
('14', '22', '', '20150001', '', '1', '0'),
('15', '25', '', '20150001', '', '1', '0'),
('16', '26', '', '20150001', '', '1', '0'),
('17', '28', '', '20150001', '', '1', '0'),
('18', '29', '', '20150001', '', '1', '0'),
('19', '30', '', '20150001', '', '1', '0'),
('20', '32', '', '20150001', '', '1', '0'),
('21', '35', '', '20150001', '', '1', '0'),
('22', '40', '', '20150001', '', '1', '0');

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
('1', 'POS', '0', '1', 'DEF', '0', '0');

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
('1', 'Kon�ni kupci', '0', '2.6', '0'),
('2', 'Nadaljna prodaja', '0', '1.15', '0');

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
('2', 'System Administrator', 'System Administrator', '256;512;768;2816;3072;3328;5376;5632;5888;7936;8192;8448;10496;10752;11008;13056;13312;15616;15872;16128;1401856;1795072;1926144;1991680;2122752', '257;258;259;260;513;514;515;516;517;518;519;520;521;522;523;524;525;526;769;770;771;772;773;774;2817;2818;2819;2820;2821;2822;2823;3073;3074;3082;3075;3076;3077;3078;3079;3080;3081;3329;3330;3331;3332;3333;3334;3335;5377;5633;5634;5635;5636;5637;5641;5638;5639;5640;5889;5890;5891;7937;7938;7939;7940;8193;8194;8195;8196;8197;8449;8450;8451;10497;10753;10754;10755;10756;10757;11009;11010;11011;11012;13057;13313;13314;13315;15617;15618;15619;15620;15621;15622;15623;15624;15628;15625;15626;15627;15629;15873;15874;15875;15876;15877;15878;15879;15880;15883;15881;15882;15884;16129;16130;16131;16132;1401956;1401957;1795172;1926244;1991780;1991781;1991782;2122852;2122853;775', '0'),
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
('1', 'Privzeti', '', '', '', '', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 ;

### Data of table `0_stock_category` ###

INSERT INTO `0_stock_category` VALUES
('1', 'Rezervni deli', '0', '2', 'Kos', 'B', '760', '702', '702', '669', '1140', '5', '6', '0', '0'),
('2', 'Paketi', '0', '2', 'Kos', 'B', '760', '702', '702', '669', '1140', '2', '6', '0', '0'),
('3', 'Sistemi', '0', '2', 'Kos', 'B', '760', '702', '702', '669', '1140', '2', '6', '0', '0'),
('4', 'Storitve', '0', '2', 'Kos', 'D', '760', '702', '660', '669', '1140', '1', '6', '0', '0'),
('5', 'Orodja', '0', '2', 'Kos', 'B', '400', '702', '702', '669', '663', '22', '8', '1', '0'),
('6', 'Kilometrina', '0', '1', 'km', 'D', '485', '919', '702', '669', '663', '44', '45', '0', '0'),
('7', 'Dnevnice', '0', '1', 'dnv', 'D', '485', '919', '702', '669', '663', '44', '45', '0', '0'),
('8', 'Pisarna', '0', '2', 'Kos', 'B', '433', '051', '041', '669', '663', '21', '8', '1', '0');

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
  KEY `tran_date` (`tran_date`),
  KEY `tran_date_2` (`tran_date`)
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
  KEY `supp_ref` (`supp_ref`),
  KEY `supp_ref_2` (`supp_ref`)
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
('bank_charge_act', 'glsetup.general', 'varchar', '15', '415'),
('base_sales', 'setup.company', 'int', '11', '0'),
('bcc_email', 'setup.company', 'varchar', '100', ''),
('coy_logo', 'setup.company', 'varchar', '100', 'logo_frontaccounting.jpg'),
('coy_name', 'setup.company', 'varchar', '60', 'Training Co.'),
('coy_no', 'setup.company', 'varchar', '25', ''),
('creditors_act', 'glsetup.purchase', 'varchar', '15', '110'),
('curr_default', 'setup.company', 'char', '3', 'EUR'),
('debtors_act', 'glsetup.sales', 'varchar', '15', '120'),
('default_adj_act', 'glsetup.items', 'varchar', '15', '669'),
('default_cogs_act', 'glsetup.items', 'varchar', '15', '662'),
('default_credit_limit', 'glsetup.customer', 'int', '11', '1000'),
('default_delivery_required', 'glsetup.sales', 'smallint', '6', '1'),
('default_dim_required', 'glsetup.dims', 'int', '11', '20'),
('default_inv_sales_act', 'glsetup.items', 'varchar', '15', '760'),
('default_inventory_act', 'glsetup.items', 'varchar', '15', '702'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', '15', '669'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', '6', '30'),
('default_receival_required', 'glsetup.purchase', 'smallint', '6', '10'),
('default_sales_act', 'glsetup.sales', 'varchar', '15', '760'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', '15', '703'),
('default_wip_act', 'glsetup.items', 'varchar', '15', '663'),
('default_workorder_required', 'glsetup.manuf', 'int', '11', '20'),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', ''),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('domicile', 'setup.company', 'varchar', '55', ''),
('email', 'setup.company', 'varchar', '100', ''),
('exchange_diff_act', 'glsetup.general', 'varchar', '15', '112'),
('f_year', 'setup.company', 'int', '11', '8'),
('fax', 'setup.company', 'varchar', '30', ''),
('freight_act', 'glsetup.customer', 'varchar', '15', '407'),
('gl_closing_date', 'setup.closing_date', 'date', '8', ''),
('grn_clearing_act', 'glsetup.purchase', 'varchar', '15', '224'),
('gst_no', 'setup.company', 'varchar', '25', '9876543'),
('legal_text', 'glsetup.customer', 'tinytext', '0', 'Garancija: Na rezervne dele 6 mesecev na napake proizvajalca.Na baterije 1 leto na napake proizvajalca.'),
('loc_notification', 'glsetup.inventory', 'tinyint', '1', '0'),
('login_tout', 'setup.company', 'smallint', '6', '600'),
('no_customer_list', 'setup.company', 'tinyint', '1', '0'),
('no_item_list', 'setup.company', 'tinyint', '1', '0'),
('no_supplier_list', 'setup.company', 'tinyint', '1', '0'),
('no_zero_lines_amount', 'glsetup.sales', 'tinyint', '1', '1'),
('past_due_days', 'glsetup.general', 'int', '11', '30'),
('phone', 'setup.company', 'varchar', '30', ''),
('po_over_charge', 'glsetup.purchase', 'int', '11', '25'),
('po_over_receive', 'glsetup.purchase', 'int', '11', '10'),
('postal_address', 'setup.company', 'tinytext', '0', 'Addres'),
('print_invoice_no', 'glsetup.sales', 'tinyint', '1', '0'),
('print_item_images_on_quote', 'glsetup.inventory', 'tinyint', '1', '0'),
('profit_loss_year_act', 'glsetup.general', 'varchar', '15', '801'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', '15', '768'),
('ref_no_auto_increase','setup.company', 'tinyint', 1, '0'),
('retained_earnings_act', 'glsetup.general', 'varchar', '15', '601'),
('round_to', 'setup.company', 'int', '5', '1'),
('show_po_item_codes', 'glsetup.purchase', 'tinyint', '1', '0'),
('suppress_tax_rates', 'setup.company', 'tinyint', '1', '0'),
('tax_algorithm', 'glsetup.customer', 'tinyint', '1', '1'),
('tax_last', 'setup.company', 'int', '11', '1'),
('tax_prd', 'setup.company', 'int', '11', '1'),
('time_zone', 'setup.company', 'tinyint', '1', '0'),
('use_dimension', 'setup.company', 'tinyint', '1', '2'),
('use_fixed_assets', 'setup.company', 'tinyint', '1', '1'),
('use_manufacturing', 'setup.company', 'tinyint', '1', '1'),
('version_id', 'system', 'varchar', '11', '2.4.1');

### Structure of table `0_sys_types` ###

DROP TABLE IF EXISTS `0_sys_types`;

CREATE TABLE `0_sys_types` (
  `type_id` smallint(6) NOT NULL DEFAULT '0',
  `type_no` int(11) NOT NULL DEFAULT '1',
  `next_reference` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB ;

### Data of table `0_sys_types` ###

INSERT INTO `0_sys_types` VALUES
('0', '17', '20150001'),
('1', '7', '20150001'),
('2', '4', '20150001'),
('4', '3', '20150001'),
('10', '16', '20150001'),
('11', '2', '20150001'),
('12', '6', '20150001'),
('13', '1', '20150001'),
('16', '2', '20150001'),
('17', '2', '20150001'),
('18', '1', '20150001'),
('20', '6', '20150001'),
('21', '1', '20150001'),
('22', '3', '20150001'),
('25', '1', '20150001'),
('26', '1', '20150001'),
('28', '1', '20150001'),
('29', '1', '20150001'),
('30', '0', '20150001'),
('32', '0', '20150001'),
('35', '1', '20150001'),
('40', '1', '20150001');

### Structure of table `0_tag_associations` ###

DROP TABLE IF EXISTS `0_tag_associations`;

CREATE TABLE `0_tag_associations` (
  `record_id` varchar(15) NOT NULL,
  `tag_id` int(11) NOT NULL,
  UNIQUE KEY `record_id` (`record_id`,`tag_id`)
) ENGINE=InnoDB ;

### Data of table `0_tag_associations` ###

INSERT INTO `0_tag_associations` VALUES
('010', '6'),
('1', '2'),
('10', '10'),
('11', '10'),
('12', '7'),
('13', '11'),
('14', '12'),
('15', '12'),
('16', '12'),
('17', '4'),
('18', '4'),
('19', '4'),
('2', '5'),
('20', '4'),
('21', '7'),
('22', '9'),
('23', '13'),
('3', '1'),
('37', '8'),
('38', '2'),
('39', '13'),
('4', '1'),
('40', '2'),
('41', '13'),
('42', '13'),
('43', '13'),
('44', '12'),
('45', '12'),
('46', '9'),
('47', '13'),
('48', '13'),
('49', '13'),
('5', '4'),
('6', '4'),
('7', '11'),
('8', '7'),
('9', '7');

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
) ENGINE=InnoDB AUTO_INCREMENT=14 ;

### Data of table `0_tags` ###

INSERT INTO `0_tags` VALUES
('1', '2', 'GARANCIJA', 'Garancija', '0'),
('2', '2', 'STORITVE', 'Storitve', '0'),
('3', '2', 'PRODAJA', 'Prodaja', '0'),
('4', '2', 'RD', 'Rezervni deli', '0'),
('5', '2', 'POPRAVILA RD', 'Popravila rezervni deli', '0'),
('6', '1', 'Nalo�.Nepremi�nine', 'Nalo�bene nepremi�nine', '0'),
('7', '2', 'OSN.SREDSTVA', 'Osnovna sredstva', '0'),
('8', '2', 'PREV.STRO�KI', 'Stro�ki prevozov', '0'),
('9', '2', 'ORODJA', 'Stro�ki nabave orodja', '0'),
('10', '2', 'OLJA', 'Stro�ki porabe olj', '0'),
('11', '2', 'DROB.MATERIAL', 'Nabava drobnega materiala', '0'),
('12', '2', 'GOSPODINJSTVO', 'Obveznosti do gospodinjstva', '0'),
('13', '2', 'DAJATVE', 'Obvezne dajatve do dr�ave', '0');

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
('1', '4', '0'),
('2', '3', '1');

### Structure of table `0_tax_groups` ###

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 ;

### Data of table `0_tax_groups` ###

INSERT INTO `0_tax_groups` VALUES
('1', 'DDV (9,5%)', '0'),
('2', 'DDV (22%)', '0'),
('3', 'VAT (21%)', '0'),
('4', 'Brez davka', '0'),
('5', 'MVST(19%)', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

### Data of table `0_tax_types` ###

INSERT INTO `0_tax_types` VALUES
('3', '22', '160', '260', 'DDV', '0'),
('4', '9.5', '160', '260', 'DDV', '0');

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
  KEY `ip` (`ip`),
  KEY `ip_2` (`ip`)
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
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

### Data of table `0_users` ###

INSERT INTO `0_users` VALUES
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'Administrator', '2', '', 'adm@adm.com', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2014-05-11 23:27:46', '10', '1', '1', '1', '1', '0', 'orders', '30', '0', '1', '0', '0', '0'),
('2', 'demouser', '5f4dcc3b5aa765d61d8327deb882cf99', 'Demo User', '9', '999-999-999', 'demo@demo.nu', 'en_US', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '3', '1', '1', '0', '0', '2014-02-06 19:02:35', '10', '1', '1', '1', '1', '0', 'orders', '30', '0', '1', '0', '0', '0');

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
  KEY `workorder_id` (`workorder_id`),
  KEY `workorder_id_2` (`workorder_id`)
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
  KEY `workorder_id` (`workorder_id`),
  KEY `workorder_id_2` (`workorder_id`)
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
  KEY `workorder_id` (`workorder_id`),
  KEY `workorder_id_2` (`workorder_id`)
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
