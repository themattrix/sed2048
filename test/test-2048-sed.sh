#!/bin/bash

#
# Tests
#

function test_populate_cell_1() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 1"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_2() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 2"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|>__2|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_3() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 3"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|>__2|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_4() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 4"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|>__2|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_5() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 5"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_8() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 8"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__2|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_9() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 9"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|>__2|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_12() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 12"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__2|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_12_after() {
    diff_board <({
            echo ":---a:----:----:----"
            echo "L 12"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|>__2|____|____|____|"
            echo
        )
}

function test_populate_cell_15() {
    diff_board <({
            echo ":---a:----:----:----"
            echo "L 15"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|>__2|"
            echo
        )
}

function test_populate_cell_16_wrap_1() {
    diff_board <({
            echo ":----:----:----:---a"
            echo "L 16"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|>__2|____|____|____|"
            echo "|____|____|____|____|"
            echo "|____|____|____|____|"
            echo "|___2|____|____|____|"
            echo
        )
}

function test_populate_cell_16_wrap_4() {
    diff_board <({
            echo ":-bcd:efgh:abcd:efgh"
            echo "L 16"
        } | sed_2048 | last_board
        ) <(
            echo " ___________________"
            echo "|___4|___8|__16|>__2|"
            echo "|__32|__64|_128|_256|"
            echo "|___2|___4|___8|__16|"
            echo "|__32|__64|_128|_256|"
            echo
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
    tail -n 6
}

function diff_board() {
    diff -y --width=60 "$@"
}

function run() {
    test_fn="$1"

    output=$("${test_fn}" 2>&1)
    status=$?

    ((test_count++))

    if [ ${status} -eq 0 ]
    then
        echo "[pass] ${test_fn}"
    else
        ((fail_count++))

        echo "[FAIL] ${test_fn}:"
        sed 's/^/    /' <<< "${output}"
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

run test_populate_cell_1
run test_populate_cell_2
run test_populate_cell_3
run test_populate_cell_4
run test_populate_cell_5
run test_populate_cell_8
run test_populate_cell_9
run test_populate_cell_12
run test_populate_cell_12_after
run test_populate_cell_15
run test_populate_cell_16_wrap_1
run test_populate_cell_16_wrap_4

test_summary
