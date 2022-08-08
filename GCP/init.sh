#!/bin/bash
# HINT: The line below should be used if you're not using Google Cloud Shell.
#export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID="${GOOGLE_CLOUD_PROJECT}"
export GCP_REGION="us-central1"
export GCP_ZONE="$(gcloud compute zones list --filter=name=${GCP_REGION} --format="value(name)" --limit=1)"
export SECRET_NAME="facebook-token"
export CLUSTER_NAME="secret-validate"

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
gcloud secrets versions destroy 1 --secret="${SECRET_NAME}"

## Kubernetes
echo "We're now about to create the K8s cluster. This might take 10 minutes."
gcloud container clusters create ${CLUSTER_NAME} --region="${GCP_REGION}" --num-nodes=1 --workload-pool="${PROJECT_ID}.svc.id.goog"