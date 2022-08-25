#!/bin/bash
# Do not run this script if you didn't run '0[1-3]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

# Check if the cluster is up before attempting the next steps. Otherwise break this script from executing
if [[ "RUNNING" != $(gcloud container clusters describe ${CLUSTER_NAME} --region=${GCP_REGION} --format='value(status)') ]]; then
  exit 1;
fi

helm repo add external-secrets https://charts.external-secrets.io

helm install \
   --create-namespace \
   --namespace external-secrets \
   external-secrets external-secrets/external-secrets
