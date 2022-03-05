###############################################################
###############################################################
-- Guided Project: Mastering SQL Subqueries
###############################################################
###############################################################


#############################
-- Task One: Getting Started
-- In this task, we will retrieve data from the tables in the
-- employees database
#############################

-- 1.1: Retrieve all the data from tables in the employees database
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM customers;
SELECT * FROM sales;

#############################
-- Task Two: Subquery in the WHERE clause
-- In this task, we will learn how to use a 
-- subquery in the WHERE clause
#############################

-- 2.1: Retrieve a list of all employees that are not managers
select *  
from employees 
where emp_no not in (select emp_no from dept_manager);

-- 2.2: Retrieve all columns in the sales table for customers above 60 years old

-- Returns the count of customers
SELECT customer_id, COUNT(*)
FROM sales
GROUP BY customer_id
ORDER BY COUNT(*) DESC;

-- Solution
select * from sales
where customer_id IN (select distinct customer_id 
					  from customers where age>60);

					  
-- 2.3: Retrieve a list of all manager's employees number, first and last names
-- Returns all the data from the dept_manager table
SELECT * FROM dept_manager;

-- Solution

-- Using Join
select e.emp_no, e.first_name, e.last_name
from employees e
join dept_manager m
on e.emp_no=m.emp_no;

-- Using Subquery
select emp_no, first_name, last_name
from employees
where emp_no in (select emp_no from dept_manager)

-- Exercise 2.2: Retrieve a list of all managers that were 
-- employed between 1st January, 1990 and 1st January, 1995
select * from dept_manager
where emp_no in (select emp_no 
				 from employees where hire_date between '1990-01-01' And  '1995-01-01');
								 

#############################
-- Task Three: Subquery in the FROM clause
-- In this task, we will learn how to use a 
-- subquery in the FROM clause
#############################

-- 3.1: Retrieve a list of all customers living in the southern region
select * from customers where region='South';

-- 3.2: Retrieve a list of managers and their department names

-- Returns all the data from the dept_manager table
SELECT * FROM dept_manager;

-- Solution
select m.*,d.dept_name
from dept_manager m,
(select dept_no,dept_name from departments)d
where m.dept_no=d.dept_no;
							  

-- Exercise 3.1: Retrieve a list of managers, their first, last, and their department names

-- Returns data from the employees table
SELECT * FROM employees;

-- Solution
select m.*, e.first_name, e.last_name, d.dept_name
from dept_manager m, (select dept_name, dept_no from departments)d,
(select emp_no, first_name, last_name from employees)e
where e.emp_no= m.emp_no And m.dept_no=d.dept_no;

#############################
-- Task Four: Subquery in the SELECT clause
-- In this task, we will learn how to use a 
-- subquery in the SELECT clause
#############################

-- 4.1: Retrieve the first name, last name and average salary of all employees
select first_name, last_name, (Select round(avg(salary),2) as avg_salary
							   from salaries)
from employees;

-- Exercise 4.1: Retrieve a list of customer_id, product_id, order_line and the name of the customer

-- Returns data from the sales and customers tables
SELECT * FROM sales
ORDER BY customer_id;

SELECT * FROM customers;

-- Solution
select customer_id, product_id, order_line, (select customer_name from customers c
											where s.customer_id=c.customer_id)
from sales s
order by customer_id;

#############################
-- Task Five: Subquery Exercises - Part 1
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 5.1: Return a list of all employees who are in Customer Service department

-- Returns data from the dept_emp and departments tables
SELECT * FROM dept_emp;
SELECT * FROM departments;

-- Solution
select * from dept_emp
where dept_no in (select dept_no from departments where dept_name ='Customer Service');

-- Exercise 5.2: Include the employee number, first and last names
select e.emp_no, e.last_name, e.first_name,  b.dept_no, b.from_date, b.to_date
from employees e
join
(select * from dept_emp
where dept_no in (select dept_no from departments d where dept_name ='Customer Service')) b
on e.emp_no= b.emp_no;

-- Exercise 5.3: Retrieve a list of all managers who became managers after 
-- the 1st of January, 1985 and are in the Finance or HR department

-- Returns data from the departments and dept_manager tables
SELECT * FROM departments;
SELECT * FROM dept_manager
WHERE from_date > '1985-01-01';

