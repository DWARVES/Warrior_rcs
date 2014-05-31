#!/usr/bin/perl

use strict;
use warnings;
my $ratio = 2 / 476;

open FD,">","hotpoints" or die "Couldn't open hotpoints";

my @files = split ' ',`ls`;
for my $file (@files) {
    chomp $file;
    next if $file !~ m/\.png$/;
    my $w = `getW $file`;
    chomp $w;
    my $h = `getH $file`;
    chomp $h;
    my $hpx = $w / 2;
    my $hpy = $h - 1;
    my $ph  = $h * $ratio;
    print FD "$file $hpx $hpy $ph\n";
}
close FD;

