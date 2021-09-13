Задание 1. Выведите уникальные названия районов из таблицы адресов.
Ожидаемый результат запроса: http://prntscr.com/1311350

SELECT DISTINCT district
  FROM address;


Задание 2. Доработайте запрос из предыдущего задания, чтобы запрос выводил только те регионы, названия которых начинаются на “K” и заканчиваются на “a”, и названия не содержат пробелов.
Ожидаемый результат запроса: https://ibb.co/7SXwc50

SELECT DISTINCT district
  FROM address
 WHERE district LIKE 'K%a'
   AND district NOT LIKE '% %';


Задание 3. Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 17 марта 2007 года по 19 марта 2007 года включительно, и стоимость которых превышает 1.00. Платежи нужно отсортировать по дате платежа.
Ожидаемый результат запроса: https://ibb.co/rv88v1C

  SELECT payment_id, 
         payment_date, 
         amount
    FROM payment
   WHERE payment_date >= '2007-03-17 00:00:00' 
     AND payment_date < '2007-03-20 00:00:00'
     AND amount > 1
ORDER BY payment_date;


Задание 4. Выведите информацию о 10-ти последних платежах за прокат фильмов.
Ожидаемый результат запроса: https://ibb.co/nj1bp2v

  SELECT payment_id, 
         payment_date, 
         amount
    FROM payment
ORDER BY payment_date DESC
   LIMIT 10;

   
Задание 5. Выведите следующую информацию по покупателям:
· Фамилия и имя (в одной колонке через пробел)
· Электронная почта
· Длину значения поля email
· Дату последнего обновления записи о покупателе (без времени)
Каждой колонке задайте наименование на русском языке.
Ожидаемый результат запроса: https://ibb.co/vcgY8Mh

SELECT concat_ws(' ', first_name, last_name) AS "Фамилия и имя",
       email AS "Электронная почта",
       character_length(email) AS "Длина email",
       date(last_update) AS "Дата"
  FROM customer;


Задание 6. Выведите одним запросом активных покупателей, имена которых Kelly или Willie. Все буквы в фамилии и имени из нижнего регистра должны быть переведены в высокий регистр.
Ожидаемый результат запроса: https://ibb.co/9HWPpWk

SELECT upper(last_name), 
       upper(first_name) 
  FROM customer
 WHERE (first_name ILIKE 'Kelly' 
    OR first_name ILIKE 'Willie')
   AND active = 1;
    
   
   
Дополнительная часть:
    


Задание 1. Выведите одним запросом информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 0.00 до 3.00 включительно, 
 а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.
Ожидаемый результат запроса: https://ibb.co/Dk4PjJn

SELECT film_id,
	   title,
	   description,
       rating,
       rental_rate
  FROM film
 WHERE (rental_rate <= 3
   AND rating::text = 'R')
    OR (rental_rate >= 4
   AND rating::text = 'PG-13');
 

Задание 2. Получите информацию о трёх фильмах с самым длинным описанием фильма.
Ожидаемый результат запроса: https://ibb.co/pfMHBs0

   SELECT film_id,
          title,
          description
     FROM film
 ORDER BY character_length(description) DESC
    LIMIT 3;

Задание 3. Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй колонке должно быть значение, указанное после @.
Ожидаемый результат запроса: https://ibb.co/SJng6qd

   SELECT customer_id,
	      email AS "Email",
	      split_part(email, '@', 1) AS "Email before @",
	      split_part(email, '@', 2) AS "Email after @"
     FROM customer
 ORDER BY customer_id;


Задание 4. Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные строчными.
Ожидаемый результат запроса: https://ibb.co/vv0k9b6

   SELECT customer_id,
	      email AS "Email",
	      upper(substring( split_part(email, '@', 1) FROM 1 FOR 1) ) 
	      || lower(substring(split_part(email, '@', 1) FROM 2 FOR character_length(split_part(email, '@', 1)))) AS "Email before @",
	      upper(substring( split_part(email, '@', 2) FROM 1 FOR 1) ) 
	      || lower(substring(split_part(email, '@', 2) FROM 2 FOR character_length(split_part(email, '@', 2)))) AS "Email after @"
     FROM customer
 ORDER BY customer_id;