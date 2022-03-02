============= ������ =============

create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five')

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight')

select * from table_one

select * from table_two

--left, right, inner, full outer, cross

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select count(c.customer_id)
from customer c 
inner join address a on a.address_id = c.address_id

select count(c.customer_id)
from customer c 
left join address a on a.address_id = c.address_id

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select 
from t1 
right join ( 
	select ... 
	from t2 
	right join (select ... from ... where)
	where ...)

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1
cross join table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2
where t1.name_one = t2.name_two 

delete from table_one;
delete from table_two;

insert into table_one (name_one)
select unnest(array[1,1,2])

insert into table_two (name_two)
select unnest(array[1,1,3])

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

1a	1A	1AA
1b	1B	1BB
2	3	4

1a-1A-1AA
1a-1B
1b-1A
1b-1B

-- 5 ���������� �����

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two

cross join -> inner join -> left/right -> full join

select 1 as x, 1 as y
union distinct
select 1 as x, 1 as y

select 1 as x, 1 as y
union all
select 1 as x, 1 as y

select 1 as x, 1 as y
union 
select 1 as x, 1 as y
union
select 1 as x, 1 as y
union all
select 1 as x, 1 as y
union distinct
select 1 as x, 1 as y
union all
select 1 as x, 1 as y

select 1 as x, 1 as y
except 
select 1 as x, 1 as y

select 1 as x, 1 as y
except 
select 1 as x, 2 as y

select 1 as x, 1 as y
union all
select 1 as x, 1 as y
except 
select 1 as x, 1 as y

