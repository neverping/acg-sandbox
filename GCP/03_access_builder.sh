#!/bin/bash
set -euo pipefail

source ./00_variables.sh

export EXTERNAL_IP=$(kubectl get svc ${SECRET_MANAGER_SA_NAME} -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Your request can be done using \"curl 'http://${EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."