#!/bin/bash

set -e

if [[ ! -d "./k8s/overlays/${OVERLAY}" ]]
then
    exit 0
fi

cd ./k8s/overlays/${OVERLAY}

for IMAGE in ${IMAGES}
do
    kustomize edit set image "${IMAGE}=*:${TAG}"
done
