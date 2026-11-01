--part(pieza vendida),subministrament preu, preu retail: parella peça-proveïdor
--si la pieza esta molt demanada (high, regular low), per comparar proveidors
select PS.PS_PARTKEY, PS.PS_SUPPKEY, PS.PS_SUPPLYCOST, P.P_RETAILPRICE, (P.P_RETAILPRICE-PS.PS_SUPPLYCOST) as Unitary_Margin, 
case
    when count(L.L_PARTKEY)>5 then 'HIGH'
    when count(L.L_PARTKEY) between 1 and 5 then 'REGULAR'
    else 'LOW'
end
as Type_demand
from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS
left join {{ source('EDIT_SAMPLE_DATA', 'PART') }} P on P.P_PARTKEY=PS.PS_PARTKEY
left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L on L.L_SUPPKEY=PS.PS_SUPPKEY and L.L_PARTKEY=PS.PS_PARTKEY and L.L_RETURNFLAG<>'R'
group by PS.PS_PARTKEY, PS.PS_SUPPKEY, PS.PS_SUPPLYCOST, P.P_RETAILPRICE


