# Overview

Container image containing logic to integrate Keptn into your DevOps scripts and software delivery pipelines within CI/CD workflows for those tools that support running an image with a volume mount.  See this Dynatrace [blog](https://www.dynatrace.com/news/blog/answer-driven-release-validation-with-dynatrace-saas-cloud-automation/) for more details.

Within the container image is the Keptn CLI binary and a set of Unix bash scripts that have the logic to call the Keptn CLI for these use cases:

* Create the Dynatrace Keptn service secret
* Onboard a Keptn service 
* Perform SLO evaluation
* Call the Keptn CLI 

The Keptn CLI command need to be called in the right order with the right arguments, so this design approach simplifies maintenance. If there is a new version of the Keptn CLI, one can just update and rebuild the Docker container.  

# Container Images

| Keptn Supported Version | Container Image Tag            | Comment |
| ----------------------- | -------------------            | --------|
| 0.8.6                   | dtdemos/keptn-automation:0.1.0 | Initial version |

# Usage Prerequisites

* [Keptn](https://keptn.sh/docs/quickstart/) or [Dynatrace Cloud Automation Environment](https://www.dynatrace.com/support/help/how-to-use-dynatrace/cloud-automation/quality-gates/before-you-begin-with-quality-gates/) environment
* [Dynatrace tenant](https://www.dynatrace.com/trial)
* Sample application with Dynatrace OneAgent monitoring

# Basic Usage

Below is the basic usage using a Docker example. 

Any inputs are specified as environment variables as shown below with the script to invoke. For example calling a script such as `create-service.sh`:

```
docker run -it --rm \
    --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
    --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
    --env ... \
    --env ... \
    -v $(pwd):/keptn-mount/ \
    $IMAGE \
    create-service.sh
```

**NOTE: Any file specified requires that a Docker volume is specified so that the files that will be processed.**

See the `Development` section below of this readme for more examples using `docker run`

# Script details

See these README pages for script details
* [create-dynatrace-secret.sh](scripts/create-dynatrace-secret.md)
* [create-service.sh](scripts/create-service.md)
* [slo-evaluation.sh](scripts/slo-evaluation.md)
* [keptn.sh](scripts/keptn.md)

# Implement with GitHub Actions workflows

See [this](https://github.com/dt-demos/github-actions) repo for examples of how to include in GitHub Actions workflows.

# Development

## Build new versions

* Update the `version` file and readme compatibility grid
* Update docker for new version of the Keptn CLI
* Use the `buildpush.sh` script to build and push the built image.  This script reads the `version` file for the tag label

## Test locally

See the `test/` subfolder for test scripts. 

* `test-library.sh` is a library of functions for each use case.  These function use a `docker run` command and expect environment variables for the arguments to be set 
* `test.template.sh` is starter test script that sets the environment variables and calls the functions in `test-library.sh`.  You can adjust to meet your needs. 

To have your own test script copy, do the following:

* Copy the `test.template.sh` file one called `test.sh`.  
    * NOTE: `test.sh` is part of `.gitignore` so fill in your unique arguments and they won't be saved back to the repo.
* Within `test.sh` adjust the variables with required secrets values as well as what tests to run
* Run `chmod +x test.sh`
* Run `./test.sh` to execute test