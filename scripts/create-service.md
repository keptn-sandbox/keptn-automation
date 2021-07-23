# Overview

Use this action type to create a Keptn service. [Keptn Docs](https://keptn.sh/docs/0.8.x/manage/). 

# Script logic

1. call `keptn auth`
1. if project does not exist, call `keptn create project` 
1. if service does not exist, call `keptn create service`
    * if pass in `GIT_USER`, then add CLI arguments to configure service upstream repo credentials [Keptn Docs](https://keptn.sh/docs/0.8.x/manage/git_upstream/)
1. if KEPTN_SLO_FILE provided, call `keptn add-resource` to add SLO file as a keptn resource
1. if `CONFIGURE_DT_MONITORING = true`
    * Configures the Dynatrace tenant by creating tagging rules, a problem notification, an alerting profile as well as a project-specific dashboard and management zone [Keptn Docs](https://keptn.sh/docs/0.8.x/monitoring/dynatrace/install/#verify-dynatrace-configuration)
    * call `keptn configure monitoring dynatrace --project=$KEPTN_PROJECT`
1. if `CONFIGURE_DT_PROVIDER = true`
    * call `keptn add-resource` to add `dynatrace.conf.yaml` as a keptn resource
    * if `DT_SLI_FILE` provided, call `keptn add-resource` to add `dynatrace/sli.yaml` as a keptn resource

# Environment variables

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
| CONFIGURE_DT_PROVIDER | Set to `true` or `false` |  | false |
| DT_SLI_FILE | Dynatrace SLI filename |  |  |
| DT_CONF_FILE | Dynatrace Configuration filename. Required if `CONFIGURE_DT_SLI=true` | **Depends** |  |
| DEBUG | Set to `true` or `false` | | false |
| GIT_USER | User for upstream repo |  |  |
| GIT_TOKEN | User API Token for upstream repo |  |  |
| GIT_REMOTE_URL | URL for upstream repo |  |  |
