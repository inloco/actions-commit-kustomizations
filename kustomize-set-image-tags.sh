#!/bin/bash

set -e

if [[ ! -d "./k8s/overlays/${OVERLAY}" ]]
then
    exit 0
fi

cd ./k8s/overlays/${OVERLAY}

for IMAGE_REPO in ${IMAGE_REPOS}
do
    kustomize edit set image "${IMAGE_REPO}=*:${IMAGE_TAG}"
done
