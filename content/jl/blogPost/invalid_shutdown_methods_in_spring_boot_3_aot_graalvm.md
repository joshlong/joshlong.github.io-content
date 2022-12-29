title=Oddity with `shutdown` methods in Spring Boot 3 AOT and GraalVM
date=2022-12-29
type=post
tags=blog
status=published
~~~~~~

Suppose you've got this innocuous looking Spring Boot 3 (well, `3.0.1`, in particular) program that runs just fine on the JRE (go ahead, try it: `mvn spring-boot:run`). 

Now you go and turn it into a GraalVM native image using the new Spring Framework 6 AOT engine: `mvn -Pnative -DskipTests native:compile`. It should compile just fine, but when you run it: 

```shell
./target/shutdown 
```

You'll get a horrific  stacktrace that complains:


```shell
org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'ready': Unsatisfied dependency expressed through method 'ready' parameter 0: Error creating bean with name 'scheduledExecutorService': Invalid destruction signature
```

Ultimately, you'll see: 

```
Caused by: org.springframework.beans.factory.support.BeanDefinitionValidationException: Could not find a destroy method named 'shutdown' on bean with name 'scheduledExecutorService'
```

I don't know why this is happening, but for now - late December 2022 - you can fix it by making the destroy method explicit or nullifying it, like this:


```java
	
	...

	@Bean(destroyMethod = "")
    ScheduledExecutorService scheduledExecutorService() {
        return Executors.newScheduledThreadPool(Runtime.getRuntime().availableProcessors());
    }

    ...

```

Recompile and things should work just fine.

Happy new year!
