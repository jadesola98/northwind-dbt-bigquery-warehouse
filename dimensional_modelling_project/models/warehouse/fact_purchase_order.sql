-- Grain: one row per purchase order line (purchase_order_details.id).
-- Purchase orders are placed with suppliers, so the dimensions here are
-- supplier, employee (who created the order) and product.
-- Note: shipping_fee, taxes and payment_amount are order-level values repeated
-- on every line of the same order, so don't sum them across lines.

with source as (
    select
        pod.id                    as purchase_order_line_id,
        po.id                     as purchase_order_id,
        po.supplier_id,
        po.created_by             as employee_id,
        pod.product_id,
        pod.quantity,
        pod.unit_cost,
        pod.date_received,
        pod.posted_to_inventory,
        pod.inventory_id,
        po.submitted_date,
        date(po.creation_date)    as creation_date,
        po.status_id,
        po.expected_date,
        po.shipping_fee,
        po.taxes,
        po.payment_date,
        po.payment_amount,
        po.payment_method,
        po.notes,
        po.approved_by,
        po.approved_date,
        po.submitted_by,
        current_timestamp()       as insertion_timestamp
    from {{ ref('stg_purchase_order_details') }} pod
    inner join {{ ref('stg_purchase_orders') }} po
        on po.id = pod.purchase_order_id
),

unique_source as (
    select
        *,
        row_number() over (partition by purchase_order_line_id order by creation_date desc) as row_number
    from source
)

select * except (row_number)
from unique_source
where row_number = 1
