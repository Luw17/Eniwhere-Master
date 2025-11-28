USE `eniwhere_db`;

CREATE TABLE IF NOT EXISTS `addresses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postal_code` mediumtext NULL,
  `country` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `neighborhood` VARCHAR(100) NOT NULL,
  `address_line` VARCHAR(255) NOT NULL,
  UNIQUE (`id`),
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `app_users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `document` VARCHAR(45) NOT NULL,
  `name` VARCHAR(100),
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(45),
  `username` VARCHAR(45) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  `number` VARCHAR(45),
  `address_id` INT NULL,
  `active` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`email`),
  UNIQUE (`username`),
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `devices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `device_name` VARCHAR(100) NOT NULL,
  `model` VARCHAR(100) NOT NULL,
  `brand` VARCHAR(100) NOT NULL,
  `active` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `user_devices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `device_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`),
  FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `stores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `document` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  `number` INT NOT NULL,
  `address_id` INT NOT NULL,
  `subscription_end` DATETIME NOT NULL,
  `analytics` TINYINT NOT NULL DEFAULT 0,
  `active` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`username`),
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `store_workers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255),
  `username` VARCHAR(255) not null,
  `user_password` VARCHAR(100),
  `email` VARCHAR(100) NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`username`),
  UNIQUE (`email`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `service_orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_device_id` INT NOT NULL,
  `worker_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` DATETIME NULL,
  `feedback` INT NULL,
  `warranty` INT NULL,
  `cost` DECIMAL(10,2) NULL,
  `work` DECIMAL(10,2) NULL,
  `status` VARCHAR(100) NULL DEFAULT 'pending',
  `deadline` DATE NULL,
  `problem` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_device_id`) REFERENCES `user_devices` (`id`),
  FOREIGN KEY (`worker_id`) REFERENCES `store_workers` (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `admins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`username`),
  UNIQUE (`user_password`),
  UNIQUE (`email`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `order_logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_order_id` INT NOT NULL,
  `cost` DECIMAL(10,2) NULL,
  `work` DECIMAL(10,2) NULL,
  `status` VARCHAR(100) NULL,
  `deadline` DATE NULL,
  `problem` VARCHAR(255) NULL,
  `log_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pictures` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_order_id` INT NOT NULL,
  `path` VARCHAR(255),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `cost_price` DECIMAL(10,2) NULL DEFAULT 0.00,
  `stock_quantity` INT NOT NULL DEFAULT 0,
  `sku` VARCHAR(50) NULL,
  `category` VARCHAR(100) NULL,
  `supplier` VARCHAR(100) NULL,
  `active` TINYINT NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE (`sku`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sales` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `worker_id` INT NULL,
  `service_order_id` INT NULL,
  `document` VARCHAR(45) NULL,
  `total_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_method` VARCHAR(50) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  FOREIGN KEY (`worker_id`) REFERENCES `store_workers` (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sale_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sale_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER `decrease_stock_on_sale` AFTER INSERT ON `sale_items`
FOR EACH ROW
BEGIN
    UPDATE `products`
    SET `stock_quantity` = `stock_quantity` - NEW.`quantity`
    WHERE `id` = NEW.`product_id`;
END$$

DELIMITER ;

INSERT INTO `devices` (`device_name`, `model`, `brand`, `active`) VALUES
('Smartphone', 'Galaxy S21', 'Samsung', 1),
('Notebook', 'Inspiron 15', 'Dell', 1),
('Tablet', 'iPad Air', 'Apple', 1),
('Smartphone', 'iPhone 13', 'Apple', 1),
('Notebook', 'MacBook Pro', 'Apple', 1),
('Smartphone', 'Redmi Note 10', 'Xiaomi', 1),
('Notebook', 'Ideapad 3', 'Lenovo', 1),
('Smartphone', 'Moto G60', 'Motorola', 1),
('Tablet', 'Galaxy Tab S7', 'Samsung', 1),
('Smartphone', 'P40 Lite', 'Huawei', 1),
('Notebook', 'VivoBook 15', 'Asus', 1),
('Smartphone', 'Galaxy A52', 'Samsung', 1),
('Notebook', 'ProBook 450', 'HP', 1),
('Smartphone', 'iPhone 12', 'Apple', 1),
('Tablet', 'MatePad', 'Huawei', 1),
('Smartphone', 'Redmi 9', 'Xiaomi', 1),
('Notebook', 'Swift 3', 'Acer', 1),
('Smartphone', 'Moto E7 Plus', 'Motorola', 1),
('Tablet', 'iPad 9', 'Apple', 1),
('Smartphone', 'Galaxy M32', 'Samsung', 1),
('Notebook', 'Inspiron 14', 'Dell', 1),
('Smartphone', 'P30 Pro', 'Huawei', 1),
('Notebook', 'Legion 5', 'Lenovo', 1),
('Smartphone', 'iPhone 11', 'Apple', 1),
('Tablet', 'MediaPad T5', 'Huawei', 1),
('Smartphone', 'Redmi Note 9', 'Xiaomi', 1),
('Notebook', 'Aspire 5', 'Acer', 1),
('Smartphone', 'Moto G30', 'Motorola', 1),
('Tablet', 'Galaxy Tab A7', 'Samsung', 1),
('Smartphone', 'Galaxy S20', 'Samsung', 1),
('Notebook', 'ZenBook 14', 'Asus', 1),
('Smartphone', 'P40 Pro', 'Huawei', 1),
('Notebook', 'EliteBook 840', 'HP', 1),
('Smartphone', 'iPhone XR', 'Apple', 1),
('Tablet', 'iPad Mini', 'Apple', 1),
('Smartphone', 'Redmi 8', 'Xiaomi', 1),
('Notebook', 'Predator Helios', 'Acer', 1),
('Smartphone', 'Moto G9', 'Motorola', 1),
('Tablet', 'MatePad Pro', 'Huawei', 1),
('Smartphone', 'Galaxy A32', 'Samsung', 1),
('Notebook', 'XPS 13', 'Dell', 1),
('Smartphone', 'Nova 7i', 'Huawei', 1),
('Notebook', 'ThinkPad E14', 'Lenovo', 1),
('Smartphone', 'iPhone SE', 'Apple', 1),
('Tablet', 'Galaxy Tab S6', 'Samsung', 1),
('Smartphone', 'Redmi Note 8', 'Xiaomi', 1),
('Notebook', 'Nitro 5', 'Acer', 1),
('Smartphone', 'Moto G8', 'Motorola', 1),
('Tablet', 'iPad 8', 'Apple', 1),
('Smartphone', 'Galaxy M12', 'Samsung', 1);










