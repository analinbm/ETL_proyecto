--1a taula: taules on hi hagi F
select O.O_ORDERKEY,O.O_ORDERSTATUS,C.C_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C on C.C_CUSTKEY=O.O_CUSTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
order by O.O_ORDERSTATUS

