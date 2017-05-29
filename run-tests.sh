#!/bin/bash
COMPONENT=$1
COMMIT=$2

pushd systemtests
sleep 20
export PATH=$PATH:/tmp/openshift
cat /etc/hosts
curl -L https://raw.githubusercontent.com/EnMasseProject/enmasse/master/install/openshift/enmasse.yaml -o enmasse.yaml
sed -i -e "s/${COMPONENT}:latest/${COMPONENT}:${COMMIT}/g" enmasse.yaml

./scripts/run_test_travis.sh enmasse.yaml
./scripts/print_logs.sh
popd
