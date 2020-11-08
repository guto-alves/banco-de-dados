/*
Fazer um algoritmo que calcule os 15 primeiros termos da s�rie de Fibonacci 
e a soma dos 15 primeiros termos
*/
BEGIN
	DECLARE @count INT = 1,
			@previous INT = 0,
			@current INT = 1,
			@temp INT = 0,
			@sum INT = 0;

	WHILE @count <= 15
	BEGIN
		PRINT CAST(@count AS VARCHAR(2)) + '� = ' + CAST(@current AS VARCHAR(MAX));

		SET @sum = @sum + @current;

		SET @temp = @current;
		SET @current = @current + @previous;
		SET @previous = @temp;

		SET @count = @count + 1;
	END

	PRINT 'Sum is ' + CAST(@sum AS VARCHAR(MAX));
END


/* Fazer um algoritmo que, dado 1 n�mero, mostre se � m�ltiplo de 2,3,5 ou nenhum deles */
BEGIN
	DECLARE @number INT = 1,
			@total_multiplos SMALLINT = 0;

	IF @number % 2 = 0
	BEGIN
		PRINT '� m�ltiplo de 2';
		SET @total_multiplos  = @total_multiplos  + 1;
	END

	IF @number % 3 = 0
	BEGIN
		PRINT '� m�ltiplo de 3';
		SET @total_multiplos  = @total_multiplos  + 1;
	END

	IF @number % 5 = 0
	BEGIN
		PRINT '� m�ltiplo de 5';
		SET @total_multiplos  = @total_multiplos  + 1;
	END
	
	IF @total_multiplos  = 0
		PRINT 'N�o � m�ltiplo de 2, 3, nem 5';
END


/* Fazer um algoritmo que, dados 3 n�meros, mostre o maior e o menor */
BEGIN
	DECLARE @number1 INT = 3,
			@number2 INT = 1,
			@number3 INT = 2,
			@min INT,
			@max INT;

	SET @min = @number1;

	IF @number2 < @min
		SET @min = @number2

	IF @number3 < @min
		SET @min = @number3

	SET @max = @number1

	IF @number2 > @max
		SET @max = @number2

	IF @number3 > @max
		SET @max = @number3

	PRINT 'Menor = ' + CONVERT(CHAR, @min);
	PRINT 'Maior = ' + CONVERT(CHAR, @max);
END


/*
Fazer um algoritmo que separa uma frase, imprimindo todas as letras 
em mai�sculo e, depois imprimindo todas em min�sculo
*/
BEGIN
	DECLARE @phrase VARCHAR(50) = 'Hello World!',
			@i INT = 0;

	WHILE(@i <= LEN(@phrase))
	BEGIN
		SET @i = @i + 1
		PRINT UPPER(SUBSTRING(@phrase, @i, 1))
	END

	SET @i= 0

	WHILE(@i <= LEN(@phrase))
	BEGIN
		SET @i = @i + 1
		PRINT LOWER(SUBSTRING(@phrase, @i, 1))
	END
END


/* Fazer um algoritmo que verifica, dada uma palavra, se �, ou n�o, pal�ndromo */
BEGIN
	DECLARE @counter INT = 1,
			@word VARCHAR(MAX) = 'aabaa',
			@reversedWord VARCHAR(MAX) = '';

	WHILE @counter <= LEN(@word)
	BEGIN
		SET @reversedWord = SUBSTRING(@word, @counter, 1) + @reversedWord;
		SET @counter = @counter + 1
	END

	IF @reversedWorD = @word
		PRINT @word + ' � pal�ndromo!';
	ELSE
		PRINT @word + ' n�o � pal�dromo!';
END


/* Fazer um algoritmo que, dado um CPF diga se � v�lido */
BEGIN
	DECLARE @cpf CHAR(11) = '22233366638',
			@cpf_aux VARCHAR(11),
			@cpf_index SMALLINT,
			@digito SMALLINT,
			@valor_definido SMALLINT,
			@total INT,
			@resto SMALLINT,
			@digito_verificador1 SMALLINT,
			@digito_verificador2 SMALLINT;

	IF LEN(@cpf) != 11
		PRINT 'Inv�lido'
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
			PRINT 'Inv�lido'
		ELSE
		BEGIN 
			-- Calcula o primeiro d�gito verificador
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

			-- Calcula o segundo d�gito verificador
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
				PRINT 'V�lido'
			ELSE
				PRINT 'Inv�lido'
		END
	END
END