import pandas as pd
from itertools import combinations

df = pd.read_csv("data/trt5_processes_clean.csv")

themes = [
    "horas_extras",
    "dano_moral",
    "insalubridade",
    "periculosidade",
    "relacao_emprego",
    "rescisao_indireta",
    "verbas_rescisorias",
    "fgts",
    "aviso_previo",
    "intervalo_intrajornada"
]

results = []

for theme_a, theme_b in combinations(themes, 2):
    both = ((df[theme_a] == 1) & (df[theme_b] == 1)).sum()

    total_a = (df[theme_a] == 1).sum()
    total_b = (df[theme_b] == 1).sum()

    pct_a_with_b = both / total_a * 100 if total_a > 0 else 0
    pct_b_with_a = both / total_b * 100 if total_b > 0 else 0

    results.append({
        "theme_1": theme_a,
        "theme_2": theme_b,
        "both_count": both,
        "pct_theme1_with_theme2": round(pct_a_with_b, 2),
        "pct_theme2_with_theme1": round(pct_b_with_a, 2)
    })

associations = pd.DataFrame(results)

associations = associations.sort_values(
    by="both_count",
    ascending=False
)

print(associations.head(20).to_string(index=False))

associations.to_csv(
    "data/theme_associations.csv",
    index=False,
    encoding="utf-8-sig"
)
