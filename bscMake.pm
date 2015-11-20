#!/usr/bin/perl
package bscMake;
use warnings;
use strict;
use Data::Dumper;

=general desc
This module provides interface for making bsc binary
- read conf from blddef.csv
- access patch oracle DB
- generate makefile
- exec clearmake
=cut

# general conf variables
my $vosconfSrc = "/vobs/g2bsc/src/kernel/VOS/src/vosconf.c";
my $blddefFn = "blddef.csv";
my $verCFn = "version.c";
my $verObjFn = "VERSION.o";
my %vceInfo = (
	VTCU => {charCode => "B", coluSeq => 0},
	VDTC => {charCode => "C", coluSeq => 1},
	VSYS => {charCode => "D", coluSeq => 2},
	VOSI => {charCode => "E", coluSeq => 3},
	VTSC => {charCode => "F", coluSeq => 4},
	);
my %moduleSufix = (MLO => ".o", LIB => ".a");
my @vceMlist = (); # get from blddef.csv

sub getBldDef {
# fetch build def info of given vce from given file
# return hash of version info and module/label list
#       
    my ($defFn, $vceBaseName) = @_;
	if (!exists($vceInfo{$vceBaseName})) {
		print "exiting on unknown VCE: $vceBaseName\n";
		return undef;
	}
	my $inSecHdr = 0;
	my $inSecMap = 0;
	my @tmpinfo;
	my %bldInfo;
	my @modLst;
	my $blddefPtnVer = '^BSC_[A-Z]+\s+'. $vceBaseName .'([A-Z]{2})\s+([0-9]{2})([A-Z])';
	my $blddefPtnMod = '^('. join("|", keys(%moduleSufix)) .')(-[A-Z0-9_\-]+),.*,.*_([A-Z0-9]{4}),\s*(.*)\s*,';
	$blddefPtnMod .= "(.*,){$vceInfo{$vceBaseName}{coluSeq}}$vceInfo{$vceBaseName}{charCode}";
	open(my $DATA, "<", $defFn);
	while(<$DATA>) {
		next if ($_ =~ m/^\*/); # scape comment lines
		if ($inSecHdr) {
			if ($_ =~ m/^END_HEADER/) {
				$inSecHdr = 0;
			} elsif (@tmpinfo = ($_ =~ m/$blddefPtnVer/)){
				$bldInfo{vceRel} = $tmpinfo[1] . $tmpinfo[2];
				$bldInfo{vceVer} = $tmpinfo[0] . $tmpinfo[1];
				@tmpinfo = ();
			}
			next;
		} elsif ($inSecMap) {
			if (@tmpinfo = ($_ =~ m/$blddefPtnMod/)) {
				my $vceMod = $tmpinfo[0] . $tmpinfo[1] . $moduleSufix{$tmpinfo[0]};
				my $vceLbl = (($tmpinfo[3])?($tmpinfo[3]):($tmpinfo[2]));
				push(@modLst, {vceMod=>$vceMod, vcelbl=>$vceLbl});
			} elsif ($_ =~ m/^END_MAPPING/) {
				last;
			}
			next;
		} else {
			if (@tmpinfo = ($_ =~ m/^DATA MODEL *: *([A-Z0-9]+)/)){
				$bldInfo{dataModule} = $tmpinfo[0];
				@tmpinfo = ();
			} elsif ($_ =~ m/^START_MAPPING/) {
				$inSecHdr = 0;
				$inSecMap = 1;
			} elsif ($_ =~ m/^START_HEADER/) {
				$inSecHdr = 1;
				$inSecMap = 0;
			}
			next;
		}
	}
	close $DATA;
	$bldInfo{modLst} = @modLst;
	print Dumper(@modLst);
	return \%bldInfo;
}

sub genVerObj {
# generate version.c and gcc to version object file
#
	my ($vceBaseName, $vceVer, $vceRel, $vcePatch) = @_;
	my $endChars = '{)(*&%$#@!}';
	my $vercTxt = "EOV"<<;
EOV
    open(my $VERCF, '>', $verCFn);
    print $VERCF $vercTxt;
    close($VERCF);
}

sub genMakeFile {
# generate makefile for VCE make
#
	my ($vceBaseName, $vceVer, $vceRel, $vcePatch) = @_;

#	my $vceBaseName = 'VTCU';
#	my $vceVer = 'AL09';
#	my $vceRel = '09A';
#	my $vcePatch = '007';
	my $lnkfBRT = "basicroute_${vceBaseName}.link";
	my $vceProcVer = $vceBaseName . $vceVer . substr($vceRel, -1); # (example $vceProcVer = VTSCAL09A)
	my $targetName = "${vceBaseName}${vceVer}.${vceRel}.P${vcePatch}"; # ($targetName = VTSCAL09.09A.P003)

	my $mkfileTxt=<<"EOV";
#****************************************************************************#
# MX BUILD TOP MAKE FILE
#****************************************************************************# 
GCC_DIR       = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/bin
GCC           = \$(GCC_DIR)/pentium3-gcc
LOCAL_LDFLAGS = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/target/usr/lib/libposixtime.so
LIBRT         = /vobs/pcsoft/mvlcge40/devkit/x86/pentium3/target/lib/librt.so.1
DELIVERY_OBJ  = /vobs/g2bsc/delivery/obj
PATCH_OBJ     = \$(DELIVERY_OBJ)/patch
PF_LIBS       = /usr/local/trace/sdk/lib

################################################################
#DEPENDENCIES                                                  
################################################################
$vceProcVer := $verObjFn  @{[join(" ", @vceMlist)]} 

PHONY : ALL

ALL : $targetName

$targetName : $lnkfBRT \$($vceProcVer)
\tperl /vobs/Tools/data/genVersion.pl $targetName
\t\$(GCC) -o \$@ \$(BASIC_RT_TABLE_TCU) -Wl,--start-group,-R/usr/local/pms/lib,-R\$(PF_LIBS),-R/usr/local/spm/sdk/lib -L\$(DELIVERY_OBJ) -L\$(PATCH_OBJ) -lpmsapilinux -lmx_log_tra -lmp_spm VOSCONF.o \$($vceProcVer) --end-group -lpthread \$(LOCAL_LDFLAGS) \$(LIBRT)\n

# .PHONY target will guarantee that $verObjFn is remade even if it's already existed
.PHONY : $verObjFn
$verObjFn :
\t\$(GCC) -g -mpreferred-stack-boundary=2 -D \$vceBaseName -I/vobs/g2bsc/src/kernel/VOS/inc -I/vobs/g2bsc/src/context -I/vobs/g2bsc/src/inc -c -o /vobs/g2bsc/delivery/obj/VOSCONF.o  $vosconfSrc

EOV
		
    open(my $MAKEF, '>', "makefile");
    print $MAKEF $mkfileTxt;
    close($MAKEF);
}
