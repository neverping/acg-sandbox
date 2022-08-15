#!/bin/bash
# Do not run this script if you didn't run '0[1-3]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

helm repo add external-secrets https://charts.external-secrets.io

helm install \
   --create-namespace \
   --namespace external-secrets \
   external-secrets external-secrets/external-secrets
