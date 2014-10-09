# This script is provided as is
# I am not responsible for any consequences :-)

#!/usr/bin/perl

use strict;
use warnings;

die "perl start_bench.pl <username>" unless scalar @ARGV == 1;

my $USER = $ARGV[0];
my $FOLDER_PATH = "/home/eecs/$USER/tmp_dstat/";

sub exit_program {
    print "Terminating!\n";

# kill the dsh instance
# this is bad and ugly
    `ps aux | grep perl | grep dsh | grep $USER | grep run_dstat.pl | perl -lane 'print \$F[1]' | xargs kill -9`;

# terminate dstat in each node
    `dsh -cq -g $USER-cluster -- "perl /home/eecs/joao/dstat_scripts/kill_dstat.pl $USER"`;
    exit 0;
};


$SIG{'INT'} = sub { exit_program };

if (-d $FOLDER_PATH) {
    print "Removing $FOLDER_PATH\n";
    `rm $FOLDER_PATH -rf`;
}

print "Creating $FOLDER_PATH\n";
`mkdir $FOLDER_PATH\n`;

#print "Do you want to remove dstat_data/* (y/n)\n";
#
#my $answer = <STDIN>;
#chomp $answer;
#
#if ($answer eq "y") {
#    print "rm ~/dstat_data/* -f\n";
#    `rm ~/dstat_data/* -f`;
#}

print "Starting benchmark...\n";

# detach dsh

my $pid = fork();

if ($pid == 0) {
    `dsh -cq -g $USER-cluster -- "perl /home/eecs/joao/dstat_scripts/run_dstat.pl $USER"`;
    exit 0;
}

sleep 2; # give dsh some time

print "Do you want to terminate benchmark (y/n)?\n";

while (<STDIN>) {
    chomp;
    if ($_ eq "y") {
        exit_program();
    }
}

