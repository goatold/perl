#!/usr/bin/perl
package MyPerlTutExt;
use warnings;
use strict;
use feature 'say';

# subclass inherited from (MyPerlTut) further demo perl
#require MyPerlTut;
#use vars qw(@ISA);
#our @ISA = qw(MyPerlTut);
use parent ('MyPerlTut');

# export sub dub
our @EXPORT_OK;
push @EXPORT_OK, ("sigh_int", "sigh_hup");

# override constructor
sub new {
    my ($class) = @_;
    # calling parent's constructor
    my $self = $class->SUPER::new($_[1]);
    say "Welcome to Perl extended tutorial $self->{_usrname}";
    bless $self, $class;
    return $self;
}

# extend more demo func

# show case database operation with SQLite
sub demo_db {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    use DBI;
    my $dbdriver = "SQLite";
    my $dbname = "test.db";
    my $dsn = "DBI:$dbdriver:dbname=$dbname";
    my $uid = my $pwd = "";
    # connect to DB
    my $dbh = DBI->connect($dsn, $uid, $pwd, { RaiseError => 1 }) 
              or die $DBI::errstr;
    $dbh->trace(0); # set trace level. the highest is 4
    # create table
    my $sqlstr = qq{
CREATE TABLE test (
  id INTEGER PRIMARY KEY,
  name CHAR(8) NOT NULL,
  mtime TIMESTAMP DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')),
  realv REAL,
  descr TEXT
);
    };

    my $rv = $dbh->do($sqlstr);
    if($rv < 0){
        warn "table creation failure: $DBI::errstr\n";
    }
    # insert data
    $sqlstr = "INSERT INTO test (id, name, realv, descr) VALUES(NULL,?,?,?);";
    # binding values
    my $sth = $dbh->prepare($sqlstr);
    $sth->execute("testname", 7.8, "some descriptive text") 
        or warn "data insertion failure: $DBI::errstr\n";
    $sth->finish();
    # update db
    $sth = $dbh->prepare("update test set name=?, descr=? where id=1;");
    $sth->execute("newname","updated text");
    my $nrows = $sth->rows;
    say "updated $nrows rows";
    $sth->finish();
    # read db
    $sth = $dbh->prepare("select id, name, mtime, realv, descr from test;");
    $sth->execute();
    say "data fetched:";
    while(my @row = $sth->fetchrow_array()) {
        say "id:$row[0], name:$row[1], mtime:$row[2], realv:$row[3], descr:$row[4]";
    }
    $sth->finish();
    # cleanup db
    $dbh->do("DROP TABLE IF EXISTS test;");
    $dbh->disconnect();
}

# run process in perl
sub sigh_int {say "sig int handled";}
sub sigh_hup {say "sig hup handled";}

sub demo_proc {
    my ($self) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    # backsticks
    say "time now is ".`date`;
    # system calls
    my @options = ("-l", "-a", "-t");
    system("ls", @options);
    # file handle as pipe
    open(my $WHO, "-|", "who");
    my @who = <$WHO>;
    open(my $USORT, "|-", "sort -u");
    say $USORT @who;
    close($WHO);
    close($USORT);
    # fork process
    my $pid;
    if (!defined($pid = fork())) {
        warn "fork failed: $!";
        return -1;
    } elsif ($pid == 0) {
        say "crying kid";
        exec('echo "kid pid $$ sleeping";sleep 2');
    } else {
        say "yelling parent";
        my $rv = waitpid($pid, 0);
        say "waitpid returned $rv: Kid pid($pid) status: $?";
    }
    # signal handling
    my $sighup_h = $SIG{'HUP'};
    use sigtrap qw(handler sigh_int INT);
    $SIG{'HUP'} = \&sigh_hup;
    # send signal to myslef
    kill('INT', $$);
    kill('HUP', $$);
    $SIG{'INT'} = 'IGNORE';
    say "sigin ignored";
    kill('INT', $$);
    # restore old sig handler
    $SIG{'HUP'} = $sighup_h;
    kill('HUP', $$);
}

# error handling with try/catch
use Try::Tiny;
sub demo_trycatch {
    my ($self, @args) = @_;
    my $mfn = (caller(0))[3];
    $self->prog($mfn);
    say "incoming args saved in \@args: @args";
    my $tryrtv = try {
        die "throwing fatal errors\n";
        return 1;
    } catch {
        say "error: $_ catched";
        return 0;
    } finally {
        say "whatever happened. endup here";
    }; # notice the ; here
    # return in try block does NOT return out calling sub
    say "the retv of try is $tryrtv";
}

1;

__END__

