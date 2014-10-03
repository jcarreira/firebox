#!/usr/bin/perl

use strict;
use warnings;

my %tid_to_node; # task id to node num
my %tid_to_start; # task id to start time
my $starting_time; # starting time (sec) of run
my $is_first_start = 1; # first loop?

my %start_per_node; # start times per node
my %finish_per_node; # finish times per node
my $max_finish_time = 0; # last time recorded

# Constants
my $START_TIME = 1;
my $END_TIME = $START_TIME + 1;
my $NUM_NODES = 16;

sub max { return $_[0] > $_[1] ? $_[0] : $_[1] }

# translate hh:mm:ss to seconds
sub time_to_seconds {
    my $hour = shift;
    my $minute = shift;
    my $seconds = shift;

    return ($hour * 60 * 60) +
    ($minute * 60) + $seconds;
}

# initialize start_per_node and finish_per_node
for (1..16) {
    $start_per_node{$_} = [];
    $finish_per_node{$_} = [];
}

while (<>) {

    # process starting task entries
    if ($_ =~ /(\d\d):(\d\d):(\d\d).* Starting task .*TID (\d+), f(\d\d?)/) {
        #print "Start: $_\n";
        my $hour = $1;
        my $minute = $2;
        my $second = $3;

        $tid_to_node{$4} = $5;
        $tid_to_start{$4} = time_to_seconds($1, $2, $3);
        if ($is_first_start) { # record the starting time
            $is_first_start = 0;
            $starting_time = time_to_seconds($1, $2, $3);
        }
    }

    # process finish entries
    elsif ($_ =~ /(\d\d):(\d\d):(\d\d).* Finished task .*TID (\d+)/) {
        #print "Finish $1 $2\n";

        my $tid = $4;
        my $node = $tid_to_node{$tid};

        die unless defined $node;
        die unless defined $tid_to_start{$tid};

        my $start_time = $tid_to_start{$tid} - $starting_time;
        my $end_time = time_to_seconds($1, $2, $3) - $starting_time;
        
        push @{$start_per_node{$node}}, $start_time;
        push @{$finish_per_node{$node}}, $end_time;

        $max_finish_time = max($end_time, $max_finish_time); # compute last end time
    }
}

my $first_print = 1;

#1. print labels
print "library(plotrix)\n";
print "info2<-list(labels=c(";
for (1..$NUM_NODES) {
    my $node = $_;
    my @start_times = @{$start_per_node{$_}};
    my @finish_times = @{$finish_per_node{$_}};

    next unless scalar @start_times;

    if ($first_print) {
        $first_print = 0;
        shift @start_times;
        print "\"Node$node\"";
    }

    for my $start_time (@start_times) {
        print ",\"Node$node\"";
    }
}
print "),\n";

# print starts
print "starts=c(0";
for my $run (1..$NUM_NODES){
    for (($run == 1 ? 1 : 0)..$max_finish_time) {
        print ",$_";
    }
}
print "),\n";

# print ends
print "ends=c(1";
for my $run (1..$NUM_NODES){
    for (($run == 1 ? 2 : 1)..$max_finish_time) {
        print ",$_";
    }
}
print "),\n";

my %total_times;
for my $node (1..$NUM_NODES) {
    my @start_times = @{$start_per_node{$_}};
    my @finish_times = @{$finish_per_node{$_}};

    for (@start_times) {
        push @{$total_times{$node}}, \($_, $START_TIME);
    }
    for (@finish_times) {
        push @{$total_times{$node}}, \($_, $END_TIME);
    }
}

for my $node (1..$NUM_NODES) {
    my @sorted_times = sort { 
        my @a_ = @{$a}; 
        my @b_ = @{$b}; 
        return $a_[0] <=> $b_[0]; 
    } @{$total_times{$node}};
}

my %num_tasks_per_node; # per node holds a list of tasks per second
# go sec by sec and record the number of tasks running on each node
for my $node (1..$NUM_NODES) {
# defines the period we are looking at
    my $start_tasks_time = 0; 
    my $num_tasks = 0; # we start with 0 tasks

    my @node_times_list = @{$total_times{$node}};

    while (1) {
        my $initial_time = ${@{$nodes_times_list[0]}}[0]; # get time from pair <time, type of time>
        while ($start_tasks_time < $initial_time # go until next time record
        && $start_tasks_time < $max_finish_time) { # stop when reaching the last record
            $start_tasks_time++; # advance one second
            push @{$num_tasks_per_node{$node}}, $num_tasks;
        }

        while ($start_tasks_time <= $initial_time) {
            my $time_type = 
        }

        last if $start_tasks_time == $max_finish_time;
    }
}


##$first_print = 1;
#2. print starts
##print "starts=c(";
##for (1..16) {
##    my $node = $_;
##    my @start_times = @{$start_per_node{$_}};
##    my @finish_times = @{$finish_per_node{$_}};
##
##    next unless scalar @start_times;
##
##    if ($first_print) {
##        $first_print = 0;
##        my $start_time = shift @start_times;
##        print "$start_time";
##    }
##
##    for my $start_time (@start_times) {
##        print ",$start_time";
##    }
##}
##print "),\n";
##
##$first_print = 1;
###3. print starts
##print "ends=c(";
##for (1..16) {
##    my $node = $_;
##    my @start_times = @{$start_per_node{$_}};
##    my @finish_times = @{$finish_per_node{$_}};
##
##    next unless scalar @start_times;
##
##    if ($first_print) {
##        $first_print = 0;
##        my $finish_time = shift @finish_times;
##        print "$finish_time";
##    }
##
##    for my $finish_time (@finish_times) {
##        print ",$finish_time";
##    }
##}

        my @number_of_tasks;

        print "))\n\n";
#print "gantt.chart(info2,vgridlab=0:$max_finish_time,vgridpos=0:$max_finish_time, main=\"Node utilization\",taskcolors=\"lightgray\")";
        print "gantt.chart(info2,vgridlab=0:$max_finish_time,vgridpos=0:$max_finish_time, main=\"Node utilization\",";

#            taskcolors=c(2,3,7,4,8,5,3,6,"purple"),border.col="black")

        <Start (time), End (time), Start (time), Start(time)>

