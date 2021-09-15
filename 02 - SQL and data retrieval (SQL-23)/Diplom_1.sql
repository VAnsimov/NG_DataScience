/*
 1. В каких городах больше одного аэропорта?
*/

SELECT city, 
       COUNT(airport_code)
  FROM airports
 GROUP BY city 
HAVING COUNT(airport_code) > 1

/*
 2. В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
 	- Подзапрос
*/

SELECT airport_code, 
	   airport_name,
	   flight_range
  FROM (SELECT flights.departure_airport AS airport_code, 
  			   MAX(aircrafts."range") AS flight_range
      	  FROM flights
      	  LEFT JOIN aircrafts USING(aircraft_code)
     	 GROUP BY flights.departure_airport) AS airport_max_flight_range
  LEFT JOIN airports USING(airport_code)
 WHERE flight_range = (SELECT MAX("range") FROM aircrafts)
 
/*
 3. Вывести 10 рейсов с максимальным временем задержки вылета
 	- Оператор LIMIT
*/
 

 SELECT flight_id, 
 	    actual_departure, 
 	    scheduled_departure
  FROM flights
 WHERE actual_departure IS NOT NULL 
 ORDER BY actual_departure - scheduled_departure DESC
 LIMIT 10
  
/*
 4. Были ли брони, по которым не были получены посадочные талоны?
 	- Верный тип JOIN
*/


WITH ticket_boarding_passes AS (
 	SELECT *
  	  FROM ticket_flights
 	 INNER JOIN boarding_passes USING(ticket_no, flight_id) 
)
SELECT ticket_no,
	   ticket_boarding_passes.boarding_no,
	   tickets.book_ref
  FROM ticket_boarding_passes
  FULL OUTER JOIN tickets USING(ticket_no)
 WHERE ticket_boarding_passes.boarding_no IS NULL
    OR tickets.book_ref IS NULL

/*
 5. Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
 Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта на каждый день. 
 Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за день.
 	- Оконная функция
 	- Подзапросы
*/

WITH aircrafts_seats AS (
 	SELECT aircraft_code, 
 		   COUNT(seat_no) AS totla_seat_count
  	  FROM aircrafts
 	 INNER JOIN seats USING(aircraft_code)
 	 GROUP BY aircraft_code
)
SELECT flight_seat.departure_airport,
	   DATE(flight_seat.actual_departure),
	   flight_seat.seat_count,
	   aircrafts_seats.totla_seat_count - flight_seat.seat_count AS free_seat_count,
	   aircrafts_seats.totla_seat_count,
	   ROUND(100 - (flight_seat.seat_count::NUMERIC / aircrafts_seats.totla_seat_count::NUMERIC) * 100, 2) AS percentage_of_free_seats,
	   SUM(flight_seat.seat_count::NUMERIC) OVER (PARTITION BY departure_airport, DATE(flight_seat.actual_departure)) AS sum_passengers_in_day
  FROM (SELECT flight_id, 
	       	   aircraft_code, 
	           flights.departure_airport,
	           COUNT(seat_no) AS seat_count,
	           flights.actual_departure
 	      FROM flights
 	     INNER JOIN ticket_flights USING(flight_id)
 	     INNER JOIN boarding_passes USING(ticket_no, flight_id) 
         GROUP BY flight_id
) AS flight_seat
 INNER JOIN aircrafts_seats USING(aircraft_code)
 ORDER BY flight_seat.flight_id

 /*
 6. Найдите процентное соотношение перелетов по типам самолетов от общего количества.
 	- Подзапрос
 	- Оператор ROUND
*/


SELECT aircrafts.model,
	   ROUND(COUNT(flights.flight_id)::NUMERIC / (SELECT COUNT(flight_id) AS total_count FROM flights) * 100, 2) AS flights_percent
  FROM flights
 INNER JOIN aircrafts USING(aircraft_code)
 GROUP BY aircrafts.model

/*
7. Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?
- CTE
*/
--Выборка из таблицы flights соединение таблицы airports и ticket_flights
--Отфильтровать по экном классу
--Отфильтровать по экном бизнесс классу
--И примененить фильтры


