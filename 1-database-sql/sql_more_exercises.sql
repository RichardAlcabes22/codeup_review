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