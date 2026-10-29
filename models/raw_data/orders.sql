
-- escullo aqsta taula x incremental: pq a la taula, es poden anar editant els estatus de les orders
{{
    config(materialized='incremental', unique_key='O_ORDERKEY')
}}



select *
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}
{#1r: em carrega tota la taula i despres, mira la condicio i edita només allo q cal cumpleix condicio:
q sigui un any mes antic q ..... any actual-124 o l'altra condicio: una de les 2 minim#}

{#o open , F es fulfilled i P partially, vull q s'actualitzon nomes les comandes q estan en O o P#}
{#exemple de data yyyy-mm-dd#}
{%if is_incremental()%}
    where O_ORDERSTATUS='O' or O_ORDERSTATUS='P'
{%endif%}


{#where O_ORDERDATE<=dateadd(year, -34,CURRENT_DATE) or O_ORDERSTATUS='O'#}


