title=Converting `.mp4` to `.gif`
date=2016-10-14
type=post
tags=blog
status=published
~~~~~~

I know there are probably a million worthy solutions to this, but I've found one that works so I thought I'd share it with others:

```
#!/bin/bash

mp4_to_gif (){
  fn=$1
  frames=`mktemp -d`
  mkdir $frames
  out=$2
  ffmpeg -i $fn -vf scale=320:-1:flags=lanczos,fps=10 $frames/ffout%03d.png
  convert -loop 0 $frames/ffout*.png $out
  rm -rf $frames
}

mp4_to_gif dogs.mp4 dogs.gif

```

Make sure you've got `imagemagick` and `ffmpeg` and `ghostscript` installed on your machine. On OS X/macOS Sierra: `brew install imagemagick ffmpeg ghostscript` will do the trick.  Why is this useful? Well, reusing funny content on Twitter for posts to Google Hangouts is my use case. Perhaps there are others..
