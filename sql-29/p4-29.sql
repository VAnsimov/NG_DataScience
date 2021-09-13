create database ��������_����_������

create schema lecture_4_�������

set search_path to lecture_4

======================== �������� ������ ========================
1. �������� ������� "�����" � ������:
- id 
- ���
- ��������� (����� �� ����)
- ���� ��������
- ����� ��������
- ������ ����
* ����������� 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* ��� id �������� serial, ����������� primary key
* ��� � ���� �������� - not null
* ����� � ���� - ������� �����

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


1*  �������� ������� "����", "�����", "������".
* ��� id �������� serial, ����������� primary key
* �������� - not null � �������� �� ������������

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

======================== ���������� ������� ========================

2. �������� ������ � ������� � �������:
'�������', '�����������', '��������'
* ����� ��������� ��������� ����� ������������:
    INSERT INTO table (column1, column2, �)
    VALUES
     (value1, value2, �),
     (value1, value2, �) ,...;

insert into language (name)
values ('�������'),	('�����������'), ('��������')

-- ������������ ������ �������� � ����� ��������
alter sequence books_id_seq restart with 5000;
	
2.1 �������� ������ � ������� �� �������� �� ������ country ���� dvd-rental:

insert into country (name)
select country from "dvd-rental".country

2.2 �������� ������ � ������� � �������� �������� ����� �� ������ city ���� dvd-rental:

insert into city (name, country_id)
select city, country_id from "dvd-rental".city

2.3 �������� ������ � ������� � ��������, �������������� ������ � ������� �������� �������.
���� ����, 08.02.1828
������ ���������, 03.10.1814
������ ��������, 12.01.1949

insert into author (first_name, last_name, born_date)
values ('���� ����', '08.02.1828'),
	('������ ���������', '03.10.1814'),
	('������ ��������', '12.01.1949')


======================== ����������� ������� ========================

3. �������� ���� "������������� �����" � ������� � ��������
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;

-- ���������� ������ �������
alter table author add column language_id smallint

-- �������� �������
alter table author drop column language_id 

-- ���������� ����������� not null
alter table author alter column language_id set not null

-- �������� ����������� not null
alter table author alter column language_id drop not null

-- ���������� ����������� unique
alter table author add constraint last_name_unique unique (last_name)

-- �������� ����������� unique
alter table author drop constraint last_name_unique 

-- ��������� ���� ������ �������
alter table author alter column last_name type text using last_name::text
 
 3* � ������� � �������� �������� ������� language_id - ������� ���� - ������ �� �����
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table author add constraint language_author_fkey foreign key (language_id) references language(language_id)

alter table author drop constraint language_author_fkey 


 ======================== ����������� ������ ========================

4. �������� ������, ��������� ���������� ����� ���������:
���� �������� ���� - �����������
������ ������� ��������� - ����������
������ �������� - ��������
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


4*. ��������� �������� ����� �� �������:

update author
set city_id = 2
where id = 1

update author
set city_id = 1
where id = 2

update author
set city_id = 3
where id = 3


 ======================== �������� ������ ========================
 
5. ������� ����������

update author
set deleted = 1 
where id = 2

delete from author 
where id = 2

5.1 ������� ��� ������

delete from city 

drop table author cascade

drop table books cascade

drop schema lecture_4

drop database ��������_����

� film_name � array[The Shawshank Redemption, The Green Mile, Back to the Future, Forrest Gump, Schindler�s List];
� film_year � array[1994, 1999, 1985, 1994, 1993];
� film_rental_rate � array[2.99, 0.99, 1.99, 2.99, 3.99];
� film_duration � array[142, 189, 116, 142, 195].


insert into table_one


select unnest(array[1994, 1999, 1985, 1994, 1993]),
	unnest(array[142, 189, 116, 142, 195])
	
���������������