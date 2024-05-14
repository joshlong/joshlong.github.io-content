title=A Custom Build System for Sublime to Make it Easier to work with Java ... Scripts... "Scripts that use Java"? 
date=2024-05-14
type=post
tags=blog
status=published
~~~~~~



I like using Java to write scripts. It's particularly easy with two features in Java: Java can run source code, and you can have class-less `main` methods.

The fact that you can launch a Java program with `java Main.java` (e.g.: I didn't point `java`, the runner, to `.class` files, but instead I pointed it to a source code file). If you want to use preview features, you also need to specify the source and specify that you want to use preview features.

So, given a program in `Main.java`, the full incantation would be:

```shell
java --source 21 --enable-preview Main.java
```


Preview features are worth remembering, because there's a doozy of a preview feature in at least Java 21 (or later) that allows you to run Java programs without the ceremonial `public static void main`. So, the following is valid: 


```java

void main() { 
	var name = "Josh" ;
	var message = STR."""
			 Hello, \{name}!
	""";
	System.out.println(message);
}

```

Nice! 

A lot of times I just write quick and dirty Java programs to do file management chores or automate something on my local desktop. I develop these single-page applications in Sublime and I want to run them. It's not easy. Sublime knows how to compile a `.java` program, but it doesn't know how to   _run_ it. It's easy enough to teach it, however.

Go to `Tool` > `Build System` > `New Build System`. It'll popup with a partially completed source code buffer. Use the following instead:


```json
{
  "shell_cmd": "java --source 21 --enable-preview $file",
  "selector": "*java"
}
```

Save the file (`File` > `Save`, or `CMD`/`CTRL`+S on your operating system of choice). It'll save it automatically in your system's correct build plugins folder. On my system that folder is: `$HOME/Library/Application Support/Sublime Text/Packages/User/`. Yours might be different. No idea.  I installed my Sublime through Homebrew, for what it's worth... 

Now, create a new file called `Main.java` (or `Cat.java`, it really doesn't matter!) and add the following code:


```java

```

Then run the build. On macOS, it's `CMD`+`B`. Voilà!  REPL-like productivity with a statically typed language you already know and love. 

This approach is super liberating. Half of the interesting things I may want to do seems to revolve around `java.util.*` and `java.io.*`. I just remember to import those, and start writing. If I can write the whole thing from memory of the types involved, fine. If not, or if the the thing gets more involved, it's just Java. I can always promite it to its own Maven or Gradle project. No big deal. 