WITH flight_city AS (
	SELECT flight_id,
           city AS arrival_to_city,
           ticket_flights.fare_conditions,
           ticket_flights.amount
  	  FROM flights
 	 INNER JOIN airports ON flights.arrival_airport = airports.airport_code 
 	 INNER JOIN ticket_flights USING(flight_id)
), economy AS (
	SELECT arrival_to_city,
		   MAX(amount) AS amount
      FROM flight_city
     WHERE fare_conditions = 'Economy'
     GROUP BY arrival_to_city
), business AS (
    SELECT arrival_to_city,
		   MIN(amount) AS amount
      FROM flight_city
     WHERE fare_conditions = 'Business'
     GROUP BY arrival_to_city
)
SELECT economy.arrival_to_city,
       economy.amount AS economy_amount,
       business.amount AS business_amount
  FROM economy
 INNER JOIN business USING(arrival_to_city)
 WHERE economy.amount > business.amount


/*  
8. Между какими городами нет прямых рейсов?
- Декартово произведение в предложении FROM
- Самостоятельно созданные представления
- Оператор EXCEPT
*/


--DROP VIEW IF EXISTS airport_to_airport

CREATE VIEW no_flight_airports AS
WITH airport_to_airport AS (
	SELECT a.airport_code AS airport_a, 
	       a.city AS city_a,
           airports.airport_code AS airport_b,
           airports.city AS city_b
 	  FROM airports as a CROSS JOIN airports
 	 WHERE  a.airport_code <> airports.airport_code
), flight_airport AS (
	SELECT departure_airport, 
	       arrival_airport
  	  FROM flights
 	 GROUP BY departure_airport, arrival_airport
)
SELECT airport_a AS airport_code_a, 
	   airport_b AS airport_code_b
  FROM airport_to_airport
EXCEPT
SELECT *
  FROM flight_airport
  
 SELECT a1.city AS city_a,
 	    a2.city  AS city_b
   FROM no_flight_airports
   LEFT JOIN airports AS a1 ON a1.airport_code = no_flight_airports.airport_code_a 
   LEFT JOIN airports AS a2 ON a2.airport_code = no_flight_airports.airport_code_b
  GROUP BY a1.city, a2.city

/*
9. Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы *
- Оператор RADIANS или использование sind/cosd

 Кратчайшее расстояние между двумя точками A и B на земной поверхности (если принять ее за сферу) определяется зависимостью:
 
 d = arccos {sin(latitude_a)·sin(latitude_b) + cos(latitude_a)·cos(latitude_b)·cos(longitude_a - longitude_b)}

 latitude_a и latitude_b — широты
 longitude_a, longitude_b — долготы данных пунктов 
 d — расстояние между пунктами измеряется в радианах длиной дуги большого круга земного шара.

 Расстояние между пунктами, измеряемое в километрах, определяется по формуле:
 L = d·R, где R = 6371 км — средний радиус земного шара.
*/


WITH flight_airports AS (
	SELECT departure_airport, 
	       arrival_airport,
	       aircraft_code
  	  FROM flights
 	 GROUP BY departure_airport, 
 	       arrival_airport,
 	       aircraft_code
), airports_distance AS (
	SELECT flight_airports.departure_airport,
	   	   flight_airports.arrival_airport,
	       ACOS( 
	          SIND(dep_airports.latitude) * SIND(arr_airports.latitude) + COSD(dep_airports.latitude) * COSD(arr_airports.latitude) * COSD(dep_airports.longitude - arr_airports.longitude)
	   	   ) * 6371 AS distance_km
  	  FROM flight_airports
  	  LEFT JOIN airports AS dep_airports ON dep_airports.airport_code = flight_airports.departure_airport
  	  LEFT JOIN airports AS arr_airports ON arr_airports.airport_code = flight_airports.arrival_airport
)
SELECT flight_airports.departure_airport,
	   flight_airports.arrival_airport,
	   flight_airports.aircraft_code,
	   ROUND(airports_distance.distance_km::NUMERIC, 0) AS distance_km,
	   aircrafts."range"
  FROM flight_airports
  LEFT JOIN airports_distance USING(departure_airport, arrival_airport)
  LEFT JOIN aircrafts USING (aircraft_code)
 

  
  
  