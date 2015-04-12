#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(max);
use Data::Dump;
use Data::Dumper;

my $gap_penalty = -1;
my $scoreMatrix;

my $seq1 = 'GCATGCU';
my $seq2 = 'GATTACA';

my @lettersA = split //, $seq1;
my @lettersB = split //, $seq2;

$scoreMatrix->[0][0] = 0;
my $tracebackMatrix;

for (my $i=0; $i < length($seq1)+ 1 ; $i++) {
	$scoreMatrix->[$i][0] = $i * $gap_penalty;
}

for (my $j=0; $j < length($seq2) + 1; $j++) {
	$scoreMatrix->[0][$j] = $j * $gap_penalty;
}

for (my $i = 1; $i < length($seq1) + 1; $i++) {
 for (my $j = 1; $j < length($seq2) + 1; $j++) {
	 # Diagonal
	 my $match = 
		 $scoreMatrix->[$i-1][$j-1] + 
		 score($lettersA[$i-1],$lettersB[$j-1]);

	 # up
	 my $delete = $scoreMatrix->[$i-1][$j] + $gap_penalty;

	 # left
	 my $insert = $scoreMatrix->[$i][$j-1] + $gap_penalty;

	 my $max = max($match,$delete,$insert);

	 my $whatMatched = '';
	 for ($max) {
		 $whatMatched = 'Left' if ($_ eq $insert);
		 $whatMatched = 'Up' if ($_ eq $delete);
		 $whatMatched = 'Diagonal' if ($_ eq $match);
	 }
	 $scoreMatrix->[$i][$j] = $max;
	 $tracebackMatrix->[$i][$j] = $whatMatched;
 }
}

my $alignA = '';
my $alignB = '';

my $i = length($seq1);
my $j = length($seq2);


dd $scoreMatrix;
dd $tracebackMatrix;

while ( $i > 0 or $j > 0) {
	if ($i > 0 and $j > 0 and $tracebackMatrix->[$i][$j] eq 'Diagonal') {
		$alignA = $lettersA[$i-1] . $alignA;
		$alignB = $lettersB[$j-1] . $alignB;
		$i--;
		$j--;
	} elsif ($i > 0 and $tracebackMatrix->[$i][$j] eq 'Up') {
		$alignA = $lettersA[$i-1] . $alignA;
		$alignB = '-' . $alignB;
		$i--;
	} elsif ($j > 0 and $tracebackMatrix->[$i][$j] eq 'Left') {
		$alignA = '-' . $alignA;
		$alignB = $lettersB[$j-1]. $alignB;
		$j--;
	}
}

print "AlignA: $alignA\n";
print "AlignB: $alignB\n";

sub score {
	my ($letterA, $letterB) = @_;
	return 1 if ($letterA eq $letterB); #Match
	return -1 if ($letterA ne $letterB); # Mismatch
	return -1 if (!$letterB); # Only received one letter
}

