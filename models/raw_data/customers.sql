truncate table
select *
from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }}
