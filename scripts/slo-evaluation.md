# Overview

Use this action type to perform a [SLO evaluation](https://keptn.sh/docs/0.8.x/quality_gates/get_started/)

##Use Cases:**
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

## environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| KEPTN_BRIDGE_URL | Keptn Bridge URL  | | value of `KEPTN_BASE_URL` variable |
| KEPTN_PROJECT | Keptn Project Name | **Yes** | |
| KEPTN_SERVICE | Keptn Service Name | **Yes** | |
| KEPTN_STAGE | Keptn Stage Name | **Yes** | |
| EVALUATION_RULE | Must be value of `ignore`, `pass_on_warning`, or `fail_on_warning` | **Yes** | ignore |
| TEST_STRATEGY | Custom metadata field | **Yes** | detached |
| WAIT_LOOPS | Number of waiting loops for the evaluation to complete| **Yes** | 20 |
| SOURCE | Custom metadata field | **Yes** | unknown |
| START | Evaluation Start Time in format of 2021-06-09T21:00:00 | |
| LABELS | Custom metadata data in format of a comma separated list - example `buildId=1,executedBy=manual​` | |
| END | Evaluation End Time in format of 2021-06-09T21:00:00. Required if specify `START` variable. | Depends | |
| TIMEFRAME | Evaluation time frame. Start time is now unless `START` variable. | | 5m |
| DEBUG | Set to `true` or `false` | | false |
