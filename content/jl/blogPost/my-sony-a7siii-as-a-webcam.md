title=My Sony A7S III as a webcam
date=2023-10-14
type=post
tags=blog
status=published
~~~~~~
 


In 2022, I bought a Sony A7S iii for use in producing my YouTube videos (
see [Spring Tips (@SpringTipsLive)](https://bit.ly/spring-tips-playlist)
and [Coffee Software (@coffeesoftwareshow)](https://youtube.com/@coffeesoftware)). I did the normal things. I installed
the Sony Imaging Edge software, which let me launch, configure settings on the camera, and start and stop recordings, all
from within my macOS environment. It was OK, but it was only, in effect, a proxy for the mechanisms for controlling the
camera on the camera's menu systems. I also installed the Sony Imaging Webcam application. It does something slightly
different: it lets me use the Sony A7S iii as a webcam for Zoom, Google Meet, etc. Awkwardly, it doesn't let me
use the camera as a camera from any arbitrary operating system application, like Quicktime, which I use routinely to
record my face as I'm doing a demo on the machine. It seemed redundant; I think the Sony Imaging Edge application
already lets you do this. I'm not 100% sure.

But either way, it wasn't what I wanted. I did things the hard way for the longest time, recording to the camera's
local CFEXPRESS cards. The CFEXPRESS cards are, by the way, super expensive! I'm glad that the camera supports and
the results are
amazing, but
_yeesh_! [They're pricey indeed](https://www.amazon.com/SanDisk-128GB-Extreme-CFexpress-Card/dp/B07WVDV3FG?th=1). I have
a fairly expansive and
expensive [CalDigit USB-C hub](https://www.amazon.com/gp/product/B09GK8LBWS/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)
that has a ton of connectivity. I am also glad because it doesn't have CFEXPRESS card ports, so I had to buy an
external reader and plug it into Caldigit's data USB-C ports. All that to say, the connectivity cost ~$400 and the
reader another ~$100 or so. And then the cards. So that I could have a way to efficiently write the 4k 60fps video that
my camera can do for video. This workflow works fine, except that it assumes I will do a produced video and
that I'll spend a lot of time writing data to the card, taking it out of the camera, taking it to the reader, mounting
the card, copying the files, etc. I'd rather have the ability to start and stop a Movie recording in
Quicktime and then save the result to my desk. Please. So, finally, as I retool my new home studio, I decided it was
time to figure this out once and for all.

Separate from all of this was that, years ago, I bought an Elgato HD60 S+ capture card. The idea was that I could
stream from OBS on another machine, and one of the input sources for that OBS setup was the output coming from my main
laptop. This arrangement was essential because Quicklime slows things down considerably if you run it on the same
machine as you're trying to demonstrate something. I would do these spring tips videos on my old Intel MacBook Pro 2019
16" and things would crawl when being recorded. It is expensive to run QuickTime computationally inefficiently, but it's swift to have a secondary monitor, presumably because it's more driven by the graphics card. I don't know. Either way, I tried to avoid having my IntelliJ demos be sluggish. It makes for nasty videos! Nobody wants 2s of dead air waiting for an application to restart. There is not enough time for a joke and not enough time to easily see it in the Adobe Premiere timeline. Then, in 2020, the unthinkable happened: Apple released the Apple Silicon chips, and suddenly, it could do all sorts of things on the laptop simultaneously. So, I stopped using the capture card. The demos are still a bit slower than they would be were I not running quick time, but they're _fast enough_ and that's fine.

All this to say, I still had the capture card lying around!

And I started to piece two and two together. The camera can do HDMI output. But to what? Well, the capture card, of course. Then I could plug the capture card into the computer (specifically, the Caldigit USB hub), and now it appears as a camera in _every_ application! Hurray!

NB; there are some limiitations. My Elgato doesn't do well with 4k videos, which is fine. 1080p on the camera is still very good. So, go to the appropriate camera configuration screen and configure 1080p output resolution for HDMI output.

Now I can hit the switch and start recording. I feel so professional. 
