title=Abstracts
date=2021-04-02
type=page
status=published
listed=true
~~~~~~


## Bootiful GraalVM 

My first favorite place is production. I love production. You love production. And I don’t know anything that makes it easier to survive and thrive in production than Spring and GraalVM!

In this session, join me -  Spring Developer Advocate Josh Long - and we’ll look at some of the amazing ways that Spring and GraalVM are an insurmountable win for your JVM applications in 2025. Experience blazingly fast startup, better security, and lower footprint for greener and cheaper production deployments!



## Bootiful Spring Boot: A DOGumentary

Spring Boot 4.x and Java 25 have arrived, making it an exciting time to be a Java developer! Join me, Josh Long (@starbuxman), as we dive into the future of Spring Boot with Java 25. We'll learn how to scale your applications and codebases effortlessly, explore the robust Spring Boot ecosystem featuring AI, modularity, seamless data access, security, and cutting-edge production optimizations like Project Loom's virtual threads, GraalVM, AppCDS, and more. Let's explore the latest-and-greatest in Spring Boot to build faster, more scalable, more efficient, more modular, more secure, and more intelligent systems and services.

## Bootiful Spring Boot

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

## Bootiful Spring AI

The age of artificial intelligence (because the search for regular intelligence hasn't gone well..) is nearly at hand, and it's _everywhere_! But is it in your application? It should be. AI is about integration, and here the Java and Spring communities come second to nobody. In this talk, we'll demystify the concepts of modern day Artificial Intelligence and look at its integration with the white hot new Spring AI project, a framework that builds on the richness of Spring Boot to extend them to the wide world of AI engineering.

## Bootiful GraphQL 

Hi Spring fans! Data wants to be free and so much of what we do in the wide and wonderful world of microservices is all about connecting data. It's difficult. There's a tension between how we build well-encapsulated microservices and how we connect their data in our clients. Until now. Facebook open sourced GraphQL in 2015 (also the same year that "Avengers: Age of Ultron," a movie about a psychotic super computer that wanted to take over the world came out. No coincidence, surely...). GraphQL is an alternative to the REST constraint on HTTP. It provides an easy way to model queries (reads, like an HTTP `GET`), subscriptions (longer-lived, asynchronous notifications sent to the client) and mutations (updates). Join me, Spring Developer Advocate Josh Long (@starbuxman), and we'll look at how to build data gateways for every clients' needs with Spring GraphQL. 


## Kubernetes Native Java

Spring is all about helping developers get to production quickly and safely. These days, "production" is all but guaranteed to mean Kubernetes, and Spring has you covered. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](https://twitter.com/starbuxman), and we'll look at how Spring Boot makes writing blisteringly fast, cloud-native, and scalable services more effortless than ever. 

## Bootiful Testing (1-3h)

How would you feel if you knew that any pat of the code was at most a few minutes away from being shippable and delivered into production?  How would you feel if you knew that any part of the code is a few ctrl+z's away from being shippable and delivered into production? Emboldened and confident? Test driven development (TDD) gives you that. TDD allows you to proceed with confidence that you're building the right thing. It provides you with imminent-horizons that you can meet and measure. TDD gives developers the confidence to go faster, secure in the knowledge that what they break they will fix and be able to improve. In this talk, join Spring Developer Advocate Josh Long (@starbuxman) as he looks at how to test Spring applications and services. We'll look at how to test basic components, mocks, how to take advantage of test slices, and how to test web applications. We'll also  look at how to  ensure that  API producers and API consumers work well together using consumer driven contract testing (CDCT) without sacrificing the testing pyramid for  end-to-end integration tests.


## Bootiful Kotlin

Spring Boot, the convention-over-configuration centric framework from the Spring team at Pivotal, marries Spring's flexibility with conventional, common sense defaults to make application development on the JVM not just fly, but pleasant! Spring Boot aims to make address the common functional and non-functional requirements that gate quickly moving to production. The framework is as clean as it gets, wouldn't it be nice if the language matched its elegance?

Kotlin, the productivity-focused language from our friends at JetBrains, takes up the slack to make the experience leaner, cleaner and even more pleasant!

The Spring and Kotlin teams have worked hard to make sure that Kotlin and Spring Boot are a first-class experience for all developers trying to get to production, faster and safer. Come for the Spring and stay for the Bootiful Kotlin.

## Cloud Native Java (3-6h)

“It is not necessary to change. Survival is not mandatory.” -W. Edwards Deming

Work takes time to flow through an organization and ultimately be deployed to production where it captures value. It’s critical to reduce time-to-production. Software - for many organizations and industries - is a competitive advantage. Organizations break their larger software ambitions into smaller, independently deployable, feature -centric batches of work - microservices. In order to reduce the round-trip between stations of work, organizations collapse or consolidate as much of them as possible and automate the rest; developers and operations beget “devops,” cloud-based services and platforms automate operations work and break down the need for ITIL tickets and change management boards. But velocity, for velocity’s sake, is dangerous. Microservices invite architectural complexity that few are prepared to address. In this talk, we’ll look at how high performance organizations like Ticketmaster, Alibaba, and Netflix make short work of that complexity with Spring Boot and Spring Cloud.

## Bootiful Kafka: Get the Message!

Hi, Spring fans! I once met Dave Chapelle (no, not _that_ Dave Chapelle!), who was a legend from the messaging industry. He worked on SonicMQ and a bunch of other famous messaging initiatives. He also wrote _the_ O'Reilly book on the Java Messaging Service. I met him once, asked him to sign my copy of the book. He wrote, "Get the message!" and then signed it. I always loved him for that. And that's what I want you to do. Spring Boot and Apache Kafka are leaders in their respective fields and it's no surprise that they work well together. Join me, Spring Developer Advocate [Josh Long (@starbuxman)](https://twitter.com/starbuxman) and we'll look at how to use Spring Boot and Apache Kafka to build better, scalable systems and services so that you, too, can _get the message_! 
