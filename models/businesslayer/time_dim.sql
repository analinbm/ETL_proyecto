
select O_ORDERDATE,DATE_PART('year',O_ORDERDATE) as yy,DATE_PART('month',O_ORDERDATE) as mm,DATE_PART('day',O_ORDERDATE) as dd, quarter(O_ORDERDATE) as Trimester
from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} 