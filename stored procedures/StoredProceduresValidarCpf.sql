/* 
1) Criar um database, fazer uma tabela cadastro (cpf, nome, rua, numero e cep) 
com uma procedure que só permitirá a inserção dos dados se o CPF for válido, 
caso contrário retornar uma mensagem de erro.
*/

CREATE DATABASE cadastrodb;
GO
USE cadastrodb;

CREATE TABLE cadastro (
	cpf CHAR(11) PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	rua VARCHAR(255),
	numero INT,
	cep CHAR(8)
);

GO 

CREATE PROC sp_inserir_cadastro (
	@cpf CHAR(11),
	@nome VARCHAR(255),
	@rua VARCHAR(255),
	@numero INT,
	@cep CHAR(8)
) AS 
BEGIN
	DECLARE @result VARCHAR(20);

	EXEC sp_validar_cpf 
		@cpf = @cpf, 
		@result = @result OUTPUT;

	IF @result = 'Válido'
	BEGIN
		INSERT INTO cadastro 
		VALUES(@cpf, @nome, @rua, @numero, @cep);
	END
	ELSE
	BEGIN
		RAISERROR('Não foi possível realizar o cadastro. CPF inválido.', 16, 1);
	END
END;

GO 

CREATE PROC sp_validar_cpf (
	@cpf CHAR(11), 
	@result VARCHAR(20) OUTPUT
) AS
BEGIN
	DECLARE @cpf_aux VARCHAR(11),
			@cpf_index SMALLINT,
			@digito SMALLINT,
			@valor_definido SMALLINT,
			@total INT,
			@resto SMALLINT,
			@digito_verificador1 SMALLINT,
			@digito_verificador2 SMALLINT;

	IF LEN(@cpf) != 11
		SET @result = 'Inválido';
	ELSE
	BEGIN
		DECLARE @total_digitos_repetidos SMALLINT = 0;

		SET @cpf_index = 0;
		SET @digito = CAST(SUBSTRING(@cpf, 1, 1) AS SMALLINT);
		SET @cpf_aux = '';

		WHILE @cpf_index < 11
		BEGIN
			SET @cpf_aux = @cpf_aux + CAST(@digito AS VARCHAR(1));
			SET @cpf_index = @cpf_index + 1;
		END

		IF @cpf = @cpf_aux
			SET @result = 'Inválido'
		ELSE
		BEGIN 
			-- Calcula o primeiro dígito verificador
			SET @cpf_aux = SUBSTRING(@cpf, 1, 9);
			SET @cpf_index = LEN(@cpf_aux);
			SET @valor_definido = 2;
			SET @total = 0;

			WHILE @cpf_index >= 1
			BEGIN
				SET @digito = CAST(SUBSTRING(@cpf, @cpf_index, 1) AS SMALLINT);

				SET @total = @total + @digito * @valor_definido;

				SET @cpf_index = @cpf_index - 1;
				SET @valor_definido = @valor_definido + 1;
			END

			SET @resto = @total % 11;

			IF @resto < 2
			BEGIN
				SET @digito_verificador1 = 0
			END
			ELSE
			BEGIN
				SET @digito_verificador1 = 11 - @resto;
			END

			-- Calcula o segundo dígito verificador
			SET @cpf_aux = @cpf_aux + CAST(@digito_verificador1 AS CHAR(1));

			SET @cpf_index = LEN(@cpf_aux);
			SET @valor_definido = 2;
			SET @total = 0;

			WHILE @cpf_index >= 1
			BEGIN
				SET @digito = CAST(SUBSTRING(@cpf, @cpf_index, 1) AS SMALLINT);

				SET @total = @total + @digito * @valor_definido;

				SET @cpf_index = @cpf_index - 1;
				SET @valor_definido = @valor_definido + 1;
			END

			SET @resto = @total % 11;

			IF @resto < 2
			BEGIN
				SET @digito_verificador2 = 0
			END
			ELSE
			BEGIN
				SET @digito_verificador2 = 11 - @resto;
			END

			SET @cpf_aux = @cpf_aux + CAST(@digito_verificador2 AS CHAR(1))

			IF @cpf = @cpf_aux
				SET @result = 'Válido'
			ELSE
				SET @result = 'Inválido'
		END
	END
END

GO