CREATE DATABASE livraria
GO
USE livraria

CREATE TABLE Livro (
	cod INT PRIMARY KEY,
	nome VARCHAR (100),
	lingua VARCHAR (50),
	ano INT
)

CREATE TABLE Edicao (
	isbn INT PRIMARY KEY,
	preco DECIMAL(7, 2),
	ano INT,
	numPaginas INT,
	qtdEstoque INT
)

CREATE TABLE Autor (
	cod INT PRIMARY KEY,
	nome VARCHAR(100),
	nascimento DATE,
	pais VARCHAR(50),
	biografia VARCHAR(MAX)
)

CREATE TABLE Editora (
	cod INT PRIMARY KEY,
	nome VARCHAR(50),
	logradouro VARCHAR(255),
	numero INT,
	cep CHAR(8),
	telefone CHAR(11),
)

CREATE TABLE LivroAutor (
	codLivro INT NOT NULL,
	codAutor INT NOT NULL,
	PRIMARY KEY (codLivro, codAutor),
	FOREIGN KEY (codLivro) REFERENCES Livro (cod),
	FOREIGN KEY (codAutor) REFERENCES Autor (cod)
)

CREATE TABLE LivroEdicaoEditora (
	isbnEdicao INT NOT NULL,
	codEditora INT NOT NULL,
	codLivro INT NOT NULL,
	PRIMARY KEY (isbnEdicao, codEditora, codLivro),
	FOREIGN KEY (isbnEdicao) REFERENCES Edicao (isbn),
	FOREIGN KEY (codEditora) REFERENCES Editora (cod),
	FOREIGN KEY (codLivro) REFERENCES Livro (cod)
)

EXEC sp_rename 'dbo.Edicao.ano', 'anoEdicao', 'column'

ALTER TABLE Editora
ALTER COLUMN nome VARCHAR(30)

/*
ALTER TABLE Autor
ALTER COLUMN nascimento INT */

ALTER TABLE Autor
DROP COLUMN nascimento

ALTER TABLE Autor
ADD ano INT

INSERT INTO Livro 
VALUES 
	(1001, 'CCNA 4.1', 'PT-BR', 2015),
	(1002, 'HTML 5', 'PT-BR', 2017),
	(1003, 'Redes de Computadores', 'EN', 2010),
	(1004, 'Android em Ação', 'PT-BR', 2018)

INSERT INTO Autor 
VALUES 
	(10001, 'Inácio da Siva', 'Brasil', 'Programado WEB desde 1995', 1975),
	(10002, 'Andrew Tannenbaum', 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij', 1944),
	(10003, 'Luis Rocha', 'Brasil', 'Programador Mobile desde 2000', 1967),
	(10004, 'David Halliday', 'EUA', 'Físico PH.D desde 1941', 1916)

INSERT INTO LivroAutor
VALUES
	(1001, 10001),
	(1002, 10003),
	(1003, 10002),
	(1004, 10003)

INSERT INTO Edicao
VALUES 
	(0130661023, 189.99, 2018, 653, 10)
	
UPDATE Autor
SET biografia = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
WHERE cod = 10002

UPDATE Edicao
SET qtdEstoque -= 2
WHERE isbn = 0130661023

DELETE Autor
WHERE cod = 10004



	