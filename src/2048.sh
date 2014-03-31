#!/usr/bin/env bash

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HIGH_SCORE_FILE="${THIS_DIR}/../.highscore"

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
    sed -E -u -e "
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
    sed -E -n -u -f "${THIS_DIR}/lib/2048.sed"
}

function normalize_high_score() {
    if [ -e "${HIGH_SCORE_FILE}" ]
    then
        sed -i -n -e '$p' "${HIGH_SCORE_FILE}"
    else
        echo "0" > "${HIGH_SCORE_FILE}"
    fi
}

function high_score() {
    awk -v high="$(cat "${HIGH_SCORE_FILE}" 2> /dev/null || echo 0)" '
        /^Score:/{
            score = int(substr($0, match($0, /[0-9]+/)))

            if (score > high) {
                print score > "'"${HIGH_SCORE_FILE}"'"
                close("'"${HIGH_SCORE_FILE}"'")
                high = score
            }

            $0=$0"\n High: "high
        }
        {
            print $0
            fflush()
        }'
}

function define_colors() {
    # https://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash
    txtblk='\e[0;30m' # Black - Regular
    txtred='\e[0;31m' # Red
    txtgrn='\e[0;32m' # Green
    txtylw='\e[0;33m' # Yellow
    txtblu='\e[0;34m' # Blue
    txtpur='\e[0;35m' # Purple
    txtcyn='\e[0;36m' # Cyan
    txtwht='\e[0;37m' # White
    bldblk='\e[1;30m' # Black - Bold
    bldred='\e[1;31m' # Red
    bldgrn='\e[1;32m' # Green
    bldylw='\e[1;33m' # Yellow
    bldblu='\e[1;34m' # Blue
    bldpur='\e[1;35m' # Purple
    bldcyn='\e[1;36m' # Cyan
    bldwht='\e[1;37m' # White
    undblk='\e[4;30m' # Black - Underline
    undred='\e[4;31m' # Red
    undgrn='\e[4;32m' # Green
    undylw='\e[4;33m' # Yellow
    undblu='\e[4;34m' # Blue
    undpur='\e[4;35m' # Purple
    undcyn='\e[4;36m' # Cyan
    undwht='\e[4;37m' # White
    bakblk='\e[40m' # Black - Background
    bakred='\e[41m' # Red
    bakgrn='\e[42m' # Green
    bakylw='\e[43m' # Yellow
    bakblu='\e[44m' # Blue
    bakpur='\e[45m' # Purple
    bakcyn='\e[46m' # Cyan
    bakwht='\e[47m' # White
    txtrst='\e[0m' # Text Reset

    clr_divi="${bldblk}&${txtrst}"
    clr_none="${undwht}${bldblk}&${txtrst}"
    clr_0002="${undwht}${bldblk}&${txtrst}"
    clr_0004="${txtwht}${undwht}&${txtrst}"
    clr_0008="${txtgrn}${undgrn}&${txtrst}"
    clr_0016="${txtpur}${undpur}&${txtrst}"
    clr_0032="${txtcyn}${undcyn}&${txtrst}"
    clr_0064="${txtylw}${undylw}&${txtrst}"
    clr_0128="${bldwht}${bakred}${undwht}&${txtrst}"
    clr_0256="${bldwht}${bakblu}${undwht}&${txtrst}"
    clr_0512="${bldwht}${bakpur}${undwht}&${txtrst}"
    clr_1024="${txtblk}${bakgrn}${undblk}&${txtrst}"
    clr_2048="${txtblk}${bakcyn}${undblk}&${txtrst}"
    clr_4096="${txtblk}${bakylw}${undblk}&${txtrst}"
}

function colorize() {
    sed -E -u -e "
        /^ _/{
            s/_+/$(printf "${bldblk}")&$(printf "${txtrst}")/
            b
        }
        /^\|/{
            s/\|/$(printf "${clr_divi}")/g
            s/____/$(printf "${clr_none}")/g
            s/.__2/$(printf "${clr_0002}")/g
            s/.__4/$(printf "${clr_0004}")/g
            s/___8/$(printf "${clr_0008}")/g
            s/__16/$(printf "${clr_0016}")/g
            s/__32/$(printf "${clr_0032}")/g
            s/__64/$(printf "${clr_0064}")/g
            s/_128/$(printf "${clr_0128}")/g
            s/_256/$(printf "${clr_0256}")/g
            s/_512/$(printf "${clr_0512}")/g
            s/1024/$(printf "${clr_1024}")/g
            s/2048/$(printf "${clr_2048}")/g
            s/4096/$(printf "${clr_4096}")/g
            s/_/ /g
        }
        /High:/{
            s/.*/$(printf "${clr_divi}")/
        }"
}

function print_help_and_exit() {
    {
        echo "$(basename "$0") [--color] [--no-color] [--help]"
        echo
        echo "--color       Colorize the board."
        echo "--no-color    Do not colorize the board (default)."
        echo "--help        Print this help."
    } 2>&1

    exit 1
}

function main() {
    local color=1

    for arg in "$@"
    do
        if [ "${arg}" == "--color" ]
        then
            color=1
        elif [ "${arg}" == "--no-color" ]
        then
            color=0
        else
            print_help_and_exit
        fi
    done

    if [ "${color}" -eq 1 ]
    then
        define_colors
    else
        function colorize() {
            cat
        }
    fi

    echo
    echo " ___________________| 2048.sed |___________________ "
    echo "|                                                  |"
    echo "| Use the W/A/S/D keys to play and CTRL+C to quit. |"
    echo "|__________________________________________________|"
    echo

    # Play!
    gather_input | sed_2048 | high_score | colorize
}


if [ "${BASH_SOURCE}" == "$0" ]
then
    main "$@"
fi
