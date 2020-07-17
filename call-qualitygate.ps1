param(

[Parameter(Position=0,mandatory=$true)]
[string]$Image,

[Parameter(Position=1,mandatory=$true)]
[string]$KeptnApiUrl,

[Parameter(Position=2,mandatory=$true)] 
[string]$KeptnApiToken,

[Parameter(Position=3,mandatory=$true)] 
[string]$Start,

[Parameter(Position=4,mandatory=$true)] 
[string]$End,

[Parameter(Position=5,mandatory=$true)] 
[string]$Project,

[Parameter(Position=6,mandatory=$true)] 
[string]$Service,

[Parameter(Position=7,mandatory=$true)] 
[string]$Stage,

[Parameter()]
[string]$Labels,

[Parameter()]
[string]$ProcessType,

[Parameter()]
[string]$DebugLevel

)

Write-Host "==============================================="
Write-Host "running keptn-quality-gate"
Write-Host "==============================================="
Write-Host "Image          = $Image"
Write-Host "KeptnApiUrl    = $KeptnApiUrl"
Write-Host "KeptnApiToken  = $KeptnApiToken"
Write-Host "Start          = $Start"
Write-Host "End            = $End"
Write-Host "Project        = $Project"
Write-Host "Service        = $Service"
Write-Host "Stage          = $Stage"
Write-Host "Labels          = $Labels"
Write-Host "ProcessType    = $ProcessType"
Write-Host "DebugLevel     = $DebugLevel"
Write-Host "==============================================="

docker run -i `
    --env KEPTN_URL=$KeptnApiUrl `
    --env KEPTN_TOKEN=$KeptnApiToken `
    --env START=$Start `
    --env END=$End `
    --env PROJECT=$Project `
    --env SERVICE=$Service `
    --env STAGE=$Stage `
    --env LABELS=$Labels `
    --env PROCESS_TYPE=$ProcessType `
    --env DEBUG=$DebugLevel `
    $image
