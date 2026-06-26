create database amozoreturns_refundn_data_analyse ;
select * from customer;


select * from delievry ;
select * from orders ; 
select * from products ;
select * from ratings ;
select * from returns_refund ;
select * from subscription_plan ;
select * from subscription_details;
select * from transactions;

-- DUPLICATE record cleaning 

select c_id, COUNT(*)
FROM customer
GROUP BY c_id
HAVING COUNT(*) > 1;
-- 184 rows are duplicate 
-- now we are delete duplicate record in customer table  as per create new table 

create table temp_customer as select distinct * from customer ;
truncate table customer ;
insert into customer select * from temp_customer ;
drop table temp_customer ;
select * from customer ;

select dp_id, COUNT(*)FROM delievry GROUP BY dp_id HAVING COUNT(*) > 1;
-- we are found 25 duplicade row from delievry table
-- now we are delete duplicate record in delievry table as per create new table 
create table temp_delivery as select distinct * from delievry ;
truncate table delievry ;
insert into delievry select * from temp_delivery ;
drop table temp_delivery ;
select * from delievry ;

select or_id , count(*) from orders group by Or_ID having count(*) > 1 ;
-- there are no duplicate row in this table 

select p_id , count(*) from products group by P_ID having count(*)>1 ;
-- there are no duplicate  row in this table 

select r_id , count(*) from ratings group by R_ID having count(*) > 1 ;
-- there are no duplicate row in this table 

select rt_id , count(*)from returns_refund group by RT_ID having count(*)>1 ;
 -- there are no duplicate row in this tableb
 
 select SD_ID , count(*)from subscription_details group by sd_id having count(*)>1 ;
-- THERE ARE NO DUPLICATE ROW IN THIS TABLE 

select tr_id , count(*)from transactions group by Tr_ID having count(*)>1 ;
-- there are no duplicte row in this table

-- data cleaning

select sum(c_id is null) as id, SUM(c_id  = '' ) AS c_id ,
sum(c_name is null)as c_name ,SUM(c_name   = '' ) AS c_empty,
sum(gender is null)as gender ,SUM(gender   = '' ) AS gender_empty,
sum(age is null )as age ,SUM(age   = '' ) AS age_empty,
sum(state is null)as state ,SUM(state   = '' ) AS state_empty,
sum(`street address` is null) as add_s,SUM(`street address`   = '' ) AS `street address_empty `,
sum(mobile is null)as mob , SUM(mobile   = '' ) AS mobile_empty
from customer ;

select 
      sum(DP_ID is Null ) as D_ID, SUM(DP_id = '' ) AS empty_id ,
      sum(DP_Name is null ) as D_Name, SUM(dp_name = '' ) AS empty_name ,
      SUM(DP_Ratings IS NULL) AS real_nulls, SUM(DP_Ratings = '' ) AS empty_values
FROM delievry;
-- we found there is 22 empty values in dp_rating 
-- now we are replacing empty_values with numeric values(0)
set sql_safe_updates = 0 ;
update delievry set dp_ratings = '0' where dp_ratings = '' ;
select * from delievry ;
-- now dp_ratings column is update form empty values "0"

select 
sum(or_id is null)as id_null , sum(or_id = '')as id_empty ,
sum(c_id is null)as c_null , sum(c_id = '')as c_empty ,
sum(p_id is null)as p_null , sum(p_id = '')as p_empty ,
sum(order_date is null)as date_null , sum(order_date = '')as date_empty ,
sum(order_time is null)as time_null , sum(order_time = '')as time_empty ,
sum(qty is null)as qty_null , sum(qty = '')as qty_empty ,
sum(coupon is null)as coupon_null , sum(coupon = '')as coupon_empty ,
sum(dp_id is null)as dp , sum(dp_id = '')as dp 
from orders ;
 -- we found there are  5011 coupon_empty in the orders table it mean that 5011 customer is not applicable for coupon process
 -- so now we are replacing coupon_empty column with "not applicable"
 set sql_safe_updates = 0 ;
update orders set coupon = 'not applicable' where coupon = '' ;

