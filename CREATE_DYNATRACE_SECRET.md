# Overview

Use this action type to create Dynatrace secret with required credentials. [Keptn Docs](https://keptn.sh/docs/0.13.x/monitoring/dynatrace/install/#1-create-a-secret-with-required-credentials). 

## Script logic

1. call `keptn auth`
1. call `keptn delete secret dynatrace`
1. call `keptn create secret dynatrace`

## Environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn base URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| DT_BASE_URL | Dynatrace base URL such as http://abc.live.dynatrace.com | **Yes** | |
| DT_API_TOKEN | Dynatrace API Token  | **Yes** | |
| DEBUG | Set to `true` or `false` | | false |

## Usage Examples

Below is the basic usage using a Docker example. Any inputs are specified as environment variables as shown below with the script to invoke. 

```
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env DT_BASE_URL=$DT_BASE_URL \
    --env DT_API_TOKEN=$DT_API_TOKEN \
    $IMAGE \
    create-dynatrace-secret.sh
```

## More Examples

See the [test/test-library.lib](test/test-library.lib) file more examples. 
