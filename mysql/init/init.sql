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
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `store_workers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100),
  `username` VARCHAR(45),
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

-- inserts de teste
INSERT INTO `addresses` (`postal_code`, `country`, `state`, `city`, `neighborhood`, `address_line`) VALUES
('12345-678', 'Brazil', 'SP', 'São Paulo', 'Centro', 'Rua A, 123'),
('23456-789', 'Brazil', 'RJ', 'Rio de Janeiro', 'Copacabana', 'Avenida Atlântica, 500'),
('34567-890', 'Brazil', 'MG', 'Belo Horizonte', 'Savassi', 'Rua B, 456'),
('45678-901', 'Brazil', 'RS', 'Porto Alegre', 'Moinhos', 'Rua C, 789'),
('56789-012', 'Brazil', 'BA', 'Salvador', 'Pelourinho', 'Ladeira D, 321');
INSERT INTO `addresses` (`postal_code`, `country`, `state`, `city`, `neighborhood`, `address_line`) VALUES
('01001-000', 'Brasil', 'SP', 'São Paulo', 'Sé', 'Praça da Sé, 1'),
('20020-010', 'Brasil', 'RJ', 'Rio de Janeiro', 'Centro', 'Av. Rio Branco, 1'),
('30110-000', 'Brasil', 'MG', 'Belo Horizonte', 'Funcionários', 'Av. do Contorno, 1000'),
('40010-000', 'Brasil', 'BA', 'Salvador', 'Comércio', 'Rua Chile, 15'),
('50010-000', 'Brasil', 'PE', 'Recife', 'Boa Vista', 'Rua Imperial, 100'),
('60010-000', 'Brasil', 'CE', 'Fortaleza', 'Centro', 'Rua Barão do Rio Branco, 1'),
('70010-000', 'Brasil', 'DF', 'Brasília', 'Asa Sul', 'SHS Quadra 1'),
('80010-000', 'Brasil', 'PR', 'Curitiba', 'Centro', 'Rua XV de Novembro, 1'),
('90010-000', 'Brasil', 'RS', 'Porto Alegre', 'Centro Histórico', 'Praça Marechal Deodoro, 1'),
('01020-000', 'Brasil', 'SP', 'São Paulo', 'República', 'Av. Ipiranga, 100'),
('20030-020', 'Brasil', 'RJ', 'Rio de Janeiro', 'Centro', 'Rua da Carioca, 50'),
('30120-010', 'Brasil', 'MG', 'Belo Horizonte', 'Savassi', 'Rua Pernambuco, 100'),
('40020-010', 'Brasil', 'BA', 'Salvador', 'Pelourinho', 'Largo do Pelourinho, 1'),
('50020-010', 'Brasil', 'PE', 'Recife', 'Santo Antônio', 'Rua do Imperador, 100'),
('60020-010', 'Brasil', 'CE', 'Fortaleza', 'Aldeota', 'Av. Dom Luís, 500'),
('70020-010', 'Brasil', 'DF', 'Brasília', 'Asa Norte', 'CLN 101 Bloco A'),
('80020-010', 'Brasil', 'PR', 'Curitiba', 'Batel', 'Av. do Batel, 1000'),
('90020-010', 'Brasil', 'RS', 'Porto Alegre', 'Moinhos de Vento', 'Rua Padre Chagas, 100'),
('01030-000', 'Brasil', 'SP', 'São Paulo', 'Bela Vista', 'Rua 13 de Maio, 100'),
('20040-030', 'Brasil', 'RJ', 'Rio de Janeiro', 'Botafogo', 'Rua Voluntários da Pátria, 100'),
('30130-020', 'Brasil', 'MG', 'Belo Horizonte', 'Lourdes', 'Rua da Bahia, 1000'),
('40030-020', 'Brasil', 'BA', 'Salvador', 'Barra', 'Av. Oceânica, 100'),
('50030-020', 'Brasil', 'PE', 'Recife', 'Boa Viagem', 'Av. Boa Viagem, 1000'),
('60030-020', 'Brasil', 'CE', 'Fortaleza', 'Meireles', 'Av. Beira Mar, 1000'),
('70030-020', 'Brasil', 'DF', 'Brasília', 'Sudoeste', 'CLSW 101 Bloco A'),
('80030-020', 'Brasil', 'PR', 'Curitiba', 'Bigorrilho', 'Rua Padre Anchieta, 1000'),
('90030-020', 'Brasil', 'RS', 'Porto Alegre', 'Petrópolis', 'Rua Coronel Bordini, 1000'),
('01040-000', 'Brasil', 'SP', 'São Paulo', 'Consolação', 'Rua da Consolação, 1000'),
('20050-040', 'Brasil', 'RJ', 'Rio de Janeiro', 'Copacabana', 'Av. Atlântica, 100'),
('30140-030', 'Brasil', 'MG', 'Belo Horizonte', 'Sion', 'Rua dos Inconfidentes, 1000'),
('40040-030', 'Brasil', 'BA', 'Salvador', 'Ondina', 'Av. Adhemar de Barros, 100'),
('50040-030', 'Brasil', 'PE', 'Recife', 'Pina', 'Av. Herculano Bandeira, 100'),
('60040-030', 'Brasil', 'CE', 'Fortaleza', 'Dionísio Torres', 'Av. Santos Dumont, 1000'),
('70040-030', 'Brasil', 'DF', 'Brasília', 'Lago Sul', 'SHIS QI 5 Bloco A'),
('80040-030', 'Brasil', 'PR', 'Curitiba', 'Água Verde', 'Rua Solimões, 1000'),
('90040-030', 'Brasil', 'RS', 'Porto Alegre', 'Tristeza', 'Av. Wenceslau Escobar, 1000'),
('01050-000', 'Brasil', 'SP', 'São Paulo', 'Higienópolis', 'Rua Maranhão, 1000'),
('20060-050', 'Brasil', 'RJ', 'Rio de Janeiro', 'Ipanema', 'Rua Visconde de Pirajá, 100'),
('30150-040', 'Brasil', 'MG', 'Belo Horizonte', 'Cidade Nova', 'Av. Cristiano Machado, 1000'),
('40050-040', 'Brasil', 'BA', 'Salvador', 'Pituba', 'Av. Manoel Dias da Silva, 1000'),
('50050-040', 'Brasil', 'PE', 'Recife', 'Casa Forte', 'Av. 17 de Agosto, 1000'),
('60050-040', 'Brasil', 'CE', 'Fortaleza', 'Papicu', 'Av. Engenheiro Santana Júnior, 1000'),
('70050-040', 'Brasil', 'DF', 'Brasília', 'Lago Norte', 'SHIN QI 5 Bloco A'),
('80050-040', 'Brasil', 'PR', 'Curitiba', 'Cristo Rei', 'Rua Desembargador Westphalen, 1000'),
('90050-040', 'Brasil', 'RS', 'Porto Alegre', 'Bela Vista', 'Av. Plínio Brasil Milano, 1000'),
('01060-000', 'Brasil', 'SP', 'São Paulo', 'Vila Mariana', 'Rua Domingos de Morais, 1000'),
('20070-060', 'Brasil', 'RJ', 'Rio de Janeiro', 'Leblon', 'Rua Dias Ferreira, 100'),
('30160-050', 'Brasil', 'MG', 'Belo Horizonte', 'Santa Efigênia', 'Rua dos Tamoios, 1000'),
('40060-050', 'Brasil', 'BA', 'Salvador', 'Caminho das Árvores', 'Av. Antônio Carlos Magalhães, 1000'),
('50060-050', 'Brasil', 'PE', 'Recife', 'Graças', 'Rua Benfica, 1000'),
('60060-050', 'Brasil', 'CE', 'Fortaleza', 'Cocó', 'Av. Washington Soares, 1000'),
('70060-050', 'Brasil', 'DF', 'Brasília', 'Guará', 'QE 11 Área Especial A'),
('80060-050', 'Brasil', 'PR', 'Curitiba', 'Mercês', 'Rua Trajano Reis, 1000'),
('90060-050', 'Brasil', 'RS', 'Porto Alegre', 'Santana', 'Av. Assis Brasil, 1000'),
('01070-000', 'Brasil', 'SP', 'São Paulo', 'Pinheiros', 'Rua Teodoro Sampaio, 1000'),
('20080-070', 'Brasil', 'RJ', 'Rio de Janeiro', 'Barra da Tijuca', 'Av. das Américas, 1000'),
('30170-060', 'Brasil', 'MG', 'Belo Horizonte', 'Pampulha', 'Av. Antônio Abrahão Caram, 1000'),
('40070-060', 'Brasil', 'BA', 'Salvador', 'Horto Florestal', 'Rua Patagônia, 100'),
('50070-060', 'Brasil', 'PE', 'Recife', 'Espinheiro', 'Rua do Espinheiro, 100'),
('60070-060', 'Brasil', 'CE', 'Fortaleza', 'Varjota', 'Rua Torres Câmara, 100'),
('70070-060', 'Brasil', 'DF', 'Brasília', 'Taguatinga', 'QSA 1 Área Especial A'),
('80070-060', 'Brasil', 'PR', 'Curitiba', 'Cabral', 'Rua Brigadeiro Franco, 1000'),
('90070-060', 'Brasil', 'RS', 'Porto Alegre', 'Rio Branco', 'Av. Osvaldo Aranha, 1000'),
('01080-000', 'Brasil', 'SP', 'São Paulo', 'Itaim Bibi', 'Rua Joaquim Floriano, 1000'),
('20090-080', 'Brasil', 'RJ', 'Rio de Janeiro', 'Tijuca', 'Rua Conde de Bonfim, 1000'),
('30180-070', 'Brasil', 'MG', 'Belo Horizonte', 'Coração Eucarístico', 'Av. Dom José Gaspar, 1000'),
('40080-070', 'Brasil', 'BA', 'Salvador', 'Itaigara', 'Av. Tancredo Neves, 1000'),
('50080-070', 'Brasil', 'PE', 'Recife', 'Rosarinho', 'Rua do Futuro, 1000'),
('60080-070', 'Brasil', 'CE', 'Fortaleza', 'Benfica', 'Av. da Universidade, 1000'),
('70080-070', 'Brasil', 'DF', 'Brasília', 'Águas Claras', 'Av. das Araucárias, 1000'),
('80080-070', 'Brasil', 'PR', 'Curitiba', 'Bom Retiro', 'Rua 24 de Maio, 1000'),
('90080-070', 'Brasil', 'RS', 'Porto Alegre', 'Independência', 'Rua Sarmento Leite, 1000'),
('01090-000', 'Brasil', 'SP', 'São Paulo', 'Moema', 'Av. Ibirapuera, 1000'),
('20100-090', 'Brasil', 'RJ', 'Rio de Janeiro', 'Flamengo', 'Rua Dois de Dezembro, 100'),
('30190-080', 'Brasil', 'MG', 'Belo Horizonte', 'Gutierrez', 'Rua Alagoas, 1000'),
('40090-080', 'Brasil', 'BA', 'Salvador', 'Stiep', 'Av. Orlando Gomes, 1000'),
('50090-080', 'Brasil', 'PE', 'Recife', 'Madalena', 'Rua Real da Torre, 1000'),
('60090-080', 'Brasil', 'CE', 'Fortaleza', 'Parquelândia', 'Rua Professor Dias da Rocha, 1000'),
('70090-080', 'Brasil', 'DF', 'Brasília', 'Sobradinho', 'Quadra 1 Área Especial A'),
('80090-080', 'Brasil', 'PR', 'Curitiba', 'Juvevê', 'Rua Ubaldino do Amaral, 1000'),
('90090-080', 'Brasil', 'RS', 'Porto Alegre', 'Cidade Baixa', 'Rua João Alfredo, 1000'),
('01100-000', 'Brasil', 'SP', 'São Paulo', 'Jardim Paulista', 'Rua Haddock Lobo, 1000'),
('20110-100', 'Brasil', 'RJ', 'Rio de Janeiro', 'Laranjeiras', 'Rua das Laranjeiras, 100'),
('30200-090', 'Brasil', 'MG', 'Belo Horizonte', 'Santo Antônio', 'Rua Timbiras, 1000'),
('40100-090', 'Brasil', 'BA', 'Salvador', 'Brotas', 'Av. Dom João VI, 1000'),
('50100-090', 'Brasil', 'PE', 'Recife', 'Parnamirim', 'Rua Professor José Brandão, 1000'),
('60100-090', 'Brasil', 'CE', 'Fortaleza', 'Fátima', 'Rua 24 de Maio, 1000'),
('70100-090', 'Brasil', 'DF', 'Brasília', 'Planaltina', 'Área Especial 1'),
('80100-090', 'Brasil', 'PR', 'Curitiba', 'Hugo Lange', 'Rua Presidente Taunay, 1000'),
('90100-090', 'Brasil', 'RS', 'Porto Alegre', 'Centro Histórico', 'Rua dos Andradas, 1000');
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('11122233344', 'João Silva', 'joao.silva@email.com', '11987654321', 'joaosilvaa', '$2b$10$QoGo7/zvqT2wymqAOezb4udHUiAg82Zqah10/.70.p4tk3QB1XgRG', 'Apto 101', 1, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('22233344455', 'Maria Oliveira', 'maria.oliveira@email.com', '21987654321', 'mariaoliveira', '$2b$10$tCYDNoBDrmrh1TszPeuojOqhyWocMqffF5NTksF8N4YAjCkjm.9sy', 'Casa 2', 2, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('33344455566', 'Carlos Souza', 'carlos.souza@email.com', '31987654321', 'carlossouza', '$2b$10$/cAJIITdensmEF59emmVL.d5z7qw.06FqIlEXgzBWmwF9Bga8l.4K', 'Bloco A', 3, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('44455566677', 'Ana Costa', 'ana.costa@email.com', '41987654321', 'anacosta', '$2b$10$ptzh1losI2cdg2rojTH8B.GF7KrjVKdbVJm8PEBhhInux/7SRlcD2', 'Sala 10', 4, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('55566677788', 'Pedro Santos', 'pedro.santos@email.com', '51987654321', 'pedrosantos', '$2b$10$e9ENS/l1OZGMbH7fwuXPwOfjzpWWMTKOdvv8Mxlmjo1XZFh0240Li', 'Apto 202', 5, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('66677788899', 'Mariana Lima', 'mariana.lima@email.com', '61987654321', 'marianalima', '$2b$10$TwHIk1UhMLMKwepizz2sgOtcAdAsxPF2XYuqyE7ybnNgJ3BYf79Sy', 'Casa 5', 6, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('77788899900', 'Lucas Pereira', 'lucas.pereira@email.com', '71987654321', 'lucaspereira', '$2b$10$Uzw/O4/9snOP6ap34hU8QOjnHOhdgKty7enVL1Vr9cQFPxO79oR72', 'Bloco B', 7, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('88899900011', 'Juliana Alves', 'juliana.alves@email.com', '81987654321', 'julianaalves', '$2b$10$BF4LyaZLiWKEOFvup03DL.oGfUWLhOkTvJ//SoyC4K.1Y8jchJvMa', 'Sala 20', 8, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('99900011122', 'Fernando Gomes', 'fernando.gomes@email.com', '85987654321', 'fernandogomes', '$2b$10$DpNy9KqpB19m9DHAwP8nUu1VL9IqytpdRWP1idLCr7RBcYoNipi8.', 'Apto 303', 9, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('00011122233', 'Patrícia Ribeiro', 'patricia.ribeiro@email.com', '11987654322', 'patriciaribeiro', '$2b$10$MneyBxKdYAiQ1wr3cZqknuVY.N8dUT48UAfGEvds3qF9k7ablcUau', 'Casa 8', 10, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('11122233345', 'Ricardo Martins', 'ricardo.martins@email.com', '21987654322', 'ricardomartins', '$2b$10$1283sDELHV3NzN.bKW8xCefMWPxnUE/PFcNmIeAOR6CUgCtnjrYFC', 'Bloco C', 11, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('22233344456', 'Amanda Ferreira', 'amanda.ferreira@email.com', '31987654322', 'amandaferreira', '$2b$10$gMFZAJKhwdtXRsYyX/39NuXizdJalHLKXy..lNdajQT1J.aU7NhYq', 'Sala 30', 12, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('33344455567', 'Roberto Carvalho', 'roberto.carvalho@email.com', '41987654322', 'robertocarvalho', '$2b$10$nRJPjojZNQNcglj/jlOOt.F5t9d7YdgAhxoeUcClX8g9oCer9PYbC', 'Apto 404', 13, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('44455566678', 'Tatiane Nunes', 'tatiane.nunes@email.com', '51987654322', 'tatianenunes', '$2b$10$BANXH/Nt2Y8t6HUNL75uk.atrBPz.VCwP8PBFklQJbUg/laKcBz/C', 'Casa 12', 14, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('55566677789', 'Eduardo Rocha', 'eduardo.rocha@email.com', '61987654322', 'eduardorocha', '$2b$10$jBYXSA6NoZyOaV11RaFlruWe6ywJakl/SjBru8gOsDyh5RoNOH2sq', 'Bloco D', 15, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('66677788890', 'Vanessa Correia', 'vanessa.correia@email.com', '71987654322', 'vanessacorreia', '$2b$10$PkuEj3Se982sxwu97U11HOkCYE0KxxM0bXrf0Ec6niRCeZspAtpzS', 'Sala 40', 16, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('77788899901', 'Marcos Pinto', 'marcos.pinto@email.com', '81987654322', 'marcospinto', '$2b$10$tQhElnWsBiutr7ofE7N9reTjM3vg2S66xDGnKhecXp.KBmeI2qGy2', 'Apto 505', 17, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('88899900012', 'Cristina Dias', 'cristina.dias@email.com', '85987654322', 'cristinadias', '$2b$10$hAubu8s01T7hFv2vHu6F6./rJM4r0wA39P1FvbjqCf6AXCQ62m0Nu', 'Casa 15', 18, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('99900011123', 'Gustavo Monteiro', 'gustavo.monteiro@email.com', '11987654323', 'gustavomonteiro', '$2b$10$n/DMJ5F8.ecrkA2it21qzunR0.fN.CuHmIVnNmHGKAi0h4C8DqpN2', 'Bloco E', 19, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('00011122234', 'Isabela Cunha', 'isabela.cunha@email.com', '21987654323', 'isabelacunha', '$2b$10$Wwf4znp9NTdWbl9tkJLzTumOr13wF37eQVO0sktYqswUmtn0YDs2i', 'Sala 50', 20, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('11122233346', 'Rodrigo Moreira', 'rodrigo.moreira@email.com', '31987654323', 'rodrigomoreira', '$2b$10$FkUiaYX0fz2zOx70juk3hu7uSVcLjWJ3ydTijBD8nptwjGeZy77Ga', 'Apto 606', 21, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('22233344457', 'Larissa Cardoso', 'larissa.cardoso@email.com', '41987654323', 'larissacardoso', '$2b$10$X6q.G76g8tloPLsIw0SFV.K.rw/ZO/VyaDw3q75CTa8qjT3/hENR2', 'Casa 18', 22, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('33344455568', 'Felipe Ramos', 'felipe.ramos@email.com', '51987654323', 'feliperamos', '$2b$10$LxQInjYV/BbLKH7TF.mYg.dV6Orsq.Wrjf6vTwA2tRVsjn0hJ1liO', 'Bloco F', 23, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('44455566679', 'Daniela Peixoto', 'daniela.peixoto@email.com', '61987654323', 'danielapeixoto', '$2b$10$jvs/XfiZC87gnEGVbFET5enx14LEkZ9s1Yh8tnE5Y5VdKj6CZ5iI6', 'Sala 60', 24, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('55566677780', 'Alexandre Campos', 'alexandre.campos@email.com', '71987654323', 'alexandrecampos', '$2b$10$j3.Nb7DpRe/KDSEjcKM.y.u3AgfOg7BPzhQ3qo80XbAx1eD6FMQ/O', 'Apto 707', 25, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('66677788891', 'Beatriz Rezende', 'beatriz.rezende@email.com', '81987654323', 'beatrizrezende', '$2b$10$D0NZDrsEldpU08duF3jFxOjmoeRYJGq0NQBjQLQ8Xn6FVBwNoU1PS', 'Casa 20', 26, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('77788899902', 'Vinícius Guimarães', 'vinicius.guimaraes@email.com', '85987654323', 'viniciusguimaraes', '$2b$10$qSBprPjgqMpeYLCWv7OQM.reduQt3pxXt.uMUh7GTK/l5n2TXtc0G', 'Bloco G', 27, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('88899900013', 'Helena Barbosa', 'helena.barbosa@email.com', '11987654324', 'helenabarbosa', '$2b$10$z9jm33/IFTJ8Moxrmf.sNuy94duwDiAX961muTWMppmaJmi4WvGqe', 'Sala 70', 28, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('99900011124', 'Rafael Tavares', 'rafael.tavares@email.com', '21987654324', 'rafaeltavares', '$2b$10$2UglpSTWwxnoBSR1HSakPuoEryxUocS//0lFOdHBqIVFlzEfkT3KO', 'Apto 808', 29, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('00011122235', 'Camila Andrade', 'camila.andrade@email.com', '31987654324', 'camilaandrade', '$2b$10$DgCXlDYdROOYjJaU38aUG.I2xD.tCy/qdHcXbBBiIWzMN83elIkWm', 'Casa 22', 30, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('11122233347', 'Diego Mendes', 'diego.mendes@email.com', '41987654324', 'diegomendes', '$2b$10$QPQE90vWXxb4bI3jtwTbgOXCB0MVuY3y3tPdNi5r6ZVvz88olno1i', 'Bloco H', 31, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('22233344458', 'Laura Castro', 'laura.castro@email.com', '51987654324', 'lauracastro', '$2b$10$nv0HXCQeliFrIRqWmuWLWeW8pjrs38znpCeG9vbfTHELWAHIQ8Avu', 'Sala 80', 32, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('33344455569', 'Thiago Fonseca', 'thiago.fonseca@email.com', '61987654324', 'thiagofonseca', '$2b$10$BgN.Q6RKpc0Tg.fBgKK3geaz/RgdlUcjrPLDkWi2.9.CCU9EsdqQq', 'Apto 909', 33, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('44455566670', 'Natália Duarte', 'natalia.duarte@email.com', '71987654324', 'nataliaduarte', '$2b$10$vrtXEmg6NWC1KqEwZjSIOuvRYmOR78PNcF23LyCT7XhROjHH0OnU.', 'Casa 25', 34, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('55566677781', 'Bruno Lopes', 'bruno.lopes@email.com', '81987654324', 'brunolopes', '$2b$10$zYZGeu3oB48IkTJywhPgJehkS3bRadpqfklkFDc70WslLEu6jL6hC', 'Bloco I', 35, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('66677788892', 'Renata Miranda', 'renata.miranda@email.com', '85987654324', 'renatamiranda', '$2b$10$Ioro5L68oNXqUrC5B7ykA.tvniUEqw4yi4UkADHOXNwyrtg/4MhQG', 'Sala 90', 36, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('77788899903', 'Paulo Henrique', 'paulo.henrique@email.com', '11987654325', 'paulohenrique', '$2b$10$ESRtsuydY5XSpjKzns1rzOGZ0GdsV3p5G5zIHIkddDrahDq7v07jK', 'Apto 1010', 37, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('88899900014', 'Gabriela Sampaio', 'gabriela.sampaio@email.com', '21987654325', 'gabrielasampaio', '$2b$10$4UWg5a88T0kh.helSu.hNOjIQluAQks3eowBk4tVDvMVaHp.s6Wv2', 'Casa 28', 38, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('99900011125', 'Marcelo Brito', 'marcelo.brito@email.com', '31987654325', 'marcelobrito', '$2b$10$9tUU.KhCQfxikjtsXqaWEuhYCB2KyfOTO84KSVLzn6qqPpUqnQoYW', 'Bloco J', 39, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('00011122236', 'Letícia Azevedo', 'leticia.azevedo@email.com', '41987654325', 'leticiaazevedo', '$2b$10$Iia2olXkVAcea3eECL8bQekuXYIUqbEL4lFEk816HmmZgdmqQSfYS', 'Sala 100', 40, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('11122233348', 'Leonardo Pires', 'leonardo.pires@email.com', '51987654325', 'leonardopires', '$2b$10$LZOCENx0CIjm96G.2aJ7HeUaCEjLrci7V/a15XZQUvLdA2dSDRuOm', 'Apto 1111', 41, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('22233344459', 'Simone Xavier', 'simone.xavier@email.com', '61987654325', 'simonexavier', '$2b$10$LOp8Cz5nNLb7yrrJsatRGOhpAeiDkF6RHBK1r6Nknfu1ObtRckewK', 'Casa 30', 42, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('33344455560', 'André Vasconcelos', 'andre.vasconcelos@email.com', '71987654325', 'andrevasconcelos', '$2b$10$C6ID.UjVM./RW31rH0eaFe6Nx/NUzDdVqn6145mWq5JngdsmPZ0w.', 'Bloco K', 43, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('44455566671', 'Elaine Moraes', 'elaine.moraes@email.com', '81987654325', 'elainemoraes', '$2b$10$cElmMTmSMJY3xm7w10JP3.MR/43sXnJskX9Vg4BK1b4iUOTMXcF7C', 'Sala 110', 44, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('55566677782', 'Hugo Medeiros', 'hugo.medeiros@email.com', '85987654325', 'hugomedeiros', '$2b$10$xh.aeqWqfm3piG1a3/e/NegtTkN0IXRvCdkGEL.PTI5apZSQKl80u', 'Apto 1212', 45, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('66677788893', 'Carla Santana', 'carla.santana@email.com', '11987654326', 'carlasantana', '$2b$10$7mt4t93Kcwod8.QeAlXGEOt60zl3qkDTYi0cU/.eieWROPIWmVBwq', 'Casa 32', 46, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('77788899904', 'Otávio Freitas', 'otavio.freitas@email.com', '21987654326', 'otaviofreitas', '$2b$10$Ew65p16GmZnEAOdqqjGKpeQxrMmwgKnw9BCa3dn8l./OkU9gIs4D.', 'Bloco L', 47, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('88899900015', 'Yasmin Teixeira', 'yasmin.teixeira@email.com', '31987654326', 'yasminteixeira', '$2b$10$koEkAv8MX1qa3xE9nicHMOSEuCTU9bnS3ZWpNgqZThO5/h5e/mdJG', 'Sala 120', 48, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('99900011126', 'Igor Cordeiro', 'igor.cordeiro@email.com', '41987654326', 'igorcordeiro', '$2b$10$xl59ND.v5vvIUJtiGOFZcucbYu./Z5cjArqYZ6L0jFygEYh/XkeH.', 'Apto 1313', 49, 1);
INSERT INTO `app_users` (`document`, `name`, `email`, `phone`, `username`, `user_password`, `number`, `address_id`, `active`) VALUES
('00011122237', 'Luana Mello', 'luana.mello@email.com', '51987654326', 'luanamello', '$2b$10$RYLPd6s4vP751zItDlIFuuqhfJI4piz2AnEEEzJ/3Cuk9MyMoFvp6', 'Casa 35', 50, 1);

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


INSERT INTO `user_devices` (`user_id`, `device_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34),
(35, 35),
(36, 36),
(37, 37),
(38, 38),
(39, 39),
(40, 40),
(41, 41),
(42, 42),
(43, 43),
(44, 44),
(45, 45),
(46, 46),
(47, 47),
(48, 48),
(49, 49),
(50, 50);

