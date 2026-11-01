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

