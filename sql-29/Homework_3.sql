
/*
Задание 1. Спроектируйте базу данных для следующих сущностей:
· язык (английский, французский и т. п.);
· народность (славяне, англосаксы и т. п.);
· страны (Россия, Германия и т. п.).

Правила следующие:
· на одном языке могут говорить несколько народностей;
· одна народность может проживать в нескольких странах;
· в каждой стране могут проживать нескольких народностей.

Таким образом должно получиться 5 таблиц: 3 таблицы-справочника и 2 таблицы со связями (пример таблицы со связями — film_actor).

Требования к таблицам-справочникам:
· идентификатор сущности должен присваиваться автоинкрементом;
· наименования сущностей не должны содержать null-значения, не должны допускаться дубликаты в названиях сущностей.
*/




/* Таблица: Народность */

CREATE TABLE nationality (
nationality_id serial PRIMARY KEY,
"name" VARCHAR(127) NOT NULL UNIQUE,
last_update TIMESTAMP DEFAULT NOW()
);

INSERT INTO nationality ("name")
VALUES
('галисийцы'),
('португальцы'),
('англичане'),
('французы'),
('итальянцы'),
('славяне'),
('америанцы'),
('немцы')



/* Таблица: Язык */

CREATE TABLE "language" (
language_id serial PRIMARY KEY,
"name" VARCHAR(127) NOT NULL UNIQUE,
last_update TIMESTAMP DEFAULT NOW()
);

INSERT INTO "language"("name")
VALUES
('английский'),
('французский'),
('русский'),
('итальянский'),
('испанский')
  


/* Таблица: Страна */

CREATE TABLE country (
country_id serial PRIMARY KEY,
"name" VARCHAR(127) NOT NULL UNIQUE,
last_update TIMESTAMP DEFAULT NOW()
);

INSERT INTO country ("name")
VALUES
('Канада'),
('Франция'),
('Русский'),
('Италия'),
('Америка'),
('Испания')



/* Таблица: Язык и Народность */

CREATE TABLE language_nationality (
nationality_id INTEGER NOT NULL,
language_id INTEGER NOT NULL,
last_update TIMESTAMP DEFAULT NOW(),
PRIMARY KEY(nationality_id, language_id),
FOREIGN KEY (nationality_id) REFERENCES nationality(nationality_id),
FOREIGN KEY (language_id) REFERENCES "language"(language_id)
);

INSERT INTO language_nationality (language_id, nationality_id)
SELECT l.language_id, n.nationality_id
  FROM "language" AS l
  LEFT JOIN nationality AS n ON CASE 
  									 WHEN (l.language_id = 1  AND n.nationality_id = 3)
  									   OR (l.language_id = 1  AND n.nationality_id = 7) THEN TRUE
  									 WHEN l.language_id = 2  AND n.nationality_id = 4 THEN TRUE
  									 WHEN l.language_id = 3  AND n.nationality_id = 6 THEN TRUE
  									 WHEN l.language_id = 4  AND n.nationality_id = 5 THEN TRUE
  									 WHEN (l.language_id = 5  AND n.nationality_id = 1)
  									   OR (l.language_id = 5  AND n.nationality_id = 2) THEN TRUE
  								ELSE FALSE
	   							END

	   						
	   							
/* Таблица: Народность и Страна */
  
CREATE TABLE nationality_country (
nationality_id INTEGER NOT NULL,
country_id INTEGER NOT NULL,
last_update TIMESTAMP DEFAULT NOW(),
PRIMARY KEY(nationality_id, country_id),
FOREIGN KEY (nationality_id) REFERENCES nationality(nationality_id),
FOREIGN KEY (country_id) REFERENCES country(country_id)
);

INSERT INTO nationality_country (country_id, nationality_id)
SELECT с.country_id, n.nationality_id
  FROM country AS с
  LEFT JOIN nationality AS n ON CASE 
  									 WHEN (с.country_id = 1  AND n.nationality_id = 3)
  									   OR (с.country_id = 1  AND n.nationality_id = 4)
  									   OR (с.country_id = 1  AND n.nationality_id = 7) THEN TRUE
  									 WHEN с.country_id = 2  AND n.nationality_id = 4 THEN TRUE
  									 WHEN с.country_id = 3  AND n.nationality_id = 6 THEN TRUE
  									 WHEN с.country_id = 4  AND n.nationality_id = 5 THEN TRUE
  									 WHEN с.country_id = 5  AND n.nationality_id = 7 THEN TRUE
  									 WHEN (с.country_id = 6  AND n.nationality_id = 1)
  									   OR (с.country_id = 6  AND n.nationality_id = 2)
  									   OR (с.country_id = 6  AND n.nationality_id = 5)  THEN TRUE
  								ELSE FALSE
	   							END

	   							
	   							
/* Выборки */

SELECT l.language_id AS "Язык ID",
       n.nationality_id AS "Народность ID",
       l."name" AS "Язык",
       n."name" AS "Народность"
  FROM language_nationality
  LEFT JOIN "language" AS l USING(language_id)
  LEFT JOIN nationality AS n USING(nationality_id)
  
  
SELECT n.nationality_id AS "Народность ID",
	   c.country_id AS "Страна ID",
	   n."name" AS "Народность",
       c."name" AS "Страна"
  FROM nationality_country
  LEFT JOIN country AS c USING(country_id)
  LEFT JOIN nationality AS n USING(nationality_id)
 ORDER BY n.nationality_id
