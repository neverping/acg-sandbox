#!/bin/bash
# Do not run this script if you didn't run '0[1-6]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

export INIT_CONTAINER_SRC="k8s/echo-server-with-initcontainer"
export CSI_CONTAINER_SRC="k8s/echo-server-with-secret-storage-csi"
export ESO_CONTAINER_SRC="k8s/secrets-via-external-secret-operator"


export INIT_CONTAINER_FILE="./echo_server_with_initcontainer.yaml"
export CSI_CONTAINER_FILE="./echo_server_with_csi.yaml"
export ESO_CONTAINER_FILE="./echo_server_with_eso.yaml"

# Check if the cluster is up before attempting the next steps. Otherwise break this script from executing
if [[ "RUNNING" != $(gcloud container clusters describe ${CLUSTER_NAME} --region=${GCP_REGION} --format='value(status)') ]]; then
  exit 1;
fi

test -f ${INIT_CONTAINER_FILE} && rm ${INIT_CONTAINER_FILE}

test -f ${CSI_CONTAINER_FILE} && rm ${CSI_CONTAINER_FILE}

test -f ${ESO_CONTAINER_FILE} && rm ${ESO_CONTAINER_FILE}


# TODO: This should be a Helm.
for files in $(ls ${INIT_CONTAINER_SRC}); do
  echo "---" >> ${INIT_CONTAINER_FILE}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE},g" \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH},g" \
    -e "s,MY_PROJECT_ID,${PROJECT_ID},g" \
    -e "s,MY_SECRET_NAME,${SECRET_NAME},g" \
    ${INIT_CONTAINER_SRC}/${files} >> ${INIT_CONTAINER_FILE}
  echo "" >> ${INIT_CONTAINER_FILE}
done

for files in $(ls ${CSI_CONTAINER_SRC} | grep -v 00_init); do
  echo "---" >> ${CSI_CONTAINER_FILE}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE},g" \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH},g" \
    -e "s,MY_PROJECT_ID,${PROJECT_ID},g" \
    -e "s,MY_SECRET_NAME,${SECRET_NAME},g" \
    ${CSI_CONTAINER_SRC}/${files} >> ${CSI_CONTAINER_FILE}
  echo "" >> ${CSI_CONTAINER_FILE}
done

for files in $(ls ${ESO_CONTAINER_SRC}); do
  echo "---" >> ${ESO_CONTAINER_FILE}
  sed \
    -e "s,MY_NAMESPACE,default,g" \
    -e "s,MY_GCP_REGION,${GCP_REGION},g" \
    -e "s,MY_CLUSTER_NAME,${CLUSTER_NAME},g" \
    -e "s,MY_SECRET_MANAGER_SA_NAME,${SECRET_MANAGER_SA_NAME},g" \
    -e "s,MY_PROJECT_ID,${PROJECT_ID},g" \
    -e "s,MY_SECRET_NAME,${SECRET_NAME},g" \
    ${ESO_CONTAINER_SRC}/${files} >> ${ESO_CONTAINER_FILE}
  echo "" >> ${ESO_CONTAINER_FILE}
done

echo "We're about to apply ${INIT_CONTAINER_FILE}, ${ESO_CONTAINER_FILE}, and ${CSI_CONTAINER_FILE} files into K8s!"

kubectl apply -f ${INIT_CONTAINER_FILE}
kubectl apply -f ${CSI_CONTAINER_FILE}
kubectl apply -f ${ESO_CONTAINER_FILE}