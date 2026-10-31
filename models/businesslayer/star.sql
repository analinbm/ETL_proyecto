fact_table
time_dim select()
customer_dim select()
supplier_dim
part_dim
region_dim



from {{ source('EDIT_SAMPLE_DATA', 'CUSTOMERS') }}