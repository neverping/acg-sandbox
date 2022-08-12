#!/bin/bash
set -euo pipefail

source ./00_variables.sh

# To be Used both by GKE and Secret Manager
gcloud config set compute/region "${GCP_REGION}"
gcloud config set compute/zone "${GCP_ZONE}"

## Needed APIs
gcloud services enable secretmanager.googleapis.com container.googleapis.com cloudbuild.googleapis.com

## Secret Manager
gcloud secrets create ${SECRET_NAME} --replication-policy="user-managed" --locations=${GCP_REGION}
echo "the-first-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-second-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-third-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-fourth-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
gcloud secrets versions disable 4 --secret="${SECRET_NAME}"
gcloud secrets versions destroy 1 --secret="${SECRET_NAME}" --quiet

## Kubernetes
echo "We're now about to create the K8s cluster. This might take 10 minutes."
gcloud container clusters create ${CLUSTER_NAME} --region="${GCP_REGION}" --num-nodes=1 --workload-pool="${K8S_WORKLOAD_POOL}"