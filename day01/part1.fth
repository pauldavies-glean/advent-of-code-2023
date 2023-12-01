0 value fp
variable fp-buffer 128 allot

: open-input ( -- )
    s" input" r/o open-file throw to fp ;

: for-each-line-in-input ( 'fn -- )
    >r begin
        fp-buffer 128 fp read-line throw
        if ( not eof )
            fp-buffer swap r@ execute
            0
        else 1 then
    until rdrop ;

: for-each-char-in-line ( addr len 'fn -- )
    >r begin
        dup if
            1- swap dup c@ >r 1+ swap r>
            r@ execute 0
        else 1 then
    until 2drop rdrop ;

0 value total
0 value first
0 value second
: reset-pointers ( -- )
    0 to first
    0 to second ;

: update-total ( -- )
    total . '+' emit first second . .
    total first 10 * second + + '=' emit dup . cr to total
;

: atoi ( char -- num|0 )
    dup '0' > over '9' <= and if
        '0' -
    else drop 0 then ;

: process-char ( char -- )
    atoi ?dup-if
        first 0= if
            dup to first
        then
        to second
    then ;

: process-line ( addr len -- )
    reset-pointers
    ['] process-char for-each-char-in-line
    update-total ;

: do-the-thing ( -- )
    open-input
    ['] process-line for-each-line-in-input
    total . ;

do-the-thing
