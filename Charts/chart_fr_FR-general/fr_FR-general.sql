# MySQL dump of database 'faupgrade' on host 'localhost'
# Backup Date and Time: 2016-02-23 16:57
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
('1', '1 Capitaux', '3', '0'),
('2', '2 Immobilisations', '1', '0'),
('3', '3 Stocks et en-cours', '1', '0'),
('4', '4 Tiers', '2', '0'),
('5', '5 Financiers', '1', '0'),
('6', '6 Charges', '6', '0'),
('7', '7 Produits', '4', '0'),
('8', '8 Comptes spéciaux', '4', '0');

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
('100000', '', 'Capital et réserves.', '10', '0'),
('101000', '', 'Capital.', '101', '0'),
('101100', '', 'Capital souscrit - non appelé.', '1011', '0'),
('101200', '', 'Capital souscrit - appelé, non versé.', '1012', '0'),
('101300', '', 'Capital souscrit - appelé, versé.', '1013', '0'),
('101310', '', 'Capital non amorti.', '10131', '0'),
('101320', '', 'Capital amorti.', '10132', '0'),
('101800', '', 'Capital souscrit soumis à des réglementations part', '1018', '0'),
('104000', '', 'Primes liées au capital social.', '104', '0'),
('104100', '', 'Primes d&#039;émission.', '1041', '0'),
('104200', '', 'Primes de fusion.', '1042', '0'),
('104300', '', 'Primes d&#039;apport.', '1043', '0'),
('104400', '', 'Primes de conversion d&#039;obligations en actions.', '1044', '0'),
('104500', '', 'Bons de souscription d&#039;actions.', '1045', '0'),
('105000', '', 'Ecarts de réévaluation.', '105', '0'),
('105100', '', 'Réserve spéciale de réévaluation.', '1051', '0'),
('105200', '', 'Ecart de réévaluation libre.', '1052', '0'),
('105300', '', 'Réserve de réévaluation.', '1053', '0'),
('105500', '', 'Ecarts de réévaluation (autres opérations légales)', '1055', '0'),
('105700', '', 'Autres écarts de réévaluation en France.', '1057', '0'),
('105800', '', 'Autres écarts de réévaluation à l&#039;étranger.', '1058', '0'),
('106000', '', 'Réserves.', '106', '0'),
('106100', '', 'Réserve légale.', '1061', '0'),
('106110', '', 'Réserve légale proprement dite.', '10611', '0'),
('106120', '', 'Plus-values nettes à long terme.', '10612', '0'),
('106200', '', 'Réserves indisponibles.', '1062', '0'),
('106300', '', 'Réserves statutaires ou contractuelles.', '1063', '0'),
('106400', '', 'Réserves réglementées.', '1064', '0'),
('106410', '', 'Plus-values nettes à long terme.', '10641', '0'),
('106430', '', 'Réserves consécutives à l&#039;octroi de subventions d&#039;', '10643', '0'),
('106480', '', 'Autres réserves réglementées.', '10648', '0'),
('106800', '', 'Autres réserves.', '1068', '0'),
('106810', '', 'Réserve de propre assureur.', '10681', '0'),
('106880', '', 'Réserves diverses.', '10688', '0'),
('107000', '', 'Ecart d&#039;équivalence.', '107', '0'),
('108000', '', 'Compte de l&#039;exploitant.', '108', '0'),
('109000', '', 'Actionnaires : Capital souscrit - non appelé.', '109', '0'),
('110000', '', 'Report à nouveau (solde créditeur).', '110', '0'),
('119000', '', 'Report à nouveau (solde débiteur).', '119', '0'),
('120000', '', 'Résultat de l&#039;exercice (bénéfice).', '120', '0'),
('129000', '', 'Résultat de l&#039;exercice (perte).', '129', '0'),
('130000', '', 'Subventions d&#039;investissement.', '13', '0'),
('131000', '', 'Subventions d&#039;équipement.', '131', '0'),
('131100', '', 'Etat.', '1311', '0'),
('131200', '', 'Régions.', '1312', '0'),
('131300', '', 'Départements.', '1313', '0'),
('131400', '', 'Communes.', '1314', '0'),
('131500', '', 'Collectivités publiques.', '1315', '0'),
('131600', '', 'Entreprises publiques.', '1316', '0'),
('131700', '', 'Entreprises et organismes privés.', '1317', '0'),
('131800', '', 'Autres.', '1318', '0'),
('138000', '', 'Autres subventions d&#039;investissement.', '138', '0'),
('139000', '', 'Subventions d&#039;investissement inscrites au compte d', '139', '0'),
('139100', '', 'Subventions d&#039;équipement.', '1391', '0'),
('139110', '', 'Etat.', '13911', '0'),
('139120', '', 'Régions.', '13912', '0'),
('139130', '', 'Départements.', '13913', '0'),
('139140', '', 'Communes.', '13914', '0'),
('139150', '', 'Collectivités publiques.', '13915', '0'),
('139160', '', 'Entreprises publiques.', '13916', '0'),
('139170', '', 'Entreprises et organismes privés.', '13917', '0'),
('139180', '', 'Autres.', '13918', '0'),
('139800', '', 'Autres subventions d&#039;investissement.', '1398', '0'),
('140000', '', 'Provisions réglementées.', '14', '0'),
('142000', '', 'Provisions réglementées relatives aux immobilisati', '142', '0'),
('142300', '', 'Provision pour reconstitution desgisements miniers', '1423', '0'),
('142400', '', 'Provision pour investissement(participation des sa', '1424', '0'),
('143000', '', 'Provisions réglementées relatives aux stocks.', '143', '0'),
('143100', '', 'Hausse des prix.', '1431', '0'),
('143200', '', 'Fluctuation des cours.', '1432', '0'),
('144000', '', 'Provisions réglementées relatives aux autres éléme', '144', '0'),
('145000', '', ' Amortissements dérogatoires.', '145', '0'),
('146000', '', 'Provision spéciale de réévaluation.', '146', '0'),
('147000', '', 'Plus-values réinvesties.', '147', '0'),
('148000', '', 'Autres provisions réglementées.', '148', '0'),
('150000', '', 'Provisions.', '15', '0'),
('151000', '', 'Provisions pour risques.', '151', '0'),
('151100', '', 'Provisions pour litiges.', '1511', '0'),
('151200', '', 'Provisions pour garanties données aux clients.', '1512', '0'),
('151300', '', 'Provisions pour pertes sur marchés à terme.', '1513', '0'),
('151400', '', 'Provisions pour amendes et pénalités.', '1514', '0'),
('151500', '', 'Provisions pour pertes de change.', '1515', '0'),
('151600', '', 'Provisions pour pertes sur contrats.', '1516', '0'),
('151800', '', 'Autres provisions pour risques.', '1518', '0'),
('153000', '', 'Provisions pour pensions et obligations similaires', '153', '0'),
('154000', '', 'Provisions pour restructurations.', '154', '0'),
('155000', '', 'Provisions pour impôts.', '155', '0'),
('156000', '', 'Provisions pour renouvellement des immobilisations', '156', '0'),
('157000', '', 'Provisions pour charges à répartir sur plusieurs e', '157', '0'),
('157200', '', 'Autres provisions pour charges.', '158', '0'),
('158000', '', 'Provisions pour gros entretien ou grandes révision', '1572', '0'),
('158200', '', 'Provisions pour remise en état.', '1581', '0'),
('160000', '', 'Emprunts et dettes assimilées.', '16', '0'),
('161000', '', 'Emprunts obligataires convertibles.', '161', '0'),
('163000', '', 'Autres emprunts obligataires.', '163', '0'),
('164000', '', 'Emprunts auprès des établissements de crédit.', '164', '0'),
('165000', '', 'Dépôts et cautionnements reçus.', '165', '0'),
('165100', '', 'Dépôts.', '1651', '0'),
('165500', '', 'Cautionnements.', '1655', '0'),
('166000', '', 'Participation des salariés aux résultats.', '166', '0'),
('166100', '', 'Comptes bloqués.', '1661', '0'),
('166200', '', 'Fonds de participation.', '1662', '0'),
('167000', '', 'Emprunts et dettes assortis de conditions particul', '167', '0'),
('167100', '', 'Emissions de titres participatifs.', '1671', '0'),
('167400', '', 'Avances conditionnées de l&#039;Etat.', '1674', '0'),
('167500', '', 'Autres emprunts et dettes assimilées.', '168', '0'),
('168000', '', 'Emprunts participatifs.', '1675', '0'),
('168100', '', 'Autres emprunts.', '1681', '0'),
('168500', '', 'Rentes viagères capitalisées.', '1685', '0'),
('168700', '', 'Autres dettes.', '1687', '0'),
('168800', '', 'Intérêts courus.', '1688', '0'),
('168810', '', 'Sur emprunts obligataires convertibles.', '16881', '0'),
('168840', '', 'Sur emprunts auprès des établissements de crédit.', '16884', '0'),
('168850', '', 'Sur dépôts et cautionnements reçus.', '16885', '0'),
('168860', '', 'Sur participation des salariés aux résultats.', '16886', '0'),
('168870', '', 'Sur emprunts et dettes assortis de conditions part', '16887', '0'),
('168880', '', 'Sur autres emprunts et dettes assimilées.', '16888', '0'),
('169000', '', 'Primes de remboursement des obligations.', '169', '0'),
('170000', '', 'Dettes rattachées à des participations.', '17', '0'),
('171000', '', 'Dettes rattachées à des participations (groupe).', '171', '0'),
('174000', '', 'Dettes rattachées à des participation (hors groupe', '174', '0'),
('178000', '', 'Dettes rattachées à des sociétés en participation.', '178', '0'),
('178100', '', 'Principal.', '1781', '0'),
('178800', '', 'Intérêts courus.', '1788', '0'),
('180000', '', 'Comptes de liaison des établissements et sociétés ', '18', '0'),
('181000', '', 'Compte de liaison des établissements.', '181', '0'),
('186000', '', 'Biens et prestations de services échangés entre ét', '186', '0'),
('187000', '', 'Biens et prestations de services échangés entre ét', '187', '0'),
('188000', '', 'Comptes de liaison des sociétés en participation.', '188', '0'),
('200000', '', 'Immobilisations incorporelles.', '20', '0'),
('201000', '', 'Frais d&#039;établissement.', '201', '0'),
('201100', '', 'Frais de constitution.', '2011', '0'),
('201200', '', 'Frais de premier établissement.', '2012', '0'),
('201210', '', 'Frais de prospection.', '20121', '0'),
('201220', '', 'Frais de publicité.', '20122', '0'),
('201300', '', 'Frais d&#039;augmentation de capital et d&#039;opérations di', '2013', '0'),
('203000', '', 'Frais de recherche et de développement.', '203', '0'),
('205000', '', 'Concessions et droits similaires, brevets, licence', '205', '0'),
('206000', '', 'Droit au bail.', '206', '0'),
('207000', '', 'Fonds commercial.', '207', '0'),
('208000', '', 'Autres immobilisations incorporelles.', '208', '0'),
('210000', '', 'Immobilisations corporelles.', '21', '0'),
('211000', '', 'Terrains.', '211', '0'),
('211100', '', 'Terrains nus.', '2111', '0'),
('211200', '', 'Terrains aménagés.', '2112', '0'),
('211300', '', 'Sous-sols et sur-sols.', '2113', '0'),
('211400', '', 'Terrains de gisements.', '2114', '0'),
('211410', '', 'Carrières.', '21141', '0'),
('211500', '', 'Terrains bâtis.', '2115', '0'),
('211510', '', 'Ensembles immobiliers industriels (A, B...).', '21151', '0'),
('211550', '', 'Ensembles immobiliers administratifs et commerciau', '21155', '0'),
('211580', '', 'Autres ensembles immobiliers.', '21158', '0'),
('211581', '', 'Autres ensembles immobiliers affectés aux opérations profess', '211581', '0'),
('211588', '', 'Autres ensembles immobiliers affectés aux opérations non pro', '211588', '0'),
('211600', '', 'Autres ensembles immobiliers affectés aux opérations profess', '213181', '0'),
('212000', '', 'Autres ensembles immobiliers affectés aux opérations non pro', '213188', '0'),
('213000', '', 'Compte d&#039;ordre sur immobilisations (art. 6 du décr', '2116', '0'),
('213100', '', 'Agencements et aménagements de terrains.', '212', '0'),
('213110', '', 'Constructions.', '213', '0'),
('213150', '', 'Bâtiments.', '2131', '0'),
('213180', '', 'Ensembles immobiliers industriels (A, B...).', '21311', '0'),
('213181', '', 'Ensembles immobiliers administratifs et commerciau', '21315', '0'),
('213188', '', 'Autres ensembles immobiliers.', '21318', '0'),
('213500', '', 'Installations générales - Agencements-aménagements', '2135', '0'),
('213800', '', 'Ouvrages d&#039;infrastructure.', '2138', '0'),
('213810', '', 'Voies de terre.', '21381', '0'),
('213820', '', 'Voies de fer.', '21382', '0'),
('213830', '', 'Voies d&#039;eau.', '21383', '0'),
('213840', '', 'Barrages.', '21384', '0'),
('213850', '', 'Pistes d&#039;aérodrome.', '21385', '0'),
('214000', '', 'Constructions sur sol d&#039;autrui.', '214', '0'),
('215000', '', 'Installations techniques, matériel et outillage in', '215', '0'),
('215100', '', 'Installations complexes spécialisées.', '2151', '0'),
('215110', '', 'Installations complexes spécialisées sur sol propre.', '21511', '0'),
('215140', '', 'Installations complexes spécialisées sur sol d&#039;autrui.', '21514', '0'),
('215300', '', 'Installations à caractère spécifique.', '2153', '0'),
('215310', '', 'Installations à caractère spécifique sur sol propre.', '21531', '0'),
('215340', '', 'Installations à caractère spécifique sur sol d&#039;autrui.', '21534', '0'),
('215400', '', 'Matériel industriel.', '2154', '0'),
('215500', '', 'Outillage industriel.', '2155', '0'),
('215700', '', 'Agencements et aménagements du matériel et outilla', '2157', '0'),
('218000', '', 'Autres immobilisations corporelles.', '218', '0'),
('218100', '', 'Installations générales, agencements, aménagements', '2181', '0'),
('218200', '', 'Matériel de transport.', '2182', '0'),
('218300', '', 'Matériel de bureau et matériel informatique.', '2183', '0'),
('218400', '', 'Mobilier.', '2184', '0'),
('218500', '', 'Cheptel.', '2185', '0'),
('218600', '', 'Emballages récupérables.', '2186', '0'),
('220000', '', 'Immobilisations mises en concession.', '22', '0'),
('230000', '', 'Immobilisations en cours.', '23', '0'),
('231000', '', ' Immobilisations corporelles en cours.', '231', '0'),
('231200', '', 'Terrains.', '2312', '0'),
('231300', '', 'Constructions.', '2313', '0'),
('231500', '', 'Installations techniques, matériel et outillage in', '2315', '0'),
('231800', '', 'Autres immobilisations corporelles.', '2318', '0'),
('232000', '', 'Immobilisations incorporelles en cours.', '232', '0'),
('237000', '', 'Avances et acomptes versés sur immobilisations inc', '237', '0'),
('238000', '', 'Avances et acomptes versés sur commandes d&#039;immobil', '238', '0'),
('238200', '', 'Terrains.', '2382', '0'),
('238300', '', 'Constructions.', '2383', '0'),
('238500', '', 'Installations techniques, matériel et outillage in', '2385', '0'),
('238800', '', 'Autres immobilisations corporelles.', '2388', '0'),
('250000', '', 'Entreprises liées - Parts et créances.', '25', '0'),
('260000', '', 'Participations et créances rattachées à des partic', '26', '0'),
('261000', '', 'Titres de participation.', '261', '0'),
('261100', '', 'Actions.', '2611', '0'),
('261800', '', 'Autres titres.', '2618', '0'),
('266000', '', 'Autres formes de participation.', '266', '0'),
('267000', '', 'Créances rattachées à des participations.', '267', '0'),
('267100', '', 'Créances rattachées à des participations (groupe).', '2671', '0'),
('267400', '', 'Créances rattachées à des participations (hors gro', '2674', '0'),
('267500', '', 'Versements représentatifs d&#039;apports non capitalisé', '2675', '0'),
('267600', '', 'Avances consolidables.', '2676', '0'),
('267700', '', 'Autres créances rattachées à des participations.', '2677', '0'),
('267800', '', 'Intérêts courus.', '2678', '0'),
('268000', '', 'Créances rattachées à des sociétés en participatio', '268', '0'),
('268100', '', 'Principal.', '2681', '0'),
('268800', '', 'Intérêts courus.', '2688', '0'),
('269000', '', 'Versements restant à effectuer sur titres de parti', '269', '0'),
('270000', '', 'Autres immobilisations financières.', '27', '0'),
('271000', '', 'Titres immobilisés autres que les titres immobilis', '271', '0'),
('271100', '', 'Actions.', '2711', '0'),
('271800', '', 'Autres titres.', '2718', '0'),
('272000', '', 'Titres immobilisés (droit de créance).', '272', '0'),
('272100', '', 'Obligations.', '2721', '0'),
('272200', '', 'Bons.', '2722', '0'),
('273000', '', 'Titres immobilisés de l&#039;activité de portefeuille.', '273', '0'),
('274000', '', 'Prêts.', '274', '0'),
('274100', '', 'Prêts participatifs.', '2741', '0'),
('274200', '', 'Prêts aux associés.', '2742', '0'),
('274300', '', 'Prêts au personnel.', '2743', '0'),
('274800', '', 'Autres prêts.', '2748', '0'),
('275000', '', 'Dépôts et cautionnements versés.', '275', '0'),
('275100', '', 'Dépôts.', '2751', '0'),
('275500', '', 'Cautionnements.', '2755', '0'),
('276000', '', 'Autres créances immobilisées.', '276', '0'),
('276100', '', 'Créances diverses.', '2761', '0'),
('276800', '', 'Intérêts courus.', '2768', '0'),
('276820', '', 'Sur titres immobilisés (droit de créance).', '27682', '0'),
('276840', '', 'Sur prêts.', '27684', '0'),
('276850', '', 'Sur dépôts et cautionnements.', '27685', '0'),
('276880', '', 'Sur créances diverses.', '27688', '0'),
('277000', '', 'Actions propres ou parts propres.', '277', '0'),
('277100', '', 'Actions propres ou parts propres.', '2771', '0'),
('277200', '', 'Actions propres ou parts propres en voie d&#039;annulat', '2772', '0'),
('279000', '', 'Versements restant à effectuer sur titres immobili', '279', '0'),
('280000', '', 'Amortissements des immobilisations incorporelles.', '280', '0'),
('280100', '', 'Frais d&#039;établissement (même ventilation que celle ', '2801', '0'),
('280300', '', 'Frais de recherche et de développement.', '2803', '0'),
('280500', '', 'Concessions et droits similaires, brevets, licence', '2805', '0'),
('280700', '', 'Fonds commercial.', '2807', '0'),
('280800', '', 'Autres immobilisations incorporelles.', '2808', '0'),
('281000', '', 'Amortissements des immobilisations corporelles.', '281', '0'),
('281100', '', 'Terrains de gisement.', '2811', '0'),
('281200', '', 'Agencements, aménagements de terrains (même ventil', '2812', '0'),
('281300', '', 'Constructions (même ventilation que celle du compt', '2813', '0'),
('281400', '', 'Constructions sur sol d&#039;autrui (même ventilation q', '2814', '0'),
('281500', '', 'Installations techniques, matériel et outillage in', '2815', '0'),
('281800', '', 'Autres immobilisations corporelles (même ventilati', '2818', '0'),
('282000', '', 'Amortissements des immobilisations mises en conces', '282', '0'),
('290000', '', 'Provisions pour dépréciation des immobilisations i', '290', '0'),
('290500', '', 'Marques, procédés, droits et valeurs similaires.', '2905', '0'),
('290600', '', 'Droit au bail.', '2906', '0'),
('290700', '', 'Fonds commercial.', '2907', '0'),
('290800', '', 'Autres immobilisations incorporelles.', '2908', '0'),
('291000', '', 'Dépréciations des immobilisations corporelles (mêm', '291', '0'),
('291100', '', 'Terrains (autres que terrains de gisement).', '2911', '0'),
('292000', '', 'Dépréciations des immobilisations mises en concess', '292', '0'),
('293000', '', 'Dépréciations des immobilisations en cours.', '293', '0'),
('293100', '', 'Immobilisations corporelles en cours.', '2931', '0'),
('293200', '', 'Immobilisations incorporelles en cours.', '2932', '0'),
('296000', '', 'Dépréciations des participations et créances ratta', '296', '0'),
('296100', '', 'Titres de participation.', '2961', '0'),
('296600', '', 'Autres formes de participation.', '2966', '0'),
('296700', '', 'Créances rattachées à des participations (même ven', '2967', '0'),
('296800', '', 'Créances rattachées à des sociétés en participatio', '2968', '0'),
('297000', '', 'Dépréciations des autres immobilisations financièr', '297', '0'),
('297100', '', 'Titres immobilisés autres que les titres immobilis', '2971', '0'),
('297200', '', 'Titres immobilisés - droit de créance (même ventil', '2972', '0'),
('297300', '', 'Titres immobilisés de l&#039;activité de portefeuille.', '2973', '0'),
('297400', '', 'Prêts (même ventilation que celle du compte 274).', '2974', '0'),
('297500', '', 'Dépôts et cautionnements versés (même ventilation ', '2975', '0'),
('297600', '', 'Autres créances immobilisées (même ventilation que', '2976', '0'),
('310000', '', 'Matières premières (et fournitures).', '31', '0'),
('311000', '', 'Matière (ou groupe) A.', '311', '0'),
('312000', '', 'Matière (ou groupe) B.', '312', '0'),
('317000', '', 'Fournitures A, B, C...', '317', '0'),
('320000', '', 'Autres approvisionnements.', '32', '0'),
('321000', '', 'Matières consommables.', '321', '0'),
('321100', '', 'Matière (ou groupe) C.', '3211', '0'),
('321200', '', 'Matière (ou groupe) D.', '3212', '0'),
('322000', '', 'Fournitures consommables.', '322', '0'),
('322100', '', 'Combustibles.', '3221', '0'),
('322200', '', 'Produits d&#039;entretien.', '3222', '0'),
('322300', '', 'Fournitures d&#039;atelier et d&#039;usine.', '3223', '0'),
('322400', '', 'Fournitures de magasin.', '3224', '0'),
('322500', '', 'Fournitures de bureau.', '3225', '0'),
('326000', '', 'Emballages.', '326', '0'),
('326100', '', 'Emballages perdus.', '3261', '0'),
('326500', '', 'Emballages récupérables non identifiables.', '3265', '0'),
('326700', '', 'Emballages à usage mixte.', '3267', '0'),
('330000', '', 'En-cours de production de biens.', '33', '0'),
('331000', '', 'Produits en cours.', '331', '0'),
('331100', '', 'Produits en cours P 1.', '3311', '0'),
('331200', '', 'Produits en cours P 2.', '3312', '0'),
('335000', '', 'Travaux en cours.', '335', '0'),
('335100', '', 'Travaux en cours T 1.', '3351', '0'),
('335200', '', 'Travaux en cours T 2.', '3352', '0'),
('340000', '', 'En-cours de production de services.', '34', '0'),
('341000', '', 'Etudes en cours.', '341', '0'),
('341100', '', 'Etude en cours E 1.', '3411', '0'),
('341200', '', 'Etude en cours E 2.', '3412', '0'),
('345000', '', 'Prestations de services en cours.', '345', '0'),
('345100', '', 'Prestation de services S 1.', '3451', '0'),
('345200', '', 'Prestation de services S 2.', '3452', '0'),
('350000', '', 'Stocks de produits.', '35', '0'),
('351000', '', 'Produits intermédiaires.', '351', '0'),
('351100', '', 'Produit intermédiaire (ou groupe) A.', '3511', '0'),
('351200', '', 'Produit intermédiaire (ou groupe) B.', '3512', '0'),
('355000', '', 'Produits finis.', '355', '0'),
('355100', '', 'Produit fini (ou groupe) A.', '3551', '0'),
('355200', '', 'Produit fini (ou groupe) B.', '3552', '0'),
('358000', '', 'Produits résiduels (ou matières de récupération).', '358', '0'),
('358100', '', 'Déchets.', '3581', '0'),
('358500', '', 'Rebuts.', '3585', '0'),
('358600', '', 'Matières de récupération.', '3586', '0'),
('360000', '', 'Stocks provenant d&#039;immobilisations.', '36', '0'),
('370000', '', 'Stocks de marchandises.', '37', '0'),
('371000', '', 'Marchandise (ou groupe) A.', '371', '0'),
('372000', '', 'Marchandise (ou groupe) B.', '372', '0'),
('380000', '', 'Stocks en voie d&#039;acheminement, mis en dépôt ou don', '38', '0'),
('390000', '', 'Dépréciations des stocks et en-cours.', '39', '0'),
('391000', '', 'Dépréciations des matières premières (et fournitur', '391', '0'),
('391100', '', 'Matière (ou groupe) A.', '3911', '0'),
('391200', '', ' Matière (ou groupe) B.', '3912', '0'),
('391700', '', 'Fourniture A, B, C...', '3917', '0'),
('392000', '', 'Dépréciations des autres approvisionnements.', '392', '0'),
('392100', '', 'Matières consommables (même ventilation que celle ', '3921', '0'),
('392200', '', 'Fournitures consommables (même ventilation que cel', '3922', '0'),
('392600', '', 'Emballages (même ventilation que celle du compte 3', '3926', '0'),
('393000', '', 'Dépréciations des en-cours de production de biens.', '393', '0'),
('393100', '', 'Produits en cours (même ventilation que celle du c', '3931', '0'),
('393500', '', 'Travaux en cours (même ventilation que celle du co', '3935', '0'),
('394000', '', 'Dépréciations des en-cours de production de servic', '394', '0'),
('394100', '', 'Etudes en cours (même ventilation que celle du com', '3941', '0'),
('394500', '', 'Prestations de services en cours (même ventilation', '3945', '0'),
('395000', '', 'Dépréciations des stocks de produits.', '395', '0'),
('395100', '', 'Produits intermédiaires (même ventilation que cell', '3951', '0'),
('395500', '', 'Produits finis (même ventilation que celle du comp', '3955', '0'),
('397000', '', 'Dépréciations des stocks de marchandises.', '397', '0'),
('397100', '', 'Marchandise (ou groupe) A.', '3971', '0'),
('397200', '', 'Marchandise (ou groupe) B.', '3972', '0'),
('400000', '', 'Fournisseurs et comptes rattachés.', '40', '0'),
('401000', '', 'Fournisseurs.', '401', '0'),
('401100', '', 'Fournisseurs - Achats de biens ou de prestations d', '4011', '0'),
('401700', '', 'Fournisseurs - Retenues de garantie.', '4017', '0'),
('403000', '', 'Fournisseurs - Effets à payer.', '403', '0'),
('404000', '', 'Fournisseurs d&#039;immobilisations.', '404', '0'),
('404100', '', 'Fournisseurs - Achats d&#039;immobilisations.', '4041', '0'),
('404700', '', 'Fournisseurs d&#039;immobilisations - Retenues de garan', '4047', '0'),
('405000', '', 'Fournisseurs d&#039;immobilisations - Effets à payer.', '405', '0'),
('408000', '', 'Fournisseurs - Factures non parvenues.', '408', '0'),
('408100', '', 'Fournisseurs.', '4081', '0'),
('408400', '', 'Fournisseurs d&#039;immobilisations.', '4084', '0'),
('408800', '', 'Fournisseurs - Intérêts courus.', '4088', '0'),
('409000', '', 'Fournisseurs débiteurs.', '409', '0'),
('409100', '', 'Fournisseurs - Avances et acomptes versés sur comm', '4091', '0'),
('409600', '', 'Fournisseurs - Créances pour emballages et matérie', '4096', '0'),
('409700', '', 'Fournisseurs - Autres avoirs.', '4097', '0'),
('409710', '', 'Fournisseurs d&#039;exploitation.', '40971', '0'),
('409740', '', 'Fournisseurs d&#039;immobilisation.', '40974', '0'),
('409800', '', 'Rabais, remises, ristournes à obtenir et autres av', '4098', '0'),
('410000', '', 'Clients et comptes rattachés.', '41', '0'),
('411000', '', 'Clients et comptes rattachés.', '410', '0'),
('411100', '', 'Clients.', '411', '0'),
('411700', '', 'Clients - Ventes de biens ou de prestations de ser', '4111', '0'),
('413000', '', 'Clients - Retenues de garantie.', '4117', '0'),
('416000', '', 'Clients - Effets à recevoir.', '413', '0'),
('417000', '', 'Clients douteux ou litigieux.', '416', '0'),
('418000', '', 'Clients - Produits non encore facturés.', '418', '0'),
('418100', '', 'Clients - Factures à établir.', '4181', '0'),
('418800', '', 'Clients - Intérêts courus.', '4188', '0'),
('419000', '', 'Clients créditeurs.', '419', '0'),
('419100', '', 'Clients - Avances et acomptes reçus sur commandes.', '4191', '0'),
('419600', '', 'Clients - Dettes pour emballages et matériel consi', '4196', '0'),
('419700', '', 'Clients - Autres avoirs.', '4197', '0'),
('419800', '', 'Rabais, remises, ristournes à accorder et autres a', '4198', '0'),
('420000', '', 'Personnel et comptes rattachés.', '42', '0'),
('421000', '', 'Personnel - Rémunérations dues.', '421', '0'),
('422000', '', 'Comités d&#039;entreprise, d&#039;établissement...', '422', '0'),
('424000', '', 'Participation des salariés aux résultats.', '424', '0'),
('424600', '', 'Réserve spéciale (C. tr. art. L 442-2).', '4246', '0'),
('424800', '', 'Comptes courants.', '4248', '0'),
('425000', '', 'Personnel - Avances et acomptes.', '425', '0'),
('426000', '', 'Personnel - Dépôts.', '426', '0'),
('427000', '', 'Personnel - Opposition.', '427', '0'),
('428000', '', 'Personnel - Charges à payer et produits à recevoir', '428', '0'),
('428200', '', 'Dettes provisionnées pour congés à payer.', '4282', '0'),
('428400', '', 'Dettes provisionnées pour participation des salari', '4284', '0'),
('428600', '', 'Autres charges à payer.', '4286', '0'),
('428700', '', 'Produits à recevoir.', '4287', '0'),
('430000', '', 'Sécurité sociale et autres organismes sociaux.', '43', '0'),
('431000', '', 'Sécurité sociale.', '431', '0'),
('437000', '', 'Autres organismes sociaux.', '437', '0'),
('438000', '', 'Organismes sociaux - Charges à payer et produits à', '438', '0'),
('438200', '', 'Charges sociales sur congés à payer.', '4382', '0'),
('438600', '', 'Autres charges à payer.', '4386', '0'),
('438700', '', 'Produits à recevoir.', '4387', '0'),
('440000', '', 'Etat et autres collectivités publiques.', '44', '0'),
('441000', '', 'Etat - Subventions à recevoir.', '441', '0'),
('441100', '', 'Subventions d&#039;investissement.', '4411', '0'),
('441700', '', 'Subventions d&#039;exploitation.', '4417', '0'),
('441800', '', 'Subventions d&#039;équilibre.', '4418', '0'),
('441900', '', 'Avances sur subventions.', '4419', '0'),
('442000', '', 'Etat - Impôts recouvrables sur des tiers.', '442', '0'),
('442400', '', 'Obligataires.', '4424', '0'),
('442500', '', 'Associés.', '4425', '0'),
('443000', '', 'Opérations particulières avec l&#039;Etat, les collecti', '443', '0'),
('443100', '', 'Créance sur l&#039;Etat résultant de la suppression de ', '4431', '0'),
('443800', '', 'Intérêts courus sur créance figurant au compte 443', '4438', '0'),
('444000', '', 'Etat - Impôts sur les bénéfices.', '444', '0'),
('445000', '', 'Etat - Taxes sur le chiffre d&#039;affaires.', '445', '0'),
('445200', '', 'TVA due intracommunautaire.', '4452', '0'),
('445500', '', 'Taxes sur le chiffre d&#039;affaires à décaisser.', '4455', '0'),
('445510', '', 'TVA à décaisser.', '44551', '0'),
('445580', '', 'Taxes assimilées à la TVA.', '44558', '0'),
('445600', '', 'Taxes sur le chiffre d&#039;affaires déductibles.', '4456', '0'),
('445620', '', 'TVA sur immobilisations.', '44562', '0'),
('445630', '', 'TVA transférée sur d&#039;autres entreprises.', '44563', '0'),
('445660', '', 'TVA sur autres biens et services.', '44566', '0'),
('445670', '', 'Crédit de TVA à reporter.', '44567', '0'),
('445680', '', 'Taxes assimilées à la TVA.', '44568', '0'),
('445700', '', 'Taxes sur le chiffre d&#039;affaires collectées par l&#039;e', '4457', '0'),
('445710', '', 'TVA collectée.', '44571', '0'),
('445780', '', 'Taxes assimilées à la TVA.', '44578', '0'),
('445800', '', 'Taxes sur le chiffre d&#039;affaires à régulariser ou e', '4458', '0'),
('445810', '', 'Acomptes - Régime simplifié d&#039;imposition.', '44581', '0'),
('445820', '', 'Acomptes - Régime de forfait.', '44582', '0'),
('445830', '', 'Remboursement de taxes sur le chiffre d&#039;affaires d', '44583', '0'),
('445840', '', 'TVA récupérée d&#039;avance.', '44584', '0'),
('445860', '', 'Taxes sur le chiffre d&#039;affaires sur factures non p', '44586', '0'),
('445870', '', 'Taxes sur le chiffre d&#039;affaires sur factures à éta', '44587', '0'),
('446000', '', 'Obligations cautionnées.', '446', '0'),
('447000', '', 'Obligations cautionnées.', '4461', '0'),
('448000', '', 'Autres impôts, taxes et versements assimilés.', '447', '0'),
('448200', '', 'Etat - Charges à payer et produits à recevoir.', '448', '0'),
('448600', '', 'Charges fiscales sur congés à payer.', '4482', '0'),
('448700', '', 'Charges à payer.', '4486', '0'),
('450000', '', 'Produits à recevoir.', '4487', '0'),
('451000', '', 'Quotas d&#039;émission à restituer à l&#039;Etat.', '449', '0'),
('455000', '', 'Groupe et associés.', '45', '0'),
('455100', '', 'Groupe.', '451', '0'),
('455800', '', 'Associés - Comptes courants.', '455', '0'),
('456000', '', 'Principal.', '4551', '0'),
('456100', '', 'Intérêts courus.', '4558', '0'),
('456110', '', 'Associés - Opérations sur le capital.', '456', '0'),
('456150', '', 'Apports en nature.', '45611', '0'),
('456200', '', 'Apports en numéraire.', '45615', '0'),
('456210', '', 'Apporteurs - Capital appelé, non versé.', '4562', '0'),
('456250', '', 'Actionnaires - Capital souscrit et appelé, non ver', '45621', '0'),
('456300', '', 'Associés - Capital appelé, non versé.', '45625', '0'),
('456400', '', 'Associés - Versements reçus sur augmentation de ca', '4563', '0'),
('456600', '', 'Associés - Versements anticipés.', '4564', '0'),
('456700', '', 'Actionnaires défaillants.', '4566', '0'),
('457000', '', 'Associés - Capital à rembourser.', '4567', '0'),
('458000', '', 'Associés - Dividendes à payer.', '457', '0'),
('458100', '', 'Associés - Opérations faites en commun et en GIE.', '458', '0'),
('458800', '', 'Opérations courantes.', '4581', '0'),
('460000', '', 'Intérêts courus.', '4588', '0'),
('462000', '', 'Débiteurs divers et créditeurs divers.', '46', '0'),
('464000', '', 'Créances sur cessions d&#039;immobilisations.', '462', '0'),
('465000', '', 'Dettes sur acquisition de valeurs mobilières de pl', '464', '0'),
('467000', '', 'Créances sur cessions de valeurs mobilières de pla', '465', '0'),
('468000', '', 'Autres comptes débiteurs ou créditeurs.', '467', '0'),
('468600', '', 'Divers - Charges à payer et produits à recevoir.', '468', '0'),
('468700', '', 'Charges à payer.', '4686', '0'),
('470000', '', 'Produits à recevoir.', '4687', '0'),
('471000', '', 'Comptes transitoires ou d&#039;attente.', '47', '0'),
('476000', '', 'Différences de conversion - Actif.', '476', '0'),
('476100', '', 'Diminution des créances.', '4761', '0'),
('476200', '', 'Augmentation des dettes.', '4762', '0'),
('476800', '', 'Différences compensées par couverture de change.', '4768', '0'),
('477000', '', 'Différences de conversion - Passif.', '477', '0'),
('477100', '', 'Augmentation des créances.', '4771', '0'),
('477200', '', 'Diminution des dettes.', '4772', '0'),
('477800', '', 'Différences compensées par couverture de change.', '4778', '0'),
('478000', '', 'Autres comptes transitoires.', '478', '0'),
('480000', '', 'Comptes de régularisation.', '48', '0'),
('481000', '', 'Charges à répartir sur plusieurs exercices.', '481', '0'),
('481600', '', 'Frais d&#039;émission des emprunts.', '4816', '0'),
('486000', '', 'Charges constatées d&#039;avance.', '486', '0'),
('487000', '', 'Produits constatés d&#039;avance.', '487', '0'),
('488000', '', 'Comptes de répartition périodique des charges et d', '488', '0'),
('488600', '', 'Charges.', '4886', '0'),
('488700', '', 'Produits.', '4887', '0'),
('489000', '', 'Quotas d&#039;émission alloués par l&#039;Etat.', '489', '0'),
('490000', '', 'Dépréciations des comptes de tiers.', '49', '0'),
('491000', '', 'Dépréciations des comptes de clients.', '491', '0'),
('495000', '', 'Dépréciations des comptes du groupe et des associé', '495', '0'),
('495100', '', 'Comptes du groupe.', '4951', '0'),
('495500', '', 'Comptes courants des associés.', '4955', '0'),
('495800', '', 'Opérations faites en commun et en GIE.', '4958', '0'),
('496000', '', 'Dépréciations des comptes de débiteurs divers.', '496', '0'),
('496200', '', 'Créances sur cessions d&#039;immobilisations.', '4962', '0'),
('496500', '', 'Créances sur cessions de valeurs mobilières de pla', '4965', '0'),
('496700', '', 'Autres comptes débiteurs.', '4967', '0'),
('500000', '', 'Valeurs mobilières de placement.', '50', '0'),
('501000', '', 'Parts dans des entreprises liées.', '501', '0'),
('502000', '', 'Actions propres.', '502', '0'),
('503000', '', 'Actions.', '503', '0'),
('503100', '', 'Titres cotés.', '5031', '0'),
('503500', '', 'Titres non cotés.', '5035', '0'),
('504000', '', 'Autres titres conférant un droit de propriété.', '504', '0'),
('505000', '', 'Obligations et bons émis par la société et racheté', '505', '0'),
('506000', '', 'Obligations.', '506', '0'),
('506100', '', 'Titres cotés.', '5061', '0'),
('506500', '', 'Titres non cotés.', '5065', '0'),
('507000', '', 'Bons du Trésor et bons de caisse à court terme.', '507', '0'),
('508000', '', 'Autres valeurs mobilières de placement et autres c', '508', '0'),
('508100', '', 'Autres valeurs mobilières.', '5081', '0'),
('508200', '', 'Bons de souscription.', '5082', '0'),
('508800', '', 'Intérêts courus sur obligations, bons et valeurs assimilées', '5088', '0'),
('509000', '', 'Versements restant à effectuer sur valeurs mobiliè', '509', '0'),
('510000', '', 'Banques, établissements financiers et assimilés.', '51', '0'),
('511000', '', 'Valeurs à l&#039;encaissement.', '511', '0'),
('511100', '', 'Coupons échus à l&#039;encaissement.', '5111', '0'),
('511200', '', 'Chèques à encaisser.', '5112', '0'),
('511300', '', 'Effets à l&#039;encaissement.', '5113', '0'),
('511400', '', 'Effets à l&#039;escompte.', '5114', '0'),
('512000', '', 'Banques.', '512', '0'),
('512100', '', 'Comptes en monnaie nationale.', '5121', '0'),
('512400', '', 'Comptes en devises.', '5124', '0'),
('514000', '', 'Chèques postaux.', '514', '0'),
('515000', '', 'Caisses du Trésor et des établissements public', '515', '0'),
('516000', '', 'Sociétés de bourse.', '516', '0'),
('517000', '', 'Autres organismes financiers.', '517', '0'),
('518000', '', 'Intérêts courus.', '518', '0'),
('518100', '', 'Intérêts courus à payer.', '5181', '0'),
('518800', '', 'Intérêts courus à recevoir.', '5188', '0'),
('519000', '', 'Concours bancaires courants.', '519', '0'),
('519100', '', 'Crédit de mobilisation de créances commerciales (C', '5191', '0'),
('519300', '', 'Mobilisations de créances nées à l&#039;étranger.', '5193', '0'),
('519800', '', 'Intérêts courus sur concours bancaires courants', '5198', '0'),
('520000', '', 'Instruments de trésorerie.', '52', '0'),
('530000', '', 'Caisse.', '53', '0'),
('531000', '', 'Caisse siège social.', '531', '0'),
('531100', '', 'Caisse en monnaie nationale.', '5311', '0'),
('531400', '', 'Caisse en devises.', '5314', '0'),
('532000', '', 'Caisse succursale (ou usine) A.', '532', '0'),
('533000', '', 'Caisse succursale (ou usine) B.', '533', '0'),
('540000', '', 'Régies d&#039;avances et accréditifs.', '54', '0'),
('580000', '', 'Virements internes.', '58', '0'),
('590000', '', 'Dépréciations des valeurs mobilières de placement.', '590', '0'),
('590300', '', 'Actions.', '5903', '0'),
('590400', '', 'Autres titres conférant un droit de propriété.', '5904', '0'),
('590600', '', 'Obligations.', '5906', '0'),
('590800', '', 'Autres valeurs mobilières de placement et créances', '5908', '0'),
('600000', '', 'Achats (sauf 603)', '60', '0'),
('601000', '', 'Achats stockés - Matières premières (et fourniture', '601', '0'),
('601100', '', 'Matière (ou groupe) A.', '6011', '0'),
('601200', '', 'Matière (ou groupe) B.', '6012', '0'),
('601700', '', 'Fournitures A, B, C...', '6017', '0'),
('602000', '', 'Achats stockés - Autres approvisionnements.', '602', '0'),
('602100', '', 'Matières consommables.', '6021', '0'),
('602110', '', 'Matière (ou groupe) C.', '60211', '0'),
('602120', '', 'Matière (ou groupe) D.', '60212', '0'),
('602200', '', 'Fournitures consommables.', '6022', '0'),
('602210', '', 'Combustibles.', '60221', '0'),
('602220', '', 'Produits d&#039;entretien.', '60222', '0'),
('602230', '', 'Fournitures d&#039;atelier et d&#039;usine.', '60223', '0'),
('602240', '', 'Fournitures de magasin.', '60224', '0'),
('602250', '', 'Fournitures de bureau.', '60225', '0'),
('602600', '', 'Emballages.', '6026', '0'),
('602610', '', 'Emballages perdus.', '60261', '0'),
('602650', '', 'Emballages récupérables non identifiables.', '60265', '0'),
('602670', '', 'Emballages à usage mixte.', '60267', '0'),
('603000', '', 'Variation des stocks (approvisionnements et marcha', '603', '0'),
('603100', '', 'Variation des stocks de matières premières (et fou', '6031', '0'),
('603200', '', 'Variation des stocks des autres approvisionnements', '6032', '0'),
('603700', '', 'Variation des stocks de marchandises.', '6037', '0'),
('604000', '', 'Achats d&#039;études et prestations de services.', '604', '0'),
('605000', '', 'Achats de matériel, équipements et travaux.', '605', '0'),
('606000', '', 'Achats non stockés de matières et fournitures.', '606', '0'),
('606100', '', 'Fournitures non stockables (eau, énergie...).', '6061', '0'),
('606300', '', 'Fournitures d&#039;entretien et de petit équipement.', '6063', '0'),
('606400', '', 'Fournitures administratives.', '6064', '0'),
('606800', '', 'Autres matières et fournitures.', '6068', '0'),
('607000', '', 'Achats de marchandises.', '607', '0'),
('607100', '', 'Marchandise (ou groupe) A.', '6071', '0'),
('607200', '', 'Marchandise (ou groupe) B.', '6072', '0'),
('608000', '', 'Frais accessoires d&#039;achat.', '608', '0'),
('609000', '', 'Rabais, remises et ristournes obtenus sur achats.', '609', '0'),
('609100', '', 'Rabais, remises et ristournes obtenus sur achats de matières', '6091', '0'),
('609200', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;autr', '6092', '0'),
('609400', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;étud', '6094', '0'),
('609500', '', 'Rabais, remises et ristournes obtenus sur achats de matériel', '6095', '0'),
('609600', '', 'Rabais, remises et ristournes obtenus sur achats d&#039;appr', '6096', '0'),
('609700', '', 'Rabais, remises et ristournes obtenus sur achats de marchand', '6097', '0'),
('609800', '', 'Rabais, remises et ristournes non affectés.', '6098', '0'),
('610000', '', 'Services extérieurs.', '61', '0'),
('611000', '', 'Sous-traitance générale.', '611', '0'),
('612000', '', 'Redevances de crédit-bail.', '612', '0'),
('612200', '', 'Crédit-bail mobilier.', '6122', '0'),
('612500', '', 'Crédit-bail immobilier.', '6125', '0'),
('613000', '', 'Locations.', '613', '0'),
('613200', '', 'Locations immobilières.', '6132', '0'),
('613500', '', 'Locations mobilières.', '6135', '0'),
('613600', '', 'Malis sur emballages.', '6136', '0'),
('614000', '', 'Charges locatives et de copropriété.', '614', '0'),
('615000', '', 'Entretien et réparations.', '615', '0'),
('615200', '', 'Entretien et réparations sur biens immobiliers.', '6152', '0'),
('615500', '', 'Entretien et réparations sur biens mobiliers.', '6155', '0'),
('615600', '', 'Maintenance.', '6156', '0'),
('616000', '', 'Primes d&#039;assurance.', '616', '0'),
('616100', '', 'Multirisques.', '6161', '0'),
('616200', '', 'Assurance obligatoire dommage-construction.', '6162', '0'),
('616300', '', 'Assurance transport.', '6163', '0'),
('616360', '', 'Assurance transport sur achats.', '61636', '0'),
('616370', '', 'Assurance transport sur ventes.', '61637', '0'),
('616380', '', 'Assurance transport sur autres biens.', '61638', '0'),
('616400', '', 'Risques d&#039;exploitation.', '6164', '0'),
('616500', '', 'Insolvabilité clients.', '6165', '0'),
('617000', '', 'Etudes et recherches.', '617', '0'),
('618000', '', 'Divers.', '618', '0'),
('618100', '', 'Documentation générale.', '6181', '0'),
('618300', '', 'Documentation technique.', '6183', '0'),
('618500', '', 'Frais de colloques, séminaires, conférences, formations.', '6185', '0'),
('619000', '', 'Rabais, remises et ristournes obtenus sur services', '619', '0'),
('620000', '', 'Autres services extérieurs.', '62', '0'),
('621000', '', 'Personnel extérieur à l&#039;entreprise.', '621', '0'),
('621100', '', 'Personnel intérimaire.', '6211', '0'),
('621400', '', 'Personnel détaché ou prêté à l&#039;entreprise.', '6214', '0'),
('622000', '', 'Rémunérations d&#039;intermédiaires et honoraires.', '622', '0'),
('622100', '', 'Commissions et courtages sur achats.', '6221', '0'),
('622200', '', 'Commissions et courtages sur ventes.', '6222', '0'),
('622400', '', 'Rémunérations des transitaires.', '6224', '0'),
('622500', '', 'Rémunérations d&#039;affacturage.', '6225', '0'),
('622600', '', 'Honoraires.', '6226', '0'),
('622700', '', 'Frais d&#039;actes et de contentieux.', '6227', '0'),
('622800', '', 'Divers.', '6228', '0'),
('623000', '', 'Publicité, publications, relations publiques.', '623', '0'),
('623100', '', 'Annonces et insertions.', '6231', '0'),
('623200', '', 'Echantillons.', '6232', '0'),
('623300', '', 'Foires et expositions.', '6233', '0'),
('623400', '', 'Cadeaux à la clientèle.', '6234', '0'),
('623500', '', 'Primes.', '6235', '0'),
('623600', '', 'Catalogues et imprimés.', '6236', '0'),
('623700', '', 'Publications.', '6237', '0'),
('623800', '', 'Divers (pourboires, dons courants...).', '6238', '0'),
('624000', '', 'Transports de biens et transports collectifs du pe', '624', '0'),
('624100', '', 'Transports sur achats.', '6241', '0'),
('624200', '', 'Transports sur ventes.', '6242', '0'),
('624300', '', 'Transports entre établissements ou chantiers.', '6243', '0'),
('624400', '', 'Transports administratifs.', '6244', '0'),
('624700', '', 'Transports collectifs du personnel.', '6247', '0'),
('624800', '', 'Divers.', '6248', '0'),
('625000', '', 'Déplacements, missions et réceptions.', '625', '0'),
('625100', '', 'Voyages et déplacements.', '6251', '0'),
('625500', '', 'Frais de déménagement.', '6255', '0'),
('625600', '', 'Missions.', '6256', '0'),
('625700', '', 'Réceptions.', '6257', '0'),
('626000', '', 'Frais postaux et frais de télécommunications.', '626', '0'),
('627000', '', 'Services bancaires et assimilés.', '627', '0'),
('627100', '', 'Frais sur titres (achats, vente, garde).', '6271', '0'),
('627200', '', 'Commissions et frais sur émission d&#039;emprunts.', '6272', '0'),
('627500', '', 'Frais sur effets.', '6275', '0'),
('627600', '', 'Location de coffres.', '6276', '0'),
('627800', '', 'Autres frais et commissions sur prestations de ser', '6278', '0'),
('628000', '', 'Divers.', '628', '0'),
('628100', '', 'Concours divers (cotisations...).', '6281', '0'),
('628400', '', 'Frais de recrutement de personnel.', '6284', '0'),
('629000', '', 'Rabais, remises et ristournes obtenus sur autres s', '629', '0'),
('630000', '', 'Impôts, taxes et versements assimilés.', '63', '0'),
('631000', '', 'Impôts, taxes et versements assimilés sur rémunération admin', '631', '0'),
('631100', '', 'Taxe sur les salaires.', '6311', '0'),
('631200', '', 'Taxe d&#039;apprentissage.', '6312', '0'),
('631300', '', 'Participation des employeurs à la formation profes', '6313', '0'),
('631400', '', 'Cotisation pour défaut d&#039;investissement obligatoir', '6314', '0'),
('631800', '', 'Autres.', '6318', '0'),
('633000', '', 'Impôts, taxes et versements assimilés sur rémunération Autre', '633', '0'),
('633100', '', 'Versement de transport.', '6331', '0'),
('633110', '', 'Taxe professionnelle.', '63511', '0'),
('633200', '', 'Allocation logement.', '6332', '0'),
('633300', '', 'Participation des employeurs à la formation professionnelle ', '6333', '0'),
('633400', '', 'Participation des employeurs à l&#039;effort de constru', '6334', '0'),
('633500', '', 'Versements libératoires ouvrant droit à l&#039;exonérat', '6335', '0'),
('633800', '', 'Autres.', '6338', '0'),
('635000', '', 'Autres impôts, taxes et versements assimilés (admi', '635', '0'),
('635100', '', 'Impôts directs (sauf impôts sur les bénéfices).', '6351', '0'),
('635120', '', 'Taxes foncières.', '63512', '0'),
('635130', '', 'Autres impôts locaux.', '63513', '0'),
('635140', '', 'Taxe sur les véhicules des sociétés.', '63514', '0'),
('635200', '', 'Taxes sur le chiffre d&#039;affaires non récupérables.', '6352', '0'),
('635300', '', 'Impôts indirects.', '6353', '0'),
('635400', '', 'Droits d&#039;enregistrement et de timbre.', '6354', '0'),
('635410', '', 'Droits de mutation.', '63541', '0'),
('635800', '', 'Autres droits.', '6358', '0'),
('637000', '', 'Autres impôts, taxes et versements assimilés (autr', '637', '0'),
('637100', '', 'Contribution sociale de solidarité à la charge des', '6371', '0'),
('637200', '', 'Taxes perçues par les organismes publics internati', '6372', '0'),
('637300', '', 'CSG/CRDS déductible IR', '6373', '0'),
('637400', '', 'Impôts et taxes exigibles à l&#039;étranger.', '6374', '0'),
('637800', '', 'Taxes diverses.', '6378', '0'),
('640000', '', 'Charges de personnel.', '64', '0'),
('641000', '', 'Rémunérations du personnel.', '641', '0'),
('641100', '', 'Salaires, appointements.', '6411', '0'),
('641200', '', 'Congés payés.', '6412', '0'),
('641300', '', 'Primes et gratifications.', '6413', '0'),
('641400', '', 'Indemnités et avantages divers.', '6414', '0'),
('641500', '', 'Supplément familial.', '6415', '0'),
('644000', '', 'Rémunération du travail de l&#039;exploitant.', '644', '0'),
('644100', '', 'CSG non déductible IR', '6441', '0'),
('645000', '', 'Charges de sécurité sociale et de prévoyance.', '645', '0'),
('645100', '', 'Cotisations à l&#039;Urssaf.', '6451', '0'),
('645200', '', 'Cotisations aux mutuelles.', '6452', '0'),
('645300', '', 'Cotisations aux caisses de retraites.', '6453', '0'),
('645400', '', 'Cotisations aux Assédic.', '6454', '0'),
('645800', '', 'Cotisations aux autres organismes sociaux.', '6458', '0'),
('646000', '', 'Cotisations sociales personnelles de l&#039;exploitant.', '646', '0'),
('646100', '', 'Cotisations Allocations familiales TNS', '6461', '0'),
('646200', '', 'Cotisations Maladie TNS', '6462', '0'),
('646300', '', 'Cotisations Viellesse TNS', '6463', '0'),
('647000', '', 'Autres charges sociales.', '647', '0'),
('647100', '', 'Prestations directes.', '6471', '0'),
('647200', '', 'Versements aux comités d&#039;entreprise et d&#039;établisse', '6472', '0'),
('647300', '', 'Versements aux comités d&#039;hygiène et de sécurité.', '6473', '0'),
('647400', '', 'Versements aux autres oeuvres sociales.', '6474', '0'),
('647500', '', 'Médecine du travail, pharmacie.', '6475', '0'),
('648000', '', 'Autres charges de personnel.', '648', '0'),
('650000', '', 'Autres charges de gestion courante.', '65', '0'),
('651000', '', 'Redevances pour concessions, brevets, licences, pr', '651', '0'),
('651100', '', 'Redevances pour concessions, brevets, licences, ma', '6511', '0'),
('651600', '', 'Droits d&#039;auteur et de reproduction.', '6516', '0'),
('651800', '', 'Autres droits et valeurs similaires.', '6518', '0'),
('653000', '', 'Jetons de présence.', '653', '0'),
('654000', '', 'Pertes sur créances irrécouvrables.', '654', '0'),
('654100', '', 'Créances de l&#039;exercice.', '6541', '0'),
('654400', '', 'Créances des exercices antérieurs.', '6544', '0'),
('655000', '', 'Quotes-parts de résultat sur opérations faites en ', '655', '0'),
('655100', '', 'Quote-part de bénéfice transférée (comptabilité du', '6551', '0'),
('655500', '', 'Quote-part de perte supportée (comptabilité des as', '6555', '0'),
('658000', '', 'Charges diverses de gestion courante.', '658', '0'),
('660000', '', 'Charges financières.', '66', '0'),
('661000', '', 'Charges d&#039;intérêts.', '661', '0'),
('661100', '', 'Intérêts des emprunts et dettes.', '6611', '0'),
('661160', '', 'Intérêts des emprunts et dettes assimilées.', '66116', '0'),
('661170', '', 'Intérêts des dettes rattachées à des participations.', '66117', '0'),
('661500', '', 'Intérêts des comptes courants et des dépôts crédit', '6615', '0'),
('661600', '', 'Intérêts bancaires et sur opérations de financemen', '6616', '0'),
('661700', '', 'Intérêts des obligations cautionnées.', '6617', '0'),
('661800', '', 'Intérêts des autres dettes.', '6618', '0'),
('661810', '', 'Intérêts des dettes commerciales.', '66181', '0'),
('661880', '', 'Intérêts des dettes diverses.', '66188', '0'),
('664000', '', 'Pertes sur créances liées à des participations.', '664', '0'),
('665000', '', 'Escomptes accordés.', '665', '0'),
('666000', '', 'Pertes de change.', '666', '0'),
('667000', '', 'Charges nettes sur cessions de valeurs mobilières ', '667', '0'),
('668000', '', 'Autres charges financières.', '668', '0'),
('670000', '', 'Charges exceptionnelles.', '67', '0'),
('671000', '', 'Charges exceptionnelles sur opérations de gestion.', '671', '0'),
('671100', '', 'Pénalités sur marchés (et dédits payés sur achats ', '6711', '0'),
('671200', '', 'Pénalités, amendes fiscales et pénales.', '6712', '0'),
('671300', '', 'Dons, libéralités.', '6713', '0'),
('671400', '', 'Créances devenues irrécouvrables dans l&#039;exercice.', '6714', '0'),
('671500', '', 'Subventions accordées.', '6715', '0'),
('671700', '', 'Rappel d&#039;impôts (autres qu&#039;impôts sur les bénéfice', '6717', '0'),
('671800', '', 'Autres charges exceptionnelles sur opérations de g', '6718', '0'),
('672000', '', 'Charges sur exercices antérieurs (en cours d&#039;exerc', '672', '0'),
('675000', '', 'Valeurs comptables des éléments d&#039;actif cédés.', '675', '0'),
('675100', '', 'Immobilisations incorporelles.', '6751', '0'),
('675200', '', 'Immobilisations corporelles.', '6752', '0'),
('675600', '', 'Immobilisations financières.', '6756', '0'),
('675800', '', 'Autres éléments d&#039;actif.', '6758', '0'),
('678000', '', 'Autres charges exceptionnelles.', '678', '0'),
('678100', '', 'Malis provenant de clauses d&#039;indexation.', '6781', '0'),
('678200', '', 'Lots.', '6782', '0'),
('678300', '', 'Malis provenant du rachat par l&#039;entreprise d&#039;actio', '6783', '0'),
('678800', '', 'Charges exceptionnelles diverses.', '6788', '0'),
('680000', '', 'Dotations aux amortissements, aux dépréciations et', '68', '0'),
('681000', '', 'Dotations aux amortissements, aux dépréciations et', '681', '0'),
('681100', '', 'Dotations aux amortissements des immobilisations i', '6811', '0'),
('681110', '', 'Dotations aux amortissements des Immobilisations incorporell', '68111', '0'),
('681120', '', 'Dotations aux amortissements des Immobilisations corporelles', '68112', '0'),
('681200', '', 'Dotations aux amortissements des charges d&#039;exploit', '6812', '0'),
('681500', '', 'Dotations aux provisions d&#039;exploitation.', '6815', '0');
INSERT INTO `0_chart_master` VALUES
('681600', '', 'Dotations aux dépréciations des immobilisations in', '6816', '0'),
('681610', '', 'Dotations aux dépréciations des Immobilisations incorporelle', '68161', '0'),
('681620', '', 'Dotations aux dépréciations des Immobilisations corporelles.', '68162', '0'),
('681700', '', 'Dotations aux dépréciations des actifs circulants.', '6817', '0'),
('681730', '', 'Dotations aux dépréciations de Stocks et en-cours.', '68173', '0'),
('681740', '', 'Dotations aux dépréciations de Créances.', '68174', '0'),
('686000', '', 'Dotations aux amortissements, aux dépréciations et', '686', '0'),
('686100', '', 'Dotations aux amortissements des primes de rembour', '6861', '0'),
('686500', '', 'Dotations aux provisions financières.', '6865', '0'),
('686600', '', 'Dotations aux dépréciations des éléments financier', '6866', '0'),
('686620', '', 'Immobilisations financières.', '68662', '0'),
('686650', '', 'Valeurs mobilières de placement.', '68665', '0'),
('686800', '', 'Autres dotations.', '6868', '0'),
('687000', '', 'Dotations aux amortissements et aux provisions - C', '687', '0'),
('687100', '', 'Dotations aux amortissements exceptionnels des imm', '6871', '0'),
('687200', '', 'Dotations aux provisions réglementées (immobilisat', '6872', '0'),
('687250', '', 'Amortissements dérogatoires.', '68725', '0'),
('687300', '', 'Dotations aux provisions réglementées (stocks).', '6873', '0'),
('687400', '', 'Dotations aux autres provisions réglementées.', '6874', '0'),
('687500', '', 'Dotations aux provisions exceptionnelles.', '6875', '0'),
('687600', '', 'Dotations aux dépréciations exceptionnelles.', '6876', '0'),
('690000', '', 'Participation des salariés - Impôts sur les bénéfi', '69', '0'),
('691000', '', 'Participation des salariés aux résultats.', '691', '0'),
('695000', '', 'Impôts sur les bénéfices.', '695', '0'),
('695100', '', 'Impôts dus en France.', '6951', '0'),
('695200', '', 'Contribution additionnelle à l&#039;impôt sur les bénéf', '6952', '0'),
('695400', '', 'Impôts dus à l&#039;étranger.', '6954', '0'),
('696000', '', 'Suppléments d&#039;impôt sur les sociétés liés aux dist', '696', '0'),
('697000', '', 'Imposition forfaitaire annuelle des sociétés.', '697', '0'),
('698000', '', 'Intégration fiscale d&#039;impôt (voir n° 2855).', '698', '0'),
('698100', '', 'Intégration fiscale - Charges.', '6981', '0'),
('698900', '', 'Intégration fiscale - Produits.', '6989', '0'),
('699000', '', 'Produits - report en arrière des déficits.', '699', '0'),
('700000', '', 'Ventes de produits fabriqués, prestations de servi', '70', '0'),
('701000', '', 'Ventes de produits finis.', '701', '0'),
('701100', '', 'Produit fini (ou groupe) A.', '7011', '0'),
('701200', '', 'Produit fini (ou groupe) B.', '7012', '0'),
('702000', '', 'Ventes de produits intermédiaires.', '702', '0'),
('703000', '', 'Ventes de produits résiduels.', '703', '0'),
('704000', '', 'Travaux.', '704', '0'),
('704100', '', 'Travaux de catégorie (ou activité) A.', '7041', '0'),
('704200', '', 'Travaux de catégorie (ou activité) B.', '7042', '0'),
('705000', '', 'Etudes.', '705', '0'),
('706000', '', 'Prestations de services.', '706', '0'),
('707000', '', 'Ventes de marchandises.', '707', '0'),
('707100', '', 'Marchandise (ou groupe) A.', '7071', '0'),
('707200', '', 'Marchandise (ou groupe) B.', '7072', '0'),
('708000', '', 'Produits des activités annexes.', '708', '0'),
('708100', '', 'Produits des services exploités dans l&#039;intérêt du perso', '7081', '0'),
('708200', '', 'Commissions et courtages.', '7082', '0'),
('708300', '', 'Locations diverses.', '7083', '0'),
('708400', '', 'Mise à disposition de personnel facturée.', '7084', '0'),
('708500', '', 'Ports et frais accessoires facturés.', '7085', '0'),
('708600', '', 'Bonis sur reprises d&#039;emballages consignés.', '7086', '0'),
('708700', '', 'Bonifications obtenues des clients et primes sur v', '7087', '0'),
('708800', '', 'Autres produits d&#039;activités annexes (cessions d&#039;ap', '7088', '0'),
('709000', '', 'Rabais, remises et ristournes accordés par l&#039;entre', '709', '0'),
('709100', '', '- sur ventes de produits finis.', '7091', '0'),
('709200', '', '- sur ventes de produits intermédiaires.', '7092', '0'),
('709400', '', '- sur travaux.', '7094', '0'),
('709500', '', '- sur études.', '7095', '0'),
('709600', '', '- sur prestations de services.', '7096', '0'),
('709700', '', '- sur ventes de marchandises.', '7097', '0'),
('709800', '', '- sur produits des activités annexes.', '7098', '0'),
('710000', '', 'Production stockée (ou déstockage).', '71', '0'),
('713000', '', 'Variation des stocks (en-cours de production, prod', '713', '0'),
('713300', '', 'Variation des en-cours de production de biens.', '7133', '0'),
('713310', '', 'Produits en cours.', '71331', '0'),
('713350', '', 'Travaux en cours.', '71335', '0'),
('713400', '', 'Variation des en-cours de production de services.', '7134', '0'),
('713410', '', 'Etudes en cours.', '71341', '0'),
('713450', '', 'Prestations de services en cours.', '71345', '0'),
('713500', '', 'Variation des stocks de produits.', '7135', '0'),
('713510', '', 'Produits intermédiaires.', '71351', '0'),
('713550', '', 'Produits finis.', '71355', '0'),
('713580', '', 'Produits résiduels.', '71358', '0'),
('720000', '', 'Production immobilisée. ', '72', '0'),
('721000', '', 'Immobilisations incorporelles.', '721', '0'),
('722000', '', 'Immobilisations corporelles.', '722', '0'),
('740000', '', 'Subventions d&#039;exploitation.', '74', '0'),
('750000', '', 'Autres produits de gestion courante.', '75', '0'),
('751000', '', 'Redevances pour concessions, brevets, licences, ma', '751', '0'),
('751100', '', 'Redevances pour concessions, brevets, licences, ma', '7511', '0'),
('751600', '', 'Droits d&#039;auteur et de reproduction.', '7516', '0'),
('751800', '', 'Autres droits et valeurs similaires.', '7518', '0'),
('752000', '', 'Revenus des immeubles non affectés aux activités p', '752', '0'),
('753000', '', 'Jetons de présence et rémunérations d&#039;administrate', '753', '0'),
('754000', '', 'Ristournes perçues des coopératives (provenant des', '754', '0'),
('755000', '', 'Quotes-parts de résultat sur opérations faites en ', '755', '0'),
('755100', '', 'Quote-part de perte transférée (comptabilité du gé', '7551', '0'),
('755500', '', 'Quote-part de bénéfice attribuée (comptabilité des', '7555', '0'),
('758000', '', 'Produits divers de gestion courante.', '758', '0'),
('760000', '', 'Produits financiers. ', '76', '0'),
('761000', '', 'Produits de participations.', '761', '0'),
('761100', '', 'Revenus des titres de participation.', '7611', '0'),
('761600', '', 'Revenus sur autres formes de participation.', '7616', '0'),
('761700', '', 'Revenus de créances rattachées à des participation', '7617', '0'),
('762000', '', 'Produits des autres immobilisations financières.', '762', '0'),
('762100', '', 'Revenus des titres immobilisés.', '7621', '0'),
('762600', '', 'Revenus des prêts.', '7624', '0'),
('762700', '', 'Revenus des créances immobilisées.', '7627', '0'),
('763000', '', 'Revenus des autres créances.', '763', '0'),
('763100', '', 'Revenus des créances commerciales.', '7631', '0'),
('763800', '', 'Revenus des créances diverses.', '7638', '0'),
('764000', '', 'Revenus des valeurs mobilières de placement.', '764', '0'),
('765000', '', 'Escomptes obtenus.', '765', '0'),
('766000', '', 'Gains de change.', '766', '0'),
('767000', '', 'Produits nets sur cessions de valeurs mobilières de placemen', '767', '0'),
('768000', '', 'Autres produits financiers.', '768', '0'),
('770000', '', 'Produits exceptionnels. ', '77', '0'),
('771000', '', 'Produits exceptionnels sur opérations de gestion.', '771', '0'),
('771100', '', 'Dédits et pénalités perçus sur achats et sur vente', '7711', '0'),
('771300', '', 'Libéralités perçues.', '7713', '0'),
('771400', '', 'Rentrées sur créances amorties.', '7714', '0'),
('771500', '', 'Subventions d&#039;équilibre.', '7715', '0'),
('771700', '', 'Dégrèvement d&#039;impôts autres qu&#039;impôts sur les béné', '7717', '0'),
('771800', '', 'Autres produits exceptionnels sur opérations de ge', '7718', '0'),
('772000', '', 'Produits sur exercices antérieurs (en cours d&#039;exer', '772', '0'),
('775000', '', 'Produits des cessions d&#039;éléments d&#039;actif.', '775', '0'),
('775100', '', 'Immobilisations incorporelles.', '7751', '0'),
('775200', '', 'Immobilisations corporelles.', '7752', '0'),
('775600', '', 'Immobilisations financières.', '7756', '0'),
('775800', '', 'Autres éléments d&#039;actif.', '7758', '0'),
('777000', '', 'Quote-part des subventions d&#039;investissement virée ', '777', '0'),
('778000', '', 'Autres produits exceptionnels.', '778', '0'),
('778100', '', 'Bonis provenant de clauses d&#039;indexation.', '7781', '0'),
('778200', '', 'Lots.', '7782', '0'),
('778300', '', 'Bonis provenant du rachat par l&#039;entreprise d&#039;actio', '7783', '0'),
('778800', '', 'Produits exceptionnels divers.', '7788', '0'),
('780000', '', 'Reprises sur amortissements, aux dépréciations et ', '78', '0'),
('781000', '', 'Reprises sur amortissements et provisions (à inscr', '781', '0'),
('781100', '', 'Reprises sur amortissements des immobilisations in', '7811', '0'),
('781110', '', 'Immobilisations incorporelles.', '78111', '0'),
('781120', '', 'Immobilisations corporelles.', '78112', '0'),
('781500', '', 'Reprises sur provisions d&#039;exploitation.', '7815', '0'),
('781600', '', 'Reprise sur dépréciations des immobilisations inco', '7816', '0'),
('781610', '', 'Immobilisations incorporelles.', '78161', '0'),
('781620', '', 'Immobilisations corporelles.', '78162', '0'),
('781700', '', 'Reprises sur dépréciations des actifs circulants.', '7817', '0'),
('781730', '', 'Stocks et en-cours.', '78173', '0'),
('781740', '', 'Créances.', '78174', '0'),
('786000', '', 'Reprises sur provisions pour risques et dépréciati', '786', '0'),
('786500', '', 'Reprises sur provisions financières.', '7865', '0'),
('786600', '', 'Reprises sur dépréciations des éléments financiers', '7866', '0'),
('786620', '', 'Immobilisations financières.', '78662', '0'),
('786650', '', 'Valeurs mobilières de placement.', '78665', '0'),
('787000', '', 'Reprises sur provisions et dépréciations (à inscri', '787', '0'),
('787200', '', 'Reprises sur provisions réglementées (immobilisati', '7872', '0'),
('787250', '', 'Amortissements dérogatoires.', '78725', '0'),
('787260', '', 'Provision spéciale de réévaluation.', '78726', '0'),
('787270', '', 'Plus-values réinvesties.', '78727', '0'),
('787300', '', 'Reprises sur provisions réglementées (stocks).', '7873', '0'),
('787400', '', 'Reprises sur autres provisions réglementées.', '7874', '0'),
('787500', '', 'Reprises sur provisions exceptionnelles.', '7875', '0'),
('787600', '', 'Reprises sur dépréciations exceptionnelles.', '7876', '0'),
('790000', '', 'Transferts de charges. ', '79', '0'),
('791000', '', 'Transferts de charges d&#039;exploitation.', '791', '0'),
('796000', '', 'Transferts de charges financières.', '796', '0'),
('797000', '', 'Transferts de charges exceptionnelles.', '797', '0'),
('800000', '', 'Engagements', '80', '0'),
('801000', '', 'Engagements donnés par l’entité', '801', '0'),
('801100', '', 'Avals, cautions, garanties.', '8011', '0'),
('801400', '', 'Effets circulant sous l’endos de l’entité.', '8014', '0'),
('801600', '', 'Redevances crédit-bail restant à courir.', '8016', '0'),
('801610', '', 'Redevances crédit-bail mobilier restant à courir.', '80161', '0'),
('801650', '', 'Redevances crédit-bail immobilier restant à courir.', '80165', '0'),
('801800', '', 'Autres engagements donnés.', '8018', '0'),
('802000', '', 'Engagements reçus par l’entité', '802', '0'),
('802100', '', 'Avals, cautions, garanties.', '8021', '0'),
('802400', '', 'Créances escomptées non échues.', '8024', '0'),
('802600', '', 'Engagements reçus pour utilisation en crédit-bail.', '8026', '0'),
('802610', '', 'Engagements reçus pour utilisation en crédit-bail mobilier.', '80261', '0'),
('802650', '', 'Engagements reçus pour utilisation en crédit-bail immobilier', '80265', '0'),
('802800', '', 'Autres engagements reçus.', '8028', '0'),
('809000', '', 'Contrepartie des engagements', '809', '0'),
('809100', '', 'Contrepartie 801', '8091', '0'),
('809200', '', 'Contrepartie 802', '8092', '0'),
('880000', '', 'Résultat en instance d&#039;affectation.', '88', '0'),
('890000', '', 'Bilan d&#039;ouverture.', '890', '0'),
('891000', '', 'Bilan de clôture.', '891', '0');

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
('10', '10 Capital et réserves.', '1', '', '0'),
('101', '101 Capital.', '1', '101', '0'),
('1011', '1011 Capital souscrit - non appelé.', '1', '101', '0'),
('1012', '1012 Capital souscrit - appelé, non versé.', '1', '101', '0'),
('1013', '1013 Capital souscrit - appelé, versé.', '1', '101', '0'),
('10131', '10131 Capital non amorti.', '1', '1013', '0'),
('10132', '10132 Capital amorti.', '1', '1013', '0'),
('1018', '1018 Capital souscrit soumis à des réglementations part', '1', '101', '0'),
('104', '104 Primes liées au capital social.', '1', '10', '0'),
('1041', '1041 Primes d&#039;émission.', '1', '104', '0'),
('1042', '1042 Primes de fusion.', '1', '104', '0'),
('1043', '1043 Primes d&#039;apport.', '1', '104', '0'),
('1044', '1044 Primes de conversion d&#039;obligations en actions.', '1', '104', '0'),
('1045', '1045 Bons de souscription d&#039;actions.', '1', '104', '0'),
('105', '105 Ecarts de réévaluation.', '1', '10', '0'),
('1051', '1051 Réserve spéciale de réévaluation.', '1', '105', '0'),
('1052', '1052 Ecart de réévaluation libre.', '1', '105', '0'),
('1053', '1053 Réserve de réévaluation.', '1', '105', '0'),
('1055', '1055 Ecarts de réévaluation (autres opérations légales)', '1', '105', '0'),
('1057', '1057 Autres écarts de réévaluation en France.', '1', '105', '0'),
('1058', '1058 Autres écarts de réévaluation à l&#039;étranger.', '1', '105', '0'),
('106', '106 Réserves.', '1', '10', '0'),
('1061', '1061 Réserve légale.', '1', '106', '0'),
('10611', '10611 Réserve légale proprement dite.', '1', '1061', '0'),
('10612', '10612 Plus-values nettes à long terme.', '1', '1061', '0'),
('1062', '1062 Réserves indisponibles.', '1', '106', '0'),
('1063', '1063 Réserves statutaires ou contractuelles.', '1', '106', '0'),
('1064', '1064 Réserves réglementées.', '1', '106', '0'),
('10641', '10641 Plus-values nettes à long terme.', '1', '1064', '0'),
('10643', '10643 Réserves consécutives à l&#039;octroi de subventions d', '1', '1064', '0'),
('10648', '10648 Autres réserves réglementées.', '1', '1064', '0'),
('1068', '1068 Autres réserves.', '1', '106', '0'),
('10681', '10681 Réserve de propre assureur.', '1', '1068', '0'),
('10688', '10688 Réserves diverses.', '1', '1068', '0'),
('107', '107 Ecart d&#039;équivalence.', '1', '10', '0'),
('108', '108 Compte de l&#039;exploitant.', '1', '10', '0'),
('109', '109 Actionnaires : Capital souscrit - non appelé.', '1', '10', '0'),
('11', '11 Report à nouveau (solde créditeur ou débiteur).', '1', '', '0'),
('110', '110 Report à nouveau (solde créditeur).', '1', '11', '0'),
('119', '119 Report à nouveau (solde débiteur).', '1', '11', '0'),
('12', '12 Résultat de l&#039;exercice (bénéfice ou perte).', '1', '', '0'),
('120', '120 Résultat de l&#039;exercice (bénéfice).', '1', '12', '0'),
('129', '129 Résultat de l&#039;exercice (perte).', '1', '12', '0'),
('13', '13 Subventions d&#039;investissement.', '1', '', '0'),
('131', '131 Subventions d&#039;équipement.', '1', '13', '0'),
('1311', '1311 Etat.', '1', '131', '0'),
('1312', '1312 Régions.', '1', '131', '0'),
('1313', '1313 Départements.', '1', '131', '0'),
('1314', '1314 Communes.', '1', '131', '0'),
('1315', '1315 Collectivités publiques.', '1', '131', '0'),
('1316', '1316 Entreprises publiques.', '1', '131', '0'),
('1317', '1317 Entreprises et organismes privés.', '1', '131', '0'),
('1318', '1318 Autres.', '1', '131', '0'),
('138', '138 Autres subventions d&#039;investissement.', '1', '13', '0'),
('139', '139 Subventions d&#039;investissement inscrites au compte d', '1', '13', '0'),
('1391', '1391 Subventions d&#039;équipement.', '1', '139', '0'),
('13911', '13911 Etat.', '1', '1391', '0'),
('13912', '13912 Régions.', '1', '1391', '0'),
('13913', '13913 Départements.', '1', '1391', '0'),
('13914', '13914 Communes.', '1', '1391', '0'),
('13915', '13915 Collectivités publiques.', '1', '1391', '0'),
('13916', '13916 Entreprises publiques.', '1', '1391', '0'),
('13917', '13917 Entreprises et organismes privés.', '1', '1391', '0'),
('13918', '13918 Autres.', '1', '1391', '0'),
('1398', '1398 Autres subventions d&#039;investissement.', '1', '139', '0'),
('14', '14 Provisions réglementées.', '1', '', '0'),
('142', '142 Provisions réglementées relatives aux immobilisati', '1', '14', '0'),
('1423', '1423 Provision pour reconstitution desgisements miniers', '1', '142', '0'),
('1424', '1424 Provision pour investissement(participation des sa', '1', '142', '0'),
('143', '143 Provisions réglementées relatives aux stocks.', '1', '14', '0'),
('1431', '1431 Hausse des prix.', '1', '143', '0'),
('1432', '1432 Fluctuation des cours.', '1', '143', '0'),
('144', '144 Provisions réglementées relatives aux autres éléme', '1', '14', '0'),
('145', '145  Amortissements dérogatoires.', '1', '14', '0'),
('146', '146 Provision spéciale de réévaluation.', '1', '14', '0'),
('147', '147 Plus-values réinvesties.', '1', '14', '0'),
('148', '148 Autres provisions réglementées.', '1', '14', '0'),
('15', '15 Provisions.', '1', '', '0'),
('151', '151 Provisions pour risques.', '1', '15', '0'),
('1511', '1511 Provisions pour litiges.', '1', '151', '0'),
('1512', '1512 Provisions pour garanties données aux clients.', '1', '151', '0'),
('1513', '1513 Provisions pour pertes sur marchés à terme.', '1', '151', '0'),
('1514', '1514 Provisions pour amendes et pénalités.', '1', '151', '0'),
('1515', '1515 Provisions pour pertes de change.', '1', '151', '0'),
('1516', '1516 Provisions pour pertes sur contrats.', '1', '151', '0'),
('1518', '1518 Autres provisions pour risques.', '1', '151', '0'),
('153', '153 Provisions pour pensions et obligations similaires', '1', '15', '0'),
('154', '154 Provisions pour restructurations.', '1', '15', '0'),
('155', '155 Provisions pour impôts.', '1', '15', '0'),
('156', '156 Provisions pour renouvellement des immobilisations', '1', '15', '0'),
('157', '157 Provisions pour charges à répartir sur plusieurs e', '1', '15', '0'),
('1572', '1572 Provisions pour gros entretien ou grandes révision', '1', '15', '0'),
('158', '158 Autres provisions pour charges.', '1', '158', '0'),
('1581', '1581 Provisions pour remise en état.', '1', '158', '0'),
('16', '16 Emprunts et dettes assimilées.', '1', '', '0'),
('161', '161 Emprunts obligataires convertibles.', '1', '16', '0'),
('163', '163 Autres emprunts obligataires.', '1', '16', '0'),
('164', '164 Emprunts auprès des établissements de crédit.', '1', '16', '0'),
('165', '165 Dépôts et cautionnements reçus.', '1', '16', '0'),
('1651', '1651 Dépôts.', '1', '165', '0'),
('1655', '1655 Cautionnements.', '1', '165', '0'),
('166', '166 Participation des salariés aux résultats.', '1', '16', '0'),
('1661', '1661 Comptes bloqués.', '1', '166', '0'),
('1662', '1662 Fonds de participation.', '1', '166', '0'),
('167', '167 Emprunts et dettes assortis de conditions particul', '1', '16', '0'),
('1671', '1671 Emissions de titres participatifs.', '1', '167', '0'),
('1674', '1674 Avances conditionnées de l&#039;Etat.', '1', '167', '0'),
('1675', '1675 Emprunts participatifs.', '1', '16', '0'),
('168', '168 Autres emprunts et dettes assimilées.', '1', '168', '0'),
('1681', '1681 Autres emprunts.', '1', '168', '0'),
('1685', '1685 Rentes viagères capitalisées.', '1', '168', '0'),
('1687', '1687 Autres dettes.', '1', '168', '0'),
('1688', '1688 Intérêts courus.', '1', '168', '0'),
('16881', '16881 Sur emprunts obligataires convertibles.', '1', '1688', '0'),
('16884', '16884 Sur emprunts auprès des établissements de crédit.', '1', '1688', '0'),
('16885', '16885 Sur dépôts et cautionnements reçus.', '1', '1688', '0'),
('16886', '16886 Sur participation des salariés aux résultats.', '1', '1688', '0'),
('16887', '16887 Sur emprunts et dettes assortis de conditions part', '1', '1688', '0'),
('16888', '16888 Sur autres emprunts et dettes assimilées.', '1', '1688', '0'),
('169', '169 Primes de remboursement des obligations.', '1', '16', '0'),
('17', '17 Dettes rattachées à des participations.', '1', '', '0'),
('171', '171 Dettes rattachées à des participations (groupe).', '1', '17', '0'),
('174', '174 Dettes rattachées à des participation (hors groupe', '1', '17', '0'),
('178', '178 Dettes rattachées à des sociétés en participation.', '1', '17', '0'),
('1781', '1781 Principal.', '1', '178', '0'),
('1788', '1788 Intérêts courus.', '1', '178', '0'),
('18', '18 Comptes de liaison des établissements et sociétés ', '1', '', '0'),
('181', '181 Compte de liaison des établissements.', '1', '18', '0'),
('186', '186 Biens et prestations de services échangés entre ét', '1', '18', '0'),
('187', '187 Biens et prestations de services échangés entre ét', '1', '18', '0'),
('188', '188 Comptes de liaison des sociétés en participation.', '1', '18', '0'),
('20', '20 Immobilisations incorporelles.', '2', '', '0'),
('201', '201 Frais d&#039;établissement.', '2', '20', '0'),
('2011', '2011 Frais de constitution.', '2', '201', '0'),
('2012', '2012 Frais de premier établissement.', '2', '201', '0'),
('20121', '20121 Frais de prospection.', '2', '2012', '0'),
('20122', '20122 Frais de publicité.', '2', '2012', '0'),
('2013', '2013 Frais d&#039;augmentation de capital et d&#039;opératio', '2', '201', '0'),
('203', '203 Frais de recherche et de développement.', '2', '20', '0'),
('205', '205 Concessions et droits similaires, brevets, licence', '2', '20', '0'),
('206', '206 Droit au bail.', '2', '20', '0'),
('207', '207 Fonds commercial.', '2', '20', '0'),
('208', '208 Autres immobilisations incorporelles.', '2', '20', '0'),
('21', '21 Immobilisations corporelles.', '2', '', '0'),
('211', '211 Terrains.', '2', '21', '0'),
('2111', '2111 Terrains nus.', '2', '211', '0'),
('2112', '2112 Terrains aménagés.', '2', '211', '0'),
('2113', '2113 Sous-sols et sur-sols.', '2', '211', '0'),
('2114', '2114 Terrains de gisements.', '2', '211', '0'),
('21141', '21141 Carrières.', '2', '2114', '0'),
('2115', '2115 Terrains bâtis.', '2', '211', '0'),
('21151', '21151 Ensembles immobiliers industriels (A, B...).', '2', '2115', '0'),
('21155', '21155 Ensembles immobiliers administratifs et commerciau', '2', '2115', '0'),
('21158', '21158 Autres ensembles immobiliers.', '2', '2115', '0'),
('211581', '211581 Autres ensembles immobiliers affectés aux opérations ', '2', '21158', '0'),
('211588', '211588 Autres ensembles immobiliers affectés aux opérations ', '2', '21158', '0'),
('2116', '2116 Compte d&#039;ordre sur immobilisations (art. 6 du décr', '2', '21', '0'),
('212', '212 Agencements et aménagements de terrains.', '2', '212', '0'),
('213', '213 Constructions.', '2', '213', '0'),
('2131', '2131 Bâtiments.', '2', '2131', '0'),
('21311', '21311 Ensembles immobiliers industriels (A, B...).', '2', '2131', '0'),
('21315', '21315 Ensembles immobiliers administratifs et commerciau', '2', '21315', '0'),
('21318', '21318 Autres ensembles immobiliers.', '2', '21318', '0'),
('213181', '213181 Autres ensembles immobiliers affectés aux opérations ', '2', '213', '0'),
('213188', '213188 Autres ensembles immobiliers affectés aux opérations ', '2', '21', '0'),
('2135', '2135 Installations générales - Agencements-aménagements', '2', '213', '0'),
('2138', '2138 Ouvrages d&#039;infrastructure.', '2', '213', '0'),
('21381', '21381 Voies de terre.', '2', '2138', '0'),
('21382', '21382 Voies de fer.', '2', '2138', '0'),
('21383', '21383 Voies d&#039;eau.', '2', '2138', '0'),
('21384', '21384 Barrages.', '2', '2138', '0'),
('21385', '21385 Pistes d&#039;aérodrome.', '2', '2138', '0'),
('214', '214 Constructions sur sol d&#039;autrui.', '2', '21', '0'),
('215', '215 Installations techniques, matériel et outillage in', '2', '21', '0'),
('2151', '2151 Installations complexes spécialisées.', '2', '215', '0'),
('21511', '21511 Installations complexes spécialisées sur sol propre.', '2', '2151', '0'),
('21514', '21514 Installations complexes spécialisées sur sol d&#039;au', '2', '2151', '0'),
('2153', '2153 Installations à caractère spécifique.', '2', '215', '0'),
('21531', '21531 Installations à caractère spécifique sur sol propre.', '2', '2153', '0'),
('21534', '21534 Installations à caractère spécifique sur sol d&#039;au', '2', '2153', '0'),
('2154', '2154 Matériel industriel.', '2', '215', '0'),
('2155', '2155 Outillage industriel.', '2', '215', '0'),
('2157', '2157 Agencements et aménagements du matériel et outilla', '2', '215', '0'),
('218', '218 Autres immobilisations corporelles.', '2', '21', '0'),
('2181', '2181 Installations générales, agencements, aménagements', '2', '218', '0'),
('2182', '2182 Matériel de transport.', '2', '218', '0'),
('2183', '2183 Matériel de bureau et matériel informatique.', '2', '218', '0'),
('2184', '2184 Mobilier.', '2', '218', '0'),
('2185', '2185 Cheptel.', '2', '218', '0'),
('2186', '2186 Emballages récupérables.', '2', '218', '0'),
('22', '22 Immobilisations mises en concession.', '2', '', '0'),
('23', '23 Immobilisations en cours.', '2', '', '0'),
('231', '231  Immobilisations corporelles en cours.', '2', '23', '0'),
('2312', '2312 Terrains.', '2', '231', '0'),
('2313', '2313 Constructions.', '2', '231', '0'),
('2315', '2315 Installations techniques, matériel et outillage in', '2', '231', '0'),
('2318', '2318 Autres immobilisations corporelles.', '2', '231', '0'),
('232', '232 Immobilisations incorporelles en cours.', '2', '23', '0'),
('237', '237 Avances et acomptes versés sur immobilisations inc', '2', '23', '0'),
('238', '238 Avances et acomptes versés sur commandes d&#039;immobil', '2', '23', '0'),
('2382', '2382 Terrains.', '2', '238', '0'),
('2383', '2383 Constructions.', '2', '238', '0'),
('2385', '2385 Installations techniques, matériel et outillage in', '2', '238', '0'),
('2388', '2388 Autres immobilisations corporelles.', '2', '238', '0'),
('25', '25 Entreprises liées - Parts et créances.', '2', '', '0'),
('26', '26 Participations et créances rattachées à des partic', '2', '', '0'),
('261', '261 Titres de participation.', '2', '26', '0'),
('2611', '2611 Actions.', '2', '261', '0'),
('2618', '2618 Autres titres.', '2', '261', '0'),
('266', '266 Autres formes de participation.', '2', '26', '0'),
('267', '267 Créances rattachées à des participations.', '2', '26', '0'),
('2671', '2671 Créances rattachées à des participations (groupe).', '2', '267', '0'),
('2674', '2674 Créances rattachées à des participations (hors gro', '2', '267', '0'),
('2675', '2675 Versements représentatifs d&#039;apports non capitalisé', '2', '267', '0'),
('2676', '2676 Avances consolidables.', '2', '267', '0'),
('2677', '2677 Autres créances rattachées à des participations.', '2', '267', '0'),
('2678', '2678 Intérêts courus.', '2', '267', '0'),
('268', '268 Créances rattachées à des sociétés en participatio', '2', '26', '0'),
('2681', '2681 Principal.', '2', '268', '0'),
('2688', '2688 Intérêts courus.', '2', '268', '0'),
('269', '269 Versements restant à effectuer sur titres de parti', '2', '26', '0'),
('27', '27 Autres immobilisations financières.', '2', '', '0'),
('271', '271 Titres immobilisés autres que les titres immobilis', '2', '27', '0'),
('2711', '2711 Actions.', '2', '271', '0'),
('2718', '2718 Autres titres.', '2', '271', '0'),
('272', '272 Titres immobilisés (droit de créance).', '2', '27', '0'),
('2721', '2721 Obligations.', '2', '272', '0'),
('2722', '2722 Bons.', '2', '272', '0'),
('273', '273 Titres immobilisés de l&#039;activité de portefeuille.', '2', '27', '0'),
('274', '274 Prêts.', '2', '27', '0'),
('2741', '2741 Prêts participatifs.', '2', '274', '0'),
('2742', '2742 Prêts aux associés.', '2', '274', '0'),
('2743', '2743 Prêts au personnel.', '2', '274', '0'),
('2748', '2748 Autres prêts.', '2', '274', '0'),
('275', '275 Dépôts et cautionnements versés.', '2', '27', '0'),
('2751', '2751 Dépôts.', '2', '275', '0'),
('2755', '2755 Cautionnements.', '2', '275', '0'),
('276', '276 Autres créances immobilisées.', '2', '27', '0'),
('2761', '2761 Créances diverses.', '2', '276', '0'),
('2768', '2768 Intérêts courus.', '2', '276', '0'),
('27682', '27682 Sur titres immobilisés (droit de créance).', '2', '2768', '0'),
('27684', '27684 Sur prêts.', '2', '2768', '0'),
('27685', '27685 Sur dépôts et cautionnements.', '2', '2768', '0'),
('27688', '27688 Sur créances diverses.', '2', '2768', '0'),
('277', '277 Actions propres ou parts propres.', '2', '27', '0'),
('2771', '2771 Actions propres ou parts propres.', '2', '277', '0'),
('2772', '2772 Actions propres ou parts propres en voie d&#039;annulat', '2', '277', '0'),
('279', '279 Versements restant à effectuer sur titres immobili', '2', '27', '0'),
('28', '28 Amortissements des immobilisations.', '2', '', '0'),
('280', '280 Amortissements des immobilisations incorporelles.', '2', '28', '0'),
('2801', '2801 Frais d&#039;établissement (même ventilation que celle ', '2', '280', '0'),
('2803', '2803 Frais de recherche et de développement.', '2', '280', '0'),
('2805', '2805 Concessions et droits similaires, brevets, licence', '2', '280', '0'),
('2807', '2807 Fonds commercial.', '2', '280', '0'),
('2808', '2808 Autres immobilisations incorporelles.', '2', '280', '0'),
('281', '281 Amortissements des immobilisations corporelles.', '2', '28', '0'),
('2811', '2811 Terrains de gisement.', '2', '281', '0'),
('2812', '2812 Agencements, aménagements de terrains (même ventil', '2', '281', '0'),
('2813', '2813 Constructions (même ventilation que celle du compt', '2', '281', '0'),
('2814', '2814 Constructions sur sol d&#039;autrui (même ventilation q', '2', '281', '0'),
('2815', '2815 Installations techniques, matériel et outillage in', '2', '281', '0'),
('2818', '2818 Autres immobilisations corporelles (même ventilati', '2', '281', '0'),
('282', '282 Amortissements des immobilisations mises en conces', '2', '28', '0'),
('29', '29 Dépréciations des immobilisations.', '2', '', '0'),
('290', '290 Provisions pour dépréciation des immobilisations i', '2', '29', '0'),
('2905', '2905 Marques, procédés, droits et valeurs similaires.', '2', '290', '0'),
('2906', '2906 Droit au bail.', '2', '290', '0'),
('2907', '2907 Fonds commercial.', '2', '290', '0'),
('2908', '2908 Autres immobilisations incorporelles.', '2', '290', '0'),
('291', '291 Dépréciations des immobilisations corporelles (mêm', '2', '29', '0'),
('2911', '2911 Terrains (autres que terrains de gisement).', '2', '291', '0'),
('292', '292 Dépréciations des immobilisations mises en concess', '2', '29', '0'),
('293', '293 Dépréciations des immobilisations en cours.', '2', '29', '0'),
('2931', '2931 Immobilisations corporelles en cours.', '2', '293', '0'),
('2932', '2932 Immobilisations incorporelles en cours.', '2', '293', '0'),
('296', '296 Dépréciations des participations et créances ratta', '2', '29', '0'),
('2961', '2961 Titres de participation.', '2', '296', '0'),
('2966', '2966 Autres formes de participation.', '2', '296', '0'),
('2967', '2967 Créances rattachées à des participations (même ven', '2', '296', '0'),
('2968', '2968 Créances rattachées à des sociétés en participatio', '2', '296', '0'),
('297', '297 Dépréciations des autres immobilisations financièr', '2', '29', '0'),
('2971', '2971 Titres immobilisés autres que les titres immobilis', '2', '297', '0'),
('2972', '2972 Titres immobilisés - droit de créance (même ventil', '2', '297', '0'),
('2973', '2973 Titres immobilisés de l&#039;activité de portefeuille.', '2', '297', '0'),
('2974', '2974 Prêts (même ventilation que celle du compte 274).', '2', '297', '0'),
('2975', '2975 Dépôts et cautionnements versés (même ventilation ', '2', '297', '0'),
('2976', '2976 Autres créances immobilisées (même ventilation que', '2', '297', '0'),
('31', '31 Matières premières (et fournitures).', '3', '', '0'),
('311', '311 Matière (ou groupe) A.', '3', '31', '0'),
('312', '312 Matière (ou groupe) B.', '3', '31', '0'),
('317', '317 Fournitures A, B, C...', '3', '31', '0'),
('32', '32 Autres approvisionnements.', '3', '', '0'),
('321', '321 Matières consommables.', '3', '32', '0'),
('3211', '3211 Matière (ou groupe) C.', '3', '321', '0'),
('3212', '3212 Matière (ou groupe) D.', '3', '321', '0'),
('322', '322 Fournitures consommables.', '3', '32', '0'),
('3221', '3221 Combustibles.', '3', '322', '0'),
('3222', '3222 Produits d&#039;entretien.', '3', '322', '0'),
('3223', '3223 Fournitures d&#039;atelier et d&#039;usine.', '3', '322', '0'),
('3224', '3224 Fournitures de magasin.', '3', '322', '0'),
('3225', '3225 Fournitures de bureau.', '3', '322', '0'),
('326', '326 Emballages.', '3', '32', '0'),
('3261', '3261 Emballages perdus.', '3', '326', '0'),
('3265', '3265 Emballages récupérables non identifiables.', '3', '326', '0'),
('3267', '3267 Emballages à usage mixte.', '3', '326', '0'),
('33', '33 En-cours de production de biens.', '3', '', '0'),
('331', '331 Produits en cours.', '3', '33', '0'),
('3311', '3311 Produits en cours P 1.', '3', '331', '0'),
('3312', '3312 Produits en cours P 2.', '3', '331', '0'),
('335', '335 Travaux en cours.', '3', '33', '0'),
('3351', '3351 Travaux en cours T 1.', '3', '335', '0'),
('3352', '3352 Travaux en cours T 2.', '3', '335', '0'),
('34', '34 En-cours de production de services.', '3', '', '0'),
('341', '341 Etudes en cours.', '3', '34', '0'),
('3411', '3411 Etude en cours E 1.', '3', '341', '0'),
('3412', '3412 Etude en cours E 2.', '3', '341', '0'),
('345', '345 Prestations de services en cours.', '3', '34', '0'),
('3451', '3451 Prestation de services S 1.', '3', '345', '0'),
('3452', '3452 Prestation de services S 2.', '3', '345', '0'),
('35', '35 Stocks de produits.', '3', '', '0'),
('351', '351 Produits intermédiaires.', '3', '35', '0'),
('3511', '3511 Produit intermédiaire (ou groupe) A.', '3', '351', '0'),
('3512', '3512 Produit intermédiaire (ou groupe) B.', '3', '351', '0'),
('355', '355 Produits finis.', '3', '35', '0'),
('3551', '3551 Produit fini (ou groupe) A.', '3', '355', '0'),
('3552', '3552 Produit fini (ou groupe) B.', '3', '355', '0'),
('358', '358 Produits résiduels (ou matières de récupération).', '3', '35', '0'),
('3581', '3581 Déchets.', '3', '358', '0'),
('3585', '3585 Rebuts.', '3', '358', '0'),
('3586', '3586 Matières de récupération.', '3', '358', '0'),
('36', '36 Stocks provenant d&#039;immobilisations.', '3', '', '0'),
('37', '37 Stocks de marchandises.', '3', '', '0'),
('371', '371 Marchandise (ou groupe) A.', '3', '37', '0'),
('372', '372 Marchandise (ou groupe) B.', '3', '37', '0'),
('38', '38 Stocks en voie d&#039;acheminement, mis en dépôt ou don', '3', '', '0'),
('39', '39 Dépréciations des stocks et en-cours.', '3', '', '0'),
('391', '391 Dépréciations des matières premières (et fournitur', '3', '39', '0'),
('3911', '3911 Matière (ou groupe) A.', '3', '391', '0'),
('3912', '3912  Matière (ou groupe) B.', '3', '391', '0'),
('3917', '3917 Fourniture A, B, C...', '3', '391', '0'),
('392', '392 Dépréciations des autres approvisionnements.', '3', '39', '0'),
('3921', '3921 Matières consommables (même ventilation que celle ', '3', '392', '0'),
('3922', '3922 Fournitures consommables (même ventilation que cel', '3', '392', '0'),
('3926', '3926 Emballages (même ventilation que celle du compte 3', '3', '392', '0'),
('393', '393 Dépréciations des en-cours de production de biens.', '3', '39', '0'),
('3931', '3931 Produits en cours (même ventilation que celle du c', '3', '393', '0'),
('3935', '3935 Travaux en cours (même ventilation que celle du co', '3', '393', '0'),
('394', '394 Dépréciations des en-cours de production de servic', '3', '39', '0'),
('3941', '3941 Etudes en cours (même ventilation que celle du com', '3', '394', '0'),
('3945', '3945 Prestations de services en cours (même ventilation', '3', '394', '0'),
('395', '395 Dépréciations des stocks de produits.', '3', '39', '0'),
('3951', '3951 Produits intermédiaires (même ventilation que cell', '3', '395', '0'),
('3955', '3955 Produits finis (même ventilation que celle du comp', '3', '395', '0'),
('397', '397 Dépréciations des stocks de marchandises.', '3', '39', '0'),
('3971', '3971 Marchandise (ou groupe) A.', '3', '397', '0'),
('3972', '3972 Marchandise (ou groupe) B.', '3', '397', '0'),
('40', '40 Fournisseurs et comptes rattachés.', '4', '', '0'),
('401', '401 Fournisseurs.', '4', '40', '0'),
('4011', '4011 Fournisseurs - Achats de biens ou de prestations d', '4', '401', '0'),
('4017', '4017 Fournisseurs - Retenues de garantie.', '4', '401', '0'),
('403', '403 Fournisseurs - Effets à payer.', '4', '40', '0'),
('404', '404 Fournisseurs d&#039;immobilisations.', '4', '40', '0'),
('4041', '4041 Fournisseurs - Achats d&#039;immobilisations.', '4', '404', '0'),
('4047', '4047 Fournisseurs d&#039;immobilisations - Retenues de garan', '4', '404', '0'),
('405', '405 Fournisseurs d&#039;immobilisations - Effets à payer.', '4', '40', '0'),
('408', '408 Fournisseurs - Factures non parvenues.', '4', '40', '0'),
('4081', '4081 Fournisseurs.', '4', '408', '0'),
('4084', '4084 Fournisseurs d&#039;immobilisations.', '4', '408', '0'),
('4088', '4088 Fournisseurs - Intérêts courus.', '4', '408', '0'),
('409', '409 Fournisseurs débiteurs.', '4', '40', '0'),
('4091', '4091 Fournisseurs - Avances et acomptes versés sur comm', '4', '409', '0'),
('4096', '4096 Fournisseurs - Créances pour emballages et matérie', '4', '409', '0'),
('4097', '4097 Fournisseurs - Autres avoirs.', '4', '409', '0'),
('40971', '40971 Fournisseurs d&#039;exploitation.', '4', '4097', '0'),
('40974', '40974 Fournisseurs d&#039;immobilisation.', '4', '4097', '0'),
('4098', '4098 Rabais, remises, ristournes à obtenir et autres av', '4', '409', '0'),
('41', '41 Clients et comptes rattachés.', '4', '', '0'),
('410', '410 Clients et comptes rattachés.', '4', '41', '0'),
('411', '411 Clients.', '4', '411', '0'),
('4111', '4111 Clients - Ventes de biens ou de prestations de ser', '4', '411', '0'),
('4117', '4117 Clients - Retenues de garantie.', '4', '41', '0'),
('413', '413 Clients - Effets à recevoir.', '4', '41', '0'),
('416', '416 Clients douteux ou litigieux.', '4', '41', '0'),
('418', '418 Clients - Produits non encore facturés.', '4', '41', '0'),
('4181', '4181 Clients - Factures à établir.', '4', '418', '0'),
('4188', '4188 Clients - Intérêts courus.', '4', '418', '0'),
('419', '419 Clients créditeurs.', '4', '41', '0'),
('4191', '4191 Clients - Avances et acomptes reçus sur commandes.', '4', '419', '0'),
('4196', '4196 Clients - Dettes pour emballages et matériel consi', '4', '419', '0'),
('4197', '4197 Clients - Autres avoirs.', '4', '419', '0'),
('4198', '4198 Rabais, remises, ristournes à accorder et autres a', '4', '419', '0'),
('42', '42 Personnel et comptes rattachés.', '4', '', '0'),
('421', '421 Personnel - Rémunérations dues.', '4', '42', '0'),
('422', '422 Comités d&#039;entreprise, d&#039;établissement...', '4', '42', '0'),
('424', '424 Participation des salariés aux résultats.', '4', '42', '0'),
('4246', '4246 Réserve spéciale (C. tr. art. L 442-2).', '4', '424', '0'),
('4248', '4248 Comptes courants.', '4', '424', '0'),
('425', '425 Personnel - Avances et acomptes.', '4', '42', '0'),
('426', '426 Personnel - Dépôts.', '4', '42', '0'),
('427', '427 Personnel - Opposition.', '4', '42', '0'),
('428', '428 Personnel - Charges à payer et produits à recevoir', '4', '42', '0'),
('4282', '4282 Dettes provisionnées pour congés à payer.', '4', '428', '0'),
('4284', '4284 Dettes provisionnées pour participation des salari', '4', '428', '0'),
('4286', '4286 Autres charges à payer.', '4', '428', '0'),
('4287', '4287 Produits à recevoir.', '4', '428', '0'),
('43', '43 Sécurité sociale et autres organismes sociaux.', '4', '', '0'),
('431', '431 Sécurité sociale.', '4', '43', '0'),
('437', '437 Autres organismes sociaux.', '4', '43', '0'),
('438', '438 Organismes sociaux - Charges à payer et produits à', '4', '43', '0'),
('4382', '4382 Charges sociales sur congés à payer.', '4', '438', '0'),
('4386', '4386 Autres charges à payer.', '4', '438', '0'),
('4387', '4387 Produits à recevoir.', '4', '438', '0'),
('44', '44 Etat et autres collectivités publiques.', '4', '', '0'),
('441', '441 Etat - Subventions à recevoir.', '4', '44', '0'),
('4411', '4411 Subventions d&#039;investissement.', '4', '441', '0'),
('4417', '4417 Subventions d&#039;exploitation.', '4', '441', '0'),
('4418', '4418 Subventions d&#039;équilibre.', '4', '441', '0'),
('4419', '4419 Avances sur subventions.', '4', '441', '0'),
('442', '442 Etat - Impôts recouvrables sur des tiers.', '4', '44', '0'),
('4424', '4424 Obligataires.', '4', '442', '0'),
('4425', '4425 Associés.', '4', '442', '0'),
('443', '443 Opérations particulières avec l&#039;Etat, les collecti', '4', '44', '0'),
('4431', '4431 Créance sur l&#039;Etat résultant de la suppression de ', '4', '443', '0'),
('4438', '4438 Intérêts courus sur créance figurant au compte 443', '4', '443', '0'),
('444', '444 Etat - Impôts sur les bénéfices.', '4', '44', '0'),
('445', '445 Etat - Taxes sur le chiffre d&#039;affaires.', '4', '44', '0'),
('4452', '4452 TVA due intracommunautaire.', '4', '445', '0'),
('4455', '4455 Taxes sur le chiffre d&#039;affaires à décaisser.', '4', '445', '0'),
('44551', '44551 TVA à décaisser.', '4', '4455', '0'),
('44558', '44558 Taxes assimilées à la TVA.', '4', '4455', '0'),
('4456', '4456 Taxes sur le chiffre d&#039;affaires déductibles.', '4', '445', '0'),
('44562', '44562 TVA sur immobilisations.', '4', '4456', '0'),
('44563', '44563 TVA transférée sur d&#039;autres entreprises.', '4', '4456', '0'),
('44566', '44566 TVA sur autres biens et services.', '4', '4456', '0'),
('44567', '44567 Crédit de TVA à reporter.', '4', '4456', '0'),
('44568', '44568 Taxes assimilées à la TVA.', '4', '4456', '0'),
('4457', '4457 Taxes sur le chiffre d&#039;affaires collectées par l&amp;#', '4', '445', '0'),
('44571', '44571 TVA collectée.', '4', '4457', '0'),
('44578', '44578 Taxes assimilées à la TVA.', '4', '4457', '0'),
('4458', '4458 Taxes sur le chiffre d&#039;affaires à régulariser ou e', '4', '445', '0'),
('44581', '44581 Acomptes - Régime simplifié d&#039;imposition.', '4', '4458', '0'),
('44582', '44582 Acomptes - Régime de forfait.', '4', '4458', '0'),
('44583', '44583 Remboursement de taxes sur le chiffre d&#039;affaires ', '4', '4458', '0'),
('44584', '44584 TVA récupérée d&#039;avance.', '4', '4458', '0'),
('44586', '44586 Taxes sur le chiffre d&#039;affaires sur factures non ', '4', '4458', '0'),
('44587', '44587 Taxes sur le chiffre d&#039;affaires sur factures à ét', '4', '4458', '0'),
('446', '446 Obligations cautionnées.', '4', '44', '0'),
('4461', '4461 Obligations cautionnées.', '4', '44', '0'),
('447', '447 Autres impôts, taxes et versements assimilés.', '4', '44', '0'),
('448', '448 Etat - Charges à payer et produits à recevoir.', '4', '448', '0'),
('4482', '4482 Charges fiscales sur congés à payer.', '4', '448', '0'),
('4486', '4486 Charges à payer.', '4', '448', '0'),
('4487', '4487 Produits à recevoir.', '4', '', '0'),
('449', '449 Quotas d&#039;émission à restituer à l&#039;Etat.', '4', '44', '0'),
('45', '45 Groupe et associés.', '4', '45', '0'),
('451', '451 Groupe.', '4', '451', '0'),
('455', '455 Associés - Comptes courants.', '4', '455', '0'),
('4551', '4551 Principal.', '4', '45', '0'),
('4558', '4558 Intérêts courus.', '4', '455', '0'),
('456', '456 Associés - Opérations sur le capital.', '4', '456', '0'),
('45611', '45611 Apports en nature.', '4', '4561', '0'),
('45615', '45615 Apports en numéraire.', '4', '456', '0'),
('4562', '4562 Apporteurs - Capital appelé, non versé.', '4', '4562', '0'),
('45621', '45621 Actionnaires - Capital souscrit et appelé, non ver', '4', '4562', '0'),
('45625', '45625 Associés - Capital appelé, non versé.', '4', '456', '0'),
('4563', '4563 Associés - Versements reçus sur augmentation de ca', '4', '456', '0'),
('4564', '4564 Associés - Versements anticipés.', '4', '456', '0'),
('4566', '4566 Actionnaires défaillants.', '4', '456', '0'),
('4567', '4567 Associés - Capital à rembourser.', '4', '45', '0'),
('457', '457 Associés - Dividendes à payer.', '4', '45', '0'),
('458', '458 Associés - Opérations faites en commun et en GIE.', '4', '458', '0'),
('4581', '4581 Opérations courantes.', '4', '458', '0'),
('4588', '4588 Intérêts courus.', '4', '', '0'),
('46', '46 Débiteurs divers et créditeurs divers.', '4', '46', '0'),
('462', '462 Créances sur cessions d&#039;immobilisations.', '4', '46', '0'),
('464', '464 Dettes sur acquisition de valeurs mobilières de pl', '4', '46', '0'),
('465', '465 Créances sur cessions de valeurs mobilières de pla', '4', '46', '0'),
('467', '467 Autres comptes débiteurs ou créditeurs.', '4', '46', '0'),
('468', '468 Divers - Charges à payer et produits à recevoir.', '4', '468', '0'),
('4686', '4686 Charges à payer.', '4', '468', '0'),
('4687', '4687 Produits à recevoir.', '4', '', '0'),
('47', '47 Comptes transitoires ou d&#039;attente.', '4', '47', '0'),
('476', '476 Différences de conversion - Actif.', '4', '47', '0'),
('4761', '4761 Diminution des créances.', '4', '476', '0'),
('4762', '4762 Augmentation des dettes.', '4', '476', '0'),
('4768', '4768 Différences compensées par couverture de change.', '4', '476', '0'),
('477', '477 Différences de conversion - Passif.', '4', '47', '0'),
('4771', '4771 Augmentation des créances.', '4', '477', '0'),
('4772', '4772 Diminution des dettes.', '4', '477', '0'),
('4778', '4778 Différences compensées par couverture de change.', '4', '477', '0'),
('478', '478 Autres comptes transitoires.', '4', '47', '0'),
('48', '48 Comptes de régularisation.', '4', '', '0'),
('481', '481 Charges à répartir sur plusieurs exercices.', '4', '48', '0'),
('4816', '4816 Frais d&#039;émission des emprunts.', '4', '481', '0'),
('486', '486 Charges constatées d&#039;avance.', '4', '48', '0'),
('487', '487 Produits constatés d&#039;avance.', '4', '48', '0'),
('488', '488 Comptes de répartition périodique des charges et d', '4', '48', '0'),
('4886', '4886 Charges.', '4', '488', '0'),
('4887', '4887 Produits.', '4', '488', '0'),
('489', '489 Quotas d&#039;émission alloués par l&#039;Etat.', '4', '489', '0'),
('49', '49 Dépréciations des comptes de tiers.', '4', '', '0'),
('491', '491 Dépréciations des comptes de clients.', '4', '49', '0'),
('495', '495 Dépréciations des comptes du groupe et des associé', '4', '49', '0'),
('4951', '4951 Comptes du groupe.', '4', '495', '0'),
('4955', '4955 Comptes courants des associés.', '4', '495', '0'),
('4958', '4958 Opérations faites en commun et en GIE.', '4', '495', '0'),
('496', '496 Dépréciations des comptes de débiteurs divers.', '4', '49', '0'),
('4962', '4962 Créances sur cessions d&#039;immobilisations.', '4', '496', '0'),
('4965', '4965 Créances sur cessions de valeurs mobilières de pla', '4', '496', '0'),
('4967', '4967 Autres comptes débiteurs.', '4', '496', '0'),
('50', '50 Valeurs mobilières de placement.', '5', '', '0'),
('501', '501 Parts dans des entreprises liées.', '5', '50', '0'),
('502', '502 Actions propres.', '5', '50', '0'),
('503', '503 Actions.', '5', '50', '0'),
('5031', '5031 Titres cotés.', '5', '503', '0'),
('5035', '5035 Titres non cotés.', '5', '503', '0'),
('504', '504 Autres titres conférant un droit de propriété.', '5', '50', '0'),
('505', '505 Obligations et bons émis par la société et racheté', '5', '50', '0'),
('506', '506 Obligations.', '5', '50', '0'),
('5061', '5061 Titres cotés.', '5', '506', '0'),
('5065', '5065 Titres non cotés.', '5', '506', '0'),
('507', '507 Bons du Trésor et bons de caisse à court terme.', '5', '50', '0'),
('508', '508 Autres valeurs mobilières de placement et autres c', '5', '50', '0'),
('5081', '5081 Autres valeurs mobilières.', '5', '508', '0'),
('5082', '5082 Bons de souscription.', '5', '508', '0'),
('5088', '5088 Intérêts courus sur obligations, bons et valeurs assimi', '5', '508', '0'),
('509', '509 Versements restant à effectuer sur valeurs mobiliè', '5', '50', '0'),
('51', '51 Banques, établissements financiers et assimilés.', '5', '', '0'),
('511', '511 Valeurs à l&#039;encaissement.', '5', '51', '0'),
('5111', '5111 Coupons échus à l&#039;encaissement.', '5', '511', '0'),
('5112', '5112 Chèques à encaisser.', '5', '511', '0'),
('5113', '5113 Effets à l&#039;encaissement.', '5', '511', '0'),
('5114', '5114 Effets à l&#039;escompte.', '5', '511', '0'),
('512', '512 Banques.', '5', '51', '0'),
('5121', '5121 Comptes en monnaie nationale.', '5', '512', '0'),
('5124', '5124 Comptes en devises.', '5', '512', '0'),
('514', '514 Chèques postaux.', '5', '51', '0'),
('515', '515 Caisses du Trésor et des établissements public', '5', '51', '0'),
('516', '516 Sociétés de bourse.', '5', '51', '0'),
('517', '517 Autres organismes financiers.', '5', '51', '0'),
('518', '518 Intérêts courus.', '5', '51', '0'),
('5181', '5181 Intérêts courus à payer.', '5', '518', '0'),
('5188', '5188 Intérêts courus à recevoir.', '5', '518', '0'),
('519', '519 Concours bancaires courants.', '5', '51', '0'),
('5191', '5191 Crédit de mobilisation de créances commerciales (C', '5', '519', '0'),
('5193', '5193 Mobilisations de créances nées à l&#039;étranger.', '5', '519', '0'),
('5198', '5198 Intérêts courus sur concours bancaires courants', '5', '519', '0'),
('52', '52 Instruments de trésorerie.', '5', '', '0'),
('53', '53 Caisse.', '5', '', '0'),
('531', '531 Caisse siège social.', '5', '53', '0'),
('5311', '5311 Caisse en monnaie nationale.', '5', '531', '0'),
('5314', '5314 Caisse en devises.', '5', '531', '0'),
('532', '532 Caisse succursale (ou usine) A.', '5', '53', '0'),
('533', '533 Caisse succursale (ou usine) B.', '5', '53', '0'),
('54', '54 Régies d&#039;avances et accréditifs.', '5', '', '0'),
('58', '58 Virements internes.', '5', '', '0'),
('59', '59 Dépréciations des comptes financiers.', '5', '', '0'),
('590', '590 Dépréciations des valeurs mobilières de placement.', '5', '59', '0'),
('5903', '5903 Actions.', '5', '590', '0'),
('5904', '5904 Autres titres conférant un droit de propriété.', '5', '590', '0'),
('5906', '5906 Obligations.', '5', '590', '0'),
('5908', '5908 Autres valeurs mobilières de placement et créances', '5', '590', '0'),
('60', '60 Achats (sauf 603)', '6', '', '0'),
('601', '601 Achats stockés - Matières premières (et fourniture', '6', '60', '0'),
('6011', '6011 Matière (ou groupe) A.', '6', '601', '0'),
('6012', '6012 Matière (ou groupe) B.', '6', '601', '0'),
('6017', '6017 Fournitures A, B, C...', '6', '601', '0'),
('602', '602 Achats stockés - Autres approvisionnements.', '6', '60', '0'),
('6021', '6021 Matières consommables.', '6', '602', '0'),
('60211', '60211 Matière (ou groupe) C.', '6', '6021', '0'),
('60212', '60212 Matière (ou groupe) D.', '6', '6021', '0'),
('6022', '6022 Fournitures consommables.', '6', '602', '0'),
('60221', '60221 Combustibles.', '6', '6022', '0'),
('60222', '60222 Produits d&#039;entretien.', '6', '6022', '0'),
('60223', '60223 Fournitures d&#039;atelier et d&#039;usine.', '6', '6022', '0'),
('60224', '60224 Fournitures de magasin.', '6', '6022', '0'),
('60225', '60225 Fournitures de bureau.', '6', '6022', '0'),
('6026', '6026 Emballages.', '6', '602', '0'),
('60261', '60261 Emballages perdus.', '6', '6026', '0'),
('60265', '60265 Emballages récupérables non identifiables.', '6', '6026', '0'),
('60267', '60267 Emballages à usage mixte.', '6', '6026', '0'),
('603', '603 Variation des stocks (approvisionnements et marcha', '6', '60', '0'),
('6031', '6031 Variation des stocks de matières premières (et fou', '6', '603', '0'),
('6032', '6032 Variation des stocks des autres approvisionnements', '6', '603', '0'),
('6037', '6037 Variation des stocks de marchandises.', '6', '603', '0'),
('604', '604 Achats d&#039;études et prestations de services.', '6', '60', '0'),
('605', '605 Achats de matériel, équipements et travaux.', '6', '60', '0'),
('606', '606 Achats non stockés de matières et fournitures.', '6', '60', '0'),
('6061', '6061 Fournitures non stockables (eau, énergie...).', '6', '606', '0'),
('6063', '6063 Fournitures d&#039;entretien et de petit équipement.', '6', '606', '0'),
('6064', '6064 Fournitures administratives.', '6', '606', '0'),
('6068', '6068 Autres matières et fournitures.', '6', '606', '0'),
('607', '607 Achats de marchandises.', '6', '60', '0'),
('6071', '6071 Marchandise (ou groupe) A.', '6', '607', '0'),
('6072', '6072 Marchandise (ou groupe) B.', '6', '607', '0'),
('608', '608 Frais accessoires d&#039;achat.', '6', '60', '0'),
('609', '609 Rabais, remises et ristournes obtenus sur achats.', '6', '60', '0'),
('6091', '6091 Rabais, remises et ristournes obtenus sur achats de mat', '6', '609', '0'),
('6092', '6092 Rabais, remises et ristournes obtenus sur achats d&amp;#039', '6', '609', '0'),
('6094', '6094 Rabais, remises et ristournes obtenus sur achats d&amp;#039', '6', '609', '0'),
('6095', '6095 Rabais, remises et ristournes obtenus sur achats de mat', '6', '609', '0'),
('6096', '6096 Rabais, remises et ristournes obtenus sur achats d&amp;#039', '6', '609', '0'),
('6097', '6097 Rabais, remises et ristournes obtenus sur achats de mar', '6', '609', '0'),
('6098', '6098 Rabais, remises et ristournes non affectés.', '6', '609', '0'),
('61', '61 Services extérieurs.', '6', '', '0'),
('611', '611 Sous-traitance générale.', '6', '61', '0'),
('612', '612 Redevances de crédit-bail.', '6', '61', '0'),
('6122', '6122 Crédit-bail mobilier.', '6', '612', '0'),
('6125', '6125 Crédit-bail immobilier.', '6', '612', '0'),
('613', '613 Locations.', '6', '61', '0'),
('6132', '6132 Locations immobilières.', '6', '613', '0'),
('6135', '6135 Locations mobilières.', '6', '613', '0'),
('6136', '6136 Malis sur emballages.', '6', '613', '0'),
('614', '614 Charges locatives et de copropriété.', '6', '61', '0'),
('615', '615 Entretien et réparations.', '6', '61', '0'),
('6152', '6152 Entretien et réparations sur biens immobiliers.', '6', '615', '0'),
('6155', '6155 Entretien et réparations sur biens mobiliers.', '6', '615', '0'),
('6156', '6156 Maintenance.', '6', '615', '0'),
('616', '616 Primes d&#039;assurance.', '6', '61', '0'),
('6161', '6161 Multirisques.', '6', '616', '0'),
('6162', '6162 Assurance obligatoire dommage-construction.', '6', '616', '0'),
('6163', '6163 Assurance transport.', '6', '616', '0'),
('61636', '61636 Assurance transport sur achats.', '6', '6163', '0'),
('61637', '61637 Assurance transport sur ventes.', '6', '6163', '0'),
('61638', '61638 Assurance transport sur autres biens.', '6', '6163', '0'),
('6164', '6164 Risques d&#039;exploitation.', '6', '616', '0'),
('6165', '6165 Insolvabilité clients.', '6', '616', '0'),
('617', '617 Etudes et recherches.', '6', '61', '0'),
('618', '618 Divers.', '6', '61', '0'),
('6181', '6181 Documentation générale.', '6', '618', '0'),
('6183', '6183 Documentation technique.', '6', '618', '0'),
('6185', '6185 Frais de colloques, séminaires, conférences, formations', '6', '618', '0'),
('619', '619 Rabais, remises et ristournes obtenus sur services', '6', '61', '0'),
('62', '62 Autres services extérieurs.', '6', '', '0'),
('621', '621 Personnel extérieur à l&#039;entreprise.', '6', '62', '0'),
('6211', '6211 Personnel intérimaire.', '6', '621', '0'),
('6214', '6214 Personnel détaché ou prêté à l&#039;entreprise.', '6', '621', '0'),
('622', '622 Rémunérations d&#039;intermédiaires et honoraires.', '6', '62', '0'),
('6221', '6221 Commissions et courtages sur achats.', '6', '622', '0'),
('6222', '6222 Commissions et courtages sur ventes.', '6', '622', '0'),
('6224', '6224 Rémunérations des transitaires.', '6', '622', '0'),
('6225', '6225 Rémunérations d&#039;affacturage.', '6', '622', '0'),
('6226', '6226 Honoraires.', '6', '622', '0'),
('6227', '6227 Frais d&#039;actes et de contentieux.', '6', '622', '0'),
('6228', '6228 Divers.', '6', '622', '0'),
('623', '623 Publicité, publications, relations publiques.', '6', '62', '0'),
('6231', '6231 Annonces et insertions.', '6', '623', '0'),
('6232', '6232 Echantillons.', '6', '623', '0'),
('6233', '6233 Foires et expositions.', '6', '623', '0'),
('6234', '6234 Cadeaux à la clientèle.', '6', '623', '0'),
('6235', '6235 Primes.', '6', '623', '0'),
('6236', '6236 Catalogues et imprimés.', '6', '623', '0'),
('6237', '6237 Publications.', '6', '623', '0'),
('6238', '6238 Divers (pourboires, dons courants...).', '6', '623', '0'),
('624', '624 Transports de biens et transports collectifs du pe', '6', '62', '0'),
('6241', '6241 Transports sur achats.', '6', '624', '0'),
('6242', '6242 Transports sur ventes.', '6', '624', '0'),
('6243', '6243 Transports entre établissements ou chantiers.', '6', '624', '0'),
('6244', '6244 Transports administratifs.', '6', '624', '0'),
('6247', '6247 Transports collectifs du personnel.', '6', '624', '0'),
('6248', '6248 Divers.', '6', '624', '0'),
('625', '625 Déplacements, missions et réceptions.', '6', '62', '0'),
('6251', '6251 Voyages et déplacements.', '6', '625', '0'),
('6255', '6255 Frais de déménagement.', '6', '625', '0'),
('6256', '6256 Missions.', '6', '625', '0'),
('6257', '6257 Réceptions.', '6', '625', '0'),
('626', '626 Frais postaux et frais de télécommunications.', '6', '62', '0'),
('627', '627 Services bancaires et assimilés.', '6', '62', '0'),
('6271', '6271 Frais sur titres (achats, vente, garde).', '6', '627', '0'),
('6272', '6272 Commissions et frais sur émission d&#039;emprunts.', '6', '627', '0'),
('6275', '6275 Frais sur effets.', '6', '627', '0'),
('6276', '6276 Location de coffres.', '6', '627', '0'),
('6278', '6278 Autres frais et commissions sur prestations de ser', '6', '627', '0'),
('628', '628 Divers.', '6', '62', '0'),
('6281', '6281 Concours divers (cotisations...).', '6', '628', '0'),
('6284', '6284 Frais de recrutement de personnel.', '6', '628', '0'),
('629', '629 Rabais, remises et ristournes obtenus sur autres s', '6', '62', '0'),
('63', '63 Impôts, taxes et versements assimilés.', '6', '', '0'),
('631', '631 Impôts, taxes et versements assimilés sur rémunération a', '6', '63', '0'),
('6311', '6311 Taxe sur les salaires.', '6', '631', '0'),
('6312', '6312 Taxe d&#039;apprentissage.', '6', '631', '0'),
('6313', '6313 Participation des employeurs à la formation profes', '6', '631', '0'),
('6314', '6314 Cotisation pour défaut d&#039;investissement obligatoir', '6', '631', '0'),
('6318', '6318 Autres.', '6', '631', '0'),
('633', '633 Impôts, taxes et versements assimilés sur rémunération A', '6', '63', '0'),
('6331', '6331 Versement de transport.', '6', '633', '0'),
('6332', '6332 Allocation logement.', '6', '633', '0'),
('6333', '6333 Participation des employeurs à la formation professionn', '6', '633', '0'),
('6334', '6334 Participation des employeurs à l&#039;effort de constru', '6', '633', '0'),
('6335', '6335 Versements libératoires ouvrant droit à l&#039;exonérat', '6', '633', '0'),
('6338', '6338 Autres.', '6', '633', '0'),
('635', '635 Autres impôts, taxes et versements assimilés (admi', '6', '63', '0'),
('6351', '6351 Impôts directs (sauf impôts sur les bénéfices).', '6', '635', '0'),
('63511', '63511 Taxe professionnelle.', '6', '6351', '0'),
('63512', '63512 Taxes foncières.', '6', '6351', '0'),
('63513', '63513 Autres impôts locaux.', '6', '6351', '0'),
('63514', '63514 Taxe sur les véhicules des sociétés.', '6', '6351', '0'),
('6352', '6352 Taxes sur le chiffre d&#039;affaires non récupérables.', '6', '635', '0'),
('6353', '6353 Impôts indirects.', '6', '635', '0'),
('6354', '6354 Droits d&#039;enregistrement et de timbre.', '6', '635', '0'),
('63541', '63541 Droits de mutation.', '6', '6354', '0'),
('6358', '6358 Autres droits.', '6', '635', '0'),
('637', '637 Autres impôts, taxes et versements assimilés (autr', '6', '63', '0'),
('6371', '6371 Contribution sociale de solidarité à la charge des', '6', '637', '0'),
('6372', '6372 Taxes perçues par les organismes publics internati', '6', '637', '0'),
('6373', '6373 CSG/CRDS déductible IR', '6', '637', '0'),
('6374', '6374 Impôts et taxes exigibles à l&#039;étranger.', '6', '637', '0'),
('6378', '6378 Taxes diverses.', '6', '637', '0'),
('64', '64 Charges de personnel.', '6', '', '0'),
('641', '641 Rémunérations du personnel.', '6', '64', '0'),
('6411', '6411 Salaires, appointements.', '6', '641', '0'),
('6412', '6412 Congés payés.', '6', '641', '0'),
('6413', '6413 Primes et gratifications.', '6', '641', '0'),
('6414', '6414 Indemnités et avantages divers.', '6', '641', '0'),
('6415', '6415 Supplément familial.', '6', '641', '0'),
('644', '644 Rémunération du travail de l&#039;exploitant.', '6', '64', '0'),
('6441', '6441 CSG non déductible IR', '6', '644', '0'),
('645', '645 Charges de sécurité sociale et de prévoyance.', '6', '64', '0'),
('6451', '6451 Cotisations à l&#039;Urssaf.', '6', '645', '0'),
('6452', '6452 Cotisations aux mutuelles.', '6', '645', '0'),
('6453', '6453 Cotisations aux caisses de retraites.', '6', '645', '0'),
('6454', '6454 Cotisations aux Assédic.', '6', '645', '0'),
('6458', '6458 Cotisations aux autres organismes sociaux.', '6', '645', '0'),
('646', '646 Cotisations sociales personnelles de l&#039;exploitant.', '6', '64', '0'),
('6461', '6461 Cotisations Allocations familiales TNS', '6', '646', '0'),
('6462', '6462 Cotisations Maladie TNS', '6', '646', '0'),
('6463', '6463 Cotisations Viellesse TNS', '6', '646', '0'),
('647', '647 Autres charges sociales.', '6', '64', '0'),
('6471', '6471 Prestations directes.', '6', '647', '0'),
('6472', '6472 Versements aux comités d&#039;entreprise et d&#039;étab', '6', '647', '0'),
('6473', '6473 Versements aux comités d&#039;hygiène et de sécurité.', '6', '647', '0'),
('6474', '6474 Versements aux autres oeuvres sociales.', '6', '647', '0'),
('6475', '6475 Médecine du travail, pharmacie.', '6', '647', '0'),
('648', '648 Autres charges de personnel.', '6', '64', '0'),
('65', '65 Autres charges de gestion courante.', '6', '', '0'),
('651', '651 Redevances pour concessions, brevets, licences, pr', '6', '65', '0'),
('6511', '6511 Redevances pour concessions, brevets, licences, ma', '6', '651', '0'),
('6516', '6516 Droits d&#039;auteur et de reproduction.', '6', '651', '0'),
('6518', '6518 Autres droits et valeurs similaires.', '6', '651', '0'),
('653', '653 Jetons de présence.', '6', '65', '0'),
('654', '654 Pertes sur créances irrécouvrables.', '6', '65', '0'),
('6541', '6541 Créances de l&#039;exercice.', '6', '654', '0'),
('6544', '6544 Créances des exercices antérieurs.', '6', '654', '0'),
('655', '655 Quotes-parts de résultat sur opérations faites en ', '6', '65', '0'),
('6551', '6551 Quote-part de bénéfice transférée (comptabilité du', '6', '655', '0'),
('6555', '6555 Quote-part de perte supportée (comptabilité des as', '6', '655', '0'),
('658', '658 Charges diverses de gestion courante.', '6', '65', '0'),
('66', '66 Charges financières.', '6', '', '0'),
('661', '661 Charges d&#039;intérêts.', '6', '66', '0'),
('6611', '6611 Intérêts des emprunts et dettes.', '6', '661', '0'),
('66116', '66116 Intérêts des emprunts et dettes assimilées.', '6', '6611', '0'),
('66117', '66117 Intérêts des dettes rattachées à des participations.', '6', '6611', '0'),
('6615', '6615 Intérêts des comptes courants et des dépôts crédit', '6', '661', '0'),
('6616', '6616 Intérêts bancaires et sur opérations de financemen', '6', '661', '0'),
('6617', '6617 Intérêts des obligations cautionnées.', '6', '661', '0'),
('6618', '6618 Intérêts des autres dettes.', '6', '661', '0'),
('66181', '66181 Intérêts des dettes commerciales.', '6', '6618', '0'),
('66188', '66188 Intérêts des dettes diverses.', '6', '6618', '0'),
('664', '664 Pertes sur créances liées à des participations.', '6', '66', '0'),
('665', '665 Escomptes accordés.', '6', '66', '0'),
('666', '666 Pertes de change.', '6', '66', '0'),
('667', '667 Charges nettes sur cessions de valeurs mobilières ', '6', '66', '0');
INSERT INTO `0_chart_types` VALUES
('668', '668 Autres charges financières.', '6', '66', '0'),
('67', '67 Charges exceptionnelles.', '6', '', '0'),
('671', '671 Charges exceptionnelles sur opérations de gestion.', '6', '67', '0'),
('6711', '6711 Pénalités sur marchés (et dédits payés sur achats ', '6', '671', '0'),
('6712', '6712 Pénalités, amendes fiscales et pénales.', '6', '671', '0'),
('6713', '6713 Dons, libéralités.', '6', '671', '0'),
('6714', '6714 Créances devenues irrécouvrables dans l&#039;exercice.', '6', '671', '0'),
('6715', '6715 Subventions accordées.', '6', '671', '0'),
('6717', '6717 Rappel d&#039;impôts (autres qu&#039;impôts sur les bén', '6', '671', '0'),
('6718', '6718 Autres charges exceptionnelles sur opérations de g', '6', '671', '0'),
('672', '672 Charges sur exercices antérieurs (en cours d&#039;exerc', '6', '67', '0'),
('675', '675 Valeurs comptables des éléments d&#039;actif cédés.', '6', '67', '0'),
('6751', '6751 Immobilisations incorporelles.', '6', '675', '0'),
('6752', '6752 Immobilisations corporelles.', '6', '675', '0'),
('6756', '6756 Immobilisations financières.', '6', '675', '0'),
('6758', '6758 Autres éléments d&#039;actif.', '6', '675', '0'),
('678', '678 Autres charges exceptionnelles.', '6', '67', '0'),
('6781', '6781 Malis provenant de clauses d&#039;indexation.', '6', '678', '0'),
('6782', '6782 Lots.', '6', '678', '0'),
('6783', '6783 Malis provenant du rachat par l&#039;entreprise d&#039;', '6', '678', '0'),
('6788', '6788 Charges exceptionnelles diverses.', '6', '678', '0'),
('68', '68 Dotations aux amortissements, aux dépréciations et', '6', '', '0'),
('681', '681 Dotations aux amortissements, aux dépréciations et', '6', '68', '0'),
('6811', '6811 Dotations aux amortissements des immobilisations i', '6', '681', '0'),
('68111', '68111 Dotations aux amortissements des Immobilisations incor', '6', '6811', '0'),
('68112', '68112 Dotations aux amortissements des Immobilisations corpo', '6', '6811', '0'),
('6812', '6812 Dotations aux amortissements des charges d&#039;exploit', '6', '681', '0'),
('6815', '6815 Dotations aux provisions d&#039;exploitation.', '6', '681', '0'),
('6816', '6816 Dotations aux dépréciations des immobilisations in', '6', '681', '0'),
('68161', '68161 Dotations aux dépréciations des Immobilisations incorp', '6', '6816', '0'),
('68162', '68162 Dotations aux dépréciations des Immobilisations corpor', '6', '6816', '0'),
('6817', '6817 Dotations aux dépréciations des actifs circulants.', '6', '681', '0'),
('68173', '68173 Dotations aux dépréciations de Stocks et en-cours.', '6', '6817', '0'),
('68174', '68174 Dotations aux dépréciations de Créances.', '6', '6817', '0'),
('686', '686 Dotations aux amortissements, aux dépréciations et', '6', '68', '0'),
('6861', '6861 Dotations aux amortissements des primes de rembour', '6', '686', '0'),
('6865', '6865 Dotations aux provisions financières.', '6', '686', '0'),
('6866', '6866 Dotations aux dépréciations des éléments financier', '6', '686', '0'),
('68662', '68662 Immobilisations financières.', '6', '6866', '0'),
('68665', '68665 Valeurs mobilières de placement.', '6', '6866', '0'),
('6868', '6868 Autres dotations.', '6', '686', '0'),
('687', '687 Dotations aux amortissements et aux provisions - C', '6', '68', '0'),
('6871', '6871 Dotations aux amortissements exceptionnels des imm', '6', '687', '0'),
('6872', '6872 Dotations aux provisions réglementées (immobilisat', '6', '687', '0'),
('68725', '68725 Amortissements dérogatoires.', '6', '6872', '0'),
('6873', '6873 Dotations aux provisions réglementées (stocks).', '6', '687', '0'),
('6874', '6874 Dotations aux autres provisions réglementées.', '6', '687', '0'),
('6875', '6875 Dotations aux provisions exceptionnelles.', '6', '687', '0'),
('6876', '6876 Dotations aux dépréciations exceptionnelles.', '6', '687', '0'),
('69', '69 Participation des salariés - Impôts sur les bénéfi', '6', '', '0'),
('691', '691 Participation des salariés aux résultats.', '6', '69', '0'),
('695', '695 Impôts sur les bénéfices.', '6', '69', '0'),
('6951', '6951 Impôts dus en France.', '6', '695', '0'),
('6952', '6952 Contribution additionnelle à l&#039;impôt sur les bénéf', '6', '695', '0'),
('6954', '6954 Impôts dus à l&#039;étranger.', '6', '695', '0'),
('696', '696 Suppléments d&#039;impôt sur les sociétés liés aux dist', '6', '69', '0'),
('697', '697 Imposition forfaitaire annuelle des sociétés.', '6', '69', '0'),
('698', '698 Intégration fiscale d&#039;impôt (voir n° 2855).', '6', '69', '0'),
('6981', '6981 Intégration fiscale - Charges.', '6', '698', '0'),
('6989', '6989 Intégration fiscale - Produits.', '6', '698', '0'),
('699', '699 Produits - report en arrière des déficits.', '6', '69', '0'),
('70', '70 Ventes de produits fabriqués, prestations de servi', '7', '', '0'),
('701', '701 Ventes de produits finis.', '7', '70', '0'),
('7011', '7011 Produit fini (ou groupe) A.', '7', '701', '0'),
('7012', '7012 Produit fini (ou groupe) B.', '7', '701', '0'),
('702', '702 Ventes de produits intermédiaires.', '7', '70', '0'),
('703', '703 Ventes de produits résiduels.', '7', '70', '0'),
('704', '704 Travaux.', '7', '70', '0'),
('7041', '7041 Travaux de catégorie (ou activité) A.', '7', '704', '0'),
('7042', '7042 Travaux de catégorie (ou activité) B.', '7', '704', '0'),
('705', '705 Etudes.', '7', '70', '0'),
('706', '706 Prestations de services.', '7', '70', '0'),
('707', '707 Ventes de marchandises.', '7', '70', '0'),
('7071', '7071 Marchandise (ou groupe) A.', '7', '707', '0'),
('7072', '7072 Marchandise (ou groupe) B.', '7', '707', '0'),
('708', '708 Produits des activités annexes.', '7', '70', '0'),
('7081', '7081 Produits des services exploités dans l&#039;intérêt du ', '7', '708', '0'),
('7082', '7082 Commissions et courtages.', '7', '708', '0'),
('7083', '7083 Locations diverses.', '7', '708', '0'),
('7084', '7084 Mise à disposition de personnel facturée.', '7', '708', '0'),
('7085', '7085 Ports et frais accessoires facturés.', '7', '708', '0'),
('7086', '7086 Bonis sur reprises d&#039;emballages consignés.', '7', '708', '0'),
('7087', '7087 Bonifications obtenues des clients et primes sur v', '7', '708', '0'),
('7088', '7088 Autres produits d&#039;activités annexes (cessions d&amp;#0', '7', '708', '0'),
('709', '709 Rabais, remises et ristournes accordés par l&#039;entre', '7', '70', '0'),
('7091', '7091 - sur ventes de produits finis.', '7', '709', '0'),
('7092', '7092 - sur ventes de produits intermédiaires.', '7', '709', '0'),
('7094', '7094 - sur travaux.', '7', '709', '0'),
('7095', '7095 - sur études.', '7', '709', '0'),
('7096', '7096 - sur prestations de services.', '7', '709', '0'),
('7097', '7097 - sur ventes de marchandises.', '7', '709', '0'),
('7098', '7098 - sur produits des activités annexes.', '7', '709', '0'),
('71', '71 Production stockée (ou déstockage).', '7', '', '0'),
('713', '713 Variation des stocks (en-cours de production, prod', '7', '71', '0'),
('7133', '7133 Variation des en-cours de production de biens.', '7', '713', '0'),
('71331', '71331 Produits en cours.', '7', '7133', '0'),
('71335', '71335 Travaux en cours.', '7', '7133', '0'),
('7134', '7134 Variation des en-cours de production de services.', '7', '713', '0'),
('71341', '71341 Etudes en cours.', '7', '7134', '0'),
('71345', '71345 Prestations de services en cours.', '7', '7134', '0'),
('7135', '7135 Variation des stocks de produits.', '7', '713', '0'),
('71351', '71351 Produits intermédiaires.', '7', '7135', '0'),
('71355', '71355 Produits finis.', '7', '7135', '0'),
('71358', '71358 Produits résiduels.', '7', '7135', '0'),
('72', '72 Production immobilisée. ', '7', '', '0'),
('721', '721 Immobilisations incorporelles.', '7', '72', '0'),
('722', '722 Immobilisations corporelles.', '7', '72', '0'),
('74', '74 Subventions d&#039;exploitation.', '7', '', '0'),
('75', '75 Autres produits de gestion courante.', '7', '', '0'),
('751', '751 Redevances pour concessions, brevets, licences, ma', '7', '75', '0'),
('7511', '7511 Redevances pour concessions, brevets, licences, ma', '7', '751', '0'),
('7516', '7516 Droits d&#039;auteur et de reproduction.', '7', '751', '0'),
('7518', '7518 Autres droits et valeurs similaires.', '7', '751', '0'),
('752', '752 Revenus des immeubles non affectés aux activités p', '7', '75', '0'),
('753', '753 Jetons de présence et rémunérations d&#039;administrate', '7', '75', '0'),
('754', '754 Ristournes perçues des coopératives (provenant des', '7', '75', '0'),
('755', '755 Quotes-parts de résultat sur opérations faites en ', '7', '75', '0'),
('7551', '7551 Quote-part de perte transférée (comptabilité du gé', '7', '755', '0'),
('7555', '7555 Quote-part de bénéfice attribuée (comptabilité des', '7', '755', '0'),
('758', '758 Produits divers de gestion courante.', '7', '75', '0'),
('76', '76 Produits financiers. ', '7', '', '0'),
('761', '761 Produits de participations.', '7', '76', '0'),
('7611', '7611 Revenus des titres de participation.', '7', '761', '0'),
('7616', '7616 Revenus sur autres formes de participation.', '7', '761', '0'),
('7617', '7617 Revenus de créances rattachées à des participation', '7', '761', '0'),
('762', '762 Produits des autres immobilisations financières.', '7', '76', '0'),
('7621', '7621 Revenus des titres immobilisés.', '7', '762', '0'),
('7624', '7624 Revenus des prêts.', '7', '762', '0'),
('7627', '7627 Revenus des créances immobilisées.', '7', '762', '0'),
('763', '763 Revenus des autres créances.', '7', '76', '0'),
('7631', '7631 Revenus des créances commerciales.', '7', '763', '0'),
('7638', '7638 Revenus des créances diverses.', '7', '763', '0'),
('764', '764 Revenus des valeurs mobilières de placement.', '7', '76', '0'),
('765', '765 Escomptes obtenus.', '7', '76', '0'),
('766', '766 Gains de change.', '7', '76', '0'),
('767', '767 Produits nets sur cessions de valeurs mobilières de plac', '7', '76', '0'),
('768', '768 Autres produits financiers.', '7', '76', '0'),
('77', '77 Produits exceptionnels. ', '7', '', '0'),
('771', '771 Produits exceptionnels sur opérations de gestion.', '7', '77', '0'),
('7711', '7711 Dédits et pénalités perçus sur achats et sur vente', '7', '771', '0'),
('7713', '7713 Libéralités perçues.', '7', '771', '0'),
('7714', '7714 Rentrées sur créances amorties.', '7', '771', '0'),
('7715', '7715 Subventions d&#039;équilibre.', '7', '771', '0'),
('7717', '7717 Dégrèvement d&#039;impôts autres qu&#039;impôts sur les', '7', '771', '0'),
('7718', '7718 Autres produits exceptionnels sur opérations de ge', '7', '771', '0'),
('772', '772 Produits sur exercices antérieurs (en cours d&#039;exer', '7', '77', '0'),
('775', '775 Produits des cessions d&#039;éléments d&#039;actif.', '7', '77', '0'),
('7751', '7751 Immobilisations incorporelles.', '7', '775', '0'),
('7752', '7752 Immobilisations corporelles.', '7', '775', '0'),
('7756', '7756 Immobilisations financières.', '7', '775', '0'),
('7758', '7758 Autres éléments d&#039;actif.', '7', '775', '0'),
('777', '777 Quote-part des subventions d&#039;investissement virée ', '7', '77', '0'),
('778', '778 Autres produits exceptionnels.', '7', '77', '0'),
('7781', '7781 Bonis provenant de clauses d&#039;indexation.', '7', '778', '0'),
('7782', '7782 Lots.', '7', '778', '0'),
('7783', '7783 Bonis provenant du rachat par l&#039;entreprise d&#039;', '7', '778', '0'),
('7788', '7788 Produits exceptionnels divers.', '7', '778', '0'),
('78', '78 Reprises sur amortissements, aux dépréciations et ', '7', '', '0'),
('781', '781 Reprises sur amortissements et provisions (à inscr', '7', '78', '0'),
('7811', '7811 Reprises sur amortissements des immobilisations in', '7', '781', '0'),
('78111', '78111 Immobilisations incorporelles.', '7', '7811', '0'),
('78112', '78112 Immobilisations corporelles.', '7', '7811', '0'),
('7815', '7815 Reprises sur provisions d&#039;exploitation.', '7', '781', '0'),
('7816', '7816 Reprise sur dépréciations des immobilisations inco', '7', '781', '0'),
('78161', '78161 Immobilisations incorporelles.', '7', '7816', '0'),
('78162', '78162 Immobilisations corporelles.', '7', '7816', '0'),
('7817', '7817 Reprises sur dépréciations des actifs circulants.', '7', '781', '0'),
('78173', '78173 Stocks et en-cours.', '7', '7817', '0'),
('78174', '78174 Créances.', '7', '7817', '0'),
('786', '786 Reprises sur provisions pour risques et dépréciati', '7', '78', '0'),
('7865', '7865 Reprises sur provisions financières.', '7', '786', '0'),
('7866', '7866 Reprises sur dépréciations des éléments financiers', '7', '786', '0'),
('78662', '78662 Immobilisations financières.', '7', '7866', '0'),
('78665', '78665 Valeurs mobilières de placement.', '7', '7866', '0'),
('787', '787 Reprises sur provisions et dépréciations (à inscri', '7', '78', '0'),
('7872', '7872 Reprises sur provisions réglementées (immobilisati', '7', '787', '0'),
('78725', '78725 Amortissements dérogatoires.', '7', '7872', '0'),
('78726', '78726 Provision spéciale de réévaluation.', '7', '7872', '0'),
('78727', '78727 Plus-values réinvesties.', '7', '7872', '0'),
('7873', '7873 Reprises sur provisions réglementées (stocks).', '7', '787', '0'),
('7874', '7874 Reprises sur autres provisions réglementées.', '7', '787', '0'),
('7875', '7875 Reprises sur provisions exceptionnelles.', '7', '787', '0'),
('7876', '7876 Reprises sur dépréciations exceptionnelles.', '7', '787', '0'),
('79', '79 Transferts de charges. ', '7', '', '0'),
('791', '791 Transferts de charges d&#039;exploitation.', '7', '79', '0'),
('796', '796 Transferts de charges financières.', '7', '79', '0'),
('797', '797 Transferts de charges exceptionnelles.', '7', '79', '0'),
('80', '80 Engagements', '8', '', '0'),
('801', '801 Engagements donnés par l’entité', '8', '80', '0'),
('8011', '8011 Avals, cautions, garanties.', '8', '801', '0'),
('8014', '8014 Effets circulant sous l’endos de l’entité.', '8', '801', '0'),
('8016', '8016 Redevances crédit-bail restant à courir.', '8', '801', '0'),
('80161', '80161 Redevances crédit-bail mobilier restant à courir.', '8', '8016', '0'),
('80165', '80165 Redevances crédit-bail immobilier restant à courir.', '8', '8016', '0'),
('8018', '8018 Autres engagements donnés.', '8', '801', '0'),
('802', '802 Engagements reçus par l’entité', '8', '80', '0'),
('8021', '8021 Avals, cautions, garanties.', '8', '802', '0'),
('8024', '8024 Créances escomptées non échues.', '8', '802', '0'),
('8026', '8026 Engagements reçus pour utilisation en crédit-bail.', '8', '802', '0'),
('80261', '80261 Engagements reçus pour utilisation en crédit-bail mobi', '8', '8026', '0'),
('80265', '80265 Engagements reçus pour utilisation en crédit-bail immo', '8', '8026', '0'),
('8028', '8028 Autres engagements reçus.', '8', '802', '0'),
('809', '809 Contrepartie des engagements', '8', '80', '0'),
('8091', '8091 Contrepartie 801', '8', '809', '0'),
('8092', '8092 Contrepartie 802', '8', '809', '0'),
('88', '88 Résultat en instance d&#039;affectation.', '8', '', '0'),
('89', '89 Bilan.', '8', '', '0'),
('890', '890 Bilan d&#039;ouverture.', '8', '89', '0'),
('891', '891 Bilan de clôture.', '8', '89', '0');

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
('1', 'Bon historique', '0', '0'),
('3', 'Pas de travail supplémentaire jusqu&#039;à paiement', '1', '0'),
('4', 'En liquidation', '1', '0');

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
('Pounds', 'GBP', '?', 'Anglaterre', 'Pence', '0', '1'),
('US Dollars', 'USD', '$', 'Etats Unis', 'Cents', '0', '1');

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
('1', '2008-01-01', '2008-12-31', '0'),
('2', '2009-01-01', '2009-12-31', '0');

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
('DEF', 'Défaut', 'N/A', '', '', '', '', '', '0', '0');

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
('1', 'Le 15 du mois suivant', '0', '17', '0'),
('2', 'Fin du mois suivant', '0', '30', '0'),
('3', '10 jours', '10', '0', '0'),
('4', 'Liquide uniquement', '1', '0', '0');

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
('1', 'Assistant commercial', '', '', '', '5', '20000', '4', '0');

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
('1', 'Aucune', '', '', '', '', '0');

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
('deferred_income_act', 'glsetup.sales', 'varchar', '15', ''),
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
('0', '17', '1'),
('1', '7', '1'),
('2', '4', '1'),
('4', '3', '1'),
('10', '16', '1'),
('11', '2', '1'),
('12', '6', '1'),
('13', '1', '1'),
('16', '2', '1'),
('17', '2', '1'),
('18', '1', '1'),
('20', '6', '1'),
('21', '1', '1'),
('22', '3', '1'),
('25', '1', '1'),
('26', '1', '1'),
('28', '1', '1'),
('29', '1', '1'),
('30', '0', '1'),
('32', '0', '1'),
('35', '1', '1'),
('40', '1', '1');

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
('2', 'Pas de TVA', '0'),
('4', '19.6 TVA collectée', '0'),
('5', '5.5 TVA déductible biens/services', '0'),
('6', '19.6 TVA déductible biens/services', '0'),
('7', '19.6 TVA déductiblesur immobilisations', '0');

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
('6', '19.6', '445710', '445660', '19.6 TVA déductible biens/services', '0'),
('7', '19.6', '445710', '445660', '19.6 TVA collectée', '0'),
('8', '19.6', '445620', '445710', '19.6 TVA déductiblesur immobilisations', '0'),
('9', '5.5', '445660', '445710', '5.5 TVA déductible biens/services', '0'),
('10', '0', '445660', '445710', 'Pas de TVA', '0');

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
