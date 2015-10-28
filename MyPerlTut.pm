#!/usr/bin/perl
package MyPerlTut;
use warnings;
use strict;
use Data::Dumper;
use Config;

# inherit from Exporter
use parent ("Exporter");
# export sub dub
our @EXPORT_OK;
push @EXPORT_OK, "dub";

=blocl comments
This package/class (MyPerlTut) demo basic perl
syntax and func
=cut

# constructor
sub new {
    my $class = shift;
    my $self = { _usrname => shift,
                 _progress => {}
               };
    print "Running on OS: $Config{osname}, Arch: $Config{archname}\n";
    print "Welcome to basic Perl tutorial $self->{_usrname}\n";
    bless $self, $class;
    return $self;
}

sub show_prog {
    my ($self) = @_;
    print "func gone through:\n";
    foreach my $fn (keys %{ $self->{_progress} }) {
        print "$fn: $self->{_progress}{$fn}\n";
    }
}

sub prog {
    my ($self, $mfn) = @_;
    if (exists($self->{_progress}{$mfn})){
        $self->{_progress}{$mfn}++;
    } else {
        $self->{_progress}{$mfn} = 1;
    }
}

sub demo_scavar {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    my $var1 = "stra";
    my $int1 = 3;
    my $flt = 13.5;
    my $oct = 016;
    my $hex = 0xf1;
    my $snot = 1.2E2;
    my $x5 = "x" x 5;
    my $nullv = undef;
    my $vstr = v66.98.79;
    print "Test var1=$var1, int1=$int1 oct=$oct.\n";
    print "binary operation: ".(~$int1).(3|5).($int1^5).($int1&0)."\n";
    
    my $hdoc=<<"EOV";
Here document:
lots of text
multple lines
var included $x5
func call @{[substr($var1, -2)]}
vstring $vstr
EOV
    print "Test hdoc=$hdoc\n";
    print "Special literals: ". __PACKAGE__.",".__FILE__.",". __LINE__."\n";
}

sub demo_array {
    my $self = shift;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
	# define multidimensional array from list won't work
    my @arr = ("text", (1, 1.2), 'anything', -44);
	# multidimensional array
	$arr[5] = ("x","y","z");
	$arr[6] = [6, "66"];
    print "array: @arr \n";
    my $alen = @arr;
    $arr[8] = "tail";
    $arr[9] = \@ARGV;
    print "Array arr len $alen, last indx=$#arr, last=$arr[-1] \$arr[5]=$arr[5] \$arr[6][1]=$arr[6][1] \$arr[9][1]=$arr[9][1]\n";
    # array slice and array func: sort, reverse
    print "silce [0..3]: ";
    print "$_ " for reverse sort(@arr[0..3]); print "\n";
	print scalar reverse "1234";
    print "slice [2,4,8] @arr[2,4,8]\n";
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
    my @evens = map { $_ * 2 } 1..3;
    print Dumper(\@evens);
}

sub demo_hash {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
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
    my ($k, $v);
    while( ($k,$v) = each(%hmap)) {
        print("hmap{$k} => $v\n");
    }
	# multidimensional hash
	my %mHash = (k1 => {kk1 => "vv1"});
	print Dumper(\%mHash);
}

# Operator Description
# + Addition - Adds values on either side of the operator
# - Subtraction - Subtracts right hand operand from left hand operand
# * Multiplication - Multiplies values on either side of the operator
# / Division - Divides left hand operand by right hand operand
# % Modulus - Divides left hand operand by right hand operand and returns remainder
# ** Exponent - Performs exponential (power) calculation on operators
# & Binary AND Operator copies a bit to the result if it exists in both operands.
# | Binary OR Operator copies a bit if it exists in eather operand.
# ^ Binary XOR Operator copies the bit if it is set in one operand but not both.
# ~ Binary Ones Complement Operator is unary and has the efect of 'flipping' bits.
# << Binary Left Shift Operator. The left operands value is moved left by the number of bits specified by the right operand.
# >> Binary Right Shift Operator. The left operands value is moved right by the number of bits specified by the right operand.
# and Called Logical AND operator. If both the operands are true then then condition becomes true.
# && C-style Logical AND operator copies a bit to the result if it exists in both operands.
# or Called Logical OR Operator. If any of the two operands are non zero then then condition becomes true.
# || C-style Logical OR operator copies a bit if it exists in eather operand.
# not Called Logical NOT Operator. Use to reverses the logical state of its operand. If a condition is true then Logical NOT operator will make false.
# . Binary operator dot (.) concatenates two strings.
# x The repetition operator x returns a string consisting of the left operand repeated the number of times specified by the right operand.
# .. The range operator .. returns a list of values counting (up by ones) from the left value to the right value
# ++ Auto Increment operator increases integer value by one
# -- Auto Decrement operator decreases integer value by one
# -> The arrow operator is mostly used in dereferencing a method or variable from an object or a class name

