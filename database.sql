SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `elektron_shop` DEFAULT CHARACTER SET utf8 ;
USE `elektron_shop` ;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(64) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `firstname` VARCHAR(64) NOT NULL,
  `lastname` VARCHAR(64) NOT NULL,
  `otp_secret` VARCHAR(128) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`taxes` (
  `tax_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'Nazwa podatku',
  `value` FLOAT NOT NULL DEFAULT 0 COMMENT 'Wartość podatku w procentach',
  `deleted` VARCHAR(45) NOT NULL DEFAULT 0,
  PRIMARY KEY (`tax_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`producers` (
  `producer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `logo_url` VARCHAR(64) NULL,
  `website_url` VARCHAR(64) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`producer_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`suppliers` (
  `supplier_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `logo_url` VARCHAR(64) NULL,
  `website_url` VARCHAR(64) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`supplier_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`products` (
  `product_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `price` FLOAT NOT NULL,
  `description` VARCHAR(1024) NULL,
  `tax` INT NOT NULL,
  `photo_url` VARCHAR(45) NULL,
  `producer` INT UNSIGNED NULL,
  `supplier` INT UNSIGNED NULL,
  `virtual` TINYINT NOT NULL DEFAULT 0,
  `available` TINYINT NOT NULL DEFAULT 0,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`),
  INDEX `fk_products_taxes1_idx` (`tax` ASC) VISIBLE,
  INDEX `fk_products_producers1_idx` (`producer` ASC) VISIBLE,
  INDEX `fk_products_suppliers1_idx` (`supplier` ASC) VISIBLE,
  CONSTRAINT `fk_products_taxes1`
    FOREIGN KEY (`tax`)
    REFERENCES `elektron_shop`.`taxes` (`tax_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_producers1`
    FOREIGN KEY (`producer`)
    REFERENCES `elektron_shop`.`producers` (`producer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_suppliers1`
    FOREIGN KEY (`supplier`)
    REFERENCES `elektron_shop`.`suppliers` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`warehouse` (
  `warehouse_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `management_type` ENUM('WA', 'FIFO', 'LIFO') NOT NULL DEFAULT 'WA',
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`warehouse_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`addresses` (
  `address_id` BIGINT NOT NULL AUTO_INCREMENT,
  `user` INT NULL,
  `warehouse` INT UNSIGNED NULL,
  `supplier` INT UNSIGNED NULL,
  `producer` INT UNSIGNED NULL,
  `firstname` VARCHAR(64) NULL,
  `lastname` VARCHAR(64) NULL,
  `company_name` VARCHAR(64) NULL,
  `company_nip` VARCHAR(16) NULL,
  `province` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `postcode` VARCHAR(45) NULL,
  `street` VARCHAR(45) NULL,
  `email` VARCHAR(64) NULL,
  `phone` VARCHAR(32) NULL,
  `phone_mobile` VARCHAR(32) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`address_id`),
  INDEX `fk_addresses_warehouse1_idx` (`warehouse` ASC) VISIBLE,
  INDEX `fk_addresses_users1_idx` (`user` ASC) VISIBLE,
  INDEX `fk_addresses_suppliers1_idx` (`supplier` ASC) VISIBLE,
  INDEX `fk_addresses_producers1_idx` (`producer` ASC) VISIBLE,
  CONSTRAINT `fk_addresses_warehouse1`
    FOREIGN KEY (`warehouse`)
    REFERENCES `elektron_shop`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_addresses_users1`
    FOREIGN KEY (`user`)
    REFERENCES `elektron_shop`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_addresses_suppliers1`
    FOREIGN KEY (`supplier`)
    REFERENCES `elektron_shop`.`suppliers` (`supplier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_addresses_producers1`
    FOREIGN KEY (`producer`)
    REFERENCES `elektron_shop`.`producers` (`producer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`deliveries` (
  `delivery_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL COMMENT 'Nazwa dostawy',
  `price` FLOAT NOT NULL COMMENT 'Koszt dostawy',
  `details` VARCHAR(128) NULL,
  `tax` INT NOT NULL COMMENT 'FK Podatku do dostawy',
  `logo_url` VARCHAR(64) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`delivery_id`),
  INDEX `fk_deliveries_taxes_idx` (`tax` ASC) VISIBLE,
  CONSTRAINT `fk_deliveries_taxes`
    FOREIGN KEY (`tax`)
    REFERENCES `elektron_shop`.`taxes` (`tax_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`stock` (
  `stock_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `warehouse` INT UNSIGNED NOT NULL,
  `product` BIGINT UNSIGNED NOT NULL,
  `quantity` INT NOT NULL DEFAULT 0,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  `available` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`stock_id`),
  INDEX `fk_stock_warehouse1_idx` (`warehouse` ASC) VISIBLE,
  INDEX `fk_stock_products1_idx` (`product` ASC) VISIBLE,
  CONSTRAINT `fk_stock_warehouse1`
    FOREIGN KEY (`warehouse`)
    REFERENCES `elektron_shop`.`warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stock_products1`
    FOREIGN KEY (`product`)
    REFERENCES `elektron_shop`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`payments` (
  `payment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `price` FLOAT NOT NULL,
  `payment_margin` FLOAT NOT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`payment_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`roles` (
  `role_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`role_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`employees` (
  `employe_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(64) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `otp_secret` VARCHAR(128) NOT NULL,
  `firstname` VARCHAR(64) NOT NULL,
  `lastname` VARCHAR(64) NOT NULL,
  `pesel` VARCHAR(16) NOT NULL,
  `role` INT UNSIGNED NOT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`employe_id`),
  INDEX `fk_employees_roles1_idx` (`role` ASC) VISIBLE,
  CONSTRAINT `fk_employees_roles1`
    FOREIGN KEY (`role`)
    REFERENCES `elektron_shop`.`roles` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`orders` (
  `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dest_address` BIGINT NOT NULL,
  `delivery` INT UNSIGNED NOT NULL,
  `delivery_tax` INT NOT NULL,
  `payment` INT UNSIGNED NOT NULL,
  `purchaser` INT NOT NULL,
  `serving_employee` INT UNSIGNED NOT NULL,
  `total_price` FLOAT NOT NULL,
  `state` INT NOT NULL DEFAULT 0,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_addresses1_idx` (`dest_address` ASC) VISIBLE,
  INDEX `fk_orders_deliveries1_idx` (`delivery` ASC) VISIBLE,
  INDEX `fk_orders_users1_idx` (`purchaser` ASC) VISIBLE,
  INDEX `fk_orders_taxes1_idx` (`delivery_tax` ASC) VISIBLE,
  INDEX `fk_orders_payments1_idx` (`payment` ASC) VISIBLE,
  INDEX `fk_orders_employers1_idx` (`serving_employee` ASC) VISIBLE,
  CONSTRAINT `fk_orders_addresses1`
    FOREIGN KEY (`dest_address`)
    REFERENCES `elektron_shop`.`addresses` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_deliveries1`
    FOREIGN KEY (`delivery`)
    REFERENCES `elektron_shop`.`deliveries` (`delivery_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_users1`
    FOREIGN KEY (`purchaser`)
    REFERENCES `elektron_shop`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_taxes1`
    FOREIGN KEY (`delivery_tax`)
    REFERENCES `elektron_shop`.`taxes` (`tax_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_payments1`
    FOREIGN KEY (`payment`)
    REFERENCES `elektron_shop`.`payments` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_employers1`
    FOREIGN KEY (`serving_employee`)
    REFERENCES `elektron_shop`.`employees` (`employe_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`order_rows` (
  `order_row_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product` BIGINT UNSIGNED NOT NULL,
  `tax` INT NOT NULL,
  `order` BIGINT UNSIGNED NOT NULL,
  `quantity` FLOAT NOT NULL,
  PRIMARY KEY (`order_row_id`),
  INDEX `fk_order_rows_products1_idx` (`product` ASC) VISIBLE,
  INDEX `fk_order_rows_taxes1_idx` (`tax` ASC) VISIBLE,
  INDEX `fk_order_rows_orders1_idx` (`order` ASC) VISIBLE,
  CONSTRAINT `fk_order_rows_products1`
    FOREIGN KEY (`product`)
    REFERENCES `elektron_shop`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_rows_taxes1`
    FOREIGN KEY (`tax`)
    REFERENCES `elektron_shop`.`taxes` (`tax_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_rows_orders1`
    FOREIGN KEY (`order`)
    REFERENCES `elektron_shop`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`categories` (
  `category` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `description` VARCHAR(512) NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`category`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`categorization` (
  `category` INT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  INDEX `fk_categorization_categories1_idx` (`category` ASC) VISIBLE,
  INDEX `fk_categorization_products1_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_categorization_categories1`
    FOREIGN KEY (`category`)
    REFERENCES `elektron_shop`.`categories` (`category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_categorization_products1`
    FOREIGN KEY (`product_id`)
    REFERENCES `elektron_shop`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`units` (
  `unit_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `symbol` VARCHAR(45) NOT NULL,
  `deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`unit_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `elektron_shop`.`parametrs` (
  `product` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `value` DOUBLE NOT NULL,
  `unit` BIGINT UNSIGNED NULL,
  INDEX `fk_parametrs_products1_idx` (`product` ASC) VISIBLE,
  INDEX `fk_parametrs_units1_idx` (`unit` ASC) VISIBLE,
  CONSTRAINT `fk_parametrs_products1`
    FOREIGN KEY (`product`)
    REFERENCES `elektron_shop`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parametrs_units1`
    FOREIGN KEY (`unit`)
    REFERENCES `elektron_shop`.`units` (`unit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
