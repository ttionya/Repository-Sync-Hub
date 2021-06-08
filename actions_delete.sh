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
    mkdir -p /tmp/

    git ls-remote --refs --heads --tags origin | awk -F' ' '{ print $2 }' | sort > /tmp/originBranches.txt
    if [[ $? != 0 ]]; then
        color red "failed to fetch remote (origin) refs"

        exit 1
    fi
    color blue "origin branch list"
    cat /tmp/originBranches.txt

    git ls-remote --refs --heads --tags target | awk -F' ' '{ print $2 }' | sort > /tmp/targetBranches.txt
    if [[ $? != 0 ]]; then
        color red "failed to fetch remote (target) refs"

        exit 1
    fi
    color blue "target branch list"
    cat /tmp/targetBranches.txt

    grep -Fvxf /tmp/originBranches.txt /tmp/targetBranches.txt | xargs -I {} git push target -f --delete {}
}
