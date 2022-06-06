# Overview

Use this to [send a Cloud event](https://keptn.sh/docs/0.13.x/reference/cli/commands/keptn_send_event/) to start a sequence or a task.

## Use Cases

* Start a sequence
* Indicate a sequence task state such as `started` or `finished`

## Script logic

1. For the provided Keptn project, service, stage, and event type and other parameters, generate JSON cloud event
1. Call `keptn auth`
1. Call `keptn trigger event` event with the generated JSON cloud event as the payload
1. If the DEBUG is set to `true` then the standard output returns detailed debug messages such as the generated JSON object.

## environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn base URL - used in `keptn auth` | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token - used in `keptn auth`  | **Yes** | |
| KEPTN_PROJECT | Keptn Project Name | **Yes** | |
| KEPTN_SERVICE | Keptn Service Name | **Yes** | |
| KEPTN_STAGE | Keptn Stage Name | **Yes** | |
| KEPTN_EVENT_TYPE | Keptn Event Type for example run sequence `sh.keptn.event.production.evaluation.triggered` or finish a task event `sh.keptn.event.setfeature.finished` | **Yes** | |
| KEPTN_EVENT_SOURCE | Any descriptive value | | keptn-automation-container |
| KEPTN_EVENT_LABELS | Optional data in format of JSON object with quotes escaped - `"\"labels\": { \"GitLabURL\": \"http://mylink\" }"` | | |
| KEPTN_EVENT_DATA | Optional data in format of JSON object with quotes escaped - `\"evaluation\": { \"timeframe\": \"5m\" }` | | |
| KEPTN_EVENT_RESULT | Used when sending in task events.  values values are pass, warning, fail | | pass |
| KEPTN_EVENT_STATUS | Used when sending in task events.  values values are succeeded, errored, unknown | | succeeded |
| KEPTN_EVENT_SHKEPTNCONTEXT | Used when sending in task events. Its the cloud keptn context ID of the calling task. | | |
| KEPTN_EVENT_TRIGGERID | Used when sending in task events. Its the cloud event ID of the calling task. | | |
| DEBUG | Set to `true` or `false` | | false |

## Usage Examples

Below is the basic usage where parameters are specified as environment variables. 

## #1 - Send the Event to trigger a sequence

```
export KEPTN_BASE_URL=<YOUR BASE URL>
export KEPTN_API_TOKEN=<YOUR TOKEN>
export KEPTN_PROJECT=slo-demo
export KEPTN_SERVICE=casdemoapp
export KEPTN_STAGE=production
export KEPTN_EVENT_TYPE=sh.keptn.event.production.evaluation.triggered
export KEPTN_EVENT_SOURCE=my-source
export KEPTN_EVENT_LABELS="\"labels\": { \"myURL\": \"http://myURL\",\"myLabel\": \"myValue\" }"
export KEPTN_EVENT_DATA="\"evaluation\": { \"timeframe\": \"5m\" }"

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    --env KEPTN_EVENT_TYPE=$KEPTN_EVENT_TYPE \
    --env KEPTN_EVENT_DATA="$KEPTN_EVENT_DATA" \
    --env KEPTN_EVENT_LABELS="$KEPTN_EVENT_LABELS" \
    --env DEBUG=true \
    dtdemos/keptn-automation:0.5.0 \
    send-event.sh
```

## #2 - Send the Event to set state of sequence task

```
export KEPTN_BASE_URL=<YOUR BASE URL>
export KEPTN_API_TOKEN=<YOUR TOKEN>
export KEPTN_PROJECT=slo-demo
export KEPTN_SERVICE=casdemoapp
export KEPTN_STAGE=production
export KEPTN_EVENT_TYPE=sh.keptn.event.deployment.started
export KEPTN_EVENT_SOURCE=my-source
export KEPTN_EVENT_LABELS="\"labels\": { \"deploymentURL\": \"http://myURL\",\"myLabel\": \"myValue\" }"
export KEPTN_EVENT_DATA="\"deployment\": { \"deploymentURL\": \"http://myURL\" }"
export KEPTN_EVENT_RESULT=pass
export KEPTN_EVENT_STATUS=succeeded
export KEPTN_EVENT_SHKEPTNCONTEXT=<YOUR CONTEXT ID>
export KEPTN_EVENT_TRIGGERID=<YOUR ID>

docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    --env KEPTN_EVENT_TYPE=$KEPTN_EVENT_TYPE \
    --env KEPTN_EVENT_DATA="$KEPTN_EVENT_DATA" \
    --env KEPTN_EVENT_LABELS="$KEPTN_EVENT_LABELS" \
    --env KEPTN_EVENT_RESULT="$KEPTN_EVENT_RESULT" \
    --env KEPTN_EVENT_STATUS="$KEPTN_EVENT_STATUS" \
    --env KEPTN_EVENT_SHKEPTNCONTEXT="$KEPTN_EVENT_SHKEPTNCONTEXT" \
    --env KEPTN_EVENT_TRIGGERID="$KEPTN_EVENT_TRIGGERID" \
    --env DEBUG=true \
    dtdemos/keptn-automation:0.5.0 \
    send-event.sh
```