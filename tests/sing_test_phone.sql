select C_CUSTKEY,C_PHONE
from {{ref('customers')}}
where not REGEXP_LIKE (C_PHONE, '(\\d{2})-(\\d{3})-(\\d{3})-(\\d{4})')

--q no coicideixi amb l esperat: 00-000-000-0000
--si retorna algo, ha fallat el test



