#!/bin/bash

# read in the test library
source test-library.lib

#########################################################################
# Adjust theses values for your testing needs
#########################################################################
export KEPTN_BASE_URL=      # for example https://XXXXX.cloudautomation.live.dynatrace.com
export KEPTN_API_TOKEN=     # <ADD YOUR TOKEN>

export IMAGE=dtdemos/keptn-automation:0.4.0

# these variables only needed for 'create-dynatrace-secret' use case
export DT_BASE_URL=         # for example https://XXXXX.live.dynatrace.com
export DT_API_TOKEN=        # <ADD YOUR TOKEN>

export GIT_USER=            # <ADD YOUR USER NAME>
export GIT_TOKEN=           # <ADD YOUR TOKEN>
export GIT_REMOTE_URL=      # for example https://github.com/username/reponame.git

#########################################################################
# Only need to adjust these if change the project/service/stage or test files
#########################################################################
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=frontend
export KEPTN_STAGE=staging
export MOUNT_PATH=/keptn-mount   # this is the subfolder within the Docker image
export LOCAL_TEST_FILES_PATH=$(pwd)/keptn-test-files
export KEPTN_SHIPYARD_FILE=$MOUNT_PATH/shipyard.yaml
export DT_CONF_QUERY_FILE=$MOUNT_PATH/dynatrace.conf.query.yaml
export DT_CONF_SLO_FILE=$MOUNT_PATH/dynatrace.conf.slo.yaml
export KEPTN_SLO_FILE=$MOUNT_PATH/slo.yaml
export DT_SLI_FILE=$MOUN_PATHT/dynatrace.sli.yaml

#########################################################################
# Optionally, uncomment this next line to build a new image
#########################################################################
#cd .. && ./buildpush.sh && cd test/

#########################################################################
# uncomment the tests to run
#########################################################################
export DEBUG=true

#test_create_dynatrace_secret
#test_delete_project
#test_create_project
#test_update_project_with_upstream
#test_get_project
#test_configure_dynatrace_monitoring_for_project
#test_create_service
#test_configure_service_with_dynatrace_query
#test_configure_service_with_dynatrace_slo_file

#########################################################################
# update these variables to test different SLO evaluation scenarios
#########################################################################
#export EVALUATION_RULE=pass_on_warning     # e.g. ignore, pass_on_warning, fail_on_warning
#export LABELS=buildId=1,executedBy=manual​
#export LABELS=runId=939511494,executedBy=GitHub,Job=https://github.com/dt-demos/github-actions/actions/runs/939511494
#export START=2021-06-09T21:00:00
#export END=2021-06-09T22:00:00
#export TIMEFRAME=5m

#test_slo_evaluation
