USE master;
DROP DATABASE IF EXISTS ExercicioBiblioteca;
CREATE DATABASE ExercicioBiblioteca;
GO
USE ExercicioBiblioteca;

CREATE TABLE clientes (
	cod INT IDENTITY(1001, 1) PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	logradouro VARCHAR(30),
	numero INT,
	telefone CHAR(11)
);

CREATE TABLE autores (
	cod INT IDENTITY(10001, 1) PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	pais VARCHAR(50),
	biografia VARCHAR (255) 
);

CREATE TABLE corredores (
	cod INT IDENTITY(3251, 1) PRIMARY KEY,
	tipo VARCHAR(20) NOT NULL,
);

GO

CREATE TABLE livros (
	cod INT IDENTITY PRIMARY KEY,
	cod_autor INT NOT NULL,
	cod_corredores INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	pag INT,
	idioma VARCHAR(50),
	FOREIGN KEY (cod_autor) 
		REFERENCES autores (cod),
	FOREIGN KEY(cod_corredores)
		REFERENCES corredores (cod)
); 

GO

CREATE TABLE emprestimo (
	cod_cli INT NOT NULL,
	data DATE NOT NULL,
	cod_livro INT NOT NULL,
	PRIMARY KEY(cod_cli, cod_livro),
	FOREIGN KEY(cod_cli) 
		REFERENCES clientes (cod), 
	FOREIGN KEY(cod_livro) 
		REFERENCES livros (cod)
);

GO

INSERT INTO clientes
	VALUES
		('Luis Augusto', 'R. 25 de Março', 250, 996529632),
		('Maria Luisa', 'R. XV de Novembro',890, 998526541),
		('Claudio Batista',	'R. Anhaia', 112, 996547896),
		('Wilson Mendes', 'R. do Hipódromo', 1250, 991254789),
		('Ana Maria', 'R. Augusta',	896, 999365589),
		('Cinthia Souza', 'R. Voluntários da Pátria', 1023, 984256398),
		('Luciano Britto', NULL, NULL, 995678556),
		('Antônio do Valle', 'R. Sete de Setembro', 1894,NULL);

