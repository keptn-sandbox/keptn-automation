#!/bin/bash

image=$1              # e.g. dtdemos/keptn-quality-gate-bash

REPOSITORY=$1
VERSION_TAG=$2
IMAGE=keptn-automation

if [ -z "$REPOSITORY" ]
then
    REPOSITORY=dtdemos
fi

if [ -z "$VERSION_TAG" ]
then
    VERSION_TAG=1
fi

FULLIMAGE=$REPOSITORY/$IMAGE:$VERSION_TAG

echo "==============================================="
echo "Building $FULLIMAGE"
echo "==============================================="
docker build -t $FULLIMAGE .

echo ""
echo "=============================================================="
echo "Ready to push $FULLIMAGE ?"
echo "=============================================================="
read -p "Enter y to push image or any other character to NOT push: " CONT
if [ "$CONT" = "y" ]; then
    docker push $FULLIMAGE;
fi