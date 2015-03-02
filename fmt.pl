#!/usr/bin/perl
# perl format output
format REPORT =
-----------------------------
@>>>>> @||||| @<<<<< @###.##
$f1 $f2 $f3 $f4
.

format REPORT_HEAD = 
=============================
F1    F2    F3    F4 <pg @<<>
$%
.

select(STDOUT);
$~ = REPORT;
$^ = REPORT_HEAD;
$= = 10; # page size
for(my $i=1; $i<=32; $i++) {
    $f1 = "l" x ($i%5);
    $f2 = "m" x ($i%5);
    $f3 = "r" x ($i%5);
    $f4 = 1.1 * $i;
    write();
}


