{#li passo un key d una part, i el dia el qual miro #}
{#vull q em retorni PARTKEY, quantitat q sha venut en aquell mes(QUANTITY_SOLD_MONTH)
s/importar proveidor, si necessito stock (RE_STOCK_NEED)#}
{#VULL Q TMB RETORNI el MILLOR SUPPLIER, supp q te mes stock#}
{% macro re_stock_inventory(part_key,date_sales) %}
    
    WITH SALES_MONTH AS (select {{part_key}} as PARTKEY,coalesce(sum(L.L_QUANTITY),0) as Quantity_sold_month
    from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
    where L.L_PARTKEY={{part_key}} and month(L_SHIPDATE)=month('{{date_sales}}'::date) and year(L_SHIPDATE)=year('{{date_sales}}'::date)),

    best_supplier as (select PS.PS_PARTKEY,PS.PS_SUPPKEY, S.S_NAME, PS.PS_AVAILQTY, ROW_NUMBER() over (partition by PS.PS_PARTKEY order by PS.PS_AVAILQTY desc) as rank_best_supp 
    from {{ source('EDIT_SAMPLE_DATA', 'PARTSUPP') }} PS
    left join {{ source('EDIT_SAMPLE_DATA', 'SUPPLIER') }} S on S.S_SUPPKEY=PS.PS_SUPPKEY
    where PS_PARTKEY={{part_key}})
    
    select SALES_MONTH.PARTKEY, SALES_MONTH.QUANTITY_SOLD_MONTH,
    case 
        when SALES_MONTH.Quantity_sold_month>=6 then 'YES'
        else 'NO'
    end as re_stock_need,
    best_supplier.S_NAME as best_supplier_month
    from SALES_MONTH
    left join best_supplier on best_supplier.PS_PARTKEY=SALES_MONTH.PARTKEY and best_supplier.rank_best_supp=1
    
{% endmacro %}
--{{re_stock_inventory(142916,'1994-08-29')}}
{#ultim join: nomes vull nom supplier q té rank=1#}
----------------------------------------------------------------------



{% macro delivery_delays(days_delay=1) %}
    select L.L_PARTKEY,L.L_SHIPDATE, L.L_RECEIPTDATE, L.L_COMMITDATE, {{dbt.datediff("L.L_COMMITDATE", "L.L_RECEIPTDATE", "day")}} as days_delayed   
    from {{ source('EDIT_SAMPLE_DATA', 'LINEITEM') }} L
    where {{dbt.datediff('L.L_COMMITDATE', 'L.L_RECEIPTDATE', 'day')}}>={{days_delay}}
{% endmacro %}