#!/bin/bash
# Do not run this script if you didn't run '01_init.sh' and '02_cluster_setup.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

helm install \
  --set syncSecret.enabled=true \
  --set enableSecretRotation=true \
  --namespace kube-system \
  csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver

# Based on secrets-store-csi-driver-provider-gcp/deploy/provider-gcp-plugin.yaml on https://github.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp.git
kubectl apply -f echo-server-with-secret-storage-csi/00_init.yaml
