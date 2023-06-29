USE employees;
SHOW TABLES;
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM dept_emp LIMIT 5;
SELECT * FROM dept_manager LIMIT 5;
SELECT * FROM salaries LIMIT 5;
SELECT * FROM titles LIMIT 5;

-- is_current?

SELECT e.emp_no,de.dept_no,de.from_date,de.to_date,
		IF (MAX(de.to_date) > CURDATE(),1,0) AS is_current
FROM employees AS e
	JOIN dept_emp AS de
      USING(emp_no)
GROUP BY e.emp_no,de.dept_no
;

-- create and populate alpha_group column

SELECT last_name,first_name,
		CASE 
			WHEN SUBSTR(last_name,1,1) BETWEEN 'a' AND 'h' THEN 'A-H'
            WHEN SUBSTR(last_name,1,1) BETWEEN 'i' AND 'q' THEN 'I-Q'
            WHEN SUBSTR(last_name,1,1) BETWEEN 'r' AND 'z' THEN 'R-Z'
		END AS alpha_group
FROM employees
-- LIMIT 10
;

SELECT 
		CASE 
			WHEN SUBSTR(last_name,1,1) BETWEEN 'a' AND 'h' THEN 'A-H'
            WHEN SUBSTR(last_name,1,1) BETWEEN 'i' AND 'q' THEN 'I-Q'
            WHEN SUBSTR(last_name,1,1) BETWEEN 'r' AND 'z' THEN 'R-Z'
		END AS alpha_group,
        COUNT(*)
FROM employees
GROUP BY alpha_group
;
-- number of employees born in each decade?
SELECT 
		CASE 
			WHEN YEAR(birth_date) BETWEEN 1950 AND 1959 THEN '50s'
            WHEN YEAR(birth_date) BETWEEN 1960 AND 1969 THEN '60s'
		END AS decade,
        COUNT(*)
FROM employees
GROUP BY decade
;
SELECT MAX(birth_date) FROM employees;

-- current avg_sal for each group; RD SM PrQM, FiHR,CS

SELECT d.dept_name,
	CASE
       WHEN d.dept_name IN ('research', 'development') THEN 'R&D'
       WHEN d.dept_name IN ('sales', 'marketing') THEN 'Sales & Marketing'
       WHEN d.dept_name IN ('Production', 'Quality Management') THEN 'Prod & QM'
       WHEN d.dept_name IN ('Finance', 'Human Resources') THEN 'Finance & HR'
       ELSE d.dept_name
	END AS dept_group,
        ROUND(AVG(s.salary),0) AS cur_avg_sal
FROM dept_emp AS de
	JOIN departments AS d
      USING(dept_no)
	JOIN employees AS e
      USING(emp_no)
	JOIN salaries AS s
      ON e.emp_no = s.emp_no AND s.to_date > CURDATE()
GROUP BY dept_group,d.dept_name
ORDER BY dept_group
;