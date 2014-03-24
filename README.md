2048.sed
========

This is an (almost) entirely sed implementation of the 2048 game. All of the game logic is in sed. Bash is used to supply the sed script with user input and with pseudo-random numbers.

Use the W/A/S/D keys to control. Run with:

    $ ./src/2048.sh

> Note for OS X users: The version of sed installed has different options than the Linux one. Notably, it does not have the extended-regex option `-r`. I recommend building the latest version from here: http://sed.sourceforge.net/
