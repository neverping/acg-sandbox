#!/bin/bash
# Do not run this script if you didn't run '0[1-4]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

export EXTERNAL_IP=$(kubectl get svc ${SECRET_MANAGER_SA_NAME} -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Your request can be done using \"curl 'http://${EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."