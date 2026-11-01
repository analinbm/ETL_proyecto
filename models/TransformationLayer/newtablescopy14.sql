---PER SABER QUANTS HI HA TIPU_mkt
select C.C_MKTSEGMENT, count(*) as number
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }} C
group by C.C_MKTSEGMENT

