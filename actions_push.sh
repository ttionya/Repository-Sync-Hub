#!/bin/bash
#
# Push functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Push current ref to remote.
# Arguments:
#     None
########################################
function push_current_ref() {
    git_retry push target "${GITHUB_REF}:${GITHUB_REF}" -f
}

########################################
# Push all branches and tags to remote.
# Arguments:
#     None
# Outputs:
#     branch information
########################################
function push_refs() {
    # delete all local tags
    git tag | xargs git tag -d

    color blue "show all branches"
    git branch --all

    # fetch all branches and tags from origin
    git_retry fetch origin
    if [[ $? -ne 0 ]]; then
        color red "failed to fetch remote (origin) refs"

        exit 1
    fi

    color blue "checkout local branch from remote branch"
    git branch --remotes --list "origin/*" | sed 's|[ \t]||g' | grep -v "HEAD" | xargs -I {} git checkout --track {}

    color blue "push all branches"
    git_retry push -u target -f --all
    if [[ $? -ne 0 ]]; then
        color red "failed to push branches to remote (target)"

        exit 1
    fi

    color blue "push all tags"
    git_retry push -u target -f --tags
    if [[ $? -ne 0 ]]; then
        color red "failed to push tags to remote (target)"

        exit 1
    fi
}