INSERT INTO `stores` (`name`, `document`, `email`, `username`, `user_password`, `number`, `address_id`, `subscription_end`, `analytics`, `active`) VALUES
('Loja SP', '12345678000100', 'loja1@exemplo.com', 'loja1', '$2b$10$t2qm1LE0RU6H2IfZnk8DZuYrK.FE2A/kBYC0FeMws16MZC4ENjxJy', 101, 1, '2026-12-31 23:59:59', 1, 1),
('Loja RJ', '23456789000111', 'loja2@exemplo.com', 'loja2', '$2b$10$Ooz1h3MEZPJn9aC1SBdQt.k9dmUrARAA7h7AylfQZJ61/4IIIWqF.', 202, 2, '2025-11-30 23:59:59', 0, 1),
('Loja MG', '34567890000122', 'loja3@exemplo.com', 'loja3', '$2b$10$O8zdwQ5hjka3lcFCj5CAqO4dQOML4zXr0MbzN57Q/2z6LduzmmLBq', 303, 3, '2025-10-31 23:59:59', 1, 1),
('Loja RS', '45678900000133', 'loja4@exemplo.com', 'loja4', '$2b$10$d2CBGwdESHtrCa/ma3y4n.KoNb8VFMh.BaMCX.DywGwElY2H6ZdbS', 404, 4, '2025-09-30 23:59:59', 0, 0),
('Loja BA', '56789000000144', 'loja5@exemplo.com', 'loja5', '$2b$10$1egzfPYEygcFm15.Q7vAqeftbyzHlxlKQH.cOP8ejZ.osTozup4H6', 505, 5, '2025-08-31 23:59:59', 1, 1);

