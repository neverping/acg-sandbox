#!/bin/bash
# HINT: The line below should be used if you're not using Google Cloud Shell.
#export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID="${GOOGLE_CLOUD_PROJECT}"
export GCP_REGION="us-central1"
export GCP_ZONE="$(gcloud compute zones list --filter=name=${GCP_REGION} --format="value(name)" --limit=1)"
export SECRET_NAME="facebook-token"
export CLUSTER_NAME="secret-validate"
export SECRET_MANAGER_SA_NAME="echo-server-sm"
export K8S_NAMESPACE="default"
export FACEBOOK_TOKEN_PATH="/mnt/secret-manager/facebook"
export FACEBOOK_TOKEN_FILE="${FACEBOOK_TOKEN_PATH}/${SECRET_NAME}.txt"