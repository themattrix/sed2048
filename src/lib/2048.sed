#!/bin/sed -rnf

:initial-board

    # The very first input line is the initial board. Let's output it.
    /:/b output


:next

    # This is *not* the initial board, so the hold buffer is expected to
    # contain the previous state of the board. Append the hold buffer to
    # the pattern buffer so that we can use the existing board with the
    # new key-press.
    G
    s/\n//


:check-if-game-is-over

    # The game is over when no more moves are possible. The simplest
    # way to check this is to perform a trial run through verical and
    # horizontal merges.

    #
    # In a dry-run.
    #

    # Already in a horizontal dry-run, which means no cells were merged.
    # Let's try a vertical dry-run instead.
    /^Ld/{
        s/^./D/
        b rotate-forward-if-necessary
    }

    # Already in a vertical dry-run, which means no cells were merged.
    # There are no moves left! Game over!
    /^Dd/b game-over

    #
    # Not in a dry-run.
    #

    # There's at least one cell open - continue!
    /-/b game-not-over

    # No cells available, let's see if a horizontal move is possible.
    # Set the "dry-run" flag (d).
    s/^(.)/Ld \1/
    b merge


:game-over

    # Aw, set a flag to indicate the game being over.
    s/$/ z/
    b output


:game-not-over

    # Yay! Let's continue!


:rotate-forward-if-necessary

    # If left or right was pressed, merge blocks without rotating.
    /^[LR]/b merge

    # Clockwise rotation:
    #
    #    abcd => miea
    #    efgh => njfb
    #    ijkl => okgc
    #    mnop => plhd
    #
    #    When expressed linearly:
    #
    #    abcd efgh ijkl mnop
    #    4    3    2    1    => miea
    #     4    3    2    1   => njfb
    #      4    3    2    1  => okgc
    #       4    3    2    1 => plhd

    # Generate the new order and place it after the existing order.
    s/:(.)...:(.)...:(.)...:(.).../& \4\3\2\1:/
    s/:.(.)..:.(.)..:.(.)..:.(.).. .*/&\4\3\2\1:/
    s/:..(.).:..(.).:..(.).:..(.). .*/&\4\3\2\1:/
    s/:...(.):...(.):...(.):...(.) .*/&\4\3\2\1/

    s/:....:....:....:.... /:/


:merge
    
    # Collapse spaces.
    s/-//g

    # Jump to next line to clear conditional jump state.
    t try-merge

    # Merge cells. We merge them in high-to-low order so that four
    # "2" cells become two "4" cells and not a single "8" cell.
    :try-merge

        s/kk/l/g
        s/jj/k/g
        s/ii/j/g
        s/hh/i/g
        s/gg/h/g
        s/ff/g/g
        s/ee/f/g
        s/dd/e/g
        s/cc/d/g
        s/bb/c/g
        s/aa/b/g

    # If this is a dry run...
    /^.d /{
        # ...and a merge was made, end the dry-run.
        t end-dry-run

        # Otherwise, restore the board state from the hold buffer...
        G
        s/:.*\n//

        # ...and check again to see if the game is over.
        b check-if-game-is-over

        :end-dry-run

            # Dry run done! Remove the dry-run flag.
            s/^.d //
            
            # Restore the board state from the hold buffer.
            G
            s/:.*\n//
            
            # Continue game :)
            b game-not-over
    }


:pad

    # If right (or a rotated up), pad left. Otherwise, pad right.
    /^[RU]/b pad-left


:pad-right

    # Add an extra four dashes to the right of the line, then trim the
    # line to the left-most four characters.
    s/(:[^:]*)/\1----/g
    s/(:....)[^:]*/\1/g
    b rotate-backwards-if-necessary


:pad-left

    # Add an extra four dashes to the left of the line, then trim the
    # line to the right-most four characters.
    s/:([^:]*)/:----\1/g
    s/[^:]*(....)(:|$)/\1\2/g
    b rotate-backwards-if-necessary


