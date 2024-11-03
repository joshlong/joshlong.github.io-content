title=A New Developer's Journey in 2024
date=2024-11-03
type=post
tags=blog
status=published
~~~~~~


I get this question a lot: “I’m learning Java and would love your idea of a roadmap.” In this post, I’ll try to tackle that very question.

I don’t think there’s any single thing you need to focus on. It really depends on your use case. If you want to build a mobile app, the skills for that—especially for Android—are very different from using the JVM on the server side. It also depends on your proficiency.

Do you know how to write valid Java code?

## Java 101

If you want to learn Java itself, the language, then you might want to focus on that for a while—but not too long! The best way to learn is to dive in and build something. My all-time favorite Java book is Thinking in Java, but it’s huge. If you prefer tutorials, Angie Jones has some great video tutorials.

Make sure you know:

	-	Variable declarations
	-	Visibility modifiers (Hint: the more private, the better)
	-	Control flow (for, while, maybe do/while)
	-	Collections, generics, and streams
	-	Reference vs. primitive types
	-	Methods
	-	Basic object orientation (classes, inheritance, polymorphism, method overloads, super(), etc.)
	-	final
	-	Basic I/O (start with something like files)
	-	Basic concurrency

There are a lot of developers in the Java community who also use Kotlin. It's a completely different language, but it runs on the JVM, just like code compiled from Java. So, maybe this is worth exploring. I certainly think so. 

### References:
	- 	[Angie Jones' Java tutorials](https://angiejones.tech/free-java-course-test-automation/)
	-	My all time double dutch favorite Java book: ["Thinking in Java"](https://www.mindviewllc.com)

## Spring 101

### Getting Started

	-	start.spring.io
	-	Creating a new project
	-	Git-Clone-Run with Docker Compose
	-	Data-Oriented Programming
	-	Data
	-	HTTP
	-	Extending Spring Boot


### Advanced Spring Boot
	-	Auto-configuration
	-	Building a starter
	-	Modular monoliths

### Data Driven Applications
 	- 	JDBC
 	- 	PostgreSQL 
 	- 	`JdbcClient`
 	-	the repository pattern
 	- 	Spring Data JDBC
 	- 	NoSQL 

	

### Production-Ready Features
	-	Spring Boot Actuator
	-	Virtual Threads
	-	GraalVM


### Cloud Native Computing 
	- 	Docker
	-	Buildpacks
	-	Kubernetes

### Artificial Intelligence
	- 	image models, chat models, transcription models, etc.
	-	Ollama
	-	Spring AI

### Event-Driven Architecture
	-	Simplicity scales
	-	Decoupling with events
	-	External events

### Microservices
	-	Messaging
	-	Security with Spring Authorization Server
	-	Spring Cloud Gateway to introduce a UI

### Operations
	-	Observability
	-	Alerting
	-	Metrics
	-	Distributed tracing
	-	Micrometer.io

### Security
	-	Authentication
	-	Authorization
	-	OAuth



### References:
	- 	[Spring Academy](https://spring.academy)
	-	[the Spring guides](https://spring.io/guides)
	- 	I do an OK set of videos on the [_Spring Tips_ playlist](https://bit.ly/spring-tips-playlist) or [on my own channel](https://youtube.com/@coffeesoftware).



I know it won't be possible to learn all of this quickly. As you get towards the end of this list, focus more on understanding the concepts and feel free to ping me josh@joshlong.com or via DM on Blueskye (starbuxman.joshlong.com) or Twitter (@starbuxman) if you need help. 


Good luck, and enjoy your journey to production!
