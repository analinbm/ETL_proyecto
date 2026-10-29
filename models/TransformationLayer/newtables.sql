--1a taula: taules on hi hagi F
select O.O_ORDERKEY,O.O_ORDERSTATUS,C.C_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on C.C_CUSTKEY=O.O_CUSTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
order by O.O_ORDERSTATUS


select O.O_ORDERSTATUS, count(*) as number
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS


select C_NAME,R.R_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R on R.R_REGIONKEY  = N.N_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on C.C_CUSTKEY=O.O_CUSTKEY 
where O.O_ORDERSTATUS<>'F'
order by R_NAME, N_NAME


--quantitat de orders x cada status
select O.O_ORDERSTATUS, count(*) as number_orders
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS

--R_NAME i el NUM_ORDERS, el NUM_CLIENTS, TOTAL_PRICE orders
select R.R_NAME,count(O_ORDERKEY) as num_orders, count(distinct C.C_CUSTKEY) as num_clients, sum(O.O_TOTALPRICE) as Total_price
from {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_REGIONKEY=R.R_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on  C.C_NATIONKEY = N.N_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by R.R_NAME






--Faig una CTE per posar a cada nacio, els orders q hi ha per el tipus de priority
with orders_priority_nation as (select N.N_NAME, count(O.O_ORDERKEY) as number_orders_type, O.O_ORDERPRIORITY as type_priority
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O 
join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on C.C_CUSTKEY=O.O_CUSTKEY 
join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY 
group by O_ORDERPRIORITY, N.N_NAME)
--SELECT * FROM orders_priority_nation

--organitzo per type priority, el num total orders d'aquesta priority, el país predominant i les respectives orders
select type_priority, sum(number_orders_type) as number_total_orders_of_specific_priority, max_by(N_NAME,number_orders_type) as nation_with_most_orders, max(number_orders_type) as num_orders_priority_specific_nation
from orders_priority_nation
group by type_priority
order by type_priority
