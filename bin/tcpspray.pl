#!/usr/bin/perl -w

use strict;
local $| = 0;

my $n = 16;

my($dst) = @ARGV;
my($dport) = 80;

chomp $dst;

for (my $i=1;$i<=$n;$i++){
    print `nmap -oX - -sT -p${dport} -n ${dst}`;
}
