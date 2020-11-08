-- Testa validação de cpf
DECLARE @result VARCHAR(20);

EXEC sp_validar_cpf
	@cpf = '49026059884', 
	@result = @result OUTPUT;

PRINT @result;


-- Testa inserção de um cadastro
EXEC sp_inserir_cadastro 
	@cpf = '49026059884', 
	@nome = 'Gustavo Alves Brito de Almeida',
	@rua = 'Rua Jacob Moysés José', 
	@numero = 262, 
	@cep = 08040340;

SELECT * FROM cadastro;