title=Java 10
date=2018-03-20
type=post
tags=blog
status=published
~~~~~~

UPDATE: you can find [the code for this project on my Github](https://github.com/joshlong/spring-boot-and-java-10).

It's my favorite time of the year, the  first day of Spring! Happy Spring equinox!

And, almost as if to ring in the new season with an extra jolt of caffeine, [Java 10 was released today](http://mail.openjdk.java.net/pipermail/announce/2018-March/000247.html), as well! There's so much to enjoy one hardly knows where to get started! So, I set about [downloading the new JDK](http://jdk.java.net/10/) and got it installed on my local machine. I had to do so manually, though. I'm running Ubuntu 17.10, (though I'm eagerly awaiting 18.04 due next month..) and there is no Java 10 / OpenJDK package, yet. This is fine. OpenJDK 10 went GA literally hours ago, so.. not a big deal.

I downloaded the Linux distro for JDK 10, unpacked it and then changed my `JAVA_HOME` variable to point to `$HOME/bin/jdk-10`, which is where I'd unpacked it. I also made sure that my `PATH` variable had  `$JAVA_HOME/bin` on it. I then have to tell Ubuntu to prefer the new JDK, not the existing `defaultjdk` that was already installed. For me, this has been Java 8. I used the following commands to make it work:

```
sudo update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1
sudo update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1
```

Then I had to update the configuration for the alternatives available, telling Ubuntu to prefer the new `java` and `javac` be from the JDK 10 release. This amounted to running `sudo update-alternatives --config java` and choosing the appropriate installation (one of which is the release I manually installed above). I did the same thing again, substituting `javac` for `java`. I opened a new shell and ran `java -version` and `javac -version` to confirm everything had taken. Looked good!

At this point, Ubuntu believed I was running Java 10, but - as I would soon discover - little else did.  

I opened  up [the Spring Initialzr](http://start.spring.io), added `Web`, `JPA`, and `Actuator`, `H2`, and generated a (Maven) project. I unzipped the project and then ran `mvn clean package` and got a number of errors complaining that JAXB was missing. Java 9 dropped support for the various types that used to be part of Java EE as those have since been moved to a separate foundation. So, we have to add the dependency back. Thankfully, the correct version is already managed for us by the Spring Boot starter parent so all that was required was adding the dependency:

```
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
</dependency>
```

You would have had to add this dependency if you were using Java 9, too. I want to use Java 10, though, so I opened the `pom.xml` file and changed the `java.version` property value to be `10`. The Maven surefire plugin broke the build next; it was complaining about not being able to parse the version of the JDK. I overrode the version by redefining the property for the plugin's version: `<maven-surefire-plugin.version>2.21.0</maven-surefire-plugin.version>`.

I then made sure I had the latest version of IntelliJ IDEA - version 2018.1, as of this writing - and set up my JDK as the default in the Default Project Settings and then I opened my new Spring Boot project in IntelliJ and was able to use some of the nice shiny  new features that I've not had a chance to enjoy since the release of Java 8, including local type inference (`var`), and the collection builders `Map.of(..)` and `Set.of(..)`, among other things.

<script src="https://gist.github.com/joshlong/808ff052844e9ed9c05d8e14c52753bb.js"></script>



So far the experience seems to be alright, though I'm sad that I couldn't figure out how to get Lombok working. Here's hoping that gets sorted soon. If you have some other issue not addressed in this post, you might [check the evolving Spring Boot with Java 9 Wiki page](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-with-Java-9) or this example and explainer [from the good Dr. Dave Syer](https://github.com/dsyer/spring-boot-java-9). If you're trying to use Spring Boot with Java 9 modules (Jigsaw) then.. why? But if you must, Nicolas Frankel has a nice few posts that seemed helpful. Here's [part one](https://blog.frankel.ch/migrating-to-java-9/1/) and here's [part two](https://blog.frankel.ch/migrating-to-java-9/2/).
