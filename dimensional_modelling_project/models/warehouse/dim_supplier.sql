-- One row per supplier. Added so fact_purchase_order has a proper supplier dimension.

with source as (
    select
        id as supplier_id,
        company,
        last_name,
        first_name,
        email_address,
        job_title,
        business_phone,
        home_phone,
        mobile_phone,
        fax_number,
        address,
        city,
        state_province,
        zip_postal_code,
        country_region,
        web_page,
        notes,
        attachments,
        current_timestamp() as insertion_timestamp
    from {{ ref('stg_suppliers') }}
),

unique_source as (
    select
        *,
        row_number() over (partition by supplier_id) as row_number
    from source
)

select * except (row_number)
from unique_source
where row_number = 1
