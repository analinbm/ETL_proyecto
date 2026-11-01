--time dim per a order

with dates_orders_lineitem as (
    select O_ORDERDATE as specific_date from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} 
    union
    select L_SHIPDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}
    union
    select L_RECEIPTDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}
    union
    select L_COMMITDATE from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }}

)


--totes les dates possibles les busco, dsp les poso dins d'una columna q s anomena specific_date

select distinct specific_date,DATE_PART('year',specific_date) as yy,DATE_PART('month',specific_date) as mm,DATE_PART('day',specific_date) as dd, quarter(specific_date) as Trimester
from dates_orders_lineitem


--fare nomes aqsta taula: llavors a powerBi faig totes les relacions i només activaré una, depen del q busco(si la data de la order, del L_SHIPDATE , L_RECEIPTDATE o del L_COMMITDATE)
