#!/usr/bin/env bash

# ONCE THE CLI has better output, will remove the API calls

# default the variables if not set
DEBUG=${DEBUG:="false"}
EVALUATION_RULE=${EVALUATION_RULE:="ignore"}
TEST_STRATEGY=${TEST_STRATEGY:="detached"}
WAIT_LOOPS=${WAIT_LOOPS:="20"}
SOURCE=${SOURCE:="unknown"}
TIMEFRAME=${TIMEFRAME:="5m"}

# optional parameters with no defaults 
# START
# END

# Required parameters
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}
KEPTN_PROJECT=${KEPTN_PROJECT:?'KEPTN_PROJECT envionmment variable missing.'}
KEPTN_SERVICE=${KEPTN_SERVICE:?'KEPTN_SERVICE envionmment variable missing.'}
KEPTN_STAGE=${KEPTN_STAGE:?'KEPTN_STAGE envionmment variable missing.'}

# default the bridge URL if not provided
if [ ! -z "$KEPTN_BRIDGE_URL" ]; then
  KEPTN_BRIDGE_URL=$KEPTN_BASE_URL
fi

echo "================================================================="
echo "Keptn SLO Evaluation:"
echo ""
echo "EVALUATION_RULE   = $EVALUATION_RULE"
echo "KEPTN_BASE_URL    = $KEPTN_BASE_URL"
echo "KEPTN_BRIDGE_URL  = $KEPTN_BRIDGE_URL"
echo "KEPTN_PROJECT     = $KEPTN_PROJECT"
echo "KEPTN_SERVICE     = $KEPTN_SERVICE"
echo "KEPTN_STAGE       = $KEPTN_STAGE"
echo "START             = $START"
echo "END               = $END"
echo "TIMEFRAME         = $TIMEFRAME"
echo "LABELS            = $LABELS"
echo "SOURCE            = $SOURCE"
echo "TEST_STRATEGY     = $TEST_STRATEGY"
echo "WAIT_LOOPS        = $WAIT_LOOPS"
echo "DEBUG             = $DEBUG"
echo "================================================================="

echo "Authorizing keptn cli"
keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL"
if [ $? -ne 0 ]; then
    echo "Aborting: Failed to authenticate Keptn CLI"
    exit 1
fi

echo "-----------------------------------------------------------------"
echo "Sending start Keptn Evaluation"
KEPTN_CMD="keptn trigger evaluation --project=$KEPTN_PROJECT --stage=$KEPTN_STAGE --service=$KEPTN_SERVICE"
# if passed in start then add that, else just use timeframe
if [ -n "$TIMEFRAME" ]; then
  if [ -n "$START" ]; then
    KEPTN_CMD="$KEPTN_CMD --timeframe=$TIMEFRAME --start=$START"
  else
    KEPTN_CMD="$KEPTN_CMD --timeframe=$TIMEFRAME"
  fi
else
  # if did not pass in timeframe, then start and end are both required
  START=${START:?'START envionmment variable missing.'}
  END=${END:?'END envionmment variable missing.'}
  KEPTN_CMD="$KEPTN_CMD --start=$START --end=$END"
fi

if [ -n "$LABELS" ]; then
  KEPTN_CMD="$KEPTN_CMD --labels=$LABELS"
fi

POST_RESPONSE=$($KEPTN_CMD)
if [[ "${DEBUG}" == "true" ]]; then
  echo ""
  echo "Keptn Command:"
  echo "$KEPTN_CMD"
  echo "Keptn Command Response:"
  echo $POST_RESPONSE
  echo ""
fi

# ONCE THE CLI has better output, will adjust this logic
KEPTN_CONTEXT_ID=$(echo $POST_RESPONSE| grep "ID of Keptn context" | cut -d ":" -f2 | tr -d '[:space:]') 
if [ -z "${KEPTN_CONTEXT_ID}" ]; then
  echo "Aborting: Keptn Context ID not returned with the keptn response of:"
  echo $POST_RESPONSE
  exit 1
else
  echo ""
  echo "Keptn Context ID:"
  echo "$KEPTN_CONTEXT_ID"
  echo ""
fi

echo "-----------------------------------------------------------------"
i=1
while [ $i -lt $WAIT_LOOPS ]
do
    echo "Waiting for evaluation results (attempt $i of $WAIT_LOOPS)..."
    result=$(curl -s -k -X GET "${KEPTN_BASE_URL}/api/mongodb-datastore/event?keptnContext=${KEPTN_CONTEXT_ID}&type=sh.keptn.event.evaluation.finished" -H "accept: application/json" -H "x-token: ${KEPTN_API_TOKEN}")
    if [[ "${DEBUG}" == "true" ]]; then
      echo "Response from API: "
      echo $result | jq .
    fi
    status=$(echo $result|jq -r ".events[0].data.evaluation.result")
    score=$(echo $result|jq -r ".events[0].data.evaluation.score")

    if [ "$status" = "null" ]; then
      i=`expr $i + 1`
      sleep 10
    else
      break
    fi
done

filename=evaluation-result.json
echo "Writing results to file $filename."
echo $result|jq > $filename

echo "================================================================="
echo "Evaluation Rule   = $EVALUATION_RULE"
echo "Evaluation Result = ${status}"
echo "Evaluation Score  = ${score}"
echo "================================================================="
echo "For details visit the Keptn Bridge:"
echo "$KEPTN_BRIDGE_URL/bridge/trace/$KEPTN_CONTEXT_ID"
echo "================================================================="

# determine if process the result
if [ "${EVALUATION_RULE}" != "pass_on_warning" ] && [ "${EVALUATION_RULE}" != "fail_on_warning" ]; then
  echo "Ignoring Evaluation Logic"
  exit
fi

if [ "$status" = "pass" ]; then
  echo "Evaluation PASSED"
elif [ "$status" = "warning" ]; then
  if [ "${EVALUATION_RULE}" == "fail_on_warning" ]; then
    echo "Evaluation FAILED on warning"
    exit 1
  else
    echo "Evaluation PASSED with warning"
  fi
else
  echo "Evaluation FAILED"
  exit 1
fi
