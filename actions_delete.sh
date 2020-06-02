#!/bin/sh
#
# GitHubEventName: DELETE
# Author: ttionya <git@ttionya.com>

echo "=============== DELETE ==============="

mkdir -p /tmp/
git ls-remote origin | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/originBranch.txt
echo "originBranch.txt"
cat /tmp/originBranch.txt
git ls-remote target | awk -F' ' '{ print $2 }' | grep -E '^refs' | grep -Ev '\^\{}$' | sort > /tmp/targetBranch.txt
echo "targetBranch.txt"
cat /tmp/targetBranch.txt

grep -Fvf /tmp/originBranch.txt /tmp/targetBranch.txt | xargs -I {} git push target -f --delete {}
