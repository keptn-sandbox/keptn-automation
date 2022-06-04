FROM alpine:latest

RUN apk --no-cache add \
    bash \
    jq

RUN apk add curl

# Install Keptn CLI **********************************
ARG KEPTN_VERSION="0.13.6"

RUN curl -LO https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/keptn-${KEPTN_VERSION}-linux-amd64.tar.gz
RUN tar -xvf keptn-${KEPTN_VERSION}-linux-amd64.tar.gz
RUN mv keptn-${KEPTN_VERSION}-linux-amd64 keptn

# copy in CLI and scripts **********************************
RUN chmod +x keptn && mv keptn /usr/bin/
COPY scripts/*.sh /usr/bin

# this allow to run any commmand in this location
ENTRYPOINT ["/bin/bash", "-l", "-c"]
