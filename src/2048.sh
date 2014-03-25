#!/usr/bin/env bash

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function get_random() {
    local range=$1
    echo "$(($RANDOM % $range + 1))"
}

function initial_board() {
    sed -r \
        -e "s/-/a/$(get_random 16)" \
        -e "s/-/a/$(get_random 15)" \
        <<< ":----:----:----:----"
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
            echo "${arrow} $(get_random 16)"
        fi
    done
}

function sed_2048() {
    "${THIS_DIR}/lib/2048.sed"
}

function print_score() {
    awk -F'[_|>]+' '
        /^ _/{
            // Start board
            score = 0
        }
        /^\|/{
            // Board row
            score += $2 + $3 + $4 + $5
        }
        /^$/{
            // End board
            print "\nScore: "score
        }
        {
            // Any line
            print $0
        }'
}

echo
echo " ___________________| 2048.sed |___________________ "
echo "|                                                  |"
echo "| Use the W/A/S/D keys to play and CTRL+C to quit. |"
echo "|__________________________________________________|"
echo

gather_input | sed_2048 | print_score
