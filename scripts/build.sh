#!/usr/bin/env bash
set -o nounset
set -o errexit

docker build --platform "${PLATFORM}" --provenance=false --load --tag "${LOCAL_IMAGE}" .

## --provenance=false
## See: https://stackoverflow.com/questions/65608802/cant-deploy-container-image-to-lambda-function
