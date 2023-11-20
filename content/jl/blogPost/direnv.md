title=Cool, Convenient, and Quick Environments with Direnv 
date=2023-11-19
type=post
tags=blog
status=published
~~~~~~


My friend [Dashaun (@dashaun)](https://x.com/dashaun) turned me onto this very handy utility. It's amazing. Want to have arbitrary environment variables at your finger tips when working on projects? Tired of having to lovingly craft environment variables to pour into your IDE's run configuration? Check out [`direnv`](https://direnv.net)

Install it. It's easy enough. Then in a directory, any directory, create `.envrc`. You put variables in there or execute shell script statements. Anything you can imagine needing done when you `cd` into a given directory. Then `cd` out of it. Then `cd` back into it. You should see the contents of your `.envrc` file execute. 

Why does this matter? Well, suppose you're working on a new program that uses Amazon S3. You need to specify credentials when you're developing the code. Obviously, you don't want live Amazon Cloud credentials being checked into your version controls system, so, you think, you'll just simply have to craft the environment variables anew each time you want to work on that codebase. You'll need to plugin environment variables for your Run Configuration in IntelliJ, at a minimum. And if you try to run the program outside of the IDE, you'll need to duplicate the environment variables there. Tedious! 

Well, fret no longer. `direnv` can fix this, especially used with a Password Manager. I've used Lastpass, 1Password, and Bitwarden. They all have CLIs you can use to talk to them. Lastpass' experience was my favorite. Bitwarden works, but it's very fidgety. The basic strategy is this: put a call to your password manager in the `.envrc`. 

Here's an example with LastPass:

```shell
export SUPER_SECRET_S3_ACCESS_KEY=$(lpass show --password lastpass-s3-key)
export SUPER_SECRET_S3_ACCESS_KEY_SECRET=$(lpass show --password lastpass-s3-key-secret)
```

Now if, you're already logged in, then this will execute immediately. If you're not logged in, then you'll be prompted on the CLI. Either way, _easy_! You can definitely chuck this `.envrc` file into a Git repository with no regrests. Mind you, if you're sharing this configureation with other folks on the team, make sure they're both using `lpass` (the Lastpass CLI) _and_ that they've named the credential the same thing as you have. 

Alternatively, you could put multiple branches in the same `.envrc` file, gated by checks to see if the requisite program is even installed on a given machine. Either way, this arrangement is awesome. 

Let's talk about Bitwarden. It's less convenient, but still workable. The trouble with Bitwarden is that it's entirely up to you to manage the session, the lifetime, of the interaction with the password manager on your system by constantly representing the unique token they give you when you first login (`bw login`) as an environment  variable called `BW_SESSION`. The trouble is that they don't do a great job of just giving you the toke so you can easily assign into a variable and call it good. Some parsing is required. And it's kinda fidgety. So I wrote a little Java program that, compiled as a GraalVm ntive image, I've installed somewhere on my machine's `PATH`. It's called `bwu` ("Bitwarden unlocked"). Here's [the source code (in its entirety! _lol_)](https://github.com/joshlong/bitwarden-session-token-per-shell). Now, whenever I need a set of Bitwarden variables, I do something like this:


```shell
if [ "$(which bw)" != "" ]; then
	# heres the call to my custom program
    export BW_SESSION="$(bwu)"
    export S3_ACCESS_KEY=$(bw get username youtube-assistant-s3-production)
    export S3_ACCESS_KEY_SECRET=$(bw get password youtube-assistant-s3-production)
fi
```

Easy _and_ secure! I love this. NB: environment variables configured this way don't endure once you've closed the shell.

Happy Thanksgiving!
