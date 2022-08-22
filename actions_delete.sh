#!/bin/bash
#
# Delete functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Delete the deleted branches and tags from the original repository.
# Arguments:
#     None
# Outputs:
#     remote branches and tags
########################################
function delete_refs() {
    mkdir -p "/tmp/"

    local ORIGIN_REFS
    local ORIGIN_REFS_FILE="/tmp/originRefs.txt"
    local TARGET_REFS
    local TARGET_REFS_FILE="/tmp/targetRefs.txt"

    # list remote (origin) refs
    ORIGIN_REFS="$(retry git ls-remote --refs --heads --tags origin)"
    if [[ $? -ne 0 ]]; then
        color red "failed to fetch remote (origin) refs"

        exit 1
    fi

    echo "${ORIGIN_REFS}" | awk -F' ' '{ print $2 }' | sort > "${ORIGIN_REFS_FILE}"
    color blue "origin refs list"
    cat "${ORIGIN_REFS_FILE}"

    # list remote (target) refs
    TARGET_REFS="$(retry git ls-remote --refs --heads --tags target)"
    if [[ $? -ne 0 ]]; then
        color red "failed to fetch remote (target) refs"

        exit 1
    fi

    echo "${TARGET_REFS}" | awk -F' ' '{ print $2 }' | sort > "${TARGET_REFS_FILE}"
    color blue "target refs list"
    cat "${TARGET_REFS_FILE}"

    # diff
    grep -Fvxf "${ORIGIN_REFS_FILE}" "${TARGET_REFS_FILE}" | xargs -I {} bash -c 'retry git push target -f --delete "{}"'
}
