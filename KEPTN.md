# Overview

Use this action type to call the [Keptn CLI](https://keptn.sh/docs/0.9.x/reference/cli/).  The action requires that the Keptn URL and API token are provided. The arguments to `keptn.sh` are are the arguments as specified in the keptn CLI.

## Script logic

1. call `keptn auth`
1. run the keptn command provided such as `get project`

## Environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn base URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| MOUNT | Used when `DEBUG=true`.  Provide the the path the file mount and a `ls -l` is run within the container to help in triage. | | |
| DEBUG | Set to `true` or `false` to enable CLI verbose logging| | false |

## Usage Examples

Below is the basic usage using a Docker example. Any inputs are specified as environment variables as shown below with the script to invoke. 

Calling `keptn get project`

```
export KEPTN_COMMAND="get project"
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    $IMAGE \
    "keptn.sh $KEPTN_COMMAND"
```

Calling `keptn create project` where the `shipyard.yaml` is referenced via a Docker file mount

```
export MOUNT=/keptn-mount
export KEPTN_COMMAND="create project $KEPTN_PROJECT --shipyard=$MOUNT/shipyard.yaml"
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    -v $(pwd):$MOUNT/ \
    $IMAGE \
    "keptn.sh $KEPTN_COMMAND"
```

Same example as above, but with `DEBUG`and `MOUNT` enabled

```
export MOUNT_PATH=/keptn-mount
export KEPTN_COMMAND="create project $KEPTN_PROJECT --shipyard=$MOUNT/shipyard.yaml"
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env DEBUG=true \
    --env MOUNT=$MOUNT_PATH \
    -v $(pwd):$MOUNT_PATH \
    $IMAGE \
    "keptn.sh $KEPTN_COMMAND"
```

## More Examples

See the [test/test-library.lib](test/test-library.lib) file more examples. 

