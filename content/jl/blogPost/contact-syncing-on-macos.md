title=Fixing the issue where macOS fails to sync contacts
date=2026-10-24
type=post
tags=blog
status=published
~~~~~~

The title says it all. I've got two Apple laptops. I've got an iPhone and an iPad and a Watch. The "oldest" laptop is from 2024. Not that old, I know, but in the intervening years I've changed the email associated with my Apple ID. Apparently their systems for contacts propagation (e.g., my list of phone numbers) rely on the old username being the same as the new one. (Why?) So I was getting text messages on the older Mac from people whose names weren't showing up. They showed up correctly on all the devices signed into the same Apple account using the new username (the newer email). Just not here. So I was getting the messages, but the contacts weren't syncing. I tried the usual: `System Settings` -> `iCloud` -> toggle `Contacts`. Nothing.

I looked at the logs and they told me, basically:

* There are four contact lists on this Mac, some from my various internet 'accounts'. The fourth is the iCloud one, stored in the folder `Sources/ABC1234-`... It connects to `p123-contacts.icloud.com` as `<old email>`. The server answers `401` (credentials not accepted), and the sync fails with error `-1012`, which means the login was refused.
* The sync stops right there with `ERRORS REMAIN in sync`. It never logs `setting lastSyncDate`. It never gets far enough to ask iCloud what changed, so new contacts can't come down. I was also getting repeated `Failed to get a X-mobile me token` lines.

So, I went to `System Settings`, clicked on my name, and signed out of iCloud. I chose to preserve local data. Then I signed in with the new email and it pulled down the data. It saw I had local data, so it asked me if I wanted to merge the online data with the local data. I said yes. It did, and everything was _fine_. 