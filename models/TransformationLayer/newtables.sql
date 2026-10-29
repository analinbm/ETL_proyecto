--1a taula: taules on hi hagi F
select O_ORDERKEY,O_ORDERSTATUS,CUSTOMERS.C_NAME,NATION.N_NAME

from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} on NATION.N_NATIONKEY=ORDERS.C_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} on CUSTOMERS.C_CUSTKEY=ORDERS.O_CUSTKEY
group by O_ORDERSTATUS





