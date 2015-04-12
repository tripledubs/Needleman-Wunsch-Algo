#!/usr/bin/env perl
use strict;
use warnings;

my $seq1 = $ARGV[0] // 'GCATGCU';
my $seq2 = $ARGV[1] // 'GATTACA';

if (!$seq1 or !$seq2) {
	die "Must present two strings on command line";
}

my $gap_penalty = -1;
my $scoreMatrix;

my @lettersA = split //, $seq1;
my @lettersB = split //, $seq2;

# Fill out initial values
# Example:
#         G   C   A   T   G   C   U
#     0   -1  -2  -3  -4  -5  -6  -7
#  G -1   
#  A -2
#  T -3
#  T -4
#  A -5
#  C -6
#  A -7

for (my $i=0; $i < length($seq1)+ 1 ; $i++) {
	$scoreMatrix->[$i][0] = $i * $gap_penalty;
	$scoreMatrix->[0][$i] = $i * $gap_penalty;
}


my $tracebackMatrix;
$tracebackMatrix->[0][0] = 'Diagonal';

for (my $i = 1; $i < length($seq1)+ 1; $i++) {
 for (my $j = 1; $j < length($seq2) + 1; $j++) {
	 no warnings;
	 # Diagonal
	 my $match = 
		 $scoreMatrix->[$i-1][$j-1] + 
		 score($lettersA[$i-1],$lettersB[$j-1]);

	 # up
	 my $delete = $scoreMatrix->[$i-1][$j] + $gap_penalty ;

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


while ( $i > 0 or $j > 0) {
	no warnings;
	if ($i > 0 && $j > 0 && $tracebackMatrix->[$i][$j] eq 'Diagonal') {
		$alignA = $lettersA[$i-1] . $alignA;
		$alignB = $lettersB[$j-1] . $alignB;
		$i--;
		$j--;
	} elsif ($i > 0 &&  $tracebackMatrix->[$i][$j] eq 'Up') {
		$alignA = $lettersA[$i-1] . $alignA;
		$alignB = '-' . $alignB;
		$i--;
	} else {
		$alignA = '-' . $alignA;
		$alignB = $lettersB[$j-1]. $alignB;
		$j--;
	}
}

sub score {
	my ($letterA, $letterB) = @_;
	return -1 if (!$letterB); # Only received one letter
	return -1 if (!$letterA); # Only received one letter
	return 1 if ($letterA eq $letterB); #Match
	return -1 if ($letterA ne $letterB); # Mismatch
}

sub max {
	my ($max, @vars) = @_;
	for (@vars) {
		$max = $_ if ($_ > $max);
	}
	return $max;
}

print "Best alignment for $seq1: $alignA\n";
print "Best alignment for $seq2: $alignB\n";

