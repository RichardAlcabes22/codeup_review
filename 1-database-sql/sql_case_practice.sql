USE employees;
SHOW TABLES;
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM dept_emp LIMIT 5;
SELECT * FROM dept_manager LIMIT 5;
SELECT * FROM salaries LIMIT 5;
SELECT * FROM titles LIMIT 5;

-- IF function: good for Binary designations
SELECT dept_name,
		IF(dept_name LIKE '%re%',True,False) AS is_re
FROM departments
;
-- CASE Statement: more levels to each factor
SELECT dept_name,
		CASE dept_name
			WHEN 'research' THEN 'Development'
            WHEN 'marketing' THEN 'Sales'
            ELSE dept_name
		END AS dept_group
FROM departments
;
-- CASE another way to use CASE: specify the column in each CASE STATEMENT instead of preceding all CASE statements:
SELECT dept_name,
		CASE
			WHEN dept_name IN ('research','development') THEN 'R&D'
            WHEN dept_name IN ('sales','marketing') THEN 'Sales & Marketing'
            WHEN dept_name IN ('Production','Quality Management') THEN 'Prod & QM'
            ELSE dept_name
		END AS dept_group
FROM departments
;
-- Here we build a PIVOT TABLE:

SELECT dept_name,
		CASE WHEN title = 'Senior Engineer' THEN title ELSE NULL END AS SE,
        CASE WHEN title = 'Staff' THEN title ELSE NULL END AS S,
        CASE WHEN title = 'Engineer' THEN title ELSE NULL END AS E,
        CASE WHEN title = 'Senior Staff' THEN title ELSE NULL END AS SS,
        CASE WHEN title = 'Assistant Engineer' THEN title ELSE NULL END AS AE,
        CASE WHEN title = 'Technique Leader' THEN title ELSE NULL END AS TL,
        CASE WHEN title = 'Manager' THEN title ELSE NULL END AS M
FROM departments
	JOIN dept_emp
      USING(dept_no)
	JOIN titles
      USING(emp_no)
;

SELECT dept_name,
		COUNT(CASE WHEN title = 'Senior Engineer' THEN title ELSE NULL END) AS SE,
        COUNT(CASE WHEN title = 'Staff' THEN title ELSE NULL END) AS S,
        COUNT(CASE WHEN title = 'Engineer' THEN title ELSE NULL END) AS E,
        COUNT(CASE WHEN title = 'Senior Staff' THEN title ELSE NULL END) AS SS,
        COUNT(CASE WHEN title = 'Assistant Engineer' THEN title ELSE NULL END) AS AE,
        COUNT(CASE WHEN title = 'technique Leader' THEN title ELSE NULL END) AS TL,
        COUNT(CASE WHEN title = 'Manager' THEN title ELSE NULL END) AS M
FROM departments
	JOIN dept_emp
      USING(dept_no)
	JOIN titles
      USING(emp_no)
GROUP BY dept_name
ORDER BY dept_name
;

-- now we filter for CURRENT numbers in the JOIN STATEMENTS
SELECT dept_name,
		COUNT(CASE WHEN title = 'Senior Engineer' THEN title ELSE NULL END) AS SE,
        COUNT(CASE WHEN title = 'Staff' THEN title ELSE NULL END) AS S,
        COUNT(CASE WHEN title = 'Engineer' THEN title ELSE NULL END) AS E,
        COUNT(CASE WHEN title = 'Senior Staff' THEN title ELSE NULL END) AS SS,
        COUNT(CASE WHEN title = 'Assistant Engineer' THEN title ELSE NULL END) AS AE,
        COUNT(CASE WHEN title = 'technique Leader' THEN title ELSE NULL END) AS TL,
        COUNT(CASE WHEN title = 'Manager' THEN title ELSE NULL END) AS M
FROM departments
	JOIN dept_emp
      ON departments.dept_no = dept_emp.dept_no AND dept_emp.to_date > CURDATE()
	JOIN titles
      ON dept_emp.emp_no = titles.emp_no AND titles.to_date > CURDATE()
GROUP BY dept_name
ORDER BY dept_name
;