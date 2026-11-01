select O.O_ORDERSTATUS, count(*) as number
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
group by O.O_ORDERSTATUS
