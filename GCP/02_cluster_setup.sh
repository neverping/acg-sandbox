#!/bin/bash
# Do not run this script if you didn't run '01_init.sh' script first!

set -euo pipefail
source ./00_variables.sh

# We need the new GKE auth plugin installed on clusters 1.21 and newer.
#gcloud components install gke-gcloud-auth-plugin


# Check if the cluster is up before attempting the next steps. Otherwise break this script from executing
if [[ "RUNNING" != $(gcloud container clusters describe ${CLUSTER_NAME} --region=${GCP_REGION} --format='value(status)') ]]; then
  exit 1;
fi

# Minimal steps needed by providing K8s access to GCP Secret Manager
kubectl create serviceaccount ${SECRET_MANAGER_SA_NAME} --namespace ${K8S_NAMESPACE}

gcloud iam service-accounts create ${SECRET_MANAGER_SA_NAME} --project=${PROJECT_ID}

gcloud iam service-accounts add-iam-policy-binding ${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${K8S_WORKLOAD_POOL}[${K8S_NAMESPACE}/${SECRET_MANAGER_SA_NAME}]"

# HINT: We allow directly at the RESOURCE level because ACG doesn't allow our USER ACCOUNTS to grant permissions at the PROJECT level.
gcloud secrets add-iam-policy-binding ${SECRET_NAME} \
    --member="serviceAccount:${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role='roles/secretmanager.secretAccessor'

# HINT: We allow directly at the RESOURCE level because ACG doesn't allow our USER ACCOUNTS to grant permissions at the PROJECT level.
gcloud secrets add-iam-policy-binding ${SECRET_NAME} \
    --member="serviceAccount:${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role='roles/secretmanager.viewer'

kubectl annotate serviceaccount ${SECRET_MANAGER_SA_NAME} \
    --namespace ${K8S_NAMESPACE} \
    iam.gke.io/gcp-service-account=${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
