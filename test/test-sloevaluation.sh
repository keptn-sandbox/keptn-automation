#!/bin/bash

echo "================================================================="
echo "Test SLO evaluation"
echo "================================================================="

docker run -it --rm \
    --env EVALUATION_RULE=$EVALUATION_RULE \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_BRIDGE_URL=$KEPTN_BRIDGE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    --env SOURCE=$SOURCE \
    --env LABELS=$LABELS \
    --env START=$START \
    --env END=$END \
    --env TIMEFRAME=$TIMEFRAME \
    --env DEBUG=$DEBUG \
    $IMAGE \
    slo-evaluation.sh
