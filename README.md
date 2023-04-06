# Unix Toolset

## Modern tools

https://github.com/ibraheemdev/modern-Unix

Files:
* exa (ls replacement): https://github.com/ogham/exa
* broot (directory navigation): https://github.com/Canop/broot
* fzf (fuzzy file finder): https://github.com/junegunn/fzf
* fd (find replacement): https://github.com/sharkdp/fd
* bat (cat replacement): https://github.com/sharkdp/bat
* rg (grep replacement) https://github.com/BurntSushi/ripgrep
* fdupes (finding duplicated files) https://github.com/adrianlopezroche/fdupes

Networking:
* mtr (combines tracepath and ping)
* httpie (curl replacement): `apt install httpie`, https://github.com/jakubroztocil/httpie

Other
* shellcheck (check shell scripts for common errors): https://www.shellcheck.net/
* explainshell (enter command and get man page extract for parameters): https://explainshell.com/

## Historic tools
* ed, 1969 (https://sanctum.geek.nz/arabesque/actually-using-ed/)
* ex/vi, 1976 (https://sanctum.geek.nz/arabesque/using-more-of-ex/)
* Unix command line conventions over time (https://blog.liw.fi/posts/2022/05/07/unix-cli/)
* What exactly is TTY? https://www.sobyte.net/post/2022-05/tty/

# Learning
## Howto

* Unix as an IDE https://sanctum.geek.nz/arabesque/series/unix-as-ide/
* Writing safe shell scripts https://sipb.mit.edu/doc/safe-shell/
* Tmux Tutorial https://leimao.github.io/blog/Tmux-Tutorial/

## Gamification

* https://cmdchallenge.com/
* https://overthewire.org/wargames/


# Useful commands
## Filesystem

* make finding files with same md5sum easier:

```
find . -name "*.xml" -exec md5sum {} \; | sort
```

* Sync folder for incremental backup; deleting obsolete files in backup, preserving them in ../DELETED_FILES/ (relative to the target dir) for observation
```
rsync -ab --delete --info=progress2 --backup-dir=../DELETED_FILES/ /run/media/user/source/folder/ /run/media/user/target/folder/
```
  * Save disk space using hard links for incremental backups: https://linuxconfig.org/how-to-create-incremental-backups-using-rsync-on-linux


* find the 10 biggest files in subfolders (with zsh globbing)
```zsh
#!/usr/bin/zsh
ls -hlS **/*(.OL[1,10])
```

## Images, Audio, Video

**Create pdf from images:**

`convert *.jpg -compress jpeg -resize 1240x1753 -units PixelsPerInch -density 150x150 -page a4 output.pdf`

**Remove password protection from pdfs:**

* expects qpdf to be installed
* adapt password in this command
* looks for pdfs in same directory, creates out-Folder and puts unencrypted pdfs there

```sh
#!/bin/sh
mkdir -p out/
find . -maxdepth 1 -type f -iname '*.pdf' -printf '%f\0' | xargs -0 -I '{}' qpdf --password="secret"  --decrypt '{}' out/'{}'
```



**Create video from images (requires images named `image-1.jpg`, `image-2.jpg`, ...):**

`ffmpeg -framerate 4 -i image-%00d.jpg -c:v libx264 -s hd720 -pix_fmt yuv420p output.mp4`

http://trac.ffmpeg.org/wiki/Slideshow

**Rename photos according to date**:

* change EXIF-Date (if camera configuration incorrect):

`exiftool -AllDates+=02:00:00 *.JPG`

* Rename files:

`exiftool -r '-FileName<CreateDate' -d 'IMG_%Y%m%d_%H%M%S%%-c.jpg' .`

**Add EXIF-date as watermark to image**

```shell
ImageFilename="image.jpg"
DateTimeOriginal=`exiftool -d "%d.%m.%Y" -DateTimeOriginal -S -s $ImageFilename`
echo "$DateTimeOriginal" # 29.04.2016
convert -resize 3264x1836! -font Helvetica-Bold -pointsize 140 -fill white -draw "text 0, 1816 '$DateTimeOriginal'" "$ImageFilename" "watermark_$ImageFilename"
```
More controls: https://www.hagenfragen.de/programmieren/bash/wasserzeichen-und-exif-datum-in-bilder-einbetten.html

**Concat mp3 files, keep id3 data**
```shell
# create filelist (concatlist.txt)
for f in ./*.mp3; do echo "file '$f'" >> concatlist.txt; done

# extract id3-tag from first file (id3.txt)
ffmpeg -i "$(ls *.mp3 | head -1)" -f ffmetadata id3.txt

# concat files from concatlist using id3 data from file, write to output.mp3
ffmpeg -f concat -safe 0 -i concatlist.txt -i id3.txt -map_metadata 1 -id3v2_version 3 -write_id3v1 1 -c copy  "output.mp3"
```
