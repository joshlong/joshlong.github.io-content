title=My journey with window management's  next stop: Raycast
date=2025-01-10
type=post
tags=blog
status=published
~~~~~~



So, my journey with window management on macOS continues!

I love macOS. It wants you to feel like you’re using your own physical desk. Things are sort of flung hither and thither—papers on top of folders, apps on top of other apps, in random positions. You know where the work you were doing is—it’s in the window that just barely peeks out from under the app I’m using. Easy. I’ll grab it and get back to work when I need it.

There’s just one problem: I don’t keep my papers and folders in a random heap! I stack them neatly, quickly, and align them with each other. I look at one paper at a time, process it, and then either trash it or file it. If I need to view the contents of multiple pages at once, I tape them next to each other, effectively creating a 17x11” page.

When I had a physical desk with anything more than the essentials required to use a computer (a mouse, a keyboard, etc.), I kept everything perpendicular and parallel to the desk’s border. I never kept a giant paper calendar under my laptop because it would compete for my attention. I didn’t hang things on the wall in front of me because they would also vie for my attention. I didn’t position the monitor in front of a window because, again, I didn’t want distractions. (Though I might position it next to a window…)

I take the same approach when working on my laptop. The human attention span is incredibly weak. It’s self-sabotage to build an overly stimulating and taxing desktop environment. I empty macOS’s trash regularly. I keep only two folders on the macOS desktop at a time. I keep all my code under ~/code, and all of it is version-controlled and backed up. I keep the contents for my videos under a single folder—~/Drive—synced with my SAN over the cloud. I keep my ~/Downloads folder empty unless I’m doing a demo on stage in some of the folders I’ve created there.

When I work with apps on my laptop, I tend—whenever possible—to keep them full screen. If I have to divide attention between two applications, I give them equal screen real estate and then, when I’m done, give the dominant application the full screen again.

Needless to say, I want things nice and organized.

Less is more. It’s true for mobile. It’s true for desktops.

I was thrilled when macOS shipped the ability to snap windows to different quadrants of the screen in the latest release. A huge improvement. Except… it didn’t have key bindings. You had to use the mouse!

Every other environment—tablets, phones, Google Chromebooks, newer operating systems built for the 2010s and onward, watches, etc.—provides window management shortcuts. In a sense, Windows 8’s flat UI was spot on and ahead of its time. Even macOS has embraced this single-minded, focused approach to desktop work with the recent addition of Stage Manager. I understand why you’d use it—I just don’t because I’ve already got the ability to achieve what it gives me. How?

Well, this has been a bit of a journey. For years, I used ShiftIt. Then that stopped working. So my friend Matt Raible discovered Hammerspoon, which could be scripted. Eventually, we discovered there was a ShiftIt plugin for Hammerspoon. So we used that. It worked fine.

Then I discovered Raycast.

Raycast is a sort of command center for macOS. It provides tons of integrations—some of which exceed what’s provided by macOS, others of which complement it. Either way, I’m a big fan. It’s a Spotlight replacement, an emoji picker, a color chooser, a calculator, a way to initialize Spring Boot, control Spotify, find things, control Apple Music, interact with ChatGPT, toggle the macOS system menu bar, and a million other things—all with a single, unified interface element that you can bring up with just Command + Spacebar. (Make sure to disable Apple’s Spotlight.)

And it does window management! I uninstalled Hammerspoon, went into the commands section for window management, and configured them to have the same key bindings as Hammerspoon did.


<img src= "https://api.joshlong.com/media/raycast-window-management-bindings.png" />

I sure hope this is the final stop. Raycast looks to be _really_ compelling, and feels like the cheetcode for how to get the next-gen macOS without forcing everyone else to come with me. 

