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
    count = (
        (df[theme_a] == 1) &
        (df[theme_b] == 1)
    ).sum()

    results.append({
        "theme_1": theme_a,
        "theme_2": theme_b,
        "count": count
    })

cooccurrence = pd.DataFrame(results)

cooccurrence = cooccurrence.sort_values(
    by="count",
    ascending=False
)

print(cooccurrence.head(20).to_string(index=False))

cooccurrence.to_csv(
    "data/theme_cooccurrence.csv",
    index=False,
    encoding="utf-8-sig"
)