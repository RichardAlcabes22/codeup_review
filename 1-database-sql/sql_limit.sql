USE employees;
SHOW TABLES;
SELECT *
FROM employees
LIMIT 5;
DESCRIBE employees.employees;

SELECT DISTINCT title
FROM titles;
-- hired 1990s born on XMAS ORDER BY hire_date (ASC) and LIMIT 5
SELECT emp_no,last_name,first_name,hire_date,birth_date
FROM employees
WHERE 	(YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND	(
		MONTH(birth_date) = 12
		AND	DAY(birth_date) = 25)
ORDER BY hire_date ASC,birth_date ASC
LIMIT 5;
-- update this query to find the 5 results on pg 10...
SELECT emp_no,last_name,first_name,hire_date,birth_date
FROM employees
WHERE 	(YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND	(
		MONTH(birth_date) = 12
		AND	DAY(birth_date) = 25)
ORDER BY hire_date ASC,birth_date ASC
LIMIT 5 OFFSET 45;
