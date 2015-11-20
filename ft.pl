use warnings;
use strict;
sub demo_fileio {
    my $fname = "file.txt";
    open(my $DATA, "+>", $fname);
    print $DATA "0123456789";
    # seek FILEHANDLE,POSITION,WHENCE
    # where WHENCE: 0 start, 1 current, 2 eof
    seek($DATA, -2, 2);
    print $DATA "xx";
    seek($DATA, 0, 0);
    print "cur char: ". getc($DATA) . "\n";
    print $DATA "yy";
    close($DATA);
#    open($DATA, "<", $fname);
#    my @data = <$DATA>;
#    print "now file content:\n@data\n";
#    close($DATA);
}

&demo_fileio();
