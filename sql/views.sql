-- power bi view: court dna theme profile

create view vw_court_theme_profile as

with court_theme_rates as (

    select
        judging_body,
        theme,
        count(distinct process_id) as theme_cases

    from labor_claim_themes

    group by
        judging_body,
        theme
),

court_totals as (

    select
        judging_body,
        count(*) as total_cases

    from labor_claims

    group by judging_body
),

trt5_theme_rates as (

    select
        theme,
        count(distinct process_id) as theme_cases

    from labor_claim_themes

    group by theme
),

trt5_total as (

    select count(*) as total_cases
    from labor_claims
)

select
    c.judging_body,
    c.theme,

    round(
        100.0 * c.theme_cases / ct.total_cases,
        2
    ) as court_pct,

    round(
        100.0 * t.theme_cases / tt.total_cases,
        2
    ) as trt5_pct,

    round(
        (100.0 * c.theme_cases / ct.total_cases)
        -
        (100.0 * t.theme_cases / tt.total_cases),
        2
    ) as difference_pp

from court_theme_rates c

join court_totals ct
    on c.judging_body = ct.judging_body

join trt5_theme_rates t
    on c.theme = t.theme

cross join trt5_total tt

where ct.total_cases >= 50;