INSERT INTO autores
	VALUES
		('Ramez E. Elmasri',	'EUA', 'Professor da Universidade do Texas'),
		('Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
		('Diva Marília Flemming',	'Brasil ','Professora Adjunta da UFSC'),
		('David Halliday','EUA', 'Ph.D. da University of Pittsburgh'),
		('Marco Antonio Furlan de Souza', 'Brasil', 'Prof. do IMT'),
		('Alfredo Steinbruch', 'Brasil', 'Professor de Matemática da UFRS e da PUCRS');

INSERT INTO corredores
	VALUES
		('Informática'),
		('Matemática'),
		('Física'),
		('Química');

INSERT INTO livros
	VALUES
		(10001,	3251, 'Sistemas de Banco de dados', 720, 'Português'),
		(10002,	3251, 'Sistemas Operacionais Modernos', 580, 'Português'),
		(10003,	3252, 'Calculo A', 290, 'Português'),
		(10004,	3253, 'Fundamentos de Física I', 185, 'Português'),
		(10005,	3251, 'Algoritmos e Lógica de Programação', 90, 'Português'),
		(10006,	3252, 'Geometria Analítica', 75, 'Português'),
		(10004,	3253, 'Fundamentos de Física II', 150, 'Português'),
		(10002,	3251, 'Redes de Computadores', 493, 'Inglês'),
		(10002,	3251, 'Organização Estruturada de Computadores', 576, 'Português');

INSERT INTO emprestimo (cod_cli, data, cod_livro)
	VALUES
		(1001, '2012-05-10', 1),
		(1001, '2012-05-10', 2),
		(1001, '2012-05-10', 8),
		(1002, '2012-05-11', 4),
		(1002, '2012-05-11', 7),
		(1003, '2012-05-12', 3),
		(1004, '2012-05-14', 5),
		(1001, '2012-05-15', 9);

GO


-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo
--formatada padrão BR (dd/mm/yyyy)
SELECT 
	clientes.nome,
	CONVERT(VARCHAR, emprestimo.data, 103) as data_emprestimo
FROM
	clientes INNER JOIN emprestimo
		ON clientes.cod = emprestimo.cod_cli
GROUP BY
	clientes.nome, emprestimo.data;


-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram 
--escritos por Cada autor, ordenado pelo número de livros. 
--Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
SELECT 
	CASE
		WHEN (LEN(autores.nome) > 25) 
			THEN SUBSTRING(autores.nome, 1, 13)
		ELSE
			autores.nome
	END AS nome,
	COUNT(livros.cod) as total_livros
FROM
	autores INNER JOIN livros
		ON autores.cod = livros.cod_autor
GROUP BY
	autores.nome
ORDER BY 
	total_livros;


-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com 
--maior número de páginas cadastrados no sistema
SELECT 
	autores.nome, 
	autores.pais
FROM
	autores INNER JOIN livros
		ON autores.cod = livros.cod_autor
WHERE
	livros.pag IN (
		SELECT 
			MAX(livros.pag)
		FROM 
			livros							
	);


-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem 
--livros emprestados
SELECT
	clientes.nome, 
	clientes.logradouro + ', ' + CAST(clientes.numero AS VARCHAR) AS endereco
FROM
	clientes INNER JOIN emprestimo
		ON clientes.cod = emprestimo.cod_cli 
GROUP BY
	clientes.nome, clientes.logradouro, clientes.numero;


-- Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT 
	COUNT(livros.cod) AS total_livros_nao_emprestados
FROM
	livros LEFT JOIN emprestimo
		ON livros.cod = emprestimo.cod_livro
WHERE
	emprestimo.cod_livro IS NULL;

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos
-- livros, ordenados por quantidade de livro
SELECT 
	autores.nome, corredores.tipo, 
	COUNT(livros.cod) AS quantidade_livros
FROM
	autores INNER JOIN livros
		ON autores.cod = livros.cod_autor
	INNER JOIN corredores
		ON livros.cod_corredores = corredores.cod
GROUP BY
	autores.nome, corredores.tipo
ORDER BY
	quantidade_livros;


-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o 
-- nome do cliente, o nome do livro, o total de dias que cada um está com
-- o livro e, uma coluna que apresente, caso o número de dias seja superior
-- a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'							
SELECT 
	clientes.nome, livros.nome,
	DATEDIFF(DAY, emprestimo.data, '18/05/2012') as total_dias,
	CASE
		WHEN DATEDIFF(DAY, emprestimo.data, '18/05/2012') > 4
			THEN 'Atrasado'
		ELSE 'No Prazo'
	END AS status
FROM
	clientes INNER JOIN emprestimo
		ON clientes.cod = emprestimo.cod_cli
	INNER JOIN livros
		ON emprestimo.cod_livro = livros.cod;


-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e 
-- quantos livros tem em cada corredor							
SELECT 
	corredores.cod, corredores.tipo,
	COUNT(livros.cod) AS total_livros
FROM 
	corredores 
INNER JOIN livros 
	ON corredores.cod = livros.cod_corredores
GROUP BY
	corredores.cod, corredores.tipo;


-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de 
-- livros cadastrado é maior ou igual a 2.		
SELECT
	autores.nome, 
	COUNT (livros.cod) AS total_livros
FROM
	autores	INNER JOIN livros
		ON autores.cod = livros.cod_autor
GROUP BY
	autores.nome
HAVING 
	COUNT (livros.cod) >= 2
ORDER BY 
	autores.nome;


-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o 
-- nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais							
SELECT
	clientes.nome AS cliente, 
	livros.nome AS livro
FROM
	clientes INNER JOIN emprestimo
		ON clientes.cod = emprestimo.cod_cli
	INNER JOIN livros
		ON emprestimo.cod_livro = livros.cod
WHERE
	DATEDIFF(DAY, emprestimo.data, '18/05/2012') >= 7;

