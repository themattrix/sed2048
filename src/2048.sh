#!/bin/bash

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function get_random() {
    echo "$(($RANDOM % 16))"
}

function gather_input() {
    # Read one key from the user and convert that to an arrow key. Also
    # output a random number (0-15) next to the chosen key. Ignore other
    # inputs.
    while true
    do
        read -s -n 1 key
        
        case "${key}" in
            w) arrow=U;;
            a) arrow=L;;
            s) arrow=D;;
            d) arrow=R;;
            *) arrow=;;
        esac
        
        [ -n "${arrow}" ] && echo "${arrow} $(get_random)"
    done
}

function sed_2048() {
    "${THIS_DIR}/lib/2048.sed"
}

gather_input | sed_2048
