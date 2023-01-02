--Display average billing amount for each customer between 2019 to 2021,
--asuume 0$ if nothing is billed for a particular year of that customer

drop table billing;
create table billing
(
      customer_id               int
    , customer_name             varchar(1)
    , billing_id                varchar(5)
    , billing_creation_date     date
    , billed_amount             int
);

insert into billing values (1, 'A', 'id1', to_date('10-10-2020','dd-mm-yyyy'), 100);
insert into billing values (1, 'A', 'id2', to_date('11-11-2020','dd-mm-yyyy'), 150);
insert into billing values (1, 'A', 'id3', to_date('12-11-2021','dd-mm-yyyy'), 100);
insert into billing values (2, 'B', 'id4', to_date('10-11-2019','dd-mm-yyyy'), 150);
insert into billing values (2, 'B', 'id5', to_date('11-11-2020','dd-mm-yyyy'), 200);
insert into billing values (2, 'B', 'id6', to_date('12-11-2021','dd-mm-yyyy'), 250);
insert into billing values (3, 'C', 'id7', to_date('01-01-2018','dd-mm-yyyy'), 100);
insert into billing values (3, 'C', 'id8', to_date('05-01-2019','dd-mm-yyyy'), 250);
insert into billing values (3, 'C', 'id9', to_date('06-01-2021','dd-mm-yyyy'), 300);

select * from billing;



--------------------Code-------------------------
WITH
T1
AS
   (
        select b.*,extract(year from billing_creation_date) BILL_YEAR,SUM(BILLED_AMOUNT) OVER(PARTITION BY CUSTOMER_ID) SPENT,COUNT(CUSTOMER_ID) OVER(PARTITION BY CUSTOMER_ID) N_RROW
        from billing b
        where extract(year from billing_creation_date) between 2019 and 2021
        order by customer_name
   ),
 T2
 AS
    (
      SELECT T1.*,(3-COUNT(DISTINCT BILL_YEAR) OVER(PARTITION BY CUSTOMER_ID)) NO_OF_YEAR_MISSING
      FROM T1
    ),
 T3
 AS
     (

       SELECT T2.*,SPENT/(N_RROW+NO_OF_YEAR_MISSING)  AVG_SPENT
       FROM T2
     )  
SELECT DISTINCT CUSTOMER_NAME,AVG_SPENT 
FROM T3





-- Dataset
drop table emp_input;
create table emp_input
(
id      int,
name    varchar(40)
);
insert into emp_input values (1, 'Emp1');
insert into emp_input values (2, 'Emp2');
insert into emp_input values (3, 'Emp3');
insert into emp_input values (4, 'Emp4');
insert into emp_input values (5, 'Emp5');
insert into emp_input values (6, 'Emp6');
insert into emp_input values (7, 'Emp7');
insert into emp_input values (8, 'Emp8');

select * from emp_input;


-----code----
with
t1
as
   (
        select id,(to_char(id) || ' '||name) new_name
        from emp_input i
   ),
t2
as
   (
      select new_name || ',' ||lead(new_name,1) over(order by id ) new_name2,id
      from t1

   )       
select new_name2
 from t2
where mod(id,2) = 1;



-------Dataset-------

----Write a query to return the account no and the transaction date when the account balance reached 1000.
----Please include only those accounts whose balance  currently is >= 1000


drop table account_balance;
create table account_balance
(
    account_no          varchar(20),
    transaction_date    date,
    debit_credit        varchar(10),
    transaction_amount  decimal
);

insert into account_balance values ('acc_1', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 100);
insert into account_balance values ('acc_1', to_date('2022-01-21', 'YYYY-MM-DD'), 'credit', 500);
insert into account_balance values ('acc_1', to_date('2022-01-22', 'YYYY-MM-DD'), 'credit', 300);
insert into account_balance values ('acc_1', to_date('2022-01-23', 'YYYY-MM-DD'), 'credit', 200);
insert into account_balance values ('acc_2', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 500);
insert into account_balance values ('acc_2', to_date('2022-01-21', 'YYYY-MM-DD'), 'credit', 1100);
insert into account_balance values ('acc_2', to_date('2022-01-22', 'YYYY-MM-DD'), 'debit', 1000);
insert into account_balance values ('acc_3', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 1000);
insert into account_balance values ('acc_4', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 1500);
insert into account_balance values ('acc_4', to_date('2022-01-21', 'YYYY-MM-DD'), 'debit', 500);
insert into account_balance values ('acc_5', to_date('2022-01-20', 'YYYY-MM-DD'), 'credit', 900);

select * from account_balance;


------CODE----

WITH
MAIN
AS
   (
     SELECT AB.*,
           CASE WHEN DEBIT_CREDIT = 'credit' THEN 1* TRANSACTION_AMOUNT ELSE (-1*TRANSACTION_AMOUNT )
           END AS ACTUAL_DC
     FROM ACCOUNT_BALANCE AB
   ),
T2
AS
   (
      SELECT M.*,SUM(ACTUAL_DC) OVER(PARTITION BY ACCOUNT_NO ORDER BY TRANSACTION_DATE) RUNNING_AMOUNT
      FROM MAIN M
   ),
T3
AS
   (
      SELECT X.*,FIRST_VALUE(RUNNING_AMOUNT) OVER(PARTITION BY ACCOUNT_NO ORDER BY TRANSACTION_DATE DESC) LAST_ACCOUNT_BALANCE
      FROM T2 X
   ),
T4
AS
    (         
        SELECT X.ACCOUNT_NO,X.TRANSACTION_DATE,X.RUNNING_AMOUNT,ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO ORDER BY RUNNING_AMOUNT DESC) RK
        FROM T3 X
        WHERE LAST_ACCOUNT_BALANCE >= 1000
        ORDER BY ACCOUNT_NO,TRANSACTION_DATE
    )
SELECT *
FROM T4
WHERE RK =1;
