select P_PARTKEY,P_BRAND
from {{ref('part')}}
where P_BRAND not like 'Brand#%'  

--q no comenci per brand#, si retorna algo, ha fallat el test