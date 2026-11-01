--quantitat de orders x cada status
select O.O_ORDERSTATUS, count(*) as number_orders
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS

