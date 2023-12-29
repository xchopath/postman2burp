#!/usr/bin/env bash
# Send all Postman Collection's endpoints to Burp Suite (History)

echo '  ___          ___     '
echo ' | _ \        | _ )    '
echo ' |  _/        | _ \    '
echo ' |_|OSTMAN TO |___/URP '
echo ''

if [[ ! -z ${POSTMAN_JSON_FILE} ]] || [[ ! -z ${BURP_PROXY} ]] || [[ ! -z ${URL_HOST} ]] || [[ ! -z ${CUSTOM_HEADERS} ]]; then
	echo -ne ''
elif [[ -f .env ]]; then
	source .env
else
	echo "ERROR: Could not read the variables, please read the documentation properly."
	exit
fi

if [[ ! -f ${POSTMAN_JSON_FILE} ]]; then
	echo "ERROR: Could not find Postman File, please configure .env file properly."
	exit
fi

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
	for HEADER in "${CUSTOM_HEADERS[@]}"; do
		CURL_COMMANDS+=" -H '$HEADER'"
	done
	if [[ ! -z ${REQUEST_BODY} ]]; then
		CURL_COMMANDS+=" --data '${REQUEST_BODY}'"
	fi

	# RUN CURL
	eval "${CURL_COMMANDS}"
done
