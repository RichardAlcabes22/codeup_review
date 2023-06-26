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