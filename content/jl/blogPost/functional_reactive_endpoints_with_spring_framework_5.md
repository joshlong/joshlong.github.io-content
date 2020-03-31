title=Functional Reactive Web Endpoints in Spring Framework 5.0 and Spring Boot 2.0
date=2018-02-18
type=post
tags=blog
status=published
~~~~~~

Want to get started with Spring Framework 5's functional reactive web endpoints? Read on..

Spring Framework 5 introduced a new way to build HTTP endpoints that's similar to the handler model in Express.js in the Node.js world, or Sinatra  in the Ruby world, or Ratpack in the Groovy world, or Spark Java in the Java world. The idea is simple: contribute a predicate that matches incoming requests and provide a callback or handler that produces the response when the predicate matches an incoming request. This is a particularly compelling approach in the world of lambdas, in Java 8 or later, or in more sophisticated languages like Groovy, Kotlin, or Scala.

Go to [the Spring Initializr](http://start.spring.io), choose the latest version of Spring   Boot (version 2.0.RC1, as of this writing) in the dropdown menu on the top right, and then type 'Reactive Web' in the 'Search for Dependencies' text input field. You'll be given a default Maven project (though you could have selected Gradle). Open the Maven project in your iDE. IntellIJ will let you File > Open > select `pom.xml`. In Eclipse you can go to File > Import > Maven and then select the `pom.xml`. You'll be given a single class with a `public static void main` method in it and the `@SpringBootApplication` annotation on the Java class. Edit it, adding a single method, to make it look like this:

```
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Flux;

import static org.springframework.web.reactive.function.server.RequestPredicates.GET;

@SpringBootApplication
public class DemoApplication {

	@Bean
	RouterFunction<ServerResponse> routes() {
		return RouterFunctions
				.route(GET("/hi"), request -> ServerResponse.ok().body(Flux.just("Hi, world"), String.class))
				.andRoute(GET("/hello"), request -> ServerResponse.ok().body(Flux.just("Hello, world"), String.class));
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
```

Run the Java program and open the browser at `/hi` and you'll see `Hello, world`.

Congratulations on building your first functional reactive endpoint with Spring Framework 5 (and Spring Boot 2.0).  
