#!/bin/bash

echo "================================================================="
echo "Test CREATE_DT_SECRET"
echo "================================================================="

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env DT_BASE_URL=$DT_BASE_URL \
    --env DT_API_TOKEN=$DT_API_TOKEN \
    $IMAGE \
    create-dynatrace-secret.sh