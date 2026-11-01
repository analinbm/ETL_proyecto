
--quantitat d'ordres per costumer I SABER SI ALGUN CLIENT HA FET MES DE1 
--quantitat de orders x cada status-- commands
select C.C_NAME, count(O.O_ORDERKEY) as number_orders
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C 
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O on O.O_CUSTKEY =C.C_CUSTKEY
group by C.C_NAME
--having count(O.O_ORDERKEY)>1

