#!/bin/sh

# Assumes that COMMIT, DOCKER_EMAIL, DOCKER_USER and DOCKER_PASS to be set
REPO=$1
DIR=$2
TAG="latest"

if [ -n "$TRAVIS_TAG" ]
then
    TAG="$TRAVIS_TAG"
fi

docker build -t $REPO:$COMMIT $DIR || exit 1

if [ "$TRAVIS_BRANCH" == "master" ] || [ -n "$TRAVIS_TAG" ]
then
    docker login -u $DOCKER_USER -p $DOCKER_PASS || exit 1
    docker tag $REPO:$COMMIT $REPO:$TAG || exit 1
    docker tag $REPO:$COMMIT $REPO:travis-$TRAVIS_BUILD_NUMBER || exit 1
    docker push $REPO || exit 1
fi
