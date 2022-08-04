#!/bin/bash
export PROJECT_ID=$(gcloud config get-value project)
export GCP_REGION="us-central1"
export GCP_ZONE="$(gcloud compute zones list --filter=name=${GCP_REGION} --format="value(name)" --limit=1)"
gcloud config set compute/region="${GCP_REGION}"
gcloud config set compute/zone="${GCP_ZONE}"