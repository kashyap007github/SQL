drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert all
into users (user_id,user_name,email) values(1, 'Sumit', 'sumit@gmail.com')
into users (user_id,user_name,email) values(2, 'Reshma', 'reshma@gmail.com')
into users (user_id,user_name,email) values(3, 'Farhana', 'farhana@gmail.com')
into users (user_id,user_name,email) values(4, 'Robin', 'robin@gmail.com')
into users (user_id,user_name,email) values(5, 'Robin', 'robin@gmail.com')
select * from dual;

select * from users;


--1.Write a SQL Query to fetch all the duplicate records in a table
--Record is considered duplicate if a user name is present more than once.
WITH MAIN AS
(
    select u.*,
    row_number() over (partition by user_name order by user_id) as rn
    from
    users  u
    order by u.user_id
),
DUPLICATE
AS
(
  SELECT * FROM MAIN
  WHERE RN>1
)
SELECT * FROM DUPLICATE;




--2. Write a SQL query to fetch the second last record from employee table

drop table employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

INSERT ALL
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(101, 'Mohan', 'Admin', 4000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(102, 'Rajkumar', 'HR', 3000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(103, 'Akbar', 'IT', 4000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(104, 'Dorvin', 'Finance', 6500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(105, 'Rohit', 'HR', 3000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(106, 'Rajesh',  'Finance', 5000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(107, 'Preet', 'HR', 7000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(108, 'Maryam', 'Admin', 4000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(109, 'Sanjay', 'IT', 6500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(110, 'Vasudha', 'IT', 7000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(111, 'Melinda', 'IT', 8000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(112, 'Komal', 'IT', 10000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(113, 'Gautham', 'Admin', 2000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(114, 'Manisha', 'HR', 3000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(115, 'Chandni', 'IT', 4500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(116, 'Satya', 'Finance', 6500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(117, 'Adarsh', 'HR', 3500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(118, 'Tejaswi', 'Finance', 5500)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(119, 'Cory', 'HR', 8000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(120, 'Monica', 'Admin', 5000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(121, 'Rosalin', 'IT', 6000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(122, 'Ibrahim', 'IT', 8000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(123, 'Vikram', 'IT', 8000)
into employee(emp_ID,emp_NAME,DEPT_NAME,SALARY) values(124, 'Dheeraj', 'IT', 11000)
SELECT * FROM DUAL;


select * from employee;


SELECT *
FROM
(
    SELECT E.*,
    ROW_NUMBER() OVER( ORDER BY EMP_ID DESC) RN
    FROM EMPLOYEE E 
)
WHERE RN=2;

 --3.Write a SQL query to display only the details of employees who either earn the highest salary or the lowest 
 --salary in each department from the employee table
WITH MAIN
AS
(
    SELECT E.*,
    FIRST_VALUE(SALARY) OVER(PARTITION BY DEPT_NAME ORDER BY SALARY DESC) MAX_SAL,
    FIRST_VALUE(SALARY) OVER(PARTITION BY DEPT_NAME ORDER BY SALARY ) MIN_SAL
    FROM EMPLOYEE E
),
MAX_MIN_SAL
AS
(
   SELECT *
   FROM MAIN
   WHERE SALARY =MAX_SAL OR SALARY=MIN_SAL
)
SELECT * FROM MAX_MIN_SAL;

--4. From the doctors table, fetch the details of doctors who work in the same hospital but in different specialty


drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);
insert all
into doctors(id,name,speciality,hospital,city,consultation_fee)values(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500)
into doctors(id,name,speciality,hospital,city,consultation_fee)values(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000)
into doctors(id,name,speciality,hospital,city,consultation_fee)values(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000)
into doctors(id,name,speciality,hospital,city,consultation_fee)values(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500)
into doctors(id,name,speciality,hospital,city,consultation_fee)values(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700)
into doctors(id,name,speciality,hospital,city,consultation_fee)values(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500)
select * from dual;


select * from doctors;



SELECT D.*
FROM DOCTORS D
INNER JOIN DOCTORS E
ON D.HOSPITAL=E.HOSPITAL
AND D.SPECIALITY<> E.SPECIALITY;




--5. From the login_details table, fetch the users who logged in consecutively 3 or more times.

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

INSERT ALL
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(101, 'Michael', current_date)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(102, 'James', current_date)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(103, 'Stewart', current_date+1)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(104, 'Stewart', current_date+1)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(105, 'Stewart', current_date+1)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(106, 'Michael', current_date+2)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(107, 'Michael', current_date+2)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(108, 'Stewart', current_date+3)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(109, 'Stewart', current_date+3)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(110, 'James', current_date+4)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(111, 'James', current_date+4)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(112, 'James', current_date+5)
INTO LOGIN_DETAILS(LOGIN_ID,USER_NAME,LOGIN_DATE)VALUES(113, 'James', current_date+6)
SELECT * FROM DUAL;

SELECT * FROM login_details;

WITH MAIN
AS
(
    SELECT LD.*,
    ROW_NUMBER()  OVER(PARTITION BY USER_NAME ORDER BY LOGIN_ID) RN,
    LOGIN_ID - (ROW_NUMBER()  OVER(PARTITION BY USER_NAME ORDER BY LOGIN_ID)) DIFF
    FROM LOGIN_DETAILS LD
    ORDER BY LOGIN_ID
),
MULTIPLE_LOGIN
AS
(
  SELECT M.*,
  COUNT(*) OVER( PARTITION BY DIFF,USER_NAME) NO_OF_TIMES_LOGIN
  FROM MAIN M
),
ANS
AS
(
   SELECT * FROM MULTIPLE_LOGIN
   WHERE NO_OF_TIMES_LOGIN >=3
)
SELECT * FROM ANS;

--METHOD 2

select distinct repeated_names
from (
select LD.*,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details LD) x
where x.repeated_names is not null;


--6. From the students table, write a SQL query to interchange the adjacent student names.
drop table students;

create table students

(
id int primary key,
student_name varchar(50) not null
);

INSERT ALL
into students(ID,STUDENT_NAME) values(1, 'James')
into students(ID,STUDENT_NAME) values(2, 'Michael')
into students(ID,STUDENT_NAME) values(3, 'George')
into students(ID,STUDENT_NAME) values(4, 'Stewart')
into students(ID,STUDENT_NAME) values(5, 'Robin')
SELECT * FROM DUAL;

SELECT * FROM STUDENTS;


SELECT S.*,
CASE WHEN MOD(ID,2)<>0 AND LEAD(STUDENT_NAME) OVER( ORDER BY ID ) IS NULL THEN STUDENT_NAME
     WHEN MOD(ID,2)<>0 THEN LEAD(STUDENT_NAME) OVER( ORDER BY ID ) 
     WHEN MOD(ID,2)=0 THEN LAG(STUDENT_NAME) OVER( ORDER BY ID )
     ELSE  'XX'  END AS ADJ_STUDENT_NAME
FROM STUDENTS S ;


--7. From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more
--Note: Weather is considered to be extremely cold when its temperature is less than zero
drop table weather;
create table weather
(
id int,
city varchar(50),
temperature int,
day_date DATE
);

INSERT ALL
INTO WEATHER(id,city,temperature,day_date) VALUES(1, 'London', -1, to_date('2021-01-01','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(2, 'London', -2, to_date('2021-01-02','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(3, 'London', 4, to_date('2021-01-03','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(4, 'London', 1, to_date('2021-01-04','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(5, 'London', -2, to_date('2021-01-05','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(6, 'London', -5, to_date('2021-01-06','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(7, 'London', -7, to_date('2021-01-07','yyyy-mm-dd'))
INTO WEATHER(id,city,temperature,day_date) VALUES(8, 'London', 5, to_date('2021-01-08','yyyy-mm-dd'))
SELECT * FROM DUAL;

SELECT * FROM WEATHER;


WITH MAIN
AS
(
    SELECT W.*,
    ROW_NUMBER()  OVER( ORDER BY ID) RN,
    ID - (ROW_NUMBER()  OVER( ORDER BY ID)) DIFF
    FROM WEATHER W
    WHERE TEMPERATURE <0
    ORDER BY ID
),
MULTIPLE_DAYS
AS
(
  SELECT M.*,
  COUNT(*) OVER( PARTITION BY DIFF) NO_OF_TIMES_TEMP
  FROM MAIN M
),
ANS
AS
(
   SELECT * FROM MULTIPLE_DAYS
   WHERE NO_OF_TIMES_TEMP >=3
)
SELECT * FROM ANS
ORDER BY ID;

--8. From the following 3 tables (event_category, physician_speciality, patient_treatment), 
--write a SQL query to get the histogram of specialties 
--of the unique physicians who have done the procedures but never did prescribe anything.


drop table event_category;
create table event_category
(
  event_name varchar(50),
  category varchar(100)
);
insert all
into event_category(event_name,category) values ('Chemotherapy','Procedure')
into event_category(event_name,category) values ('Radiation','Procedure')
into event_category(event_name,category) values ('Immunosuppressants','Prescription')
into event_category(event_name,category) values ('BTKI','Prescription')
into event_category(event_name,category) values ('Biopsy','Test')
select * from dual;

select * from event_category;


drop table physician_speciality;
create table physician_speciality
(
  physician_id int,
  speciality varchar(50)
);

insert all
into physician_speciality(physician_id,speciality)  values (1000,'Radiologist')
 into physician_speciality(physician_id,speciality)  values (2000,'Oncologist')
 into physician_speciality(physician_id,speciality)  values (3000,'Hermatologist')
 into physician_speciality(physician_id,speciality)  values (4000,'Oncologist')
 into physician_speciality(physician_id,speciality)  values (5000,'Pathologist')
 into physician_speciality(physician_id,speciality)  values (6000,'Oncologist')
 select * from dual;
 
 drop table patient_treatment;
create table patient_treatment
(
  patient_id int,
  event_name varchar(50),
  physician_id int
);

insert all
 into patient_treatment(patient_id,event_name,physician_id) values (1,'Radiation', 1000)
 into patient_treatment(patient_id,event_name,physician_id) values (2,'Chemotherapy', 2000)
 into patient_treatment(patient_id,event_name,physician_id) values (1,'Biopsy', 1000)
 into patient_treatment(patient_id,event_name,physician_id) values (3,'Immunosuppressants', 2000)
 into patient_treatment(patient_id,event_name,physician_id) values (4,'BTKI', 3000)
 into patient_treatment(patient_id,event_name,physician_id) values (5,'Radiation', 4000)
 into patient_treatment(patient_id,event_name,physician_id) values (4,'Chemotherapy', 2000)
 into patient_treatment(patient_id,event_name,physician_id) values (1,'Biopsy', 5000)
 into patient_treatment(patient_id,event_name,physician_id) values (6,'Chemotherapy', 6000)
select * from dual;

select * from patient_treatment;
select * from event_category;
select * from physician_speciality; 

with main
as
(
    SELECT pt.*,ec.category,ps.speciality
    from patient_treatment pt
    inner join event_category ec
    on pt.event_name = ec.event_name
    inner join physician_speciality ps
    on pt.physician_id = ps.physician_id
    where ec.category = 'Procedure'
),
res
as
(
  select m.*,
  count( distinct event_name) over(partition by speciality) sk
  from main m
)
select distinct speciality,sk from res;


--9. Find the top 2 accounts with the maximum number of unique patients on a monthly basis


drop table patient_logs;
create table patient_logs
(
  account_id int,
  u_date date,
  patient_id int
);


insert all
 into patient_logs(account_id,u_date,patient_id) values (1, to_date('02-01-2020','dd-mm-yyyy'), 100)
 into patient_logs(account_id,u_date,patient_id) values (1, to_date('27-01-2020','dd-mm-yyyy'), 200)
 into patient_logs(account_id,u_date,patient_id) values (2, to_date('01-01-2020','dd-mm-yyyy'), 300)
 into patient_logs(account_id,u_date,patient_id) values (2, to_date('21-01-2020','dd-mm-yyyy'), 400)
 into patient_logs(account_id,u_date,patient_id) values (2, to_date('21-01-2020','dd-mm-yyyy'), 300)
 into patient_logs(account_id,u_date,patient_id) values (2, to_date('01-01-2020','dd-mm-yyyy'), 500)
 into patient_logs(account_id,u_date,patient_id) values (3, to_date('20-01-2020','dd-mm-yyyy'), 400)
 into patient_logs(account_id,u_date,patient_id) values (1, to_date('04-03-2020','dd-mm-yyyy'), 500)
 into patient_logs(account_id,u_date,patient_id) values (3, to_date('20-01-2020','dd-mm-yyyy'), 450)
 select * from dual;
 
 
select month,account_id,unique_patients
from
(
    select account_id,
    extract(month from u_date) as month,
    count(distinct patient_id) as unique_patients
    from patient_logs pl
    group by account_id,extract(month from u_date)
    order by count(distinct patient_id) desc
)
where rownum<3
















