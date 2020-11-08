/*
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                                                                    

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.
*/

USE master;
CREATE DATABASE academia;
GO
USE academia;

CREATE TABLE aluno (
	codigo INT IDENTITY PRIMARY KEY,
	nome VARCHAR(100) NOT NULL
);

CREATE TABLE atividade (
	codigo INT PRIMARY KEY ,
	descricao VARCHAR(255) NOT NULL,
	imc DECIMAL(4, 2) NOT NULL
);

CREATE TABLE atividade_aluno (
	codigo_aluno INT,
	codigo_atividade INT,
	peso DECIMAL(4, 2),
	altura DECIMAL(4, 2),
	imc DECIMAL(4, 2),
	PRIMARY KEY (codigo_aluno, codigo_atividade),
	FOREIGN KEY (codigo_aluno) REFERENCES aluno(codigo),
	FOREIGN KEY (codigo_atividade) REFERENCES atividade(codigo)
);

INSERT INTO atividade 
VALUES
	(1, 'Corrida + Step', 18.5),
	(2, 'Biceps + Costas + Pernas', 24.9),
	(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
	(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
	(5, 'Esteira + Bicicleta', 39.9);

SELECT * FROM atividade;

GO


/*
Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/
CREATE PROC sp_alunoatividades (
	@codigo INT = NULL,
	@nome VARCHAR(100),
	@peso DECIMAL,
	@altura DECIMAL,
	@result VARCHAR(10) OUTPUT
) AS
BEGIN
	DECLARE @imc DECIMAL = @peso * POWER(@altura, 2);

	IF @codigo IS NULL
	BEGIN
		INSERT INTO aluno(nome)
		VALUES(@nome);

		INSERT INTO atividade_aluno(altura, peso, imc)
		VALUES(@altura, @peso, @imc);
	END
	ELSE
	BEGIN
		DECLARE @x INT = (
			SELECT 
				COUNT(*)
			FROM
				aluno
			WHERE
				aluno.codigo = @codigo)

		IF @x = 0
			RAISERROR('Código inválido', 16, 1);
		ELSE
		BEGIN
			DECLARE @codigo_atividade INT = (
				SELECT TOP 1
					codigo
				FROM
					atividade
				WHERE
					imc > @imc)

			UPDATE 
				atividade_aluno
			SET 
				peso = @peso,
				altura = @altura,
				imc = @imc,
				codigo_atividade = @codigo_atividade
			WHERE
				codigo_aluno = @codigo;
		END
	END
END;
