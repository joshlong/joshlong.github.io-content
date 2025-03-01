title=Apple macOS Sequoia 15.4 Beta Broke Docker (and Everything Else)
date=2025-02-28
type=post
tags=blog
status=published
~~~~~~

I've just reinstalled macOS on my Apple MacBook Pro M4 Max. _Why_ did I reinstall macOS? Because I got suckered! I've been riding the macOS system betas for _years_ now—rarely an issue. Before you comment, I'd bet you've had more issues riding _mainstream_—_released_—Windows and Linux distro updates than I have riding macOS betas. This time, however, I regret it! 

I had a _huge_ error. The new macOS beta **broke** Docker virtualization. I rebooted the machine after installing the update, and Docker started up on login. The error occurred, and the screen froze. This was a _hard_ fault, a kernel panic, and I ended up in a reboot cycle until finally booting into macOS' `Safe Mode`. I managed to finally log in to macOS after disabling Docker in `Safe Mode`, but now I had no Docker capability! Unacceptable. I need Docker for literally everything I do. I was _not_ prepared to wait for the next release, which may well be weeks or months out. And Apple, tediously, doesn't provide an easy way to roll back the upgrade. 

So, I resigned myself to formatting the disk and reinstalling. I `git push`ed any in-progress code and made sure my Synology Drive app (which functions sort of like Dropbox's native operating system experience) had synchronized all files to my Synology NAS. Then, I booted into `Safe Mode` again and began the reset process. Except midway, the device just sort of reboots, and I get dumped into a horrific black screen with a grey exclamation mark and a link to Apple's support portal explaining how to do a _Device Firmware Update_. Ruh-roh. 

<img style="max-width: 100%; height: auto;" src="https://api.joshlong.com/media/macos-sequoia-dfu-error-of-doom.png" />

_Device Firmware Updates_ require you to connect the MacBook Pro via a USB-C to USB-C cable to another, healthy, MacBook Pro and attempt to sort of heal the broken laptop's firmware. Thank goodness I hadn't yet sold my old Apple MacBook Pro M3 device! The DFU process was sort of like an _open-part_ surgery. Or a firmware transplant. 

I did everything as directed, and it kicked off the process. Then, suddenly, _bam_, it rebooted. No idea why. This happened a few times.

Off to the Apple Store. Turns out they can't fix it, so of course, they take possession of my device and ship it off to the true _Genius Bar_ at Apple HQ or something. Now I'm without my main laptop, and I've got 15 hours before I need to board a plane for Confoo in Montréal, Canada. So this led to a scramble to reset my old M3 and get it ready—which I did—and everything was basically fine. 

But still: _don't upgrade_ your macOS beta if you are a Docker enjoyer! 