{#li passo un key d una part, i el dia el qual miro #}
{#vull q em retorni PARTKEY, quantitat q sha venut en aquell mes(QUANTITY_SOLD_MONTH)
s/importar proveidor, si necessito stock (RE_STOCK_NEED)#}




{% macro re_stock_inventory(part_key,date_sales) %}
    
    select {{part_key}} as PARTKEY,coalesce(sum(L.L_QUANTITY),0) as Quantity_sold_month,
    case 
        when coalesce(sum(L.L_QUANTITY),0) >=60 then 'YES'
        else 'NO'
    end as re_stock_need,    
    
    from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L where L.L_PARTKEY={{part_key}} and month(L_SHIPDATE)=month('{{date_sales}}'::date) and year(L_SHIPDATE)=year('{{date_sales}}'::date)
{% endmacro %}
{{re_stock_inventory(142916,'1994-08-29')}}



----------------------------------------------------------------------



{% macro delivery_delays(days_delay=1) %}
    select L.L_PARTKEY,L.L_SHIPDATE, L.L_RECEIPTDATE, L.L_COMMITDATE, {{dbt.datediff("L.L_COMMITDATE", "L.L_RECEIPTDATE", "day")}} as days_delayed   
    from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
    where {{dbt.datediff('L.L_COMMITDATE', 'L.L_RECEIPTDATE', 'day')}}>={{days_delay}}
{% endmacro %}