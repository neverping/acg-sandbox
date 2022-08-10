#!/bin/bash
# Do not run this script if you didn't run '0[1-3]_*.sh' scripts first!
set -euo pipefail

source ./00_variables.sh

export INIT_CONTAINER_SRC="k8s/echo-server-with-initcontainer"
export CSI_CONTAINER_SRC="k8s/echo-server-with-secret-storage-csi"

export INIT_CONTAINER_FILE="./echo_server_with_initcontainer.yaml"
export CSI_CONTAINER_FILE="./echo_server_with_csi.yaml"


test -f ${INIT_CONTAINER_FILE} && rm ${INIT_CONTAINER_FILE}

test -f ${CSI_CONTAINER_FILE} && rm ${CSI_CONTAINER_FILE}

# TODO: This should be a Helm.
for files in $(ls ${INIT_CONTAINER_SRC}); do
  echo "---" >> ${INIT_CONTAINER_FILE}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE}," \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH}," \
    -e "s,MY_PROJECT_ID,${PROJECT_ID}," \
    -e "s,MY_SECRET_NAME,${SECRET_NAME}," \
    ${INIT_CONTAINER_SRC}/${files} >> ${INIT_CONTAINER_FILE}
  echo "" >> ${INIT_CONTAINER_FILE}
done

for files in $(ls ${CSI_CONTAINER_SRC} | grep -v 00_init); do
  echo "---" >> ${CSI_CONTAINER_FILE}
  sed \
    -e "s,MY_FACEBOOK_TOKEN_FILE,${FACEBOOK_TOKEN_FILE}," \
    -e "s,MY_FACEBOOK_TOKEN_PATH,${FACEBOOK_TOKEN_PATH}," \
    -e "s,MY_PROJECT_ID,${PROJECT_ID}," \
    -e "s,MY_SECRET_NAME,${SECRET_NAME}," \
    ${CSI_CONTAINER_SRC}/${files} >> ${CSI_CONTAINER_FILE}
  echo "" >> ${CSI_CONTAINER_FILE}
done

echo "You should now run \"kubectl apply -f ${INIT_CONTAINER_FILE}\" manually."

echo "You should now run \"kubectl apply -f ${CSI_CONTAINER_FILE}\" manually."