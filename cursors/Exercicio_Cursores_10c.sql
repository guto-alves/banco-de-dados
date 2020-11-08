/*
Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor, 
monte uma tabela de saída com as informações do curso que é parâmetro de entrada.

(Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)
*/

CREATE FUNCTION udf_curso(@codigo_curso INT)
	RETURNS @disciplinas TABLE (
		codigo_disciplina INT,
		nome_disciplina VARCHAR(100),
		carga_horaria_disciplina INT,
		nome_curso VARCHAR(100)
	)
AS
BEGIN
	DECLARE @codigo_disciplina INT,
		@nome_disciplina VARCHAR(100),
		@carga_horaria_disciplina INT, 
		@nome_curso VARCHAR(100);
		
		DECLARE c CURSOR
		FOR SELECT 
				disciplina.codigo,
				disciplina.nome,
				disciplina.carga_horaria,
				curso.nome
			FROM 
				curso
			INNER JOIN disciplina_curso
				ON curso.codigo = disciplina_curso.codigo_curso
			INNER JOIN disciplina
				ON disciplina.codigo = disciplina_curso.codigo_disciplina
			WHERE
				curso.codigo = @codigo_curso;

		OPEN c;

		FETCH NEXT FROM c INTO 
			@codigo_disciplina,
			@nome_disciplina,
			@carga_horaria_disciplina,
			@nome_curso;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @disciplinas
				VALUES
					(@codigo_disciplina,
					@nome_disciplina,
					@carga_horaria_disciplina,
					@nome_curso);

			FETCH NEXT FROM c INTO 
				@codigo_disciplina,
				@nome_disciplina,
				@carga_horaria_disciplina,
				@nome_curso;
		END;

		CLOSE c;
		DEALLOCATE c;
		RETURN;
END;