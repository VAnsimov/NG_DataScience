/*
Задание 1. Выведите для каждого покупателя его адрес, город и страну проживания.
Ожидаемый результат запроса: http://prntscr.com/1316yrv
*/

SELECT concat_ws(' ', customer.last_name , customer.first_name) AS "Фамилия и имя",
       address.address  AS "Адрес",
       city.city AS "Город",
       country.country AS "Страна"
  FROM customer
  LEFT JOIN address USING(address_id)
  LEFT JOIN city USING (city_id)
  LEFT JOIN country USING(country_id)
  
/*
Задание 2. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
Ожидаемый результат запроса: http://prntscr.com/13170ax
*/
  
SELECT c.store_id AS "ID магазина",
       count(c.customer_id) AS "Количество покупателей"
  FROM customer AS c 
 GROUP BY c.store_id 

/*
Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300. Для решения используйте фильтрацию по сгруппированным строкам с функцией агрегации. Ожидаемый результат запроса: https://postimg.cc/2VQdc6N9
*/
 
 SELECT c.store_id AS "ID магазина",
       count(c.customer_id) AS "Количество покупателей"
  FROM customer AS c 
 GROUP BY c.store_id
HAVING count(c.customer_id) > 300
 
/*
Доработайте запрос, добавив в него информацию о городе магазина, фамилии и имени продавца, который работает в нём. Ожидаемый результат запроса: https://postimg.cc/5XfBZVx4
*/


SELECT customer.store_id AS "ID магазина",
       count(customer.customer_id) AS "Количество покупателей",
       a_city.city AS "Город магазина",
       concat_ws(' ', staff.last_name, staff.first_name) AS "Фамилия и имя продавца"
  FROM customer 
  LEFT JOIN staff USING(store_id)
  LEFT JOIN store USING(store_id)
  LEFT JOIN (SELECT city.city, address.address_id
   		       FROM address
               LEFT JOIN city USING(city_id)) AS a_city ON store.address_id = a_city.address_id
 GROUP BY customer.store_id, 
  	  	  a_city.city, 
  	  	  concat_ws(' ', staff.last_name, staff.first_name)
HAVING count(customer.customer_id) > 300

/*
Задание 3. Выведите топ-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов.
Ожидаемый результат запроса: https://postimg.cc/yDnmKbdF
*/

SELECT concat_ws(' ', customer.last_name, customer.first_name) AS "Фамилия и имя покупателя",
 	   count(rental.rental_id) AS "Количество фильмов"
  FROM rental
 INNER JOIN customer USING(customer_id)
 GROUP BY customer.customer_id
 ORDER BY count(rental.rental_id) DESC
 lIMIT 5
 
  
/*
Задание 4. Посчитайте для каждого покупателя 4 аналитических показателя:
· количество взятых в аренду фильмов;
· общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа);
· минимальное значение платежа за аренду фильма;
· максимальное значение платежа за аренду фильма.
Ожидаемый результат запроса:https://postimg.cc/CZ1jxsB9
*/
 
SELECT concat_ws(' ', customer.last_name, customer.first_name) AS "Фамилия и имя покупателя",
 	   count(rental.rental_id) AS "Количество фильмов",
 	   round(sum(payment.amount)) AS "Общая стоимость платежей",
 	   min(payment.amount) AS "Минимальная стоимость платежей",
 	   max(payment.amount) AS "Максимальная стоимость платежей"
  FROM rental
 INNER JOIN customer USING(customer_id)
 INNER JOIN payment USING(rental_id)
 GROUP BY customer.customer_id

 /*
Задание 5. Используя данные из таблицы городов, составьте одним запросом всевозможные пары городов так, чтобы в результате не было пар с одинаковыми названиями городов. Для решения необходимо использовать декартово произведение.
Ожидаемый результат запроса: https://postimg.cc/Thmn1w12
*/
 
SELECT origin_city.city AS "Город 1",
       join_city.city AS "Город 2" 
  FROM city AS origin_city CROSS JOIN city AS join_city
 WHERE origin_city.city_id != join_city.city_id 
 
/*
Задание 6. Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и дате возврата (поле return_date), вычислите для каждого покупателя среднее количество дней, за которые он возвращает фильмы.
Ожидаемый результат запроса: https://postimg.cc/1VpFjW2V
*/
  

 SELECT customer.customer_id,
 		ROUND(AVG(DATE_PART('day', rental.return_date - rental.rental_date))::NUMERIC, 2)
   FROM rental
   LEFT JOIN customer USING(customer_id)
  GROUP BY customer.customer_id 
  ORDER BY customer.customer_id
  
  
  
  
  
  
  
  