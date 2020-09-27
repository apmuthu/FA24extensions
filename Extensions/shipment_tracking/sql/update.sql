DROP TABLE IF EXISTS `0_shipments`;

CREATE TABLE `0_shipments` (
  `shipment_id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_no` int(11) NOT NULL DEFAULT '0',
  `type` smallint(6) UNSIGNED NOT NULL DEFAULT '0',
  `shipment_date` date NOT NULL DEFAULT '0000-00-00',
  `shipment_tracking_no` varchar(60) DEFAULT NULL,
  `shipment_vehicle_no` varchar(60) DEFAULT NULL,
  `shipment_eway_bill` varchar(60) DEFAULT NULL,
  `shipment_package` double NOT NULL DEFAULT '0',
  `abbr` varchar(20) NOT NULL,
  `shipment_freight` double NOT NULL DEFAULT '0',
  `shipment_status` int(11) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `0_options` (
  `option_id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(30) NOT NULL,
  `column_name` varchar(30) NOT NULL,
  `column_value` varchar(30) NOT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `0_options` (`table_name`, `column_name`, `column_value`, `inactive`) VALUES
('shipments', 'shipment_status', 'On Hold', 0),
('shipments', 'shipment_status', 'Preparing Dispatch', 0),
('shipments', 'shipment_status', 'Awaiting Pickup', 0),
('shipments', 'shipment_status', 'In Transit', 0),
('shipments', 'shipment_status', 'Delivered', 0);