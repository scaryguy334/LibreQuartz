#!/usr/bin/perl
# TASK
#   Calculate the relative luminance of a color
#   http://www.w3.org/TR/WCAG20/Overview.html#relativeluminancedef
#
# USAGE
#   ./luminance.pl RRGGBB


use strict;
use warnings;


my $r = hex(substr($ARGV[0], 0, 2)) / 255;
my $g = hex(substr($ARGV[0], 2, 2)) / 255;
my $b = hex(substr($ARGV[0], 4, 2)) / 255;


if ($r <= 0.03928) { $r = $r/12.92; } else { $r = (($r+0.055)/1.055) ** 2.4; }
if ($g <= 0.03928) { $g = $g/12.92; } else { $g = (($g+0.055)/1.055) ** 2.4; }
if ($b <= 0.03928) { $b = $b/12.92; } else { $b = (($b+0.055)/1.055) ** 2.4; }


printf("%.4g\n", 0.2126*$r + 0.7152*$g + 0.0722*$b);
