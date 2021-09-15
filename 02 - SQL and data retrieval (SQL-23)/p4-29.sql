create database название_базы_данных

create schema lecture_4_фамилия

set search_path to lecture_4

======================== Создание таблиц ========================
1. Создайте таблицу "автор" с полями:
- id 
- имя
- псевдоним (может не быть)
- дата рождения
- город рождения
- родной язык
* Используйте 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* для id подойдет serial, ограничение primary key
* Имя и дата рождения - not null
* город и язык - внешние ключи

create table author (
	author_id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	born_date date not null,
	city_id int2 --references city(city_id),
	--language_id int2 references language(language_id),
	create_date timestamp default now(),
	deleted int2 default 0 check(deleted in (1, 2))
)


1*  Создайте таблицы "Язык", "Город", "Страна".
* для id подойдет serial, ограничение primary key
* названия - not null и проверка на уникальность

create table language (
	language_id serial primary key,
	name varchar(50) not null unique,
	create_date timestamp default now(),
	deleted int2 default 0 check(deleted in (1, 2))
)

create table country (
	country_id serial primary key,
	"name" varchar(50) not null unique,
	create_date timestamp default now(),
	deleted int2 default 0 check(deleted in (1, 2))
)

create table city (
	city_id serial primary key,
	"name" varchar(50) not null unique ,
	country_id int2 --references country(country_id),
	create_date timestamp default now(),
	deleted int2 default 0 check(deleted in (1, 2))
)

======================== Заполнение таблицы ========================

2. Вставьте данные в таблицу с языками:
'Русский', 'Французский', 'Японский'
* Можно вставлять несколько строк одновременно:
    INSERT INTO table (column1, column2, …)
    VALUES
     (value1, value2, …),
     (value1, value2, …) ,...;

insert into language (name)
values ('Русский'),	('Французский'), ('Японский')

-- демонстрация работы счетчика и сброс счетчика
alter sequence books_id_seq restart with 5000;
	
2.1 Вставьте данные в таблицу со странами из таблиц country базы dvd-rental:

insert into country (name)
select country from "dvd-rental".country

2.2 Вставьте данные в таблицу с городами соблюдая связи из таблиц city базы dvd-rental:

insert into city (name, country_id)
select city, country_id from "dvd-rental".city

2.3 Вставьте данные в таблицу с авторами, идентификаторы языков и городов оставьте пустыми.
Жюль Верн, 08.02.1828
Михаил Лермонтов, 03.10.1814
Харуки Мураками, 12.01.1949

insert into author (first_name, last_name, born_date)
values ('Жюль Верн', '08.02.1828'),
	('Михаил Лермонтов', '03.10.1814'),
	('Харуки Мураками', '12.01.1949')


======================== Модификация таблицы ========================

3. Добавьте поле "идентификатор языка" в таблицу с авторами
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;

-- добавление нового столбца
alter table author add column language_id smallint

-- удаление столбца
alter table author drop column language_id 

-- добавление ограничения not null
alter table author alter column language_id set not null

-- удаление ограничения not null
alter table author alter column language_id drop not null

-- добавление ограничения unique
alter table author add constraint last_name_unique unique (last_name)

-- удаление ограничения unique
alter table author drop constraint last_name_unique 

-- изменение типа данных столбца
alter table author alter column last_name type text using last_name::text
 
 3* В таблице с авторами измените колонку language_id - внешний ключ - ссылка на языки
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table author add constraint language_author_fkey foreign key (language_id) references language(language_id)

alter table author drop constraint language_author_fkey 


 ======================== Модификация данных ========================

4. Обновите данные, проставив корректное языки писателям:
Жюль Габриэль Верн - Французский
Михаил Юрьевич Лермонтов - Российский
Харуки Мураками - Японский
* UPDATE table
  SET column1 = value1,
   column2 = value2 ,...
  WHERE
   condition;
  
select * from author a
  
update author
set language_id = 2
where id = 1

update author
set language_id = 1
where id = 2

update author
set language_id = 3
where id = 3


4*. Дополните оставшие связи по городам:

update author
set city_id = 2
where id = 1

update author
set city_id = 1
where id = 2

update author
set city_id = 3
where id = 3


 ======================== Удаление данных ========================
 
5. Удалите Лермонтова

update author
set deleted = 1 
where id = 2

delete from author 
where id = 2

5.1 Удалите все города

delete from city 

drop table author cascade

drop table books cascade

drop schema lecture_4

drop database название_базы

· film_name — array[The Shawshank Redemption, The Green Mile, Back to the Future, Forrest Gump, Schindler’s List];
· film_year — array[1994, 1999, 1985, 1994, 1993];
· film_rental_rate — array[2.99, 0.99, 1.99, 2.99, 3.99];
· film_duration — array[142, 189, 116, 142, 195].


insert into table_one


select unnest(array[1994, 1999, 1985, 1994, 1993]),
	unnest(array[142, 189, 116, 142, 195])
	
секционирование