CREATE TABLE `_farm` (
	`id` INT(11) NOT NULL,
	`private` INT(11) NULL DEFAULT '0',
	`owner` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`whitelist` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`data` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`lasttime` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;


INSERT INTO `items` (`name`, `label`) VALUES
	('cucumber_seed', 'Cucumber seed'),
	('cucumber', 'Cucumber'),
	('chili_seed', 'Chili seed'),
	('chili', 'Chili'),
	('corn_seed', 'Corn seed'),
	('corn', 'Corn'),
	('weed_seed', 'Weed seed'),
	('weed', 'Weed'),
	('wateringcan', 'Watering can')