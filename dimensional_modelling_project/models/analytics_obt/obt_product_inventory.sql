-- One big table for stock reporting: every inventory transaction with its
-- product details already joined.

with source as (
    select
        i.inventory_id,
        i.transaction_type,
        i.transaction_created_date,
        i.transaction_modified_date,
        i.quantity,
        i.purchase_order_id,
        i.customer_order_id,
        i.comments,
        p.product_id,
        p.product_code,
        p.product_name,
        p.description       as product_description,
        p.supplier_company,
        p.standard_cost,
        p.list_price,
        p.reorder_level,
        p.target_level,
        p.quantity_per_unit,
        p.discontinued,
        p.minimum_reorder_quantity,
        p.category          as product_category,
        current_timestamp() as insertion_timestamp
    from {{ ref('fact_inventory') }} i
    left join {{ ref('dim_product') }} p
        on p.product_id = i.product_id
)

select * from source
