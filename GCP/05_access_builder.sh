#!/bin/bash
# Do not run this script if you didn't run '0[1-4]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

export INIT_EXTERNAL_IP=$(kubectl get svc echo-server-sm -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export CSI_EXTERNAL_IP=$(kubectl get svc echo-server-csi -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Your request can be done using \"curl 'http://${INIT_EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."
echo "Your request can be done using \"curl 'http://${CSI_EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."