#!/bin/bash
set -euo pipefail

source ./00_variables.sh

export YAML_BUNDLE="./echo_server_with_sidecar.yaml"

# Do not run this script if you didn't run '01_init.sh' script first!
kubectl create serviceaccount ${SECRET_MANAGER_SA_NAME} --namespace ${K8S_NAMESPACE}
gcloud iam service-accounts create ${SECRET_MANAGER_SA_NAME} --project=${PROJECT_ID}

#gcloud projects add-iam-policy-binding PROJECT_ID \
#    --member "serviceAccount:${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
#    --role "roles/spanner.viewer"

gcloud iam service-accounts add-iam-policy-binding ${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[NAMESPACE/${K8S_NAMESPACE}]"

kubectl annotate serviceaccount ${SECRET_MANAGER_SA_NAME} \
    --namespace ${K8S_NAMESPACE} \
    iam.gke.io/gcp-service-account=${SECRET_MANAGER_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

# TODO: This should be a Helm.

if [[ -f ${YAML_BUNDLE} ]]; then
  rm ${YAML_BUNDLE}
fi

for files in $(ls k8s/echo-server-with-sidecar); do
  echo "---" >> ${YAML_BUNDLE}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE},g" \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH},g" \
    -e "s,MY_PROJECT_ID,${PROJECT_ID},g" \
    -e "s,MY_SECRET_NAME,${SECRET_NAME},g" \
    k8s/echo-server-with-sidecar/${files} >> yaml_to_apply.yaml
 done
