#!/bin/sh

# Assumes that COMMIT, DOCKER_EMAIL, DOCKER_USER and DOCKER_PASS to be set
REPO=$1
TAG="latest"

if [ -n "$TRAVIS_TAG" ]
then
    TAG="$TRAVIS_TAG"
fi

docker build -t $REPO:$COMMIT || exit 1

if [ "$TRAVIS_BRANCH" == "master" ] || [ -n "$TRAVIS_TAG" ]
then
    docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS || exit 1
    docker tag $REPO:$COMMIT $REPO:$TAG || exit 1
    docker tag $REPO:$COMMIT $REPO:travis-$TRAVIS_BUILD_NUMBER || exit 1
    docker push || exit 1
fi
