-- Grain: one row per sales order line (order_details.id).

with source as (
    select
        od.id                   as order_line_id,
        od.order_id,
        od.product_id,
        o.customer_id,
        o.employee_id,
        o.shipper_id,
        od.quantity,
        od.unit_price,
        od.discount,
        od.status_id,
        od.date_allocated,
        od.purchase_order_id,
        od.inventory_id,
        date(o.order_date)      as order_date,
        o.shipped_date,
        o.paid_date,
        current_timestamp()     as insertion_timestamp
    from {{ ref('stg_orders') }} o
    inner join {{ ref('stg_order_details') }} od
        on od.order_id = o.id
),

unique_source as (
    select
        *,
        row_number() over (partition by order_line_id order by order_date desc) as row_number
    from source
)

select * except (row_number)
from unique_source
where row_number = 1
