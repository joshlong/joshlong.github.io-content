title=Abstracts
date=2021-04-02
type=page
status=published
listed=true
~~~~~~


All talks are workable in a one-hour slot  unless otherwise noted.

## Bootiful Spring Applications

Hi, Spring fans! There's never been a better time to be a JVM / Spring developer! Spring brings the worlds of security, batch processing, NoSQL and SQL data access, enterprise application integration, web and microservices, gRPC, GraphQL, observability, AI, agentic systems, and so much more to your doorstep. In this talk we're going to look at some of the amazing opportunities that lay before the Spring Boot developer in 2025!

## Bootiful Spring Boot: the Deep-Dive 

Hi, Spring fans! Developers today are being asked to deliver more with less time and build ever more efficient services, and Spring is ready to help you meet the demands. In this workshop, we'll take a roving tour of all things Spring, looking at fundamentals of the Spring component model, look at Spring Boot, and then see how to apply Spring in the context of batch processing, security, data processing, modular architecture, miroservices, messaging, AI, and so much more. 

Here's a rough outline whose contents we may, or may not, get to assuming enough time (a day or two):

The code [is here](bit.ly/spring-tips-playlist) and you can learn more about this stuff on the [channel I help run](https://youtube.com/@coffeesoftware)

### Basics
* which IDE? IntelliJ, VSCode, and Eclipse
* your choice of Java: GraalVM
* start.spring.io, an API, website, and an IDE wizard 
* Devtools
* Docker Compose 
* Testcontainers
* banner.txt

### Development Desk Check
* the Spring JavaFormat Plugin 
	* Python, `gofmt`, your favorite IDE, and 
* the power of environment variables
* SDKMAN
	* `.sdkman`
* direnv 
	*  `.envrc`
* a good password manager for secrets 

### Data Oriented Programming in Java 21+ 
* an example

### Beans
* dependency injection from first principles
* bean configuration
* XML
* stereotype annotations
* lifecycle 
	* BeanPostProcessor
	* BeanFactoryPostProcessor
* auto configuration 
* AOP
* Spring's event publisher
* configuration and the `Environment`
* configuration processor

### AOT & GraalVM
* installing GraalVM 
* GraalVM native images 
* basics
* AOT lifecycles

### Scalability 
* non-blocking IO
* virtual threads
* José Paumard's demo
* Cora Iberkleid's demo 


### Cloud Native Java (with Kubernetes)
 * graceful shutdown 
 * `ConfigMap` and you 
 * Buildpacks and Docker support
 * Actuator readiness and liveness probes

### Data 
* `JdbcClient`
* SQL Initialization
* Flyway
* Spring Data JDBC


### Web Programming
* clients: `RestTemplate`, `RestClient`, declarative interface clients
* REST
	* controllers
	* functional style
* GraphQL 
	* batches


### Architecting for Modularity
* Privacy
* Spring Modulith 
* Externalized messages
* Testing 

### Batch Processing 
* Spring Batch
* load some data from a CSV file to a SQL database

### Microservices
* centralized configuration 
* API gateways 
	* reactive or not reactive
* event bus and refreshable configuration
* service registration and discovery

### Messaging and Integration
* "What do you mean by Event Driven?"
* Messaging Technologies like RabbitMQ or Apache Kafka
* Spring Integration
* files to events

### Kafka 
* a look at Spring for Apache Kafka 
* Spring Integration 
* Spring Cloud Stream
* Spring Cloud Stream Kafka Streams

### Security 
* adding form login to an application
* authentication 
* authorization
* passkeys
* one time tokens
* OAuth 
	* the Spring Authorizatinm Server
	* OAuth clients
	* OAuth resource servers
	* protecting messaging code



## Bootiful Spring Boot: A DOGumentary

Spring Boot 3.x and Java 21 have arrived, making it an exciting time to be a Java developer! Join me, Josh Long (@starbuxman), as we dive into the future of Spring Boot with Java 21. Discover how to scale your applications and codebases effortlessly. We'll explore the robust Spring Boot ecosystem, featuring AI, modularity, seamless data access, and cutting-edge production optimizations like Project Loom's virtual threads, GraalVM, AppCDS, and more. Let's explore the latest-and-greatest in Spring Boot to build faster, more scalable, more efficient, more modular, more secure, and more intelligent systems and services.


## Bootiful Spring AI

The age of artificial intelligence (because the search for regular intelligence hasn't gone well..) is nearly at hand, and it's _everywhere_! But is it in your application? It should be. AI is about integration, and here the Java and Spring communities come second to nobody. In this talk, we'll demystify the concepts of modern day Artificial Intelligence and look at its integration with the white hot new Spring AI project, a framework that builds on the richness of Spring Boot to extend them to the wide world of AI engineering.

## Bootiful GraphQL 

Hi Spring fans! Data wants to be free and so much of what we do in the wide and wonderful world of microservices is all about connecting data. It's difficult. There's a tension between how we build well-encapsulated microservices and how we connect their data in our clients. Until now. Facebook open sourced GraphQL in 2015 (also the same year that "Avengers: Age of Ultron," a movie about a psychotic super computer that wanted to take over the world came out. No coincidence, surely...). GraphQL is an alternative to the REST constraint on HTTP. It provides an easy way to model queries (reads, like an HTTP `GET`), subscriptions (longer-lived, asynchronous notifications sent to the client) and mutations (updates). Join me, Spring Developer Advocate Josh Long (@starbuxman), and we'll look at how to build data gateways for every clients' needs with Spring GraphQL. 

## Bootiful GraalVM 

Hi, Spring fans! Spring Framework 6 and Spring Boot 3 imply a new baseline, bringing the Spring ecosystem in line with the needs of tomorrow's workloads. A huge part of that is the new baselines of Jakarta EE and Java 17 and the new support for GraalVM native images, based on the work of Spring Native. Join me, Spring Developer Advocate Josh Long, and we'll explore the implications of this exciting new technology for your Spring Boot applications and services. 

We'll look at things like using the GraalVM AOT compiler to produce native images that take up a markedly smaller memory footprint and start up in 10s or maybe hundreds of milliseconds. We'll look at how to containerize those workloads. We'll look at how to tame the GraalVM compiler when something goes wrong. And we'll look at how to teach GraalVM about your custom workloads. 


## Bootiful Edge Services 

Hi, Spring fans! So much of the difficult of microservices is not the services themselves, but the clients that connect to them. There are just so many things that can go wrong or cause bumps on the road to production! Clients may not speak the same protocols as the services to which they're connecting. Clients may need to adapt the data coming from services to suit their use cases, tailoring them to the user interface' particular requirements. Join me, Spring Developer Advocate Josh Long (@starbuxman) and we'll look at how to use reactive to build better API adapters, how to use Spring GraphQL to build better data integration gateways, and we'll look at Spring Cloud Gateway to build API gateways. 



## Kubernetes Native Java

Spring is all about helping developers get to production quickly and safely. These days, "production" is all but guaranteed to mean Kubernetes, and Spring has you covered. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](https://twitter.com/starbuxman), and we'll look at how Spring Boot makes writing blisteringly fast, cloud-native, and scalable services more effortless than ever. 


## The RSocket Revolution 

[RSocket is here!](http://RSocket.io) RSocket is a binary, reactive, and operations-friendly wire protocol that integrates that builds on top of Project Reactor. Engineers originally developed RSocket at Netflix. Then they moved to Facebook. RSocket was the fledgling project for the Reactive Foundation, of which the spring team, Lightbend, Facebook, Alibaba, and others are founding members. RSocket represents the operational insight of some of the largest organizations in the world. And, it readily integrates with Spring. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](http://twitter.com/starbuxman) in this rapid, reactive ride on the RSocket rocket, and we'll look at the rich Spring support for RSocket and its use in building faster, more robust and more scalable services. 

* How to build RSocket-based controllers in Spring Framework 
* Build RSocket clients using the `RSocketRequester`
* How to use the `rsc` client 
* Build processing pipelines using Spring Integration 
* Secure our services with Spring Security 
* Introduce bidirectional communication 
* and more!
  

## Reactive Spring


Microservices and big-data increasingly confront us with the  limitations of traditional input/output. In traditional IO, work that is IO-bound dominates   threads. This wouldn't be such a big deal if we could add more threads cheaply, but threads are expensive on the JVM, and most other platforms. Even if threads were cheap and infinitely scalable, we'd still be confronted with the faulty nature of networks. Things break, and they often do so in subtle, but non-exceptional ways. Traditional approaches to integration bury the faulty nature of networks behind overly simplifying abstractions. We need something better. 

Spring Framework 5 is here! It introduces the Spring developer to a growing world of support for reactive programming across the Spring portfolio, starting with a new Netty-based web runtime, component model and module called Spring WebFlux, and then continuing to Spring Data Kay, Spring Security 5.0, Spring Boot 2.0 and Spring Cloud Finchley. Sure, it sounds like a lot, but don't worry! Join me, your guide, Spring developer advocate Josh Long, and we'll explore the wacky, wonderful world of Reactive Spring together.



## Bootiful Testing (1-3h)

How would you feel if you knew that any pat of the code was at most a few minutes away from being shippable and delivered into production?  How would you feel if you knew that any part of the code is a few ctrl+z's away from being shippable and delivered into production? Emboldened and confident? Test driven development (TDD) gives you that. TDD allows you to proceed with confidence that you're building the right thing. It provides you with imminent-horizons that you can meet and measure. TDD gives developers the confidence to go faster, secure in the knowledge that what they break they will fix and be able to improve. In this talk, join Spring Developer Advocate Josh Long (@starbuxman) as he looks at how to test Spring applications and services. We'll look at how to test basic components, mocks, how to take advantage of test slices, and how to test web applications. We'll also  look at how to  ensure that  API producers and API consumers work well together using consumer driven contract testing (CDCT) without sacrificing the testing pyramid for  end-to-end integration tests.


## Bootiful Kotlin

Spring Boot, the convention-over-configuration centric framework from the Spring team at Pivotal, marries Spring's flexibility with conventional, common sense defaults to make application development on the JVM not just fly, but pleasant! Spring Boot aims to make address the common functional and non-functional requirements that gate quickly moving to production. The framework is as clean as it gets, wouldn't it be nice if the language matched its elegance?

Kotlin, the productivity-focused language from our friends at JetBrains, takes up the slack to make the experience leaner, cleaner and even more pleasant!

The Spring and Kotlin teams have worked hard to make sure that Kotlin and Spring Boot are a first-class experience for all developers trying to get to production, faster and safer. Come for the Spring and stay for the Bootiful Kotlin.


## A Bootiful Service 

Hi, Spring fans! Getting to production is hard, but building an application shouldn't be. In this workshop, we will explore several concepts and technologies in the Spring ecosystem to help you make better applications and systems with Spring Boot. 

* **Your First Steps** 
	* basic dependency injection 
	* start.spring.io
* **Java 21**
	* Data-Oriented Programming
	* Virtual Threads
* **Data Driven Applications** 
	* the joy of data
	* Spring Data JDBC
* **The Web**
	* HTTP and REST
	* GraphQL 
* **Structuring your Spring Boot application**
	* decoupling with events
	* clean modular services with Spring Modulith
* **Introducing Messaging** 
	* RabbitMQ or Apache Kafka; the choice is yours 
* **Smarter Clients**
	* We're publishing events, now we need to refresh our view of the data, now what?
	* the Spring declarative clients
* **Security with the Spring Authorization Server**
	* introducing OAuth  
* **Easy API Gateways with Spring Cloud Gateway**
	* sidestepping CORS with a good proxy
	* token relays
* **Packaging for Production**
	* GraalVM native images


## Cloud Native Java (3-6h)

“It is not necessary to change. Survival is not mandatory.” -W. Edwards Deming

Work takes time to flow through an organization and ultimately be deployed to production where it captures value. It’s critical to reduce time-to-production. Software - for many organizations and industries - is a competitive advantage. Organizations break their larger software ambitions into smaller, independently deployable, feature -centric batches of work - microservices. In order to reduce the round-trip between stations of work, organizations collapse or consolidate as much of them as possible and automate the rest; developers and operations beget “devops,” cloud-based services and platforms automate operations work and break down the need for ITIL tickets and change management boards. But velocity, for velocity’s sake, is dangerous. Microservices invite architectural complexity that few are prepared to address. In this talk, we’ll look at how high performance organizations like Ticketmaster, Alibaba, and Netflix make short work of that complexity with Spring Boot and Spring Cloud.


## Cloud Native Java (2 days) 

In this workshop we'll look at how to build cloud-native Java systems that are elastic, agile, observable and robust.

* Bootcamp: this will be our first hands-on experience. It'll be useful as a way to validate that we have most everything required for the course
	* First Steps with Spring 
	* First Steps with Spring Boot 
	* First Steps with Kubernetes 

* Reactive Programming 
	* Motivating Reactive Programming
	* Reactor 
	* Spring Webflux and Spring Data R2DBC
	* Testing Reactive Applications 

* Kotlin 
	* Reactive Streams and coroutines 

* RSocket 
	* basic client/services
	* bidirection client/services 
	* Spring Integration 

* Edge Services 
	* API Gateways with Spring Cloud Gateway
	* Reactive service orchestration and composition 
	* Reliability Patterns like circuit breakers
	* GraphQL 

* Building Observable Services 
	* the Spring Boot Actuator 
	* TSDBs and Micrometer
	* Distributed Tracing with Spring Cloud Sleuth 
	* The Spring Boot Admin 

* Configuration 
	* The Spring Environment abstraction 
	* the Refresh Scope
	* The Spring Cloud Config Server
	* Reading data from config trees and environment variables in a Kubernetes environment 
	* Reading and re-reading configuration data directly from the Kubernetes `ConfigMap` structure itself using the API and Spring Cloud Kubernetes' ConfigMap support

* Service Registration and Discovery 
	* Discovery Servers 
	* Client-side Loadbalancing 

* Packaging for Production 
	* Docker, Buildpacks, KPack, etc.
	* Spring Native and GraalVM 

* Working with the Kubernetes API from Spring 
	* using the Kubernetes Java API 
	* Turning the application into a native binary with GraalVM and Spring Native 



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

 
## Bootiful Kafka: Get the Message!

Hi, Spring fans! I once met Dave Chapelle (no, not _that_ Dave Chapelle!), who was a legend from the messaging industry. He worked on SonicMQ and a bunch of other famous messaging initiatives. He also wrote _the_ O'Reilly book on the Java Messaging Service. I met him once, asked him to sign my copy of the book. He wrote, "Get the message!" and then signed it. I always loved him for that. And that's what I want you to do. Spring Boot and Apache Kafka are leaders in their respective fields and it's no surprise that they work well together. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](https://twitter.com/starbuxman) and we'll look at how to use Spring Boot and Apache Kafka to build better, scalable systems and services so that you, too, can _get the message_! 
