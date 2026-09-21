
CREATE DATABASE TrackCommerce;
USE TrackCommerce;



CREATE TABLE Endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY,
  estado CHAR(2) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  bairro VARCHAR(100) NOT NULL,
  logradouro VARCHAR(100) NOT NULL,
  numero VARCHAR(10) NOT NULL
);

CREATE TABLE Empresa (
  id_empresa INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(100) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  fk_endereco INT NULL,
  CONSTRAINT uq_empresa_cnpj UNIQUE (cnpj),
  CONSTRAINT fk_empresa_endereco
    FOREIGN KEY (fk_endereco) REFERENCES Endereco (id_endereco) ON DELETE SET NULL
);

CREATE TABLE Cargo (
  id_cargo INT AUTO_INCREMENT PRIMARY KEY,
  nome_cargo VARCHAR(45) NOT NULL,
  nivel VARCHAR(45) NOT NULL
);

CREATE TABLE Permissao (
  id_permissao INT AUTO_INCREMENT PRIMARY KEY,
  nome_permissao VARCHAR(45) NOT NULL
);

CREATE TABLE Cargo_Permissao (
  fk_cargo INT NOT NULL,
  fk_permissao INT NOT NULL,
  PRIMARY KEY (fk_cargo, fk_permissao),
  CONSTRAINT fk_cp_cargo
    FOREIGN KEY (fk_cargo) REFERENCES Cargo (id_cargo) ON DELETE CASCADE,
  CONSTRAINT fk_cp_permissao
    FOREIGN KEY (fk_permissao) REFERENCES Permissao (id_permissao) ON DELETE CASCADE
);

CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  senha VARCHAR(255) NOT NULL, -- hash (bcrypt/argon2), nao texto plano
  celular CHAR(11) NULL,
  fk_empresa INT NOT NULL,
  fk_cargo INT NOT NULL,
  CONSTRAINT uq_usuario_email UNIQUE (email),
  CONSTRAINT fk_usuario_empresa
    FOREIGN KEY (fk_empresa) REFERENCES Empresa (id_empresa) ON DELETE RESTRICT,
  CONSTRAINT fk_usuario_cargo
    FOREIGN KEY (fk_cargo) REFERENCES Cargo (id_cargo) ON DELETE RESTRICT
);

CREATE TABLE Instancias (
  id_instancia INT AUTO_INCREMENT PRIMARY KEY,
  fk_empresa INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  identificador VARCHAR(50) NOT NULL,
  CONSTRAINT uq_instancia_identificador UNIQUE (identificador),
  CONSTRAINT fk_instancia_empresa
    FOREIGN KEY (fk_empresa) REFERENCES Empresa (id_empresa) ON DELETE CASCADE
);


-- Tabelas novas (monitoramento, leituras e eventos)


CREATE TABLE Componentes (
  id_componente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  unidade_medida VARCHAR(15) NOT NULL
);

CREATE TABLE Monitoramento (
  id_monitoramento INT AUTO_INCREMENT PRIMARY KEY,
  fk_componente INT NOT NULL,
  fk_instancia INT NOT NULL,
  parametro DECIMAL(10,2) NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT uq_monitoramento_componente_instancia
    UNIQUE (fk_componente, fk_instancia),
  CONSTRAINT fk_monitoramento_componente
    FOREIGN KEY (fk_componente) REFERENCES Componentes (id_componente) ON DELETE RESTRICT,
  CONSTRAINT fk_monitoramento_instancia
    FOREIGN KEY (fk_instancia) REFERENCES Instancias (id_instancia) ON DELETE CASCADE
);

CREATE TABLE Leitura_Metrica (
  id_leitura_m INT AUTO_INCREMENT PRIMARY KEY,
  fk_monitoramento INT NOT NULL,
  valor DOUBLE NOT NULL,
  data DATETIME NOT NULL,
  CONSTRAINT fk_leitura_monitoramento
    FOREIGN KEY (fk_monitoramento) REFERENCES Monitoramento (id_monitoramento) ON DELETE CASCADE
);

CREATE TABLE Criticidade (
  id_criticidade INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NOT NULL
);

CREATE TABLE Evento (
  id_evento INT AUTO_INCREMENT PRIMARY KEY,
  fk_leitura INT NOT NULL,
  fk_criticidade INT NOT NULL,
  data_hora DATETIME NOT NULL,
  descricao VARCHAR(255) NULL,
  chamado_jira_id VARCHAR(45) NULL,
  status VARCHAR(45) NOT NULL DEFAULT 'aberto',
  CONSTRAINT fk_evento_leitura
    FOREIGN KEY (fk_leitura) REFERENCES Leitura_Metrica (id_leitura_m) ON DELETE CASCADE,
  CONSTRAINT fk_evento_criticidade
    FOREIGN KEY (fk_criticidade) REFERENCES Criticidade (id_criticidade) ON DELETE RESTRICT
);