# Subroutines. prototype with arg list not suggested
sub dub($) {
    my ($a) = @_;
    $a *= 2;
    print "dub: $a\n";
    return $a;
}

sub demo_strsort {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    my $teststr = "The quick brown fox jumps over the lazy dog";
    my $strlen = length($teststr);
    # index returns 0 based position
    my $indx1 = index($teststr, "he");
    my $indx2 = index($teststr, "he", $indx1+1);
    my $indx3 = rindex($teststr, "d");
    my $origstr = substr($teststr, $indx3, 3, "sheep");
    print "$origstr\nindx1: $indx1, indx2: $indx2\nafter substr: $teststr\n";
    # sort array
    my @instr = ("a1".."c3");
    my @sortstr = sort { substr($a,1) <=> substr($b,1) } @instr;
    print "input: @instr\nsorted: @sortstr\n";
    my %inhash = ("x" => 9, "y" => 6, "c" => 2, "a" => 3, "r" => 3, "t" => 6);
    print "origin table:\n";
    my @hkeys = keys(%inhash);
    print "$_=$inhash{$_}\n" for @hkeys;
    print "sorted table:\n";
    my @skeys = sort { $inhash{$a} <=> $inhash{$b} or $a cmp $b } @hkeys;
    print "$_=$inhash{$_}\n" for @skeys;
}

sub demo_flowcntl {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    my $testv = 9;
    my @testarr = (3, "gg", "_h_", 9, 10, 77.3);
    my %testmap = ('k1'=>5, "k2"=>9, 3=>"v3");
# if/unless elsif else
# number 0, the strings '0' and "" , the empty list (),
# and undef are all false in a boolean context and all other values are true. 
# compare
# number: < > >= <= == != <=>
# str: lt gt ge le eq ne cmp
    if (0 || "") {
        print "true case\n";
    } elsif ($testarr[0] > 5 || $testmap{3} le "b") {
        print "elsif case\n";
    } else {
        print "else case\n";
    }

# switch case
# deprecated by experimental given/when since 5.10
    use Switch;
    print "old switch case\n";
    switch($testv) {
        case 1 { print "int 1\n"; }
        case "a" { print "string a\n" }
        case [11..13,42] { print "number in list\n" }
        case (\@testarr) { print "number in array\n"; next; }
        case qr/\t+/ { print "pattern match\n" }
        case (\%testmap) { print "entry in hash\n"; next; }
        case (\&dub) { print "arg to subroutine\n" }
        case (/\w+/) { print "pattern match \\w+\n"; }
        else { print "no match\n"; }
    }
    use feature "switch";
    print "new given when\n";
    # Every "when" block is implicitly ended with a "break"
    # use keyword continue to fall through to next case
    given($testv) {
        when(9) { print "int 9\n"; continue; }
        when("9") { print "string 9\n"; continue; }
        when([1..10,42]) { print "number in list\n"; continue; }
        when(\@testarr) { print "number in array\n"; continue; }
        when(qr/\t+/) { print "pattern match\n" }
        when(\%testmap) { print "entry in hash\n"; continue; }
        when(\&dub) { print "arg to subroutine\n" }
        when(/\w+/) { print "pattern match \\w+\n"; }
        default { print "no match\n"; }
    }         



# loops
# while/until
    while ($testv != 0) {
        print "in while loop $testv\n";
        $testv--;
    }

# for
    for (my $x=16; $x>2; $x/=2) {
        print "in for loop $x\n";
    }

# foreach
    foreach my $i (@testarr) {
        print "item in array: $i\n";
        last if $i =~/0/ and print "last in loop\n";
    }
}

sub func_hash {
    my ($k, $v, %h) = @_;
    $h{$k} = $v;
    return $v;
}
sub func_hash_ref {
    my ($k, $v, $h) = @_;
    $$h{$k} = $v;
}

