# Overview

This repo contains scripts to create a container image with the [Keptn CLI](https://keptn.sh/docs/0.9.x/reference/cli/) binary and a set of Unix bash scripts to simplify the effort to integrate Keptn into software delivery pipelines. This design is aimed to approach simplifies maintenance. If there is a new version of the Keptn CLI, one can just update and rebuild the Docker container and the Unix bash scripts automate common logic.

## Container Images

| Keptn Supported Version | Container Image Tag            | Comment |
| ----------------------- | -------------------            | --------|
| 0.9.1                   | dtdemos/keptn-automation:0.1.0 | Initial version |
| 0.9.2                   | dtdemos/keptn-automation:0.1.1 | Update to 0.9.2 Keptn CLI |

# Usage 

## Supported Use cases

1. [Execute ANY Keptn CLI command such as those needed to onboard a service](KEPTN.md)
1. [Create Dynatrace Service secret](CREATE_DYNATRACE_SECRET.md)
1. [Perform SLO Evaluation as a "Quality Gate"](SLO_EVALUATION.md)

## Usage Prerequisites

* [Keptn](https://keptn.sh/docs/quickstart/) with a [Dynatrace tenant](https://www.dynatrace.com/trial) or a [Dynatrace Cloud Automation Environment](https://www.dynatrace.com/support/help/how-to-use-dynatrace/cloud-automation/quality-gates/before-you-begin-with-quality-gates/) environment
* Sample application with Dynatrace OneAgent monitoring
* A pipeline tool that supports running a Docker image with a volume mount.  

## Continuous Delivery pipeline examples

* **GitHub Actions** - see this [repo](https://github.com/dt-demos/github-actions) for examples of how to include in GitHub Actions workflows

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

1. Copy the `test.template.sh` file to `test.sh`.  
1. Within `test.sh`:
    * Adjust the environment variables with required secrets values such as API tokens and URLs
    * Uncomment the tests to run
1. Run `./test.sh` to execute tests

*NOTE: `test.sh` is part of `.gitignore` so fill in your unique arguments and they won't be saved back to the repo.*