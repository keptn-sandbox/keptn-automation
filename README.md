# Overview

Container image containing logic to integrate Keptn into your DevOps scripts and software delivery pipelines.  

# Container Images

| Container Image Tag | Keptn Supported Version | Comment |
| ------------------- | ----------------------- | --------|
| dtdemos/keptn-automation:1 | 0.8.3 | Initial version |

# Usage - using Docker

Any inputs are specified as environment variables as shown below with the script to invoke. For example calling a script such as `onboard-service.sh`:

```
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env ...
    --env ...
    $IMAGE \
    onboard-service.sh
```

# Script Details

Supported Scripts are described in detail in this section:
* `onboard-service.sh`
* `create-dynatrace-secret.sh`
* `slo-evaluation.sh`
* `keptn.sh`

See the `test/` folder for examples of each script.

## `onboard-service.sh`

Use this action type to [onboard a service](https://keptn.sh/docs/0.8.x/manage/). **Requires that a Docker volume is specified to the files that will be processed.**

**Script logic**

1. call `keptn auth`
1. if project does not exist, call `keptn create project` 
1. if service does not exist, call `keptn create service` 
1. if KEPTN_SLO_FILE provided, call `keptn add-resource` to add SLO file as a keptn resource
1. if `CONFIGURE_DT_MONITORING = true`
    * call `keptn add-resource` to add `dynatrace.conf.yaml` as a keptn resource
    * if `DT_SLI_FILE` provided, call `keptn add-resource` to add `dynatrace/sli.yaml` as a keptn resource

**Docker environment variables**
| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| KEPTN_PROJECT | Keptn Project Name | **Yes** | |
| KEPTN_SERVICE | Keptn Service Name | **Yes** | |
| KEPTN_STAGE | Keptn Stage Name | **Yes** | |
| KEPTN_SHIPYARD_FILE | Keptn Shipyard filename | **Yes** | |
| KEPTN_SLO_FILE | Keptn SLO filename | **Yes** | |
| CONFIGURE_DT_MONITORING | Set to `true` or `false` |  | false |
| DT_SLI_FILE | Dynatrace SLI filename |  |  |
| DT_CONF_FILE | Dynatrace Configuration filename. Required if `CONFIGURE_DT_MONITORING=true` | **Depends** |  |
| DEBUG | Set to `true` or `false` | | false |

## `create-dynatrace-secret.sh`

Use this action type to [create Dynatrace secret with required credentials](https://keptn.sh/docs/0.8.x/monitoring/dynatrace/install/#1-create-a-secret-with-required-credentials). 

**Script logic**

1. call `keptn auth`
1. call `keptn delete secret dynatrace`
1. call `keptn create secret dynatrace`

**Docker environment variables**
| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| DT_BASE_URL | Dynatrace Tenant URL such as http://abc.live.dynatrace.com | **Yes** | |
| DT_API_TOKEN | Dynatrace API Token  | **Yes** | |
| DEBUG | Set to `true` or `false` | | false |

## `slo-evaluation.sh`

Use this action type to perform a [SLO evaluation](https://keptn.sh/docs/0.8.x/quality_gates/get_started/)

**Use Cases:**
* Add this following a performance test to automate results analysis
* Add this to code pipeline as a `quality gate` prior to deploying to another environment
* Add this to following the performance test of individual services as a prerequisite quality gate to integrated tests
* Add this following a deployment based on real-user traffic to ensure it was successful

**Script logic**

1. call `keptn auth`
1. For the provided Keptn project, service, and stage, call `keptn trigger evaluation` event and save the `Keptn Context ID` returned from the response
1. Loop and call the Keptn API every 10 seconds using the `Keptn Context ID` to retrieve results
    * If there is no response with the number loops set by the `WAIT_LOOPS`, then exit with status 1
1. If there is a response from Keptn, then Docker will exit with status of 1 or 0 based on the logic behind the passed in `process_type` argument:
    * If the Keptn status = `ignore`, then always return zero
    * If the Keptn status = `pass_on_warning`, then - return zero unless keptn status equals fail
    * If the Keptn status = `fail_on_warning`, then - return zero unless keptn status equals fail or warn

**Docker environment variables**
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

## `keptn.sh`

Use this action type to call the [Keptn CLI](https://keptn.sh/docs/0.8.x/reference/cli/).  The action requires that the Kpetn URL and API token are provided. The arguments to `keptn.sh` are are the arguments as specfied in the keptn CLI.

For example:

```
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    $IMAGE \
    keptn.sh get project
```

**Script logic**

1. call `keptn auth`
1. run the keptn command provided such as `keptn get projects`

**Docker environment variables**
| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |

# Development

Use `buildpush.sh` script builds a the container image and asks to push it to specified container registry.

# Development Testing using Docker

1. Copy the `test.template.sh` file one called `test.sh`. Note that `test.sh` is part of `.gitignore` so fill in your unique arguments and they won't be saved to the repo.

1. Adjust the variables with required secrets values as well as what tests to run

1. Run `chmod +x test.sh`

1. Run `./test.sh` to execute test