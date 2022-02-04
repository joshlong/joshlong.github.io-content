title=Spring Native Extension Points 
date=2022-02-04
type=post
tags=blog
status=published
~~~~~~

Hi Spring fans! I hope you're doing well. I wanted to touch base with you regarding the new work being done in Spring Native and the work we're doing for Spring Framework 6.

So, we have Spring Native and it has a programming model you can use to dynamically register types for reflection, proxies, resources, etc., as you would in the `.json` files for GraalVM itself directly

Go to the Spring Initializr and generate a new project with `Native`. Then, make sure to add the following dependency to your build then you can write implementations of `NativeConfiguration`, `BeanFactoryNativeConfigurationProcessor`, and `BeanNativeConfigurationProcessor`.

```xml
<dependency>
    <groupId>org.springframework.experimental</groupId>
    <artifactId>spring-aot</artifactId>
    <version>${spring-native.version}</version>
    <scope>provided</scope>
</dependency>
```

These types can be all registered in `META-INF/spring.factories`, along with auto configurations for Spring Boot, like this:

```properties
org.springframework.aot.context.bootstrap.generator.infrastructure.nativex.BeanNativeConfigurationProcessor  = my.BeanNativeConfigurationProcessor

org.springframework.aot.context.bootstrap.generator.infrastructure.nativex.BeanFactoryNativeConfigurationProcessor=\
  my.BeanFactoryNativeConfigurationProcessor

org.springframework.nativex.type.NativeConfiguration=\
  io.cloudnativejava.lucene.MyNativeConfiguration
```

The classes are invoked during build time in the `spring-aot` maven plugin. If you have types you want to register and those types are unknown to Spring, or Spring Boot, then you can easily register them in implementation of `NativeConfiguration`. Use the `registry` instance to programmatically register what types of resources, jni, reflection, or proxies you want.

If you have components that are discovered and managed by Spring (anything contributed via `@Component`, `@Bean`, etc., then you can use either or both of the following types: `BeanNativeConfigurationProcessor` and `BeanFactoryNativeConfigurationProcessor`. These types are special because they are given a chance to inspect the bean definitions in the Spring application context. That last part is very important: you get an object that has metadata about the beans in the Spring application context - its class, interfaces, dependencies, properties, constructors, etc., - but not the actual beans themselves. Don't eagerly initialize a bean! You're safe if you only work with `BeanDescriptor`, `BeanDefinition`, and bean names. 

`BeanNativeConfigurationProcessor` gives you a chance to work with every discovered bean. `BeanFactoryNativeConfigurationProcessor` gives you a chance to work with the whole `BeanFactory`, which is the container for all objects in the system that underpins the `ApplicationContext`.

If you add the code you have just written to the classpath of any module with Spring Native configured (again, go to the [Spring Initializr](https://start.spring.io) and add `Native`) they will contribute hints (configuration) to the final GraalVM build. This is important because it means you get to inspect all the registered components and register hints as necessary. It's also important because you get to run against the same types that will be present in the final native build. You can do reflection, for example, and use that to automatically configure things that meet certain patterns. I like [the Reflections](https://www.baeldung.com/reflections-library) library, which makes it easy to find all types in a given package  that have a particular parent type or a given annotation. You can use this to programmatically register a _lot_ of things, and this hint - unlike the static JSON file - will work whether you refactor the name of the class or delete things or add things. 

I have put a lot of hints in my little [hints project](https://github.com/bootiful-spring-graalvm/hints) for reference, and also Spring Native itself ships dozens (hundreds?) of hints as well. 

Spring Native 0.11 - which we released last November - also does something amazing: it turns all auto-configuration (`@Configuration` component scanning) into the functional/programmatic configuration, and so greatly reduces the amount of reflection done and minimizes the footprint of the resulting native application. 

Spring Native is the research bed for the work we will do to integrate GraalVM native images into Spring Framework 6 and Spring Boot 3, both of which we'll see later this year. I can not tell you that what you do in Spring Native today will not need to be reworked a little for Spring Framework 6, but I think - conceptually - that you should be able to reuse a lot of the work. Figuring out how to build as clean and elegant and minimal a set of hints for GraalVM now is always a good thing. 

 
