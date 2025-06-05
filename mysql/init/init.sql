USE `eniwhere_db`;

CREATE TABLE IF NOT EXISTS `addresses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postal_code` VARCHAR(20) NULL,
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
  UNIQUE (`user_password`),
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
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` DATETIME NULL,
  `feedback` INT NULL,
  `warranty` INT NULL,
  `cost` VARCHAR(45) NULL,
  `work` VARCHAR(255) NULL,
  `status` VARCHAR(100) NULL DEFAULT 'pending',
  `deadline` DATE NULL,
  `problem` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_device_id`) REFERENCES `user_devices` (`id`),
  FOREIGN KEY (`worker_id`) REFERENCES `store_workers` (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `admins` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`username`),
  UNIQUE (`user_password`)
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


CREATE TABLE IF NOT EXISTS `pictures` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_order_id` INT NOT NULL,
  `path` VARCHAR(255),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`service_order_id`) REFERENCES `service_orders` (`id`)
) ENGINE = InnoDB;

-- inserts de teste
INSERT INTO `addresses` (`postal_code`, `country`, `state`, `city`, `neighborhood`, `address_line`) VALUES
('12345-678', 'Brazil', 'SP', 'São Paulo', 'Centro', 'Rua A, 123'),
('23456-789', 'Brazil', 'RJ', 'Rio de Janeiro', 'Copacabana', 'Avenida Atlântica, 500'),
('34567-890', 'Brazil', 'MG', 'Belo Horizonte', 'Savassi', 'Rua B, 456'),
('45678-901', 'Brazil', 'RS', 'Porto Alegre', 'Moinhos', 'Rua C, 789'),
('56789-012', 'Brazil', 'BA', 'Salvador', 'Pelourinho', 'Ladeira D, 321');


INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('12345678900', 'João Silva', 'joao@example.com', '11999999999', 'joaosilva', 'senha123', '101', 1, 1),
('98765432100', 'Maria Souza', 'maria@example.com', '21988888888', 'mariasouza', 'senha456', '202', 2, 1),
('11223344556', 'Carlos Lima', 'carlos@example.com', '31977777777', 'carlima', 'senha789', '303', 3, 1),
('66554433221', 'Ana Paula', 'ana@example.com', '41966666666', 'anapaula', 'senha321', '404', 4, 1),
('99887766554', 'Bruno Costa', 'bruno@example.com', '51955555555', 'brunocosta', 'senha654', '505', 5, 0);


INSERT INTO `devices` (`device_name`, `model`, `brand`, `active`) VALUES
('iPhone 13', 'A2633', 'Apple', 1),
('Galaxy S21', 'SM-G991B', 'Samsung', 1),
('Redmi Note 10', 'M2101K7AG', 'Xiaomi', 1),
('Moto G9', 'XT2083-1', 'Motorola', 1),
('Zenfone 8', 'ZS590KS', 'Asus', 0);


INSERT INTO `user_devices` (`user_id`, `device_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO `stores` (`name`, `document`, `email`, `username`, `user_password`, `number`, `address_id`, `subscription_end`, `analytics`, `active`) VALUES
('Loja SP', '12345678000100', 'loja1@exemplo.com', 'loja1', 'senha1', 101, 1, '2026-12-31 23:59:59', 1, 1),
('Loja RJ', '23456789000111', 'loja2@exemplo.com', 'loja2', 'senha2', 202, 2, '2025-11-30 23:59:59', 0, 1),
('Loja MG', '34567890000122', 'loja3@exemplo.com', 'loja3', 'senha3', 303, 3, '2025-10-31 23:59:59', 1, 1),
('Loja RS', '45678900000133', 'loja4@exemplo.com', 'loja4', 'senha4', 404, 4, '2025-09-30 23:59:59', 0, 0),
('Loja BA', '56789000000144', 'loja5@exemplo.com', 'loja5', 'senha5', 505, 5, '2025-08-31 23:59:59', 1, 1);

INSERT INTO `store_workers` (`name`, `username`, `user_password`, `store_id`) VALUES
('Lucas Rocha', 'lucasr', 'senha123', 1),
('Juliana Prado', 'julianap', 'senha456', 2),
('Marcos Vinícius', 'marcosv', 'senha789', 3),
('Fernanda Lima', 'fernandal', 'senha321', 4),
('Paulo Sérgio', 'paulos', 'senha654', 5);


INSERT INTO `service_orders` (`user_device_id`, `worker_id`, `store_id`, `created_at`, `completed_at`, `feedback`, `warranty`, `cost`, `work`, `status`, `deadline`, `problem`) VALUES
(1, 1, 1, NOW(), NULL, NULL, 6, '250.00', 'Troca de tela', 'pending', '2025-06-15', 'Tela quebrada'),
(2, 2, 2, NOW(), '2025-06-01 14:00:00', 10, 12, '180.00', 'Troca de bateria', 'completed', '2025-06-05', 'Bateria descarregando'),
(3, 3, 3, NOW(), NULL, NULL, NULL, NULL, NULL, 'pending', '2025-06-20', 'Celular não liga'),
(4, 4, 4, NOW(), NULL, NULL, 3, '400.00', 'Troca de placa', 'in progress', '2025-06-30', 'Sem sinal'),
(5, 5, 5, NOW(), NULL, NULL, 6, '150.00', 'Limpeza e manutenção', 'pending', '2025-07-01', 'Aquecimento excessivo');


INSERT INTO `order_logs` (`service_order_id`, `cost`, `work`, `status`, `deadline`, `problem`, `log_date`) VALUES
(1, '250.00', 'Troca de tela', 'pending', '2025-06-15', 'Tela quebrada', NOW()),
(2, '180.00', 'Troca de bateria', 'completed', '2025-06-05', 'Bateria descarregando', NOW()),
(3, '0.00', 'Diagnóstico', 'pending', '2025-06-20', 'Celular não liga', NOW()),
(4, '400.00', 'Troca de placa', 'in progress', '2025-06-30', 'Sem sinal', NOW()),
(5, '150.00', 'Limpeza e manutenção', 'pending', '2025-07-01', 'Aquecimento excessivo', NOW());


INSERT INTO `admins` (`username`, `user_password`) VALUES
('admin1', 'senhaSegura123'),
('admin2', 'senhaForte456'),
('admin3', 'adminPass789'),
('superuser', 'rootAccess999'),
('Luw','luw12345'),
('gestor_ti', 'ti@empresa2025');


INSERT INTO `pictures` (`service_order_id`, `path`) VALUES
(1, '/uploads/tela_quebrada.jpg'),
(2, '/uploads/bateria_ruim.jpg'),
(3, '/uploads/celular_morto.jpg'),
(4, '/uploads/placa_queimada.jpg'),
(5, '/uploads/sujeira_interna.jpg');