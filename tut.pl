#!/usr/bin/perl
require MyPerlTutExt;

use MyPerlTut ("dub");
use MyPerlTutExt ("sigh_int");

my $mytut = new MyPerlTutExt("Leow");

&MyPerlTut::dub(6);
&dub(7);
&sigh_int();
$mytut->demo_scavar();
$mytut->demo_array();
$mytut->demo_hash();
$mytut->demo_flowcntl();
$mytut->demo_funcRef();
$mytut->demo_datetime();
$mytut->demo_fileio();
$mytut->demo_strsort();
$mytut->demo_dir();
$mytut->demo_db();
$mytut->demo_regx();

$mytut->demo_xxx();

