#!/bin/sh -e
# TASK
#   Render crosshairs from gfx/crosshair*.svg to DATADIR/gfx/crosshair*.tga,
#   if they are newer than their target tga file.
#
# NOTES
#   To compensate for filter rendering errors and to reduce rbg noise,
#   the svg files are rendered at a large size and then scaled down.
#
# DEPENDENCIES
#   rsvg-convert (librsvg)
#   convert (imagemagick)
#
# USAGE
#   ./render-svg.sh DATADIR
#
# USAGE EXAMPLE
#   ./render-crosshairs.sh ~/.xonotic/data


# Check for argument
if [ -z "$1" ]; then
	echo "Usage: $0 DATADIR"
	exit 1
fi


data="$1"; shift
maxScale=8
maxPixels=100000000


for svg in gfx/*.svg; do
	ext="${svg##*.}"
	dir="$data/${svg%/*}"
	tga="$data/${svg%.*}.tga"

	if [ "$ext" = "svg" ] && [ -f "$svg" ] && [ "$svg" -nt "$tga" ]; then
		echo "Rendering $tga"

		w=$(identify -format "%w" "$svg")
		h=$(identify -format "%h" "$svg")
		scale=$(echo "s=sqrt($maxPixels/$w/$h);if(s>$maxScale)s=$maxScale;s" | bc)

		mkdir -p "$dir"
		rsvg-convert -z "$scale" "$svg" | convert - -scale "$w" "$tga"
	fi
done