-- Solution
select * from dept_manager
where from_date>'1985-01-01' 
and dept_no in (select dept_no from departments where 
				dept_name= 'Finance' or dept_name ='Human Resources');
										
-- Exercise 5.4: Retrieve a list of all employees that earn above 120,000
-- and are in the Finance or HR departments

-- Retrieve a list of all employees that earn above 120,000
SELECT emp_no, salary FROM salaries
WHERE salary > 120000;

-- Solution
select emp_no,salary from salaries
where salary > 120000
and emp_no in (select emp_no from dept_emp where
			   dept_no= 'd002' or dept_no='d003');


-- Alternative Solution
SELECT emp_no, salary FROM salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
				WHERE dept_no IN ('d002','d003'));

-- Exercise 5.5: Retrieve the average salary of these employees
SELECT emp_no, round(avg(salary),2) as avg_salary from salaries
WHERE salary > 120000
AND emp_no IN (SELECT emp_no FROM dept_emp
				WHERE dept_no IN ('d002','d003'))
group by emp_no;


#############################
-- Task Six: Subquery Exercises - Part Two
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 6.1: Return a list of all employees number, first and last name.
-- Also, return the average salary of all the employees and average salary
-- of each employee

-- Retrieve all the records in the salaries table
SELECT * FROM salaries;

-- Return the employee number, first and last names and average
-- salary of all employees
SELECT e.emp_no, e.first_name, e.last_name, 
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN salaries s
ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- Returns the employee number and average salary of each employee
SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no;

-- Solution
SELECT e.emp_no, e.first_name, e.last_name, b.emp_avg_salary,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no) as b 
on e.emp_no= b.emp_no;


-- Exercise 6.2: Find the difference between an employee's average salary
-- and the average salary of all employees
SELECT e.emp_no, e.first_name, e.last_name, b.emp_avg_salary,
(SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary, 
b.emp_avg_salary-(select round(avg(salary),2)from salaries) as avg_salary_difference
FROM employees e
JOIN (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
FROM salaries
GROUP BY emp_no
ORDER BY emp_no) as b 
on e.emp_no= b.emp_no
order by e.emp_no;



-- Exercise 6.3: Find the difference between the maximum salary of employees
-- in the Finance or HR department and the maximum salary of all employees

SELECT e.emp_no, e.first_name, e.last_name, a.emp_max_salary,
(SELECT MAX(salary) max_salary FROM salaries), 
(SELECT MAX(salary) max_salary FROM salaries) - a.emp_max_salary salary_diff
FROM employees e
JOIN (SELECT s.emp_no, MAX(salary) AS emp_max_salary
				   FROM salaries s
				   GROUP BY s.emp_no
				   ORDER BY s.emp_no) a
ON e.emp_no = a.emp_no
WHERE e.emp_no IN (SELECT emp_no FROM dept_emp WHERE dept_no IN ('d002', 'd003'))
ORDER BY emp_no;


#############################
-- Task Seven: Subquery Exercises - Part Three
-- In this task, we will try our hands on more 
-- exercises on subqueries
#############################

-- Exercise 7.1: Retrieve the salary that occured most

-- Returns a list of the count of salaries
SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary
order by count(*) desc
limit 1;

-- Solution
select a.salary from 
(SELECT salary, COUNT(*)
FROM salaries
GROUP BY salary
order by count(*) desc
limit 1) a;

-- Exercise 7.2: Find the average salary excluding the highest and
-- the lowest salaries

-- Returns the average salary of all employees
SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries

-- Solution
SELECT ROUND(AVG(salary), 2) avg_salary from salaries
where salary not in (
	(select max(salary) from salaries), 
	(select min(salary) from salaries)
);


-- Exercise 7.3: Retrieve a list of customers id, name that have
-- bought the most from the store

-- Returns a list of customer counts
SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC;
	 
-- Solution
select c.customer_id, c.customer_name, a.cust_count
from customers c, (SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC) as a
where c.customer_id= a.customer_id
order by a.cust_count desc;


-- Exercise 7.4: Retrieve a list of the customer name and segment
-- of those customers that bought the most from the store and
-- had the highest total sales

-- Returns a list of customer counts and total sales
SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC;

-- Solution
select c.customer_id, c.customer_name, a.cust_count,c.segment,a.total_sales from customers c,
(SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC) as a
where c.customer_id= a.customer_id
ORDER BY total_sales DESC, cust_count DESC

