use selects

-- Exercícios

-- Nomes completos dos Funcionários que estão no
-- projeto Modificação do Módulo de Cadastro.
SELECT 
	nome + ' ' + sobrenome AS nome_completo
FROM 
	funcionario 
WHERE 
	id IN
	(
		SELECT 
			id_funcionario 
		FROM 
			funcproj 
		WHERE 
			codigo_projeto IN 
			(SELECT 
				codigo 
			FROM 
				projeto 
			WHERE 
				nome = 'Modificação do módulo de cadastro'))


-- Nomes completos e Idade, em anos (considere se fez ou ainda fará
-- aniversário esse ano), dos funcionários.
SELECT 
	nome + ' ' + sobrenome AS nome_completo,
	CONVERT(INT, DATEDIFF(DAY, data_nasc, GETDATE()) / 365.25) AS idade
FROM 
	funcionario