USE `TrackCommerce`;
-- -----------------------------------------------------
-- Inserção na Tabela Endereco
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Endereco` (`id_endereco`, `estado`, `cidade`, `bairro`, `logradouro`, `numero`) VALUES
(1, 'SP', 'Sao Paulo', 'Vila Olimpia', 'Rua Funchal', '418'),
(2, 'SP', 'Campinas', 'Cambui', 'Avenida Norte-Sul', '1200'),
(3, 'RJ', 'Rio de Janeiro', 'Botafogo', 'Rua Voluntarios da Patria', '89');

-- -----------------------------------------------------
-- Inserção na Tabela Empresa
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Empresa` (`id_empresa`, `razao_social`, `cnpj`, `fk_endereco`) VALUES
(1, 'LojaCerta Comercio Eletronico LTDA', '12345678000190', 1),
(2, 'Mercado Rapido E-commerce S.A.', '98765432000110', 2),
(3, 'BoraComprar Varejo Digital LTDA', '11222333000144', 3);

-- -----------------------------------------------------
-- Inserção na Tabela Cargo
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Cargo` (`id_cargo`, `nome_cargo`, `nivel`) VALUES
(1, 'Administrador', 'Alto'),
(2, 'Analista de Infraestrutura', 'Medio'),
(3, 'Suporte Tecnico', 'Baixo');

-- -----------------------------------------------------
-- Inserção na Tabela Permissao
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Permissao` (`id_permissao`, `nome_permissao`) VALUES
(1, 'gerenciar_usuarios'),
(2, 'gerenciar_instancias'),
(3, 'visualizar_dashboard'),
(4, 'visualizar_historico_alertas'),
(5, 'gerenciar_parametros_monitoramento');

-- -----------------------------------------------------
-- Inserção na Tabela Cargo_Permissao
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Cargo_Permissao` (`fk_cargo`, `fk_permissao`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 2), (2, 3), (2, 4), (2, 5),
(3, 3), (3, 4);

-- -----------------------------------------------------
-- Inserção na Tabela Usuario (dados mais recentes do script antigo)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Usuario` (`id_usuario`, `nome`, `email`, `senha`, `celular`, `fk_empresa`, `fk_cargo`) VALUES
(1, 'Bruno Alcantara', 'bruno.alcantara@lojacerta.com', 'senha123', '11991112222', 1, 1),
(2, 'Camila Duarte', 'camila.duarte@lojacerta.com', 'senha123', '11992223333', 1, 2),
(3, 'Diego Ferraz', 'diego.ferraz@mercadorapido.com', 'senha123', '19993334444', 2, 1),
(4, 'Fernanda Souza', 'fernanda.souza@mercadorapido.com', 'senha123', '19994445555', 2, 3),
(5, 'Gabriel Teixeira', 'gabriel.teixeira@boracomprar.com', 'senha123', '21995556666', 3, 1),
(6, 'Helena Vasconcelos', 'helena.vasconcelos@boracomprar.com', 'senha123', '21996667777', 3, 2);

-- -----------------------------------------------------
-- Inserção na Tabela Instancias
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Instancias` (`id_instancia`, `fk_empresa`, `nome`, `identificador`, `ativo`) VALUES
(1, 1, 'VM Producao Web', 'lojacerta-prod-web-01', 1),
(2, 1, 'VM Banco de Dados', 'lojacerta-prod-db-01', 1),
(3, 2, 'VM Producao Web', 'mercadorapido-prod-web-01', 1),
(4, 2, 'VM Cache/Redis', 'mercadorapido-prod-cache-01', 1),
(5, 3, 'VM Producao Web', 'boracomprar-prod-web-01', 1);

-- -----------------------------------------------------
-- Inserção na Tabela Componentes (removido unidade_medida, adicionado dt_atribuicao)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Componentes` (`id_componente`, `nome`, `dt_atribuicao`) VALUES
(1, 'CPU', NOW()),
(2, 'Memoria RAM', NOW()),
(3, 'Armazenamento', NOW()),
(4, 'Leitura de Disco', NOW()),
(5, 'Escrita de Disco', NOW()),
(6, 'Rede - Download', NOW()),
(7, 'Rede - Upload', NOW()),
(8, 'Latencia API Pagamento', NOW());

-- -----------------------------------------------------
-- Inserção na Tabela Parametros (nova estrutura vinculando ao componente)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Parametros` (`id_parametro`, `nome`, `unidade_medida`, `dt_atribuicao`, `Componentes_id_componente`) VALUES
(1, 'Uso de Processador', '%', NOW(), 1),
(2, 'Consumo de Memoria', '%', NOW(), 2),
(3, 'Espaco em Disco', '%', NOW(), 3),
(4, 'Taxa de Leitura', 'MB/s', NOW(), 4),
(5, 'Taxa de Escrita', 'MB/s', NOW(), 5),
(6, 'Banda de Download', 'Mbps', NOW(), 6),
(7, 'Banda de Upload', 'Mbps', NOW(), 7),
(8, 'Tempo de Resposta', 'ms', NOW(), 8);

-- -----------------------------------------------------
-- Inserção na Tabela Parametros_Alertas (definindo limiares moderados e críticos)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Parametros_Alertas` (`id_parametro_alerta`, `alerta_moderado`, `alerta_critico`, `dt_edicao`, `fk_parametro`) VALUES
(1, 70.0, 85.0, NOW(), 1),  -- CPU (Crítico baseado no antigo limite de 85%)
(2, 75.0, 90.0, NOW(), 2),  -- RAM (Crítico baseado no antigo limite de 90%)
(3, 70.0, 80.0, NOW(), 3),  -- Armazenamento (Crítico baseado no antigo limite de 80%)
(4, 50.0, 100.0, NOW(), 4), -- Leitura
(5, 50.0, 100.0, NOW(), 5), -- Escrita
(6, 500.0, 1000.0, NOW(), 6),-- Download
(7, 500.0, 1000.0, NOW(), 7),-- Upload
(8, 500.0, 1000.0, NOW(), 8);-- Latência API (Crítico baseado no antigo limite de 1000ms)

-- -----------------------------------------------------
-- Inserção na Tabela Instancias_Componentes (substitui a antiga tabela Monitoramento)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`Instancias_Componentes` (`id_instancia_componente`, `fk_instancia`, `fk_componentes`, `fk_parametros_alertas`, `Status`, `dt_edicao`) VALUES
(1, 1, 1, 1, 1, NOW()), -- Instância 1 (VM Prod Web) + CPU
(2, 1, 2, 2, 1, NOW()), -- Instância 1 (VM Prod Web) + RAM
(3, 2, 3, 3, 1, NOW()), -- Instância 2 (VM DB) + Armazenamento
(4, 3, 1, 1, 1, NOW()), -- Instância 3 (VM Prod Web MR) + CPU
(5, 3, 8, 8, 1, NOW()), -- Instância 3 (VM Prod Web MR) + Latência API
(6, 4, 2, 2, 1, NOW()), -- Instância 4 (VM Cache) + RAM
(7, 5, 1, 1, 1, NOW()); -- Instância 5 (VM Prod Web BC) + CPU

-- -----------------------------------------------------
-- Inserção na Tabela ApiJira (nova tabela associada à Empresa)
-- -----------------------------------------------------
INSERT INTO `TrackCommerce`.`ApiJira` (`id_api_jira`, `codigo_api`, `fk_empresa`) VALUES
(1, 'JIRA-API-KEY-LOJACERTA-89213', 1),
(2, 'JIRA-API-KEY-MERCADORAPIDO-44123', 2),
(3, 'JIRA-API-KEY-BORACOMPRAR-77211', 3);