INSERT INTO `store_workers` (`name`, `username`, `user_password`, `email`, `store_id`) VALUES
('Lucas Rocha', 'lucasr', '$2b$10$FZibRXsQpXItn2AEzR1wdeglVWhuxDYl53d18ugiM06EvLkWKe1vS', 'lucasr@example.com', 1),
('Juliana Prado', 'julianap', '$2b$10$VGM7wwZqg2pxRFK2nbOPq.xYb/819Y2GN50ZQPC/m6Lp6QekK2Xry', 'julianap@example.com', 2),
('Marcos Vinícius', 'marcosv', '$2b$10$.FMxoZFGte2lFFRG3WvpnuPP3H8s5U4ZGXxB9L097zPgZyeNhC94i', 'marcosv@example.com', 3),
('Fernanda Lima', 'fernandal', '$2b$10$8OhxPnPlxR3qIP7.Vc/aJOkK48MWK3IkdkoFt3xuZvpkXnQ1ovqrm', 'fernandal@example.com', 4),
('Paulo Sérgio', 'paulos', '$2b$10$s6kiyxuI9Kj7K9TSDISBoekRlWfIo141DqvjpKrJ6owJTub7Ws.JW', 'paulos@example.com', 5);



INSERT INTO `service_orders` (`user_device_id`, `worker_id`, `store_id`, `created_at`, `completed_at`, `feedback`, `warranty`, `cost`, `work`, `status`, `deadline`, `problem`) VALUES
(1, 1, 1, NOW(), NULL, NULL, 6, 250.00, 50.00, 'pending', '2025-06-15', 'Tela quebrada'),
(2, 2, 2, '2025-06-01 10:00:00', '2025-06-01 14:00:00', 10, 12, 180.00, 30.00, 'completed', '2025-06-05', 'Bateria descarregando'),
(3, 3, 3, NOW(), NULL, NULL, NULL, NULL, NULL, 'pending', '2025-06-20', 'Celular não liga'),
(4, 4, 4, NOW(), NULL, NULL, 3, 400.00, 80.00, 'in progress', '2025-06-30', 'Sem sinal'),
(5, 5, 5, NOW(), NULL, NULL, 6,150.00, 50.00, 'pending', '2025-07-01', 'Aquecimento excessivo');


