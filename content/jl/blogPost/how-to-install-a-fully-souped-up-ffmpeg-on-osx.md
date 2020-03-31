title=How to Install FFMPEG with _ALL_ the Options using Homebrew on macOS
date=2018-09-28
type=post
tags=blog
status=published
~~~~~~

I needed `libtheora` support in my macOS / OSX install of `ffmpeg`. I installed `ffmpeg` using [Homebrew](http://homebrew.io) but needed to add theora support.

I found this handy recipe which gives me an `ffmpeg` that supports _tons_ of options!

```sh
brew install ffmpeg $(brew options ffmpeg | grep -vE '\s' | grep -- '--with-' | tr '\n' ' ')
```

If you already have `ffmpeg` installed you can remove it or just change the above command to be `brew reinstall ...`.
