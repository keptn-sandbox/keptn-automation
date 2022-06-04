# Overview

The keptn automation Docker image contains the [Keptn CLI](https://keptn.sh/docs/0.13.x/reference/cli/). The Keptn CLI requires that the Keptn URL and API token are provided so there are two approaches.

# Option 1 - Use CLI directly

Most commands require the cli to be authenticated, so the commands must be strung together as shown below.

```
docker run -it --rm dtdemos/keptn-automation:0.5.0 "keptn auth -e $KEPTN_BASE_URL/api -a $KEPTN_API_TOKEN && keptn status && keptn get projects"
```

Depending on the pipeline tool, the image can be opened and multiple command passed seperately.  See the `example/gitlab` folder for an example of this.

# Option 2 - Use the keptn.sh script 

A convenience script called `keptn.sh` will perform both the auth and the passed in keptn CLI command.

## script logic

1. call `keptn auth`
1. call `keptn set config kubeContextCheck false`
1. run the keptn command provided such as `keptn get project`

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

