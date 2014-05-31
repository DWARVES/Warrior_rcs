#!/usr/bin/perl

use warnings;
use strict;
use Path::Class;

my $dir = dir('.');
while (my $file = $dir->next()) {
    next if $file->is_dir();
    my $name = $file->stringify;
    next if $name !~ m/.*\.png/;
    next if $name =~ m/\w+_\d+\.png/;
    print "Flopping $name.\n";
    `convert $name -flop $name`;
}

