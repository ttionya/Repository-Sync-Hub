#!/bin/bash
#
# Common functions
#
# Author: ttionya <git@ttionya.com>

#################### Function ####################
########################################
# Print colorful message.
# Arguments:
#     color
#     message
# Outputs:
#     colorful message
########################################
function color() {
    case $1 in
        red)     echo -e "\033[31m$2\033[0m" ;;
        green)   echo -e "\033[32m$2\033[0m" ;;
        yellow)  echo -e "\033[33m$2\033[0m" ;;
        blue)    echo -e "\033[34m$2\033[0m" ;;
        none)    echo "$2" ;;
    esac
}

export -f color

########################################
# Command git with retry.
# Arguments:
#     git command options
# Returns:
#     command return code
# Outputs:
#     git command output
########################################
function git_retry() {
    local RETRY_COUNT=3
    local RETRY_DELAY=2
    local COUNT=0
    local RETURN_CODE=0

    while [[ "${COUNT}" -lt "${RETRY_COUNT}" ]]; do
        if [[ "${COUNT}" -gt 0 ]]; then
            color yellow "retry after ${RETRY_DELAY} seconds" 1>&2
            sleep "${RETRY_DELAY}"
        fi

        git $*
        RETURN_CODE=$?

        if [[ "${RETURN_CODE}" -eq 0 ]]; then
            break
        fi

        ((COUNT++))
    done

    return "${RETURN_CODE}"
}

export -f git_retry

########################################
# Command ssh-keyscan with retry.
# Arguments:
#     ssh-keyscan command options
# Returns:
#     command return code
# Outputs:
#     ssh-keyscan command output
########################################
function ssh_keyscan_retry() {
    local RETRY_COUNT=5
    local RETRY_DELAY=1
    local COUNT=0
    local RETURN_CODE=0

    while [[ "${COUNT}" -lt "${RETRY_COUNT}" ]]; do
        if [[ "${COUNT}" -gt 0 ]]; then
            color yellow "retry after ${RETRY_DELAY} second" 1>&2
            sleep "${RETRY_DELAY}"
        fi

        ssh-keyscan $*
        RETURN_CODE=$?

        if [[ "${RETURN_CODE}" -eq 0 ]]; then
            break
        fi

        ((COUNT++))
    done

    return "${RETURN_CODE}"
}
