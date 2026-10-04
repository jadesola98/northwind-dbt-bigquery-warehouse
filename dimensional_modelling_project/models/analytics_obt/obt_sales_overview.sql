-- One big table for sales reporting: every sales order line with its
-- customer, employee and product details already joined.

with source as (
    select
        s.order_line_id,
        s.order_id,
        s.order_date,
        s.shipped_date,
        s.paid_date,
        s.shipper_id,
        s.quantity,
        s.unit_price,
        s.discount,
        s.status_id,
        s.date_allocated,
        s.purchase_order_id,
        s.inventory_id,
        c.customer_id,
        c.company           as customer_company,
        c.last_name         as customer_last_name,
        c.first_name        as customer_first_name,
        c.email_address     as customer_email_address,
        c.job_title         as customer_job_title,
        c.business_phone    as customer_business_phone,
        c.mobile_phone      as customer_mobile_phone,
        c.fax_number        as customer_fax_number,
        c.address           as customer_address,
        c.city              as customer_city,
        c.state_province    as customer_state_province,
        c.zip_postal_code   as customer_zip_postal_code,
        c.country_region    as customer_country_region,
        e.employee_id,
        e.last_name         as employee_last_name,
        e.first_name        as employee_first_name,
        e.email_address     as employee_email_address,
        e.job_title         as employee_job_title,
        e.city              as employee_city,
        e.country_region    as employee_country_region,
        p.product_id,
        p.product_code,
        p.product_name,
        p.description       as product_description,
        p.supplier_company,
        p.standard_cost,
        p.list_price,
        p.category          as product_category,
        p.discontinued,
        current_timestamp() as insertion_timestamp
    from {{ ref('fact_sales') }} s
    left join {{ ref('dim_customer') }} c
        on c.customer_id = s.customer_id
    left join {{ ref('dim_employees') }} e
        on e.employee_id = s.employee_id
    left join {{ ref('dim_product') }} p
        on p.product_id = s.product_id
)

select * from source
