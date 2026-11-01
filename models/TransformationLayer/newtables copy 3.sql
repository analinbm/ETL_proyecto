-----------------------------------------------------------------------------------------------------
select O.O_ORDERKEY, count(L.L_ORDERKEY) as num_line_items from {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O
left join {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L on L.L_ORDERKEY=O.O_ORDERKEY
group by O.O_ORDERKEY

----------------------------------------------------------------------------------------------------------------------------------------------