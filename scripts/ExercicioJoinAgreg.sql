USE master
DROP DATABASE IF EXISTS ExercicioJoinAgreg
CREATE DATABASE ExercicioJoinAgreg
GO
USE ExercicioJoinAgreg

CREATE TABLE Cliente (
	Codigo INT IDENTITY (33601, 1) PRIMARY KEY,
	Nome VARCHAR (20) NOT NULL,
	Endereco VARCHAR (30) NOT NULL,
	Numero_Porta INT NOT NULL,
	Telefone CHAR(8) NOT NULL,
	Data_Nascimento DATE
);

CREATE TABLE Fornecedor (
	Codigo INT IDENTITY (1001, 1) PRIMARY KEY,
	Nome VARCHAR (20) NOT NULL,
	Atividade VARCHAR (30) NOT NULL,
	Telefone CHAR (8) NOT NULL
);

CREATE TABLE Produto (
	Codigo INT IDENTITY PRIMARY KEY,
	Nome VARCHAR (30) NOT NULL,
	Valor_Unitario DECIMAL (7, 2) NOT NULL,
	Quantidade_Estoque INT NOT NULL,
	Descricao VARCHAR (50) NOT NULL,
	Codigo_Fornecedor INT NOT NULL,
	FOREIGN KEY (Codigo_Fornecedor) REFERENCES Fornecedor (Codigo)
);

CREATE TABLE Pedido (
	Codigo_Pedido INT,
	Codigo_Cliente INT,
	Codigo_Produto INT,
	Quantidade INT NOT NULL,
	Previsao_Entrega DATE NOT NULL,
	PRIMARY KEY (Codigo_Pedido, Codigo_Cliente, Codigo_Produto),
	FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente (Codigo),
	FOREIGN KEY (Codigo_Produto) REFERENCES Produto (Codigo)
); 

INSERT INTO Cliente 
VALUES
	('Maria Clara',	'R. 1° de Abril', 870, '96325874', '1990-04-15'),
	('Alberto Souza', 'R. XV de Novembro', 987, '95873625',	'1975-12-25'),
	('Sonia Silva', 'R. Voluntários da Pátria',	1152, '75418596',	'1944-06-03'),
	('José Sobrinho', 'Av. Paulista', 250,	'85236547',	'1982-10-12'),
	('Carlos Camargo', 'Av. Tiquatira',	9652, '75896325', '1975-02-27');

INSERT INTO Fornecedor 
VALUES
	('Estrela', 'Brinquedo', '41525898'),
	('Lacta', ' Chocolate', '42698596'),
	('Asus', ' Informática', '52014596'),
	('Tramontina', ' Utensílios Domésticos', '50563985'),
	('Grow', ' Brinquedos', '47896325'),
	('Mattel', ' Bonecos', '59865898');

