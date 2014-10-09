#!/usr/bin/perl

use strict;
use warnings;

die "perl kill_dstat <username>" unless scalar @ARGV == 1;

my $USER = $ARGV[0];

# ugly and dirty
for my $i (1..5) {
    my $cmd = "ps aux | grep $USER | grep dstat | grep -v grep | grep -v kill_dstat | perl -lane 'print \$F[1]' | xargs kill -9";
    `$cmd`;
}
