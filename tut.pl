#!/usr/bin/perl
use MyPerlTut;

my $mytut = new MyPerlTut("Leow");

&MyPerlTut::dub(6);
$mytut->demo_scavar();
$mytut->demo_array();
$mytut->demo_hash();
$mytut->demo_flowcntl();
$mytut->demo_funcRef();
$mytut->demo_datetime();
$mytut->demo_fileio();
$mytut->demo_regx();
$mytut->show_prog();

