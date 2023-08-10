USE join_example_db;
SHOW TABLES;
SELECT users.name AS user,roles.name AS role
FROM users
	JOIN roles
	 ON users.role_id = roles.id;
DESCRIBE users;
DESCRIBE roles;
SELECT * FROM users LIMIT 5;
SELECT * FROM roles LIMIT 5;
SELECT users.name AS user, roles.name AS role
FROM users
	LEFT JOIN roles
          ON  users.role_id = roles.id;
SELECT roles.name AS role,users.name AS user
FROM roles
	LEFT JOIN users
          ON  roles.id = users.role_id;
          
-- list of roles and total users for each role
SELECT roles.name AS role,COUNT(users.name) AS total_users
FROM roles
	JOIN users
     ON  roles.id = users.role_id
GROUP BY role;

USE employees;
SHOW TABLES;
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM dept_emp LIMIT 5;
SELECT * FROM dept_manager LIMIT 5;
SELECT * FROM salaries LIMIT 5;
SELECT * FROM titles LIMIT 5;

-- each department with CURRENT manager
SELECT dept_name,CONCAT(last_name,', ',first_name) AS manager
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
WHERE YEAR(dm.to_date) = 9999
;
-- name of depts currently managed by women:
SELECT dept_name,CONCAT(last_name,', ',first_name) AS manager
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
WHERE YEAR(dm.to_date) = 9999
		AND e.gender = 'F'
;
-- current titles of employees working in CustService:
SELECT title, COUNT(de.emp_no)
FROM titles AS t
	JOIN dept_emp AS de
      USING(emp_no)
	JOIN departments AS d
      USING(dept_no)
WHERE YEAR(t.to_date) = 9999
	AND YEAR(de.to_date) = 9999
	AND d.dept_name = 'Customer Service'
GROUP BY t.title
ORDER BY title;
-- current salary of all current managers:
SELECT dept_name,
		CONCAT(last_name,', ',first_name) AS manager,
        s.salary
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
	JOIN salaries AS s
      USING(emp_no)
WHERE YEAR(dm.to_date) = 9999
	AND YEAR(s.to_date) = 9999
-- ORDER BY d.dept_no;
-- current employee count for each dept:
SELECT d.dept_no, d.dept_name,COUNT(de.emp_no)
FROM departments AS d
	JOIN dept_emp AS de
      ON d.dept_no = de.dept_no
WHERE YEAR(de.to_date) = 9999
GROUP BY dept_name
ORDER BY d.dept_no
;
-- department with highest current avg salary?
SELECT d.dept_no, d.dept_name,COUNT(de.emp_no),ROUND(AVG(s.salary),2) AS avg_curr_sal
FROM departments AS d
	JOIN dept_emp AS de
      ON d.dept_no = de.dept_no
	JOIN employees AS e
      ON de.emp_no = e.emp_no
	JOIN salaries AS s
      ON e.emp_no = s.emp_no
WHERE YEAR(de.to_date) = 9999
	AND YEAR(s.to_date) = 9999
GROUP BY dept_name
ORDER BY avg_curr_sal DESC
;
-- who is highest paid in Marketing dept?:
SELECT CONCAT(last_name,', ',first_name) AS emp_name, s.salary
FROM departments AS d
	JOIN dept_emp AS de
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
	JOIN salaries AS s
      ON e.emp_no = s.emp_no
WHERE d.dept_name = 'Marketing'
	AND YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
LIMIT 5
;
-- current dept manager with highest sal?:
SELECT dept_name,
		CONCAT(last_name,', ',first_name) AS manager,
        s.salary
FROM departments AS d
	JOIN dept_manager AS dm
	  USING (dept_no)
	JOIN employees AS e
      USING (emp_no)
	JOIN salaries AS s
      USING(emp_no)
WHERE YEAR(dm.to_date) = 9999
	AND YEAR(s.to_date) = 9999
ORDER BY s.salary DESC
;
-- avg salary for each dept using ALL historical salaries:
SELECT d.dept_no, d.dept_name,ROUND(AVG(s.salary),2) AS avg_hist_sal
FROM departments AS d
	JOIN dept_emp AS de
      ON d.dept_no = de.dept_no
	JOIN employees AS e
      ON de.emp_no = e.emp_no
	JOIN salaries AS s
      ON e.emp_no = s.emp_no
GROUP BY dept_name
ORDER BY avg_hist_sal DESC
;
-- find names of all curr emps, their dept, and their curr manager:
SELECT e.last_name, e.first_name, d.dept_name,m.manager
FROM employees AS e
	JOIN dept_emp AS de
      USING (emp_no)
	JOIN departments AS d
      USING(dept_no)
					JOIN (SELECT dept_name,CONCAT(last_name,', ',first_name) AS manager
							FROM departments AS d
								JOIN dept_manager AS dm
								  USING (dept_no)
								JOIN employees AS e
								  USING (emp_no)
							WHERE YEAR(dm.to_date) = 9999) AS m
						ON d.dept_name = m.dept_name
WHERE YEAR(de.to_date) = 9999
;