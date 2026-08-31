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
