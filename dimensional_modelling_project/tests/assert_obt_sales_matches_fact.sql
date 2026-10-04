-- The left joins in obt_sales_overview must not add or drop rows.
-- Fails if the OBT and the fact table have different row counts.

with counts as (
    select
        (select count(*) from {{ ref('fact_sales') }})         as fact_rows,
        (select count(*) from {{ ref('obt_sales_overview') }}) as obt_rows
)

select *
from counts
where fact_rows != obt_rows
