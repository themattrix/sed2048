2048.sed
========

This is a sed implementation of the [2048 game](http://gabrielecirulli.github.io/2048/). All of the game logic is in sed. Bash is used to supply the sed script with user input and with pseudo-random numbers.

Use the `W`, `A`, `S`, `D` keys to control. Run with:

    $ ./src/2048.sh

Gameplay differences from the original 2048 game:

- Total score is not calculated.
- New cells are populated only with 2's, instead of having a small chance of a 4 appearing.

> Note for OS X users: The version of sed installed has different options than the Linux one. Notably, it does not have the extended-regex option `-r`. I recommend building the latest version from here: http://sed.sourceforge.net/
