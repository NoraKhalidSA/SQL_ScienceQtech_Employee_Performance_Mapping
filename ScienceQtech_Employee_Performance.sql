
/* 1. Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
SQL code: */


CREATE DATABASE employee; USE employee;





/* 2. Create an ER diagram for the given employee database. SQL code:
DESCRIBE data_science_team;
DESCRIBE emp_record_table;
DESCRIBE proj_table; */
-- ------------------------------------------------------------------------
ALTER TABLE emp_record_table ADD primary key (EMP_ID);
ALTER TABLE emp_record_table MODIFY EMP_ID VARCHAR(30);
ALTER TABLE data_science_team MODIFY EMP_ID VARCHAR(30);
ALTER TABLE data_science_team MODIFY EMP_ID VARCHAR(30);
ALTER TABLE proj_table
MODIFY PROJECT_ID VARCHAR(50);
ALTER TABLE emp_record_table MODIFY PROJ_ID VARCHAR(50);
ALTER TABLE proj_table
ADD primary key (PROJECT_ID);
ALTER TABLE emp_record_table
ADD foreign key (PROJ_ID) REFERENCES proj_table(PROJECT_ID);
ALTER TABLE emp_record_table
ADD FOREIGN KEY(PROJ_ID) REFERENCES proj_table(PROJECT_ID);
ALTER TABLE data_science_team
ADD FOREIGN KEY(EMP_ID)
REFERENCES emp_record_table(EMP_ID);



/* 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
SQL code: */


SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table;


/* 4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is:
less than two
greater than four between two and four
SQL code:*/




SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2 OR EMP_RATING > 4 OR (EMP_RATING >= 2 AND EMP_RATING <= 4);


/*5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
SQL code:*/


SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME FROM emp_record_table
WHERE DEPT = 'Finance';



/*6. Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
SQL code:*/


SELECT e.EMP_ID , e.FIRST_NAME , e.LAST_NAME, e.DEPT, e.MANAGER_ID, p.PROJECT_ID FROM emp_record_table e
INNER JOIN proj_table p
WHERE e.ROLE NOT IN ("MANAGER","PRESIDENT","CEO")
ORDER BY e.MANAGER_ID;


/*7. Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
SQL code:*/


SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table
WHERE DEPT = 'Healthcare'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT FROM emp_record_table
WHERE DEPT = 'Finance';




/*8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
SQL code:*/


SELECT e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.ROLE, e.DEPT, e.EMP_RATING, m.MAX_EMP_RATING
FROM emp_record_table e JOIN (
SELECT DEPT, MAX(EMP_RATING) AS MAX_EMP_RATING FROM emp_record_table
GROUP BY DEPT
) m ON e.DEPT = m.DEPT;



/*9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
SQL code:*/


SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY FROM emp_record_table
GROUP BY ROLE;


/*10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
SQL code:*/


SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, RANK() OVER (ORDER BY EXP DESC) AS EMP_RANK
FROM emp_record_table;


/*11. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
SQL code:*/



CREATE VIEW high_salary_employees_view AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY FROM emp_record_table
WHERE SALARY > 6000;


/*12. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
SQL code:*/


SELECT *
FROM emp_record_table WHERE EMP_ID IN (
SELECT EMP_ID
FROM emp_record_table WHERE EXP > 10
);



/*13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
SQL code:*/


DELIMITER &&
CREATE PROCEDURE get_experience()
BEGIN
SELECT * FROM emp_record_table WHERE EXP > 3; END &&
DELIMITER ;


/*14. Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
SQL code:*/




SELECT dt.EMP_ID, dt.FIRST_NAME, dt.LAST_NAME, dt.EXP,
CASE
WHEN dt.EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
WHEN dt.EXP > 2 AND dt.EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST' WHEN dt.EXP > 5 AND dt.EXP <= 10 THEN 'SENIOR DATA SCIENTIST' WHEN dt.EXP > 10 AND dt.EXP <= 12 THEN 'LEAD DATA SCIENTIST' WHEN dt.EXP > 12 AND dt.EXP <= 16 THEN 'MANAGER'
END AS JOB_PROFILE FROM
data_science_team dt LEFT JOIN
(

SELECT
PROJECT_ID,
ROW_NUMBER() OVER (PARTITION BY PROJECT_ID ORDER BY START_DATE DESC) AS rn
FROM proj_table
) pt ON dt.EMP_ID = pt.PROJECT_ID AND pt.rn = 1;





/*15. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
SQL code:*/



CREATE INDEX idx_FIRST_NAME ON emp_record_table (FIRST_NAME(255));



/*16. Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
SQL code:*/

SELECT EMP_ID, FIRST_NAME, SALARY, EMP_RATING, (0.05 * SALARY * EMP_RATING) AS bonus
FROM emp_record_table;


/*17. Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
SQL code:*/

SELECT CONTINENT, COUNTRY, AVG(SALARY) AS average_salary FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;



