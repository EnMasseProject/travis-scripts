#!/bin/sh
NEWUSER=$1
NEWTOKEN=$2
NEWPASS=$3

for i in `find . -name ".travis.yml"`
do
    bdir=`dirname $i`
    echo $bdir
    pushd $bdir
    travis encrypt --add -p DOCKER_USER=$NEWUSER
    travis encrypt --add -p DOCKER_PASS=$NEWPASS
    travis encrypt --add -p TRAVIS_TOKEN=$NEWTOKEN
    vim .travis.yml
    ## git commit .travis.yml -m 'Update secrets' && git push
    popd
done
