#!/usr/bin/perl
# TASK
#   Calculate compound HSV feColorMatrix for svg filter
#   http://www.w3.org/TR/SVG11/filters.html#feColorMatrixElement
#
# USAGE
#   ./hsv-matrix.pl HUE(degrees) SATURATION VALUE


use strict;
use warnings;


my $hue = $ARGV[0]*3.14159/180.0;
my $sat = $ARGV[1];
my $val = $ARGV[2];


# Luminance vectors
my @lum = (0.2126, 0.7152, 0.0722);
my @inv = (1.0-$lum[0], 1.0-$lum[1], 1.0-$lum[2]);


# Hue transformation matrix
my @h = (
	[$lum[0]+cos($hue)*$inv[0]-sin($hue)*$lum[0],
	 $lum[1]-cos($hue)*$lum[1]-sin($hue)*$lum[1],
	 $lum[2]-cos($hue)*$lum[2]+sin($hue)*$inv[2]],

	[$lum[0]-cos($hue)*$lum[0]+sin($hue)*0.143,
	 $lum[1]+cos($hue)*$inv[1]+sin($hue)*0.140,
	 $lum[2]-cos($hue)*$lum[2]-sin($hue)*0.283],

	[$lum[0]-cos($hue)*$lum[0]-sin($hue)*$inv[0],
	 $lum[1]-cos($hue)*$lum[1]+sin($hue)*$lum[1],
	 $lum[2]+cos($hue)*$inv[2]+sin($hue)*$lum[2]]
);


# Saturation transformation matrix
my @s = (
	[$lum[0]+$inv[0]*$sat, $lum[1]-$lum[1]*$sat, $lum[2]-$lum[2]*$sat],
	[$lum[0]-$lum[0]*$sat, $lum[1]+$inv[1]*$sat, $lum[2]-$lum[2]*$sat],
	[$lum[0]-$lum[0]*$sat, $lum[1]-$lum[1]*$sat, $lum[2]+$inv[2]*$sat]
);


# Print feColorMatrix (HxSxV)
my $f = '%.2f';
printf("$f $f $f 0 0 $f $f $f 0 0 $f $f $f 0 0 0 0 0 1 0\n",
	($h[0][0]*$s[0][0]+$h[0][1]*$s[1][0]+$h[0][2]*$s[2][0])*$val,
	($h[0][0]*$s[0][1]+$h[0][1]*$s[1][1]+$h[0][2]*$s[2][1])*$val,
	($h[0][0]*$s[0][2]+$h[0][1]*$s[1][2]+$h[0][2]*$s[2][2])*$val,

	($h[1][0]*$s[0][0]+$h[1][1]*$s[1][0]+$h[1][2]*$s[2][0])*$val,
	($h[1][0]*$s[0][1]+$h[1][1]*$s[1][1]+$h[1][2]*$s[2][1])*$val,
	($h[1][0]*$s[0][2]+$h[1][1]*$s[1][2]+$h[1][2]*$s[2][2])*$val,

	($h[2][0]*$s[0][0]+$h[2][1]*$s[1][0]+$h[2][2]*$s[2][0])*$val,
	($h[2][0]*$s[0][1]+$h[2][1]*$s[1][1]+$h[2][2]*$s[2][1])*$val,
	($h[2][0]*$s[0][2]+$h[2][1]*$s[1][2]+$h[2][2]*$s[2][2])*$val);
