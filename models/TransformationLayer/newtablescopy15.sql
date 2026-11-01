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