:rotate-backwards-if-necessary

    # Don't rotate back if we didn't rotate in the first place.
    /^[LR]/b populate-empty-tile-if-necessary

    # Counter-clockwise rotation:
    #
    #    abcd => dhlp
    #    efgh => cgko
    #    ijkl => bfjn
    #    mnop => aeim
    #
    #    When expressed linearly:
    #
    #    abcd efgh ijkl mnop
    #       1    2    3    4 => dhlp
    #      1    2    3    4  => cgko
    #     1    2    3    4   => bfjn
    #    1    2    3    4    => aeim

    # Generate the new order and place it after the existing order.
    s/:...(.):...(.):...(.):...(.)/& \1\2\3\4:/
    s/:..(.).:..(.).:..(.).:..(.). .*/&\1\2\3\4:/
    s/:.(.)..:.(.)..:.(.)..:.(.).. .*/&\1\2\3\4:/
    s/:(.)...:(.)...:(.)...:(.)... .*/&\1\2\3\4/

    s/:....:....:....:.... /:/


:populate-empty-tile-if-necessary

    # An empty tile should be populated if the state of the board before
    # the move is different than the state of the board after the move.
    #
    # This is easy to check, since *before* state is still in the hold
    # buffer. To compare, we'll simply append the hold buffer to the
    # pattern buffer and see if the pattern buffer appears twice.
    
    # Append *before* state to *after* state (separated by a newline).
    G

    /((:....){4})\n\1/!{
        # Since the before/after board state differs, populate the first
        # (for now) empty tile with a '2' tile.

        # Remove the *before* state and put a space at the end.
        s/\n.*/ /

        # Replacement for a modulus operator. Fill the Nth open cell,
        # mod number-of-open-cells. Instead of filling the cell with an
        # "a" (2), we use an "A" so that that it can be specially marked
        # when output.
        s/(:....){4} /&&&&&&&&&&&&&&&&/
        / 16:/s/-/A/16
        / 15:/s/-/A/15
        / 14:/s/-/A/14
        / 13:/s/-/A/13
        / 12:/s/-/A/12
        / 11:/s/-/A/11
        / 10:/s/-/A/10
        / 9:/s/-/A/9
        / 8:/s/-/A/8
        / 7:/s/-/A/7
        / 6:/s/-/A/6
        / 5:/s/-/A/5
        / 4:/s/-/A/4
        / 3:/s/-/A/3
        / 2:/s/-/A/2
        / 1:/s/-/A/1

        # Find the copy with the replaced open cell and use that one. The
        # most likely option is that the original copy contains the
        # replacement. In this case, copies 2-16 are identical.
        s/((:....){4} )((:....){4} )\3{14}/\1/

        # Otherwise, the first copy can be used as a model from which
        # 14 other copies will match.
        s/^(. [0-9]+)((:....){4} )\2*((:....){4} )\2*$/\1\4/

        # Remove the trailing space and output the board.
        s/ $//

        b output
    }

    # Remove the *before* state.
    s/\n.*//


:output

    # If the game is over, exit with a message.
    / z/{
        s/.*/\nNo more moves! Game over./
        p
        q
    }

    # Remove key press direction and random input.
    s/^[^:]*//

    # Copy board layout to hold buffer for next time.
    h

    # Replace tokens with real numbers. The newly-populated cell is
    # marked with a ">".
    s/-/|____/g
    s/a/|___2/g
    s/A/|>__2/g
    s/b/|___4/g
    s/c/|___8/g
    s/d/|__16/g
    s/e/|__32/g
    s/f/|__64/g
    s/g/|_128/g
    s/h/|_256/g
    s/i/|_512/g
    s/j/|1024/g
    s/k/|2048/g
    s/l/|4096/g

    # Replace the *new* "2" with a normal one in the hold buffer.
    x
    s/A/a/
    x

    # Split board into multiple lines and draw borders.
    s/:/\n/g
    s/$/\n/
    s/\n/|&/2g
    s/\n/ ___________________&/

    # Output board.
    p
