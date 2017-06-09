#!/bin/bash
set -x
COMMIT=$1
ENMASSE_DIR=$2
COMPONENTS=${@:3}

if [ -z $ENMASSE_DIR ] || [ "$ENMASSE_DIR" == "" ]; then
    curl -0 https://dl.bintray.com/enmasse/snapshots/latest/enmasse-latest.tar.gz | tar -zx
    ENMASSE_DIR=`readlink -f enmasse-latest`
else
    ENMASSE_DIR=`readlink -f $ENMASSE_DIR`
fi

pushd systemtests
sleep 20
export PATH=$PATH:/tmp/openshift


for COMPONENT in $COMPONENTS
do
    echo "Replacing for $COMPONENT:$COMMIT"
    sed -i -e "s,${COMPONENT}:latest,${COMPONENT}:${COMMIT},g" $ENMASSE_DIR/openshift/enmasse.yaml
done

echo "Running tests from $ENMASSE_DIR"

./scripts/run_test_component.sh $ENMASSE_DIR
retval=$?
if [ $retval -gt 0 ]; then
    echo "Tests failed, printing logs"
    bash ./scripts/print_logs.sh /tmp/openshift
    echo "Printed logs"
    exit $retval
fi
popd
echo "Done running tests. Exiting with $retval"
exit $retval
