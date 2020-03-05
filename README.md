# Overview

Dockerized Bash script that will call the Keptn Quality Gate API.  

Script logic:
1. calls the ```start evaluation``` Keptn API and save the ```keptncontext  ID``` from the response
1. while loop with 30 second wait between calls to ```evaluate results``` Keptn API using the ```keptncontext  ID```
1. Keptn will return value of ```pass```, ```fail```, or ```warning``` in the JSON response
1. if status is NOT ```pass``` then Docker will exit with status of 1

# Setup

1. This assumes you are using ```Keptn 0.6.0``` and have a service onboarded.  See example setup and in this [README](https://github.com/grabnerandi/keptn-qualitygate-examples/blob/master/sample/README.md).  You will need the following values as parameters to the quality gate.

    * Keptn API URL
    * Keptn Token
    * Project
    * Service
    * Stage
    * Evalation start time (UTC)
    * Evalation end time (UTC)

1. Use this command to get your Keptn API URL
    ```
    keptn status
    ```

1. Use this command to get your Keptn Token
    ```
    echo "$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)"
    ```

# Usage

Call the ```docker run``` command as shown in this example.  

    ```
    image=robjahn/keptn-quality-gate-bash
    keptnApiUrl=https://api.keptn.<YOUR KEPTN DOMAIN>
    keptnApiToken=<YOUR KEPTN TOKEN>
    startTime=2019-11-21T11:00:00.000Z
    endTime=2019-11-21T11:00:10.000Z
    project=keptnorders
    service=frontend
    stage=staging
    debug=true

    docker run -it --rm \
        --env KEPTN_URL=$keptnApiUrl \
        --env KEPTN_TOKEN=$keptnApiToken \
        --env START=$start \
        --env END=$end \
        --env PROJECT=$project \
        --env SERVICE=$service \
        --env STAGE=$stage \
        --env DEBUG=$debug \
        $image
    ```

NOTES:
  * The ```START``` and ```END``` parameters is in ISO format: ```YYYY-MM-DDTHH:MM:SSZ```
  * Add the ```--env debug=true``` parameter to get additonal details
  * This pre-built image can be used if you don't want to make build your own. ```robjahn/keptn-quality-gate-bash```

# Helper scripts

* ```run.sh``` calls the ```docker run``` command with the required arguments
* ```buildrun.sh``` builds local docker image and then calls the ```run.sh``` script
* Make a ```test.sh``` script (included part of .gitignore) with your unique arguments as shown below:

```
#!/bin/bash

image=robjahn/keptn-quality-gate-bash
keptnApiUrl=https://api.keptn.XXXX
keptnApiToken=XXXX
start=2019-11-21T11:00:00.000Z
end=2019-11-21T11:10:00.000Z
project=keptnorders
service=frontend
stage=staging
debug=true

./buildrun.sh $image $keptnApiUrl $keptnApiToken $start $end $project $service $stage $debug

```