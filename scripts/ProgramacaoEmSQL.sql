/*
Fazer um algoritmo que calcule os 15 primeiros termos da s�rie de Fibonacci 
e a soma dos 15 primeiros termos
*/
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


-- Fazer um algoritmo que, dado 1 n�mero, mostre se � m�ltiplo de 2,3,5 ou nenhum deles 


-- Fazer um algoritmo que, dados 3 n�meros, mostre o maior e o menor
DECLARE @number1 INT = 1,
		@number2 INT = 2,
		@number3 INT = 2,
		@maior INT,
		@menor INT;

SET @menor = @number1;

IF @number2 < @menor
BEGIN
	SET @menor = @number2
END

IF @number3 < @menor
BEGIN
	SET @menor = @number3
END

SET @maior = @number1

IF @number2 > @maior
BEGIN
	SET @maior = @number2
END

IF @number3 > @maior
BEGIN
	SET @maior = @number3
END

PRINT 'Maior = ' + CAST(@maior AS VARCHAR(20));
PRINT 'Menor = ' + CAST(@menor AS VARCHAR(20));


/*
Fazer um algoritmo que separa uma frase, imprimindo todas as letras 
em mai�sculo e, depois imprimindo todas em min�sculo
*/

-- Fazer um algoritmo que verifica, dada uma palavra, se �, ou n�o, pal�ndromo
DECLARE @counter INT = 1,
		@word VARCHAR(MAX) = 'aabaa',
		@reversedWord VARCHAR(MAX) = '';

WHILE @counter <= LEN(@word)
BEGIN
	
	SET @reversedWord = SUBSTRING(@word, @counter, 1) + @reversedWord;
	SET @counter = @counter + 1
END

IF @reversedWorD = @word
BEGIN
	PRINT @word + ' � pal�ndromo';
END
ELSE
BEGIN
	PRINT @word + ' n�o � pal�dromo';
END


-- Fazer um algoritmo que, dado um CPF diga se � v�lido
