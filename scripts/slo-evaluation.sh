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

if [[ "${DEBUG}" == "true" ]]; then
  echo "================================================================="
  echo "Keptn SLO Evaluation:"
  echo ""
  echo "EVALUATION_RULE   = $EVALUATION_RULE"
  echo "KEPTN_BASE_URL    = $KEPTN_BASE_URL"
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
fi

if [[ "${DEBUG}" == "true" ]]; then
  echo "Calling keptn set config kubeContextCheck false"
  keptn set config kubeContextCheck false
else
  keptn set config kubeContextCheck false > /dev/null 2>&1 
fi

if [[ "${DEBUG}" == "true" ]]; then
  echo "-----------------------------------------------------------------"
  echo "Authorizing keptn cli with 'keptn auth'"
  echo "-----------------------------------------------------------------"
  keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL"
else
  keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL" > /dev/null 2>&1 
fi
if [ $? -ne 0 ]; then
    echo "Aborting: Failed to authenticate Keptn CLI"
    exit 1
fi

if [[ "${DEBUG}" == "true" ]]; then
  echo "-----------------------------------------------------------------"
  echo "Running 'keptn set config AutomaticVersionCheck false'"
  echo "-----------------------------------------------------------------"
  keptn set config AutomaticVersionCheck false
else
  keptn set config AutomaticVersionCheck false > /dev/null 2>&1 
fi

KEPTN_CMD="keptn trigger evaluation --project=$KEPTN_PROJECT --stage=$KEPTN_STAGE --service=$KEPTN_SERVICE"
if [[ "${DEBUG}" == "true" ]]; then
  echo "-----------------------------------------------------------------"
  echo "Sending start Keptn Evaluation"
  echo "$KEPTN_CMD"
  echo "-----------------------------------------------------------------"
fi


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
fi
if [[ "${DEBUG}" == "true" ]]; then
  echo ""
  echo "Keptn Context ID:"
  echo "$KEPTN_CONTEXT_ID"
  echo ""
  echo "-----------------------------------------------------------------"
fi

i=1
while [ $i -lt $WAIT_LOOPS ]
do
    if [[ "${DEBUG}" == "true" ]]; then
      echo "Waiting for evaluation results (attempt $i of $WAIT_LOOPS)..."
    fi
    result=$(curl -s -k -X GET "${KEPTN_BASE_URL}/api/mongodb-datastore/event?keptnContext=${KEPTN_CONTEXT_ID}&type=sh.keptn.event.evaluation.finished" -H "accept: application/json" -H "x-token: ${KEPTN_API_TOKEN}")
    if [[ "${DEBUG}" == "true" ]]; then
      echo "Response from API: "
      echo $result | jq .
    fi
    STATUS=$(echo $result|jq -r ".events[0].data.evaluation.result")
    SCORE=$(echo $result|jq -r ".events[0].data.evaluation.score")

    if [ "$STATUS" = "null" ]; then
      i=`expr $i + 1`
      sleep 10
    else
      break
    fi
done

filename=/slo_result/slo-evaluation-result.json
if [[ "${DEBUG}" == "true" ]]; then
  echo "Writing results to file $filename."
fi
echo $result|jq > $filename

echo "{"
echo '"evaluationRule":"'$EVALUATION_RULE'",'
echo '"evaluationResult":"'$STATUS'",'
echo '"evaluationScore":"'$SCORE'",'
echo '"bridge":"'$KEPTN_BASE_URL'/bridge/trace/'$KEPTN_CONTEXT_ID'",'

# determine if process the result
if [ "${EVALUATION_RULE}" != "pass_on_warning" ] && [ "${EVALUATION_RULE}" != "fail_on_warning" ]; then
  echo '"exitStatus":"Ignoring Evaluation Logic",'
  exitStatus=0
else
  if [ "$status" = "pass" ]; then
    echo "Evaluation PASSED"
  elif [ "$status" = "warning" ]; then
    if [ "${EVALUATION_RULE}" == "fail_on_warning" ]; then
      echo '"exitStatus":"Evaluation FAILED on warning",'
      exitStatus=1
    else
      echo '"exitStatus":"Evaluation PASSED with warning",'
      exitStatus=0
    fi
  else
    echo '"exitStatus":"Evaluation FAILED",'
    exitStatus=1
  fi
fi

echo '"evaluationResults":'
echo $result|jq
echo "}"

exit $exitStatus
