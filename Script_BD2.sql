DROP DATABASE IF EXISTS `TrackCommerce`;
CREATE DATABASE IF NOT EXISTS `TrackCommerce`
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE `TrackCommerce`;

-- -----------------------------------------------------
-- 1. Table `cargo`
-- -----------------------------------------------------
CREATE TABLE `cargo` (
  `id_cargo` INT NOT NULL AUTO_INCREMENT,
  `nome_cargo` VARCHAR(45) NOT NULL,
  `nivel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_cargo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 2. Table `permissao`
-- -----------------------------------------------------
CREATE TABLE `permissao` (
  `id_permissao` INT NOT NULL AUTO_INCREMENT,
  `nome_permissao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_permissao`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 3. Table `cargo_permissao` (N:N)
-- -----------------------------------------------------
CREATE TABLE `cargo_permissao` (
  `fk_cargo` INT NOT NULL,
  `fk_permissao` INT NOT NULL,
  PRIMARY KEY (`fk_cargo`, `fk_permissao`),
  CONSTRAINT `fk_cp_cargo` FOREIGN KEY (`fk_cargo`) REFERENCES `cargo` (`id_cargo`) ON DELETE CASCADE,
  CONSTRAINT `fk_cp_permissao` FOREIGN KEY (`fk_permissao`) REFERENCES `permissao` (`id_permissao`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 4. Table `endereco`
-- -----------------------------------------------------
CREATE TABLE `endereco` (
  `id_endereco` INT NOT NULL AUTO_INCREMENT,
  `cep` CHAR(8) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(100) NOT NULL,
  `logradouro` VARCHAR(100) NOT NULL,
  `numero` VARCHAR(10) NOT NULL,
  `complemento` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_endereco`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 5. Table `empresa`
-- -----------------------------------------------------
CREATE TABLE `empresa` (
  `id_empresa` INT NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(100) NOT NULL,
  `cnpj` CHAR(14) NOT NULL,
  `token_instalacao` CHAR(64) NULL DEFAULT NULL,
  `fk_endereco` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE INDEX `uq_empresa_cnpj` (`cnpj`),
  UNIQUE INDEX `uq_empresa_token_instalacao` (`token_instalacao`),
  CONSTRAINT `fk_empresa_endereco` FOREIGN KEY (`fk_endereco`) REFERENCES `endereco` (`id_endereco`) ON DELETE SET NULL
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 6. Table `usuario`
-- -----------------------------------------------------
CREATE TABLE `usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `celular` CHAR(11) NULL DEFAULT NULL,
  `fk_empresa` INT NOT NULL,
  `fk_cargo` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `uq_usuario_email` (`email`),
  CONSTRAINT `fk_usuario_cargo` FOREIGN KEY (`fk_cargo`) REFERENCES `cargo` (`id_cargo`) ON DELETE RESTRICT,
  CONSTRAINT `fk_usuario_empresa` FOREIGN KEY (`fk_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE RESTRICT
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 7. Table `integracao` (Antiga `apijira`)
-- -----------------------------------------------------
CREATE TABLE `integracao` (
  `id_integracao` INT NOT NULL AUTO_INCREMENT,
  `fk_empresa` INT NOT NULL,
  `codigo_api` VARCHAR(500) NOT NULL,
  `jira_url` VARCHAR(200) NULL DEFAULT NULL,
  `jira_email` VARCHAR(200) NULL DEFAULT NULL,
  `jira_project_key` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id_integracao`),
  UNIQUE INDEX `uq_integracao_empresa` (`fk_empresa`),
  CONSTRAINT `fk_integracao_empresa` FOREIGN KEY (`fk_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 8. Table `instancia`
-- -----------------------------------------------------
CREATE TABLE `instancia` (
  `id_instancia` INT NOT NULL AUTO_INCREMENT,
  `fk_empresa` INT NOT NULL,
  `nome` VARCHAR(50) NOT NULL,
  `descricao` VARCHAR(200) NULL DEFAULT NULL,
  `identificador` VARCHAR(255) NOT NULL,
  `ativo` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_instancia`),
  UNIQUE INDEX `uq_instancia_identificador` (`identificador`),
  CONSTRAINT `fk_instancia_empresa` FOREIGN KEY (`fk_empresa`) REFERENCES `empresa` (`id_empresa`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 9. Table `componente` (Catálogo unificado com padrões)
-- -----------------------------------------------------
CREATE TABLE `componente` (
  `id_componente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `metrica` VARCHAR(50) NOT NULL,
  `unidade_medida` VARCHAR(15) NOT NULL,
  `alerta_moderado_padrao` DECIMAL(10,2) NOT NULL,
  `alerta_critico_padrao` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_componente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 10. Table `instancia_componente` (N:N com limites próprios)
-- -----------------------------------------------------
CREATE TABLE `instancia_componente` (
  `id_instancia_componente` INT NOT NULL AUTO_INCREMENT,
  `fk_instancia` INT NOT NULL,
  `fk_componente` INT NOT NULL,
  `alerta_moderado` DECIMAL(10,2) NOT NULL,
  `alerta_critico` DECIMAL(10,2) NOT NULL,
  `ativo` TINYINT NOT NULL DEFAULT 1,
  `dt_edicao` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_instancia_componente`),
  UNIQUE INDEX `uq_instancia_componente` (`fk_instancia`, `fk_componente`),
  CONSTRAINT `fk_ic_instancia` FOREIGN KEY (`fk_instancia`) REFERENCES `instancia` (`id_instancia`) ON DELETE CASCADE,
  CONSTRAINT `fk_ic_componente` FOREIGN KEY (`fk_componente`) REFERENCES `componente` (`id_componente`) ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =====================================================
-- INSERÇÕES
-- =====================================================

INSERT INTO `endereco` (`id_endereco`, `cep`, `estado`, `cidade`, `bairro`, `logradouro`, `numero`, `complemento`) VALUES
(1, '04551060', 'SP', 'Sao Paulo', 'Vila Olimpia', 'Rua Funchal', '418', '12 Andar'),
(2, '13025320', 'SP', 'Campinas', 'Cambui', 'Avenida Norte-Sul', '1200', NULL),
(3, '22270000', 'RJ', 'Rio de Janeiro', 'Botafogo', 'Rua Voluntarios da Patria', '89', 'Sala 302');

INSERT INTO `empresa` (`id_empresa`, `razao_social`, `cnpj`, `fk_endereco`) VALUES
(1, 'TrackCommerce', '00000000000000', NULL),
(2, 'LojaCerta Comercio Eletronico LTDA', '12345678000190', 1),
(3, 'Mercado Rapido E-commerce S.A.', '98765432000110', 2),
(4, 'BoraComprar Varejo Digital LTDA', '11222333000144', 3);

INSERT INTO `cargo` (`id_cargo`, `nome_cargo`, `nivel`) VALUES
(1, 'Gestor', 'Alto'),
(2, 'Analista de Infraestrutura', 'Medio'),
(3, 'Suporte Tecnico', 'Baixo');

INSERT INTO `permissao` (`id_permissao`, `nome_permissao`) VALUES
(1, 'gerenciar_usuarios'),
(2, 'gerenciar_instancias'),
(3, 'visualizar_dashboard'),
(4, 'visualizar_historico_alertas'),
(5, 'gerenciar_parametros_monitoramento');

INSERT INTO `cargo_permissao` (`fk_cargo`, `fk_permissao`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 2), (2, 3), (2, 4), (2, 5),
(3, 3), (3, 4);

INSERT INTO `usuario` (`id_usuario`, `nome`, `email`, `senha`, `celular`, `fk_empresa`, `fk_cargo`) VALUES
(1, 'Dev TrackCommerce', 'dev@trackcommerce.com', '2178706529846735', NULL, 1, 1),
(2, 'Geraldo Alcantra', 'geraldo.alcantara@lojacerta.com', '2178706529846735', '11991112222', 2, 1),
(3, 'Luciana Duarte', 'luciana.duarte@lojacerta.com', '2178706529846735', '11992223333', 2, 2),
(4, 'Diego Ferraz', 'diego.ferraz@mercadorapido.com', '2178706529846735', '19993334444', 3, 1),
(5, 'Fernanda Souza', 'fernanda.souza@mercadorapido.com', '2178706529846735', '19994445555', 3, 3),
(6, 'Gabriel Teixeira', 'gabriel.teixeira@boracomprar.com', '2178706529846735', '21995556666', 4, 1),
(7, 'Helena Vasconcelos', 'helena.vasconcelos@boracomprar.com', '2178706529846735', '21996667777', 4, 2);

INSERT INTO `integracao` (`id_integracao`, `codigo_api`,`jira_email`, `fk_empresa`, `jira_url`, `jira_project_key`) VALUES
(1, 'JIRA-API-KEY-LOJACERTA-89213','enzo.martelozzo@sptech.school' ,2, 'https://trackcommerce.atlassian.net', 'NOV'),
(2, 'JIRA-API-KEY-MERCADORAPIDO-44123','enzo.martelozzo@sptech.school', 3, 'https://trackcommerce.atlassian.net', 'NOV'),
(3, 'JIRA-API-KEY-BORACOMPRAR-77211','enzo.martelozzo@sptech.school', 4, 'https://trackcommerce.atlassian.net', 'NOV');

INSERT INTO `instancia` (`id_instancia`, `fk_empresa`, `nome`, `identificador`, `ativo`) VALUES
(1, 2, 'VM Producao Web', 'ef7050f0-9d76-49ff-ae93-a7b5581ff629', 1),
(2, 2, 'VM Banco de Dados', 'lojacerta-prod-db-01', 1),
(3, 3, 'VM Producao Web', 'mercadorapido-prod-web-01', 1),
(4, 3, 'VM Cache/Redis', 'mercadorapido-prod-cache-01', 1),
(5, 4, 'VM Producao Web', 'boracomprar-prod-web-01', 1);

INSERT INTO `componente` (`id_componente`, `nome`, `metrica`, `unidade_medida`, `alerta_moderado_padrao`, `alerta_critico_padrao`) VALUES
(1, 'CPU', 'Uso de Processador', '%', 70.00, 85.00),
(2, 'Memoria RAM', 'Consumo de Memoria', '%', 75.00, 90.00),
(3, 'Armazenamento', 'Espaco em Disco', '%', 70.00, 80.00),
(4, 'Leitura de Disco', 'Taxa de Leitura', 'MB/s', 50.00, 100.00),
(5, 'Escrita de Disco', 'Taxa de Escrita', 'MB/s', 50.00, 100.00),
(6, 'Rede - Download', 'Banda de Download', 'Mbps', 500.00, 1000.00),
(7, 'Rede - Upload', 'Banda de Upload', 'Mbps', 500.00, 1000.00),
(8, 'Latencia API Pagamento', 'Tempo de Resposta', 'ms', 500.00, 1000.00);

INSERT INTO `instancia_componente` (`fk_instancia`, `fk_componente`, `alerta_moderado`, `alerta_critico`, `ativo`) VALUES
(1, 1, 70.00, 85.00, 1),
(1, 2, 75.00, 90.00, 1),
(2, 3, 70.00, 80.00, 1),
(3, 1, 70.00, 85.00, 1),
(3, 8, 500.00, 1000.00, 1),
(4, 2, 75.00, 90.00, 1),
(5, 1, 70.00, 85.00, 1);

-- =====================================================
-- CONSULTA DE VERIFICAÇÃO OTIMIZADA
-- =====================================================
SELECT ic.id_instancia_componente,
       e.id_empresa,
       e.razao_social AS empresa_nome,
       i.nome AS instancia,
       i.identificador,
       c.nome AS componente,
       c.metrica,
       c.unidade_medida,
       ic.alerta_moderado,
       ic.alerta_critico,
       ig.jira_url,
       ig.jira_email,
       ig.codigo_api,
       ig.jira_project_key
FROM instancia_componente ic
JOIN instancia i       ON i.id_instancia = ic.fk_instancia
JOIN empresa e         ON e.id_empresa = i.fk_empresa
JOIN componente c      ON c.id_componente = ic.fk_componente
LEFT JOIN integracao ig ON ig.fk_empresa = e.id_empresa
WHERE ic.ativo = 1
  AND i.ativo = 1;
