select *
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}