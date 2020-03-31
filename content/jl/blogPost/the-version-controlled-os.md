title=The Version Controlled Operating System
date=2016-10-15
type=post
tags=blog
status=published
~~~~~~

I hate having to remember which packages on each new operating system install. I keep a small script called josh-env.sh in a private Github repository (remember, Github now has unlimited private repositories!) that I then make sure is present in my home directory. The script does two things: it contributes important environment variables (typically the environment variables I use to run builds, as I might on the CI server) that are themselves version controlled, and it records the contents of my Homebrew and Homebrew Cask installations into text files and then `git commit` and `git push` those files if the contents have changed.

```
#!/bin/bash

c=`pwd`
d=`dirname $0`

## contribute environment variables
source $d/josh-env-vars.sh


## record homebrew

mkdir -p $HOME/bin
export PATH=$PATH:$HOME/bin
# lets make sure that this and the brew manifest of the OS itself are all version controlled


BC=$d/brew-cask.txt
B=$d/brew.txt

brew cask list > $BC
brew list > $B

cd $d

n=`date`
git add $B
git add $BC
git commit -a -m "updated brew manifest $n."

last_commit_status=$?

if [ $last_commit_status -eq 0 ]; then
  echo "changes detected on $n. running git push."
  git push;
fi

cd $c
```

Naturally, this script needs to be run at somepoint. It's a cheap operation so I run it on every new user shell, inside  `$HOME/.zshrc`:

```
...
source $HOME/josh-env/josh-env.sh
...
```

This way, if for any reason I need to restore a system tomorrow, I can `git clone` the private project on a new machine and restore everything. It might be as simple as:

```
#!/bin/bash

cat brew.txt | while read l ; do brew install $l ; done

cat brew-cask.txt | while read l ; do brew cask install $l ; done

```

I keep everything _heavy_ weight inside of Dropbox, so that restores naturally. I keep all code inside Github, and those restore naturally. This ensures that the remaining personalizations to my environment are recorded and restored as well.
