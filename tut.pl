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
print "array: @arr \n silce: ";
print "$_ " for sort(@arr[0..3]);
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

# hash
my %hmap = ("k1", "v1", k2 => "v2");
print "hash: %hmap";
print "keys ", keys(%hmap), "\n";
print "vals " . join(",", values(%hmap)) . "\n";




