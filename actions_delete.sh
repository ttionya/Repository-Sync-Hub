#!/bin/sh
#
# Delete functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Delete branches and tags that is deleted.
# Arguments:
#     None
# Outputs:
#     remote branches and tags
########################################
function delete_refs() {
    mkdir -p /tmp/

    git ls-remote origin | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/originBranches.txt
    color blue "origin branch list"
    cat /tmp/originBranches.txt

    git ls-remote target | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/targetBranches.txt
    color blue "target branch list"
    cat /tmp/targetBranches.txt

    grep -Fvf /tmp/originBranches.txt /tmp/targetBranches.txt | xargs -I {} git push target -f --delete {}
}
