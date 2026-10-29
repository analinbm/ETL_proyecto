
-- escullo aqsta taula x incremental: pq a la taula, es poden anar editant els estatus de les orders, es de tipus table
--dbt build --select orders --full-refresh --per reiniciar taula i tornar a les dades  inicials
-- dbt build --select orders 

--resultats guardats a ANALYTICS.DBT_ANALINBM.ORDERS x snowflake


-- dbt build 


-- vull q es faci nova columna on es posi si s'ha fet update o no


{{
    config(materialized='incremental', unique_key='O_ORDERKEY')
}}



select O_ORDERKEY,O_CUSTKEY,O_ORDERSTATUS,O_TOTALPRICE,O_ORDERDATE,O_ORDERPRIORITY,O_CLERK,O_SHIPPRIORITY,O_COMMENT,
{% if is_incremental()%}
    'UPDATED'
{%else%}
    'NOT UPDATED'
{%endif%}
as O_ORD_STAT_UPDATE
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}


{#o open , F es fulfilled i P partially, vull q s'actualitzon nomes les comandes q estan en O o P#}
{#exemple de data yyyy-mm-dd#}

{#1r: em carrega tota la taula i despres, mira la condicio i edita només allo q cal cumpleix condicio:
q sigui un any mes antic q .....(al final no ho he fet aixi) o l'altra condicio: una de les 2 minim#}
{#es fa update de la taula inicial: edito les rows q compleixen les condicions i n'afegeixo d noves#}
{%if is_incremental()%}
    where O_ORDERSTATUS='O' or O_ORDERSTATUS='P'
{%endif%}


{#where O_ORDERDATE<=dateadd(year, -34,CURRENT_DATE) or O_ORDERSTATUS='O'#}


