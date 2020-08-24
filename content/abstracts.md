title=Abstracts
date=2016-01-30
type=page
status=published
~~~~~~

All talks are workable in a one-hour slot  unless otherwise noted.


## The RSocket Revolution 

[RSocket is here!](http://RSocket.io) RSocket is a binary, reactive, and operations-friendly wire protocol that integrates that builds on top of Project Reactor. Engineers originally developed RSocket at Netflix. Then they moved to Facebook. RSocket was the fledgling project for the Reactive Foundation, of which the spring team, Lightbend, Facebook, Alibaba, and others are founding members. RSocket represents the operational insight of some of the largest organizations in the world. And, it readily integrates with Spring. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](http://twitter.com/starbuxman) in this rapid, reactive ride on the RSocket rocket, and we'll look at the rich Spring support for RSocket and its use in building faster, more robust and more scalable services. 

* How to build RSocket-based controllers in Spring Framework 
* Build RSocket clients using the `RSocketRequester`
* How to use the `rsc` client 
* Build processing pipelines using Spring Integration 
* Secure our services with Spring Security 
* Introduce bidirectional communication 
* and more!

##  Cloud Native Java, part deux 

You know what nobody has ever said to me? "I wish you'd covered even more in your 45 minute 'Cloud Native Java' talk!" And I listened! In this talk, we'll look at Spring Cloud.next to support modern microservices development, focusing on the things that *really* matter (or, at least, the things we've got cooking in Spring Boot 2.0 and Spring Cloud Finchley, both due before April or so):

- functions-as-a-service with Spring Cloud Function. We've got FUNCTIONS (wrapped in apps, in containers, running on servers, in datacenters)
- functional reactive REST endpoints (totally different meaning for "function" here, though)
- reactive programming with Spring Framework 5. Leverage flow control at every layer and make the most efficient use of every  CPU when doing input/output. You're going to need every bit of efficiency that you can get after you've installed the patches for Spectre and Meltdown!
- Kotlin. Yes, KOTLIN: you wanted Java and I'm giving it to you.. in libraries that I'll use from Kotlin.
- messaging with Apache Kafka. Nothing funny here. It's just awesome.
- Live on the edge with the new, reactive, rate-limiting, proxying, websocket-aware Spring Cloud Gateway 
- ASCII art!

## Spring and the Clouds 

Production is my favorite place on the internet. I LOVE production. YOU should love production. You should go as early, and often, as possible. Bring the kids, the whole family. The weather is amazing! It's the happiest place on earth! In this talk, join Spring Developer Advocate Josh Long (your friendly neighborhood @starbuxman) to learn how to use Spring as the onramp to production, and to cloud platforms like Azure Spring Cloud, Cloud Foundry, and more.   

## The Bootiful (Reactive) Application

Alright, so maybe "bootiful" won't ever work, but I tried, and it was worth it too because you're reading this. Spring Boot, the new convention-over-configuration centric framework from the Spring team at Pivotal, marries Spring's flexibility with conventional, common sense defaults to make application development not just fly, but pleasant! Spring Boot aims to make address the common functional and non-functional requirements that gate quickly moving to production.

Join Spring developer advocate Josh Long for a look at what Spring Boot is, why it's turning heads, why you should consider it for your next application (REST, micro services, web, batch, big data, integration, whatever!) and how to get started.

## Reactive Spring


Microservices and big-data increasingly confront us with the  limitations of traditional input/output. In traditional IO, work that is IO-bound dominates   threads. This wouldn't be such a big deal if we could add more threads cheaply, but threads are expensive on the JVM, and most other platforms. Even if threads were cheap and infinitely scalable, we'd still be confronted with the faulty nature of networks. Things break, and they often do so in subtle, but non-exceptional ways. Traditional approaches to integration bury the faulty nature of networks behind overly simplifying abstractions. We need something better. 

Spring Framework 5 is here ! It introduces the Spring developer to a growing world of support for reactive programming across the Spring portfolio, starting with a new Netty-based web runtime, component model and module called Spring WebFlux, and then continuing to Spring Data Kay, Spring Security 5.0, Spring Boot 2.0 and Spring Cloud Finchley. Sure, it sounds like a lot, but don't worry! Join me, your guide, Spring developer advocate Josh Long, and we'll explore the wacky, wonderful world of Reactive Spring together.



## Bootiful Testing (1-3h)

