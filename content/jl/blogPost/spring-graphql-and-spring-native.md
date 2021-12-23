title= Spring GraphQL and Spring Native 
date=2021-12-18
type=post
tags=blog
status=published
~~~~~~

The sample code that I'm reproducing here can be [found in this Github Repository](https://github.com/joshlong/graphql-spring-native).

I wanted to make Spring GraphQL and Spring Native work well together. It's pretty easy to get the absolute basic application working. Go to the Spring Initializr and generate a new application usign Spring Webflux an Spring Native. Spring GraphQL works with both the Servlet API (and something like Apache Tomcat) and the reactive, non-blocking Spring Webflux webstack. I obviously quite prefer anything reactive, so I chose that. 

The next bit's not so easy: you need to add the dependency to the build for Spring GraphQL itself. The project's not yet on the Spring Initializr as of the time of this writing. You'll have to do things the old fashioned way.


Add the dependency proper:


```xml
<dependency>
	<groupId>org.springframework.experimental</groupId>
	<artifactId>graphql-spring-boot-starter</artifactId>
	<version>1.0.0-M4</version>
</dependency>
```

Then add the Maven repositories by which you can resolve that dependency: 

```xml
 <repositories>
    <repository>
        <id>spring-milestones</id>
        <name>Spring Milestones</name>
        <url>https://repo.spring.io/milestone</url>
    </repository>
    <repository>
        <id>spring-snapshots</id>
        <name>Spring Snapshots</name>
        <url>https://repo.spring.io/snapshot</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
    <repository>
        <id>spring-releases</id>
        <name>Spring Releases</name>
        <url>https://repo.spring.io/release</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>
<pluginRepositories>
    <pluginRepository>
        <id>spring-releases</id>
        <name>Spring Releases</name>
        <url>https://repo.spring.io/release</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </pluginRepository>
</pluginRepositories>

```


That done, you can put together a trivial Spring GraphQL application (`src/main/java/com/example/graphqlnative/GraphqlNativeApplication.java`) that looks like this: 


```java
package com.example.graphqlnative;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.NativeDetector;
import org.springframework.core.io.ClassPathResource;
import org.springframework.graphql.boot.GraphQlSourceBuilderCustomizer;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.nativex.hint.ResourceHint;
import org.springframework.nativex.hint.TypeAccess;
import org.springframework.nativex.hint.TypeHint;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;

import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@SpringBootApplication
public class GraphqlNativeApplication {

	public static void main(String[] args) {
		SpringApplication.run(GraphqlNativeApplication.class, args);
	}
}

@Controller
class CustomerGraphQlController {


	private final Map<Integer, Customer> db;

	CustomerGraphQlController() {
		var ctr = new AtomicInteger();
		this.db = List
			.of("Tammie", "Kimly", "Josh", "Peanut")
			.stream()
			.map(name -> new Customer(ctr.incrementAndGet(), name))
			.collect(Collectors.toMap(Customer::id, customer -> customer));

	}

	@QueryMapping
	Flux<Customer> customers() {
		return Flux.fromIterable(this.db.values());
	}
}

record Customer(Integer id, String name) {
}
```

You'll also need to define some schema for the application. Create a schema file, `src/main/resource/graphql/schema.graphqls`, and specify the following content:

```
type Query {
    customers : [Customer]
}
type Customer {
    id: ID
    name :String
}
```


Run the application on the JRE, and open up `http://localhost:8080/graphiql/` and you'll be confronted with a fancy dashboard/console you can use to query your new GraphQL endpoints. Clear the text that starts with `#` and type out the following: 


```
query {

	customers {
		id, name
	}
}
```

Hit Command / Control + Enter and you should see four records return. 

Alrighty, everything's good on the JRE. What about in the world of GraalVM and Spring Native? Well, there, as you can imagine, things get considerably more difficult. 

The first problem is that the way that the GraphQL auto configuration works right now is that it tries to resolve the `schema.graphqls`, and indeed any other file in that folder, using a `PatterResourceResolver`, which _scans_, after a fashion, the contents of the classpath. But there is no classpath in a GraalVM native image. If we'd specified a classpath URL and then used that to laod the resource from the `.jar`, we could provide a Sprign Native `@ResourceHint`, specifying the pattern of the resource, and feed that into the GraalVM native image compiler.

