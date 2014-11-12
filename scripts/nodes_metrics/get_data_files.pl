#!/usr/bin/perl

# get nodes utilization from the firebox cluster
# plot this data in graphs
# generate pdf

use strict;
use warnings;

my $NODES = 16;
my $USER = 'joao';
my $FIREBOX_URL = 'fbox.millennium.berkeley.edu';

for my $i (1..$NODES) {
	print "Getting file from f$i\n";
	`scp $USER\@$FIREBOX_URL:~/dstat_data/out_f$i data/data_original/`;
	`tail -n+7 data/data_original/out_f$i > data/data_original/metrics_$i`;
	`Rscript plot.r $i data/data_original/metrics_$i data/data_results/plot_f$i.pdf`;
	`rm data/data_original/out_f$i`;
}

my $cmd = "pdftk data/data_results/plot*.pdf cat output - > data/data_results/nodes_usage.pdf";
print "$cmd\n";
`$cmd`;

