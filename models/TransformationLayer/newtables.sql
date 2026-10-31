--1a taula: taules on hi hagi F
select O.O_ORDERKEY,O.O_ORDERSTATUS,C.C_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on C.C_CUSTKEY=O.O_CUSTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
order by O.O_ORDERSTATUS


select O.O_ORDERSTATUS, count(*) as number
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS

--VULL SABER REGIO, NACIO I COM S ORDENEN, NO IMPORTA Q ESTIGUIN EMPATATS 
select R.R_NAME, N.N_NAME,
DENSE_RANK() over (partition by R.R_NAME ORDER BY count(DISTINCT C.C_CUSTKEY) desc) as rank_num_customers,
DENSE_RANK() over (partition by R.R_NAME ORDER BY count(O.O_ORDERKEY) desc) as rank_num_orders,
DENSE_RANK() over (partition by R.R_NAME order by SUM(O.O_TOTALPRICE) desc) as rank_TOTALPRICE

FROM {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_REGIONKEY=R.R_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C ON C.C_NATIONKEY=N.N_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by R.R_NAME, N.N_NAME





---PER SABER QUANTS HI HA TIPU_mkt
select C.C_MKTSEGMENT, count(*) as number
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
group by C.C_MKTSEGMENT



--vull separar per market segments i posar en cadascun, price total orders i total orders
select C.C_MKTSEGMENT, count(O.O_ORDERKEY) as number_orders,
sum(O.O_TOTALPRICE) as orders_total_price_per_mkt
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by C.C_MKTSEGMENT



--distict: pq no es repeteixi 

--client nom, regio, nacio
select distinct C.C_NAME,R.R_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R on R.R_REGIONKEY  = N.N_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on C.C_CUSTKEY=O.O_CUSTKEY 
where O.O_ORDERSTATUS<>'F'
order by R.R_NAME, N.N_NAME


--quantitat de orders x cada status
select O.O_ORDERSTATUS, count(*) as number_orders
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS


--RETURN FLAG I NUM_COMANDES
--quantitat dE NUM_COMANDES X RETURN FLAG
select L.L_RETURNFLAG, count(*) as number_item 
from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
group by L.L_RETURNFLAG
--having count(O.O_ORDERKEY)>1


--part(pieza vendida),subministrament preu, preu retail: parella peça-proveïdor
--si la pieza esta molt demanada (high, regular low), per comparar proveidors
select PS.PS_PARTKEY, PS.PS_SUPPKEY, PS.PS_SUPPLYCOST, P.P_RETAILPRICE, (P.P_RETAILPRICE-PS.PS_SUPPLYCOST) as Unitary_Margin, 
case
    when count(L.L_PARTKEY)>5 then 'HIGH'
    when count(L.L_PARTKEY) between 1 and 5 then 'REGULAR'
    else 'LOW'
end
as Type_demand
from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS
left join {{ source('EDIT_SAMPLE_DATA', 'PART') }} P on P.P_PARTKEY=PS.PS_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L on L.L_SUPPKEY=PS.PS_SUPPKEY and L.L_PARTKEY=PS.PS_PARTKEY and L.L_RETURNFLAG<>'R'
group by PS.PS_PARTKEY, PS.PS_SUPPKEY, PS.PS_SUPPLYCOST, P.P_RETAILPRICE



--quantitat d'ordres per costumer I SABER SI ALGUN CLIENT HA FET MES DE1 
--quantitat de orders x cada status-- commands
select C.C_NAME, count(O.O_ORDERKEY) as number_orders
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C 
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY =C.C_CUSTKEY
group by C.C_NAME
--having count(O.O_ORDERKEY)>1



select L.L_SHIPMODE, count(distinct(O.O_ORDERKEY)) as number_orders
FROM {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O ON O.O_ORDERKEY=L.L_ORDERKEY
group by L.L_SHIPMODE


--regio nom i el NUM_ORDERS, el NUM_CLIENTS, TOTAL_PRICE orders
select R.R_NAME,count(O_ORDERKEY) as num_orders, count(distinct C.C_CUSTKEY) as num_clients, sum(O.O_TOTALPRICE) as Total_price
from {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_REGIONKEY=R.R_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on  C.C_NATIONKEY = N.N_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by R.R_NAME

-----------------------------------------------------------------------------------------------------
select O.O_ORDERKEY, count(L.L_ORDERKEY) as num_line_items from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L on L.L_ORDERKEY=O.O_ORDERKEY
group by O.O_ORDERKEY

------------------------------------------------------------------------------------------------------------------------------------------------


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

--, L.L_QUANTITY,L_DISCOUNT,L_TAX

--Faig una CTE per saber pieza i cost PER A L'EMPRESA (dona iguual proveidor), DINERS FACTURATS, 
--select PS.PS_PARTKEY, PS.PS_SUPPKEY, PS.PS_SUPPLYCOST, P.P_RETAILPRICE,


with sales_of_parts as (select PS.PS_PARTKEY, PS.PS_SUPPKEY,(L.L_QUANTITY*PS.PS_SUPPLYCOST) AS COGS,L.L_EXTENDEDPRICE as revenue_part,
L.L_EXTENDEDPRICE*(1-L.L_DISCOUNT)	as	sale_price_part
from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS 

left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L ON L.L_SUPPKEY=PS.PS_SUPPKEY and L.L_PARTKEY=PS.PS_PARTKEY and L.L_RETURNFLAG<>'R'

)

--SELECT * FROM sales_of_parts

-- VULL MOSTRAR GROSS PROFIT I GROSS MARGIN
select PS_PARTKEY, coalesce(sum(COGS),0) as COGS_parts,coalesce(sum(revenue_part),0) as revenue,coalesce(sum(sale_price_part),0) as net_revenue, coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0) as GROSS_PROFIT,
case coalesce(sum(sale_price_part),0)
    when 0 then 0
    else round((coalesce(sum(sale_price_part),0)-coalesce(sum(COGS),0))*100/coalesce(sum(sale_price_part),0),2)
end as GROSS_MARGIN_percentage
from sales_of_parts
group by PS_PARTKEY

--coalesce: PQ NO SIGUI NULL I SIGUI ZERO
--peces no venudes: surt 0
--TOTAL_SALE_PRICE_PART=net_revenue(descompte inclos)

------------------------------------------------------------------------------------------------------------------------------------------

--mcros

--vull calcular-ho en un mes
--2400002,188783,3820,1,14.00,26204.92,0.09,0.01,R,F,1994-09-13,1994-09-25,1994-10-06,TAKE BACK RETURN,MAIL," around the slyly ironi"
{{re_stock_inventory(188783,'1994-09-13')}}
{{delivery_delays()}}