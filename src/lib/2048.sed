#!/bin/sed -rnuf

:initial-board

    # The very first input line is the initial board.
    /:/{
        # Insert the initial score (always zero).
        s/^/+0/
        
        # Output initial board.
        b output
    }


:next

    # This is *not* the initial board, so the hold buffer is expected to
    # contain the previous state of the board. Append the hold buffer to
    # the pattern buffer so that we can use the existing board with the
    # new key-press.
    G
    s/\n/ /


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
    /^[LR]/b reverse-if-necessary

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


:reverse-if-necessary

    # If right or up was pressed, reverse the order of the cells on
    # each line.
    /^[LD]/b merge

    # Generate the new order and place it after the existing order.
    s/:(.)(.)(.)(.):(.)(.)(.)(.):....:.....*/& \4\3\2\1:\8\7\6\5:/
    s/:....:....:(.)(.)(.)(.):(.)(.)(.)(.) .*/&\4\3\2\1:\8\7\6\5/

    s/:....:....:....:.... /:/


:merge
    
    # Collapse spaces.
    s/-//g

    # If this is a dry run...
    /^.d /{
        # ...and a merge can be made, end the dry-run.
        /([a-k])\1/b end-dry-run

        # Otherwise, restore the board state from the hold buffer...
        G
        s/\+.*\n//

        # ...and check again to see if the game is over.
        b check-if-game-is-over

        :end-dry-run

            # Dry run done! Remove the dry-run flag.
            s/^.d //
            
            # Restore the board state from the hold buffer.
            G
            s/\+.*\n//
            
            # Continue game :)
            b game-not-over
    }

    # Merge cells. We merge them in high-to-low order so that four
    # "2" cells become two "4" cells and not a single "8" cell.
    :try-merge t try-merge

        :merge-k /kk/{
            s/kk/l/
            s/\+/+4096+/
            b merge-k
        }
        :merge-j /jj/{
            s/jj/k/
            s/\+/+2048+/
            b merge-j
        }
        :merge-i /ii/{
            s/ii/j/
            s/\+/+1024+/
            b merge-i
        }
        :merge-h /hh/{
            s/hh/i/
            s/\+/+512+/
            b merge-h
        }
        :merge-g /gg/{
            s/gg/h/
            s/\+/+256+/
            b merge-g
        }
        :merge-f /ff/{
            s/ff/g/
            s/\+/+128+/
            b merge-f
        }
        :merge-e /ee/{
            s/ee/f/
            s/\+/+64+/
            b merge-e
        }
        :merge-d /dd/{
            s/dd/e/
            s/\+/+32+/
            b merge-d
        }
        :merge-c /cc/{
            s/cc/d/
            s/\+/+16+/
            b merge-c
        }
        :merge-b /bb/{
            s/bb/c/
            s/\+/+8+/
            b merge-b
        }
        :merge-a /aa/{
            s/aa/b/
            s/\+/+4+/
            b merge-a
        }


:pad-right

    # Add an extra four dashes to the right of the line, then trim the
    # line to the left-most four characters.
    s/(:[^:]*)/\1----/g
    s/(:....)[^:]*/\1/g


:add-score
    
    /\+.*\+/!b add-score-end

    # Calculate the new score (we'll do this in the hold buffer to make it easier).
    h
    x

    # Get rid of everything except the score components.
    s/.* \+([0-9+]+).*/\1/

    :add-number t add-number
    :combination-sums

        s/$/ 00=0,01=1,02=2,03=3,04=4,05=5,06=6,07=7,08=8,09=9/
        s/$/,11=2,12=3,13=4,14=5,15=6,16=7,17=8,18=9,19=_0/
        s/$/,22=4,23=5,24=6,25=7,26=8,27=9,28=_0,29=_1/
        s/$/,33=6,34=7,35=8,36=9,37=_0,38=_1,39=_2/
        s/$/,44=8,45=9,46=_0,47=_1,48=_2,49=_3/
        s/$/,55=_0,56=_1,57=_2,58=_3,59=_4/
        s/$/,66=_2,67=_3,68=_4,69=_5/
        s/$/,77=_4,78=_5,79=_6/
        s/$/,88=_6,89=_7/
        s/$/,99=_8 /
        
        s/\+[0-9]+/_&_/


    :zero-pad t zero-pad

        s/^_[0-9]+\+[^_]/0&/
        s/^([^_][0-9_]+\+)_/\10_/

        :do-add t do-add

            s/([0-9])_(.*)([0-9])_(.*(\1\3|\3\1)=)([0-9_]+)(.*) 0?(.*)/_\1\2_\3\4\6\7 0\6\8/
            t zero-pad

        s/^[^+]+\+[^+]+(.*) .* (.*)$/0123456789 \2\1/


    :shift t shift

        /_/{
            s/(([0-9])([0-9])[0-9]* [0-9_]*)\2_([0-9]*)(\+|$)/\1\3\4\5/
            t shift
            s/( [0-9_]*)9_([0-9]*)(\+|$)/\1_0\2\3/
            t shift
        }


    :shift-end t shift-end

        s/^0123456789 //
        s/^0+(.)/\1/

        # If there's still a "+", add another number.
        /\+/b add-number

    
    # The hold buffer now contains the current score. Put it back in the
    # pattern buffer, then replace the old score components (e.g., +4+16+4)
    # with the new score. The new score appears immediately after the newline.
    x
    G
    s/^(. [0-9,]+ )([0-9+]+)(.*)\n(.*)/\1+\4\3/

