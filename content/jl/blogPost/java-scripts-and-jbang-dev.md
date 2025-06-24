title=Java Scripts and JBang.dev
date=2025-06-24
type=post
tags=blog
status=published
~~~~~~


Let me start by saying: I just think this is really cool. It's not _official_ or anything. Just super cool and only amounts to a few dozen lines of Java code that you  could write yourself.

First, did you know that Java 25, which drops in September, will have a feature called implicit classes and relaxed main methods? What's that mean? It means the following will be considered a valid Java code page:

```java
void main(){
 IO.println("hello, world");
}
```

Yes, that's _it_. No other code required. no imports. no `public static`, no `String[] args`, nothing! Try it out. If you're on Java 24, you can run that today. Save it as `script.java`, and then run it. How? Just pass the Java.. Script.. to the `java` command. No need for compilation! This feature - the source code execution - is _already_ a feature that is GA.

So, all together then:

```
java script.java
```

And you should see `hello, world`! Neat, eh? But what can you do with this? What if we wanted a library on the classpath? Well then you'd have to get into the busy business of managing the classpath declaration each time you run the _script_. You remember how to do that, right? Surely.

I don't want to, even if I do remember how, either! Instead, we can use a handy community tool called JBang.dev, which has a bit of a pre-processor that does some amazing things to make writing _Java scripts_ (that space is very important!) a lot more pleasant. One of the niceties? You can declare dependencies using `//` comments at the top of the code page using Maven-style coordinates.

Another? You can declare a _shebang_ line, which is the line that UNIX operating systems will use to determine which program to run the contents of a given file on the very first line of a text file.

And, finally, JBang can manage the version of the JDK used to run the program. If it's not already present, JBang will _download_ it for us! We can even tell it to use a _preview_ version. LOL! Amazing.

Not that anybody asked for it, but here's a silly, but working user interface built in Java's Swing library, but pulling in an unrelated Java Swing dependencies from Maven Central. As long as you have JBang.dev installed, _this_ is all you need to run the program!

Save it to a file called `swing.java`. You can run it directly: `jbang swing.java`, or just execute it: `./swing.java`.

```java
//usr/bin/env jbang  "$0" "$@" ; exit $?
//JAVA 25
//PREVIEW
//DEPS com.fifesoft:rsyntaxtextarea:3.1.1

import org.fife.ui.rsyntaxtextarea.RSyntaxTextArea;
import org.fife.ui.rsyntaxtextarea.SyntaxConstants;

import javax.swing.*;

void main() {

    javax.swing.SwingUtilities.invokeLater(() -> {
        var frame = new JFrame("Swing FTW");

        var panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));

        //
        var editor = new RSyntaxTextArea(20, 60);
        editor.setSyntaxEditingStyle(SyntaxConstants.SYNTAX_STYLE_JAVA);
        editor.setCodeFoldingEnabled(true);
        var scroll = new JScrollPane(editor);
        panel.add(scroll);

        //
        frame.setContentPane(panel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null); // center on screen
        frame.pack();
        frame.setVisible(true); // this shows the frame
    });
}
```


It's 30 lines of verbose Swing code and you get dependency management, a JDK, and running programming for your troubles.

## Enterprise Java Script?

Nice! Can we use it with Spring, with a "p", not a "w"?  I thought you'd never ask!

In order to do this, however, we need to look at one more feature of JBang: catalogs. You can define interesting code as an extra source, and have it pull Maven dependencies from a Git repository. Our friend Dr. Dave Syer (cofounder or founder of Spring Boot, Spring Batch, Spring Cloud, Spring gRPC, etc., has put together some glue code and a B.O.M. dependency for us in his Github. With that in mind, let's build a trivial Spring Boot and Spring AI application.


```java
//usr/bin/env jbang  "$0" "$@" ; exit $?
//JAVA 25
//PREVIEW
//SOURCES springbom@scratches
//DEPS https://github.com/scratches/spring-script
//DEPS org.springframework.boot:spring-boot-starter-web
//DEPS org.springframework.ai:spring-ai-starter-model-openai

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class JokesController {

    @Autowired ChatClient ai;

    @GetMapping("/joke")
    String joke() {
        return ai.prompt("tell me a joke").call().content();
    }
}

@Bean
ChatClient chatClient(ChatClient.Builder builder) {
    return builder.build();
}

void main() {
    SpringScript.run();
}
```

This program brings in Spring AI's support for OpenAI. The Spring AI OpenAI autoconfiguration  requires that you specify an API key, which I've done as an environment variable, `SPRING_AI_OPENAI_API_KEY`.

Spring needs to know how your objects are wired together. You do this in one of two ways: `@Bean`-annotated provider methods _or_ component scanning (so called because Spring discovers all the classes  annotated with eithe `@Component` or another annotation, like `@RestController`, which itself is annotated with `@Component`). You can see we have one example of both here. To keep things svelte, I used field-injection. Ugh. Please don't this. :D I also should probably have made the `JokesController` static. But it all worked out.  Run the program (same as before, though maybe you could name this one `spring.java`) and if you've specified an environment variable, as I have, you should be able to visit localhost:8080/joke for a groaner of a joke from OpenAI.

What about other configuration? The OpenAI key being an environment variable makes sense as an environment variable because we would not want it hardcoded, but we can also load other, less variable or sensitive configuration from a property file, as usua. Just add teh following near the top of the class:

```properties
//FILES src/main/resources/application.properties
```

Are you drunk with power yet?

## Editing

I haven't tried Eclipse or Visual Studio Code with this arrangement, but apparently it's possible to get those to work with some configuration. There is a Jetbrains IntelliJ IDEA plugin from JBang.dev that, once installed, makes editing these Java Scripts a breeze!

## Next Steps

Ah. God. I don't know. I've never had this much power in Java. I've had something approaching it in Kotlin. But in Java? Absurd. I can see Java scripts replacing more and more of the little utilities I have around my system for work. I use a Java script that I've been using for a year now that I quite like. It's simple, and needs no dependencies, but it works. All it does is unzip a `.zip` file and then run `idea pom.xml` or `idea build.gradle` or `idea build.gradle.kts`. Nothing fancy, but it's more concise, typesafe, and performant than Bash, so I love it. Here's that code.

```java

// eg: java --enable-preview --source 24  ~/josh-env/bin/UnzipAndOpen.java $HOME/Downloads/demo.zip

import java.io.*;
import java.util.function.*;
import java.util.* ;

void main(String [] args) throws Exception {
    var zipFile = new File(args[0]);
    var zipFileAbsolutePath = zipFile.getAbsolutePath();
    var folder = new File(zipFileAbsolutePath.substring(0, zipFileAbsolutePath.lastIndexOf(".")));
    new ProcessBuilder().command("unzip", "-a", zipFileAbsolutePath).inheritIO().start().waitFor();
    for (var k : Set.of("build.gradle", "build.gradle.kts", "pom.xml")) {
        var buildFile = new File(folder, k);
        if (buildFile.exists()) {
            new ProcessBuilder().command("idea", buildFile.getAbsolutePath()).inheritIO().start().waitFor();
        }
    }
}
```

I should convert  this to use JBang.dev. I guess that's the next step. Find cool things and make them more convenient. It's hard to overstate how cool this is. Remember: that one source code artifact is _both_ the code and the build! Even Python and Node.js and whatever have at least two files for anything with a dependency. Sometimes I just want a simple script. Now I can have it. So, go, GO. Java Script all the things!
