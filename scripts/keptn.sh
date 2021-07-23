#!/usr/bin/env bash

# Required parameters for auth
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}

# suppress message workaround - https://github.com/keptn/keptn/issues/4553
bash -c "mkdir -p /root/.kube && touch /root/.kube/config"
bash -c "ls -l /root/.kube"

echo ""
echo "================================================================="
echo "Keptn command:"
echo "$*"
echo "================================================================="
echo ""
bash -c "keptn auth --api-token $KEPTN_API_TOKEN --endpoint $KEPTN_BASE_URL && keptn $*" 
