#!/bin/bash

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SED_2048="${THIS_DIR}/lib/2048.sed"

function get_random() {
    echo "$(($RANDOM % 16))"
}

function gather_input() {
    # Read one key from the user and convert that to an arrow key. Also
    # output a random number (0-15) next to the chosen key. Ignore other
    # inputs.
    while true; do
        read -s -n 1 key
        unset arrow
        
        case "${key}" in
            w) arrow=U;;
            a) arrow=L;;
            s) arrow=D;;
            d) arrow=R;;
        esac
        
        if [ -n "${arrow}" ]; then
            echo "${arrow} $(get_random)"
        fi
    done
}

gather_input | "${SED_2048}"
