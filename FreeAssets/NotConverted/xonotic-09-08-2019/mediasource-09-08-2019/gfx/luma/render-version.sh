#!/bin/sh -e
# TASK
#   Render menu background layers with VERSION string
#
# NOTES
#   It is necessary to have the Xolonium font installed on the system,
#   because svg rendering tools cannot handle embedded or linked fonts.
#   To compensate for filter rendering errors and to reduce rbg noise,
#   the svg files are rendered at a large size and then scaled down.
#
# DEPENDENCIES
#   rsvg-convert (librsvg 2.39.0)
#   convert (imagemagick 6.8.6-9)
#   Xolonium-Regular font
#
# USAGE
#   ./render-version.sh [--no-font-check] DATADIR VERSION
#
# USAGE EXAMPLE
#   ./render-version.sh ~/.xonotic/data "1.0"


# Check for Xolonium font
if [ "$1" = "--no-font-check" ]; then
	shift
else
	if [ -z "$(fc-list ':family=Xolonium GPL:style=Regular')" ]; then
		echo "Cannot find the Xolonium-Regular font."
		echo "Please install Xolonium before running this script."
		exit 2
	fi
fi


# Check for arguments
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0 [--no-font-check] INPUTDIR OUTPUTDIR VERSION"
	exit 1
fi


input="$1"
output="$2"
version="$3"
svgs="gfx/menu/luma/background_l2.svg
      gfx/menu/luma/background_ingame_l2.svg"


for svg in $svgs; do
	dir="$output/${svg%/*}"
	tga="$output/${svg%.*}.tga"

	mkdir -p "$output"
	sed "s/LUMA/$version/g" "$input/$svg" | rsvg-convert -z 2 | convert - -scale "50%" "$tga"
done