INSERT INTO Endereco (estado, cidade, bairro, logradouro, numero) VALUES
('SP', 'Sao Paulo', 'Vila Olimpia', 'Rua Funchal', '418'),
('SP', 'Campinas', 'Cambui', 'Avenida Norte-Sul', '1200'),
('RJ', 'Rio de Janeiro', 'Botafogo', 'Rua Voluntarios da Patria', '89');
 

INSERT INTO Empresa (razao_social, cnpj, fk_endereco) VALUES
('LojaCerta Comercio Eletronico LTDA', '12345678000190', 1),
('Mercado Rapido E-commerce S.A.', '98765432000110', 2),
('BoraComprar Varejo Digital LTDA', '11222333000144', 3);
 

INSERT INTO Cargo (nome_cargo, nivel) VALUES
('Administrador', 'Alto'),
('Analista de Infraestrutura', 'Medio'),
('Suporte Tecnico', 'Baixo');
 

INSERT INTO Permissao (nome_permissao) VALUES
('gerenciar_usuarios'),
('gerenciar_instancias'),
('visualizar_dashboard'),
('visualizar_historico_alertas'),
('gerenciar_parametros_monitoramento');
 

-- Administrador: todas as permissoes
INSERT INTO Cargo_Permissao (fk_cargo, fk_permissao) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
-- Analista de Infraestrutura: gerencia instancias ve dashboard ve historico e parametros
(2, 2), (2, 3), (2, 4), (2, 5),
-- Suporte Tecnico: so visualizacao
(3, 3), (3, 4);
 

INSERT INTO Usuario (nome, email, senha, celular, fk_empresa, fk_cargo) VALUES
('Arthur Rocha', 'arthur.rocha@lojacerta.com', 'senha123', '11987654321', 1, 1),
('Emanuelly Melo', 'emanuelly.melo@lojacerta.com', 'senha123', '11976543210', 1, 2),
('Enzo Quinalha', 'enzo.quinalha@mercadorapido.com', 'senha123', '19965432109', 2, 1),
('Gustavo Lima', 'gustavo.lima@mercadorapido.com', 'senha123', '19954321098', 2, 3),
('Maria Fernanda', 'maria.fernanda@boracomprar.com', 'senha123', '21943210987', 3, 1),
('Rafael Naleto', 'rafael.naleto@boracomprar.com', 'senha123', '21932109876', 3, 2);
 

INSERT INTO Instancias (fk_empresa, nome, identificador) VALUES
(1, 'VM Producao Web', 'lojacerta-prod-web-01'),
(1, 'VM Banco de Dados', 'lojacerta-prod-db-01'),
(2, 'VM Producao Web', 'mercadorapido-prod-web-01'),
(2, 'VM Cache/Redis', 'mercadorapido-prod-cache-01'),
(3, 'VM Producao Web', 'boracomprar-prod-web-01');
 

INSERT INTO Componentes (nome, unidade_medida) VALUES
('CPU', '%'),
('Memoria RAM', '%'),
('Armazenamento', '%'),
('Leitura de Disco', 'MB/s'),
('Escrita de Disco', 'MB/s'),
('Rede - Download', 'Mbps'),
('Rede - Upload', 'Mbps'),
('Latencia API Pagamento', 'ms');
 

INSERT INTO Monitoramento (fk_componente, fk_instancia, parametro, ativo) VALUES
(1, 1, 85.00, 1),  -- limite 85%
(2, 1, 90.00, 1),  -- limite 90%
(3, 2, 80.00, 1),  -- limite 80%
(1, 3, 85.00, 1),  -- limite 85%
(8, 3, 1000.00, 1), -- limite 1000ms
(2, 4, 90.00, 1),  -- limite 90%
(1, 5, 85.00, 1);  -- limite 85%
 

INSERT INTO Leitura_Metrica (fk_monitoramento, valor, data) VALUES
(1, 62.50, '2026-09-18 08:00:00'),
(1, 91.30, '2026-09-18 08:05:00'), -- acima do parametro (85) -> gera evento
(2, 74.10, '2026-09-18 08:00:00'),
(3, 78.90, '2026-09-18 08:00:00'),
(4, 88.40, '2026-09-18 09:00:00'), -- acima do parametro (85) -> gera evento
(5, 1450.00, '2026-09-18 09:10:00'), -- acima do parametro (1000ms) -> gera evento
(6, 55.00, '2026-09-18 09:15:00'),
(7, 60.20, '2026-09-18 10:00:00');
 

INSERT INTO Criticidade (nome) VALUES
('Baixa'),
('Media'),
('Alta'),
('Critica');
 

INSERT INTO Evento (fk_leitura, fk_criticidade, data_hora, descricao, chamado_jira_id, status) VALUES
(2, 3, '2026-09-18 08:05:00', 'Uso de CPU acima do limite configurado na VM de producao web', 'TRACK-101', 'aberto'),
(5, 2, '2026-09-18 09:00:00', 'Uso de CPU acima do limite configurado na VM de producao web (MercadoRapido)', 'TRACK-102', 'em_andamento'),
(6, 4, '2026-09-18 09:10:00', 'Latencia da API de pagamento acima do limite critico', 'TRACK-103', 'aberto');
