#!/bin/bash

set -e

UPDATE_COMMIT_MESSAGE_PREFIX="chore(k8s): update images to version"
LAST_UPDATE_COMMIT_HASH="$(git log -i --author="github-actions\[bot\]" --grep="${UPDATE_COMMIT_MESSAGE_PREFIX}" --max-count 1 --format=%H)"

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

printf "${UPDATE_COMMIT_MESSAGE_PREFIX} ${IMAGE_TAG}\n\n"

for COMMIT_HASH in ${COMMIT_HASHES}
do
    COMMIT_MESSAGE="$(git log --format=%s -n1 ${COMMIT_HASH})"

    if [[ ${IS_MERGE_COMMIT} = true ]]
    then
        if [[ "$(grep -oE "^Merge pull request" <<< ${COMMIT_MESSAGE})" ]]
        then
            PR_NUMBER="$(sed -nE 's/.*(#[0-9]+).*$/\1/p' <<< ${COMMIT_MESSAGE})"
            COMMIT_BODY="$(git log --format=%b -n1 ${COMMIT_HASH})"
            printf "${COMMIT_BODY} (${PR_NUMBER})\n"
        fi
    else
        printf "${COMMIT_MESSAGE}\n"
    fi
done
