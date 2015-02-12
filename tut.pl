#!/usr/bin/perl
use warnings;
use strict;

=blocl comments
crossing multiple lines
'until =cut
=cut

# line comment

my $var1 = "stra";
my $int1 = 3;

print "Test var1=$var1, int1=$int1.\n";

my $hdoc=<<"EOV";
Here document:
lots of text
multple lines
EOV

print "Test hdoc=$hdoc\n";

my @arr = ($var1, $int1, 5);
my $alen = @arr;
print "Arry arr len $alen, last=$arr[$#arr]\n";
print "$_ " for @arr;