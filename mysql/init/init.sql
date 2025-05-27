USE `db_eniwhere`;

CREATE TABLE IF NOT EXISTS `address` (
  `id` INT NOT NULL,
  `postal_code` TEXT NOT NULL,
  `country` TEXT NOT NULL,
  `state` TEXT NOT NULL,
  `city` TEXT NOT NULL,
  `neighborhood` TEXT NOT NULL,
  `address` TEXT NOT NULL,
  UNIQUE (`id`),
  UNIQUE (`postal_code`),
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL,
  `document` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45),
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45),
  `user` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `number` VARCHAR(45),
  `code` VARCHAR(45),
  `validity` DATETIME,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`email`),
  UNIQUE (`user`),
  UNIQUE (`password`),
  FOREIGN KEY (`address_id`) REFERENCES `address` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `device` (
  `id` INT NOT NULL,
  `device` TEXT NOT NULL,
  `model` TEXT NOT NULL,
  `brand` TEXT NOT NULL,
  UNIQUE (`id`),
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `user_has_device` (
  `id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `device_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`device_id`) REFERENCES `device` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `store` (
  `id` INT NOT NULL,
  `name` TEXT NOT NULL,
  `document` VARCHAR(45) NOT NULL,
  `email` TEXT NOT NULL,
  `user` TEXT NOT NULL,
  `password` TEXT NOT NULL,
  `number` INT NOT NULL,
  `code` TEXT NOT NULL,
  `validity` DATETIME NOT NULL,
  `address_id` INT NOT NULL,
  `sub_end` DATETIME NOT NULL,
  `analitcs` TINYINT NOT NULL DEFAULT 0,
  `storecol` VARCHAR(45),
  PRIMARY KEY (`id`),
  UNIQUE (`document`),
  UNIQUE (`user`),
  UNIQUE (`password`),
  UNIQUE (`code`),
  FOREIGN KEY (`address_id`) REFERENCES `address` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `workers` (
  `id` INT NOT NULL,
  `name` VARCHAR(45),
  `user` VARCHAR(45),
  `password` VARCHAR(45),
  `store_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`store_id`) REFERENCES `store` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `order` (
  `id` INT NOT NULL,
  `user_has_device_id` INT NOT NULL,
  `workers_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `completed_at` DATETIME NOT NULL,
  `feedback` INT NOT NULL,
  `warranty` INT NOT NULL,
  `cost` TEXT,
  `work` TEXT,
  `status` TEXT,
  `deadline` DATE,
  `problem` TEXT,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_has_device_id`) REFERENCES `user_has_device` (`id`),
  FOREIGN KEY (`workers_id`) REFERENCES `workers` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `2fcode` (
  `id` INT NOT NULL,
  `code` TEXT NOT NULL,
  `validity` DATETIME NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `adm` (
  `id` INT NOT NULL,
  `user` TEXT NOT NULL,
  `password` TEXT NOT NULL,
  `code` TEXT NOT NULL,
  `validity` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`user`),
  UNIQUE (`password`),
  UNIQUE (`code`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `order_log` (
  `id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `cost` TEXT NOT NULL,
  `work` TEXT NOT NULL,
  `status` TEXT NOT NULL,
  `deadline` DATE NOT NULL,
  `problem` TEXT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `order` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `2fcode_store` (
  `id` INT NOT NULL,
  `code` TEXT NOT NULL,
  `validity` DATETIME NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`store_id`) REFERENCES `store` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `2fcode_adm` (
  `id` INT NOT NULL,
  `code` TEXT NOT NULL,
  `validity` DATETIME NOT NULL,
  `adm_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`code`),
  FOREIGN KEY (`adm_id`) REFERENCES `adm` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `picture` (
  `id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `path` VARCHAR(255),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `order` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `2fcode_workers` (
  `id` INT NOT NULL,
  `code` TEXT,
  `validity` TEXT,
  `workers_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`workers_id`) REFERENCES `workers` (`id`)
) ENGINE = InnoDB;
