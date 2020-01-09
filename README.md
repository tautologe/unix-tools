# Unix Toolset

## Modern tools

Files:
* exa (ls replacement): https://github.com/ogham/exa
* fzf (fuzzy file finder): https://github.com/junegunn/fzf
* fd (find replacement): https://github.com/sharkdp/fd
* bat (cat replacement): https://github.com/sharkdp/bat
* rg (grep replacement) https://github.com/BurntSushi/ripgrep

Networking:
* mtr (combines tracepath and ping)
* httpie (curl replacement): `apt install httpie`, https://github.com/jakubroztocil/httpie


## Historic tools
* ed, 1969 (https://sanctum.geek.nz/arabesque/actually-using-ed/)
* ex/vi, 1976 (https://sanctum.geek.nz/arabesque/using-more-of-ex/)


# Useful commands
## Filesystem

* make finding files with same md5sum easier:

```
find . -name "*.xml" -exec md5sum {} \; | sort
```

## Images

**Create pdf from images:**

`convert *.jpg -compress jpeg -resize 1240x1753 -units PixelsPerInch -density 150x150 -page a4 output.pdf` 

**Create video from images (requires images named `image-1.jpg`, `image-2.jpg`, ...):**

`ffmpeg -framerate 4 -i image-%00d.jpg -c:v libx264 -s hd720 -pix_fmt yuv420p output.mp4`

http://trac.ffmpeg.org/wiki/Slideshow

**Rename photos according to date**:

* change EXIF-Date (if camera configuration incorrect):

`exiftool -AllDates+=02:00:00 *.JPG`

* Rename files:

`exiftool -r '-FileName<CreateDate' -d 'IMG_%Y%m%d_%H%M%S%%-c.jpg' .`

