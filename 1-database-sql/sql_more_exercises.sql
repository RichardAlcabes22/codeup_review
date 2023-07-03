USE sakila;
SHOW TABLES;
SELECT *
FROM payment
LIMIT 5;

-- all columns from actor table
SELECT *
FROM film
LIMIT 10;
-- last_name
SELECT last_name
FROM actor
ORDER BY actor_id;
-- film_id, title,release_year
SELECT film_id,title,release_year
FROM film;

-- all DISTINCT last names from actor table
SELECT DISTINCT last_name
FROM actor;
-- all DISTINCT postal codes from address table
SELECT DISTINCT postal_code
FROM address;
-- all DISTINCT ratings from film table
SELECT DISTINCT rating
FROM film;
-- title,descr,rating,length from films 3hrs+
SELECT title,f.description,rating,f.length
FROM film AS f
WHERE length >=180;
DESCRIBE payment;
-- payment_id,amount,payment_date from payment on 5/27/2005
SELECT payment_id,amount,payment_date
FROM payment
WHERE MONTH(payment_date) = '5' AND
		DAY(payment_date) = '27' AND
        YEAR(payment_date) = '2005';

-- pri key,amount,payment_date from payment on 5/27/2005
SELECT payment_id,amount,payment_date
FROM payment
WHERE MONTH(payment_date) = '5' AND
		DAY(payment_date) = '27' AND
        YEAR(payment_date) = '2005';

-- all columns from customer table where last_name startswith 's' and first_name begins with 'n'
SELECT * FROM customer LIMIT 5;
SELECT *
FROM customer
WHERE last_name LIKE 'S%' AND -- OR
		first_name LIKE 'N%';

-- all columns for inactive customers and last_name begins with 'm'
SELECT *
FROM customer
WHERE active = 0
  AND last_name LIKE 'M%';
  
-- all columns from category table where id > 4 and name starts with 'C' 'S' 'T'
SELECT * FROM category LIMIT 5;
SELECT *,SUBSTR(name,1,1)
FROM category
WHERE category_id > 4
  AND SUBSTR(name,1,1) IN ('C','S','T');

-- select all columns except password from staff table for those rows that have a password
SELECT * FROM staff;
SELECT staff_id,first_name,last_name,address_id,picture,email,store_id,active,username,last_update
FROM staff
WHERE password IS NOT NULL;
-- select all the above for staff who do NOT have password
SELECT staff_id,first_name,last_name,address_id,picture,email,store_id,active,username,last_update
FROM staff
WHERE password IS NULL;

-- select phone and district from address table in Cali,Eng,Tai,W.Java
SELECT * FROM address LIMIT 5;
SELECT phone,district
FROM address
WHERE district IN ('California','England','Taipei','West Java');
-- select payment_id, amnt,pay_date from payment table on 5-25,5-27-5-29
SELECT * FROM payment LIMIT 5;
SELECT payment_id,amount,payment_date
FROM payment
WHERE SUBSTR(payment_date,6,5) IN ('05-25','05-27','05-29');
-- select all columns from film table rated G, PG-13, NC-17
SELECT *
FROM film
WHERE rating IN ('G','PG-13','NC-17');
-- select all columns from payment table for payments made 2005-05-25 00:00:00 and 2005-05-25 23:59:59
select *
FROM payment
WHERE payment_date BETWEEN '2005-05-25 00:00:00:00' AND '2005-05-25 23:59:59'
ORDER BY payment_date;
-- select film_id, title, description, from film table where length of description is 100 to 120 chars
SELECT film_id,title,film.description
FROM film
WHERE LENGTH(film.description) BETWEEN 100 AND 120;
-- select rows from film table where description begins with "A Thoughtful"
SELECT film_id,title,film.description
FROM film
WHERE film.description LIKE 'A Thoughtful%';
-- select rows from film table where description ends with "Boat"
SELECT film_id,title,film.description
FROM film
WHERE film.description LIKE '% Boat';
-- select rows from film table where the description contains 'Database' and film is > 3 hrs
SELECT film_id,title,f.description,f.length
FROM film AS f
WHERE length >=180
	AND f.description LIKE '%Database%';
-- select all from film table, but include only first 20 rows
SELECT *
FROM film
LIMIT 20;
-- payment_date and amnt from payment table where payment amnt > 5 and zero-based index bewtween 1000-2000
SELECT * FROM payment LIMIT 5;
SELECT payment_date,amount
FROM payment
WHERE amount > 5
	AND payment_id BETWEEN 999 AND 1999;
