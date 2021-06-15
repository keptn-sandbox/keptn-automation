#!/bin/bash

echo "================================================================="
echo "Test onboard with no CONFIGURE_DT_MONITORING "
echo "================================================================="

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_SHIPYARD_FILE=$KEPTN_SHIPYARD_FILE \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    --env DEBUG=$DEBUG \
    -v $(pwd):$MOUNT/ \
    $IMAGE \
    onboard-service.sh