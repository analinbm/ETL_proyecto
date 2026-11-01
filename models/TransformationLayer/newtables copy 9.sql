--vull separar per market segments i posar en cadascun, price total orders i total orders
select C.C_MKTSEGMENT, count(O.O_ORDERKEY) as number_orders,
sum(O.O_TOTALPRICE) as orders_total_price_per_mkt
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by C.C_MKTSEGMENT

