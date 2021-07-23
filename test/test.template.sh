#!/bin/bash

# read in the test library
source test-library.sh

# adjust values for your testing needs
export KEPTN_BASE_URL=https://XXXXX.cloudautomation.live.dynatrace.com
export KEPTN_BRIDGE_URL=https://XXXXX.cloudautomation.live.dynatrace.com
export KEPTN_API_TOKEN=
export DT_BASE_URL=https://XXXXX.live.dynatrace.com
export DT_API_TOKEN=
export IMAGE=dtdemos/keptn-automation:0.1.0

# uncomment test as required

# optionally build as part of testing
#cd .. && ./buildpush.sh && cd test/

#createdynatracesecret

export MOUNT=/keptn-mount
export KEPTN_SHIPYARD_FILE=$MOUNT/shipyard.yaml
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
export DEBUG=true
#createservice

export MOUNT=/keptn-mount
export KEPTN_SHIPYARD_FILE=$MOUNT/shipyard.yaml
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
export DEBUG=true
export CONFIGURE_DT_PROVIDER=true
export DT_CONF_FILE=$MOUNT/dynatrace.conf.yaml
#createservice-with-configure-dt-provider

#createservice-with-upstream

export EVALUATION_RULE=pass_on_warning     # e.g. ignore, pass_on_warning, fail_on_warning
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
#export LABELS=buildId=1,executedBy=manual​
export LABELS=runId=939511494,executedBy=GitHub,Job=https://github.com/dt-demos/github-actions/actions/runs/939511494
#export START=2021-06-09T21:00:00
#export END=2021-06-09T22:00:00
export TIMEFRAME=5m
export DEBUG=true
#sloevaluation

export KEPTN_COMMAND="get project"
#keptn