#!/usr/bin/perl -w

use strict;
local $| = 1;

#send folders in comma separated 
my($repo, $fldrs) = @ARGV;

my($USER) = $ENV{'USER'};

#print $repo . "|" . $fldrs . "|\n";

if (defined $fldrs && $fldrs ne ""){
    my(@folders) = split(',', $fldrs);
    my($flist) = "\"" . join('","', @folders) . "\"";

    for my $f (@folders){
	chomp $f;
	`logger -p info "${USER} rebuilding due to invalid imap folder uid: ${f}"`;
	print `rm -fr ~/.offlineimap/Account-${repo}/LocalStatus/${f}`;
	print `rm -fr ~/.offlineimap/Repository-${repo}/FolderValidity/${f}`;
    }

    print `offlineimap -o -u ttyui -a ${repo} -f ${flist}`;
}
