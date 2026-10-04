-- Flags sales lines with zero or negative quantity.
-- Set to warn, not fail: order 81 in the source data has two lines with a
-- quantity of 0. They are real source records, so they're kept in fact_sales
-- and surfaced here rather than silently filtered out.
{{ config(severity='warn') }}

select
    order_line_id,
    order_id,
    product_id,
    quantity
from {{ ref('fact_sales') }}
where quantity <= 0