select concat(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select coalesce(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select coalesce(null, null, 6, 5)

select 
	case
		when t1.name_one is null then t2.name_two
		when t1.name_one is not null then t2.name_two
		when t1.name_one = 'one' then '��� ����'
		else '���-�� ����� �� ���'
	end
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select 
	count(case when f.film_id = 384 then 1 else null end),
	count(case when f.film_id = 400 then 1 else null end),
	count(case when f.film_id = 1 then 1 else null end)
from film f
join film_actor fa on fa.film_id = f.film_id

select count(1) filter (where f.film_id = 384),
	count(1) filter (where f.film_id = 400),
	count(1) filter (where f.film_id = 1)
from film f
join film_actor fa on fa.film_id = f.film_id

============= ���������� =============

1. �������� ������ �������� ���� ������� � �� ������ (������� language)
* ����������� ������� film
* ��������� � language
* �������� ���������� � �������:
title, language."name"

select f.title, l."name"
from film f
join "language" l on l.language_id = f.language_id

1.1 �������� ��� ������ � �� ���������:
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* ��������� ��������� �������� using

explain analyze
select f.title, c."name"
from film f
join film_category fc using(film_id)
join category c using(category_id)

2. �������� ������ ���� �������, ����������� � ������ Lambs Cincinatti (film_id = 508). 
* ����������� ������� film
* ��������� � film_actor
* ��������� � actor
* ������������, ��������� where � "title like" (��� ��������) ��� "film_id =" (��� id)

select f.title, a.last_name
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 508

2. �������� ���������� ������ �������, ������� ����� � ������ '24-05-2005'. 
* ����������� ������� film
* ��������� � inventory
* ��������� � rental
* ������������, ��������� where � "rental_date"

select distinct f.title
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
where rental_date::date = '24/05/2005'

2.1 �������� ��� �������� �� ������ Woodridge (city_id = 576)
* ����������� ������� store
* ��������� ������� � address 
* ��������� ������� � city 
* ��������� ������� � country 
* ������������ �� "city_id"
* �������� ������ ����� ������� ��������� � �� id:
store_id, postal_code, country, city, district, address, address2, phone

select store_id, postal_code, country, city, district, address, address2, phone
from store s
left join address a on a.address_id = s.address_id
left join city c on c.city_id = a.city_id
left join country c2 on c2.country_id = c.country_id
where c.city_id = 576

============= ���������� ������� =============

3. ����������� ���������� ������� � ������ Grosse Wonderful (id - 384)
* ����������� ������� film
* ��������� � film_actor
* ������������, ��������� where � "film_id" 
* ��� �������� ����������� ������� count, ����������� actor_id � �������� ��������� ������ �������
* ��������� ����������� �����������

select count(fa.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
where f.film_id = 384

select count(1)
from film f
join film_actor fa on fa.film_id = f.film_id
where f.film_id = 384

select count(1) filter (where f.film_id = 384),
	count(1) filter (where f.film_id = 400),
	count(1) filter (where f.film_id = 1)
from film f
join film_actor fa on fa.film_id = f.film_id

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.title, f.description, f.release_year -- �����

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.film_id -- ������

-- ������� ���������� 

select count(fa.actor_id), f.rating, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.rating, f.release_year -- ������, ��� ��� �����

select count(fa.actor_id), f.title, f.description, a.last_name, a.first_name
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id

3.1 ���������� ������� ��������� ������ �� ���� �� ���� �������
* ����������� ������� film
* ��������� ������ �� ���� rental_rate/rental_duration
* avg - �������, ����������� ������� ��������
--4 ���������

select round(avg(rental_rate/rental_duration), 2),
	max(rental_rate/rental_duration),
	min(rental_rate/rental_duration),
	sum(rental_rate/rental_duration)
from film 

select * 
from film f
where rental_rate is null

select count(*)
from (select null) t

============= ����������� =============

4. �������� ������, � ������� ���� ����� � ������ ����� ��� �� 10 000 �.�.

* ����������� ������� payment
* ������������ ������ �� ������ ��������� date_trunc
* ��� ������ ������ ���������� ����� ��������
* �������������� ����������� �����, ��� ������ ������� � ������ ������ ����� ��� �� 10 000 �.�.

select date_trunc('month', payment_date), sum(p.amount)
from payment p 
group by date_trunc('month', payment_date)
having sum(p.amount) > 10000

FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE ��� WITH ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY

4.1 �������� ������ ��������� �������, ������� ����������������� ������ ������� ����� 5 ����
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* ������������ ���������� ������� �� category.name
* ��� ������ ������ ���������� ������ ����������������� ������ �������
* �������������� ����������� �����, ��� ������ ��������� �� ������� ������������������ > 5 ����

select c.name, avg(f.rental_duration)
from film f
join film_category fc using(film_id)
join category c using(category_id)
group by c.category_id
having avg(f.rental_duration) > 5

select c.customer_id, p.staff_id, sum(amount)
from payment p
join customer c on c.customer_id = p.customer_id
where c.customer_id < 5
group by c.customer_id, p.staff_id

select c.customer_id, p.staff_id, sum(amount)
from payment p
join customer c on c.customer_id = p.customer_id
where c.customer_id < 5
group by grouping sets(c.customer_id, p.staff_id)

select c.customer_id, p.staff_id, date_trunc('month', payment_date), sum(amount)
from payment p
join customer c on c.customer_id = p.customer_id
where c.customer_id < 5
group by cube(c.customer_id, p.staff_id, date_trunc('month', payment_date))

select c.customer_id, p.staff_id, date_trunc('month', payment_date), sum(amount)
from payment p
join customer c on c.customer_id = p.customer_id
where c.customer_id < 5
group by rollup(c.customer_id, p.staff_id, date_trunc('month', payment_date))

select c.customer_id as a, p.staff_id as b, sum(amount)
from payment p
join customer c on c.customer_id = p.customer_id
where c.customer_id < 5
group by a, b

============= ���������� =============

5. �������� ���������� �������, �� ���������� ������ �� ���� ������, ��� ������� �������� �� ���� �������
* �������� ���������, ������� ����� ��������� ������� �������� ��������� ������ �� ���� (������� 3.1)
* ����������� ������� film
* ������������ ������ � �������������� �������, ��������� �������� > (���������)
* count - ���������� ������� �������� ��������

select count(film_id)
from film
where rental_rate/rental_duration > (select round(avg(rental_rate/rental_duration),2) from film)

6. �������� ������, � ���������� ������������ � ����� "C"
* �������� ���������:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ��������� � �������� film_category
* ��������� � �������� film
* �������� ���������� � �������:
title, category."name"
* ����������� ��������� �� from, join, where

select category_id, "name"
from category 
where "name" like 'C%'

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
join film_category fc on fc.category_id = t.category_id
join film f on f.film_id = fc.film_id --175 / 53.29 / 0.47

explain analyse
select f.title, t.name
from film f
join film_category fc on fc.film_id = f.film_id
join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.47

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id and 
	fc.category_id in (select category_id
	from category 
	where "name" like 'C%')
join category c on c.category_id = fc.category_id --175 / 47.11 / 0.45

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (
	select category_id
	from category 
	where "name" like 'C%') --175 / 46.96 / 0.43

explain analyze
select f.title, t.name
from film f
right join film_category fc on fc.film_id = f.film_id
right join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.43

explain analyze
select category_id, "name"
from category 
where "name" like 'C%'

select (select sum(amount) from payment p) / (select count(customer_id) from customer )

select sum(amount) 
from payment p
where p.customer_id = (select customer_id from customer where last_name = 'Brown')

7* ������ 2 ��� kcu

select tc.table_name, tc.constraint_name, c.column_name, c.data_type
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu on 
	tc.constraint_schema = kcu.constraint_schema 
	and tc.table_name = kcu.table_name  
	and tc.constraint_name = kcu.constraint_name
join information_schema."columns" c on
	kcu.constraint_schema = c.table_schema  
	and kcu.table_name = c.table_name  
	and kcu.column_name = c.column_name
where tc.constraint_schema = 'dvd-rental' and tc.constraint_type = 'PRIMARY KEY'

������� 1. ���������� ��� ������� ������, ������� ��� ��� ����� � ������, � ����� ����� ��������� ������ ������ �� �� �����.
��������� ��������� �������: https://postimg.cc/5YQLw9m3

select f.title, f.rating, c.name, f.release_year, l.name, count(r.rental_id), sum(p.amount)
from rental r
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join payment p on p.rental_id = r.rental_id
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
join "language" l on f.language_id = l.language_id
group by f.film_id, c.category_id, l.language_id

������� 2. ����������� ������ �� ����������� ������� � �������� � ������� ���� ������, ������� �� ���� �� ����� � ������.
��������� ��������� �������: https://postimg.cc/QByc9KcC

select f.title, f.rating, f.release_year, count(r.rental_id), sum(p.amount)
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
left join payment p on p.rental_id = r.rental_id
group by f.film_id
having count(r.rental_id) = 0

select f.title, f.rating, f.release_year, count(r.rental_id), sum(p.amount)
from rental r
full join inventory i on i.inventory_id = r.inventory_id
full join film f on f.film_id = i.film_id
full join payment p on p.rental_id = r.rental_id
where r.rental_id is null
group by f.film_id

������� 3. ���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� ��������. 
���� ���������� ������ ��������� 7 300, �� �������� � ������� ����� ���, ����� ������ ���� �������� ����.
��������� ��������� �������: https://postimg.cc/y3q9nqQz

select staff_id,
	case 
		when count(payment_id) > 7300 then 'Yes'
		else 'No'
	end "�����-�� ���������"
from payment p
group by p.staff_id

