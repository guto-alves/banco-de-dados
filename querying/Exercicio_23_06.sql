USE master
DROP DATABASE IF EXISTS Exercicio2306
CREATE DATABASE Exercicio2306
GO
USE Exercicio2306

CREATE TABLE cliente (
	cpf CHAR(11) PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	telefone VARCHAR(15)
);

CREATE TABLE fornecedor (
	id INT IDENTITY PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	logradouro VARCHAR(50),
	numero INT,
	complemento VARCHAR(20),
	cidade VARCHAR(30)
);

CREATE TABLE produto (
	codigo INT IDENTITY,
	descricao VARCHAR(50),
	fornecedor INT,
	preco DECIMAL(7, 2) NOT NULL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(fornecedor)
		REFERENCES fornecedor (id)
);

CREATE TABLE venda (
	codigo INT,
	produto INT,
	cliente CHAR(11),
	quantidade INT,
	valor_total DECIMAL(7, 2),
	data DATE NOT NULL,
	PRIMARY KEY(codigo, produto, cliente, data),
	FOREIGN KEY(produto)
		REFERENCES produto (codigo),
	FOREIGN KEY(cliente)
		REFERENCES cliente (cpf)
);

GO

INSERT INTO cliente 
	VALUES
		('25186533710', 'Maria Antonia', '87652314'),
		('34578909290', 'Julio Cesar', '82736541'),
		('79182639800', 'Paulo Cesar', '90765273'),
		('87627315416', 'Luiz Carlos', '61289012'),
		('36587498700', 'Paula Carla', '23547888');

INSERT INTO fornecedor 
	VALUES
		('LG', 'Rod. Bandeirantes', '70000', 'Km 70', 'Itapeva'),
		('Asus', 'Av. Nações Unidas', '10206', 'Sala 225', 'São Paulo'),
		('AMD', 'Av. Nações Unidas', '10206', 'Sala 1095', 'São Paulo'),
		('Leadership', 'Av. Nações Unidas', '10206', 'Sala 87', 'São Paulo'),
		('Inno', 'Av. Nações Unidas', '10206', 'Sala 34', 'São Paulo'),
		('Kingston', 'Av. Nações Unidas', '10206', 'Sala 18', 'São Paulo');

INSERT INTO produto 
	VALUES
		('Monitor 19 pol.', 1, 449.99),
		('Zenfone', 2, 1599.99),
		('Gravador de DVD - Sata', 1, 99.99),
		('Leitor de CD', 1, 49.99),
		('Processador - Ryzen 5', 3, 599.99),
		('Mouse', 4, 19.99),
		('Teclado', 4, 25.99),
		('Placa de Video - RTX 2060', 2, 2399.99),
		('Pente de Memória 4GB DDR 4 2400 MHz', 5, 259.99);

INSERT INTO venda 
	VALUES
		(1, 1, '25186533710', 1, 449.99, '2009-09-03'),
		(1, 4, '25186533710', 1, 49.99, '2009-09-03'),
		(1, 5, '25186533710', 1, 349.99, '2009-09-03'),
		(2, 6, '79182639800', 4, 79.96, '2009-09-06'),
		(3, 3, '87627315416', 1, 99.99, '2009-09-06'),
		(3, 7, '87627315416', 1, 25.99, '2009-09-06'),
		(3, 8, '87627315416', 1, 599.99, '2009-09-06'),
		(4, 2, '34578909290', 2, 1399.98, '2009-09-08');

GO

--Quantos produtos não foram vendidos ?	
SELECT 
	COUNT(produto.codigo) AS total_produtos_nao_vendidos
FROM
	produto LEFT OUTER JOIN venda
		ON produto.codigo = venda.produto
WHERE
	venda.produto IS NULL;


--Nome do produto, Nome do fornecedor, count() do produto nas vendas	
SELECT
	produto.descricao, 
	fornecedor.nome,
	COUNT(produto.codigo)
FROM
	fornecedor INNER JOIN produto
		ON fornecedor.id = produto.fornecedor
	INNER JOIN venda
		ON produto.codigo = venda.produto
