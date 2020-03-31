title=Annoying "Accept Incoming Requests" Dialog when Using IntelliJ IDEA on OS X
date=2016-02-03
type=post
tags=blog
status=published
~~~~~~

I recently got a new machine and did a `brew cask install intellij-idea` and then quickly went to a dozen different customer meetings. When the dust finally settled, I realized I was being prompted by OS X's firewall and security subsystem to confirm that IntelliJ could accept incoming connections on _every_ launch of IntelliJ, as shown here:

<img src="/media/accept-all-incoming-connections.png"/>

Lazy, and in sufficient pain as to warrant a Tweet, I asked if anybody knew of a way around this issue. I was given two interesting replies. First, we [should watch and vote on this issue on the IntelliJ tracker](https://youtrack.jetbrains.com/issue/IDEA-150782) and [second](https://twitter.com/damian_bl/status/694891546462797824) (thanks _so much_ [@damian_bl](http://twitter.com/damian_bl)!) that if I wanted to fix it in the meantime [I could force it to resign itself](https://www.igorkromin.net/index.php/2015/07/05/fix-the-do-you-want-the-application-intellij-idea-14-ceapp-to-accept-incoming-network-connections-prompt/):

```
sudo codesign --force --deep --sign -  /opt/homebrew-cask/Caskroom/intellij-idea/15.0.2/IntelliJ\ IDEA\ 15.app
```

That's all it took! On the next restart, I was prompted to confirm acceptance (one last time), and then not since have I had to confirm it.
