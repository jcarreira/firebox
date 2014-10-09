#!/usr/bin/perl

use strict;
use warnings;
use Math::Round;

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

    return ($hour * 60 * 60) + ($minute * 60) + $seconds;
}

my %num_tasks_per_node; # per node holds a list of tasks per second
my %total_times;
# initialize start_per_node and finish_per_node
for (1..$NUM_NODES) {
    $start_per_node{$_} = [];
    $finish_per_node{$_} = [];
    $total_times{$_} = [];
    $num_tasks_per_node{$_} = [];
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
for my $node (1..$NUM_NODES) {

    my $start_point = 1;
    if ($first_print) {
        $first_print = 0;
        $start_point = 2;
        print "\"Node$node\"";
    }
    for ($start_point..$max_finish_time) {
        print ",\"Node$node\"";
    }
}
print "),\n";

# print starts
print "starts=c(0";
for my $run (1..$NUM_NODES){
    for (($run == 1 ? 1 : 0)..$max_finish_time-1) {
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
print "))\n\n";

for my $node (1..$NUM_NODES) {
    my @start_times = @{$start_per_node{$node}};
    my @finish_times = @{$finish_per_node{$node}};

    for (@start_times) {
        push @{$total_times{$node}}, [$_, $START_TIME];
    }
    for (@finish_times) {
        push @{$total_times{$node}}, [$_, $END_TIME];
    }
}

my %total_sorted_times;
for my $node (1..$NUM_NODES) {
    my @sorted_times = sort { 
        my @a_ = @{$a}; 
        my @b_ = @{$b}; 
        return $a_[0] <=> $b_[0]; 
    } @{$total_times{$node}};

    $total_sorted_times{$node} = \@sorted_times;
}

# go sec by sec and record the number of tasks running on each node
for my $node (1..$NUM_NODES) {
# defines the period we are looking at
    my $start_tasks_time = 0; 
    my $num_tasks = 0; # we start with 0 tasks

    my @node_times_list = @{$total_sorted_times{$node}}; # list of <time, time type>

    while (1) {
        last unless scalar @node_times_list > 0; # if there are no records exit

        my @first_pair = @{$node_times_list[0]};
        my $next_time = $first_pair[0]; # get time from pair <time, type of time>

        while ($start_tasks_time < $next_time # go until next time record
        && $start_tasks_time < $max_finish_time) { # stop when reaching the last record
            $start_tasks_time++; # advance one second
            push @{$num_tasks_per_node{$node}}, $num_tasks;
            #   print "$max_finish_time $next_time start_tasks_time: $start_tasks_time ", scalar  @{$num_tasks_per_node{$node}}, "\n";
        }

        while ($start_tasks_time == $next_time) {
            #print "$next_time\n";
            my $time_type = $first_pair[1];

            if ($time_type == $START_TIME)  {
                $num_tasks++;
            } elsif ($time_type == $END_TIME) {
                $num_tasks--;
            } else { die; }
            die unless $num_tasks >= 0;

            shift @node_times_list;
            last if scalar @node_times_list == 0;
            @first_pair = @{$node_times_list[0]};
            $next_time = $first_pair[0]; # get time from pair <time, type of time>
        }

        #     print "ending $start_tasks_time\n" if $start_tasks_time == $max_finish_time;
        last if $start_tasks_time == $max_finish_time;
        #print "$start_tasks_time $next_time $max_finish_time\n";
    
    }

    # some nodes may not have task spanning the whole time spectrum
    while (scalar @{$num_tasks_per_node{$node}} < $max_finish_time) {
        push @{$num_tasks_per_node{$node}}, 0;
    }

    #print "node: $node\n" unless scalar @{$num_tasks_per_node{$node}} == $max_finish_time;
    print scalar @{$num_tasks_per_node{$node}} unless scalar @{$num_tasks_per_node{$node}} == $max_finish_time;
    die unless scalar @{$num_tasks_per_node{$node}} == $max_finish_time;
}

my @colors=(
    "#FFFFFF",
    "#E8E8E8",
    "#D8D8D8",
    "#C8C8C8",
    "#B8B8B8",
    "#A8A8A8",
    "#989898",
    "#888888",
    "#707070",
    "#686868",
    "#585858",
    "#505050",
    "#404040",
    "#303030",
    "#202020",
    "#101010",
    "#000000");


print "gantt.chart(info2,priority.extremes=c(\"High task utilization\",\"Low task utilization\"), priority.legend=FALSE,priority.label=\"Legend colors\", vgridlab=0:$max_finish_time,vgridpos=0:$max_finish_time, main=\"Node utilization\",taskcolors=c(";
for my $node (1..$NUM_NODES) {
    #print "Node $node: ";
    
    die unless scalar @{$num_tasks_per_node{$node}} == $max_finish_time;

    for (@{$num_tasks_per_node{$node}}) {
        print ",\"",$colors[$_], "\"";
        #round($_/(16.0*1.0)*7.0);
    }
}
#            taskcolors=c(2,3,7,4,8,5,3,6,"purple"),border.col="black")
print "))\n\n";