How would you feel if you knew that any pat of the code was at most a few minutes away from being shippable and delivered into production?  How would you feel if you knew that any part of the code is a few ctrl+z's away from being shippable and delivered into production? Emboldened and confident? Test driven development (TDD) gives you that. TDD allows you to proceed with confidence that you're building the right thing. It provides you with imminent-horizons that you can meet and    measure. TDD gives developers the confidence to go faster, secure in the knowledge that what they break they will fix and be able to improve. In this talk, join Spring Developer Advocate Josh Long (@starbuxman) as he looks at how to test Spring applications and services. We'll look at how to test basic components, mocks, how to take advantage of test slices, and how to test web applications. We'll also  look at how to  ensure that  API producers and API consumers work well together using consumer driven contract testing (CDCT) without sacrificing the testing pyramid for  end-to-end integration tests.


## Bootiful Kotlin


Spring Boot, the convention-over-configuration centric framework from the Spring team at Pivotal, marries Spring's flexibility with conventional, common sense defaults to make application development on the JVM not just fly, but pleasant! Spring Boot aims to make address the common functional and non-functional requirements that gate quickly moving to production. The framework is as clean as it gets, wouldn't it be nice if the language matched its elegance?

Kotlin, the productivity-focused language from our friends at JetBrains, takes up the slack to make the experience leaner, cleaner and even more pleasant!

The Spring and Kotlin teams have worked hard to make sure that Kotlin and Spring Boot are a first-class experience for all developers trying to get to production, faster and safer. Come for the Spring and stay for the Bootiful Kotlin.




## Cloud Native Java (3-6h)

“It is not necessary to change. Survival is not mandatory.” -W. Edwards Deming

Work takes time to flow through an organization and ultimately be deployed to production where it captures value. It’s critical to reduce time-to-production. Software - for many organizations and industries - is a competitive advantage. Organizations break their larger software ambitions into smaller, independently deployable, feature -centric batches of work - microservices. In order to reduce the round-trip between stations of work, organizations collapse or consolidate as much of them as possible and automate the rest; developers and operations beget “devops,” cloud-based services and platforms automate operations work and break down the need for ITIL tickets and change management boards. But velocity, for velocity’s sake, is dangerous. Microservices invite architectural complexity that few are prepared to address. In this talk, we’ll look at how high performance organizations like Ticketmaster, Alibaba, and Netflix make short work of that complexity with Spring Boot and Spring Cloud.

In this workshop we'll look at how to build cloud-native Java systems that are elastic, agile, observable and robust.

## Cloud Native Java (5-10 Days)

“It is not necessary to change. Survival is not mandatory.” -W. Edwards Deming

Work takes time to flow through an organization and ultimately be deployed to production where it captures value. It’s critical to reduce time-to-production. Software - for many organizations and industries - is a competitive advantage.

Organizations break their larger software ambitions into smaller, independently deployable, feature -centric batches of work - microservices. In order to reduce the round-trip between stations of work, organizations collapse or consolidate as much of them as possible and automate the rest; developers and operations beget “devops,” cloud-based services and platforms automate operations work and break down the need for ITIL tickets and change management boards.

But velocity, for velocity’s sake, is dangerous. Microservices invite architectural complexity that few are prepared to address. In this talk, we’ll look at how high performance organizations like Ticketmaster, Alibaba, and Netflix make short work of that complexity with Spring Boot and Spring Cloud.

In this workshop we'll look at how to build cloud-native Java applications. A cloud native application is:

* elastic
* agile
* observable
* robust

A cloud native application is one that is designed to fully exploit a cloud platform both in the application layer - where things decompose into microservices - and at the data layer where NoSQL offers better horizontal scaling and fitness for specific purpose. This is what we mean by *elastic*.

A cloud native application is one that is _agile_. It should be easy to write,  change, test, deploy and operate. If the cost of change is prohibitive  then normal people under normal situations won't do it. We must make doing the right thing - that which supports change - the easy thing.

A cloud native system is _observable_. It must support at-a-glance insight into what is happening in the system and support remediation. It must be instrumented at the application and systems levels to support the effort of crisis-management.

A cloud native application is one that is _fault tolerant_, or *robust*. If a service should fail, the system must be able to recover and degrade gracefully.  Instead of trying to build a system that is predicated on the lie that things are highly available, build instead to optimize for time to remediation.

In this workshop we'll cover:

