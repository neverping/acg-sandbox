#!/bin/bash
# Do not run this script if you didn't run '0[1-5]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

# Check if the cluster is up before attempting the next steps. Otherwise break this script from executing
if [[ "RUNNING" != $(gcloud container clusters describe ${CLUSTER_NAME} --region=${GCP_REGION} --format='value(status)') ]]; then
  exit 1;
fi

echo "Warning: The External Load Balancer might not be ready. Please re-run ${0} in case of errors."

export INIT_EXTERNAL_IP=$(kubectl get svc echo-server-sm -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export CSI_EXTERNAL_IP=$(kubectl get svc echo-server-csi -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Your request can be done using \"curl 'http://${INIT_EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."
echo "Your request can be done using \"curl 'http://${CSI_EXTERNAL_IP}/?echo_file=/mnt/secret-manager/facebook/facebook-token.txt'\" endpoint."
echo "The secret with External Secrets Operator is: $(kubectl get secrets facebook-token -o jsonpath={.data.facebook-token} | base64 -d)"