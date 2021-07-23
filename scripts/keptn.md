# Overview

Use this action type to call the [Keptn CLI](https://keptn.sh/docs/0.8.x/reference/cli/).  The action requires that the Keptn URL and API token are provided. The arguments to `keptn.sh` are are the arguments as specified in the keptn CLI.

For example:

```
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    $IMAGE \
    keptn.sh get project
```

## Script logic

1. call `keptn auth`
1. run the keptn command provided such as `keptn get projects`

## Environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
