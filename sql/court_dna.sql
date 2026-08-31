-- court dna [theme incidence by judging body]

select
    judging_body,
    count(*) as total_cases,

    round(
        100.0 * sum(horas_extras) / count(*),
        2
    ) as pct_horas_extras,

    round(
        100.0 * sum(dano_moral) / count(*),
        2
    ) as pct_dano_moral,

    round(
        100.0 * sum(insalubridade) / count(*),
        2
    ) as pct_insalubridade,

    round(
        100.0 * sum(periculosidade) / count(*),
        2
    ) as pct_periculosidade,

    round(
        100.0 * sum(relacao_emprego) / count(*),
        2
    ) as pct_relacao_emprego,

    round(
        100.0 * sum(rescisao_indireta) / count(*),
        2
    ) as pct_rescisao_indireta,

    round(
        100.0 * sum(verbas_rescisorias) / count(*),
        2
    ) as pct_verbas_rescisorias,

    round(
        100.0 * sum(fgts) / count(*),
        2
    ) as pct_fgts,

    round(
        100.0 * sum(aviso_previo) / count(*),
        2
    ) as pct_aviso_previo,

    round(
        100.0 * sum(intervalo_intrajornada) / count(*),
        2
    ) as pct_intervalo_intrajornada

from labor_claims

group by judging_body

having count(*) >= 50

order by total_cases desc;

-- comparing each court with the trt5 baseline to improve court dna

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

where ct.total_cases >= 50

order by
    c.judging_body,
    difference_pp desc;

-- most common theme combinations by judging body [still working on court dna]

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
    theme_1 || ' + ' || theme_2 as combination,
    total_cases,
    pct_of_court_cases,
    combination_rank

from ranked_pairs

where combination_rank <= 5

order by
    judging_body,
    combination_rank;
