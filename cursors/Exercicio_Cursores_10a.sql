--Exercício tirado de situação real.
/* A empresa tinha duas tabelas: Envio e Endereço, como listada abaixo.
No atributo NR_LINHA_ARQUIV, há um número que referencia a 
linha de incidência do endereço na tabela endereço.
Por exemplo: 

ENVIO:
|CPF		    |NR_LINHA_ARQUIV	|...
|11111111111	|1			        |
|11111111111	|2			        |

ENDEREÇO:
|CPF			|CEP		|PORTA	|ENDEREÇO	|COMPLEMENTO		|BAIRRO			|CIDADE			|UF	|
|11111111111	|11111111	|10		|Rua A		|					|Pq A			|São Paulo		|SP	|
|11111111111	|22222222	|125	|Rua B		|					|Pq B			|São Paulo		|SP	|

Portanto, o NR_LINHA_ARQUIV (1) referencia o registro do endereço da Rua A e o NR_LINHA_ARQUIV (2) 
referencia o endereço da Rua B.

Como se trata de uma estrutura completamente mal feita, o DBA solicitou
que se colcasse as colunas NM_ENDERECO, NR_ENDERECO, NM_COMPLEMENTO, NM_BAIRRO, NR_CEP,
NM_CIDADE, NM_UF varchar(2) e movesse os dados da tabela endereço para a tabela envio.

Fazer uma PROCEDURE, com cursor, que resolva esse problema
*/

create database correio;
go
use correio;

create table envio (
	CPF varchar(20),
	NR_LINHA_ARQUIV	int,
	CD_FILIAL int,
	DT_ENVIO datetime,
	NR_DDD int,
	NR_TELEFONE	varchar(10),
	NR_RAMAL varchar(10),
	DT_PROCESSAMENT	datetime,
	NM_ENDERECO varchar(200),
	NR_ENDERECO int,
	NM_COMPLEMENTO	varchar(50),
	NM_BAIRRO varchar(100),
	NR_CEP varchar(10),
	NM_CIDADE varchar(100),
	NM_UF varchar(2)
);

create table endereço (
	CPF varchar(20),
	CEP	varchar(10),
	PORTA	int,
	ENDEREÇO	varchar(200),
	COMPLEMENTO	varchar(100),
	BAIRRO	varchar(100),
	CIDADE	varchar(100),
	UF varchar(2)
);

GO

/*
Por se tratar de dados confidenciais, a procedure abaixo foi feita para se criar
dados fictícios nas tabelas
*/

create procedure sp_insereenvio
as
begin
	declare @cpf as int
	declare @cont1 as int
	declare @cont2 as int
	declare @conttotal as int
	set @cpf = 11111
	set @cont1 = 1
	set @cont2 = 1
	set @conttotal = 1
	while @cont1 <= @cont2 and @cont2 < = 100
	begin
		insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
			values (cast(@cpf as varchar(20)), @cont1, GETDATE())
		insert into endereço (CPF,PORTA,ENDEREÇO)
			values (@cpf,@conttotal,CAST(@cont2 as varchar(3)) + 'Rua ' + CAST(@conttotal as varchar(5)))
		set @cont1 = @cont1 + 1
		set @conttotal = @conttotal + 1
		if @cont1 > = @cont2
		begin
			set @cont1 = 1
			set @cont2 = @cont2 + 1
			set @cpf = @cpf + 1
		end;
	end
end;

exec sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc


-- MINHA SOLUÇÃO
GO

CREATE PROCEDURE usp_fix_envio
AS
BEGIN
	DECLARE @CEP CHAR(8),
				@PORTA INT,
				@ENDERECO VARCHAR(200),
				@COMPLEMENTO VARCHAR(100),
				@BAIRRO VARCHAR(100),
				@CIDADE VARCHAR(100),
				@UF VARCHAR(2);

	DECLARE cursor_endereco CURSOR SCROLL
		FOR SELECT
				CEP,
				PORTA,
				ENDEREÇO,
				COMPLEMENTO,
				BAIRRO,
				CIDADE,
				UF
			FROM
				endereço;

	OPEN cursor_endereco;

	DECLARE @CPF VARCHAR(20),
			@NR_LINHA_ARQUIV INT;

	DECLARE cursor_envio CURSOR
	FOR SELECT
			CPF,
			NR_LINHA_ARQUIV
		FROM
			envio;

	OPEN cursor_envio;

	FETCH NEXT FROM cursor_envio INTO
		@CPF,
		@NR_LINHA_ARQUIV;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @numero_linha INT = 1;

		FETCH FIRST FROM cursor_endereco 
			INTO
				@CEP,
				@PORTA,
				@ENDERECO,
				@COMPLEMENTO,
				@BAIRRO,
				@CIDADE,
				@UF;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @numero_linha = @NR_LINHA_ARQUIV
			BEGIN
				UPDATE envio 
				SET NM_ENDERECO = @ENDERECO, NR_ENDERECO = @PORTA, 
					NM_COMPLEMENTO = @COMPLEMENTO, 
					NM_BAIRRO = @BAIRRO, NR_CEP = @CEP,
					NM_CIDADE = @CIDADE, NM_UF = @UF
				WHERE
					CPF = @CPF AND NR_LINHA_ARQUIV = @numero_linha;
				
				BREAK;
			END;
			ELSE
			BEGIN
				SET @numero_linha = @numero_linha + 1;

				FETCH NEXT FROM cursor_endereco INTO
					@CEP,
					@PORTA,
					@ENDERECO,
					@COMPLEMENTO,
					@BAIRRO,
					@CIDADE,
					@UF;
			END;
		END;

		FETCH NEXT FROM cursor_envio INTO
			@CPF,
			@NR_LINHA_ARQUIV;
	END;

	CLOSE cursor_envio;
	DEALLOCATE cursor_envio;

	CLOSE cursor_endereco;
	DEALLOCATE cursor_endereco;
END;

EXEC usp_fix_envio;