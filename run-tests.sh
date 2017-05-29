#!/bin/bash
COMMIT=$1
COMPONENTS=${@:2}

pushd systemtests
sleep 20
export PATH=$PATH:/tmp/openshift
cat /etc/hosts
curl -L https://raw.githubusercontent.com/EnMasseProject/enmasse/master/install/openshift/enmasse.yaml -o enmasse.yaml
for COMPONENT in $COMPONENTS
do
    sed -i -e "s/${COMPONENT}:latest/${COMPONENT}:${COMMIT}/g" enmasse.yaml
done

./scripts/run_test_travis.sh enmasse.yaml
if [ $? -gt 0 ]; then
    ./scripts/print_logs.sh /tmp/openshift
fi
popd
