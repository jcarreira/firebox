#!/usr/bin/perl

use strict;
use warnings;

use Sys::Hostname;
my $host = hostname;

die "run_dstat.pl <username>" unless scalar @ARGV == 1;

my $USER = $ARGV[0];

`dstat -cdngymrstl --output /home/eecs/$USER/tmp_dstat/out_$host >/dev/zero`;

