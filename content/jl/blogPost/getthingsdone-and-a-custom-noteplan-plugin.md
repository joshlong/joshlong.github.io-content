title=An Easy Way to Track Changelogs with NotePlan and the _Get Things Done_ Methodology
date=2022-03-01
type=post
tags=blog
status=published
~~~~~~

I use the [Get Things Done (GTD)](https://todoist.com/productivity-methods/getting-things-done) methodology to manage my work streams. It looks and feels similar to lots of differnet task and project management solutions I've used before except that it's fairly barebones and can be done with literal physical inboxes and some paper or you can use software. The trick is to keep it simple-ish. Here's the basic workflow. 

The core idea of GTG is that our brains are great at creating but not at tracking work. We've all felt overwhelmed before, to the point where you've got post-it notes and todo lists and reminders and you're just trying to stay above water. The problem is that most of us don't have a single system in which we inventory and process work. _All work_, be it in your personal or family life or in your business life. Sure, we might use Pivotal Tracker or Github Issues or something like that for individual projects. We might use Todoist for our personal lives. Or we might just a hodgepodge of our cellphones' "reminders" and "notes" capabilities. Either way, there's no real central place where we can process and respond to all work in front of us, so we get lots of open loops. The open loops gnaw at the psyche. They create stress. Need to see your tax person? Need to schedule a trip to the dentist? Make sure to be there for your daughter's Parent-Teacher night? Want to prepare a deck for the boss? Have an idea for some refactorings that you think would be really cool? All these things add up to open loops - things you want to do but don't have the time to address right now. Sometimes we just learn things and want to acknowledge the things we've learned. It'd be a shame if you didn't at least write it down somewhere. All of these things, left unacknowledged, either takes up space in our heads rent free or - worse - disappears. It creates that uneasy sense that you've got something you're supposed to do but haven't. It's the worst. You ever wish you could remember something and can't sleep? You ever get anxious about sleeping because you've got a ton of work but, when pressed, can't quite put your finger on what work remains, exactly? Ever go on a vacation but have troulbe letting go because you don't know, exactly, everything that needs to be done so you can't quite clear the decks to excuse yourself? 

It's a paradox: we have so much more time to do things and things are so much easier to do now, but we also have soo much more stuff to do. Worse still, a lot of the things we do these days are not clear-cut kind of work. A lot of is knowledge work, stuff that's never quite _done_. There are no open/close definitions for "done," just "good enough." It's easy to feel overwhelmed. I won't try to revise or improve upon David Allen's original work. Suffice it to say, you should read his stuff and get a feel for what the system is trying to solve. 

The task management system envisages five steps that you must go through every day. 

* collecting: get everything, and i mean everythign, that you've got to do in one place. You could write it all down, one item per page, on blank pieces of paper. make sure to keep the blank page with the item next to the resources that you might have on hand to support that work. So, a piece of paper saying "get taxes done" might be on top of the stack of supporting documents you need to take to the tax preparer. All of this stuff goes into a folder I call "00 - Inbox." I dump all the things anybody asks me to do - on Slack, email, via calendar invites, on twitter, in person in my home - in this folder. A quick one sentence is enough sometimes. 
* processing: establish what you can do with the resources at your disposal. In practice this means going through everything item to be done and determining what the next actionable steps are.
* organizing: put the results of your processing into a system that you trust. If the work has a clear actionable thing, it goes into a folder called "01 - Next Actions." If there's nothing to be done and it's just useful information, put it in a folder called "05 - Reference." If the work is not important but you'd like to get it done one day ("Learn German," "Climb Mt. Everest," put it in a folder called "04 - Someday." ) If you're waiting on feedback or on some external event, put it in a folder called "03 - Waiting For." If you've done everything that there is to be done, put the item in "06 - Archive." If something has a particular date associated with it, I mark it down on the calendar and then put it in the "Waiting for" folder.
* doing: in this stage, you simply go through the things in the "Next Actions" folder and just... _do_. 
* reviewing: after taking action, you need to review and reflect on the work you've done. Adapt strategy, etc. 

The idea is that you do this process often. At least once a week. I do it a few times daily. It helps me to see all the outstanding work. All the stuff to which I'm committed and all the stuff I have bandwidth for. This is important because I'm constantly working on new stuff. Podcasts, blogs, videos, books, talks, etc. All of this requires concentration but I can't greedily sit there and ignore the rest of my life. With this process, I know what I'm doing and I know what I'm ignoring and I can feel relaxed when I do something that requires concentration because I know what, if anything, else needs to be done. I'm able to much better focus on something. 

I use a handy tool called NotePlan, which is available at least on iOS and macOS. I use it all the time and sits running on my machine almost all the time. It's basically a scriptable Markdown editor with a concept of folders and notes. You can create your own folders to map to the steps in the process. As I fleshed out above, my folders look like this: 

 * `00 - Inbox` 
 * `01 - Next Actions` 
 * `02 - Waiting For ` 
 * `03 - Anytime` 
 * `04 - Someday` 
 * `05 - Reference` 
 * `06 - Archive`


A lot of the things I do take a while. It's trivial to create a note and dump into `00 - Inbox` on my mobile device or at my laptop. I never worry that I'm dropping the ball on something or committing to something I won't follow through on. 

A lot of the things I do require multiple steps, however. I like to treat things like open tickets in an issue management system. I find myself adding bullets with timestamps before them a lot, so that I can know what my last action. Maybe the note starts off in `00 - Inbox`, I then clarify what needs to be done and move it to `01 - Next Actions`. This might be a day later. Maybe then I start doing the work but once I finish the work, I have an outstanding email, so the note goes into `02 - Waiting For`. All of this might take several days, or longer. So I ended up wanting a quick way to jot down a quick update for the note with the timestamp, if for no other reason so that things don't get stale. So, I wrote a little plugin for `NotePlan`, which turned out to be a fun exercise. 

The [plugin is here](https://github.com/joshlong/noteplan-date-modified-plugin). Git clone that directory into your NotePlan Plugins folder. My Plugins folder is `$HOME/Library/Containers/co.noteplan.NotePlan3/Data/Library/Application Support/co.noteplan.NotePlan3/Plugins`. Yours may very well be different at the time you read this. Restart NotePlan. I'm not sure if it'll just be available already or if you have to install it. No big deal. Open `Preferences,` goto `Plugins` and then choose to install it if it's not already installed. 

One of the most powerful aspects of NotePLan is that that it has a command bar, quite like Sublime and Visual Studio Code. CMD + J and every command or plugin is at your finger tips. With this plugin installed, you can simply say `/jlog` (Josh's Log, get it?) and it'll automatically update the title of the open note to reflect the current date. It'll also create a section in your Markdown called `## Changelog` and it'll append whatever you enter in the prompt as a listed item in that changelog with the current date and time. 

Neat? Yah! Enjoy! (It's Apache2 licensed)
