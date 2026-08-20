import pandas as pd
import unicodedata


def normalize_text(text):
    text = str(text).lower()

    text = unicodedata.normalize("NFKD", text)
    text = "".join(
        char for char in text
        if not unicodedata.combining(char)
    )

    return text.strip()


df = pd.read_csv("data/trt5_processes.csv")

df["subjects"] = df["subjects"].fillna("")
df["subjects_normalized"] = df["subjects"].apply(normalize_text)


themes = {
    "horas_extras": "horas extras",
    "dano_moral": "dano moral",
    "insalubridade": "insalubridade",
    "periculosidade": "periculosidade",
    "relacao_emprego": "relacao de emprego",
    "rescisao_indireta": "rescisao indireta",
    "verbas_rescisorias": "verbas rescisorias",
    "fgts": "fgts",
    "aviso_previo": "aviso previo",
    "intervalo_intrajornada": "intervalo intrajornada"
}


for column_name, keyword in themes.items():
    df[column_name] = (
        df["subjects_normalized"]
        .str.contains(keyword, regex=False)
        .astype(int)
    )


df.drop(columns=["subjects_normalized"], inplace=True)


df.to_csv(
    "data/trt5_processes_clean.csv",
    index=False,
    encoding="utf-8-sig"
)


print("theme counts:\n")

print(
    df[list(themes.keys())]
    .sum()
    .sort_values(ascending=False)
)

print("\nclean dataset saved:")
print("data/trt5_processes_clean.csv")