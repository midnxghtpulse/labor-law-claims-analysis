import requests
import pandas as pd
import time

url = "https://api-publica.datajud.cnj.jus.br/api_publica_trt5/_search"

headers = {
    "Authorization": "APIKey cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw==",
    "Content-Type": "application/json"
}

page_size = 1000
max_processes = 10000

rows = []
search_after = None


while len(rows) < max_processes:

    query = {
        "size": page_size,

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
            "term": {
                "grau.keyword": "G1"
            }
        },

        "sort": [
            {
                "id.keyword": {
                    "order": "asc"
                }
            }
        ]
    }

    if search_after is not None:
        query["search_after"] = search_after

    response = requests.post(
        url,
        headers=headers,
        json=query
    )

    response.raise_for_status()

    data = response.json()

    hits = data["hits"]["hits"]

    if not hits:
        break

    for hit in hits:

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
            "municipality_code": process.get(
                "orgaoJulgador", {}
            ).get("codigoMunicipioIBGE"),
            "subjects": " | ".join(subjects)
        })

        if len(rows) >= max_processes:
            break

    search_after = hits[-1]["sort"]

    print(f"{len(rows)} processes collected...")

    time.sleep(0.5)


df = pd.DataFrame(rows)

df.to_csv(
    "data/trt5_processes.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\ncollection finished.")
print(f"{len(df)} processes saved.")
print("data/trt5_processes.csv")