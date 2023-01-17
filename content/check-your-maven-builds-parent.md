title=Adventures in Maven Dependency Conflict Resolution
date=2023-01-19
type=post
tags=blog
status=published
~~~~~~

So, last week I wanted to build a Spring Boot starter for the Esper complex event processing engine. I love Esper, it seems like a natural solution for a common problem. So I built (and published!) the integration (it's `com.joshlong:esper-spring-boot-starter:0.0.1`, by the way), but you wouldn't believe the pain I experienced getting there. So, I don't know that most people will learn much from this blog but I'm going to put it out there, anyway. Here is a retrospective of the things I learned and what I did to address the issues I encountered. 

I started development of the code in a sample application that I generated from the Spring Initialzr. I wanted a sample project in which to do the refactoring required to make this work, alongside the client that would use the auto configuration. Later, I thought, I'll just extract the working autoconfiguration from the main build into a separate `.jar`. No big deal. 

I got it working and extracted as I thought I would. Then I linked the original code to the new library. It didn't work. The code that worked just fine when they were conjoined together stopped working now. It was complaining about a method missing when some code in my library interacted with code in another library. Somehow. 

It's important to keep in mind how Maven works here. If there is a conflict it honors the declaration closest to the source of the build, e.g., my application that linked to the starter. So, if my code defined a version, and a library my build brought in also defined a separate version, then the library implementation would conflict with the one in my build. You need to pin down a specific version In the app. The easiest way is to use the `<dependencyManagement>` section, like this: 

```xml
<dependencyManagement>
  <dependencies>
      <dependency>
          <groupId>group</groupId>
          <artifactId>artifact</artifactId>
      </dependency>
  </dependencies>
</dependencyManagement>
```

Sometimes the coordinates for a dependency change, but you'll want a new version. Easy. Just exclude the dependency from the thing that's bringing it in and then declare a dependency on the new, correct dependency.

```xml
<dependency>
	<groupId>groupo</groupId>
	<artifactId>artifact</artifactId>
	<exclusions>
		<exclusion>
			<groupId>old-group</groupId>
			<artifactId>old-artifact</artifactId>
		</exclusion>
	</exclusions>
</dependency>
<dependency>
	<groupId>new-groupo</groupId>
	<artifactId>new-artifact</artifactId>
</dependency>
```

So, I did _all_ these things and things were still not working! 

This library where the method was missing was almost the latest-and-greatest version of the library. If the current GA version of the library was `1.2.9`, then I was using `1.2.6`, a _minor_ release. Why would anything break in a _minor_ release? It was a hair rending bug indeed. 

I was about to walk away but then I remembered what I just explained to you: Maven draws from the versions defined closest to the build. My build was defining the version, and it was being ignored, but the _parent_ of my build - Spring Boot's parent dependency -  was defining a version, and that's what was being honored! 

This was a perfect storm of sadness: 

- why was Spring Boot managing this tiny little library that I've never seen used anywhere else 
- why would this library have _breaking_ changes in a minor release? 
- why didn't my `<dependencyManagement>` in my `pom.xml` have precedence? 

Sigh. I don't know what the resolution here is, my friends, except check your parent build and demand that your libraries do a better job of maintaining compatibility across minor binary releases! 
