0 value gridw
0 value gridh
32000 constant grid-size
variable grid grid-size allot
200 constant line-size
variable line line-size allot

: loc ( x y base -- addr )
    >r gridw * + r> + ;                         \ base + y*width + x
: at ( x y base -- ch )
    loc c@ ;

0 value fp
: read-grid ( addr len -- )
    r/o open-file throw to fp                   \ open our file

    grid begin
        line line-size fp read-line throw       \ read next line
        if
            to gridw                            \ store width
            line over gridw cmove               \ copy line into grid
            gridw +                             \ move grid pointer
            false                               \ keep looping
        else 0= then
    until

    grid - gridw / to gridh                     \ store height

    fp close-file throw ;

0 value total
variable score-grid grid-size allot

: clear-score-grid ( -- )
    score-grid grid-size 0 fill ;               \ score = [0,0,0...]
: mark-score-grid ( x y -- )
    score-grid loc true swap c! ;               \ score[y][x] = true
: is-scored ( x y -- flag )
    score-grid at ;

: isdigit ( ch -- flag )
    >r
    r@ '0' >=
    r> '9' <= and ;

: issymbol ( ch -- flag )
    >r
    r@ isdigit 0=
    r> '.' <> and ;

16 constant score-amount-size
variable score-amount score-amount-size allot
0 value score-length
: score ( x y -- )
    \ don't count the same number twice
    2dup is-scored if 2drop exit then

    \ reset numeric string
    0 to score-length

    \ find start of numeric string
    swap begin ( y x )
        2dup 1- swap grid at isdigit if
            1- dup 0=
        else 1 then
    until

    \ 2dup ." X=" . ." Y=" .

    swap begin
        \ mark square as scored
        2dup mark-score-grid

        \ append to string
        2dup grid at score-amount score-length + !
        score-length 1+ to score-length

        \ continue until non-digit or end of row
        swap 1+ dup gridw >= >r
        swap 2dup grid at isdigit 0=
        r> or
    until

    2drop
    \ convert string to number, add to total
    0 0 score-amount score-length >number 2drop drop

    \ ." value=" dup . cr

    total + to total ;

: expando ( n -- n+2 n-1 )
    1+ 1+ dup 3 - ;

0 value scan-x
: scan-adjacents ( x y -- )
    swap to scan-x
    expando do
        scan-x expando do
            i j grid at isdigit if i j score then
        loop
    loop ;

: scan-symbols ( -- )
    gridh 1 do
        gridw 1 do
            i j grid at issymbol if i j scan-adjacents then
        loop
    loop ;

: do-the-thing ( addr len -- )
    0 to total
    clear-score-grid
    read-grid
    scan-symbols total . ;

s" input" do-the-thing bye
