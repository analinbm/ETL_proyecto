select *
from {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }}

--els noms q jo he escollit a dbt