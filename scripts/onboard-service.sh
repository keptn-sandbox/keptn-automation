#!/usr/bin/env bash

# default the variables if not set
DEBUG=${DEBUG:="false"}
CONFIGURE_DT_MONITORING=${CONFIGURE_DT_MONITORING:="false"}

# Required parameters for auth
KEPTN_BASE_URL=${KEPTN_BASE_URL:?'KEPTN_BASE_URL envionmment variable missing.'}
KEPTN_API_TOKEN=${KEPTN_API_TOKEN:?'KEPTN_API_TOKEN envionmment variable missing.'}

# Required parameters initializing project and service
KEPTN_PROJECT=${KEPTN_PROJECT:?'KEPTN_PROJECT envionmment variable missing.'}
KEPTN_SERVICE=${KEPTN_SERVICE:?'KEPTN_SERVICE envionmment variable missing.'}
KEPTN_STAGE=${KEPTN_STAGE:?'KEPTN_STAGE envionmment variable missing.'}
KEPTN_SHIPYARD_FILE=${KEPTN_SHIPYARD_FILE:?'KEPTN_SHIPYARD_FILE envionmment variable missing'}

# validate shipyard file exists 
if [ ! -f "$KEPTN_SHIPYARD_FILE" ]; then
    echo "Aborting: KEPTN_SHIPYARD_FILE $KEPTN_SHIPYARD_FILE does not exist."
    exit 1
fi

# if specified, validate dynatrace monitoring file exists 
if [ "CONFIGURE_DT_MONITORING" == "true" ]; then
  DT_CONF_FILE=${DT_CONF_FILE:?'DT_CONF_FILE envionmment variable missing'}
  if [ ! -f "$DT_CONF_FILE" ]; then
      echo "Aborting: DT_CONF_FILE $DT_CONF_FILE does not exist."
      exit 1
  fi
fi

# if specified, validate dynatrace sli file exists 
if [ ! -z "$DT_SLI_FILE" ]; then
  if [ ! -f "$DT_SLI_FILE" ]; then
      echo "Aborting: DT_SLI_FILE $DT_SLI_FILE does not exist."
      exit 1
  fi
fi 

echo "================================================================="
echo "Onboard Service"
echo ""
echo "KEPTN_BASE_URL          = $KEPTN_BASE_URL"
echo "KEPTN_PROJECT           = $KEPTN_PROJECT"
echo "KEPTN_SERVICE           = $KEPTN_SERVICE"
echo "KEPTN_STAGE             = $KEPTN_STAGE"
echo "KEPTN_SHIPYARD_FILE     = $KEPTN_SHIPYARD_FILE"
echo "KEPTN_SLO_FILE          = $KEPTN_SLO_FILE"
echo "-----------------------------------------------------------------"
echo "CONFIGURE_DT_MONITORING = $CONFIGURE_DT_MONITORING"
echo "DT_CONF_FILE            = $DT_CONF_FILE"
echo "DT_SLI_FILE             = $DT_SLI_FILE"
echo "DEBUG                   = $DEBUG"
echo "================================================================="

echo "Authorizing keptn cli"
keptn auth --api-token "$KEPTN_API_TOKEN" --endpoint "$KEPTN_BASE_URL"
if [ $? -ne 0 ]; then
    echo "Aborting: Failed to authenticate Keptn CLI"
    exit 1
fi

echo "-----------------------------------------------------------------"
echo "Checking if $KEPTN_PROJECT is already onboarded"
if [ $(keptn get project $KEPTN_PROJECT | grep $KEPTN_PROJECT | wc -l) -ne 1 ]; then
  echo "Creating project $KEPTN_PROJECT"
  keptn create project $KEPTN_PROJECT --shipyard=$KEPTN_SHIPYARD_FILE
else
  echo "Project $KEPTN_PROJECT already onboarded. Skipping create project"
fi

echo "-----------------------------------------------------------------"
echo "Checking if $KEPTN_SERVICE is already onboarded"
if [ $(keptn get service $KEPTN_SERVICE --project $KEPTN_PROJECT | grep $KEPTN_SERVICE | wc -l) -ne 1 ]; then
  echo "Creating service $KEPTN_SERVICE"
  keptn create service $KEPTN_SERVICE --project=$KEPTN_PROJECT
else
  echo "Service $KEPTN_SERVICE already onboarded. Skipping create service"
fi

echo "-----------------------------------------------------------------"
if [ -f "$KEPTN_SLO_FILE" ]; then
  echo "Adding $KEPTN_SLO_FILE file as a resource"
  keptn add-resource --project=$KEPTN_PROJECT --stage=$KEPTN_STAGE --service=$KEPTN_SERVICE --resource=$KEPTN_SLO_FILE --resourceUri=slo.yaml
else
  echo "Skipping adding SLO file"
fi

echo "-----------------------------------------------------------------"
if [ "$CONFIGURE_DT_MONITORING" == "true" ]; then
  echo "Configure Dynatrace monitoring is TRUE"
  echo "Adding $DT_CONF_FILE file as a resource"
  keptn add-resource --project=$KEPTN_PROJECT --stage=$KEPTN_STAGE --service=$KEPTN_SERVICE --resource=$DT_CONF_FILE --resourceUri=dynatrace.conf.yaml

  if [ ! -z "$DT_SLI_FILE" ]; then
    echo "Adding $DT_SLI_FILE file as a resource"
    keptn add-resource --project=$KEPTN_PROJECT --stage=$KEPTN_STAGE --service=$KEPTN_SERVICE --resource=$DT_SLI_FILE --resourceUri=dynatrace/sli.yaml
  else
    echo "Skipping adding Dynatrace SLI file"
  fi
else
  echo "Skipping Configure Dynatrace monitoring"
fi

echo "================================================================="
echo "Completed Onboard Service"
echo "================================================================="
