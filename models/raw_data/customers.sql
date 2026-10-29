select *
from {{ source('EDIT_SAMPLE_DATA', 'raw_CUSTOMER') }}