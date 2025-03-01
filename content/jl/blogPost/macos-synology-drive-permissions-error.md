title=Weird Error when Installing the Synology Drive Client App on macOS Sequoia 15.3.1
date=2025-03-01
type=post
tags=blog
status=published
~~~~~~

I use the Synology NAS. It's an appliance that gives you a push-button simple RAID experience with a dedicated web-based  console to administer the NAS. I love my Synology. Indeed, I just a few weeks ago migrated the four disk RAID 10 array from 5 TB  disks to 18 TB  disks.  Now I have nearly 40 TB of space, striped and redundant. Dope. (Thanks Synology!)

But not everything's been perfect. I've been experiencing this oddity of an issue where, on every reboot, the Synology Drive client would prompt macOS to ask me for permissions (show below). Each time, I approved the permission but the error persisted on restart. Ugh.


<img style=" max-width: 100%; height: auto;" src="https://api.joshlong.com/media/easy-desktop-apps-from-sites/2025-03-01-macos-sequoia-synology-error.png" />

Some context: I've just re-installed everything on my  Apple M4 that I had sent into to get repaired by Apple. _why_ did I send it in? Well, [read this](https://joshlong.com/) for the whole nine yards. Anyway, everything's basically fine _except_ the Synology Drive, which has this weird error. 

I found [this solution](https://community.synology.com/enu/forum/72/post/190576) online, after consuling ChatGPT and Claude to no avail. It works! 

TL;DR: if you get this error, add the `SynologyDrive.app` to the `System Settings` -> `Privacy & Security` -> `Full Disk Access`. It may not show up there. If it doesn't, add it manually. You can find it in your home directory, e.g.: `$HOME/Library/Application Support/SynologyDrive/SynologyDrive.app`. NB: this is _not_ the same as the `Synology Drive Client.app` that's in your `/Applications` folder! Two different binaries. Make sure to add the right one. The other one won't work (annoyingly). 


