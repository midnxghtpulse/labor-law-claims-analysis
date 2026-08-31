-- just some basic data validation

select count(*)
from labor_claims;


select *
from labor_claims
limit 5;

-- selected theme counts

select
    sum(horas_extras) as horas_extras,
    sum(dano_moral) as dano_moral,
    sum(fgts) as fgts
from labor_claims;


-- if a case contains moral damages, what usually appears with it?

select
    round(
        100.0 * count(*) filter (where horas_extras = 1) / count(*),
        2
    ) as pct_horas_extras,

    round(
        100.0 * count(*) filter (where fgts = 1) / count(*),
        2
    ) as pct_fgts,

    round(
        100.0 * count(*) filter (where aviso_previo = 1) / count(*),
        2
    ) as pct_aviso_previo,

    round(
        100.0 * count(*) filter (where verbas_rescisorias = 1) / count(*),
        2
    ) as pct_verbas_rescisorias,

    round(
        100.0 * count(*) filter (where intervalo_intrajornada = 1) / count(*),
        2
    ) as pct_intervalo_intrajornada

from labor_claims
where dano_moral = 1;

-- court dna [selected theme incidence by judging body]

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
        100.0 * sum(fgts) / count(*),
        2
    ) as pct_fgts,

    round(
        100.0 * sum(aviso_previo) / count(*),
        2
    ) as pct_aviso_previo,

    round(
        100.0 * sum(verbas_rescisorias) / count(*),
        2
    ) as pct_verbas_rescisorias

from labor_claims

group by judging_body

having count(*) >= 50

order by total_cases desc;

-- comparing with trt5 baseline to improve court dna

with trt5_average as (
    select
        100.0 * sum(horas_extras) / count(*) as horas_extras,
        100.0 * sum(dano_moral) / count(*) as dano_moral,
        100.0 * sum(fgts) / count(*) as fgts,
        100.0 * sum(aviso_previo) / count(*) as aviso_previo,
        100.0 * sum(verbas_rescisorias) / count(*) as verbas_rescisorias
    from labor_claims
),

court_profile as (
    select
        100.0 * sum(horas_extras) / count(*) as horas_extras,
        100.0 * sum(dano_moral) / count(*) as dano_moral,
        100.0 * sum(fgts) / count(*) as fgts,
        100.0 * sum(aviso_previo) / count(*) as aviso_previo,
        100.0 * sum(verbas_rescisorias) / count(*) as verbas_rescisorias
    from labor_claims
    where judging_body = '1ª Vara do Trabalho de Vitória da Conquista'
)

select
    'horas_extras' as theme,
    round(c.horas_extras, 2) as court_pct,
    round(t.horas_extras, 2) as trt5_pct,
    round(c.horas_extras - t.horas_extras, 2) as difference_pp
from court_profile c, trt5_average t

union all

select
    'dano_moral',
    round(c.dano_moral, 2),
    round(t.dano_moral, 2),
    round(c.dano_moral - t.dano_moral, 2)
from court_profile c, trt5_average t

union all

select
    'fgts',
    round(c.fgts, 2),
    round(t.fgts, 2),
    round(c.fgts - t.fgts, 2)
from court_profile c, trt5_average t

union all

select
    'aviso_previo',
    round(c.aviso_previo, 2),
    round(t.aviso_previo, 2),
    round(c.aviso_previo - t.aviso_previo, 2)
from court_profile c, trt5_average t

union all

select
    'verbas_rescisorias',
    round(c.verbas_rescisorias, 2),
    round(t.verbas_rescisorias, 2),
    round(c.verbas_rescisorias - t.verbas_rescisorias, 2)
from court_profile c, trt5_average t

order by difference_pp desc;
