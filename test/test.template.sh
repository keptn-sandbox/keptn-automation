export KEPTN_BASE_URL=https://XXXXX.cloudautomation.live.dynatrace.com
export KEPTN_BRIDGE_URL=https://XXXXX.cloudautomation.live.dynatrace.com
export KEPTN_API_TOKEN=

export DT_BASE_URL=https://XXXXX.live.dynatrace.com
export DT_API_TOKEN=

export IMAGE=dtdemos/keptn-automation:1

cd .. && ./buildpush.sh && cd test/

# uncomment test as required

#./test-createdynatracesecret.sh

export MOUNT=/keptn-mount
export KEPTN_SHIPYARD_FILE=$MOUNT/shipyard.yaml
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
export DEBUG=true
#./test-onboardservice.sh

export MOUNT=/keptn-mount
export KEPTN_SHIPYARD_FILE=$MOUNT/shipyard.yaml
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
export DEBUG=true
export CONFIGURE_DT_MONITORING=true
export DT_CONF_FILE=$MOUNT/dynatrace.conf.yaml
./test-onboardservice-with-monitoring.sh

export EVALUATION_RULE=pass_on_warning     # e.g. ignore, pass_on_warning, fail_on_warning
export KEPTN_PROJECT=dt-orders
export KEPTN_SERVICE=catalog
export KEPTN_STAGE=dev
#export KEPTN_PROJECT=dynatrace
#export KEPTN_SERVICE==frontend
#export KEPTN_STAGE=quality-gate
#export LABELS=buildId=1,executedBy=manual​
export LABELS=runId=939511494,executedBy=GitHub,Job=https://github.com/dt-demos/github-actions/actions/runs/939511494
#export START=2021-06-09T21:00:00
#export END=2021-06-09T22:00:00
export TIMEFRAME=5m
export DEBUG=true
#./test-sloevaluation.sh

export KEPTN_COMMAND="get project"
#./test-keptn.sh