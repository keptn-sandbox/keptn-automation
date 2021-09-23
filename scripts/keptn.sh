#!/usr/bin/env bash

# Required parameters for auth
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}
DEBUG=${DEBUG:="false"}

echo "================================================================="
echo "Run Keptn Command:"
echo ""
echo "KEPTN_BASE_URL = $KEPTN_BASE_URL"
echo "DEBUG          = $DEBUG"
echo "================================================================="
echo "Keptn command with tokens removed:"
echo ""
echo keptn $* | sed -r 's/token=[^ ]+/token=/gi'
echo "================================================================="
echo ""

echo "Calling keptn set config kubeContextCheck false"
keptn set config kubeContextCheck false

if [[ "${DEBUG}" == "true" ]]; then
    if [ ! -z $MOUNT ]; then
        echo "Local files within $MOUNT"
        ls -l $MOUNT
    fi
    echo "================================================================="
    echo ""
    bash -c "keptn auth --api-token $KEPTN_API_TOKEN --endpoint $KEPTN_BASE_URL && keptn -v $*"
else
    bash -c "keptn auth --api-token $KEPTN_API_TOKEN --endpoint $KEPTN_BASE_URL && keptn $*"
fi