select 
sum(p_id is null)as id_null , sum(p_id = '')as id_empty,
sum(pname is null)as name_null , sum(pname = '')as name_empty ,
sum(category is null)as category_null , sum(category = '')as category_empty ,
sum(specs1 is null)as specs1_null , sum(specs1 = '')as specs1_empty ,
sum(price is null)as price_null , sum(price = '')as price_empty 
from products ;
-- there are 14 prodct name is not mention in products table 
-- so now we are replacing pname column with 'unnamed product'
 set sql_safe_updates = 0 ;
update products set pname = '' where pname = 'NOT MENTION ' ;
select * from products where pname = 'NOT MENTION  ';

select
sum(r_id is null )as id_null , sum(r_id = '')as id_empty ,
sum(or_id is null)as or_id_null , sum(or_id = '')as or_id_empty ,
sum(prod_rating is null)prod_rating_null , sum(prod_rating = '')as prod_rating_empty ,
sum(`Delivery/Service_Rating` is null)as service_null , sum(`Delivery/Service_Rating` = '')as service_empty
from ratings ;
-- there are no null & empty are present in ratings table

select
sum(rt_id is null)as id_null , sum(rt_id = '')as id_empty ,
sum(or_id is null)as or_id_null , sum(or_id = '')as or_id_empty ,
sum(reason is null)as reason_null , sum(reason = '')as reason_empty ,
sum(`return/refund` is null)as refund_null , sum( `return/refund`= '')as refund_empty ,
sum(`date` is null)as date_null , sum(`date` = '')as date_empty 
from returns_refund ;
-- there are no null & empty are present in returns_refund table

select
sum(sd_id is null)as sd_id_null , sum(sd_id = '')as sd_id_empty ,
sum(c_id is null)as c_id_null , sum(c_id = '')as c_id_empty ,
sum(plan_id is null)as plan_id_null , sum(plan_id = '')as plan_id_empty ,
sum(from_date is null)as from_date_null , sum(from_date = '')as from_date_empty ,
sum(to_date is null)as to_date_null , sum(to_date = '')as to_date_empty 
from subscription_details ;
-- there are no null & empty are present in subscription_details table

select
sum(tr_id is null)as tr_id_null , sum(tr_id = '')as tr_id_empty ,
sum(or_id is null)as or_id_null , sum(or_id = '')as or_id_empty ,
sum(transaction_mode is null)as transaction_mode_null , sum(transaction_mode = '')as transaction_mode_empty ,
sum(tran_status is null)as tran_status_null , sum(tran_status = '')as tran_status_empty 
from transactions ;
-- we found tha 33 transaction_mode_empty space in transactions table it mean customer are not mention in transaction_mode 
-- so now we are replacing transaction_mode column with 'not mention'
set sql_safe_updates = 0 ;
update transactions set transaction_mode = "not mention" where transaction_mode = '' ;
select * from transactions where transaction_mode = "not mention" ;

select 'customer' as table_name ,count(*) from customer
UNION ALL 
SELECT 'DELIEVRY' , COUNT(*) FROM DELIEVRY
UNION ALL 
SELECT 'ORDERS' ,COUNT(*) FROM ORDERS
UNION ALL 
SELECT 'PRODUCTS' , COUNT(*) FROM PRODUCTS
UNION ALL 
SELECT 'RATINGS' , COUNT(*) FROM RATINGS
UNION ALL 
SELECT 'RETURNS_REFUND' , COUNT(*) FROM RETURNS_REFUND
UNION ALL 
SELECT 'subscription_details' , COUNT(*) FROM subscription_details
UNION ALL 
SELECT 'SUBSCRIPTION_PLAN' , COUNT(*) FROM SUBSCRIPTION_PLAN
UNION ALL 
SELECT 'TRANSACTIONS' , COUNT(*) FROM TRANSACTIONS ;

----------------------------------------------------------------------------------------------------------------
-- 1) order analysis 
select * from orders ;
-- total no of order placed
select count(*) total_order from orders ;
-- there are totQtyQtyal 1000 order place 

-- total revenue generated from all orders 
-- using join form
SELECT SUM(P.Price * O.Qty) AS Total_Revanue
FROM products as P
join orders as O
On P.P_ID = O.P_ID;
-- there are total revenue 13987259

