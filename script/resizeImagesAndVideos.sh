#/bin/bash

SOURCE_FOLDER=$1
OUTPUT_PARENT="compressed"

maximum_img_size_kb=1000
maximum_video_size_kb=10000

echo "Started at $(date)"

SECONDS=0

find "$SOURCE_FOLDER" -type f -iname \*.jpg | while read -r file
do    
    # create result dir
    result_dir="$OUTPUT_PARENT/$(dirname "$file")"
    mkdir -p "$result_dir"    
    
    actualsize=$(du -k "$file" | cut -f 1)
    if [ $actualsize -ge $maximum_img_size_kb ]; then
        echo "Converting $file with size ($actualsize KB)..."
        # TODO resize to max 1920 height or width
        convert "$file" -resize 1920\> "$OUTPUT_PARENT/$file"
        echo "Converted file $file $(identify -format "%wx%h" "$file") to $(identify -format "%wx%h" "$OUTPUT_PARENT/$file")"
    else
        echo "Copy $file with size ($actualsize KB)"
        cp "$file" "$OUTPUT_PARENT/$file"
    fi
done

image_duration=$SECONDS

echo "Image processing took $(($image_duration / 60)) minutes."

find "$SOURCE_FOLDER" -type f -iname \*.mp4 | while read -r file
do
    # create result dir
    result_dir="$OUTPUT_PARENT/$(dirname "$file")"
    mkdir -p "$result_dir" 
    
    actualsize=$(du -k "$file" | cut -f 1)
    if [ $actualsize -ge $maximum_video_size_kb ]; then        
        echo "Converting $file with size ($actualsize KB)"
        # < /dev/null is needed to avoid ffmpeg screwing up with std input
        # -vf "scale='min(640,iw)':-2" means it scales the width to the minimum of 640px or the input width, height must fit the aspect ratio of the input image (-2 is set because Some codecs require the size of width and height to be a multiple of n)
        # -loglevel error to avoid printing too much information
        # -y to overwrite existing files, set to -n instead if existing files should not be overwritten
        # See https://trac.ffmpeg.org/wiki/Scaling for more information        
        < /dev/null ffmpeg -i "$file" -vf "scale='min(640,iw)':-2" -loglevel error -n "$OUTPUT_PARENT/$file"
    else
        echo "Copy $file with size ($actualsize KB)"
        cp "$file" "$OUTPUT_PARENT/$file"
    fi
done

echo "Finished at $(date)"

overall_duration=$SECONDS

echo "Processing images and videos took $(($overall_duration / 60)) minutes"

