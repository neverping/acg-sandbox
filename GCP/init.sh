#!/bin/bash
export PROJECT_ID=$(gcloud config get-value project)
export GCP_REGION="us-central1"
export GCP_ZONE="$(gcloud compute zones list --filter=name=${GCP_REGION} --format="value(name)" --limit=1)"
export SECRET_NAME="facebook-token"
gcloud config set compute/region "${GCP_REGION}"
gcloud config set compute/zone "${GCP_ZONE}"
gcloud services enable secretmanager.googleapis.com container.googleapis.com cloudbuild.googleapis.com
gcloud secrets create ${SECRET_NAME} --replication-policy="user-managed" --locations=${GCP_REGION}
echo "the-first-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-second-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-third-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
echo "the-fourth-version" | gcloud secrets versions add ${SECRET_NAME} --data-file=-
gcloud secrets versions disable 4 --secret="${SECRET_NAME}"
gcloud secrets versions destroy 1 --secret="${SECRET_NAME}"