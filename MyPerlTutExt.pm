#!/usr/bin/perl
package MyPerlTutExt;
use MyPerlTut;
use warnings;
use strict;
use vars qw(@ISA);

# subclass inherited from (MyPerlTut) further demo perl
our @ISA = qw(MyPerlTut);

# override constructor
sub new {
    my ($class) = @_;
    # calling parent's constructor
    my $self = $class->SUPER::new($_[1]);
    print "Welcome to Perl extended tutorial $self->{_usrname}\n";
    bless $self, $class;
    return $self;
}

# extend more demo func
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
    $dbh->trace(4); # set highest trace level
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
    print "updated $nrows rows\n";
    $sth->finish();
    # read db
    $sth = $dbh->prepare("select id, name, mtime, realv, descr from test;");
    $sth->execute();
    print "data fetched:\n";
    while(my @row = $sth->fetchrow_array()) {
        print "id:$row[0], name:$row[1], mtime:$row[2], realv:$row[3], descr:$row[4]\n";
    }
    $sth->finish();
    # cleanup db
    $dbh->do("DROP TABLE IF EXISTS test;");
    $dbh->disconnect();
}
