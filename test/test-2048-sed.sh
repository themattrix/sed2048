#!/usr/bin/env bash

#
# Tests
#

function test_merge_right() {
    diff_board <({
            echo ":bbbb:bbbb:bbbb:bbbb"
            echo "R 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|___8|___8|"
            echo "|____|____|___8|___8|"
            echo "|____|____|___8|___8|"
            echo "|____|____|___8|___8|"
        )
}

function test_merge_left() {
    diff_board <({
            echo ":bbbb:bbbb:bbbb:bbbb"
            echo "L 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___8|___8|>__2|____|"
            echo "|___8|___8|____|____|"
            echo "|___8|___8|____|____|"
            echo "|___8|___8|____|____|"
        )
}

function test_merge_up() {
    diff_board <({
            echo ":bbbb:bbbb:bbbb:bbbb"
            echo "U 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___8|___8|___8|___8|"
            echo "|___8|___8|___8|___8|"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
        )
}

function test_merge_down() {
    diff_board <({
            echo ":bbbb:bbbb:bbbb:bbbb"
            echo "D 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___8|___8|___8|___8|"
            echo "|___8|___8|___8|___8|"
        )
}

function test_merge_right_weighted_right() {
    diff_board <({
            echo ":-bbb:----:----:----"
            echo "R 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|___4|___8|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
        )
}

function test_merge_left_weighted_left() {
    diff_board <({
            echo ":-bbb:----:----:----"
            echo "L 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___8|___4|>__2|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
        )
}

function test_merge_up_weighted_up() {
    diff_board <({
            echo ":---b:---b:---b:----"
            echo "U 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|____|___8|"
            echo "|____|____|____|___4|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
        )
}

function test_merge_down_weighted_down() {
    diff_board <({
            echo ":----:---b:---b:---b"
            echo "D 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|___4|"
            echo "|____|____|____|___8|"
        )
}

function test_populate_cell_1() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 1,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__${value}|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_2() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 2,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|>__${value}|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_3() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 3,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|>__${value}|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_4() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 4,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|>__${value}|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_5() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 5,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|>__${value}|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_6() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 6,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|>__${value}|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_7() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 7,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|>__${value}|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_8() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 8,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__${value}|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_9() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 9,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|>__${value}|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_10() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 10,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|>__${value}|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_11() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 11,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|>__${value}|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_12() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 12,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__${value}|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_12_after() {
    local value="${1}"

    diff_board <({
            echo ":---a:----:----:----"
            echo "L 12,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|>__${value}|____|____|____|"
        )
}

function test_populate_cell_13_after() {
    local value="${1}"

    diff_board <({
            echo ":---a:----:----:----"
            echo "L 13,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|>__${value}|____|____|"
        )
}

function test_populate_cell_14_after() {
    local value="${1}"

    diff_board <({
            echo ":---a:----:----:----"
            echo "L 14,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|>__${value}|____|"
        )
}

function test_populate_cell_15_after() {
    local value="${1}"

    diff_board <({
            echo ":---a:----:----:----"
            echo "L 15,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__${value}|"
        )
}

function test_populate_cell_16_mod_15() {
    local value="${1}"

    diff_board <({
            echo ":----:----:----:---a"
            echo "L 16,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__${value}|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_populate_cell_16_mod_1() {
    local value="${1}"

    diff_board <({
            echo ":-bcd:efgh:abcd:efgh"
            echo "L 16,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___4|___8|__16|>__${value}|"
            echo "|__32|__64|_128|_256|"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|_256|"
        )
}

function test_populate_cell_10_mod_4() {
    local value="${1}"

    diff_board <({
            echo ":-bcd:-efg:-bcd:-efg"
            echo "L 10,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___4|___8|__16|____|"
            echo "|__32|__64|_128|>__${value}|"
            echo "|___4|___8|__16|____|"
            echo "|__32|__64|_128|____|"
        )
}

function test_populate_cell_13_mod_3() {
    local value="${1}"

    diff_board <({
            echo ":-bcd:-efg:-bcd:efgh"
            echo "L 13,${value}"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___4|___8|__16|>__${value}|"
            echo "|__32|__64|_128|____|"
            echo "|___4|___8|__16|____|"
            echo "|__32|__64|_128|_256|"
        )
}

function test_game_to_4096() {
    # -abc
    # k--d
    # j--e
    # ihgf
    diff_board <({
            echo ":-abc:k--d:j--e:ihgf"
            echo "R 1,2"
            echo "R 1,2"
            echo "R 1,2"
            echo "R 1,2"
            echo "D 1,2"
            echo "D 1,2"
            echo "D 1,2"
            echo "L 1,2"
            echo "L 1,2"
            echo "L 1,2"
            echo "R 1,2"
            echo "U 1,2"
            echo "U 1,2"
        } | sed_2048
        ) <(
            echo " ___________________"
            echo "|____|___2|___4|___8|"
            echo "|2048|____|____|__16|"
            echo "|1024|____|____|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 0"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|___2|___4|___8|"
            echo "|____|____|2048|__16|"
            echo "|____|____|1024|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 0"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|___4|___4|___8|"
            echo "|____|____|2048|__16|"
            echo "|____|____|1024|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 4"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|___2|___8|___8|"
            echo "|____|____|2048|__16|"
            echo "|____|____|1024|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 12"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|____|___4|__16|"
            echo "|____|____|2048|__16|"
            echo "|____|____|1024|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 32"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|____|___4|____|"
            echo "|____|____|2048|__32|"
            echo "|___2|____|1024|__32|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 64"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|____|___4|____|"
            echo "|____|____|2048|____|"
            echo "|___4|____|1024|__64|"
            echo "|_512|_256|_128|__64|"
            echo
            echo "Score: 132"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|____|___4|____|"
            echo "|___2|____|2048|____|"
            echo "|___4|____|1024|____|"
            echo "|_512|_256|_128|_128|"
            echo
            echo "Score: 260"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|___2|___4|>__2|____|"
            echo "|___2|2048|____|____|"
            echo "|___4|1024|____|____|"
            echo "|_512|_256|_256|____|"
            echo
            echo "Score: 516"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|___2|___4|___2|>__2|"
            echo "|___2|2048|____|____|"
            echo "|___4|1024|____|____|"
            echo "|_512|_512|____|____|"
            echo
            echo "Score: 1028"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|___2|___4|___4|>__2|"
            echo "|___2|2048|____|____|"
            echo "|___4|1024|____|____|"
            echo "|1024|____|____|____|"
            echo
            echo "Score: 2056"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|>__2|___2|___8|___2|"
            echo "|____|____|___2|2048|"
            echo "|____|____|___4|1024|"
            echo "|____|____|____|1024|"
            echo
            echo "Score: 2064"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|___2|___2|___8|___2|"
            echo "|>__2|____|___2|2048|"
            echo "|____|____|___4|2048|"
            echo "|____|____|____|____|"
            echo
            echo "Score: 4112"
            echo
            echo "You win!"
            echo
            echo " ___________________"
            echo "|___4|___2|___8|___2|"
            echo "|>__2|____|___2|4096|"
            echo "|____|____|___4|____|"
            echo "|____|____|____|____|"
            echo
            echo "Score: 8212"
            echo
            echo "You win!"
            echo
        )
}

function test_win() {
    diff_board <({
            echo ":----:----:---j:---j"
            echo "U 1,2"
        } | sed_2048
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|1024|"
            echo "|____|____|____|1024|"
            echo
            echo "Score: 0"
            echo
            echo " ___________________"
            echo "|>__2|____|____|2048|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo
            echo "Score: 2048"
            echo
            echo "You win!"
            echo
        )
}

function test_game_over() {
    diff_board <({
            echo ":abcd:efgh:abcd:efgh"
            echo "L 1,2"
        } | sed_2048
        ) <(
            echo " ___________________"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|_256|"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|_256|"
            echo
            echo "Score: 0"
            echo
            echo "No more moves! Game over."
        )
}

function test_game_over_checkerboard() {
    diff_board <({
            echo ":abab:baba:abab:baba"
            echo "L 1,2"
        } | sed_2048
        ) <(
            echo " ___________________"
            echo "|___2|___4|___2|___4|"
            echo "|___4|___2|___4|___2|"
            echo "|___2|___4|___2|___4|"
            echo "|___4|___2|___4|___2|"
            echo
            echo "Score: 0"
            echo
            echo "No more moves! Game over."
        )
}

function test_win_and_game_over() {
    diff_board <({
            echo ":abcd:efgh:abcd:efgk"
            echo "L 1,2"
        } | sed_2048
        ) <(
            echo " ___________________"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|_256|"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|2048|"
            echo
            echo "Score: 0"
            echo
            echo "You win!"
            echo
            echo "No more moves! Game over."
        )
}

function test_no_new_tile_on_no_board_change_right() {
    diff_board <({
            echo ":---a:---a:---a:---a"
            echo "R 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|___2|"
            echo "|____|____|____|___2|"
            echo "|____|____|____|___2|"
            echo "|____|____|____|___2|"
        )
}

function test_no_new_tile_on_no_board_change_left() {
    diff_board <({
            echo ":a---:a---:a---:a---"
            echo "L 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|___2|____|____|____|"
            echo "|___2|____|____|____|"
            echo "|___2|____|____|____|"
        )
}

function test_no_new_tile_on_no_board_change_up() {
    diff_board <({
            echo ":aaaa:----:----:----"
            echo "U 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|___2|___2|___2|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
        )
}

function test_no_new_tile_on_no_board_change_down() {
    diff_board <({
            echo ":----:----:----:aaaa"
            echo "D 1,2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|___2|___2|___2|"
        )
}

#
# Test helpers
#

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function sed_2048() {
    "${THIS_DIR}/../src/lib/2048.sed"
}

function last_board() {
    grep "^[| ]" | tail -n 5
}

function diff_board() {
    diff -y "$@"
}

function run() {
    test_fn="$1"
    shift
    args=("$@")

    output=$("${test_fn}" "${args[@]}" 2>&1)
    status=$?

    ((test_count++))

    if [ ${status} -eq 0 ]
    then
        echo "[pass] ${test_fn}" "${args[@]}"
    else
        ((fail_count++))

        echo "[FAIL] ${test_fn}:"
        sed 's/^/    /' <<< "${output}"
        echo
    fi
}

function test_summary() {
    echo
    if [ ${fail_count} -eq 0 ]
    then
        echo ">>> success (${test_count} tests)"
    else
        echo ">>> FAILURE (${fail_count}/${test_count} tests failed)"
        exit 1
    fi
}


#
# Test runner
#

test_count=0
fail_count=0

run test_merge_right
run test_merge_left
run test_merge_up
run test_merge_down
run test_merge_right_weighted_right
run test_merge_left_weighted_left
run test_merge_up_weighted_up
run test_merge_down_weighted_down
run test_game_to_4096
run test_win
run test_game_over
run test_game_over_checkerboard
run test_win_and_game_over
run test_no_new_tile_on_no_board_change_right
run test_no_new_tile_on_no_board_change_left
run test_no_new_tile_on_no_board_change_up
run test_no_new_tile_on_no_board_change_down

for v in 2 4
do
    run test_populate_cell_1 "${v}"
    run test_populate_cell_2 "${v}"
    run test_populate_cell_3 "${v}"
    run test_populate_cell_4 "${v}"
    run test_populate_cell_5 "${v}"
    run test_populate_cell_6 "${v}"
    run test_populate_cell_7 "${v}"
    run test_populate_cell_8 "${v}"
    run test_populate_cell_9 "${v}"
    run test_populate_cell_10 "${v}"
    run test_populate_cell_11 "${v}"
    run test_populate_cell_12 "${v}"
    run test_populate_cell_12_after "${v}"
    run test_populate_cell_13_after "${v}"
    run test_populate_cell_14_after "${v}"
    run test_populate_cell_15_after "${v}"
    run test_populate_cell_16_mod_15 "${v}"
    run test_populate_cell_16_mod_1 "${v}"
    run test_populate_cell_10_mod_4 "${v}"
    run test_populate_cell_13_mod_3 "${v}"
done

test_summary
