#!/bin/sh
#
# GitHubEventName: PUSH
# Author: ttionya <git@ttionya.com>

REF="$1"

echo "=============== PUSH ==============="

git push target "${REF}:${REF}" -f --tags
