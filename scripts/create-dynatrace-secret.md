# Overview

Use this action type to create Dynatrace secret with required credentials. [Keptn Docs](https://keptn.sh/docs/0.8.x/monitoring/dynatrace/install/#1-create-a-secret-with-required-credentials). 

## Script logic

1. call `keptn auth`
1. call `keptn delete secret dynatrace`
1. call `keptn create secret dynatrace`

## Environment variables

| Variable | Description | Required | Default |
| -------- | ----------- | ---------| ------- |
| KEPTN_BASE_URL | Keptn Tenant URL  | **Yes** | |
| KEPTN_API_TOKEN | Keptn API Token  | **Yes** | |
| DT_BASE_URL | Dynatrace Tenant URL such as http://abc.live.dynatrace.com | **Yes** | |
| DT_API_TOKEN | Dynatrace API Token  | **Yes** | |
| DEBUG | Set to `true` or `false` | | false |