-- select all from customer table where zero-based index between 101-200
SELECT * FROM customer LIMIT 5;
SELECT *
FROM customer
WHERE customer_id BETWEEN 100 AND 199;

-- select all from film table and order by length ascending
SELECT *
FROM film
ORDER BY film.length;
-- select all distinct ratings from film table ordered DESC
SELECT DISTINCT rating
FROM film
ORDER BY rating DESC;
-- select payment_date and amnt for first 20 payments ordered by amnt DESC
SELECT payment_date,amount
FROM payment
ORDER BY payment_date
LIMIT 20;

SELECT *
FROM (
		SELECT payment_date,amount
		FROM payment
		ORDER BY payment_date
		LIMIT 20
        ) AS f20
ORDER BY amount DESC;

-- select title,description,special_features,length,rental_duration from film for first 10 films with 'behind scenes footage'
-- under 2 hrs, and rental dur of 5 to 7 days, ordered by length in DESC
SELECT * FROM film LIMIT 5;

SELECT film_id,title,film.description,special_features,length,rental_duration
FROM film
WHERE special_features LIKE '%Behind the Scenes%'
ORDER BY film_id;

SELECT *
FROM (
		SELECT film_id,title,film.description,special_features,length,rental_duration
		FROM film
		WHERE special_features LIKE '%Behind the Scenes%'
	) AS bts
WHERE bts.length < 120
	AND rental_duration BETWEEN 5 AND 7
ORDER BY bts.length DESC
LIMIT 10;

-- select customer first_name/last_name and actor f/l_name from left join cust and actor tables
SELECT * FROM customer;
SELECT * FROM actor LIMIT 5;

SELECT c.customer_id,c.first_name,c.last_name,a.actor_id,a.first_name,a.last_name
FROM customer AS c
	LEFT JOIN actor AS a
      ON c.last_name = a.last_name
;
-- select customer first/last acor first/last as above, but with RIGHT join
SELECT c.customer_id,c.first_name,c.last_name,a.actor_id,a.first_name,a.last_name
FROM customer AS c
	RIGHT JOIN actor AS a
      ON c.last_name = a.last_name
;
-- select as above, but with INNER join
SELECT c.customer_id,c.first_name,c.last_name,a.actor_id,a.first_name,a.last_name
FROM customer AS c
	JOIN actor AS a
      ON c.last_name = a.last_name
;
-- select city_name and country_name from city table
SELECT * FROM city LIMIT 5;
SELECT * FROM country LIMIT 5;

SELECT ct.city,cn.country
FROM city AS ct
	LEFT JOIN country AS cn
     ON ct.country_id = cn.country_id
;
-- select title, descr,release_yr,lang from film left-joined with language table
SELECT * FROM language LIMIT 5;

SELECT f.title,f.description,f.release_year,l.name
FROM film AS f
	LEFT JOIN language AS l
      ON f.language_id = l.language_id
;
-- select first_name, last,address,adress2,city_name,district,postal from staff table join address and city
SELECT * FROM staff LIMIT 5;
SELECT * FROM address LIMIT 5;
SELECT s.first_name, s.last_name,a.address,a.address2,c.city,a.district,a.postal_code
FROM staff AS s
	LEFT JOIN address AS a
      USING(address_id)
	LEFT JOIN city AS c
      USING(city_id)
;


-- display first and last names of all actors in lowercase
SELECT CONCAT(LOWER(first_name),' ',LOWER(last_name)) AS full_name
FROM actor
LIMIT 5;
-- id, first name, last name of actor with first_name = Joe
SELECT actor_id,first_name,last_name
FROM actor
WHERE first_name = 'Joe';
-- all actors with last_names contain 'gen'
SELECT actor_id,first_name,last_name
FROM actor
WHERE last_name LIKE '%gen%';
-- actors with last names containing 'li', order by last_name, first_name
SELECT actor_id,last_name,first_name
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name,first_name;
-- display county_id and country cols for AFG, BANG,CHI
SELECT * FROM country LIMIT 5;
SELECT country_id,country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');
-- List last_names of actors and number of actors with each last_name, where actor COUNT > 1
SELECT last_name,COUNT(*) AS total
FROM actor
GROUP BY last_name
HAVING total > 1
ORDER BY total DESC;
-- recreate schema 'address' table
SHOW CREATE TABLE address;
-- first/last names and address of staff members
SELECT * FROM staff LIMIT 5;
SELECT * FROM address LIMIT 5;
SELECT first_name,last_name,address
FROM staff AS s
	JOIN address AS a
      USING(address_id)