INSERT INTO `order_logs` (`service_order_id`, `cost`, `work`, `status`, `deadline`, `problem`, `log_date`) VALUES
(1, '250.00', '30.00', 'pending', '2025-06-15', 'Tela quebrada', NOW()),
(2, '180.00', 50.00, 'completed', '2025-06-05', 'Bateria descarregando', NOW()),
(3, '0.00', '0.00', 'pending', '2025-06-20', 'Celular não liga', NOW()),
(4, '400.00', '20.00', 'in progress', '2025-06-30', 'Sem sinal', NOW()),
(5, '150.00', '50.00', 'pending', '2025-07-01', 'Aquecimento excessivo', NOW());


INSERT INTO `admins` (`username`, `user_password`, `email`) VALUES
('admin1', '$2b$10$lAVdOCvPG6yU7ex5CkzH/.tNE9cF0B8sofOa1rWT0zrVrikqTczju', 'admin1@example.com'),
('admin2', '$2b$10$Wk0ffpsiNCMjYkF8ImoEH.GnJ7xvoWbhKIwc3Qodp0MHnRGq.BHJC', 'admin2@example.com'),
('admin3', '$2b$10$ui5HCdRYzQBTcQJn9OTxbuiTdKU2itwo4etL1K7IIcm5MkUcgH6tC', 'admin3@example.com'),
('superuser', '$2b$10$/RuHLET9CgvG.UatYu4E2eqFMVu6gNDKoW6f4jROz34ZLF483y60q', 'superuser@example.com'),
('Luw', '$2b$10$FzEoMUDw7oq1DK8RV.spIeNeS.7MjtTc/M7QLpRDh74w7iL54T62y', 'luisflavio360@gmail.com'),
('gestor_ti', '$2b$10$2.j7Z6docjZhiC5avVUw5O/iY.eQ.Car5VH7vrOoUQaLTuKaIt3Nu', 'gestor_ti@example.com');


INSERT INTO `pictures` (`service_order_id`, `path`) VALUES
(1, '/uploads/tela_quebrada.jpg'),
(2, '/uploads/bateria_ruim.jpg'),
(3, '/uploads/celular_morto.jpg'),
(4, '/uploads/placa_queimada.jpg'),
(5, '/uploads/sujeira_interna.jpg');








