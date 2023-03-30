#!/bin/bash

set -e

LAST_UPDATE_COMMIT_HASH="$(git log -i --author="github-actions\[bot\]" --grep="chore(k8s): update images to version" --max-count 1 --format=%H)"

# If does not exist, commit body will be empty
if [[ -z "${LAST_UPDATE_COMMIT_HASH}" ]]
then
    LAST_UPDATE_COMMIT_HASH="HEAD"
fi

COMMIT_HASHES="$(git log --merges --format=%H HEAD...${LAST_UPDATE_COMMIT_HASH})"
IS_MERGE_COMMIT=true

# If does not exist, commits were merged via squash or commits were pushed directly to branch
if [[ -z "${COMMIT_HASHES}" ]]
then
    COMMIT_HASHES="$(git log --format=%H HEAD...${LAST_UPDATE_COMMIT_HASH})"
    IS_MERGE_COMMIT=false
fi

printf "chore(k8s): update images to version ${IMAGE_TAG}\n\n"

for COMMIT_HASH in ${COMMIT_HASHES}
do
    if [[ ${IS_MERGE_COMMIT} = true ]]
    then
        PR_REFERENCE="$(git log --format=%s -n1 ${COMMIT_HASH} | grep -oE "#[0-9]+")"
        printf "$(git log --format=%b -n1 ${COMMIT_HASH}) (${PR_REFERENCE})\n"
    else
        git log --format=%s -n1 ${COMMIT_HASH} | cat
    fi
done