-- which product cactegory has highest no of orders acording to year
SELECT P.Category , year(o.order_date)as order_year ,
Sum(O.Qty) as Total_order
FROM  Products as p
LEFT JOIN orders as o
ON p.P_Id = o.P_ID
GROUP BY P.Category , order_year productsordersOrder by Total_order DESC LIMIT 1; 
-- in 2024  

-- top 10 customers by total order  values acording to year
select c.c_name , sum(o.qty) as total_qty , year(order_date)as order_year from orders as o 
left join customer as c on c.c_id = o.C_ID group by  c.c_name , o.qty , order_year
  order by total_qty desc , order_year desc limit 10 ;
-- using left join with group by aco customer
-- orders distibution by customer city / sate 
select c.city , c.state, 
sum(o.qty) as Total_qty,
count(r.`return/refund`)  as Total_return,
sum(o.qty)  - count(r.`return/refund`)  as Net_Quantity
FROM ORDERS AS O
LEFT JOIN CUSTOMER AS C
ON O.C_ID = C.C_ID 
LEFT JOIN `returns_refund` AS R
ON R.Or_ID = O.Or_ID
GROUP BY C.CITY , C.STATE 
ORDER BY Total_qty DESC, Total_return DESC ;
-- This analysis compares total quantity ordered with total returns/refunds across different cities and states to understand regional performance

-- _______________________________________________________________________________________________________________________________________________

-- 2 ) customer behavior analysis (orders + customer)

select * from customer ;

-- analyze customer segmention base on customer id , gender , age , city & state 
SELECT   State ,GENDER , City , COUNT(distinct C_id) AS Total_Customer ,
CASE 
    WHEN AGE < 18 THEN "Child" 
    WHEN AGE  BETWEEN 18  AND  30 THEN "Adults"
    WHEN AGE  BETWEEN 30 AND  60 THEN "Seniurs"
    ELSE "SENIURS CITIZEN"
    END AS AGE_Group
    
 FROM CUSTOMER GROUP BY sTATE , GENDER, City , AGE_Group  ORDER BY Total_Customer asc ,AGE_Group ASC ;
-- This query segments customers based on age group, gender, city, and state to 
-- understand the demographic distribution of customers across regions. 

-- analyze new vs repeate customers ration 

SELECT  
 New_Customer,
 Repeat_Customers,
 Round(New_Customer *1.0 / Repeat_Customers,2) as Total_Ratio
 FROM(
 SELECT
     SUM(CASE WHEN CUSTOMER_COUNTS = 1 THEN 1 ELSE 0 END) AS New_Customer,
     SUM(CASE WHEN CUSTOMER_COUNTS > 1 THEN 1 ELSE 0 END) AS Repeat_Customers
     FROM (
     SELECT  C_id ,  COUNT(*) AS CUSTOMER_COUNTS 
     
     FROM orders
     group by C_id
     
     )X
       )Y;
--  INSIGHT = THIS ANALYSIS FIND TOTAL 6340 CUSTOMER AND COMPARE TO NEW VS REPEAT CUSTOMER
-- NEW CUSTOMER = 3707
-- REPEAT COSTOMER = 2633
-- TOTAL RETIO OF NEW & REPEAT CUSTOMER IS 1.41

-- analyze average per spend customer delievry
select avg(p.price )avg_price ,p.Category, c.c_id ,c.C_Name, c.city , year(o.order_date)avg_year from products as p 
left join orders as o 
on p.P_ID = o.P_ID 
 join customer as c on
c.c_id = o.c_id  group by c_id ,c.C_Name, c.city , avg_year , p.Category order by avg_price desc ;  -- using asc and desc  
-- this analysis found tha  maxi avgrae is  449.97 customer is Ayush Kannan  from mumbai in 2024 
-- and in 2023 year Sudiksha Kamdar from Ahmedabad  and nimrat arya from kanpur has same  average amount is 499.95
-- minimum category wise average is 10.09 customer is akbal agrawal  in 2023 from bhopal and 
-- in 2024 customer is Jagrati Bains average amount is 10.27 from Ahmedabad

