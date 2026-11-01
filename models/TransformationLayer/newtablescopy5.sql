select L.L_SHIPMODE, count(distinct(O.O_ORDERKEY)) as number_orders
FROM {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
left join {{ source('EDIT_SAMPLE_DATA', 'ORDERS') }} O ON O.O_ORDERKEY=L.L_ORDERKEY
group by L.L_SHIPMODE
