{%docs star_schema%}
{% raw %}   --es tracta com a text nomes

--fact_table
--order_dim   ----NO FER CAS
--TIME_DIM
--customer_dim 
--supplier_dim
--part_dim
--LOCATION_DIM

select C_CUSTKEY,C_NAME,C_ADDRESS,C_NATIONKEY,C_PHONE,C_MKTSEGMENT
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} 


select P_PARTKEY,P_NAME,P_BRAND,P_TYPE,P_SIZE,P_RETAILPRICE
from {{ source('EDIT_SAMPLE_DATA', 'PART') }} 


--localitat geografica del client / del proveidor
select N.N_NATIONKEY,N.N_NAME,R.R_REGIONKEY,R.R_NAME
from {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N
left JOIN {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R ON R.R_REGIONKEY=N.N_REGIONKEY


select S_SUPPKEY,S_NAME,S_ADDRESS,S_NATIONKEY,S_PHONE
from {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} 








--------------------------------------------------------------------------------------------------------------------
--time dim

with dates_orders_lineitem as (
    select O_ORDERDATE as specific_date from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} 
    union
    select L_SHIPDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}
    union
    select L_RECEIPTDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}
    union
    select L_COMMITDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}

)


--totes les dates possibles les busco, dsp les poso dins d'una columna q s anomena specific_date

select distinct specific_date,DATE_PART('year',specific_date) as yy,DATE_PART('month',specific_date) as mm,DATE_PART('day',specific_date) as dd, quarter(specific_date) as Trimester
from dates_orders_lineitem


















-----------------------------------------------------------------------------------------------------------------------------------------
---FACT TABLE  COSES BUIDES ENCARA


-----------------------------------------------------------------------------------------------------------------------------------------


--cte EDITADA



with sales_of_parts as (select PS.PS_PARTKEY, PS.PS_SUPPKEY,L.L_ORDERKEY,L.L_SHIPDATE,L.L_COMMITDATE,L.L_RECEIPTDATE, (L.L_QUANTITY*PS.PS_SUPPLYCOST) AS COGS,L.L_EXTENDEDPRICE as revenue_part,
L.L_EXTENDEDPRICE*(1-L.L_DISCOUNT)	as	sale_price_part
from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS 

join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L ON L.L_SUPPKEY=PS.PS_SUPPKEY and L.L_PARTKEY=PS.PS_PARTKEY and L.L_RETURNFLAG<>'R'

)  --nomes surten files de 'PARTSUPP' que han venut 

--SELECT * FROM sales_of_parts

select O.O_ORDERKEY,P.P_PARTKEY,C.C_CUSTKEY,S.S_SUPPKEY,
C.C_NATIONKEY, S.S_NATIONKEY,



O_ORDERDATE,sales_of_parts.L_SHIPDATE,sales_of_parts.L_COMMITDATE,sales_of_parts.L_RECEIPTDATE,coalesce(sum(COGS),0) as COGS_parts,coalesce(sum(revenue_part),0) as REVENUE,coalesce(sum(sale_price_part),0) as net_revenue, coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0) as GROSS_PROFIT,
case coalesce(sum(sale_price_part),0)
    when 0 then 0
    else round((coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0))*100/coalesce(sum(sale_price_part),0),2)
end as GROSS_MARGIN_percentage
from sales_of_parts

LEFT JOIN {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
on O.O_ORDERKEY=sales_of_parts.L_ORDERKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C ON C.C_CUSTKEY=O.O_CUSTKEY 
left join {{ source('EDIT_SAMPLE_DATA', 'PART') }} P ON P.P_PARTKEY=sales_of_parts.PS_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} S ON S.S_SUPPKEY=sales_of_parts.PS_SUPPKEY

GROUP BY O.O_ORDERKEY,P.P_PARTKEY,C.C_CUSTKEY,S.S_SUPPKEY,O.O_ORDERDATE,sales_of_parts.L_SHIPDATE,sales_of_parts.L_COMMITDATE,sales_of_parts.L_RECEIPTDATE,C.C_NATIONKEY, S.S_NATIONKEY


 --es tracta com a text nomes
{% endraw %}  

{%enddocs%}