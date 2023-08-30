CREATE TABLE IF NOT EXISTS `nd_banking_invoices` (
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
