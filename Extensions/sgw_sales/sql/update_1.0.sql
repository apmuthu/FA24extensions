CREATE TABLE IF NOT EXISTS `0_sales_recurring` (
  `id` int(11) unsigned NOT NULL,
  `trans_no` int(10) unsigned NOT NULL,
  `dt_start` date NOT NULL,
  `dt_end` date NOT NULL,
  `dt_next` date NOT NULL,
  `auto` tinyint(1) NOT NULL,
  `every` tinyint(4) NOT NULL,
  `repeats` enum('year','month') COLLATE utf8_unicode_ci NOT NULL,
  `occur` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_no` (`trans_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `0_sales_recurring`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
