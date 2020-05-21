CREATE DATABASE projectsUsers
GO
USE projectsUsers

CREATE TABLE projects (
	id INT IDENTITY(10001, 1) PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	description VARCHAR(45),
	date DATE CHECK(date > '01/09/2014')
)

CREATE TABLE users (
	id INT IDENTITY PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	username VARCHAR(45),
	password VARCHAR(45) DEFAULT('123mudar'),
	email VARCHAR(45)  NOT NULL,
	CONSTRAINT unique_username UNIQUE(username)
)

CREATE TABLE users_has_projects (
	users_id INT NOT NULL,
	projects_id INT NOT NULL,
	PRIMARY KEY (users_id, projects_id),
	FOREIGN KEY (users_id) REFERENCES users (id),
	FOREIGN KEY (projects_id) REFERENCES projects (id)
)

ALTER TABLE users 
DROP CONSTRAINT unique_username

ALTER TABLE users
ALTER COLUMN username VARCHAR(10)

ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE(username)

ALTER TABLE users
ALTER COLUMN password VARCHAR(8)

INSERT INTO users (name, username, email)
VALUES
	('Maria', 'Rh_maria', 'maria@empresa.com'),
	('Ana', 'Rh_ana', 'ana@empresa.com'),
	('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users 
VALUES
	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
	('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects 
VALUES
	('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
	('Manutenção PC''s', 'Manutençao PC''s', '06/09/2014'),
	('Auditoria', null, '07/09/2014')

INSERT INTO users_has_projects 
VALUES
	(1, 10001),
	(5, 10001),
	(3, 10003),
	(4, 10002),
	(2, 10002) 

UPDATE projects
SET date = '12/09/2014'
WHERE id = 10002

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'

DELETE FROM users_has_projects
WHERE users_id = 2 AND projects_id = 10002

ALTER TABLE projects
ADD budget DECIMAL(7, 2) NULL

UPDATE projects
SET budget = 5450
WHERE id = 10001

UPDATE projects
SET budget = 7850
WHERE id = 10002

UPDATE projects
SET budget = 9530
WHERE id = 10003

SELECT username, password 
FROM users
WHERE id = 2

SELECT name, budget, budget * 1.15 AS bonus_budget
FROM projects

SELECT id, name, email
FROM users
WHERE password = '123mudar'

SELECT id, name
FROM projects
WHERE budget > 2000 AND budget < 8000
