#!/bin/sh

# Assumes that COMMIT, DOCKER_USER and DOCKER_PASS to be set
REPO=$1
TAG=${2:-"latest"}

if [ -n "$TRAVIS_TAG" ]
then
    TAG="$TRAVIS_TAG"
fi

if [ "$TRAVIS_BRANCH" == "master" ] || [ -n "$TRAVIS_TAG" ]
then
    if [ "$TRAVIS_PULL_REQUEST" == "false" ]
    then
        docker login -u $DOCKER_USER -p $DOCKER_PASS || exit 1
        docker tag $REPO:$COMMIT $REPO:$TAG || exit 1
        docker push $REPO || exit 1
    fi
fi
