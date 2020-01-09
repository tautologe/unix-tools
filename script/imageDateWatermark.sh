#!/bin/bash

print_usage() { 
    echo "Adds watermark of the exif date to all images with name pattern "image*.jpg" in given source folder." 
    echo "Usage: ./imageDateWatermark.sh./some/folderWithImages"
}

if [  $# -lt 1 ]; then 
    print_usage; exit 1
fi

sourceDir="$1"

function addWatermark {
    ImageFilename="$1"
    TargetFilename="watermark_$ImageFilename"
 
    # read exif date
    DateTimeOriginal=`exiftool -d "%d.%m.%Y" -DateTimeOriginal -S -s $ImageFilename`
    echo "Processing $ImageFilename. Draw '$DateTimeOriginal' to $TargetFilename"

    # draw date string to image, save as watermark_$file
    convert -resize 3264x1836! -font Helvetica-Bold -pointsize 140 -fill white -draw "text 0, 1816 '$DateTimeOriginal'" "$ImageFilename" "$TargetFilename"
}

cd $sourceDir
for Image in image*.jpg; do
    addWatermark "$Image"
done

echo "Done."
exit
