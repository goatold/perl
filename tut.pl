#!/usr/bin/perl
use warnings;
use strict;

=blocl comments
crossing multiple lines
until =cut
=cut

# line comment

my $var1 = "stra";
my $int1 = 3;
my $flt = 13.5;
my $oct = 0556;
my $hex = 0xf1;
my $snot = 1.2E2;
my $x5 = "x" x 5;
my $vstr = v66.98.79;
print "Test var1=$var1, int1=$int1.\n";
print "binary operation: ".(~$int1).(3|5).($int1^5).($int1&0)."\n";

my $hdoc=<<"EOV";
Here document:
lots of text
multple lines
var included $x5
vstring $vstr
EOV

print "Test hdoc=$hdoc\n";

print "Special literals: ". __PACKAGE__.",".__FILE__.",". __LINE__."\n";
# array
my @arr = ($var1, $int1, $flt, $oct, $hex, $snot, -44);
$arr[9] = "tail";
my $alen = @arr;
print "Arry arr len $alen, last indx=$#arr, last=$arr[-1]\n";
# array slice and array func: sort, reverse
print "array: @arr \n";
print "silce [0..3]: ";
print "$_ " for sort(@arr[0..3]); print "\n";
print "slice [2,4,6] @arr[2,4,6]\n";
# remove undefined in array
@arr = grep defined, @arr;
# pop push shift
push @arr, ("p1","p2");
print "push onto the end: @arr\n";
pop @arr;
print "pop the last: @arr\n";
shift @arr;
print "shift the first: @arr\n";
unshift @arr, qw(s1 s2);
print "unshift in the front: @arr\n";
splice(@arr, 2, 3, split("-","r1-r2-r3"));
print "splice 3 items from offset 2, : @arr\n";
print "args @ARGV\n";

# hash
my %hmap = ("k1", "v1", k2 => "v2");
$hmap{"k3"} = 3;
print "hash: %hmap\n";
print "keys ", keys(%hmap), "\n";
print "vals " . join(",", values(%hmap)) . "\n";
print "slice k2, k3: @hmap{'k2','k3'} \n";
print "check 'k2' existence: " . (exists($hmap{'k2'})?"y":"n") . "\n";
my @ks = keys(%hmap);
my $hl = @ks;
print "hmap size: $hl\n";
# remove elements in hash
delete $hmap{'k2'};
print ("hash: ", %hmap, "\n");

# flow control
# if/unless elsif else
# number 0, the strings '0' and "" , the empty list (),
# and undef are all false in a boolean context and all other values are true. 
# compare
# number: < > >= <= == != <=>
# str: lt gt ge le eq ne cmp
if (0 || "") {
    print "true case\n";
} elsif ($hl > 5 || $hmap{'k3'} < 0) {
    print "elsif case\n";
} else {
    print "else case\n";
}

# switch case
use Switch;
switch($snot) {
    case 1 { print "int 1\n"; }
    case "a" { print "string a\n" }
    case [1..10,42] { print "number in list\n" }
    case (\@arr) { print "number in array\n"; next; }
    case qr/\t+/ { print "pattern match\n" }
    case (\%hmap) { print "entry in hash\n" }
    #case (\&sub) { print "arg to subroutine\n" }
    case (/\w+/) { print "pattern match \w+\n"; }
    else { print "no match\n"; }
}

# loops
# while/until
while ($int1 != 0) {
    print "in while loop $int1\n";
    $int1--;
}

# for
for (my $x=16; $x>2; $x/=2) {
    print "in for loop $x\n";
}

# foreach
foreach my $i (@arr) {
    print "item in array: $i\n";
    last if $i =~/0/ and print "last in loop\n";
}

# Subroutines
sub func_add {
    my ($a, $b) = @_;
    print "$a + $b = ". ($a+$b) ."\n";
}
&func_add(3,5);

# global/local/state var
main::astr = "global string";
sub func_loc {
    local $astr = "local string";
    &func_prt($astr);
    print "astr in func_loc $astr\n";
}

print "astr in main $astr\n";
sub func_prt {
    print "astr in func_prt $_\n";
}

# datetime func
# ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
# $datestring = gmtime();
# epoc = time(); seconds since 1/1/1970
# $datestring = strftime "%a %b %e %H:%M:%S %Y", localtime;

