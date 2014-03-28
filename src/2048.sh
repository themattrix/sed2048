#!/usr/bin/env bash

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function get_random_cell() {
    local range=$1
    echo "$(($RANDOM % $range + 1))"
}

function get_random_cell_value() {
    # 90% chance of spawning a "2"
    # 10% chance of spawning a "4"
    echo "$(($RANDOM % 10 == 0 ? 4 : 2))"
}

function initial_board() {
    sed -E -e "
        s/-/$(get_random_cell_value)/$(get_random_cell 16)
        s/-/$(get_random_cell_value)/$(get_random_cell 15)
        y/24/ab/
    " <<< ":----:----:----:----"
}

function gather_input() {
    # Read one key from the user and convert that to an arrow key. Also
    # output a random number (0-15) next to the chosen key. Ignore other
    # inputs.
    echo "$(initial_board)"

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
        
        if [ -n "${arrow}" ]
        then
            echo "${arrow} $(get_random_cell 16),$(get_random_cell_value)"
        fi
    done
}

function sed_2048() {
    "${THIS_DIR}/lib/2048.sed"
}

echo
echo " ___________________| 2048.sed |___________________ "
echo "|                                                  |"
echo "| Use the W/A/S/D keys to play and CTRL+C to quit. |"
echo "|__________________________________________________|"
echo

gather_input | sed_2048
