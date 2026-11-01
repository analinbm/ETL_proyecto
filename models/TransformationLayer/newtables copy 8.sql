--RETURN FLAG I NUM_COMANDES
--quantitat dE NUM_COMANDES X RETURN FLAG
select L.L_RETURNFLAG, count(*) as number_item 
from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
group by L.L_RETURNFLAG
--having count(O.O_ORDERKEY)>1
