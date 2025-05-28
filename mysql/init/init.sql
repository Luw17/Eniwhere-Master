USE `eniwhere_db`;

CREATE TABLE IF NOT EXISTS `addresses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postal_code` VARCHAR(20) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `neighborhood` VARCHAR(100) NOT NULL,
  `address_line` VARCHAR(255) NOT NULL,
  UNIQUE (`id`),
  UNIQUE (`postal_code`),
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
  `code` VARCHAR(45),
  `validity` DATETIME,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`email`),
  UNIQUE (`username`),
  UNIQUE (`user_password`),
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `devices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `device_name` VARCHAR(100) NOT NULL,
  `model` VARCHAR(100) NOT NULL,
  `brand` VARCHAR(100) NOT NULL,
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
  `code` VARCHAR(45) NOT NULL,
  `validity` DATETIME NOT NULL,
  `address_id` INT NOT NULL,
  `subscription_end` DATETIME NOT NULL,
  `analytics` TINYINT NOT NULL DEFAULT 0,
  `storecol` VARCHAR(45),
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`username`),
  UNIQUE (`user_password`),
  UNIQUE (`code`),
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `store_workers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100),
  `username` VARCHAR(45),
  `user_password` VARCHAR(100),
  `store_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `service_orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_device_id` INT NOT NULL,
  `worker_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `completed_at` DATETIME NULL,
  `feedback` INT NULL,
  `warranty` INT NULL,
  `cost` VARCHAR(45) NULL,
  `work` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL,
  `deadline` DATE NULL,
  `problem` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_device_id`) REFERENCES `user_devices` (`id`),
  FOREIGN KEY (`worker_id`) REFERENCES `store_workers` (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `user_2fa_codes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `validity` DATETIME NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`user_id`) REFERENCES `app_users` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `admins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  `code` VARCHAR(45) NOT NULL,
  `validity` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`username`),
  UNIQUE (`user_password`),
  UNIQUE (`code`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `order_logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_order_id` INT NOT NULL,
  `cost` VARCHAR(45) NOT NULL,
  `work` VARCHAR(255) NOT NULL,
  `status` VARCHAR(100) NOT NULL,
  `deadline` DATE NOT NULL,
  `problem` VARCHAR(255) NOT NULL,
  `log_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `store_2fa_codes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `validity` DATETIME NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `admin_2fa_codes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45) NOT NULL,
  `validity` DATETIME NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `pictures` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_order_id` INT NOT NULL,
  `path` VARCHAR(255),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `worker_2fa_codes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(45),
  `validity` VARCHAR(45),
  `worker_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`worker_id`) REFERENCES `store_workers` (`id`)
) ENGINE = InnoDB;


-- inserts de teste
-- inserts de teste
INSERT INTO `addresses` (`id`, `postal_code`, `country`, `state`, `city`, `neighborhood`, `address_line`) VALUES
(1, '12345-678', 'Brasil', 'SP', 'São Paulo', 'Centro', 'Rua A, 100'),
(2, '98765-432', 'Brasil', 'RJ', 'Rio de Janeiro', 'Copacabana', 'Avenida B, 200');

INSERT INTO `app_users` (`id`, `document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `code`, `validity`, `address_id`) VALUES
(1, '12345678900', 'João Silva', 'joao@example.com', '11999999999', 'joaos', 'senha123', '10', 'ABC123', '2025-12-31 23:59:59', 1),
(2, '98765432100', 'Maria Souza', 'maria@example.com', '21988888888', 'marias', 'senha456', '20', 'DEF456', '2025-12-31 23:59:59', 2);

INSERT INTO `devices` (`id`, `device_name`, `model`, `brand`) VALUES
(1, 'Smartphone', 'Galaxy S21', 'Samsung'),
(2, 'Laptop', 'XPS 13', 'Dell');

INSERT INTO `user_devices` (`id`, `user_id`, `device_id`) VALUES
(1, 1, 1),
(2, 2, 2);

INSERT INTO `stores` (`id`, `name`, `document`, `email`, `username`, `user_password`, `number`, `code`, `validity`, `address_id`, `subscription_end`, `analytics`, `storecol`) VALUES
(1, 'Loja Central', '12345678000199', 'contato@lojacentral.com', 'lojacentral', 'senhaLoja1', 100, 'CODE100', '2025-12-31 23:59:59', 1, '2026-12-31 23:59:59', 1, 'SC1'),
(2, 'Loja Leste', '98765432000199', 'contato@lojaleste.com', 'lojaleste', 'senhaLoja2', 200, 'CODE200', '2025-12-31 23:59:59', 2, '2026-12-31 23:59:59', 0, 'SC2');

INSERT INTO `store_workers` (`id`, `name`, `username`, `user_password`, `store_id`) VALUES
(1, 'Carlos Lima', 'carlosl', 'senhaWorker1', 1),
(2, 'Ana Paula', 'anap', 'senhaWorker2', 2);

-- ALTERADO AQUI: adicionado o campo `store_id`
INSERT INTO `service_orders` (`id`, `user_device_id`, `worker_id`, `store_id`, `created_at`, `completed_at`, `feedback`, `warranty`, `cost`, `work`, `status`, `deadline`, `problem`) VALUES
(1, 1, 1, 1, '2025-05-01 10:00:00', '2025-05-03 15:00:00', 5, 12, '150.00', 'Troca de tela', 'Concluído', '2025-05-05', 'Tela quebrada'),
(2, 2, 2, 2, '2025-05-02 11:00:00', NULL, 0, 0, NULL, NULL, 'Em andamento', '2025-05-10', 'Problema de bateria');

INSERT INTO `user_2fa_codes` (`id`, `code`, `validity`, `user_id`) VALUES
(1, '2FA123', '2025-06-01 12:00:00', 1),
(2, '2FA456', '2025-06-01 12:00:00', 2);

INSERT INTO `admins` (`id`, `username`, `user_password`, `code`, `validity`) VALUES
(1, 'admin1', 'senhaAdmin1', 'ADM123', '2025-12-31 23:59:59'),
(2, 'admin2', 'senhaAdmin2', 'ADM456', '2025-12-31 23:59:59');

INSERT INTO `order_logs` (`id`, `service_order_id`, `cost`, `work`, `status`, `deadline`, `problem`, `log_date`) VALUES
(1, 1, '150.00', 'Troca de tela', 'Concluído', '2025-05-05', 'Tela quebrada', '2025-05-03 15:00:00'),
(2, 2, '', '', 'Em andamento', '2025-05-10', 'Problema de bateria', '2025-05-02 11:00:00');

INSERT INTO `store_2fa_codes` (`id`, `code`, `validity`, `store_id`) VALUES
(1, 'S2FA123', '2025-06-01 12:00:00', 1),
(2, 'S2FA456', '2025-06-01 12:00:00', 2);

INSERT INTO `admin_2fa_codes` (`id`, `code`, `validity`, `admin_id`) VALUES
(1, 'A2FA123', '2025-06-01 12:00:00', 1),
(2, 'A2FA456', '2025-06-01 12:00:00', 2);

INSERT INTO `pictures` (`id`, `service_order_id`, `path`) VALUES
(1, 1, '/images/orders/1_pic1.jpg'),
(2, 1, '/images/orders/1_pic2.jpg');

INSERT INTO `worker_2fa_codes` (`id`, `code`, `validity`, `worker_id`) VALUES
(1, 'W2FA123', '2025-06-01 12:00:00', 1),
(2, 'W2FA456', '2025-06-01 12:00:00', 2);
