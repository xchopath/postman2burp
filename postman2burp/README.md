# postman2burp

Automate and log all your Postman Collection endpoints to Burp Suite History (with zero effort).

## Requirement
- `jq`
- `curl`

## Configuration

Variable adjustment.
```
POSTMAN_JSON_FILE="/path-to/postman_collection.json"
BURP_PROXY="http://127.0.0.1:8080"
URL_HOST="https://api.yours.dev"
```

You can insert your authentication headers here.
```
HEADERS=("Content-Type: application/json" "User-Agent: PostmanRuntime/7.35.0")
```

## How to Use

You can just run the script.

Example:
```
bash postman2burp.sh
```