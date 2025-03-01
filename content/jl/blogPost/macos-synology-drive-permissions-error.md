title=Weird Error When Installing the Synology Drive Client App on macOS Sequoia 15.3.1
date=2025-03-01
type=post
tags=blog
status=published
~~~~~~

I use the Synology NAS. It's an appliance that gives you a push-button simple RAID experience with a dedicated web-based console to administer the NAS. I love my Synology. Indeed, just a few weeks ago, I migrated the four-disk RAID 10 array from 5 TB disks to 18 TB disks. Now I have nearly 40 TB of space, striped and redundant. Dope. (Thanks, Synology!)

But not everything's been perfect. I've been experiencing this odd issue where, on every reboot, the Synology Drive client prompts macOS to ask me for permissions (shown below). Each time, I approve the permission, but the error persists on restart. Ugh.

<img style="max-width: 100%; height: auto;" src="https://api.joshlong.com/media/2025-03-01-macos-sequoia-synology-error.png" />

Some context: I've just reinstalled everything on my Apple M4, which I had sent in for repair by Apple. _Why_ did I send it in? Well, [read this](https://joshlong.com/jl/blogPost/apple-macos-sequoia-154-beta-broke-docker.html) for the whole story. Anyway, everything's basically fine _except_ for Synology Drive, which has this weird error. 

I found [this solution](https://community.synology.com/enu/forum/72/post/190576) online after consulting ChatGPT and Claude to no avail. It works! 

TL;DR: If you get this error, add `SynologyDrive.app` to **System Settings** → **Privacy & Security** → **Full Disk Access**. It may not show up there. If it doesn't, add it manually. You can find it in your home directory, e.g.:  
`$HOME/Library/Application Support/SynologyDrive/SynologyDrive.app`.  

NB: This is _not_ the same as the `Synology Drive Client.app` that's in your `/Applications` folder! These are two different binaries. Make sure to add the right one—the other one won't work (annoyingly). 