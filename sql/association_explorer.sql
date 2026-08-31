-- given one theme, find what usually appears with it [association explorwr]

with selected_cases as (
    select process_id
    from labor_claim_themes
    where theme = 'dano_moral'
),

associated_themes as (
    select
        lct.theme,
        count(distinct lct.process_id) as cases_with_theme
    from labor_claim_themes lct
    join selected_cases sc
        on lct.process_id = sc.process_id
    where lct.theme <> 'dano_moral'
    group by lct.theme
),

total_selected as (
    select count(distinct process_id) as total_cases
    from selected_cases
)

select
    a.theme,
    a.cases_with_theme,
    round(
        100.0 * a.cases_with_theme / t.total_cases,
        2
    ) as association_pct

from associated_themes a
cross join total_selected t

order by association_pct desc;
