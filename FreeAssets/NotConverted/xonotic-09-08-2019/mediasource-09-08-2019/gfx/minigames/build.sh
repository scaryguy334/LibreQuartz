#!/bin/bash

CONVERT=convert
SED="sed -r"
MKDIR="mkdir -p"

OUT_DIR=../../../data/xonotic-data.pk3dir/
JPEG_QUALITY=75
TEXTURE_SIZE=2048
FORMAT=tga

# Converts images into $FORMAT
# Synopsis: convert_image input.png output
# Genreates output.jpg and output_alpha.jpg
function convert_image()
{
	local covert_flags="-layers flatten"
	if [ "$FORMAT" = "jpg" ]
	then
		covert_flags="$covert_flags -quality $JPEG_QUALITY"
	fi
	convert -background none "$1" $covert_flags "$2.$FORMAT"
	if [ "$FORMAT" = "jpg" ]
	then
		convert -background none "$1" $covert_flags -alpha Extract "$2_alpha.jpg"
	fi
}

# Ensure that the output jpg are of the appropriate size
# Synopsis: scale_image output
# Where "output" is the same as $2 in convert_image
function scale_image()
{
	let max_w=$TEXTURE_SIZE
	
	if echo -n "$1" | grep -q ".*/piece.*"
	then
		let max_w/=4
	fi
	
	if [ "$max_w" -gt 0 ]
	then
		let img_w=$(identify -format %w "$1.$FORMAT")
		if [ "$img_w" -gt "$max_w" ]
		then
			local scale=$(echo "scale=10; $max_w/$img_w*100" | bc)
			convert "$1.$FORMAT" -resize "$scale%" "$1.$FORMAT"
			if [ "$FORMAT" = "jpg" ]
			then
				convert "$1_alpha.jpg" -resize "$scale%" "$1_alpha.jpg"
			fi
		fi
	fi
}

# handle_file src_file out_dir
function handle_file()
{
	local src_file="$1"
	local out_dir="$2"
	local out_file="$out_dir/$src_file"
	$MKDIR "$out_dir/$(dirname "$src_file")"
	
	local file_extension="$(echo "$src_file" | sed -r "s/^(.*)\.([^.]+)$/\2/")"
	local base_file="$(echo "$out_file" | sed -r "s/^(.*)\.([^.]+)$/\1/")"
	
	if echo -n "$file_extension" | grep -Eq "^(png|svg|tga|xcf)$" && 
		[ "$file_extension" != "$FORMAT" ]
	then
		out_file="$base_file.$FORMAT"
		if [ "$src_file" -nt "$out_file" ]
		then
			echo -e "Converting \x1b[1m$src_file\x1b[0m"
			convert_image "$src_file" "$base_file"
			scale_image "$base_file"
			continue
		fi
	elif [ "$src_file" -nt "$out_file" ]
	then
		echo -e "Copying \x1b[1m$src_file\x1b[0m"
		cp -T "$src_file" "$out_file"
		continue
	fi
	
	echo -e "Skipping \x1b[1m$src_file\x1b[0m"
}

# Create the files for packaging
function generate()
{
	for src_file in $(git ls-files '*/*')
	do
		handle_file "$src_file" "$OUT_DIR/gfx/hud/default/minigames/"
	done
	
	for src_file in $(git ls-files '../../models/sprites/minigame*')
	do
		handle_file "$src_file" "$OUT_DIR/models/sprites/"
	done
}

SYSTEM_NAME=$(uname)
if [ "$SYSTEM_NAME" = Darwin -o "$SYSTEM_NAME" = FreeBSD ]
then
	SED="sed -E"
fi


$MKDIR "$OUT_DIR"


while [ "$1" ]
do
	case $1 in
		help|-h|--help)
			echo TODO
			exit
			;;
		clean)
			echo -e "Removing old files"
			[ -n "$OUT_DIR" -a -e "$OUT_DIR" ] && rm -rf "$OUT_DIR"
			;;
		*)
			echo 1>&2 "Unknown option: $1"
			;;
	esac
	shift
done

generate