-- _______________________________________________________________________________________________________________________________________
   
   -- product prpormance analyze
   select * from products ;
-- top 10 best selling  product by revenue
select p.pname , p.Category ,sum(p.price * o.qty)as total_revenue  from products as p
join  orders as o on p.p_id = o.P_ID group by p.PName , p.Category order by total_revenue  desc limit 10 ;
-- this analyze found that top  10 product  and category wise by revenue

-- _______________________________________________________________________________________________________________________________________
 
 -- trasaction analyze 
select * from transactions ;
-- analyze transaction mode most use 
select transaction_mode , count(*)as usage_count from transactions
group by Transaction_Mode
order by  usage_count desc  ;

-- this analyze found that there are 6 mode use transactions but mostly customere use net banking
-- usage count is 2024 and minimum customer use trasactions mode is wallet usage count is 1974 and 
-- 33 customer is not mention in trsaction mode
-- Total count of Eproductsordersach Transaction MOdes 
-- Customer who are using NET bANKING >> 2024 
-- Debit CaRD -- " -- >> 2011 
-- CREDIT CARD -- "-- >> 1980
-- UPI --" -- >> 1978
-- WALLET -- " -- >> 1974 
-- NOT MENTION USERS  --- >> 33.

-- analyze payment sucsees vs failure
select transaction_mode  ,Tran_Status,count(*)status_trasaction from transactions
group by Transaction_Mode , Tran_Status
order by  Transaction_Mode  desc ,status_trasaction desc ;

select t.transaction_mode , t.Tran_Status,count(*)status_trasaction , sum(p.price)as total_price from transactions as t
left join orders as o on t.Or_ID = o.Or_ID
left join products as p on p.P_ID = o.P_ID 
group by t.transaction_mode ,t.Tran_Status order by   t.transaction_mode ; 
-- INSIGHT ->>  
/*NOT Mention	 Failed	            13	    2926.7
NOT Mention	    Successful	        20	    6091.419999999999
Credit Card	    Failed	            991	    264131.4700000001
Credit Card	    Successful	        989	    249719.49
Debit Card	    Failed          	996	    247861.86000000022
Debit Card	    Successful	        1015	271253.5900000006
Net Banking	    Failed	            1019	259272.9299999999
Net Banking	    Successful	        1005	255853.96000000022
UPI	            Failed	            1002	245903.82999999996
UPI	            Successful	        976	    246140.62999999986
Wallet	         Failed	            1003    252322.869999999948 */
 
-- ___________________________________________________________________________________________________________________

-- analyze rating and customer satisfaction 
select * from ratings ;
select * from customer ;
--  analyze  rating per category
select p.category , avg(prod_rating)as avg_rating from orders as o
join products as p on p.P_ID = o.P_ID 
join ratings as r on r.Or_ID = o.Or_ID group by p.Category order by avg_rating desc ;
-- this analysis found that maximum avg rating  is 3.01 from electronics and 
-- minimum avg rating is 2.96 from fashion 

-- analyze realaship between ratings and sales volume 
select p.p_id , p.pname ,p.category , sum(o.qty)as total_qty ,avg(r.prod_rating)as avg_rating
from products as p join orders as o on p.P_ID = o.P_ID
join ratings as r on r.Or_ID = o.Or_ID 
group by p.Category , p.PName , p.P_ID order by total_qty desc;
-- this analysis found that low rating but high sales indicates strong demand 
-- but poor customer experience.

-- analyze customer giving lowest ratings- repeat or one time 

select c.c_id ,c.c_name ,min(r.prod_rating) as lowest_ratings , count(*)as rating_frequency
from customer as c join orders as o on c.C_ID = o.C_ID
join ratings as r on r.Or_ID = o.Or_ID 
group by c.c_name , c.c_id order by lowest_ratings asc ;
-- Cu-- this analysis found that customers who give the lowest ratings (1–2 stars) are not limited to one-time buyers.
-- nificant portion are repeat customers, indicating that dissatisfaction is persistent, not accidental.

