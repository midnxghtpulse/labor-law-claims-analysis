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
