SELECT CONCAT('Hello ', 'Codeup', '!');
SELECT CURRENT_TIMESTAMP();
SELECT NOW();
SELECT CURDATE();
SELECT CURTIME();
SELECT UNIX_TIMESTAMP();
SELECT UNIX_TIMESTAMP('1970-01-01 23:59:59');

USE employees;
SHOW TABLES;
SELECT *
FROM employees
LIMIT 5;
DESCRIBE employees.employees;

-- last_name starts AND ends with 'e', ORDER BY emp_no, CONCAT to combine given and surname:
SELECT emp_no,last_name, first_name, CONCAT(first_name,' ',last_name) AS Full_Name 
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e'
ORDER BY emp_no;
-- Convert the Full_Name to all UPPERCASE:
SELECT emp_no, UPPER(CONCAT(first_name,' ',last_name)) AS Full_Name_Uppercase 
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e'
ORDER BY emp_no;
-- Use a function to determine # of rows returned:
SELECT COUNT(*)
FROM employees
WHERE 	last_name LIKE 'E%'
	AND last_name LIKE '%e'
ORDER BY emp_no;
-- hired 1990s born on XMAS ORDER BY hire_date (DESC) then AGE (DESC) how many days?
SELECT emp_no,birth_date,last_name,first_name,hire_date,DATEDIFF(CURDATE(),hire_date) AS days_employed
FROM employees
WHERE 	(YEAR(hire_date) BETWEEN 1990 AND 1999)
	AND	(
		MONTH(birth_date) = 12
		AND	DAY(birth_date) = 25)
ORDER BY hire_date DESC,birth_date ASC;
-- find smallest and largest CURRENT salary:
SELECT *
FROM salaries
LIMIT 5;
SELECT DISTINCT to_date
FROM salaries
;
SELECT *
FROM salaries
WHERE YEAR(to_date) = 9999
;
SELECT MIN(salary) AS MIN,MAX(salary) AS MAX
FROM salaries
WHERE YEAR(to_date) = 9999
;
-- create username for each employee
-- emp first initial, first4 of last_name, an underscore, 2digit birth month, 2digit birth year
SELECT emp_no, first_name, last_name, birth_date, LOWER(CONCAT(SUBSTR(first_name,1,1),
														SUBSTR(last_name,1,4),
                                                        '_',
                                                        SUBSTR(birth_date,6,2),
                                                        SUBSTR(birth_date,3,2))) AS username
FROM employees
LIMIT 5;
SELECT COUNT(*)
FROM employees;
SELECT COUNT(*)
FROM (SELECT DISTINCT LOWER(CONCAT(SUBSTR(first_name,1,1),
														SUBSTR(last_name,1,4),
                                                        '_',
                                                        SUBSTR(birth_date,6,2),
                                                        SUBSTR(birth_date,3,2))) AS username
	FROM employees) AS a
	;