-- analyze return and refund 
select * from returns_refund ;
-- analyze overrall retun rate (%)
select 
(sum(case when `return/refund` = "return" then 1 else 0 end)* 100)/ count(*)as return_rate_persent
 from returns_refund ;
 -- this analysis found that overall return rate is 48.45 %
 
-- analyze which category are return  most freqency
select  p.category  , (sum(case when r.`return/refund` = "return" then 1 else 0 end)*100)/count(*) as total_returns
 from returns_refund as r join orders as o 
 on r.Or_ID = o.Or_ID 
 join products as p 
 on p.P_ID = o.P_ID 
 group by   p.category order by total_returns desc ;
 -- this analyze found that home applience product most of retrun freqently
 
 -- anlyze  refund amound as % of total revenue
 SELECT
        (SUM(CASE 
                WHEN r.`return/refund` = 'Refund'
                THEN o.qty * p.price
                ELSE 0
            END) / SUM(o.qty * p.price) * 100) as refund_percentage_of_total_revenue
FROM returns_refund r
JOIN orders o
    ON r.Or_ID = o.Or_ID
JOIN products p   
    ON p.P_ID = o.P_ID ;
    
-- analyze

-- analyze low rated product have higher return rates 
SELECT P.CATEGORY ,
AVG(R.PROD_RATING) AS AVGERAGE_RATING,
(SUM(CASE WHEN RR .`RETURN/REFUND` = 'RETURN' THEN O.QTY ELSE 0 END) *1.0 / SUM(O.QTY)) AS  RETURN_RATE 
FROM ORDERS AS O 
LEFT JOIN PRODUCTS AS P
ON O.P_ID = P.P_ID 
LEFT JOIN RATINGS AS R
ON R.Or_ID = O.OR_ID 
LEFT JOIN returns_refund AS RR
ON O.Or_ID = RR.OR_ID 
GROUP BY P.CATEGORY ;
  -- ________________________________________________________________________________________________________________________________  
   
   -- analyze delivery perpormance
   select*from delievry ;
      
-- analyse How many orders has each delivery partner handled across different cities and states
 
 select d.dp_name ,c.city ,c.state ,count(dp_name ) as dp_count from
 delievry  as d join orders as o on o.DP_ID = d.DP_ID
 join customer as c on c.C_ID = o.C_ID
group by d.dp_name ,c.city, c.state order by dp_count desc ;
   -- The analysis shows city-wise order distribution for each delivery partner, 
   -- highlighting regional concentration and delivery partner dominance across different states.
   
   -- 
select * from  delievry  order by DP_Ratings desc ;
-- there are 300 delivery partner 
      
-- analyze permance delievry partener rating
select * from  delievry where DP_Ratings between 4 and 5  ;

select * from  delievry where DP_Ratings = 0  ;
--  this analyze found that maximun dp rating are 154 and 20 delievry partner has no ratings

-- subscription analysis 
select * from subscription_details ;
select * from subscription_plan ;

-- analyze how many customer using this plan
select s.plan_name , s.Features  , 
count(case when s.Plan_Name = 'prime base' then c.C_id
		   when s.Plan_Name = 'Prime Standard ' then c.C_id 
		   when s.Plan_Name = 'Prime Premium ' then c.C_id else 0 end) as total_customer 
from  subscription_plan as s join subscription_details as ss 
on s.Plan_ID = ss.Plan_ID
join customer as c on c.C_ID = ss.c_id 
group by s.plan_name ,  s.Features ;

-- same query 

select s.plan_name ,s.Features, count(*)as total_subs from subscription_plan as s join subscription_details as ss 
on s.Plan_ID = ss.Plan_ID 
group by s.Plan_Name , s.Features ;

-- this analysis found that there are 3393 customer use prime standard subscription plan , 3360 customer use prime base subscription plan
 -- and 3283 customer use prime premium subscription plan

select c_id ,count(* )as customer_count from subscription_details group by C_ID  having customer_count > 1 order by customer_count desc;


select sd_id , avg(datediff( to_date , from_date))as sd_id 
from subscription_details group by SD_ID order by sd_id desc;

select 
monthname(from_date)as month_data,
year(from_date)as year_data , count(*)as sub_count from subscription_details
group by month_data , year_data  order by sub_count desc  ;