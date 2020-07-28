# Overview

Dockerized script that will perform the logic to perform a Keptn SLO evaluation.  

Script logic:
1. For the provided Keptn project, service, and stage, send a `sh.keptn.event.start-evaluation` event to the Keptn Event API and saves the `keptncontext ID` returned from the response
1. Loop and call the Keptn API every 10 seconds using the `keptncontext ID` to retrieve results
1. If there is no response with the number loops set by the `WAIT_LOOPS`, then exit with status 1
1. If there is a response from Keptn, then Docker will exit with status of 1 or 0 based on the logic behind the passed in `process_type` argument:
    * If the Keptn status = `ignore`, then always return zero
    * If the Keptn status = `pass_on_warning`, then - return zero unless keptn status equals fail
    * If the Keptn status = `fail_on_warning`, then - return zero unless keptn status equals fail or warn

# Usage

Assumption for setup:
* Using `Keptn 0.7.x` and have a service onboarded.  See example this repo for example for how to setup keptn on k3s with a sample application - https://github.com/dt-demos/keptn-k3s-demo
* Have docker to run the `docker run` command
* Use the pre-built `robjahn/keptn-quality-gate-bash` image or build your own image.

Call the `docker run` command as shown in this example. 

```
#!/bin/bash

image=robjahn/keptn-quality-gate-bash
keptnApiUrl=https://api.keptn.<YOUR KEPTN DOMAIN>
keptnApiToken=<YOUR KEPTN TOKEN>
start=2020-07-23T21:22:20Z
end=2020-07-23T21:22:37Z
project=demo
service=simplenodeservice
stage=dev
source=detached
processType=pass_on_warning     # e.g. ignore, pass_on_warning, fail_on_warning
debug=true
build=123                      

docker run -it --rm \
    --env KEPTN_URL=$keptnApiUrl \
    --env KEPTN_TOKEN=$keptnApiToken \
    --env START=$start \
    --env END=$end \
    --env PROJECT=$project \
    --env SERVICE=$service \
    --env STAGE=$stage \
    --env SOURCE=$source \
    --env PROCESS_TYPE=$processType \
    --env DEBUG=$debug \
    --env LABELS='{"source":"'$source'","build":"'$build'"}' \
    $image
```

Refer to the table below for parameters:

| Required | Name | Description | Valid Values | Default |
|:---:|---|---|---|---|
| Y | KEPTN_URL | URL to Keptn API (1) | example https://api.keptn.11.22.33.44/api  |  |
| Y | KEPTN_TOKEN | Keptn API Token (2) |  |  |
| Y | START | Evaluation Start Time | ISO format: `YYYY-MM-DDTHH:MM:SSZ` |  |
| Y | END | Evaluation End Time | ISO format: `YYYY-MM-DDTHH:MM:SSZ`  |  |
| Y | PROJECT | Keptn Project Name | example: keptnorders  |  |
| Y | SERVICE | Keptn Service Name | example: frontend  |  |
| Y | STAGE | Keptn Stage Name | example: staging  |  ||   | PROCESS_TYPE | How the Docker script will process the Keptn results| ignore, pass_on_warning, fail_on_warning  | ignore |
|   | WAIT_LOOPS | Number of loops to wait for results. Each loop is 10 seconds |  | 20 |
|   | SOURCE | Description for the evaluation request |   | unknown |
|   | LABELS | Keptn labels | Json key-pair array with escaped quotes | see usage example below | |
|   | DEBUG | Detailed Messsage | true, false  | false |
|   | TEST_STRATEGY | Keptn test strategy |  | detached |

*Footnotes:*

(1) Use this command to get your Keptn API URL

```
keptn status
```

(2) Use this command to get your Keptn Token.  If not unix, then refer to [keptn docs](https://keptn.sh/docs/0.7.x/operate/install/#authenticate-keptn-cli).

```
echo "$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)"
```

# Development

Use the following helper unix bash scripts to build and test the docker image

* `buildpush.sh` builds local docker image and then pushes it to registry
* `buildtest.sh` builds local docker image and then calls the `test.sh` script

Local setup

1. Copy the example from the `usage` section above into a file called `test.sh` and then adjust the values for your testing. Note that `test.sh` is part of `.gitignore` so fill in your unique arguments and they won't be saved to the repo.

1. After you save the file run `chmod +x test.sh`

1. Test by just calling `./test.sh` and review the results in your Keptn Bridge UI