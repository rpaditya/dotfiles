#!/usr/bin/perl -w

use strict;
local $| = 1;

use POSIX;
use MP3::Info; # import module

my @files = <*.mp3>; # find MP3 files in current directory

my(@tracknum);
my($tracks);
for my $file (@files) {
	my $tag = get_mp3tag($file) or die "No TAG info";
	$tracks->{$file}->{'ARTIST'} = $tag->{'ARTIST'};
	$tracks->{$file}->{'TITLE'} = $tag->{'TITLE'};

	my($num) = $tag->{'TRACKNUM'};
	$num =~ s/\/\d+//g;

	$tracknum[$num] = $file;
	my $info = get_mp3info($file);
	$tracks->{$file}->{'SECS'} = ceil($info->{'SECS'});
}

print <<HEADER;
#EXTM3U
HEADER

for (my $i = 1; $i <= $#tracknum; $i++){
	my($t) = $tracknum[$i];
	print <<ENTRY
#EXTINF:$tracks->{$t}->{'SECS'}, $tracks->{$t}->{'ARTIST'} - $tracks->{$t}->{'TITLE'}
${t}
ENTRY
}
