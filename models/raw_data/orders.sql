
-- escullo aqsta taula x incremental: pq a la taula, es poden anar editant els estatus de les orders

select *
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }}
insert 