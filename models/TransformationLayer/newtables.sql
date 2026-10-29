--1a taula: taules on hi hagi F
select O_ORDERKEY,O_ORDERSTATUS,CUSTOMERS.C_NAME,NATION.N_NAME

from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=O.C_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on C.C_CUSTKEY=O.O_CUSTKEY
group by O_ORDERSTATUS





