title=Java 21: Threads at Bargain Basement Prices! 
date=2024-03-24
type=post
tags=blog
status=published
~~~~~~

I love Java 21! And I love virtual threads, in particular!

I recently tweeted something that a lot of people seemed to understand and agree with:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">async/await was a mistake</p>&mdash; Josh Long (@starbuxman) <a href="https://twitter.com/starbuxman/status/1772946628288155910?ref_src=twsrc%5Etfw">March 27, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

But some people didn't quite get it. _Why?_ In this post, I'd like to talk about what I wish `async`/`await` had been from the get go: Java 21's virtual threads.

First: here’s a simple example you can run on Java 21 today in `public static void main` or in a Spring `ApplicationRunner` or `CommandLineRunner` bean. It requires absolutely no dependencies, save for Java 21 or later. 

Nota bene: you can install Java 21 or later with ease using the [SDKMAN.io technology](https://sdkman.io):

```shell
sdk install java 22-graalce
sdk default java 22-graalce
```

See you after the code for a breakdown of what's going on (and what's _not_) going on.  I stole this example shamelessly from  [José Paumard (@josepaumard on X)](https://twitter.com/josepaumard), who works as a Java Developer Advocate at Oracle, and as a professor. 

```java
package org.example;

import java.util.ArrayList;
import java.util.Set;
import java.util.concurrent.ConcurrentSkipListSet;

public class Main {

    public static void main(String[] args) throws Exception {

        // store all 1,000 threads
        var threads = new ArrayList<Thread>();

        // dedupe thread names
        var names = new ConcurrentSkipListSet<String>();

        // thanks to Oracle Java Developer Advocate José Paumard
        for (var i = 0; i < 1000; i++) {
            var first = 0 == i;
            var unstartedJavaLangThread = Thread.ofVirtual().unstarted(() -> {
                runOnThread(first, names);
                runOnThread(first, names);
                runOnThread(first, names);
                runOnThread(first, names);
            });
            threads.add(unstartedJavaLangThread);
        }

        for (var t : threads)
            t.start();

        for (var t : threads)
            t.join();

        System.out.println(names);
    }

    private static void runOnThread(boolean first, Set<String> names) {
        if (first) names.add(Thread.currentThread().toString());
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
```

Let's walk through the code.

The code creates 1,000 threads,  that haven't yet been started and adds them to a `List<Thread>` called `threads`. Then it runs through all the threads and starts each of them. Then it runs through all the threads and waits till they've all finished executing. 

In the `Runnable` that we create and pass to the thread, we figure out if we are on the first thread of the 1,000 (`i == 0`). If we are, we take a `toString()` of the current executing thread (`Thread.currentThread()`) and add it to a `Set<String>`. (Remember, sets dedupe elements). Then we block (`Thread.sleep(100)`) for 100 milliseconds by sleeping. 

We repeat this 4 times. At the end of it all, we print out the names of the threads on which the first thread runs. 

"What?" I hear you say. "Why would the name of the thread change if you haven't changed threads??" And, you're right. They don't, at least they didn't  in the old world. This example uses `Thread.ofPlatform()`. It's the experience equivalent to what we've come to know and have experienced using for the last 25 or more years. In that world, each `java.lang.Thread` was assigned to and stayed with one actual carrier thread (an expensive and precious operating system thread). It stayed on that carrier thread for the duration of its execution.

We're only looking at the first of 1,000 threads. So, logically, since there's only one carrier thread bound to one Java `Thread`, the name of that one thread is the same each time you add it to the `Set<String>`. At the end of the run there's only one element in the `Set<String>`.

In Java 21, we have _virtual threads_. Virtual threads decouple `java.lang.Thread` instances from the actual (expensive, limited) operating system (OS) carrier threads on which they execute. A single logical `java.lang.Thread` may execute on any number of real carrier threads when you use virtual threads. How? Just change the factory method: `Thread.ofPlatform()` becomes   `Thread.ofVirtual()`. Easy. Run the program again and you'll see that the `Set<String>` now has more than one element. Maybe two, or three, or four elements. But typically more than one. The runtime automatically detected that we were running on a virtual thread, and when we tried to block (`Thread.sleep()`), it moved the code into RAM, off of the expensive OS thread, and waited for the sleep to finish. Once it was done, it got put back on another (possibly and probably) different OS carrier thread, and continued executing. 

The result? Other things in the system weren't deprived of that expensive OS carrier thread when we were sleeping. Or doing `InputStream#read()`, or `OutputStream#write()`, as in network Socket IO when talking to a DB or another micro service. 

Remember, this is admittedly very low level code. 99% of us don't create `Thread` instances of our own at all! Spring executes your controller methods in a thread pool when your Spring MVC controller handler methods are invoked, for example, but you're not dealing with that at all. So, taking it a step further, just change the `java.util.concurrent.Executor` that Tomcat (or whatever) is using under the hood, and you can do all the IO you'd like and it'll automatially free up the underlying and expensive OS carrier thread while you're blocking. Don't want to write two or three lines of code re-configuring important `Executor` instances as beans  to use this new `Executors.newVirtualThreadPerTaskExecutor()` ? No prob: `spring.threads.virtual.enabled=true` and now it's done. No changes to your code. No nonsense `async`/`await`. No `Promise<T>` returned from all methods. Nothing. 

Just use Java 21 (and set a property) to get scale and get home in time for dinner, while your colleagues are still busy figuring out `async`/`await` in languages that mostly don't even have strong enough compilers to validate the  proper use.   

Bonus: ask your boss for the money saved in cloud infrastructure spend to be deposited into your next paycheck. 

There's an interesting knock-on effect here, too: `Thread`s are _cheap_! you can create _millions_ or _tens of millions_ of them now. Indeed, the virtual `Executor` isn't even a "pool" per se. It just creates new threads _ad infinitum_ and lets them get garbage collected. 

This, in turn, means a whole class of architectural decisions and conventions could be challenged. Do you really need to send that long-running email, or report generation, or image resizing job to another cluster node to do its work, in an admirable but probably pointless attempt at keeping the front end thread pool with as much capacity as possible? Why not run it on the same node as the web server? It's not like the webserver is going to run out of capacity any time soon.

There's never been a better time to be a Java and Spring developer!