The problem is that we don't do that. What we're in essence trying to do is _scan_ the classpath and then load the things we find. Since there's no classpath, there's nothing to find. And so we never end up loading it in the first place. I don't know how to make that work in a more natural way just yet. I found soemthing a bit hackety, but it works: specify a `org.springframework.graphql.boot.GraphQlSourceBuilderCustomizer` which adds the `Resource` we'd like to load to the chain of "discovered" resources. In a GraalVM native image context, nothng will be discovered, so our  customization will have the effect of adding the one resource that should've been discovered in the first place. On the JRE, however, the resource _will_ be discovered, so we need to make sure we only _add_ the resource in a Native Image. 

Here's a definition that does the trick: 

```java

	@Bean
	GraphQlSourceBuilderCustomizer graphQlSourceBuilderCustomizer() {
		return builder -> {
			// this part isn't great, but:
			// right now the PatternResourceResolver used to 'find' the schema files on the classpath fails because
			// in the graalvm native image world there is NO classpath to speak of. So this code manually
			// adds a Resource, knowing that the default resolution logic fail. But, it only does so in
			// a GraalVM native image context
			if (NativeDetector.inNativeImage())
				builder.schemaResources(new ClassPathResource("graphql/schema.graphqls"));
		};
	}
```


Next, we'll need to account for the resource we do plan on loading, so add the following hint to your `@SpringBootApplication`-annotated class: 

```java 
@ResourceHint(patterns = {"graphql/schema.graphqls" })
```

We're also going to reflectively access the `Customer` domain type, so let's add a hint for that in the same fashion as the `@ResourecHint`. Add the following:


```java
@TypeHint(types = Customer.class, access = {TypeAccess.DECLARED_METHODS, TypeAccess.DECLARED_CONSTRUCTORS})
```

Goody. That done, let's turn to building out some hints for Spring GraphQL itself, not just our code. 


Since this will be largely the same no matter what Spring GraphQL application you're building, I've extracted the hints out into a separate `NativeConfiguration` class that'll get loaded when the application is compiled. 


Here's the definition of the class.