sub demo_funcRef {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
# reference of func
    my $funcref = \&func_hash;
    my %testmap = ('k1'=>5, "k2"=>9, 3=>"v3");
    my $ret = &$funcref(3, "hf test", %testmap);
    print "func_hash ret '$ret'\n";
    print "\%testmap after func_hash\n";
    print Dumper(\%testmap);
    &func_hash_ref(3, "hf test", \%testmap);
    print "\%testmap after func_hash_ref\n";
    print Dumper(\%testmap);
}

sub demo_datetime {
    use Time::localtime;
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    my $yday = localtime->yday();
# sec, # seconds of minutes from 0 to 61 
# min, # minutes of hour from 0 to 59 
# hour, # hours of day from 0 to 24 
# mday, # day of month from 1 to 31 
# mon, # month of year from 0 to 11 
# year, # year since 1900 
# wday, # days since sunday 
# yday, # days since January 1st 
# isdst # hours of daylight savings time
    print "day of year: $yday\n";
    my $datestring = gmtime();
    print "\$datestring $datestring\n";
    my $epoc = time(); # seconds since 1/1/1970
    print "\$epoc $epoc\n";

    use POSIX qw(strftime);
    $datestring = POSIX::strftime("%Y %a %b %e %H:%M:%S", CORE::localtime());
    print "\$datestring $datestring\n";

    use DateTime::Format::Strptime;
    my $strp = DateTime::Format::Strptime->new(
     pattern   => '%a %b %e %H:%M:%S %Y',
     on_error  => 'croak',
    );

    my $dt = $strp->parse_datetime('Fri May  1 21:13:53 2015');

    print DateTime::Format::Strptime::strftime('%Y/%m/%d %H:%M:%S', $dt), "\n";
}

sub demo_fileio {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
# associate filehandle with file
# open(FHND, mode, fname); where FHND is the filehandle name
# predefined filehandles: STDIN, STDOUT, STDERR
# supported open modes
# < or r Read Only Access 
# > or w Creates, Writes, and Truncates 
# >> or a Writes, Appends, and Creates 
# +< or r+ Reads and Writes 
# +> or w+ Reads, Writes, Creates, and Truncates 
# +>> or a+ Reads, Writes, Appends, and Creates
    my $fname = "file.txt";
    open(my $DATA, "+>", $fname);
    print $DATA "test file\n()";
    print "cur position in file: ". tell($DATA) . "\n";
    # seek FILEHANDLE,POSITION,WHENCE
    # where WHENCE: 0 start, 1 current, 2 eof
    # caveat: open a file for mixed w&r in windows will mess up the file
    seek($DATA, -2, 2);
    print "cur position in file: ". tell($DATA) . "\n";
    print "cur char: ". getc($DATA) . "\n";
    print "rewind to start\n";
    seek($DATA, 0, 0);
    my $tmpv;
    read($DATA, $tmpv, 5);
    print "read 5 bytes: $tmpv\n";
    print $DATA "new data\n";
    close($DATA);
    open($DATA, "<", $fname);
    my @data = <$DATA>;
	# when file is large, read file line by line: while(my $line = <$fh>) { 
    print "now file content:\n@data\n";
    close($DATA);

# check file info
# -A Script start time minus file last access time, in days. 
# -B Is it a binary file? 
# -C Script start time minus file last inode change time, in days. 
# -M Script start time minus file modification time, in days. 
# -O Is the file owned by the real user ID? 
# -R Is the file readable by the real user ID or real group? 
# -S Is the file a socket? 
# -T Is it a text file? 
# -W Is the file writable by the real user ID or real group? 
# -X Is the file executable by the real user ID or real group? 
# -b Is it a block special file? 
# -c Is it a character special file? 
# -d Is the file a directory? 
# -e Does the file exist? 
# -f Is it a plain file? 
# -g Does the file have the setgid bit set? 
# -k Does the file have the sticky bit set? 
# -l Is the file a symbolic link? 
# -o Is the file owned by the effective user ID? 
# -p Is the file a named pipe? 
# -r Is the file readable by the effective user or group ID?
# -s Returns the size of the file, zero size = empty file. 
# -t Is the filehandle opened by a TTY (terminal)? 
# -u Does the file have the setuid bit set? 
# -w Is the file writable by the effective user or group ID? 
# -x Is the file executable by the effective user or group ID? 
# -z Is the file size zero?
    if (-e $fname) {
        # '_' is special perl string representing the 
        # filehandle of last file operation:
        # state or file test etc. 
        print "$fname is text file\n" if (-T _);
        print "size of $fname is ". (-s _) ."\n";
    } else {
        print "$fname not exists!\n";
    }
}

