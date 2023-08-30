CREATE TABLE IF NOT EXISTS `nd_banking_accounts` (
    `owner` INT(11) NOT NULL,
    `account_number` VARCHAR(50) NOT NULL,
    `history` LONGTEXT NOT NULL DEFAULT '[]',
    INDEX `FK__characters` (`owner`) USING BTREE,
    CONSTRAINT `FK__characters` FOREIGN KEY (`owner`) REFERENCES `characters` (`character_id`) ON UPDATE CASCADE ON DELETE CASCADE
);
