USE employees;
SHOW TABLES;
SELECT *
FROM titles
LIMIT 5;
DESCRIBE employees.titles;

-- use DISTINCT to find unique titltes in table
SELECT DISTINCT title
FROM titles;
SELECT COUNT(DISTINCT title)
FROM titles;
SELECT title
FROM titles
GROUP BY title;

-- list unique names start and end with 'e' using group by
SELECT last_name
FROM employees
WHERE 	last_name LIKE 'e%'
	AND	last_name LIKE '%e'
GROUP BY last_name;
-- find unique combos of first and last names for emp with last_name start and end with 'e':
SELECT last_name,first_name
FROM employees
WHERE 	last_name LIKE 'e%'
	AND	last_name LIKE '%e'
GROUP BY last_name, first_name
ORDER BY last_name, first_name;
-- Find unique with q BUT NOT QU!:
SELECT DISTINCT last_name
FROM employees
WHERE 	last_name LIKE '%q%'
	AND	last_name NOT LIKE '%qu%';
-- add a COUNT to above query to find # of employees with each last_name:
SELECT last_name,COUNT(last_name)
FROM employees
WHERE	last_name LIKE '%q%'
	AND	last_name NOT LIKE '%qu%'
GROUP BY last_name;
-- Irena,Vidya,Maya use COUNT and GROUP BY to count each name/gender combo:
SELECT first_name,gender,COUNT(*)AS Total
FROM employees
WHERE first_name IN ('Irena','Vidya','Maya')
GROUP BY first_name,gender
ORDER BY first_name,gender;
-- count unique usernames created with heuristic:
SELECT LOWER(CONCAT(SUBSTR(first_name,1,1),
					SUBSTR(last_name,1,4),
					'_',
					SUBSTR(birth_date,6,2),
					SUBSTR(birth_date,3,2))) AS username,
		COUNT(*) AS count
FROM employees
GROUP BY username
ORDER BY count DESC, username;

-- dups? max dups? how many duplicate usernames
SELECT LOWER(CONCAT(SUBSTR(first_name,1,1),
					SUBSTR(last_name,1,4),
					'_',
					SUBSTR(birth_date,6,2),
					SUBSTR(birth_date,3,2))) AS username,
		COUNT(*) AS count
FROM employees
GROUP BY username
HAVING count > 1
ORDER BY count DESC, username;
SELECT COUNT(*)
	FROM (SELECT LOWER(CONCAT(SUBSTR(first_name,1,1),
						SUBSTR(last_name,1,4),
						'_',
						SUBSTR(birth_date,6,2),
						SUBSTR(birth_date,3,2))) AS username,
			COUNT(*) AS count
	FROM employees
	GROUP BY username
	HAVING count > 1
	ORDER BY count DESC, username) AS a
;
SELECT SUM(count)
	FROM (SELECT LOWER(CONCAT(SUBSTR(first_name,1,1),
						SUBSTR(last_name,1,4),
						'_',
						SUBSTR(birth_date,6,2),
						SUBSTR(birth_date,3,2))) AS username,
			COUNT(*) AS count
	FROM employees
	GROUP BY username
	HAVING count > 1
	ORDER BY count DESC, username) AS a
;

-- AVG of all salaries for each employee:
SELECT *
FROM salaries
LIMIT 5;
SELECT emp_no,ROUND(AVG(salary),2) AS avg
FROM salaries
GROUP BY emp_no;
-- number of current emps in each dept:
SELECT *
FROM dept_emp
LIMIT 5;
SELECT dept_no,COUNT(emp_no) AS total_count
FROM dept_emp
WHERE YEAR(to_date) = 9999
GROUP BY dept_no;
-- how many salaries has each emp had over time?:
SELECT emp_no,COUNT(salary) AS total_count_sal
FROM salaries
GROUP BY emp_no
;
-- max salary for each employee:
SELECT emp_no,MAX(salary) AS max_sal
FROM salaries
GROUP BY emp_no
LIMIT 10;
-- min salary for each employee:
SELECT emp_no,MIN(salary) AS min_sal
FROM salaries
GROUP BY emp_no
LIMIT 10;
-- std salary for each employee:
SELECT emp_no,ROUND(STD(salary),2) AS std_dev_sal
FROM salaries
GROUP BY emp_no
LIMIT 10;
-- max salary for each employee where max > 150k:
SELECT emp_no,MAX(salary) AS max_sal
FROM salaries
GROUP BY emp_no
HAVING max_sal > 150000
LIMIT 10;
-- AVG sal for each employee where AVG between 80k and 90k:
SELECT emp_no,ROUND(AVG(salary),2) AS avg
FROM salaries
GROUP BY emp_no
HAVING avg BETWEEN 80000 AND 90001
ORDER BY avg DESC;