USE employees;
SHOW TABLES;
SELECT *
FROM employees
LIMIT 5;
DESCRIBE employees.employees;
-- Irena/Vidya/Maya
SELECT *
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
ORDER BY first_name;
-- ORDER BY  first_name then last_name:
SELECT *
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
ORDER BY first_name,last_name;
-- ORDER BY last_name, then first_name:
SELECT *
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
ORDER BY last_name,first_name;
-- last_name starts AND ends with 'e', ORDER BY emp_no:
SELECT emp_no,last_name, first_name
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e'
ORDER BY emp_no;
-- last_name starts AND ends with 'e', ORDER BY hire_date(newest first):
SELECT emp_no,last_name, first_name,hire_date
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e'
ORDER BY hire_date DESC;
-- hired 1990s born on XMAS ORDER BY hire_date (DESC) then AGE (DESC)
SELECT emp_no,last_name,first_name,hire_date,birth_date
FROM employees
WHERE 	(YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND	(
		MONTH(birth_date) = 12
		AND	DAY(birth_date) = 25)
ORDER BY hire_date DESC,birth_date ASC;