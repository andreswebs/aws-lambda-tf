#!/usr/bin/env bash
EVENT_FILE="${1}"
curl \
    --request POST \
    --header "Content-Type: application/json" \
    --data "@${EVENT_FILE}" \
    "http://localhost:9000/2015-03-31/functions/function/invocations"
