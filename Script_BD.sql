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
tipo VARCHAR(50),
unidade VARCHAR(50)
);

CREATE TABLE componente_instancia(
fk_componente INT,
fk_instancia INT,
ativo BOOLEAN,

PRIMARY KEY(fk_componente, fk_instancia),

FOREIGN KEY (fk_componente) REFERENCES componente(id_componente),
FOREIGN KEY (fk_instancia) REFERENCES instancia(id_instancia)
);

CREATE TABLE cargo(
id_cargo INT PRIMARY KEY AUTO_INCREMENT,
nome_cargo VARCHAR(45)
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