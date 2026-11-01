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