```java

package org.springframework.experimental.graphql;

import graphql.GraphQL;
import graphql.analysis.QueryVisitorFieldArgumentEnvironment;
import graphql.analysis.QueryVisitorFieldArgumentInputValue;
import graphql.execution.Execution;
import graphql.execution.nextgen.result.RootExecutionResultNode;
import graphql.language.*;
import graphql.parser.ParserOptions;
import graphql.schema.*;
import graphql.schema.validation.SchemaValidationErrorCollector;
import graphql.util.NodeAdapter;
import graphql.util.NodeZipper;
import org.springframework.nativex.hint.ResourceHint;
import org.springframework.nativex.hint.TypeHint;
import org.springframework.nativex.type.NativeConfiguration;

import java.util.List;

import static org.springframework.nativex.hint.TypeAccess.*;

/**
	* Provides Spring Native hints to support using Spring GraphQL in a Spring Native application.
	*
	* @author <a href="mailto:josh@joshlong.com">Josh Long</a>
	*/
@TypeHint(
	typeNames = {
		"graphql.analysis.QueryTraversalContext",
		"graphql.schema.idl.SchemaParseOrder",
	},
	types = {
		Argument.class,
		ArrayValue.class,
		Boolean.class,
		BooleanValue.class,
		DataFetchingEnvironment.class,
		Directive.class,
		DirectiveDefinition.class,
		DirectiveLocation.class,
		Document.class,
		EnumTypeDefinition.class,
		EnumTypeExtensionDefinition.class,
		EnumValue.class,
		EnumValueDefinition.class,
		Execution.class,
		Field.class,
		FieldDefinition.class,
		FloatValue.class,
		FragmentDefinition.class,
		FragmentSpread.class,
		GraphQL.class,
		GraphQLArgument.class,
		GraphQLCodeRegistry.Builder.class,
		GraphQLDirective.class,
		GraphQLEnumType.class,
		GraphQLEnumValueDefinition.class,
		GraphQLFieldDefinition.class,
		GraphQLInputObjectField.class,
		GraphQLInputObjectType.class,
		GraphQLInterfaceType.class,
		GraphQLList.class,
		GraphQLNamedType.class,
		GraphQLNonNull.class,
		GraphQLObjectType.class,
		GraphQLOutputType.class,
		GraphQLScalarType.class,
		GraphQLSchema.class,
		GraphQLSchemaElement.class,
		GraphQLUnionType.class,
		ImplementingTypeDefinition.class,
		InlineFragment.class,
		InputObjectTypeDefinition.class,
		InputObjectTypeExtensionDefinition.class,
		InputValueDefinition.class,
		IntValue.class,
		InterfaceTypeDefinition.class,
		InterfaceTypeExtensionDefinition.class,
		List.class,
		ListType.class,
		NodeAdapter.class,
		NodeZipper.class,
		NonNullType.class,
		NullValue.class,
		ObjectField.class,
		ObjectTypeDefinition.class,
		ObjectTypeExtensionDefinition.class,
		ObjectValue.class,
		OperationDefinition.class,
		OperationTypeDefinition.class,
		ParserOptions.class,
		QueryVisitorFieldArgumentEnvironment.class,
		QueryVisitorFieldArgumentInputValue.class,
		RootExecutionResultNode.class,
		ScalarTypeDefinition.class,
		ScalarTypeExtensionDefinition.class,
		SchemaDefinition.class,
		SchemaExtensionDefinition.class,
		SchemaValidationErrorCollector.class,
		SelectionSet.class,
		StringValue.class,
		TypeDefinition.class,
		TypeName.class,
		UnionTypeDefinition.class,
		UnionTypeExtensionDefinition.class,
		VariableDefinition.class,
		VariableReference.class,
	}, //
	access = {//
		PUBLIC_CLASSES, PUBLIC_CONSTRUCTORS, PUBLIC_FIELDS, PUBLIC_METHODS,
		DECLARED_CLASSES, DECLARED_CONSTRUCTORS, DECLARED_FIELDS, DECLARED_METHODS
	} //
)
@ResourceHint(patterns = {  "graphiql/index.html"})
public class GraphQlNativeHints implements NativeConfiguration {
}

```



In order for Spring Native to discover that type, you'll need to register it in the `src/main/resources/META-INF/spring.factories` file, like so:


```properties
org.springframework.nativex.type.NativeConfiguration=\
  org.springframework.experimental.graphql.GraphQlNativeHints
```


That done, you can build and run the application like this: 


```shell
#!/usr/bin/env bash
mvn -DskipTests=true -Pnative clean package && ./target/graphql-native
``` 


When I run it, I get output like the following: 


```shell
17:00:47.748 [main] INFO org.springframework.boot.SpringApplication - AOT mode enabled
2021-12-18 17:00:47.765  INFO 91366 --- [           main] o.s.nativex.NativeListener               : This application is bootstrapped with code generated with Spring AOT

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.6.1)

2021-12-18 17:00:47.767  INFO 91366 --- [           main] c.e.g.GraphqlNativeApplication           : Starting GraphqlNativeApplication v0.0.1-SNAPSHOT using Java 17.0.1 on mbp2019.local with PID 91366 (/Users/jlong/Downloads/graphql-native/target/graphql-native started by jlong in /Users/jlong/Downloads/graphql-native)
2021-12-18 17:00:47.767  INFO 91366 --- [           main] c.e.g.GraphqlNativeApplication           : No active profile set, falling back to default profiles: default
2021-12-18 17:00:47.789  INFO 91366 --- [           main] o.s.g.b.GraphQlWebFluxAutoConfiguration  : GraphQL endpoint HTTP POST /graphql
2021-12-18 17:00:47.802  INFO 91366 --- [           main] o.s.b.web.embedded.netty.NettyWebServer  : Netty started on port 8080
2021-12-18 17:00:47.803  INFO 91366 --- [           main] c.e.g.GraphqlNativeApplication           : Started GraphqlNativeApplication in 0.051 seconds (JVM running for 0.052)

```

Good stuff. Even better? The RSS - the memory of the application taken - is a mere 49.9M. Enjoy! 
