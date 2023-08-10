USE employees;
SHOW TABLES;
-- Irena/Vidya/Maya
SELECT *
FROM employees
LIMIT 5;
SELECT *
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
LIMIT 3;
-- Same as above, but use OR
SELECT *
FROM employees
WHERE 	first_name = 'Irena' 
	OR 	first_name = 'Vidya' 
	OR 	first_name = 'Maya'
LIMIT 3;
-- Same as above, but only Male emps:
SELECT *
FROM employees
WHERE 	gender = 'M'
	AND (
			first_name = 'Irena' 
		OR 	first_name = 'Vidya' 
		OR 	first_name = 'Maya')
LIMIT 3;
-- Unique last name START with E:
SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE 'E%';
-- Unique last_name START or END with E:
SELECT DISTINCT last_name
FROM employees
WHERE 	last_name LIKE 'E%'
	OR 	last_name LIKE '%e';
-- Unique last_name END with E, but NOT START with E: 
SELECT DISTINCT last_name
FROM employees
WHERE 	last_name LIKE '%e'
	AND last_name NOT LIKE 'E%';
-- Unique last_name START and END with E:
SELECT DISTINCT last_name
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e';
-- Emps hired in 1990s:
DESCRIBE employees.employees;
SELECT emp_no,last_name,hire_date
FROM employees
WHERE 	YEAR(hire_date) BETWEEN 1990 AND 1999
LIMIT 3;
-- Emps born on XMAS:
SELECT emp_no,last_name,birth_date
FROM employees
WHERE 	MONTH(birth_date) = 12
	AND	DAY(birth_date) = 25
LIMIT 3;
-- Emps hired in 1990s AND born on XMAS:
SELECT emp_no,last_name,hire_date,birth_date
FROM employees
WHERE 	(YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND	(
		MONTH(birth_date) = 12
		AND	DAY(birth_date) = 25)
LIMIT 3;
-- Find unique last_names contains 'q':
SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE '%q%';
-- Find unique with q BUT NOT QU!:
SELECT DISTINCT last_name
FROM employees
WHERE 	last_name LIKE '%q%'
	AND	last_name NOT LIKE '%qu%';