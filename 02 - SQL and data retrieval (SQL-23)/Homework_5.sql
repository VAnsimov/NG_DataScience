/*
 Задание 1. Напишите SQL-запрос, который выводит всю информацию о фильмах со специальным атрибутом “Behind the Scenes”.
 Ожидаемый результат запроса: https://postimg.cc/B8G37Gf0
*/

SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY['Behind the Scenes'] <@ special_features
 ORDER BY film_id
 
/*
 Задание 2. Напишите ещё 2 варианта поиска фильмов с атрибутом “Behind the Scenes”, используя другие функции или операторы языка SQL для поиска значения в массиве.
 Ожидаемый результат запроса: https://postimg.cc/kRDPRJKx
*/

SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY['Behind the Scenes'] && special_features
 ORDER BY film_id

SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY_POSITION(special_features, 'Behind the Scenes') IS NOT NULL
 ORDER BY film_id

/*
 Задание 3. Для каждого покупателя посчитайте, сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
 Обязательное условие для выполнения задания: используйте запрос из задания 1, помещённый в CTE.
 Ожидаемый результат запроса: https://postimg.cc/phstdhhW
*/
 
WITH filter_film AS (
	SELECT film_id,
           special_features
  	  FROM film
 	 WHERE ARRAY['Behind the Scenes'] <@ special_features
)
SELECT customer_id, COUNT(film_id)
  FROM rental
  LEFT JOIN inventory USING(inventory_id)
 INNER JOIN filter_film USING(film_id)
 GROUP BY customer_id
 ORDER BY customer_id

/*
 Задание 4. Для каждого покупателя посчитайте, сколько он брал в аренду фильмов со специальным атрибутом “Behind the Scenes”.
 Обязательное условие для выполнения задания: используйте запрос из задания 1, помещённый в подзапрос, который необходимо использовать для решения задания.
 Ожидаемый результат запроса: https://postimg.cc/vDmsNzkc
*/
 
SELECT customer_id, COUNT(film_id)
  FROM rental
  LEFT JOIN inventory USING(inventory_id)
 INNER JOIN (
				SELECT film_id,
           			   special_features
  	  			  FROM film
 	 			 WHERE ARRAY['Behind the Scenes'] <@ special_features
			) AS filter_film USING(film_id)
 GROUP BY customer_id
 ORDER BY customer_id

/*
 Задание 5. Создайте материализованное представление с запросом из предыдущего задания и напишите запрос для обновления материализованного представления.
*/

CREATE MATERIALIZED VIEW 
arent_film_count AS
SELECT customer_id, COUNT(film_id)
  FROM rental
  LEFT JOIN inventory USING(inventory_id)
 INNER JOIN (
				SELECT film_id,
           			   special_features
  	  			  FROM film
 	 			 WHERE ARRAY['Behind the Scenes'] <@ special_features
			) AS filter_film USING(film_id)
 GROUP BY customer_id
 ORDER BY customer_id
 WITH DATA;

REFRESH MATERIALIZED VIEW arent_film_count
 
 
/*
Задание 6. С помощью explain analyze проведите анализ скорости выполнения запросов из предыдущих заданий и ответьте на вопросы:
· с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания, поиск значения в массиве происходит быстрее;
· какой вариант вычислений работает быстрее: с использованием CTE или с использованием подзапроса.

Вопрос: С каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания, поиск значения в массиве происходит быстрее;
Ответ:	Оператор ARRAY <@ и && запрос работает примерно одиникаов, а ARRAY_POSITION работает чуть быстрее, кажется что выполняется меньше на 1 действие, но разница времени не значительная

Вопрос: Какой вариант вычислений работает быстрее: с использованием CTE или с использованием подзапроса.
Ответ:	С CTE запрос работает быстрее (~8 ms против ~10 ms), но разница времени не значительная
*/

EXPLAIN ANALYZE
SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY['Behind the Scenes'] <@ special_features
 ORDER BY film_id

EXPLAIN ANALYZE
SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY['Behind the Scenes'] && special_features
 ORDER BY film_id

EXPLAIN ANALYZE
SELECT film_id, 
       title, 
       special_features
  FROM film
 WHERE ARRAY_POSITION(special_features, 'Behind the Scenes') IS NOT NULL
 ORDER BY film_id

EXPLAIN ANALYZE
WITH filter_film AS (
	SELECT film_id,
           special_features
  	  FROM film
 	 WHERE ARRAY['Behind the Scenes'] <@ special_features
)
SELECT customer_id, COUNT(film_id)
  FROM rental
  LEFT JOIN inventory USING(inventory_id)
 INNER JOIN filter_film USING(film_id)
 GROUP BY customer_id
 ORDER BY customer_id
 
EXPLAIN ANALYZE
SELECT customer_id, COUNT(film_id)
  FROM rental
  LEFT JOIN inventory USING(inventory_id)
 INNER JOIN (
				SELECT film_id,
           			   special_features
  	  			  FROM film
 	 			 WHERE ARRAY['Behind the Scenes'] <@ special_features
			) AS filter_film USING(film_id)
 GROUP BY customer_id
 ORDER BY customer_id
 
 
 