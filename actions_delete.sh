#!/bin/sh
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
    local ORIGIN_BRANCH_FILE="/tmp/originBranches.txt"
    local TARGET_BRANCH_FILE="/tmp/targetBranches.txt"

    mkdir -p "/tmp/"

    git ls-remote --refs --heads --tags origin | awk -F' ' '{ print $2 }' | sort > "${ORIGIN_BRANCH_FILE}"
    if [[ $? != 0 ]]; then
        color red "failed to fetch remote (origin) refs"

        exit 1
    fi
    color blue "origin branch list"
    cat "${ORIGIN_BRANCH_FILE}"

    git ls-remote --refs --heads --tags target | awk -F' ' '{ print $2 }' | sort > "${TARGET_BRANCH_FILE}"
    if [[ $? != 0 ]]; then
        color red "failed to fetch remote (target) refs"

        exit 1
    fi
    color blue "target branch list"
    cat "${TARGET_BRANCH_FILE}"

    grep -Fvxf "${ORIGIN_BRANCH_FILE}" "${TARGET_BRANCH_FILE}" | xargs -I {} git push target -f --delete {}
}
