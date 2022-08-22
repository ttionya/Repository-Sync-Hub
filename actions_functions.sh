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
# Command with retry.
# Arguments:
#     command options
# Returns:
#     command return code
# Outputs:
#     command output
########################################
function retry() {
    local RETRY_COUNT=3
    local RETRY_DELAY=2
    local COUNT=0
    local RETURN_CODE=0

    while [[ "${COUNT}" -lt "${RETRY_COUNT}" ]]; do
        $*
        RETURN_CODE=$?

        if [[ "${RETURN_CODE}" -eq 0 ]]; then
            break
        fi

        ((COUNT++))

        if [[ "${COUNT}" -eq "${RETRY_COUNT}" ]]; then
            color yellow "retried ${RETRY_COUNT} times, no more retries left" 1>&2
        else
            color yellow "retry after ${RETRY_DELAY} seconds" 1>&2

            sleep "${RETRY_DELAY}"
        fi
    done

    return "${RETURN_CODE}"
}

export -f retry
