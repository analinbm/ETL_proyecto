
-- escullo aqsta taula x incremental: pq a la taula, es poden anar editant els estatus de les orders
{{
    config(materialized='incremental', unique_key='O_ORDERKEY')
}}



select *
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}
{#1r: em carrega tota la taula i despres, mira la condicio i edita només allo q cal#}
{#exemple de data yyyy-mm-dd#}
{%if is_incremental()%}
    where O_ORDERDATE<dateadd(year, 124,CURRENT_DATE)  
{%endif%}