- *Basics* - we'll look at Spring Boot application development concepts like auto-configuration and embedded web container deployments (Spring Boot)

- *REST APIs* - we'll look at concerns like API versioning and hypermedia. (Spring MVC, Spring Boot, Spring HATEOAS)

- *Data Access* - we'll model  a service domain and define bounded contexts. (Spring Boot, Spring Data)

- *Observability* - what happens when there's a problem with your production application? How quickly can your team respond? How do you know if you're making improvements to a system? How do you measure progress? How do you monitor individual applications? How do you monitor the flow of requests through circuit breakers? How do you trace requests across the system? Can you visualize all the services in the system? We'll look at how to surface information about your services and systems. (Spring Boot Actuator, Micrometer, Graphite, Spring Cloud Sleuth, OpenZipkin, Spring Cloud Hystrix Dashboard)

- *Testing* -  we'll look at the concepts of test-driven development. We'll cover unit testing individual components and mock them out. We'll look at how to test service interfaces. We'll look at how to write integration tests that don't sacrifice speed in order to be exhaustive using consumer driven contracts and consumer driven contract testing.  (JUnit, Spring Boot, Spring MVC Test Framework, Spring Cloud Contract)

- *Routing and Load-Balancing* - where does your service live? How do your clients find it? How do you handle custom routing requirements? How do you handle custom load-balancing? (Spring Cloud, Ribbon)

- *Message-driven and integration-centric architectures*  -  We'll look at how to build microservices that talk to each other over messaging fabrics like Apache Kafka or RabbitMQ. We'll look at how to integrate existing systems and how to use messaging to connect disparate systems. (RabbitMQ, Spring Integration, Spring Cloud Stream)

- *Stream Processing* - We'll look at how to build solutions that process ongoing data over time. We'll look at how to compose messaging-based microservices and orchestrate them over a cloud-based fabric. (Spring Cloud Stream, Spring Cloud Data Flow)

- *Partitioned Batch Processing* - In this section we'll look at how to process large amounts of sequential data and scale the processing across a cloud fabric. We'll look at how to scale processing horizontally as our processing needs demand. (Spring Batch, Spring Integration)

- *Reliability Patterns* - In this section we'll look at how to employ retries and circuit breakers to build fault-tolerence into service invocations. We'll look at approaches to gracefully degrade if a service invocation should fail. (Spring Cloud Hystrix, Spring Retry, Spring Boot)

- *Ad-hoc Task Processing* - Need to send an email? Resize an image? Generate a report? In this section we'll look at a few ways to distribute these longer-running workloads across a cloud fabric. (Spring Batch, Spring Cloud Task, Spring Cloud Data Flow)

- *Workflow* - In this section we'll look at how to use a workflow engine to choreograph work across a cloud platform, using  messaging-centric microservics and incorporating human actors to achieve a result. (Activiti, Spring Cloud Stream)

- *Edge-services* - In this section we'll look at how to build client-centric adapter APIs. and concerns like rate limiting, backends-for-front-ends, proxying, and other cross-cutting concerns. (Spring Cloud, Zuul, Spring Cloud Gateway)

- *Security* - In this section we'll look at how to secure individual microservices. We'll look at how to perpetuate authenticated principals across service invocations with OAuth. (Spring Boot, Spring Security OAuth, Spring Cloud Security)

- *Service Registration and Discovery* - In this section we'll look at how to register and discover services dynamically with a service registry like Netflix Eureka or Hashicorp Consul. (Spring Cloud)

- *Functions-as-a-service* - In this section we'll look at how to build serverless-style applications (Spring Cloud Function)


## The Reactive Revolution (SpringOne Tour 2019 Talk)


The reactive revolution continues. For as much as we've been talking about reactive programming in Spring for the last few years the journey has only just begun. Join me, Spring Developer Advocate Josh Long (@starbuxman), and we'll take our reactive applications further, looking at how to build microservices for cloud platforms like Pivotal Application Service (Cloud Foundry) and PKS (Kubernetes). 

Some of the things we may cover include: 

* reactive NoSQL data access 
* reactive SQL data access with R2DBC 
* orchestration and reliability patterns like client-side loadbalancing, circuit breakers, and hedging 
* messaging and service integration with Apache Kafka or RSocket 
* API gateways with Spring Cloud Gateway and patterns like rate limiting and 
* API adapters 
* serverless programming with Spring Cloud Function and project Riff 
* reactive authentication and authorization with Spring Security 

