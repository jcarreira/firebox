#!/usr/bin/perl

use strict;
use warnings;

for my $i (1..16) {
	print "Getting file from f$i\n";
	`scp joao\@fbox.millennium.berkeley.edu:~/dstat_data/out_f$i data/data_original/`;
	`tail -n+7 data/data_original/out_f$i > data/data_original/metrics_$i`;
	`Rscript plot.r $i data/data_original/metrics_$i data/data_results/plot_f$i.pdf`;
	`rm data/data_original/out_f$i`;
}

my $cmd = "pdftk data/data_results/plot*.pdf cat output - > data/data_results/nodes_usage.pdf";
print "$cmd\n";
`$cmd`;


