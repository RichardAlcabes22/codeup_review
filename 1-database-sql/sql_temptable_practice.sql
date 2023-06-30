USE employees;
SHOW TABLES;
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;
SELECT * FROM dept_emp LIMIT 5;
SELECT * FROM dept_manager LIMIT 5;
SELECT * FROM salaries LIMIT 5;
SELECT * FROM titles LIMIT 5;

CREATE TEMPORARY TABLE emps_w_depts AS
SELECT emp_no,first_name,last_name,dept_no,dept_name
FROM employees
	JOIN dept_emp
      USING (emp_no)
	JOIN departments
      USING(dept_no)
LIMIT 100
;
CREATE TEMPORARY TABLE my_numbers(
    n INT UNSIGNED NOT NULL 
);
USE employees;
CREATE TEMPORARY TABLE oneil_2101.my_numbers(
    n INT UNSIGNED NOT NULL 
);
USE oneil_2101;
USE employees;
CREATE TEMPORARY TABLE oneil_2101.employees_with_salaries AS 
SELECT * FROM employees JOIN salaries USING(emp_no);
USE oneil_2101;


-- create temp table employees_w_depts
USE employees;
CREATE TEMPORARY TABLE oneil_2101.emps_w_depts AS
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
;
USE oneil_2101;
-- ALTER TABLE by adding full_name col it is pop with nulls
ALTER TABLE emps_w_depts ADD full_name VARCHAR(40);
SELECT *
FROM emps_w_depts
LIMIT 10;
-- UPDATE full_name = CONCAT (firstname,lastname)
UPDATE emps_w_depts
SET full_name = CONCAT(first_name,' ',last_name)
;
-- ALTER TABLE DROP COLUMN
ALTER TABLE emps_w_depts 	DROP first_name,
							DROP last_name;
-- another way to write query to arrive at this result
/*
USE employees;
CREATE TEMPORARY TABLE oneil_2101.emps_w_depts AS
SELECT dept_name,CONCAT(first_name,' ',last_name) AS full_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
;

USE oneil_2101;
*/
DROP TABLE IF EXISTS emps_w_depts;
-- use sakila to create a new temp table
USE sakila;
SELECT * FROM payment LIMIT 5;
DESCRIBE payment;
SELECT CAST((amount * 100) AS UNSIGNED)
FROM payment
LIMIT 5;


CREATE TEMPORARY TABLE oneil_2101.amnt_no_dec AS
SELECT CAST((amount * 100) AS UNSIGNED)
FROM payment
;
USE oneil_2101;
SELECT * FROM amnt_no_dec LIMIT 10;
DROP TABLE IF EXISTS amnt_no_dec;