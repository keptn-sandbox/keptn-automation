#!/bin/bash

image=$1              # e.g. robjahn/keptn-quality-gate
keptnApiUrl=$2        # e.g. https://api.keptn.<YOUR VALUE>.xip.io
keptnApiToken=$3
start=$4              # e.g. 2019-11-21T11:00:00.000Z
end=$5                # e.g. 2019-11-21T11:00:10.000Z
project=$6            # e.g. keptnorders
service=$7            # e.g. frontend
stage=$8              # e.g. staging
debug=$9  # e.g. OPTIONAL values - pass in Y

clear

echo ""
echo "==============================================="
echo "running keptn-quality-gate"
echo "image          = $image"
echo "keptnApiUrl    = $keptnApiUrl"
echo "keptnApiToken  = $keptnApiToken"
echo "start          = $start"
echo "end            = $end"
echo "project        = $project"
echo "service        = $service"
echo "stage          = $stage"
echo "debug          = $debug"
echo "==============================================="
docker run -it --rm \
    --env KEPTN_URL=$keptnApiUrl \
    --env KEPTN_TOKEN=$keptnApiToken \
    --env START=$start \
    --env END=$end \
    --env PROJECT=$project \
    --env SERVICE=$service \
    --env STAGE=$stage \
    --env DEBUG=$debug \
    $image