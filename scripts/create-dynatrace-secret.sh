#!/usr/bin/env bash

# default the variables if not set
DEBUG=${DEBUG:="false"}

# Required parameters for auth
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}
DT_BASE_URL=${DT_BASE_URL:?'DT_BASE_URL envionmment variable missing.'}
DT_API_TOKEN=${DT_API_TOKEN:?'DT_API_TOKEN envionmment variable missing.'}

echo "================================================================="
echo "Create Dynatrace Secret"
echo ""
echo "KEPTN_BASE_URL = $KEPTN_BASE_URL"
echo "DT_BASE_URL    = $DT_BASE_URL"
echo "DEBUG          = $DEBUG"
echo "================================================================="

echo "Authorizing keptn cli"
keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL"
if [ $? -ne 0 ]; then
    echo "Aborting: Failed to authenticate Keptn CLI"
    exit 1
fi

echo "-----------------------------------------------------------------"
echo "delete secret dynatrace"
keptn delete secret dynatrace

echo "-----------------------------------------------------------------"
echo "keptn create secret"
keptn_cmd=$(echo keptn create secret dynatrace --from-literal=\""DT_TENANT="$DT_BASE_URL"\" --from-literal=\"KEPTN_API_TOKEN="$KEPTN_API_TOKEN"\" --from-literal=\"KEPTN_API_URL="$KEPTN_BASE_URL"/api\" --from-literal=\"KEPTN_BRIDGE_URL="$KEPTN_BASE_URL"/bridge\" --from-literal=\"DT_API_TOKEN="$DT_API_TOKEN""\")
if [[ "${DEBUG}" == "true" ]]; then
    echo "keptn keptn create secret command:"
    echo $keptn_cmd
fi
bash -c "$keptn_cmd"

echo "================================================================="
echo "Create Dynatrace Secret"
echo "================================================================="
