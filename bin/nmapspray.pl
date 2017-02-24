#!/usr/bin/perl -w

use strict;
local $| = 1;

# eg:
# ./nmapspray.pl --count 2 --dip 65.52.218.82 --dport 11046,11003 --sport 8500
# 1:8501: 11046/tcp open  unknown
# 1:8501: 11003/tcp open  unknown
# 2:8502: 11046/tcp open  unknown
# 2:8502: 11003/tcp open  unknown
# dstip 65.52.218.82 destport 11046 state open: 2
# dstip 65.52.218.82 destport 11003 state open: 2

use Getopt::Long;
my($count)=64;
my($startport) = 8500;
my($dest, $dport);
my($verbose) = 0;

GetOptions ("count=i" => \$count,    # numeric
	    "dip=s"   => \$dest,      # string
	    "sport=i" => \$startport,
	    "dport=i" => \$dport,
	    "verbose"  => \$verbose)   # flag
    or die("Error in command line arguments\n");

chomp($dest);
chomp($dport);

my(@dports) = split(/\,/, $dport);

my(%stats);
for (my $i=0;$i<$count;$i++){
    my($sport) = $startport + $i;
    my(@ret) =`sudo nmap -v -P0 -p ${dport} -g ${sport} -sS ${dest}`;
    for my $dp (@dports){
	my($latency) = 0;
	for my $l (@ret){
	    chomp $l;
	    if ($l =~ /Host is up \(((\d|\.)+)s latency\)\./){
		$latency = $1;
	    }
	    
	    if (! $verbose){
		next unless ($l =~ /^${dp}/);
	    }
	    $l =~ /${dp}\/tcp\s+(\w+)\s+/;
	    $stats{$dp}{$1}++;
	    if (! defined $1 && $verbose){
		print "DEBUG:" . $l . "\n";
	    }
	    print $i . ":" . $sport . ": (${latency}s) " . $l . "\n";
	}
    }
}

for my $p (keys %stats){
    for my $state (keys %{$stats{$p}}){
	print <<LLI;
dstip ${dest} destport ${p} state ${state}: $stats{$p}{$state}
LLI
    }
}
