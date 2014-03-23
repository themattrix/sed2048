#!/bin/sed -rnf

:next

    # If the hold buffer contains something, append the hold buffer to
    # the pattern buffer.
    x
    /./{
        x
        G
        s/\n//
        b rotate-clockwise
    }
    x


:seed

    # TODO: should be initially seeded with random positions
    # Seed initial positions.
    # ga-c
    # -a-d
    # -a-e
    # -a-f
    s/$/:ga-c:-a-d:-a-e:-a-f/


:rotate-clockwise

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
    s/(:(.)...:(.)...:(.)...:(.)...)/\1 \5\4\3\2:/
    s/(:.(.)..:.(.)..:.(.)..:.(.).. .*)/\1\5\4\3\2:/
    s/(:..(.).:..(.).:..(.).:..(.). .*)/\1\5\4\3\2:/
    s/(:...(.):...(.):...(.):...(.) .*)/\1\5\4\3\2/

    s/(:....:....:....:.... )/:/


:merge
    
    # Collapse spaces.
    s/-//g
    
    # Merge blocks. We merge them in high-to-low order so that four "2"
    # blocks become two "4" blocks and not a single "8" block.
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

    # If right (or a rotated up), pad left. Otherwise, pad right.
    /^[RU]/b pad-left


:pad-right

    # Add an extra four dashes to the right of the line, then trim the
    # line to the left-most four characters.
    s/(:[^:]*)/\1----/g
    s/(:....)[^:]*/\1/g
    b rotate-counter-clockwise


:pad-left

    # Add an extra four dashes to the left of the line, then trim the
    # line to the right-most four characters.
    s/:([^:]*)/:----\1/g
    s/[^:]*(....)(:|$)/\1\2/g
    b rotate-counter-clockwise


:rotate-counter-clockwise

    # Don't rotate back if we didn't rotate in the first place.
    /^[LR]/b remove-metadata

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
    s/(:...(.):...(.):...(.):...(.))/\1 \2\3\4\5:/
    s/(:..(.).:..(.).:..(.).:..(.). .*)/\1\2\3\4\5:/
    s/(:.(.)..:.(.)..:.(.)..:.(.).. .*)/\1\2\3\4\5:/
    s/(:(.)...:(.)...:(.)...:(.)... .*)/\1\2\3\4\5/

    s/(:....:....:....:.... )/:/


:remove-metadata

    s/^[^:]*//


:output

    h
    x
    s/-/ ____/g
    s/a/    2/g
    s/b/    4/g
    s/c/    8/g
    s/d/   16/g
    s/e/   32/g
    s/f/   64/g
    s/g/  128/g
    s/h/  256/g
    s/i/  512/g
    s/j/ 1024/g
    s/k/ 2048/g
    s/l/ 4096/g
    s/:/\n/g
    s/$/\n/
    p
