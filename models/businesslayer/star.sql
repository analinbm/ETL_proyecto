--fact_table
--order_dim   ----NO FER CAS
--TIME_DIM
--customer_dim 
--supplier_dim
--part_dim
--LOCATION_DIM




select C_CUSTKEY,C_NAME,C_NATIONKEY,C_PHONE
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} 


select S_SUPPKEY,S_NAME,S_NATIONKEY,S_PHONE
from {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} 

select P_PARTKEY,P_NAME,P_BRAND,P_RETAILPRICE
from {{ source('EDIT_SAMPLE_DATA', 'PART') }} 


--select O_ORDERKEY,O_ORDERSTATUS,O_ORDERDATE,--O_ORDERPRIORITY
--from {{ source('EDIT_SAMPLE_DATA', 'ORDER') }} 

select R.R_REGIONKEY,R.R_NAME,N.N_NATIONKEY,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
RIGHT JOIN {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N ON N.N_REGIONKEY=R.R_REGIONKEY



select O_ORDERDATE,DATE_PART('year',O_ORDERDATE),DATE_PART('month',O_ORDERDATE),DATE_PART('day',O_ORDERDATE)
case 
    when month between 01 and 03 then '1'
    when month between 04 and 06 then '2'
    when month between 07 and 09 then '3'
    when month between 10 and 12 then '4'
end as 'Trimester'
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} 


---FACT TABLE  COSES BUIDES ENCARA
select O.O_ORDERKEY,P.P_PARTKEY,C.C_CUSTKEY,S.S_SUPPKEY,O_ORDERDATE,L_SHIPDATE,L_COMMITDATE,L_RECEIPTDATE, as REVENUE, as units_sold, total_sales, price_part
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
ON O.O_ORDERKEY=L.L_ORDERKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMER') }} C ON C.C_CUSTKEY=O.O_CUSTKEY 
left join {{ source('EDIT_SAMPLE_DATA', 'PART') }} P ON P.P_PARTKEY=L.L_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} P on P.P_PARTKEY=PS.PS_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} S ON S.S_SUPPKEY=PS.PS_SUPPKEY