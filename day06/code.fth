0 value race-record
0 value race-solutions

: race-distance ( hold time -- distance )
    over - * ;

: solve-race ( time record -- ways )
    0 to race-solutions
    to race-record
    dup 1 do
        i over race-distance race-record > if
            race-solutions 1+ to race-solutions
        then
    loop drop
    race-solutions ;

: part1 ( -- )
\    Time:        62     64     91     90
\    Distance:   553   1010   1473   1074
    62 553 solve-race
    64 1010 solve-race
    91 1473 solve-race
    90 1074 solve-race
    * * * . ;

: part2 ( -- )
\ Time:      62649190
\ Distance:  553101014731074
    62649190 553101014731074 solve-race . ;

." part 1: " part1 cr
." part 2: " part2 cr
bye
