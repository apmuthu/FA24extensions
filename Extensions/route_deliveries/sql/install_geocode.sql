CREATE TABLE IF NOT EXISTS `0_route_delivery_gps` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `debtor_no` INT NOT NULL,
    `branch_no` INT NOT NULL,
    `latitude` DECIMAL(10, 6) NOT NULL,
    `longitude` DECIMAL(11, 6) NOT NULL,
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE `DEBTOR_BRANCH` (`debtor_no`, `branch_no`)
) ENGINE=InnoDB;

