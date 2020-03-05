#!/usr/bin/env bash

# Required parameters
KEPTN_URL=${KEPTN_URL:?'KEPTN_URL variable missing.'}
KEPTN_TOKEN=${KEPTN_TOKEN:?'KEPTN_TOKEN variable missing.'}
START=${START:?'START variable missing.'}
END=${END:?'END variable missing.'}
PROJECT=${PROJECT:?'PROJECT variable missing.'}
SERVICE=${SERVICE:?'SERVICE variable missing.'}
STAGE=${STAGE:?'STAGE variable missing.'}

echo "================================================================="
echo "Keptn Quality Gate:"
echo ""
echo "KEPTN_URL     = $KEPTN_URL"
echo "START         = $START"
echo "END           = $END"
echo "PROJECT       = $PROJECT"
echo "SERVICE       = $SERVICE"
echo "STAGE         = $STAGE"
echo "================================================================="

POST_DATA=$(cat <<EOF
{
  "data": {
    "start": "$START",
    "end": "$END",
    "project": "$PROJECT",
    "service": "$SERVICE",
    "stage": "$STAGE",
    "teststrategy": "manual"
  },
  "type": "sh.keptn.event.start-evaluation"
}
EOF
)

if [[ "${DEBUG}" == "true" ]]; then
  echo "KEPTN_URL  = $KEPTN_URL"
  echo "---"
  echo "$POST_DATA"
  echo "---"
  ARGS+=( --verbose )
fi

echo "Sending start Keptn Evaluation"
ctxid=$(curl -s -k -X POST --url "${KEPTN_URL}/v1/event" -H "Content-type: application/json" -H "x-token: ${KEPTN_TOKEN}" -d "$POST_DATA"|jq -r ".keptnContext")
debug "keptnContext ID = $ctxid"

loops=20
i=0
while [ $i -lt $loops ]
do
    i=`expr $i + 1`
    result=$(curl -s -k -X GET "${KEPTN_URL}/v1/event?keptnContext=${ctxid}&type=sh.keptn.events.evaluation-done" -H "accept: application/json" -H "x-token: ${KEPTN_TOKEN}")
    status=$(echo $result|jq -r ".data.evaluationdetails.result")
    if [ "$status" = "null" ]; then
      echo "Waiting for results (attempt $i of 20)..."
      sleep 5
    else
      break
    fi
done

echo "================================================================="
echo "eval status = ${status}"
echo "eval result = $(echo $result|jq)"
echo "================================================================="
if [ "$status" = "pass" ]; then
        echo "Keptn Quality Gate - Evaluation Succeeded"
else
        echo "Keptn Quality Gate - Evaluation failed!"
        echo "For details visit the Keptn Bridge!"
        exit 1
fi