:add-score-end


:reverse-again-if-necessary

    # If right or up was pressed, reverse the order of the cells on
    # each line.
    /^[LD]/b rotate-backwards-if-necessary

    # Generate the new order and place it after the existing order.
    s/:(.)(.)(.)(.):(.)(.)(.)(.):....:.....*/& \4\3\2\1:\8\7\6\5:/
    s/:....:....:(.)(.)(.)(.):(.)(.)(.)(.) .*/&\4\3\2\1:\8\7\6\5/

    s/:....:....:....:.... /:/


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
    # This is easy to check, since the *before* state is still in the
    # hold buffer. To compare, we'll simply append the hold buffer to
    # the pattern buffer and see if the pattern buffer appears twice.

    # Append *before* state to *after* state (separated by a newline).
    G

    /((:....){4})\n\1/!{
        # The before/after board states differ. Because they differ, 
        # populate the Nth empty cell with a "2". N is a number between
        # 1 and 16 (inclusive). It was pseudo-randomly chosen by the
        # input script and appears right after the key press direction.

        # Remove the *before* state and put a space at the end.
        s/\n.*/ /

        # Replacement for a modulus operator. Fill the Nth open cell,
        # mod number-of-open-cells. Instead of filling the cell with an
        # "a" (2), we use an "A" so that that it can be specially marked
        # as a *new* cell when the board is output.
        s/(:....){4} /&&&&&&&&&&&&&&&&/

        # These replacements could be in any order, since only one will
        # happen. The "t end-cell-fill" commands are also not required.
        # These are simply a performance optimization.
        :cell-fill t cell-fill

            /,2/{
                / 1,/s/-/A/1;   t end-cell-fill
                / 2,/s/-/A/2;   t end-cell-fill
                / 3,/s/-/A/3;   t end-cell-fill
                / 4,/s/-/A/4;   t end-cell-fill
                / 5,/s/-/A/5;   t end-cell-fill
                / 6,/s/-/A/6;   t end-cell-fill
                / 7,/s/-/A/7;   t end-cell-fill
                / 8,/s/-/A/8;   t end-cell-fill
                / 9,/s/-/A/9;   t end-cell-fill
                / 10,/s/-/A/10; t end-cell-fill
                / 11,/s/-/A/11; t end-cell-fill
                / 12,/s/-/A/12; t end-cell-fill
                / 13,/s/-/A/13; t end-cell-fill
                / 14,/s/-/A/14; t end-cell-fill
                / 15,/s/-/A/15; t end-cell-fill
                / 16,/s/-/A/16; t end-cell-fill
            }

            /,4/{
                / 1,/s/-/B/1;   t end-cell-fill
                / 2,/s/-/B/2;   t end-cell-fill
                / 3,/s/-/B/3;   t end-cell-fill
                / 4,/s/-/B/4;   t end-cell-fill
                / 5,/s/-/B/5;   t end-cell-fill
                / 6,/s/-/B/6;   t end-cell-fill
                / 7,/s/-/B/7;   t end-cell-fill
                / 8,/s/-/B/8;   t end-cell-fill
                / 9,/s/-/B/9;   t end-cell-fill
                / 10,/s/-/B/10; t end-cell-fill
                / 11,/s/-/B/11; t end-cell-fill
                / 12,/s/-/B/12; t end-cell-fill
                / 13,/s/-/B/13; t end-cell-fill
                / 14,/s/-/B/14; t end-cell-fill
                / 15,/s/-/B/15; t end-cell-fill
                / 16,/s/-/B/16; t end-cell-fill
            }

        :end-cell-fill

        # Find the copy with the replaced open cell and use that one. The
        # most likely option is that the original copy contains the
        # replacement. In this case, copies 2-16 are identical.
        s/((:....){4} )((:....){4} )\3{14}/\1/

        # Otherwise, the first copy can be used as a model from which
        # 14 other copies will match. Pull out the modified copy.
        s/^([^:]+)((:....){4} )\2*((:....){4} )\2*/\1\4/

        # Remove the trailing space and output the board.
        s/ $//

        b output
    }

    # Remove the *before* state.
    s/\n.*//


:output

    # If the game is over, exit with a message.
    / z/{
        s/.*/No more moves! Game over./
        p
        q
    }

    # Remove key press direction and random cell number, but leave the
    # score and the board.
    s/^. [0-9,]+ //

    # Copy board layout and score to hold buffer for next time.
    h

    # If the "2048" (k) or higher cell appears, you've won! Add a "win"
    # flag to the pattern buffer.
    /[kl]/s/:/w:/

    # Replace tokens with real numbers. The newly-populated cell is
    # marked with a ">".
    s/-/|____/g
    s/a/|___2/g
    s/A/|>__2/g
    s/B/|>__4/g
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

    # Replace the *new* cell with a normal one in the hold buffer.
    x
    y/AB/ab/
    x

    # Split board into multiple lines and draw borders.
    s/:/\n/g
    s/$/\n/
    s/\n/|&/2g
    s/\n/ ___________________&/

    # Format the score.
    s/^\+([0-9]+)(.*)/\2\nScore: \1\n/

    # Winner, winner, chicken dinner!
    s/^w(.*)/\1\nYou win!\n/

    # Output board.
    p
