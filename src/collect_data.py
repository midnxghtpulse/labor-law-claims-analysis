import requests
import json

url = "https://api-publica.datajud.cnj.jus.br/api_publica_trt5/_search"

headers = {
    "Authorization": "APIKey cDZHYzlZa0JadVREZDJCendQbXY6SkJlTzNjLV9TRENyQk1RdnFKZGRQdw==",
    "Content-Type": "application/json"
}

query = {
    "size": 5,
    "query": {
        "match_all": {}
    }
}

response = requests.post(
    url,
    headers=headers,
    data=json.dumps(query)
)

print("status:", response.status_code)
print(response.text)
