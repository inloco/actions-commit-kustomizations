#!/bin/bash

set -xe

IMAGE_TAG=${1}

if [[ "${IMAGE_TAG}" = "commit-sha" ]]
then
    git describe --always --dirty --exclude '*'
else
    printf "${IMAGE_TAG}"
fi
