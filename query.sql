CREATE TABLE `nd_banking_accounts` (
    `owner` INT(11) NOT NULL,
    `account_number` VARCHAR(50) NOT NULL,
    `history` LONGTEXT NOT NULL DEFAULT '[]',
    INDEX `FK__characters` (`owner`) USING BTREE,
    CONSTRAINT `FK__characters` FOREIGN KEY (`owner`) REFERENCES `characters` (`character_id`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `nd_banking_invoices` (
    `invoice_id` INT(11) AUTO_INCREMENT,
    `sender_name` VARCHAR(50) DEFAULT NULL,
    `receiver_name` VARCHAR(50) DEFAULT NULL,
    `sender_account` VARCHAR(50) DEFAULT NULL,
    `receiver_account` VARCHAR(50) DEFAULT NULL,
    `amount` INT(11) DEFAULT NULL,
    `created` VARCHAR(50) DEFAULT NULL,
    `due_in` VARCHAR(50) DEFAULT NULL,
    `status` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`invoice_id`) USING BTREE
);
