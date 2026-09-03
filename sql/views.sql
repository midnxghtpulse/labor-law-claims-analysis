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

-- power bi view: court dna theme combinations

create view vw_court_theme_combinations as

with theme_pairs as (

    select
        a.judging_body,
        a.process_id,
        a.theme as theme_1,
        b.theme as theme_2

    from labor_claim_themes a

    join labor_claim_themes b
        on a.process_id = b.process_id
        and a.judging_body = b.judging_body
        and a.theme < b.theme
),

pair_counts as (

    select
        judging_body,
        theme_1,
        theme_2,
        count(*) as total_cases

    from theme_pairs

    group by
        judging_body,
        theme_1,
        theme_2
),

court_totals as (

    select
        judging_body,
        count(*) as total_cases

    from labor_claims

    group by judging_body
),

ranked_pairs as (

    select
        p.judging_body,
        p.theme_1,
        p.theme_2,
        p.total_cases,

        round(
            100.0 * p.total_cases / ct.total_cases,
            2
        ) as pct_of_court_cases,

        row_number() over (
            partition by p.judging_body
            order by p.total_cases desc
        ) as combination_rank

    from pair_counts p

    join court_totals ct
        on p.judging_body = ct.judging_body

    where ct.total_cases >= 50
)

select
    judging_body,
    theme_1,
    theme_2,
    theme_1 || ' + ' || theme_2 as combination,
    total_cases,
    pct_of_court_cases,
    combination_rank

from ranked_pairs

where combination_rank <= 5;

-- power bi view: association explorer

create view vw_theme_associations as

with theme_totals as (

    select
        theme,
        count(distinct process_id) as total_cases

    from labor_claim_themes

    group by theme
)

select
    a.theme as source_theme,
    b.theme as associated_theme,
    count(distinct a.process_id) as cases_with_both,

    round(
        100.0 * count(distinct a.process_id) / t.total_cases,
        2
    ) as association_pct

from labor_claim_themes a

join labor_claim_themes b
    on a.process_id = b.process_id
    and a.theme <> b.theme

join theme_totals t
    on a.theme = t.theme

group by
    a.theme,
    b.theme,
    t.total_cases;
