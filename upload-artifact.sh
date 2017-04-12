#!/bin/sh

# Assumes that BINTRAY_API_USER and BINTRAY_API_KEY to be set
REPOSITORY=$1
ARTIFACT=$2
TAG="latest"

if [ -n "$TRAVIS_TAG" ]
then
    TAG="$TRAVIS_TAG"
fi

FILENAME=`basename $ARTIFACT`


if [ "$TRAVIS_BRANCH" == "master" ] || [ -n "$TRAVIS_TAG" ]
then
    if [ "$TRAVIS_PULL_REQUEST" == "false" ]
    then
        curl -T $ARTIFACT -u${BINTRAY_API_USER}:${BINTRAY_API_KEY} "https://api.bintray.com/content/enmasse/artifacts/${REPOSITORY}/${TAG}/${TAG}/${FILENAME}?publish=1&override=1"
    fi
fi
