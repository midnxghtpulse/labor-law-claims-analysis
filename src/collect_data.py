import requests
import pandas as pd

url = "https://api-publica.datajud.cnj.jus.br/api_publica_trt5/_search"

headers = {
    "Authorization": "APIKey cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw==",
    "Content-Type": "application/json"
}

query = {
    "size": 10,
    "_source": [
        "id",
        "numeroProcesso",
        "tribunal",
        "grau",
        "dataAjuizamento",
        "classe",
        "orgaoJulgador",
        "assuntos"
    ],
    "query": {
        "match_all": {}
    }
}

response = requests.post(
    url,
    headers=headers,
    json=query
)

data = response.json()

rows = []

for hit in data["hits"]["hits"]:
    process = hit["_source"]

    subjects = [
        subject["nome"].strip()
        for subject in process.get("assuntos", [])
    ]

    rows.append({
        "process_id": process.get("id"),
        "process_number": process.get("numeroProcesso"),
        "court": process.get("tribunal"),
        "degree": process.get("grau"),
        "filing_date": process.get("dataAjuizamento"),
        "case_class": process.get("classe", {}).get("nome"),
        "judging_body": process.get("orgaoJulgador", {}).get("nome"),
        "municipality_code": process.get("orgaoJulgador", {}).get("codigoMunicipioIBGE"),
        "subjects": " | ".join(subjects)
    })

df = pd.DataFrame(rows)

print(df.to_string(index=False))
