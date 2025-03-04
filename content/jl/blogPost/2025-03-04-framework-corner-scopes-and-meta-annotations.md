title=The Framework Architect's Corner,  ep. 001: Spring's `Scope` annotation and meta annotations
date=2025-03-04
type=post
tags=blog
status=published
~~~~~~




Hi, Spring fans! You know, a member of the community is working on a sort of framework-y DSL for constructing flows. One of the requirements is to be able to parameterize beans that are managed by Spring. This is a good fit for Spring's scope mechanism. 

Spring uses scopes to control the lifecycle of beans. You know some of them. By default, beans are singletons  - there's only one of them per application. You could use the `@Scope("prototype")` annotation to specify that a bean be re-created each time you inject it. You could use `@Scope("request")` to specify that a bean be re-created for each new Servlet request. You get the idea. Scopes allow you to define the window, the duration, the beginning and the end, of a given object, and to re-initialize it. 

In this quick post we'll look at how to make use of a custom scope implementation. You can create your own by mplementing the `Scope` interface (don't mistake it with the `Scope` annotation type, tho!). We won't get into that in this post. If you want a full example, check out  Spring Framework's [`SimpleThreadScope`](https://github.com/spring-projects/spring-framework/blob/main/spring-context/src/main/java/org/springframework/context/support/SimpleThreadScope.java), which is what we'll look at in this post.


Assuming you have an implementation, you'll need to register it against the `BeanFactory` as early on as possible. Spring provides a `CustomScopeConfigurer`, which is itself a `BeanFactoryPostProcessor`. This type will need to be registered early, so mark its `@Bean` definition as `static`, as shown below. 

In the example below we're telling Spring that some beans may use a new scope, called `thread`, whch is backd by this `SimpleThreadScope`. This implementation binds Spring bean instances to a `ThreadLocal<T>`, such that each unique thread of execution gets its own bean. 

The ecampe below defines `Step` class, which we want to be unique to each thread. So we write the code as though there's only one instance, but if we run the code, you'll see it prints out a unique value instantiated in the constructor of the class. That value will be different, meaning that the bean has bewen created uniquely for each of the ten threads we create in the program. 

To ensure that we get a scoped proxy, you need to opt-in:

```
@Scope(value = "thread", proxyMode = ScopedProxyMode.TARGET_CLASS)
```

This definition works, but its tedious, so I used Spring Framework's fantastic meta-annotatino support to define another, more descriptive and type-safe annotation called `@ThreadScope`. Now, if anybody uses this annotation, it'll be sure to use the `thread` scope and generate a scoped proxy. 


```java
package com.example.demo;

import org.springframework.beans.factory.config.CustomScopeConfigurer;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.context.support.SimpleThreadScope;
import org.springframework.stereotype.Component;

import java.lang.annotation.*;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    static CustomScopeConfigurer threadCustomScopeConfigurer() {
        var configurer = new CustomScopeConfigurer();
        configurer.addScope(ThreadScope.SCOPE_NAME, new SimpleThreadScope());
        return configurer;
    }


    @Bean
    ApplicationRunner runner(MyRunnable myRunnable) {
        return _ -> {
            for (var i = 0; i < 10; i++)
                new Thread(myRunnable).start();
        };
    }
}


@Component
@ThreadScope
class Step {

    private final String uuid;

    Step() {
        this.uuid = java.util.UUID.randomUUID().toString();
    }

    String uuid() {
        return this.uuid;
    }
}

@Component
class MyRunnable implements Runnable {

    private final Step step;

    MyRunnable(Step step) {
        this.step = step;
    }

    @Override
    public void run() {
        System.out.println(this.step.uuid());
    }
}

// NB: this is key! it must be proxyMode = ScopedProxyMode.TARGET_CLASS!
@Scope(value = ThreadScope.SCOPE_NAME, proxyMode = ScopedProxyMode.TARGET_CLASS)
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@interface ThreadScope {

    String SCOPE_NAME = "thread";
}
```

Spring uses scopes all over the place. Spring Batch has its `Step` scope. Spring MVC has `session`, `request`, etc. You can create your own scope thanks to Spring's extraordinaly sophisticated implmentation. 