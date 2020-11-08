CREATE DATABASE loja;

GO

USE loja;

CREATE TABLE Produto (
	Codigo INT PRIMARY KEY IDENTITY,
	Nome VARCHAR(100) NOT NULL,
	Descricao VARCHAR(255),
	ValorUnitario DEC(7,2) NOT NULL DEFAULT(0)
);

CREATE TABLE Venda (
	NotaFiscal CHAR(9) PRIMARY KEY,
	CodigoProduto INT,
	Quantidade INT DEFAULT(1),
	FOREIGN KEY(CodigoProduto) 
		REFERENCES Produto(Codigo)
);

CREATE TABLE Estoque (
	CodigoProduto INT PRIMARY KEY,
	QtdEstoque INT DEFAULT(0),
	EstoqueMinimo INT DEFAULT(0),
	FOREIGN KEY(CodigoProduto) 
		REFERENCES Produto(Codigo)
); 

GO

CREATE TRIGGER trg_venda 
ON Venda
AFTER INSERT
AS
BEGIN
	DECLARE @CodigoProduto INT,
			@QuantidadeVendida INT,
			@QtdEstoque INT,
			@EstoqueMinimo INT;
	
	SELECT 
		@CodigoProduto = CodigoProduto,
		@QuantidadeVendida = Quantidade
	FROM 
		INSERTED;
	
	SELECT 
		@QtdEstoque = QtdEstoque,
		@EstoqueMinimo = EstoqueMinimo
	FROM 
		Estoque
	WHERE
		CodigoProduto = @CodigoProduto;
		
	IF @QuantidadeVendida > @QtdEstoque
	BEGIN
		ROLLBACK TRANSACTION;
		RAISERROR('Quantidade solicitada não está disponível em estoque', 16, 1);
	END
	ELSE
	BEGIN		
		IF @QtdEstoque < @EstoqueMinimo
			PRINT 'O estoque está abaixo do estoque mínimo determinado';
		ELSE
			IF @QtdEstoque - @QuantidadeVendida < @EstoqueMinimo
				PRINT 'Após a venda, a quantidade em estoque ficará abaixo do considerado mínimo';
		
		UPDATE 
			Estoque
		SET
			QtdEstoque = QtdEstoque - @QuantidadeVendida
		WHERE
			CodigoProduto = @CodigoProduto;
	END	
END

GO

CREATE FUNCTION udfNotaFiscal(
	@NotaFiscal CHAR(9)
) 
RETURNS TABLE
AS
RETURN
	SELECT 
		NotaFiscal,
		CodigoProduto,
		Descricao,
		ValorUnitario,
		Quantidade, 
		ValorUnitario * Quantidade AS ValorTotal
	FROM 
		Venda
	INNER JOIN Produto
		ON Venda.CodigoProduto = Produto.Codigo
	WHERE
		NotaFiscal = @NotaFiscal