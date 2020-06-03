#!/bin/sh
#
# Push functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Push current branch to remote.
# Arguments:
#     None
########################################
function push_current_branch() {
    git push target "${GITHUB_REF}:${GITHUB_REF}" -f --tags
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
    git fetch origin

    color blue "checkout local branch from remote branch"
    git branch -r --list "origin/*" | sed 's|[ \t]||g' | grep -v HEAD | xargs -I {} git checkout --track {}

    color blue "push all branches"
    git push -u target -f --all

    color blue "push all tags"
    git push -u target -f --tags
}
