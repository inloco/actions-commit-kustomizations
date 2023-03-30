#!/bin/bash

set -e

LAST_UPDATE_COMMIT_HASH="$(git log -i --author="github-actions\[bot\]" --grep="chore(k8s): update images to version" --max-count 1 --format=%H)"

# If does not exist, commit body will be empty
if [[ -z "${LAST_UPDATE_COMMIT_HASH}" ]]
then
    LAST_UPDATE_COMMIT_HASH="HEAD"
fi

PR_COMMIT_HASHES="$(git log --merges --format=%H HEAD...${LAST_UPDATE_COMMIT_HASH})"
HAS_MERGE_COMMIT=true

# If does not exist, commits were merged via squash or commits were pushed directly to branch
if [[ -z "${PR_COMMIT_HASHES}" ]]
then
    PR_COMMIT_HASHES="$(git log --format=%H HEAD...${LAST_UPDATE_COMMIT_HASH})"
    HAS_MERGE_COMMIT=false
fi

printf "chore(k8s): update images to version ${IMAGE_TAG}\n\n"

for PR_COMMIT_HASH in ${PR_COMMIT_HASHES}
do
    if [[ ${HAS_MERGE_COMMIT} = true ]]
    then
        # Get commit subject
        git log --format=%b -n1 ${PR_COMMIT_HASH} | cat
    else
        # Get commit message
        git log --format=%s -n1 ${PR_COMMIT_HASH} | cat
    fi
done
