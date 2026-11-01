--localitat geografica del client / del proveidor
select N.N_NATIONKEY,N.N_NAME,R.R_REGIONKEY,R.R_NAME
from {{ source('EDIT_SAMPLE_DATA', 'NATION') }} N
left JOIN {{ source('EDIT_SAMPLE_DATA', 'REGION') }} R ON R.R_REGIONKEY=N.N_REGIONKEY

