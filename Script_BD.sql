USE `TrackCommerce`;


-- MySQL Script
-- TrackCommerce
-- Tabelas padronizadas em letras minúsculas

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema TrackCommerce
-- -----------------------------------------------------

DROP DATABASE IF EXISTS `TrackCommerce`;
CREATE DATABASE IF NOT EXISTS `TrackCommerce`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE `TrackCommerce`;

-- -----------------------------------------------------
-- Table `cargo`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `cargo`;

CREATE TABLE IF NOT EXISTS `cargo` (
  `id_cargo` INT NOT NULL AUTO_INCREMENT,
  `nome_cargo` VARCHAR(45) NOT NULL,
  `nivel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_cargo`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `permissao`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `permissao`;

CREATE TABLE IF NOT EXISTS `permissao` (
  `id_permissao` INT NOT NULL AUTO_INCREMENT,
  `nome_permissao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_permissao`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cargo_permissao`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `cargo_permissao`;

CREATE TABLE IF NOT EXISTS `cargo_permissao` (
  `fk_cargo` INT NOT NULL,
  `fk_permissao` INT NOT NULL,

  PRIMARY KEY (`fk_cargo`, `fk_permissao`),

  CONSTRAINT `fk_cp_cargo`
    FOREIGN KEY (`fk_cargo`)
    REFERENCES `cargo` (`id_cargo`)
    ON DELETE CASCADE,

  CONSTRAINT `fk_cp_permissao`
    FOREIGN KEY (`fk_permissao`)
    REFERENCES `permissao` (`id_permissao`)
    ON DELETE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_cp_permissao`
ON `cargo_permissao` (`fk_permissao` ASC);


-- -----------------------------------------------------
-- Table `componentes`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `componentes`;

CREATE TABLE IF NOT EXISTS `componentes` (
  `id_componente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `dt_atribuicao` DATETIME NOT NULL,

  PRIMARY KEY (`id_componente`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `endereco`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `endereco`;

CREATE TABLE IF NOT EXISTS `endereco` (
  `id_endereco` INT NOT NULL AUTO_INCREMENT,
  `estado` CHAR(2) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(100) NOT NULL,
  `logradouro` VARCHAR(100) NOT NULL,
  `numero` VARCHAR(10) NOT NULL,

  PRIMARY KEY (`id_endereco`)
)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `empresa`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `empresa`;

CREATE TABLE IF NOT EXISTS `empresa` (
  `id_empresa` INT NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(100) NOT NULL,
  `cnpj` CHAR(14) NOT NULL,
  `fk_endereco` INT NULL DEFAULT NULL,

  PRIMARY KEY (`id_empresa`),

  CONSTRAINT `fk_empresa_endereco`
    FOREIGN KEY (`fk_endereco`)
    REFERENCES `endereco` (`id_endereco`)
    ON DELETE SET NULL
)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `uq_empresa_cnpj`
ON `empresa` (`cnpj` ASC);

CREATE INDEX `fk_empresa_endereco`
ON `empresa` (`fk_endereco` ASC);


-- -----------------------------------------------------
-- Table `instancias`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `instancias`;

CREATE TABLE IF NOT EXISTS `instancias` (
  `id_instancia` INT NOT NULL AUTO_INCREMENT,
  `fk_empresa` INT NOT NULL,
  `nome` VARCHAR(50) NOT NULL,
  `descricao` VARCHAR(200),
  `identificador` VARCHAR(500) NOT NULL,
  `ativo` TINYINT NOT NULL DEFAULT 1,

  PRIMARY KEY (`id_instancia`),

  CONSTRAINT `fk_instancia_empresa`
    FOREIGN KEY (`fk_empresa`)
    REFERENCES `empresa` (`id_empresa`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `uq_instancia_identificador`
ON `instancias` (`identificador` ASC);

CREATE INDEX `fk_instancia_empresa`
ON `instancias` (`fk_empresa` ASC);


-- -----------------------------------------------------
-- Table `usuario`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `usuario`;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `celular` CHAR(11) NULL DEFAULT NULL,
  `fk_empresa` INT NOT NULL,
  `fk_cargo` INT NOT NULL,

  PRIMARY KEY (`id_usuario`),

  CONSTRAINT `fk_usuario_cargo`
    FOREIGN KEY (`fk_cargo`)
    REFERENCES `cargo` (`id_cargo`)
    ON DELETE RESTRICT,

  CONSTRAINT `fk_usuario_empresa`
    FOREIGN KEY (`fk_empresa`)
    REFERENCES `empresa` (`id_empresa`)
    ON DELETE RESTRICT
)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE UNIQUE INDEX `uq_usuario_email`
ON `usuario` (`email` ASC);

CREATE INDEX `fk_usuario_empresa`
ON `usuario` (`fk_empresa` ASC);

CREATE INDEX `fk_usuario_cargo`
ON `usuario` (`fk_cargo` ASC);


-- -----------------------------------------------------
-- Table `parametros`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `parametros`;

CREATE TABLE IF NOT EXISTS `parametros` (
  `id_parametro` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `unidade_medida` VARCHAR(15) NOT NULL,
  `dt_atribuicao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Componentes_id_componente` INT NOT NULL,

  PRIMARY KEY (`id_parametro`),

  CONSTRAINT `fk_parametros_componentes`
    FOREIGN KEY (`Componentes_id_componente`)
    REFERENCES `componentes` (`id_componente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_parametros_componentes_idx`
ON `parametros` (`Componentes_id_componente` ASC);


-- -----------------------------------------------------
-- Table `parametros_alertas`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `parametros_alertas`;

CREATE TABLE IF NOT EXISTS `parametros_alertas` (
  `id_parametro_alerta` INT NOT NULL AUTO_INCREMENT,
  `alerta_moderado` DOUBLE NOT NULL,
  `alerta_critico` DOUBLE NOT NULL,
  `dt_edicao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fk_parametro` INT NOT NULL,

  PRIMARY KEY (`id_parametro_alerta`),

  CONSTRAINT `fk_parametros_alertas_parametros`
    FOREIGN KEY (`fk_parametro`)
    REFERENCES `parametros` (`id_parametro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_parametros_alertas_parametros_idx`
ON `parametros_alertas` (`fk_parametro` ASC);


-- -----------------------------------------------------
-- Table `instancias_componentes`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `instancias_componentes`;

CREATE TABLE IF NOT EXISTS `instancias_componentes` (
  `id_instancia_componente` INT NOT NULL,
  `fk_instancia` INT NOT NULL,
  `fk_componentes` INT NOT NULL,
  `fk_parametros_alertas` INT NOT NULL,
  `Status` TINYINT NOT NULL DEFAULT 1,
  `dt_edicao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (
    `id_instancia_componente`,
    `fk_instancia`,
    `fk_componentes`,
    `fk_parametros_alertas`
  ),

  CONSTRAINT `fk_instancias_componentes_instancias`
    FOREIGN KEY (`fk_instancia`)
    REFERENCES `instancias` (`id_instancia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_instancias_componentes_componentes`
    FOREIGN KEY (`fk_componentes`)
    REFERENCES `componentes` (`id_componente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_instancias_componentes_parametros_alertas`
    FOREIGN KEY (`fk_parametros_alertas`)
    REFERENCES `parametros_alertas` (`id_parametro_alerta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_instancias_componentes_componentes_idx`
ON `instancias_componentes` (`fk_componentes` ASC);

CREATE INDEX `fk_instancias_componentes_instancias_idx`
ON `instancias_componentes` (`fk_instancia` ASC);

CREATE INDEX `fk_instancias_componentes_parametros_alertas_idx`
ON `instancias_componentes` (`fk_parametros_alertas` ASC);


-- -----------------------------------------------------
-- Table `apijira`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `apijira`;

CREATE TABLE IF NOT EXISTS `apijira` (
  `id_api_jira` INT NOT NULL,
  `codigo_api` VARCHAR(500) NOT NULL,
  `fk_empresa` INT NOT NULL,

  PRIMARY KEY (`id_api_jira`),

  CONSTRAINT `fk_apijira_empresa`
    FOREIGN KEY (`fk_empresa`)
    REFERENCES `empresa` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_apijira_empresa_idx`
ON `apijira` (`fk_empresa` ASC);


-- -----------------------------------------------------
-- Restore settings
-- -----------------------------------------------------

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Inserção na Tabela endereco
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`endereco`
(`id_endereco`, `estado`, `cidade`, `bairro`, `logradouro`, `numero`)
VALUES
(1, 'SP', 'Sao Paulo', 'Vila Olimpia', 'Rua Funchal', '418'),
(2, 'SP', 'Campinas', 'Cambui', 'Avenida Norte-Sul', '1200'),
(3, 'RJ', 'Rio de Janeiro', 'Botafogo', 'Rua Voluntarios da Patria', '89');


-- -----------------------------------------------------
-- Inserção na Tabela empresa
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`empresa`
(`id_empresa`, `razao_social`, `cnpj`, `fk_endereco`)
VALUES
(1, 'LojaCerta Comercio Eletronico LTDA', '12345678000190', 1),
(2, 'Mercado Rapido E-commerce S.A.', '98765432000110', 2),
(3, 'BoraComprar Varejo Digital LTDA', '11222333000144', 3);


-- -----------------------------------------------------
-- Inserção na Tabela cargo
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`cargo`
(`id_cargo`, `nome_cargo`, `nivel`)
VALUES
(1, 'Administrador', 'Alto'),
(2, 'Analista de Infraestrutura', 'Medio'),
(3, 'Suporte Tecnico', 'Baixo');


-- -----------------------------------------------------
-- Inserção na Tabela permissao
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`permissao`
(`id_permissao`, `nome_permissao`)
VALUES
(1, 'gerenciar_usuarios'),
(2, 'gerenciar_instancias'),
(3, 'visualizar_dashboard'),
(4, 'visualizar_historico_alertas'),
(5, 'gerenciar_parametros_monitoramento');


-- -----------------------------------------------------
-- Inserção na Tabela cargo_permissao
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`cargo_permissao`
(`fk_cargo`, `fk_permissao`)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(3, 3),
(3, 4);


-- -----------------------------------------------------
-- Inserção na Tabela usuario
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`usuario`
(`id_usuario`, `nome`, `email`, `senha`, `celular`, `fk_empresa`, `fk_cargo`)
VALUES
(1, 'Bruno Alcantara', 'bruno.alcantara@lojacerta.com', 'senha123', '11991112222', 1, 1),
(2, 'Camila Duarte', 'camila.duarte@lojacerta.com', 'senha123', '11992223333', 1, 2),
(3, 'Diego Ferraz', 'diego.ferraz@mercadorapido.com', 'senha123', '19993334444', 2, 1),
(4, 'Fernanda Souza', 'fernanda.souza@mercadorapido.com', 'senha123', '19994445555', 2, 3),
(5, 'Gabriel Teixeira', 'gabriel.teixeira@boracomprar.com', 'senha123', '21995556666', 3, 1),
(6, 'Helena Vasconcelos', 'helena.vasconcelos@boracomprar.com', 'senha123', '21996667777', 3, 2);


-- -----------------------------------------------------
-- Inserção na Tabela instancias
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`instancias`
(`id_instancia`, `fk_empresa`, `nome`, `identificador`, `ativo`)
VALUES
(1, 1, 'VM Producao Web', 'lojacerta-prod-web-01', 1),
(2, 1, 'VM Banco de Dados', 'lojacerta-prod-db-01', 1),
(3, 2, 'VM Producao Web', 'mercadorapido-prod-web-01', 1),
(4, 2, 'VM Cache/Redis', 'mercadorapido-prod-cache-01', 1),
(5, 3, 'VM Producao Web', 'boracomprar-prod-web-01', 1);


-- -----------------------------------------------------
-- Inserção na Tabela componentes
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`componentes`
(`id_componente`, `nome`, `dt_atribuicao`)
VALUES
(1, 'CPU', NOW()),
(2, 'Memoria RAM', NOW()),
(3, 'Armazenamento', NOW()),
(4, 'Leitura de Disco', NOW()),
(5, 'Escrita de Disco', NOW()),
(6, 'Rede - Download', NOW()),
(7, 'Rede - Upload', NOW()),
(8, 'Latencia API Pagamento', NOW());


-- -----------------------------------------------------
-- Inserção na Tabela parametros
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`parametros`
(`id_parametro`, `nome`, `unidade_medida`, `dt_atribuicao`, `Componentes_id_componente`)
VALUES
(1, 'Uso de Processador', '%', NOW(), 1),
(2, 'Consumo de Memoria', '%', NOW(), 2),
(3, 'Espaco em Disco', '%', NOW(), 3),
(4, 'Taxa de Leitura', 'MB/s', NOW(), 4),
(5, 'Taxa de Escrita', 'MB/s', NOW(), 5),
(6, 'Banda de Download', 'Mbps', NOW(), 6),
(7, 'Banda de Upload', 'Mbps', NOW(), 7),
(8, 'Tempo de Resposta', 'ms', NOW(), 8);


-- -----------------------------------------------------
-- Inserção na Tabela parametros_alertas
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`parametros_alertas`
(`id_parametro_alerta`, `alerta_moderado`, `alerta_critico`, `dt_edicao`, `fk_parametro`)
VALUES
(1, 70.0, 85.0, NOW(), 1),
(2, 75.0, 90.0, NOW(), 2),
(3, 70.0, 80.0, NOW(), 3),
(4, 50.0, 100.0, NOW(), 4),
(5, 50.0, 100.0, NOW(), 5),
(6, 500.0, 1000.0, NOW(), 6),
(7, 500.0, 1000.0, NOW(), 7),
(8, 500.0, 1000.0, NOW(), 8);


-- -----------------------------------------------------
-- Inserção na Tabela instancias_componentes
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`instancias_componentes`
(`id_instancia_componente`, `fk_instancia`, `fk_componentes`, `fk_parametros_alertas`, `Status`, `dt_edicao`)
VALUES
(1, 1, 1, 1, 1, NOW()),
(2, 1, 2, 2, 1, NOW()),
(3, 2, 3, 3, 1, NOW()),
(4, 3, 1, 1, 1, NOW()),
(5, 3, 8, 8, 1, NOW()),
(6, 4, 2, 2, 1, NOW()),
(7, 5, 1, 1, 1, NOW());


-- -----------------------------------------------------
-- Inserção na Tabela apijira
-- -----------------------------------------------------

INSERT INTO `TrackCommerce`.`apijira`
(`id_api_jira`, `codigo_api`, `fk_empresa`)
VALUES
(1, 'JIRA-API-KEY-LOJACERTA-89213', 1),
(2, 'JIRA-API-KEY-MERCADORAPIDO-44123', 2),
(3, 'JIRA-API-KEY-BORACOMPRAR-77211', 3);


ALTER TABLE apijira
  ADD COLUMN jira_url          VARCHAR(200),
  ADD COLUMN jira_email        VARCHAR(200),
  ADD COLUMN jira_project_key  VARCHAR(200),
  ADD COLUMN slack_webhook     VARCHAR(200);
  
  
UPDATE instancias SET identificador = "ef7050f0-9d76-49ff-ae93-a7b5581ff629" where id_instancia = 1;

desc instancias;

select * from instancias;

select * from empresa;

select * from parametros_alertas;

select * from parametros;
select * from componentes;
show tables;

select * from instancias_componentes;


SELECT ic.id_instancia_componente, e.id_empresa, e.razao_social AS empresa_nome, i.nome AS instancia,
                   i.identificador, c.nome AS componente, p.unidade_medida,
                   pa.alerta_moderado, pa.alerta_critico,
                   aj.jira_url, aj.jira_email, aj.codigo_api, aj.jira_project_key, aj.slack_webhook
            FROM instancias_componentes ic
            JOIN instancias i  ON i.id_instancia = ic.fk_instancia
            JOIN empresa e     ON e.id_empresa = i.fk_empresa
            JOIN componentes c ON c.id_componente = ic.fk_componentes
            JOIN parametros_alertas pa ON pa.id_parametro_alerta = ic.fk_parametros_alertas
            JOIN parametros p  ON p.id_parametro = pa.fk_parametro
            JOIN apijira aj    ON aj.fk_empresa = e.id_empresa
            WHERE ic.Status = 1 AND i.ativo = 1
              AND c.nome IN ('CPU','Memoria RAM','Armazenamento',
                             'Leitura de Disco','Escrita de Disco',
                             'Rede - Download','Rede - Upload');