how to build:

vasmm68k_mot -m68010 -Fhunkexe rogue.asm -o rogue -I include -esc -databss -nosym -opt-allbra

you need the following files from the original:

Rogue.Char

Credits\
Hall.of.Fame\
Title.Screen\
Tombstone\
Total.Winner

also you need to convert the five bitmap files to lz4 compressed ones with:

lz4 --best --content-size Total.Winner

bugfixes:\
compatible with fastmem now\
rogue -s now can return to the shell\
scroll of wild magic is now immune to potion of discernment\
fixed the three typos (thuderclaps, missle and instructiuons)\
scroll of wild magic is now shown with its name after declining to use it\
if you identify an item where you have two of it (or more) all item descriptions get updated.\
setting the macro now works (shift-f)\
scroll names do not end with a space anymore\
update screen titlebar after restoring a game to show rank and stuff\
fixed creation of gold in _create_obj (wizard mode only)\
the ability to see the invisible actually works now\
fixed a possible rare double free which happens when a group is split up (eg: you shoot an arrow and miss)

changes:\
if the Rogue.Char file is missing the game still works (try this! ;)\
show_map and show_passages code is now reconnected (wizard mode only)\
food_left and show_inpack is added (wizard mode only)\
fastmode now has a small pause added so you can still see the player\
bitmap handling now uses only 4 big memory allocations and not 288 small ones\
print actual score with color in topten list (seems only to work in v40)\
reactivated the beep function\
added the shortcuts to the command menu\
hiding strength,maxhp and xp in the highscore file (can be overwritten by long names)
