title=The world changes, even if your build doesn't 
date=2023-06-02
type=post
tags=blog
status=published
~~~~~~

I've been working around the clock to move my various online properties (like [joshlong.com](https://joshlong.com) and [bootifulpodcast.fm](https://bootifulpodcast.fm)) to a new Kubernetes cluster and it has been.. painful. The code still runs fine but so much of the work of getting the thing onlioe in the first place is made more difficult by the fact that, basically, 
the world's changed. There are externalities that have made moving to a new platform shall we say _interesting_? Things like the older beta APIs no longer being available on the managed Kubernetes cluster, or the default branch on Github changing from `master` to `main`. Things change, and perhaps I should've been practicing a more chaos-monkey like approach of forcing myself to 
redeploy everything every few months. Sigh. This exercise has been painful, but valuable because I;ve realized some services can be turned off and retired, or their functionality has since been superseded and things can consolidate on the new superseding approach. 
Also, I've got a very strong urge to write a Kubernetes CRD and a new Github Action, as so much of the work of getting things into production is boiletplate and could be templatized and reused. This is obvious now as I'm scrutinizing every application all at once, but not so clear as I was deploying things sporadically.
