#!/usr/bin/env bash

# Required parameters for auth
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}

# authorize keptn cli
keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL"
if [ $? -ne 0 ]; then
    echo "Aborting: Failed to authenticate Keptn CLI"
    exit 1
fi

echo ""
echo "================================================================="
echo "Keptn command:"
echo "$*"
echo "================================================================="
echo ""
bash -c "keptn auth --api-token $KEPTN_API_TOKEN --endpoint $KEPTN_BASE_URL && keptn $*" 
