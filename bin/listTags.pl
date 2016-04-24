#!/usr/bin/perl

use MP3::Tag; # import module

my(@files) = @ARGV;

# loop over file list
# print tag information
for my $f (@files) {
	my $mp3 = MP3::Tag->new($f);
	$mp3->get_tags();

	if (exists $mp3->{ID3v1}) {
		for my $t (keys %{$mpc->{ID3v1}}){
			print $_, "\t", $mp3->{ID3v1}->artist, "\t", $mp3->{ID3v1}->title, "\n";
			print $t . " : " . $mp3->{ID3v1}->{$t} . "\n";
		}
	}
	$mp3->close();
}
