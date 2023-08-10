CREATE TABLE `lootpool` (
	`item` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`amount` INT(11) NOT NULL DEFAULT -2,
	`dailyamount` INT(11) NULL DEFAULT -1,
	`rarity` INT(11) NOT NULL DEFAULT '0',
	`looted` INT(11) NOT NULL DEFAULT '0',
	`scripts` LONGTEXT NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`item`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
