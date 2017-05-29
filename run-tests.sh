#!/bin/bash
COMMIT=$1
ENMASSE_DIR=$2
COMPONENTS=${@:3}

pushd systemtests
sleep 20
export PATH=$PATH:/tmp/openshift

if [ -n $ENMASSE_DIR ] || [ "$ENMASSE_DIR" == "" ]; then
    curl -0 https://dl.bintray.com/enmasse/snapshots/latest/enmasse-latest.tar.gz | tar -zx
    ENMASSE_DIR=`readlink -f enmasse-latest`
else
    ENMASSE_DIR=`readlink -f $ENMASSE_DIR`
fi

for COMPONENT in $COMPONENTS
do
    echo "Replacing for $COMPONENT"
    sed -i -e "s,${COMPONENT}:latest,${COMPONENT}:${COMMIT},g" $ENMASSE_DIR/openshift/enmasse.yaml
done

./scripts/run_test_component.sh $ENMASSE_DIR
if [ $? -gt 0 ]; then
    ./scripts/print_logs.sh /tmp/openshift
fi
popd
