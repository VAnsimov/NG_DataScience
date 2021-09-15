
/*
Задание 1. Сделайте запрос к таблице payment. Пронумеруйте все продажи от 1 до N по дате.
Ожидаемый результат запроса: https://postimg.cc/cKd7YNKg
*/

SELECT payment_id,
	   payment_date,
	   ROW_NUMBER() OVER (ORDER BY payment_date)
  FROM payment
 ORDER BY payment_date;

/*
Задание 2. Используя оконную функцию, добавьте колонку с порядковым номером продажи для каждого покупателя, сортировка платежей должна быть по дате.
Ожидаемый результат запроса: https://postimg.cc/v1XrtS9P
*/

SELECT payment_id,
	   payment_date,
	   customer_id,
	   ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date)
  FROM payment
 ORDER BY customer_id;

/*
Задание 3. Для каждого пользователя посчитайте нарастающим итогом сумму всех его платежей, сортировка должна быть по дате платежа.
Ожидаемый результат запроса: https://postimg.cc/CB1jPHsw
*/

SELECT customer_id,
	   payment_id,
	   payment_date,
	   amount,
	   SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date)
  FROM payment
 ORDER BY customer_id;

/*
Задание 4. Для каждого покупателя выведите данные о его последней оплате аренды.
Ожидаемый результат запроса: https://postimg.cc/0KK7xk43
*/

SELECT p.customer_id,
	   p.payment_id, 
  	   p.payment_date, 
  	   p.amount
  FROM (SELECT customer_id,
	   		   FIRST_VALUE(payment_id) OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS payment_id,
	   		   FIRST_VALUE(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS payment_date,
	   		   FIRST_VALUE(amount) OVER (PARTITION BY customer_id ORDER BY payment_date DESC) AS amount
	   	  FROM payment) AS p
 GROUP BY p.customer_id, 
  		  p.payment_id, 
  		  p.payment_date, 
  		  p.amount
 ORDER BY customer_id;