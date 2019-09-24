#!/usr/bin/perl
# TASK
#   Convert color value from hexadecial to floating point and vice versa.
#
# USAGE
#   ./color-convert.pl [RRGGBB | R.R G.G B.B]


use strict;
use warnings;


if (@ARGV == 1)
{
	printf("%.2g %.2g %.2g\n",
		hex(substr($ARGV[0], 0, 2)) / 255,
		hex(substr($ARGV[0], 2, 2)) / 255,
		hex(substr($ARGV[0], 4, 2)) / 255);

}
elsif (@ARGV == 3)
{
	printf("%02x%02x%02x\n",
		int($ARGV[0]*255 + 0.5),
		int($ARGV[1]*255 + 0.5),
		int($ARGV[2]*255 + 0.5));
}
