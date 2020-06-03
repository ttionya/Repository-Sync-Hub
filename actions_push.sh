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