;
-- total amount by each staff in Aug2005
SELECT * FROM rental LIMIT 5;
SELECT * FROM payment LIMIT 5;

SELECT staff_id,SUM(amount),COUNT(*),MIN(payment_date),MAX(payment_date)
FROM payment
WHERE payment_date LIKE '2005-08%'
GROUP BY staff_id;
-- list each film and COUNT of actors listed for film
SELECT * FROM film_actor LIMIT 5;

SELECT film_id, COUNT(actor_id) AS total_actors
FROM film_actor
GROUP BY film_id;

-- display title of films begin with 'K' and 'Q' and ENGLISH language
SELECT * FROM language LIMIT 5;

SELECT title
FROM film AS f
	JOIN language AS l
      USING(language_id)
WHERE l.name = 'English'
	AND SUBSTR(title,1,1) IN ('K','Q')
;
-- display actors appear in 'Alone Trip'
SELECT film_id FROM film WHERE title = 'Alone Trip';

SELECT fa.actor_id,fa.film_id,a.first_name,a.last_name
FROM film_actor AS fa
	JOIN actor AS a
      USING(actor_id)
WHERE fa.film_id = (
				SELECT film_id FROM film WHERE title = 'Alone Trip'
                )
;
-- list names and emails for all customers in Canada
SELECT * FROM customer LIMIT 5;
SELECT * FROM city LIMIT 5;
SELECT * FROM country LIMIT 5;
SELECT * FROM customer_list LIMIT 5;

SELECT country_id FROM country WHERE country = 'Canada';
SELECT city_id,city FROM city WHERE country_id = 20;


SELECT cl.ID, cl.name, c.email, cl.country
FROM customer_list AS cl
	JOIN customer AS c
      ON cl.ID = c.customer_id
WHERE cl.country = 'Canada';

-- all movies identified as 'Family'
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- a query to show sum amount in dollars per store
SELECT * FROM store LIMIT 5;
SELECT * FROM sales_by_store LIMIT 5;

SELECT st.store_id,SUM(amount)
FROM store AS st
	JOIN staff AS stf
      ON st.manager_staff_id = stf.staff_id
	JOIN payment AS p
      USING(staff_id)
GROUP BY st.store_id;
SELECT * FROM payment WHERE staff_id IS NULL;
-- for each store, show store_id,city,country
SELECT s.store_id,a.city_id,c.city,cnty.country_id,cnty.country
FROM store AS s
	JOIN address AS a
      USING(address_id)
	JOIN city AS c
      USING(city_id)
	JOIN country AS cnty
	  USING(country_id);
      
-- top 5 genres in gross revenue DESC
SELECT * FROM film_category LIMIT 5;
SELECT * FROM inventory LIMIT 5;
SELECT * FROM category LIMIT 5;

SELECT cat.category_id,cat.name, COUNT(*) AS total_units,SUM(p.amount) AS total_$
FROM category AS cat
	JOIN film_category AS fcat
      USING(category_id)
	JOIN inventory AS i
      USING(film_id)
	JOIN rental AS r
      USING(inventory_id)
	JOIN payment AS p
      USING(rental_id)
GROUP BY cat.category_id,cat.name
ORDER BY total_$ DESC
LIMIT 5;

-- avg replacement cost of a film, then sliced by rating
SELECT ROUND(AVG(replacement_cost),2) AS avg_rep_cost
FROM film
;
SELECT rating,ROUND(AVG(replacement_cost),2) AS avg_rep_cost
FROM film
GROUP BY rating;

-- how many unique film titles in each genre
SELECT fcat.category_id,cat.name,COUNT(fcat.film_id)
FROM film_category AS fcat
	JOIN category AS cat
      USING(category_id)
GROUP BY fcat.category_id;

-- top 5 most frequently rented films
SELECT i.film_id,COUNT(*) AS tot_inv_units
FROM rental AS r
	JOIN inventory AS i
      USING(inventory_id)
GROUP BY i.film_id;
-- -- -- create a temp table AS ... by addding category_id to rental table
SELECT rental_id, inventory_id,category_id