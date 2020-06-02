INSERT INTO users
	VALUES('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO projects
	VALUES('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '12/09/2014')

SELECT 
	users.id, 
	users.name, 
	users.email,
	projects.id,
	projects.name,
	projects.description,
	projects.date
FROM 
	users, projects, users_has_projects
WHERE 
	users.id = users_has_projects.users_id AND
	projects.id = users_has_projects.projects_id AND
	projects.name = 'Re-folha' 


SELECT 
	projects.name
FROM 
	projects LEFT OUTER JOIN users_has_projects
		ON projects.id = users_has_projects.projects_id 
WHERE 
	users_has_projects.projects_id IS NULL


SELECT 
	users.name
FROM
	users LEFT JOIN users_has_projects
		ON users.id = users_has_projects.users_id
WHERE
	users_has_projects.users_id IS NULL
