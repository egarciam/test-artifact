#!/bin/sh
NEXUS_BASE_URL="http://gcs-tools.tk:8081/"
REPOSITORY="gcsw-releases"
GROUP_ID="es.orange.dsi.cgsw"
ARTIFACT_ID="pvcsapi"
VERSION="0.4.2"
LOCAL_FILE="destination.jar"

echo ${NEXUS_BASE_URL}

NEXUS_RESOLVE_URL="${NEXUS_BASE_URL}artifact/maven/resolve?g=${GROUP_ID}&a=${ARTIFACT_ID}&r=${REPOSITORY}&v=${VERSION}"

echo ${NEXUS_RESOLVE_URL}
REPOSITORY_LOCAL_PATH=`curl -s "${NEXUS_RESOLVE_URL}" | xmllint --xpath "//artifact-resolution/data/repositoryPath/text()" -`
ARTIFACT_DOWNLOAD_URL="${NEXUS_BASE_URL}repository/${REPOSITORY}/content${REPOSITORY_LOCAL_PATH}"
curl -o "${LOCAL_FILE}" "${ARTIFACT_DOWNLOAD_URL}"
