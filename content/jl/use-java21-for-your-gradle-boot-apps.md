title=Spring Boot and Gradle on Java 21 
date=2023-10-10
type=post
tags=blog
status=published
~~~~~~


hey, while Gradle doesn't officially support Java 21, you can still build and work with Spring Boot on Java 21. 

Here are the steps:

* install GraalVM and Java 21: `sdk install 21-graalce`
* create a [new project on the Spring Initializr](https://start.spring.io/#!type=gradle-project&language=java&platformVersion=3.2.0-M3&packaging=jar&jvmVersion=21&groupId=com.example&artifactId=demo&name=demo&description=Demo%20project%20for%20Spring%20Boot&packageName=com.example.demo&dependencies=native,web)
* open it in your IDE. I did: `idea build.gradle`. Make sure to point your IDE JDK to Java 21.
* add the following method to your `DemoApplication.java` 

```
@Bean
ApplicationRunner runner () {
 return args -> Executors
   .newVirtualThreadPerTaskExecutor()
   .submit(() -> System.out.println("hello, world!"));
}
```

* `./gradlew bootRun // it's running Java 21 code in Gradle`
* `./gradlew bootJar && java -jar ./build/libs/demo-0.0.1-SNAPSHOT.jar // it's produced a binary with Java 21`
