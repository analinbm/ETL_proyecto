--distict: pq no es repeteixi 

--client nom, regio, nacio
select distinct C.C_NAME,R.R_NAME,N.N_NAME
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_NATIONKEY=C.C_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R on R.R_REGIONKEY  = N.N_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on C.C_CUSTKEY=O.O_CUSTKEY 
where O.O_ORDERSTATUS<>'F'
order by R.R_NAME, N.N_NAME

