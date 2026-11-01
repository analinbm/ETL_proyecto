--VULL SABER REGIO, NACIO I COM S ORDENEN, NO IMPORTA Q ESTIGUIN EMPATATS 
select  N.N_NAME,R.R_NAME,
DENSE_RANK() over (partition by R.R_NAME ORDER BY count(DISTINCT C.C_CUSTKEY) desc) as rank_num_customers,
DENSE_RANK() over (partition by R.R_NAME ORDER BY count(O.O_ORDERKEY) desc) as rank_num_orders,
DENSE_RANK() over (partition by R.R_NAME order by SUM(O.O_TOTALPRICE) desc) as rank_TOTALPRICE

FROM {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R
left join {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N on N.N_REGIONKEY=R.R_REGIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C ON C.C_NATIONKEY=N.N_NATIONKEY
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY=C.C_CUSTKEY
group by R.R_NAME, N.N_NAME

