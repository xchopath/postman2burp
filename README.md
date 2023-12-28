# postman2burp

Automate the logging of your Postman Collection' endpoints into Burp Suite History with postman2burp.

![Postman2burp drawio](https://github.com/xchopath/postman2burp/assets/44427665/f13e9eb8-7969-45ef-a7b2-51e9cd5cf250)

## Requirement
- `jq`
- `curl`

## Setup

Go to downloaded repo:
```
cd postman2burp/
```

Make a copy of environment variable file:
```
cp .env.example .env
```

Variable adjustment:
```
POSTMAN_JSON_FILE="/path-to/postman_collection.json"
BURP_PROXY="http://127.0.0.1:8080"
URL_HOST="https://api.yours.dev"
CUSTOM_HEADERS=("Content-Type: application/json" "User-Agent: PostmanRuntime/7.35.0")
```

## How to Use

If all done, you can just run the script.

Example:
```
bash postman2burp.sh
```