INSERT INTO Produto 
VALUES
	('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
	('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
	('Faqueiro', 350.00, 0, '120 peças', 1004),
	('Jogo para churrasco', 75.00, 3, '7 peças', 1004),
	('Eee Pc', 750.00, 29, 'Netbook com 4 Gb de HD', 1003),
	('Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001),
	('Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002),
	('Galak', 5.00, 65, 'Barra', 1002);

INSERT INTO Pedido 
VALUES
	(99001,	33601,	1,	1,	'2017-07-07'),
	(99001,	33601,	2,	1,	'2017-07-07'),
	(99001,	33601,	8,	3,	'2017-07-07'),
	(99002,	33602,	2,	1,	'2017-07-09'),
	(99002,	33602,	4,	3,	'2017-07-09'),
	(99003,	33605,	5,	1,	'2017-07-15');


--Codigo do produto, nome do produto, quantidade em estoque,									
--uma coluna dizendo se está baixo, bom ou confortável,									
--uma coluna dizendo o quanto precisa comprar para que o 
--estoque fique minimamente confortável.
SELECT 
	Codigo, Nome, Quantidade_Estoque,
	CASE 
		WHEN Quantidade_Estoque > 20
			THEN 'Confortável'
		WHEN Quantidade_Estoque < 10
			THEN 'Baixo'
		ELSE 
			'Bom'	
	END AS Status_Estoque,
	CASE
		WHEN Quantidade_Estoque > 20 
			THEN 0
		ELSE
			21 - Quantidade_Estoque
	END AS Necessario_Status_Confortavel
FROM 
	Produto;


--Consultar o nome e o telefone dos fornecedores que não tem 
--produtos cadastrados								
SELECT 
	Fornecedor.Nome, Fornecedor.Telefone
FROM
	Fornecedor LEFT OUTER JOIN Produto
		ON Fornecedor.Codigo = Produto.Codigo_Fornecedor
WHERE 
	Produto.Codigo_Fornecedor IS NULL;


--Consultar o nome e o telefone dos clientes que não tem pedidos 
--cadastrados	
SELECT 
	Cliente.Nome, Cliente.Telefone
FROM 
	Cliente LEFT JOIN Pedido
		ON Cliente.Codigo = Pedido.Codigo_Cliente
WHERE
	Pedido.Codigo_Cliente IS NULL;
						

--Considerando a data do sistema, consultar o nome do cliente, 									
--endereço concatenado com o número de porta o código do pedido e 
--quantos dias faltam para a data prevista para a entrega criar, 
--também, uma coluna que escreva ABAIXO para menos de 25 dias de 
--previsão de entrega, ADEQUADO entre 25 e 30 dias e ACIMA para 
--previsão superior a 30 dias as linhas de saída não devem se 
--repetir e ordenar pela quantidade de dias	
SELECT 
	Cliente.Nome, 
	Cliente.Endereco + ', ' + CONVERT(VARCHAR(5), Cliente.Numero_Porta) AS Endereco_Completo,
	Pedido.Codigo_Pedido,
	DATEDIFF(DAY,  GETDATE(), Pedido.Previsao_Entrega) 
		AS Dias_Para_Entrega,
	CASE
		WHEN DATEDIFF(DAY,  GETDATE(), Pedido.Previsao_Entrega) > 30
			THEN 'ACIMA'
		WHEN DATEDIFF(DAY,  GETDATE(), Pedido.Previsao_Entrega) < 25
			THEN 'ABAIXO' 
		ELSE 
			'ADEQUADO'
	END AS Status_Entrega
FROM 
	Cliente INNER JOIN Pedido
		ON Cliente.Codigo = Pedido.Codigo_Cliente
GROUP BY 
	Cliente.Nome, Cliente.Endereco, Cliente.Numero_Porta,
	Pedido.Codigo_Pedido, Pedido.Previsao_Entrega
ORDER BY
	Dias_Para_Entrega;


--Consultar o Nome do cliente, o código do pedido, 							
--a soma do gasto do cliente no pedido e a quantidade de produtos 
--por pedido ordenar pelo nome do cliente		
SELECT 
	Cliente.Nome, Pedido.Codigo_Pedido,
	SUM (Produto.Valor_Unitario * Pedido.Quantidade) AS Valor_Pedido,
	SUM (Pedido.Quantidade) AS Quantidade_Produtos
FROM
	Cliente INNER JOIN Pedido
		ON Cliente.Codigo = Pedido.Codigo_Cliente
	INNER JOIN Produto
		ON Pedido.Codigo_Produto = Produto.Codigo
GROUP BY 
	Cliente.Nome, Pedido.Codigo_Pedido
ORDER BY
	Cliente.Nome;
			

--Consultar o Código e o nome do Fornecedor e 
--a contagem de quantos produtos ele fornece
SELECT 
	Fornecedor.Codigo, Fornecedor.Nome,
	COUNT(Produto.Codigo_Fornecedor) AS Contagem_Produtos
FROM
	Fornecedor INNER JOIN Produto
		ON Fornecedor.Codigo = Produto.Codigo_Fornecedor
GROUP BY
	Fornecedor.Codigo, Fornecedor.Nome
ORDER BY
	Fornecedor.Nome;


--Consultar o nome e o telefone dos clientes que tem menos de 2 
--compras feitas. A query não deve considerar quem fez 2 compras.
SELECT
	Cliente.Nome, Cliente.Telefone
FROM
	Cliente INNER JOIN Pedido
		ON Cliente.Codigo = Pedido.Codigo_Cliente
GROUP BY
	Cliente.Nome, Cliente.Telefone
HAVING
	COUNT (Pedido.Codigo_Cliente) > 2;


--Consultar o Codigo do pedido que tem o maior valor unitário de 
--produto
SELECT 
	Pedido.Codigo_Pedido, Produto.Nome, Produto.Valor_Unitario
FROM
	Pedido INNER JOIN Produto
		ON Pedido.Codigo_Produto = Produto.Codigo
WHERE
	Produto.Valor_Unitario =
(SELECT 
	MAX(Produto.Valor_Unitario)
FROM
	Produto);


--Consultar o Codigo_Pedido, o Nome do cliente e o valor total da 
--compra do pedido. O valor total se dá pela somatória de 
--valor_Unitário * quantidade comprada
SELECT 
	Pedido.Codigo_Pedido, Cliente.Nome,
	SUM (Produto.Valor_Unitario * Pedido.Quantidade) AS Valor_Total
FROM
	Cliente INNER JOIN Pedido
		ON Cliente.Codigo = Pedido.Codigo_Cliente
	INNER JOIN Produto
		ON Pedido.Codigo_Produto = Produto.Codigo
GROUP BY
	Pedido.Codigo_Pedido, Cliente.Nome;
