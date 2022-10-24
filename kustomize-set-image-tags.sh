#!/bin/bash

set -e

split_image() {
    export IMAGE_REPO="$(sed -En 's/([^:]*).*/\1/p' <<< ${1})"
    export IMAGE_TAG_SUFFIX="$(sed -En 's/.*:(.*)/\1/p' <<< ${1})"
    if [[ ! -z "${IMAGE_TAG_SUFFIX}" ]]
    then
        export IMAGE_TAG_SUFFIX="-${IMAGE_TAG_SUFFIX}"
    fi
}

if [[ ! -d "${K8S_PATH}/overlays/${OVERLAY}" ]]
then
    exit 0
fi

cd ${K8S_PATH}/overlays/${OVERLAY}

for IMAGE in ${IMAGES}
do
    split_image ${IMAGE}
    kustomize edit set image "${IMAGE}=*:${IMAGE_TAG}${IMAGE_TAG_SUFFIX}"
done
