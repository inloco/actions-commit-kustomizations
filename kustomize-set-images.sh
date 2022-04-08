#!/bin/bash

set -e

if [[ -z "${IMAGES}" ]]
then
    exit 0
fi

cd ./k8s/overlays/${OVERLAY}

for IMAGE in ${IMAGES}
do
    kustomize edit set image "${IMAGE}:${TAG}"
done
