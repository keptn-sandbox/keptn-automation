#!/bin/bash

# these functions assume the environment variables were set

createdynatracesecret() {

    echo "================================================================="
    echo "Test CREATE_DT_SECRET"
    echo "================================================================="

    docker run -it --rm \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        --env DT_BASE_URL=$DT_BASE_URL \
        --env DT_API_TOKEN=$DT_API_TOKEN \
        $IMAGE \
        create-dynatrace-secret.sh
}

createservice() {

    echo "================================================================="
    echo "Test create service: CONFIGURE_DT_MONITORING=$CONFIGURE_DT_MONITORING"
    echo "================================================================="

    docker run -it --rm \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        --env KEPTN_SHIPYARD_FILE=$KEPTN_SHIPYARD_FILE \
        --env KEPTN_PROJECT=$KEPTN_PROJECT \
        --env KEPTN_SERVICE=$KEPTN_SERVICE \
        --env KEPTN_STAGE=$KEPTN_STAGE \
        --env CONFIGURE_DT_MONITORING=$CONFIGURE_DT_MONITORING \
        --env DEBUG=$DEBUG \
        -v $(pwd):$MOUNT/ \
        $IMAGE \
        create-service.sh
}


createservice-with-upstream() {

    echo "================================================================="
    echo "Test create service with GIT upstream "
    echo "================================================================="

    docker run -it --rm \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        --env KEPTN_SHIPYARD_FILE=$KEPTN_SHIPYARD_FILE \
        --env KEPTN_PROJECT=$KEPTN_PROJECT \
        --env KEPTN_SERVICE=$KEPTN_SERVICE \
        --env KEPTN_STAGE=$KEPTN_STAGE \
        --env DEBUG=$DEBUG \
        --env GIT_USER=$GIT_USER \
        --env GIT_TOKEN=$GIT_TOKEN \
        --env GIT_REMOTE_URL=$GIT_REMOTE_URL \
        -v $(pwd):$MOUNT/ \
        $IMAGE \
        create-service.sh
}

createservice-with-configure-dt-provider() {

    echo "================================================================="
    echo "Test create with CONFIGURE_DT_PROVIDER"
    echo "================================================================="

    docker run -it --rm \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        --env KEPTN_SHIPYARD_FILE=$KEPTN_SHIPYARD_FILE \
        --env KEPTN_PROJECT=$KEPTN_PROJECT \
        --env KEPTN_SERVICE=$KEPTN_SERVICE \
        --env KEPTN_STAGE=$KEPTN_STAGE \
        --env DEBUG=$DEBUG \
        --env CONFIGURE_DT_PROVIDER=$CONFIGURE_DT_PROVIDER \
        --env DT_BASE_URL=$DT_BASE_URL \
        --env DT_API_TOKEN=$DT_API_TOKEN \
        --env DT_CONF_FILE=$DT_CONF_FILE \
        -v $(pwd):$MOUNT/ \
        $IMAGE \
        create-service.sh
}

sloevaluation() {

    echo "================================================================="
    echo "Test SLO evaluation"
    echo "================================================================="

    docker run -it --rm \
        --env EVALUATION_RULE=$EVALUATION_RULE \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_BRIDGE_URL=$KEPTN_BRIDGE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        --env KEPTN_PROJECT=$KEPTN_PROJECT \
        --env KEPTN_SERVICE=$KEPTN_SERVICE \
        --env KEPTN_STAGE=$KEPTN_STAGE \
        --env SOURCE=$SOURCE \
        --env LABELS=$LABELS \
        --env START=$START \
        --env END=$END \
        --env TIMEFRAME=$TIMEFRAME \
        --env DEBUG=$DEBUG \
        $IMAGE \
        slo-evaluation.sh

}

keptn() {

    echo "================================================================="
    echo "Test keptn - $KEPTN_COMMAND"
    echo "================================================================="

    docker run -it --rm \
        --env KEPTN_BASE_URL=$KEPTN_BASE_URL \
        --env KEPTN_API_TOKEN=$KEPTN_API_TOKEN \
        $IMAGE \
        "keptn.sh $KEPTN_COMMAND"
}