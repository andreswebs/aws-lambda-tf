#!/usr/bin/env bash
set -o nounset
set -o errexit

LOCAL_PORT="${LOCAL_PORT:-9000}"
IMAGE_PORT="${IMAGE_PORT:-8080}"

docker run \
    --name local-lambda \
    --platform "${PLATFORM}" \
    --rm \
    --detach \
    --volume ~/.aws-lambda-rie:/aws-lambda \
    --publish "${LOCAL_PORT}:${IMAGE_PORT}" \
    --entrypoint /aws-lambda/aws-lambda-rie \
    "${LOCAL_IMAGE}" "${@}"
