CREATE DATABASE TrackCommerce;
USE TrackCommerce;

CREATE TABLE endereco(
id_endereco INT PRIMARY KEY AUTO_INCREMENT,
estado CHAR(2),
cidade VARCHAR(100),
bairro VARCHAR(100),
logradouro VARCHAR(100),
numero VARCHAR(10)
);

CREATE TABLE empresa(
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(45),
cnpj CHAR(14),
fk_endereco INT,

FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco)
);

CREATE TABLE instancia(
id_instancia INT PRIMARY KEY AUTO_INCREMENT,
fk_empresa INT,
nome VARCHAR(50),
identificador VARCHAR(50),

FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa)
);

CREATE TABLE componente(
id_componente INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50),
opcao_monitorar VARCHAR (150)
);

CREATE TABLE componente_instancia(
fk_componente INT,
fk_instancia INT,
ativo BOOLEAN,
parametro VARCHAR(50),
 
FOREIGN KEY (fk_componente) REFERENCES componente(id_componente),
FOREIGN KEY (fk_instancia) REFERENCES instancia(id_instancia)
);



CREATE TABLE cargo(
id_cargo INT PRIMARY KEY AUTO_INCREMENT,
nome_cargo VARCHAR(45),
nivel VARCHAR(45)
);

CREATE TABLE usuario(
id_usuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
email VARCHAR(100),
senha VARCHAR(100),
celular CHAR(11),
fk_empresa INT,
fk_cargo INT,

FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa),
FOREIGN KEY (fk_cargo) REFERENCES cargo(id_cargo)
);

CREATE TABLE permissao(
id_permissao INT PRIMARY KEY AUTO_INCREMENT,
nome_permissao VARCHAR(45)
);

CREATE TABLE cargo_permissao(
fk_cargo INT,
fk_permissao INT,

PRIMARY KEY(fk_cargo,fk_permissao),

FOREIGN KEY (fk_cargo) REFERENCES cargo(id_cargo),
FOREIGN KEY (fk_permissao) REFERENCES permissao(id_permissao)
);

INSERT INTO endereco (estado, cidade, bairro, logradouro, numero) 
VALUES 
('SP', 'São Paulo', 'Bela Vista', 'Avenida Paulista', '1578'),
('RJ', 'Rio de Janeiro', 'Centro', 'Rua da Assembleia', '10'),
('MG', 'Belo Horizonte', 'Savassi', 'Avenida do Contorno', '6000'),
('PR', 'Curitiba', 'Batel', 'Avenida do Batel', '1230');

INSERT INTO empresa (razao_social, cnpj, fk_endereco) 
VALUES 
('TrackCommerce Tecnologia LTDA', '12345678000100', 1),
('Global Vendas S.A.', '98765432000199', 2),
('Logistica Nacional ME', '11222333000144', 3),
('Tech Solutions EIRELI', '44555666000188', 4);

INSERT INTO componente(nome, opcao_monitorar)VALUES
("CPU", "Porcentagem de Uso"),
("CPU", "Frequência do Processador"),
("Disco", "Porcentagem de Uso"),
("Disco", "Quantidade de GB livre"),
("RAM", "Porcentagem de Uso"),
("RAM", "Quantidade de GB livre"),
("Rede", "Monitorar Latência da Rede");


select * from instancia;


select * from componente_instancia;



SELECT 
    a.nome,
a.identificador,
a.id_instancia,
GROUP_CONCAT(DISTINCT c.nome SEPARATOR ', ') AS grupoComponentes,
GROUP_CONCAT(DISTINCT CONCAT(c.id_componente, ':',  ci.parametro) SEPARATOR', ') AS grupoOpcoesComponentes
FROM instancia a
JOIN componente_instancia ci ON ci.fk_instancia = a.id_instancia
JOIN componente c ON c.id_componente = ci.fk_componente
WHERE a.fk_empresa = 1
GROUP BY a.id_instancia, a.nome;	

