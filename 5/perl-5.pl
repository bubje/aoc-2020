#!/opt/local/bin/perl

use strict;
use warnings;

if (scalar(@ARGV) != 1) {
	print "Usage: $0 <INPUTFILE>\n\n";
	exit 1;
}

my($row, $pos, $number, $maxnr, %seats);
$maxnr = 0;

open(FILE, '<', $ARGV[0]) or die "Error: $!";
while(my $s = <FILE>) {
	$row = substr($s, 0, 7);
	$pos = substr($s, 7, 3);
	$row =~ tr/F/0/;
	$row =~ tr/B/1/;
	$pos =~ tr/L/0/;
	$pos =~ tr/R/1/;
	$number = oct('0b' . $row . $pos);
	$row = oct('0b' . $row);
	$pos = oct('0b' . $pos);
	$maxnr = $number if ($number > $maxnr);
	$seats{$number} = 1;
	print "Row: ", $row, ", pos: ", $pos, ", number: ", $number, "\n";
}
	
print "Max number: ", $maxnr, "\n";

for ( my $i = $maxnr; $i > 0; $i--) {
	next if (exists($seats{$i}));
	# so seat does not exist
	if (exists($seats{$i-1})) {
		# found our seat
		print "Your seat is: ", $i, "\n";
		last;
	}
}
