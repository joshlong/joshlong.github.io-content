title=Go, Go, Modern Java in 2023!
date=2023-09-26
type=post
tags=blog
status=published
~~~~~~

It's 2023 and you know nothing about Java. How do you get started? Try this.

* install a Docker daemon to run OCI/Docker images on your machine 
* install [`SDKMAN`](https://sdkman.io) 
* run: `sdk install java 21-graalce && sdk default java 21-graalce`, and then open a new shell 
* visit this URL to generate a [pre-configured project](https://start.spring.io/#!type=maven-project&language=java&platformVersion=3.2.0-M3&packaging=jar&jvmVersion=21&groupId=com.example&artifactId=demo&name=demo&description=Demo%20project%20for%20Spring%20Boot&packageName=com.example.demo&dependencies=native,web,data-jdbc,testcontainers,devtools,postgresql,docker-compose). Click `Generate`.
* open the code in your editor, like IntelliJ IDEA Community Edition or VSCode. I use IntelliJ IDEA, so: `idea pom.xml`
* add the following code to `DemoApplication.java`:

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.annotation.Id;
import org.springframework.data.repository.ListCrudRepository;
import org.springframework.web.servlet.function.RouterFunction;
import org.springframework.web.servlet.function.ServerResponse;

import static org.springframework.web.servlet.function.RequestPredicates.GET;
import static org.springframework.web.servlet.function.RouterFunctions.route;
import static org.springframework.web.servlet.function.ServerResponse.ok;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    RouterFunction<ServerResponse> routes(CustomerRepository repository) {
        return route(GET("/customers"), request -> ok().body(repository.findAll()));
    }
}

interface CustomerRepository extends ListCrudRepository<Customer, Integer> {
}

record Customer(@Id Integer id, String name) {
}
```

* add the following to `application.properties`: 

```properties
spring.threads.virtual.enabled=true
spring.sql.init.mode=always
spring.docker.compose.enabled=false
```

* create `src/main/resources/schema.sql`:

```sql
create table if not exists customer
(
    id   serial primary key,
    name text not null
);
```

* create `src/main/resources/data.sql`:

```sql
insert into customer (name) values ('Josh');
insert into customer (name) values ('Stef');
```

* from the root of the project, in your terminal, run: `./mvnw spring-boot:test-run`

What does that buy you? Well, you've now got an application with an HTTP endpoint (`curl http://localhost:8080/customers`), it's spun up a PostgreSQL Docker image for you and connected to it and initialized the schema for you. It took a _long_ time to startup because it started PostgreSQL for you. On my machine, it took 3.5s. But on subsequent changes, you don't need to restart. Just recompile the code. In IntelliJ IDEA on the Mac, you can use CMD SHIFT F9. In VSCode you just save the code. On my machine it takes 0.36s, basically ten times faster. 

You're running in development mode. In development mode, the PostgreSQL database was automatically started for you. But that's not viable in a production context. There should be a `compose.yml` file in the root of your project. We want to connect to it externally, so change line 9 in `compose.yml` to be: 

```yaml
      - '5432:5432'
```

where it is presently just:

```yaml
      - '5432'
```

Run it: `docker compose up`. Now we can run a production build against a non-ephemeral PostgreSQL database, more like a production environment.

There are two production targets. One is just a regular JRE application: `./mvnw -DskipTests clean package` and then `java -jar target/*jar`. Another, much more interesting, is as an architecture and operating system-specific native image: `./mvnw -DskipTests -Pnative native:compile`. This will produce a native binary after some time. On my machine it took about 1m5s to compile. 

We need to furnish database credentials now, since Spring Boot is no longer creating the database for us. The easiest way is to just use environment variables. This is also very common in a Kubernetes environment, where `ConfigMaps` get turned into environment variables. Try this:

```shell
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost/mydatabase
export SPRING_DATASOURCE_PASSWORD=secret
export SPRING_DATASOURCE_USERNAME=myuser

./target/demo
````

On my machine, the application starts up in about 100ms, or a tenth of a second. Even better, it uses _very_ little RAM. Note the process ID (PID) from the top of the logs. On my machine, the PID is `7854`. Get the RAM: `ps -o rss 7854`. On my machine, it's `112496` kilobytes, or around `112.496 megabytes of RAM. That's _everything_: the full Java runtime, SDK, application code, web server, data-access code, etc., all packed into one statically linked binary. 

You can also build  Docker image: `./mvnw spring-boot:build-image`. `docker tag` and then `docker push` the resulting container.

This code is leveraging _virtual threads_. You might recognize them if you've ever used `async`/`await` in C#, Python, JavaScript, TypeScript, Rust; or `suspend` in Kotlin. Unlike those languages, Java doesn't require the extra verbosity. You simply change the way you create the `java.lang.Thread` and _it just works_. Now you can create _millions_ of threads. Since Spring Boot is creating the threads for us, we didn't do _anything_. Our code doesn't need to change to support it. No need to add modifiers to language elements (functions) like `async`.  

So now you're getting Java's energy efficiencies; it's in the top five most efficient languages, along with C, Rust, C++, and Ada, per [this study in 2018](https://thenewstack.io/which-programming-languages-use-the-least-electricity/). You're getting Go-like scalability, which refers to the number of concurrent requests and threads you can handle. You're getting Go-like memory footprints, too. And you're getting it in a syntax that's _much_ less complicated and more sound (no fiddly string-ly typed code!) than PHP or Typescript can offer. Welcome to 2023. It's an amazing time to be a Java developer. 