GROUP BY
	produto.descricao, fornecedor.nome;


--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade
SELECT
	cliente.nome,
	COUNT(venda.produto) AS produtos_comprados
FROM
	cliente INNER JOIN venda
		ON cliente.cpf = venda.cliente
GROUP BY
	cliente.nome
ORDER BY
	produtos_comprados;
	
	
--Nome do produto e Quantidade de vendas do produto com menor valor do 
--catálogo de produtos	
SELECT
	produto.descricao,
	COUNT(venda.produto) AS quantidade_vendas
FROM
	produto INNER JOIN venda
		ON produto.codigo = venda.produto
WHERE
	produto.preco = (
		SELECT 
			MIN(produto.preco)
		FROM 
			produto
	)
GROUP BY
	produto.descricao;


--Nome do Fornecedor e Quantos produtos cada um fornece	
SELECT
	fornecedor.nome,
	COUNT(produto.codigo) AS total_produtos
FROM
	fornecedor INNER JOIN produto
		ON fornecedor.id = produto.fornecedor
GROUP BY
	fornecedor.nome;


--Considerando que hoje é 20/10/2009, consultar o código da compra, nome 
--do cliente, telefone do cliente e quantos dias da data da compra
SELECT DISTINCT
	venda.codigo,
	cliente.nome,
	cliente.telefone,
	DATEDIFF(DAY, venda.data, '20/10/2009') AS  dias_apos_compra
FROM
	cliente INNER JOIN venda
		ON cliente.cpf = venda.cliente;


--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade 
--que comprou mais de 2 produtos	
SELECT 
	SUBSTRING(cliente.cpf, 1, 3) + '.' + SUBSTRING(cliente.cpf, 4, 3) + '.' + 
	SUBSTRING(cliente.cpf, 7, 3) + '-' + SUBSTRING(cliente.cpf, 10, 2) AS cpf,
	cliente.nome,
	COUNT(venda.produto) AS quantidade_produtos
FROM
	cliente INNER JOIN venda
		ON cliente.cpf = venda.cliente
GROUP BY
	cliente.cpf, cliente.nome
HAVING
	COUNT(venda.produto) > 2;


--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma do 
--valor_total gasto	
SELECT 
	SUBSTRING(cliente.cpf, 1, 3) + '.' + SUBSTRING(cliente.cpf, 4, 3) + '.' + 
	SUBSTRING(cliente.cpf, 7, 3) + '-' + SUBSTRING(cliente.cpf, 10, 2) AS cpf,
	cliente.nome,
	SUM(produto.preco * venda.quantidade) as valor_total_gasto
FROM
	cliente INNER JOIN venda
		ON cliente.cpf = venda.cliente
	INNER JOIN produto
		ON venda.produto = produto.codigo
GROUP BY
	cliente.cpf, cliente.nome;


--Código da compra, data da compra em formato (DD/MM/AAAA) e uma coluna, 
--chamada dia_semana, que escreva o dia da semana por extenso	
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever 
--segunda-feira, assim por diante, até caso dia 7, escrever sábado
SELECT DISTINCT
	venda.codigo,
	CONVERT(VARCHAR, venda.data, 103) AS data_compra,
	CASE 
		WHEN DATEPART(WEEKDAY, venda.data) = 1 THEN 'Domingo'
		WHEN DATEPART(WEEKDAY, venda.data) = 2 THEN 'Segunda-feira'
		WHEN DATEPART(WEEKDAY, venda.data) = 3 THEN 'Terça-Feira'
		WHEN DATEPART(WEEKDAY, venda.data) = 4 THEN 'Quarta-Feira'
		WHEN DATEPART(WEEKDAY, venda.data) = 5 THEN 'Quinta-Feira'
		WHEN DATEPART(WEEKDAY, venda.data) = 5 THEN 'Sexta-Feira'
		WHEN DATEPART(WEEKDAY, venda.data) = 5 THEN 'Sábado'
	END AS dia_semana,
	DATENAME(WEEKDAY, venda.data) AS dia_semana2
FROM
	venda;
