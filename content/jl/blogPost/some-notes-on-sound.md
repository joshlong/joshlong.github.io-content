title=Some Notes on Sound
date=2018-07-28
type=post
tags=blog
status=published
~~~~~~

I've been studying sound and I took some notes and I'd like to be able to find these readily so I figured i'll post them there.  Hope you find these notes, disjointed thought they are, even a tiny bit useful.

### Frequency
* When sound is created, it travels through a medium, usually air. Its the change in pressure of the waves that we perceive when it hits our ears.
* the timing of those waves is known as the frequency, or literally how frequently the eave fluctuates.
* the frequency is how long it takes to complete a cycle
* measured in hertz, or cycles per second.
* the more cycles per second the higher the pitch of the sound
* 440 cycles per second = 440 hertz.
* anything over a thousand hertz is measured in kilohertz
* human hearing = 20 Hz to 20 kHz


###  Amplitude
* how much the sound wave fluctuates up ad down
* smaller fluctuates = softer; bigger = louder
* decibels = dB is how you measure amplitude
* 0 dbfs (decibels for scale) = the loudest. lower = -1dB until 0dB. -12dB is louder than 0dB.

###  Sample Rate
* when we capture sound were not actually capturing the whole thing, were capturing snapshots at intervals
* the sample rate is measured in hertz
* CDs are sample at 44100 Hz. Video = 48 KHz.
* The general rule is that the sample rate is double the highest frequency you are going to record which is why 44.1 kHz is the lowest sample rate you'd want since human beings can reach 20khz of frequency.
*  some audio engineers set it at 96 kHz for incredible quality. obviously this takes more space in the file!

###  Bit Depth
* the bit depth determines how much info is stored in each sample; the more bits the wider the range of volume we can store in each sample
* a low bit depth of 8 bits gives us a dynamic range fo 48dB. 16 bits is used for CDs. 48 bits is used for videos.
* the higher the bit depth the larger the file will be. Still, recommendation? Record at the highest bit depth you can (32-float).
