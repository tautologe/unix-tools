# unix-tools

Files:
* exa (ls replacement): https://github.com/ogham/exa
* fzf (fuzzy file finder): https://github.com/junegunn/fzf

Networking:
* mtr (combines tracepath and ping)

* httpie (curl replacement): `apt install httpie`, https://github.com/jakubroztocil/httpie



# Useful commands

Create video from images (requires images named `image-1.jpg`, `image-2.jpg`, ...):

`ffmpeg -framerate 4 -i image-%00d.jpg -c:v libx264 -s hd720 -pix_fmt yuv420p output.mp4`


Rename photos according to date:

* change EXIF-Date (if camera configuration incorrect):

`exiftool -AllDates+=02:00:00 *.JPG`

* Rename files:

`exiftool -r '-FileName<CreateDate' -d 'IMG_%Y%m%d_%H%M%S%%-c.jpg' .`
