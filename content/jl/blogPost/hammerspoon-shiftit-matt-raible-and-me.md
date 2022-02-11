title=Shiftit Died, I cried, and Raible Matt Tried To Help!
date=2022-02-02   
type=post
tags=blog
status=published
~~~~~~

I upgraded to macOs Monterey 12.2 and my beloved window manager of choice Shiftit stopped working. I was stuck, inert, unable to move windows, like some sort of heathen! 

I talked to Matt Raible who showed me hammerspoon which I installed use ye ol' package manager Homebrew: `brew install --cask hammerspoon`. I wanted it to work like Shiftit did, so after installing it, 
I installed [the Shiftit Spoon](https://github.com/peterklijn/hammerspoon-shiftit#spooninstall) and then used [Matt's `init.lua`](https://gist.githubusercontent.com/mraible/3d3f3556648e9aff3a2acf5267ad64bd/raw/f64543b9fce27bf18060c7fd7005cc763c579845/init.lua) and put that in `~/.hammerspoon/init.lua`. 

Once I went to the hammerspoon preferences and reloaded the configuration, everything worked a charm. Thanks, [Matt](https://twitter.com/mraible)!
