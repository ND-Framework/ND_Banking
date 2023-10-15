CREATE TABLE IF NOT EXISTS `nd_banking_accounts` (
    `owner` INT(11) DEFAULT NULL,
    `account_number` VARCHAR(50) DEFAULT NULL,
    `history` LONGTEXT DEFAULT '[]',
    INDEX `owner` (`owner`) USING BTREE,
    CONSTRAINT `accountowner` FOREIGN KEY (`owner`) REFERENCES `nd_characters` (`charid`) ON UPDATE CASCADE ON DELETE CASCADE
);
