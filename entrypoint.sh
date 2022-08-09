#!/bin/sh
#
# Docker entrypoint.sh
# Author: ttionya <git@ttionya.com>

. /app/actions_functions.sh
. /app/actions_push.sh
. /app/actions_delete.sh

TARGET_REPOSITORY="${INPUT_TARGET_REPOSITORY}"

#################### Function ####################
########################################
# Check target repository URL type.
# Arguments:
#     None
########################################
function check_target_repository() {
    local TARGET_REPOSITORY_HTTP_URL_MATCHED="$(echo "${TARGET_REPOSITORY}" | grep -E '^http(s?)://')"

    if [[ -n "${TARGET_REPOSITORY_HTTP_URL_MATCHED}" ]]; then
        # HTTP URL
        color blue "use HTTP URL"
        configure_token
    else
        # SSH URL
        color blue "use SSH URL"
        configure_ssh
    fi
}

########################################
# Configure access token.
# Arguments:
#     None
########################################
function configure_token() {
    git config --global credential.helper store

    local TARGET_REPOSITORY_PROTOCOL="$(echo "${TARGET_REPOSITORY}" | grep -oE '^http(s?)://')"
    local TARGET_REPOSITORY_HOST="$(echo "${TARGET_REPOSITORY}" | sed -r "s|${TARGET_REPOSITORY_PROTOCOL}||" | awk -F'/' '{ print $1 }')"

    color yellow "TARGET_REPOSITORY_PROTOCOL: ${TARGET_REPOSITORY_PROTOCOL}"
    color yellow "TARGET_REPOSITORY_HOST: ${TARGET_REPOSITORY_HOST}"

    echo "${TARGET_REPOSITORY_PROTOCOL}${INPUT_HTTP_ACCESS_NAME}:${INPUT_HTTP_ACCESS_TOKEN}@${TARGET_REPOSITORY_HOST}" > ~/.git-credentials
}

########################################
# Configure SSH.
# Arguments:
#     None
# Outputs:
#     SSH test message
########################################
function configure_ssh() {
    # configure known_hosts
    local TARGET_REPOSITORY_HOST="$(echo "${TARGET_REPOSITORY}" | sed -r 's|(.*@)?(.*):.*|\2|')"
    color yellow "TARGET_REPOSITORY_HOST: ${TARGET_REPOSITORY_HOST}"

    # ~ is /github/home/, not /root/
    mkdir -p /root/.ssh
    ssh-keyscan "${TARGET_REPOSITORY_HOST}" > /root/.ssh/known_hosts
    chmod 644 /root/.ssh/known_hosts

    # configure SSH private key
    if [[ -n "${INPUT_SSH_PRIVATE_KEY}" ]]; then
        color blue "find SSH private key"

        eval $(ssh-agent -s)
        echo "${INPUT_SSH_PRIVATE_KEY}" | tr -d '\r' | ssh-add - > /dev/null
    fi

    # test SSH connection
    local SSH_TEST_URL="$(echo "${TARGET_REPOSITORY}" | awk -F':' '{ print $1 }')"
    color yellow "SSH_TEST_URL: ${SSH_TEST_URL}"
    # Do not judge the exit code here, known github.com will return an error even if the connection is successful.
    ssh -T "${SSH_TEST_URL}"
}

########################################
# Configure Git remote information.
# Arguments:
#     None
# Outputs:
#     Git remote list
########################################
function configure_git_remote() {
    git remote add target "${TARGET_REPOSITORY}"
    git remote -v
}

########################################
# Configure Git safe directory.
# Arguments:
#     None
# Outputs:
#     None
########################################
function configure_git_safe_directory() {
    git config --global --add safe.directory "${GITHUB_WORKSPACE}"
}

########################################
# Display some variables.
# Arguments:
#     None
# Outputs:
#     variables value
########################################
function display_variables() {
    color yellow "========================================"
    color yellow "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"
    color yellow "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
    color yellow "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
    color yellow "GITHUB_SHA: ${GITHUB_SHA}"
    color yellow "GITHUB_REF: ${GITHUB_REF}"
    color yellow "GITHUB_WORKSPACE: ${GITHUB_WORKSPACE}"

    color yellow "TARGET_REPOSITORY: ${TARGET_REPOSITORY}"
    color yellow "CURRENT_DIR: $(pwd)"
    color yellow "WHOAMI: $(whoami)"
    color yellow "========================================"
}

#################### Actions ####################
check_target_repository
display_variables

configure_git_safe_directory
configure_git_remote

case "${GITHUB_EVENT_NAME}" in
    push)
        color blue "=============== PUSH ==============="

        push_current_ref
        ;;
    delete)
        color blue "=============== DELETE ==============="

        delete_refs
        ;;
    schedule)
        color blue "=============== SCHEDULE ==============="

        delete_refs
        push_refs
        ;;
    *)
        ;;
esac
