# Overview

Use this action type to perform a [SLO evaluation](https://keptn.sh/docs/0.13.x/quality_gates/get_started/)

## Use Cases

* Add this following a performance test to automate results analysis
* Add this to code pipeline as a `quality gate` prior to deploying to another environment
* Add this to following the performance test of individual services as a prerequisite quality gate to integrated tests
* Add this following a deployment based on real-user traffic to ensure it was successful

## Script logic

1. call `keptn auth`
1. For the provided Keptn project, service, and stage, call `keptn trigger evaluation` event and save the `Keptn Context ID` returned from the response
1. Loop and call the Keptn API every 10 seconds using the `Keptn Context ID` to retrieve results
    * If there is no response with the number loops set by the `WAIT_LOOPS`, then exit with status 1
1. If there is a response from Keptn, then Docker will exit with status of 1 or 0 based on the logic behind the passed in `process_type` argument:
    * If the Keptn status = `ignore`, then always return zero
    * If the Keptn status = `pass_on_warning`, then - return zero unless keptn status equals fail
    * If the Keptn status = `fail_on_warning`, then - return zero unless keptn status equals fail or warn
1. Standard output returned is JSON in this format:

    ```
    {
        "evaluationRule":"ignore",
        "evaluationResult":"warning",
        "evaluationScore":"85.71428571428571",
        "bridge":"https://rob00334.cloudautomation.live.dynatrace.com/bridge/trace/8a9fa6c2-ae1d-4002-acf5-14f0680c4852",
        "exitStatus":"Ignoring Evaluation Logic",
        "evaluationResults": { ... full output from SLO evaluation }
    }
    ```

1. If the DEBUG is set to `true` then the standard output first returns debug messages followed by the JSON results.

## environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn base URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| KEPTN_PROJECT | Keptn Project Name | **Yes** | |
| KEPTN_SERVICE | Keptn Service Name | **Yes** | |
| KEPTN_STAGE | Keptn Stage Name | **Yes** | |
| EVALUATION_RULE | Must be value of `ignore`, `pass_on_warning`, or `fail_on_warning` | | ignore |
| TEST_STRATEGY | Custom metadata field | | detached |
| WAIT_LOOPS | Number of waiting loops for the evaluation to complete| | 20 |
| SOURCE | Custom metadata field to describe to source of the request | | unknown |
| TIMEFRAME | Evaluation time frame. Start time is now unless `START` variable. | | 5m |
| LABELS | Custom metadata data in format of a comma separated list - example `buildId=1,executedBy=manual​` | |
| START | Evaluation Start Time in format of 2021-06-09T21:00:00 | |
| END | Evaluation End Time in format of 2021-06-09T21:00:00. Required if specify `START` variable. | Depends | |
| DEBUG | Set to `true` or `false` | | false |

## Usage Examples

Below is the basic usage using a Docker example. Any inputs are specified as environment variables as shown below with the script to invoke. 

```
docker run -it --rm \
    --env EVALUATION_RULE="pass_on_warning" \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env KEPTN_PROJECT=$KEPTN_PROJECT \
    --env KEPTN_SERVICE=$KEPTN_SERVICE \
    --env KEPTN_STAGE=$KEPTN_STAGE \
    $IMAGE \
    slo-evaluation.sh
```

## More Examples

See the [test/test-library.lib](test/test-library.lib) file more examples. 
