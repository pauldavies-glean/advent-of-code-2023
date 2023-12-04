0 value fp
256 value buf-size
variable fp-buffer buf-size allot

: open-input ( addr len -- )
    r/o open-file throw to fp ;

: for-each-line-in-input ( 'fn -- )
    >r begin
        fp-buffer buf-size fp read-line throw
        if ( not eof )
            fp-buffer swap r@ execute
            0
        else 1 then
    until rdrop ;

: isdigit ( ch -- flag )
    >r
    r@ '0' >=
    r> '9' <= and ;

0 value line-addr
0 value line-len

: cline ( -- addr len )
    line-addr line-len ;

: to-cline ( addr len -- )
    to line-len to line-addr ;

: cline-eof ( -- flag )
    line-len 0 <= ;

: sskip ( n -- )
    >r
    cline r@ -
    swap r> +
    swap
    to-cline ;

: sscand ( -- n )
    0 0 cline >number to-cline drop ;

: cpeek ( -- n)
    line-addr c@ ;

: skipd ( -- flag )
    begin
        cline-eof if false exit then

        cpeek isdigit if true
        else
            1 sskip
            false
        then
    until true ;

0 value red-max
0 value green-max
0 value blue-max
0 value id-total
0 value game-id

: grab-game-id ( -- )
    5 sskip
    sscand to game-id ;

: sscant ( -- max )
    cpeek case
        'r' of red-max 3 sskip endof
        'g' of green-max 5 sskip endof
        'b' of blue-max 4 sskip endof
    endcase ;

: get-next-group ( -- count max 1 | 0 )
    skipd if
        sscand 1 sskip sscant false
    else true then ;

: invalid-group? ( count max -- flag ) 
    > ;
: add-id-to-total ( -- )
    game-id id-total + to id-total ;

: process-line ( addr len -- )
    to-cline
    grab-game-id get-next-group drop
    begin
        invalid-group? if
            exit
        else
            get-next-group
        then
    until
    add-id-to-total ;

: do-the-thing ( addr len r g b -- )
    to blue-max to green-max to red-max
    open-input
    ['] process-line for-each-line-in-input
    id-total . ;

s" input" 12 13 14 do-the-thing bye
