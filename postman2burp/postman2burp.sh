#!/usr/bin/env bash
# Send all Postman Collection's endpoints to Burp Suite (History)

##### CONFIG #####
POSTMAN_JSON_FILE="/path-to/postman_collections.json"
BURP_PROXY="http://127.0.0.1:8080"
URL_HOST="https://api.yours.dev"

# You Can Add Your Authentication Header Below
HEADERS=("Content-Type: application/json" "User-Agent: PostmanRuntime/7.35.0")
##################

IFS=$'\n'
for ROW in $(cat ${POSTMAN_JSON_FILE} | jq -c '.. | .request?' | grep ^'{' | jq -c '.')
do
	HTTP_METHOD=$(echo "${ROW}" | jq -r '.method')
	URL_PATH=$(echo "${ROW}" | jq -c '.url.path' | jq -r '"/" + .[]' 2> /dev/null | tr -d '\n')
	URL_QUERY=$(echo "${ROW}" | jq -c '.url.query' | jq -r 'map("\(.key)=\(.value)") | join("&")' 2> /dev/null)
	REQUEST_BODY=$(echo "${ROW}" | jq -r '.body.raw' | jq -r -c '.' | grep -v ^'null'$)

	if [[ ! -z ${URL_QUERY} ]]; then
		URL_QUERY="?${URL_QUERY}"
	fi
	if [[ -z ${URL_PATH} ]]; then
		continue
	fi

	# CRAFT CURL
	CURL_COMMANDS="curl -s -k"
	if [[ ! -z ${BURP_PROXY} ]]; then
		CURL_COMMANDS+=" --proxy \"${BURP_PROXY}\""
	fi
	CURL_COMMANDS+=" -X ${HTTP_METHOD} \"${URL_HOST}${URL_PATH}${URL_QUERY}\""
	for HEADER in "${HEADERS[@]}"; do
		CURL_COMMANDS+=" -H '$HEADER'"
	done
	if [[ ! -z ${REQUEST_BODY} ]]; then
		CURL_COMMANDS+=" --data '${REQUEST_BODY}'"
	fi

	# RUN CURL
	eval "${CURL_COMMANDS}"
done
