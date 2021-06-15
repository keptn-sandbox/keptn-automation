#!/bin/bash

echo "================================================================="
echo "Test keptn - $KEPTN_COMMAND"
echo "================================================================="

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    $IMAGE \
    "keptn.sh $KEPTN_COMMAND"