title=How to setup the early access builds of Java 21 and GraalVM
date=2023-08-25
type=post
tags=blog
status=published
~~~~~~

# Trying out the new stuff

In order for me to play with Java 21, which - and I can not stress this enough - is coming out on September 19th, 2023!, 

## Installing the JDK 

I went to the [latest release in the Java 21 train](https://github.com/graalvm/graalvm-ce-dev-builds/releases/tag/23.1.0-dev-20230817_2024) and downloaded graalvm-community-java21-darwin-aarch64-dev.tar.gz, since I am on a Mac. Choose the equivalent for you. I downloaded it, and extracted the archive (`tar zxpf graalvm-community-java21-darwin-aarch64-dev.tar.gz`) and then I moved the JDK into a directory I would be able to keep it. 

I am using SDKMan on my machine to manage my Java installation candidates. I did the following command to install that downloaded build as a Java version: `sdk install java 21 ./graalvm-community-openjdk-21+34.1/Contents/Home`. Then I made this new version my default: `sdk default java 21`. Launch a new shell and close all the old ones. 

## Configuring my IDE

I changed the default project settings to remove all the old JDK versions. I made sure I had not only removed the old one but specified the new one in every default project setting i could find. This setting affects which version of Java is assigned to a given project. 

## Configuring my Spring Boot build 

If you go to [the Spring Initializr](https://start.spring.io), you'll notice that the max it'll let you specify, as of the date of publication, is Java 20. Choose that and be sure to choose the latest release of Spring Boot 3.2 which, as of the date of publicatiohn is 3.2 M2. Download it and then, in a text editor, before you've opened it in your IDE, add the following feature enabling preview builds for GraalVM:

```groovy
graalvmNative {

    binaries {
        main {
            buildArgs.add('--enable-preview')
        }
    }
}
```

And make sure of course to set `sourceCompatability = 21`.

That's it. Save your changes and then open the project in your IDE: `idea build.gradle`. If, upon opening it, it's using Java 21 as the JDk in the Run dialog, and in your Java code the following code - `Executors.newVirtualThreadPerTaskExecutor().submit(() -> System.out.println("hello, virtual threads!"))` -  compiles, then you're all set! 


## Fun and Profit
I recommend you try setting `spring.threads.virtual.enabled=true` to active virtual thread executors across the Spring stack. Then try building a native application: `./gradlew nativeCompile`. It'll run and dump out a native binary in `./build/native/nativeCompile`. Run it and now you have a binary that starts in a small fraction of time while taking an inconsequential amount of RAM and supporting thread efficiencies heretofore reserved only for those willing to use reactive programming. Welcome to the future!
