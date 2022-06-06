#!/bin/bash

EVENT_FILE="./event.json"

# Required parameters
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}
KEPTN_PROJECT=${KEPTN_PROJECT:?'KEPTN_PROJECT envionmment variable missing.'}
KEPTN_SERVICE=${KEPTN_SERVICE:?'KEPTN_SERVICE envionmment variable missing.'}
KEPTN_STAGE=${KEPTN_STAGE:?'KEPTN_STAGE envionmment variable missing.'}

# for example - sh.keptn.event.production.evaluation.triggered
DEBUG=${DEBUG:="false"}
KEPTN_EVENT_TYPE=${KEPTN_EVENT_TYPE:?'KEPTN_EVENT_TYPE envionmment variable missing.'}

# defaulted parameters
KEPTN_EVENT_SOURCE=${KEPTN_EVENT_SOURCE:='keptn-automation-container'}
KEPTN_EVENT_RESULT=${KEPTN_EVENT_RESULT:='pass'}
KEPTN_EVENT_STATUS=${KEPTN_EVENT_STATUS:='succeeded'}

# optional parameters
# KEPTN_EVENT_LABELS
# KEPTN_EVENT_DATA
# KEPTN_EVENT_SHKEPTNCONTEXT
# KEPTN_EVENT_TRIGGERID

if [[ "${DEBUG}" == "true" ]]; then
  echo "================================================================="
  echo "Keptn Event Values:"
  echo ""
  echo "KEPTN_BASE_URL             = $KEPTN_BASE_URL"
  echo "KEPTN_PROJECT              = $$"
  echo "KEPTN_SERVICE              = $KEPTN_SERVICE"
  echo "KEPTN_STAGE                = $KEPTN_STAGE"
  echo "KEPTN_EVENT_TYPE           = $KEPTN_EVENT_TYPE"
  echo "-------------------"
  echo "KEPTN_EVENT_SOURCE         = $KEPTN_EVENT_SOURCE"
  echo "DEBUG                      = $DEBUG"
  echo "-------------------"
  echo "KEPTN_EVENT_LABELS         = $KEPTN_EVENT_LABELS"
  echo "KEPTN_EVENT_DATA           = $KEPTN_EVENT_DATA"
  echo "-------------------"
  echo "KEPTN_EVENT_RESULT         = $KEPTN_EVENT_RESULT"
  echo "KEPTN_EVENT_STATUS         = $KEPTN_EVENT_STATUS"
  echo "KEPTN_EVENT_SHKEPTNCONTEXT = $KEPTN_EVENT_SHKEPTNCONTEXT"
  echo "KEPTN_EVENT_TRIGGERID      = $KEPTN_EVENT_TRIGGERID"
  echo "================================================================="
fi

auth_cli() {
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
}

build_event_file() {

    echo "{" > $EVENT_FILE
    echo "   \"type\": \"$KEPTN_EVENT_TYPE\"," >> $EVENT_FILE
    echo "   \"specversion\":\"1.0\"," >> $EVENT_FILE
    echo "   \"source\":\"$KEPTN_EVENT_SOURCE\"," >> $EVENT_FILE
    echo "   \"data\":{" >> $EVENT_FILE
    echo "     \"project\":\"$KEPTN_PROJECT\"," >> $EVENT_FILE
    echo "     \"stage\":\"$KEPTN_STAGE\"," >> $EVENT_FILE
    echo "     \"service\":\"$KEPTN_SERVICE\"" >> $EVENT_FILE

    # optional values related to the data object for a sequence event

    if [ -n "$KEPTN_EVENT_LABELS" ]; then
        echo "    ,$KEPTN_EVENT_LABELS" >> $EVENT_FILE
    fi

    if [ -n "$KEPTN_EVENT_DATA" ]; then
        echo "    ,$KEPTN_EVENT_DATA" >> $EVENT_FILE
    fi

    # optional values when sending a task event

    if [ -n "$KEPTN_EVENT_RESULT" ]; then
        echo "    ,\"result\": \"$KEPTN_EVENT_RESULT\"" >> $EVENT_FILE
    fi

    if [ -n "$KEPTN_EVENT_STATUS" ]; then
        echo "    ,\"status\": \"$KEPTN_EVENT_STATUS\"" >> $EVENT_FILE
    fi

    echo "   }" >> $EVENT_FILE

    # optional values when sending a task event
    if [ -n "$KEPTN_EVENT_SHKEPTNCONTEXT" ]; then
        echo "    ,\"shkeptncontext\": \"$KEPTN_EVENT_SHKEPTNCONTEXT\"" >> $EVENT_FILE
    fi

    if [ -n "$KEPTN_EVENT_TRIGGERID" ]; then
        echo "    ,\"triggeredid\": \"$KEPTN_EVENT_TRIGGERID\"" >> $EVENT_FILE
    fi

    echo "}" >> $EVENT_FILE

    if [[ "${DEBUG}" == "true" ]]; then
      echo "================================================================="
      echo "$EVENT_FILE = "
      cat $EVENT_FILE
      echo "================================================================="
    fi
}

send_event() {
    KEPTN_CMD="keptn send event --file $EVENT_FILE"
    echo "Running '$KEPTN_CMD'"

    OUTPUT=$($KEPTN_CMD)
    echo "================================================================="
    echo "keptn send event output"
    echo "================================================================="
    echo "ID = $OUTPUT"
    echo ""
}

auth_cli
build_event_file
send_event