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


select R.R_REGIONKEY,R.R_NAME,N.N_NATIONKEY,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
RIGHT JOIN {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N ON N.N_REGIONKEY=R.R_REGIONKEY



select O_ORDERDATE,DATE_PART('year',O_ORDERDATE) as yy,DATE_PART('month',O_ORDERDATE) as mm,DATE_PART('day',O_ORDERDATE) as dd, quarter(O_ORDERDATE) as Trimester
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} 

-----------------------------------------------------------------------------------------------------------------------------------------
---FACT TABLE  COSES BUIDES ENCARA


-----------------------------------------------------------------------------------------------------------------------------------------


--cte EDITADA



with sales_of_parts as (select PS.PS_PARTKEY, PS.PS_SUPPKEY,L.L_ORDERKEY,L.L_SHIPDATE,L.L_COMMITDATE,L.L_RECEIPTDATE, (L.L_QUANTITY*PS.PS_SUPPLYCOST) AS COGS,L.L_EXTENDEDPRICE as revenue_part,
L.L_EXTENDEDPRICE*(1-L.L_DISCOUNT)	as	sale_price_part
from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS 

left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L ON L.L_SUPPKEY=PS.PS_SUPPKEY and L.L_PARTKEY=PS.PS_PARTKEY and L.L_RETURNFLAG<>'R'

)

--SELECT * FROM sales_of_parts

select O.O_ORDERKEY,P.P_PARTKEY,C.C_CUSTKEY,S.S_SUPPKEY,O_ORDERDATE,sales_of_parts.L_SHIPDATE,sales_of_parts.L_COMMITDATE,sales_of_parts.L_RECEIPTDATE,coalesce(sum(COGS),0) as COGS_parts,coalesce(sum(revenue_part),0) as REVENUE, P.P_RETAILPRICE as price_part,coalesce(sum(sale_price_part),0) as net_revenue, coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0) as GROSS_PROFIT,
case coalesce(sum(sale_price_part),0)
    when 0 then 0
    else round((coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0))*100/coalesce(sum(sale_price_part),0),2)
end as GROSS_MARGIN_percentage
from sales_of_parts

LEFT JOIN {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
on O.O_ORDERKEY=sales_of_parts.L_ORDERKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMER') }} C ON C.C_CUSTKEY=O.O_CUSTKEY 
left join {{ source('EDIT_SAMPLE_DATA', 'PART') }} P ON P.P_PARTKEY=sales_of_parts.PS_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} S ON S.S_SUPPKEY=sales_of_parts.PS_SUPPKEY

GROUP BY O.O_ORDERKEY,P.P_PARTKEY,C.C_CUSTKEY,S.S_SUPPKEY,O.O_ORDERDATE,sales_of_parts.L_SHIPDATE,sales_of_parts.L_COMMITDATE,sales_of_parts.L_RECEIPTDATE, P.P_RETAILPRICE