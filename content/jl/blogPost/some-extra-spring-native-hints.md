title=I've published some extra Spring Native hints  
date=2022-02-24
type=post
tags=blog
status=published
~~~~~~

Hi, Spring fans! I've just published some extra Spring Native hints to Maven 
Central under the coordinates `com.joshlong`:`hints`:`0.0.1`. These [hints](https://github.com/bootiful-spring-graalvm) provide integrations
for a number of libraries and projects that don't yet have a home in their respective projects. My hope is that, with the introduction of GraalVM
native image support in Spring Framework 6 and Spring Boot 3, that these become irrelevant in time. If you want to learn about Spring Native,
today, then check out this YouTube video I did a few months ago on the topic.


<iframe width="560" height="315" src="https://www.youtube.com/embed/DVo5vmk5Cuw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Supported Libraries

* the Spring GraphQL project 
* Liquibase 
* the official Kubernetes Java client 
* the Fabric8 Kubernetes Java client
* Twitter4J 

I suspect that I'll probably add more and more to this project, and then - with the introduction of Spring Framework 6 and Spring Boot 3 - convert them 
to work with that mechanism and then, hopefully, disperse them to the various projects themselves, obviating the need for this project. 

Enjoy!