sub demo_dir {
    use Cwd;
    use File::stat;
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    chdir "/nowhere" or warn "chdir failure: $!\n";
    my $pwd =  cwd();
    printf "current dir is: $pwd\n"; 
    # globbing like shell
    my $glbstr = "*.*";
    my @glbarr = glob($glbstr);
    print "$glbstr: @glbarr\n";
    my $DH;
    opendir $DH, $pwd or warn "opendir failure: $!\n";
    foreach my $file (readdir $DH) {
        if (-r $file) {
            printf "$file last modified at: %s\n", 
                   ctime(stat($file)->mtime);
        }
    }
    closedir $DH
}

sub demo_regx {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
# REGEXP refer to "perldoc perlre"
# Match Regular Expression - m// 
# Substitute Regular Expression - s///  
# Transliterate Regular Expression - tr///
    my $teststr = "abc 123 xyz 456 lmn";
    my $mr = ($teststr =~ m/c.*\d /);
    print "default greedy match result: $mr\n";
    print "special matched var: \$` '$`', \$& '$&', \$' '$''\n";
    $mr = ($teststr =~ m/c.*?\d /);
    print "lazy match result: $mr\n";
    print "special matched var: \$` '$`', \$& '$&', \$' '$''\n";
    my ($m1, $m2) = ($teststr =~ m/.*(1.+) (4\d+)/);
    print "matched str: '$m1', '$m2'\n";
    $teststr =~ s/(\w+)([\d ]+)(\w+)/\U$1\E$2\u\3/;
    print "after change case: '$teststr'\n";
    $teststr =~ s/\d{2}/d_/;
    print "after substitution: '$teststr'\n";
    $teststr =~ tr/Az/zA/;
    print "after translation: '$teststr'\n";
# match patterns
# ^ Matches beginning of line.
# $ Matches end of line. 
# . Matches any single character except newline. Using m option allows it to match newline as well. 
# [...] Matches any single character in brackets.
# [^...] Matches any single character not in brackets
# * Matches 0 or more occurrences of preceding expression. 
# + Matches 1 or more occurrence of preceding expression. 
# ? Matches 0 or 1 occurrence of preceding expression. 
# {n} Matches exactly n number of occurrences of preceding expression. 
# {n,} Matches n or more occurrences of preceding expression. 
# {n, m} Matches at least n and at most m occurrences of preceding expression.
# a| b Matches either a or b.
# \w Matches word characters.
# \W Matches nonword characters.
# \s Matches whitespace. Equivalent to [\t\n\r\f].
# \S Matches nonwhitespace.
# \d Matches digits. Equivalent to [0-9].
# \D Matches nondigits.
# \A Matches beginning of string.
# \Z Matches end of string. If a newline exists, it matches just before newline.
# \z Matches end of string.
# \G Matches point where last match finished.
# \b Matches word boundaries when outside brackets. Matches backspace (0x08) when inside brackets.
# \B Matches nonword boundaries.
# \n,
# \t, etc. Matches newlines, carriage returns, tabs, etc.
# \1...\9 Matches nth grouped subexpression.
# \10 Matches nth grouped subexpression if it matched already. Otherwise refers to the octal representation of a character code.
}

# error report with Carp
use Carp qw/cluck confess/;

sub func_err {
    # cluck is like warn and will print full stack trace
    cluck "stumbled on Error!\n @_";
    # confess is like die and will print full stack trace
    confess "dying on Error!\n @_";
}

sub demo_carp {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    &func_err("demo purpose\n");
}

# defualt autoload func for error handling
use vars qw($AUTOLOAD);
sub AUTOLOAD {
    my ($self) = @_;
    my $type = ref($self);
    &func_err("$AUTOLOAD is not defined in $type\n");
}

# deconstructor called automatically by perl when the object is freed
sub DESTROY {
    my ($self) = @_;
    print "Tutorial concluded for $self->{_usrname}\n";
    $self->show_prog();
}
# Perl modules are required to return a value to signal if the require directive must succeed
1;

__END__
