# Overview

This repo contains scripts to create a container image with the [Keptn CLI](https://keptn.sh/docs/0.13.x/reference/cli/) binary and a set of Unix bash scripts to simplify the effort to integrate Keptn into software delivery pipelines. This design is aimed to approach simplifies maintenance. If there is a new version of the Keptn CLI, one can just update and rebuild the Docker container and the Unix bash scripts automate common logic.

# Usage 

## Supported Use cases

1. [Execute ANY Keptn CLI command such as those needed to onboard a service](KEPTN.md)
1. [Perform SLO Evaluation as a "Quality Gate"](SLO_EVALUATION.md)
1. [Create Dynatrace Service secret](CREATE_DYNATRACE_SECRET.md)

## Examples

See the [examples](examples/) folder in this repo for example for various platforms.
* Azure DevOps
* GitHub
* GitLab
* JFrog pipelines

## Usage Prerequisites

* [Keptn](https://keptn.sh/docs/quickstart/) with a [Dynatrace tenant](https://www.dynatrace.com/trial) or a [Dynatrace Cloud Automation Environment](https://www.dynatrace.com/support/help/how-to-use-dynatrace/cloud-automation/quality-gates/before-you-begin-with-quality-gates/) environment
* Sample application with Dynatrace OneAgent monitoring
* A pipeline tool that supports running a Docker image with a volume mount.  

## Container Images

| Keptn Supported Version | Container Image Tag            | Comment |
| ----------------------- | -------------------            | --------|
| 0.9.1                   | dtdemos/keptn-automation:0.1.0 | Initial version |
| 0.9.2                   | dtdemos/keptn-automation:0.1.1 | Update to 0.9.2 Keptn CLI |
| 0.10.0                  | dtdemos/keptn-automation:0.2.0 | Update to 0.10.0 Keptn CLI |
| 0.10.0                  | dtdemos/keptn-automation:0.2.1 | Adjust SLO output to be JSON format |
| 0.12.0                  | dtdemos/keptn-automation:0.4.0 | Update to 0.12.0 Keptn CLI |
| 0.12.6                  | dtdemos/keptn-automation:0.4.1 | Update to 0.12.6 Keptn CLI |
| 0.13.6                  | dtdemos/keptn-automation:0.5.0 | Update to 0.13.6 Keptn CLI |

# Development

## Build new versions

* Update the `version` file and readme compatibility grid using [Semantic Versioning](https://semver.org/)
    * New MAJOR version for Keptn CLI or scripts that are breaking changes 
    * New MINOR version for new versions of Keptn CLI or scripts that are backwards compatible manner
    * New PATCH version for patch fixes to Keptn CLI or scripts that are backwards compatible manner
* Update `Dockerfile` for new version of the Keptn CLI
* Use the `buildpush.sh` script to build and push the build Docker image.  NOTE: This script reads the `version` file for the Docker image tag label
* Once finalized add a Git Tag for the new version using the guide below as reference

    ```
    # list tags with descriptions
    git tag -n

    # add new tag
    git tag -a [tagname] -m [description]
    git push origin [tagname]
    
    # add new tag example:
    git tag -a "release-0.2.0" -m "Update to keptn 0.10.0"
    git push origin release-0.2.0

    # to checkout a tag
    git checkout [tagname]

    # to checkout main branch
    git checkout master
    ```

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