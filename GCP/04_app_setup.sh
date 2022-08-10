#!/bin/bash
# Do not run this script if you didn't run '0[1-3]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

export INIT_CONTAINER="./echo_server_with_initcontainer.yaml"
export CSI_CONTAINER="./echo_server_with_csi.yaml"

test -f ${INIT_CONTAINER} && rm ${INIT_CONTAINER}

test -f ${CSI_CONTAINER} && rm ${CSI_CONTAINER}

# TODO: This should be a Helm.
for files in $(ls k8s/echo-server-with-initcontainer); do
  echo "---" >> ${INIT_CONTAINER}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE}," \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH}," \
    -e "s,MY_PROJECT_ID,${PROJECT_ID}," \
    -e "s,MY_SECRET_NAME,${SECRET_NAME}," \
    k8s/echo-server-with-sidecar/${files} >> ${INIT_CONTAINER}
  echo "" >> ${INIT_CONTAINER}
done

for files in $(ls k8s/echo-server-with-secret-storage-csi | grep -v 00_init); do
  echo "---" >> ${CSI_CONTAINER}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE}," \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH}," \
    -e "s,MY_PROJECT_ID,${PROJECT_ID}," \
    -e "s,MY_SECRET_NAME,${SECRET_NAME}," \
    k8s/echo-server-with-sidecar/${files} >> ${CSI_CONTAINER}
  echo "" >> ${CSI_CONTAINER}
done

echo "You should now run \"kubectl apply -f ${INIT_CONTAINER}\" manually."

echo "You should now run \"kubectl apply -f ${CSI_CONTAINER}\" manually."