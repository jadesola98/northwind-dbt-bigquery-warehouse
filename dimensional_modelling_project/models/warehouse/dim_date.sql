-- One row per calendar day from 2005-01-01 to 2050-01-01.

select
    format_date('%F', d)            as id,
    d                               as full_date,
    extract(year from d)            as year,
    extract(week from d)            as year_week,
    extract(dayofyear from d)       as year_day,
    extract(year from d)            as fiscal_year,
    format_date('%Q', d)            as fiscal_qtr,
    extract(month from d)           as month,
    format_date('%B', d)            as month_name,
    format_date('%w', d)            as week_day,
    format_date('%A', d)            as day_name,
    case
        when format_date('%A', d) in ('Saturday', 'Sunday') then 1
        else 0
    end                             as is_weekend
from unnest(generate_date_array('2005-01-01', '2050-01-01', interval 1 day)) as d