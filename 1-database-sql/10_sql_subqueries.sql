USE employees;
SHOW TABLES;
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM dept_emp LIMIT 5;
SELECT * FROM dept_manager LIMIT 5;
SELECT * FROM salaries LIMIT 5;
SELECT * FROM titles LIMIT 5;

-- find all employees with same hire date as emp_no 101010

SELECT emp_no, hire_date
FROM employees
WHERE emp_no = 101010;

SELECT emp_no, hire_date
FROM employees AS e
	JOIN salaries AS s
      USING(emp_no)
WHERE hire_date = (SELECT hire_date
					FROM employees
					WHERE emp_no = 101010)
	AND YEAR(s.to_date) = 9999
;

-- all titles ever held by all CURRENT emps with first name Aamod:
SELECT e.emp_no,first_name,last_name
FROM employees AS e
	JOIN titles AS t
      ON e.emp_no = t.emp_no
WHERE YEAR(t.to_date) = 9999
	AND e.first_name = 'Aamod'
;

SELECT ename.emp_no, ename.first_name,ename.last_name,t.title
FROM (SELECT e.emp_no,first_name,last_name
		FROM employees AS e
			JOIN titles AS t
			  ON e.emp_no = t.emp_no
		WHERE YEAR(t.to_date) = 9999
			AND e.first_name = 'Aamod') AS ename
	JOIN titles AS t
	  ON ename.emp_no = t.emp_no
;

-- how many FORMER employees in employee table?
SELECT emp_no,MAX(to_date) AS last_date
FROM salaries
GROUP BY emp_no
HAVING last_date < CURDATE();

SELECT COUNT(*)
FROM (
		SELECT emp_no,MAX(to_date) AS last_date
		FROM salaries
		GROUP BY emp_no
		HAVING last_date < CURDATE()
        ) AS former
;

-- current dept managers that are female
-- name of depts currently managed by women:
SELECT dept_name,CONCAT(last_name,', ',first_name) AS manager, e.gender
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
WHERE YEAR(dm.to_date) = 9999
		AND e.gender = 'F'
;

-- all emps with CURRENT salary greater than overall company historical avg:

SELECT ROUND(AVG(salary),2)
FROM salaries;

SELECT s.emp_no, s.salary
FROM salaries AS s
WHERE YEAR(s.to_date) = 9999
	AND s.salary > (
					SELECT ROUND(AVG(salary),2)
					FROM salaries
                    )
ORDER BY s.salary;

-- number of CURRENT salaries that are within 1 STD of CURRENT highest salary?
-- curr std
SELECT ROUND(STDDEV(salary),2)
FROM salaries
WHERE YEAR(to_date) = 9999
;
-- all sals ordered by sal
SELECT s.emp_no, s.salary
FROM salaries AS s
WHERE YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
;
-- top curr_sal
SELECT s.salary
FROM salaries AS s
WHERE YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
LIMIT 1
;
-- all sals >= (highest_sal - stddev)
SELECT s.emp_no, s.salary
FROM salaries AS s
WHERE YEAR(s.to_date) = 9999
	AND s.salary >= (SELECT s.salary
						FROM salaries AS s
						WHERE YEAR(s.to_date) = 9999
						ORDER BY s.salary DESC
						LIMIT 1)
					- (SELECT ROUND(STDDEV(salary),2)
						FROM salaries
						WHERE YEAR(to_date) = 9999)
ORDER BY s.salary DESC
;

SELECT COUNT(*)
FROM (SELECT s.emp_no, s.salary
		FROM salaries AS s
		WHERE YEAR(s.to_date) = 9999
			AND s.salary >= (SELECT s.salary
								FROM salaries AS s
								WHERE YEAR(s.to_date) = 9999
								ORDER BY s.salary DESC
								LIMIT 1)
							- (SELECT ROUND(STDDEV(salary),2)
								FROM salaries
								WHERE YEAR(to_date) = 9999)
		ORDER BY s.salary DESC) AS highest
;
-- what % of all curr_sals does this represent?

SELECT 
		(SELECT COUNT(*)
		FROM (SELECT s.emp_no, s.salary
				FROM salaries AS s
				WHERE YEAR(s.to_date) = 9999
					AND s.salary >= (SELECT s.salary
										FROM salaries AS s
										WHERE YEAR(s.to_date) = 9999
										ORDER BY s.salary DESC
										LIMIT 1)
									- (SELECT ROUND(STDDEV(salary),2)
										FROM salaries
										WHERE YEAR(to_date) = 9999)
				ORDER BY s.salary DESC) AS highest)
/
(SELECT COUNT(*)
FROM (SELECT salary FROM salaries WHERE YEAR(to_date) = 9999) AS curr_sals)
;

-- dept names with curr_manager that is Female
SELECT dept_name
-- ,CONCAT(last_name,', ',first_name) AS manager, e.gender
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
WHERE YEAR(dm.to_date) = 9999
		AND e.gender = 'F'
;
-- first and last names of employee with highest salary:
SELECT e.first_name,e.last_name,s.salary
FROM salaries AS s
	JOIN employees AS e
      USING(emp_no)
WHERE YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
LIMIT 1
;
-- dept that employee with highest sal works in?
SELECT e.first_name,e.last_name,s.salary,d.dept_name
FROM salaries AS s
	JOIN employees AS e
      USING(emp_no)
	JOIN dept_emp AS de
      USING(emp_no)
	JOIN departments AS d
	  USING(dept_no)
WHERE YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
LIMIT 1
;
-- highest paid employee in each dept:
SELECT d.dept_name,MAX(s.salary)
FROM salaries AS s
	JOIN employees AS e
      USING(emp_no)
	JOIN dept_emp AS de
      USING(emp_no)
	JOIN departments AS d
	  USING(dept_no)
WHERE YEAR(s.to_date) = 9999
	AND YEAR(de.to_date) = 9999
GROUP BY d.dept_name
;

SELECT e.first_name, e.last_name
FROM salaries AS s
	JOIN employees AS e
      USING(emp_no)
	JOIN dept_emp AS de
      USING(emp_no)
	JOIN departments AS d
	  USING(dept_no)
WHERE d.dept_name = (SELECT d.dept_name
						FROM salaries AS s
							JOIN employees AS e
							  USING(emp_no)
							JOIN dept_emp AS de
							  USING(emp_no)
							JOIN departments AS d
							  USING(dept_no)
						WHERE YEAR(s.to_date) = 9999
							AND YEAR(de.to_date) = 9999
						GROUP BY d.dept_name)
	AND s.salary = (SELECT MAX(s.salary)
						FROM salaries AS s
							JOIN employees AS e
							  USING(emp_no)
							JOIN dept_emp AS de
							  USING(emp_no)
							JOIN departments AS d
							  USING(dept_no)
						WHERE YEAR(s.to_date) = 9999
							AND YEAR(de.to_date) = 9999
						GROUP BY d.dept_name)
;
