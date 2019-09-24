#!/bin/sh -e
# TASK
#   Render SVGFILEs from path/filename.svg to DATADIR/path/filename.tga,
#   if they are newer than their target tga file.
#
# NOTES
#   To compensate for filter rendering errors and to reduce rbg noise,
#   the svg files are rendered at a large size and then scaled down.
#
# DEPENDENCIES
#   rsvg-convert (librsvg 2.39.0)
#   convert (imagemagick 6.8.6-9)
#
# USAGE
#   ./render-svg.sh DATADIR [SVGFILE...]
#
# USAGE EXAMPLES
#   Single file: ./render-svg.sh ~/.xonotic/data gfx/menu/luma/cursor.svg
#   All files:   ./render-svg.sh ~/.xonotic/data $(find . -name "*.svg")


# Check for arguments
if [ -z "$1" ] || [ "${1##*.}" = "svg" ]; then
	echo "Usage: $0 DATADIR [SVGFILE...]"
	exit 1
fi


data="$1"; shift
maxScale=8
maxPixels=100000000


for svg in "$@"; do
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
