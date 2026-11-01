--regio nom i el NUM_ORDERS, el NUM_CLIENTS, TOTAL_PRICE orders
select R.R_NAME,count(O_ORDERKEY) as num_orders, count(distinct C.C_CUSTKEY) as num_clients, sum(O.O_TOTALPRICE) as Total_price
from {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_REGIONKEY=R.R_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on  C.C_NATIONKEY = N.N_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by R.R_NAME
