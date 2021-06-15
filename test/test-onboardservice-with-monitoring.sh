#!/bin/bash

echo "================================================================="
echo "Test onboard with CONFIGURE_DT_MONITORING"
echo "================================================================="

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_SHIPYARD_FILE=$KEPTN_SHIPYARD_FILE \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    --env DEBUG=$DEBUG \
    --env CONFIGURE_DT_MONITORING=$CONFIGURE_DT_MONITORING \
    --env DT_BASE_URL=$DT_BASE_URL \
    --env DT_API_TOKEN=$DT_API_TOKEN \
    --env DT_CONF_FILE=$DT_CONF_FILE \
    -v $(pwd):$MOUNT/ \
    $IMAGE \
    onboard-service.sh