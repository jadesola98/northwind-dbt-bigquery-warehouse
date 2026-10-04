-- One big table for purchasing reporting: every purchase order line with its
-- supplier, employee and product details already joined.
-- Replaces obt_customer_reporting, which joined purchase orders to customers.

with source as (
    select
        po.purchase_order_line_id,
        po.purchase_order_id,
        po.creation_date,
        po.submitted_date,
        po.approved_date,
        po.expected_date,
        po.date_received,
        po.payment_date,
        po.status_id,
        po.quantity,
        po.unit_cost,
        po.posted_to_inventory,
        po.inventory_id,
        po.shipping_fee,
        po.taxes,
        po.payment_amount,
        po.payment_method,
        s.supplier_id,
        s.company           as supplier_company,
        s.last_name         as supplier_contact_last_name,
        s.first_name        as supplier_contact_first_name,
        s.email_address     as supplier_email_address,
        s.city              as supplier_city,
        s.country_region    as supplier_country_region,
        e.employee_id,
        e.last_name         as employee_last_name,
        e.first_name        as employee_first_name,
        e.job_title         as employee_job_title,
        p.product_id,
        p.product_code,
        p.product_name,
        p.category          as product_category,
        p.standard_cost,
        p.list_price,
        p.reorder_level,
        p.target_level,
        current_timestamp() as insertion_timestamp
    from {{ ref('fact_purchase_order') }} po
    left join {{ ref('dim_supplier') }} s
        on s.supplier_id = po.supplier_id
    left join {{ ref('dim_employees') }} e
        on e.employee_id = po.employee_id
    left join {{ ref('dim_product') }} p
        on p.product_id = po.product_id
)

select * from source
