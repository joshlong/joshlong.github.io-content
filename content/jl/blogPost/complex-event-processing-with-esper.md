
title=Complex Event Processing with Esper and Spring Boot 
date=2023-01-15
type=post
tags=blog
status=published
~~~~~~



How intelligent is your application? No, not every application has to use GPT4 to do its work. A little intelligence goes a long way! Just ask my dog. Not very smart, relative to Chat GPT or your average human, but plenty intelligent enough to get the job done. For example, does your application know the difference between discrete and complex events? No? Then it's not nearly smart enough! 

The real world is full of complex events. Events that, taken together, imply something else. A typical example is fraud detection. Suppose I withdraw USD 250 from my account at an ATM at 16:00 in San Francisco, California, USA, and then - ten minutes later - at 16:10 -  I withdraw USD 100 from an ATM in Casablanca, Morocco. Individually, either of these events is innocuous enough but taken together; something is amiss! 

It would be best if you could work with facts (_events_) and analyze them through the prism of _time_. Time and count, more specifically. Enter Esper. Esper is _not_ a new piece of software. It's been around forever. I liked it when I first learned about it in the late 20 "aughts," maybe 2007? It's a convenient little library that lets you persist and query events in a repository. The query language is the part of it that's most magic. It enables you to ask questions about interrelated events and define smart correlation logic between them, such as whether they occurred within a specific time of each other or if they are in a particular grouping - called a _context_. 

There are a lot of moving parts, but basically, your application will start up, compile an expression and then deploy that compiled expression. As things are added to the repository, those queries will be evaluated, and any and all listeners attached to those queries will be invoked. 


That's the super high-level, big-picture description of what you can expect to do. The trouble is that putting the pieces together was, as I discovered, quite tricky. The documentation is pretty overwhelming, and the getting started experience is even worse so. So, I put together a Spring Boot 3.x starter that's now on Maven central:

* `com.joshlong` : `esper-spring-boot-starter` : `0.0.1`

Create a Spring Boot application on the [Spring Initializr (you know where to: start.spring.io)](https://start.spring.io). Then, add the starter to your Maven or Gradle builds as usual, with one caveat: it depends on a version of a library that conflicts with the version management provided by Spring Boot, so you need to wrangle that version down manually.

Here's how you'd do it in a Gradle build:

```groovy
project.ext["janino.version" ] = '3.1.6'
```

Here's how you'd override the dependency in Apache Maven: 

```XML

<properties>
    <!-- ... -->
    <janino.version>3.1.0</janino.version>
</properties>

```

That done; let's look at an example in Java, though any JVM language will work. 

The use case is trivial: we're a bank and want to know when two withdrawals occur within a small window of time from different locations. 

In this case, we're going to emit certain events - just `WithdrawlEvent`. (Unfortunately, there's no easy out-of-the-box support for Java ` record's, _yet_, so we're using our trusty old friend, [Project Lombok](https://projectlombok.org/))


```java
package bootiful;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WithdrawalEvent {
	private float amount;
	private String user, location;
}

```

We'll need to tailor the Esper `Configuration` class so that it knows about these types. Please think of this as registering our data schema with the repository. NB: this is  _not_ Spring's `@Configuration`, but an object of the same name. The Spring Boot autoconfiguration will define a default instance of this type. The autoconfiguration exposes a `com.joshlong.esper.EsperConfigurationCustomizer` interface. You could just define your own `Configuration` bean and the autoconfiguration will defer to your definition. If there are multiple creations to make to the `Configuration`, it'll be easier to implement the interface. Create a bean that implements this type and use it to tailor the Esper `Configuration`:


"`java
	@Bean
	EsperConfigurationCustomizer esperConfigurationCustomizer() {
		return configuration -> List.of( WithdrawalEvent.class)
		   .forEach(eventType -> configuration.getCommon().addEventType(eventType));
	}
```

Finally, we're going to want to create our queries and attach a listener to them:


"`java
package bootiful;

import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompiler;
import com.espertech.esper.runtime.client.EPDeploymentService;
import com.espertech.esper.runtime.client.EPEventService;
import com.joshlong.esper.autoconfiguration.EsperConfigurationCustomizer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

import java.util.List;

...

	@Bean
	InitializingBean esperDeploymentsIntialization(
			com.espertech.esper.common.client.configuration.Configuration configuration, EPCompiler compiler,
			EPDeploymentService deploymentService, ApplicationEventPublisher publisher) {
		return () -> {

			var epl = """
					create context PartitionedByUser partition by user  from WithdrawalEvent ;

					@name('withdrawals-from-multiple-locations')
					context PartitionedByUser select * from pattern [
					 every  (
					  a = WithdrawalEvent ->
					  b = WithdrawalEvent ( user = a.user, location != a.location) where timer:within(5 minutes)
					 )
					]
					""";
			var deployment = deploymentService.deploy(compiler.compile(EPL, new CompilerArguments(configuration)));
			var statement = deploymentService.getStatement(
				deployment.getDeploymentId(),
					"withdrawals-from-multiple-locations");
			// this listener is invoked when the Esper CEP engine determines fraud
			epStatement.addListener((newEvents, oldEvents, statement, runtime) -> {
				var a = (WithdrawalEvent) newEvents[0].get("a");
				var b = (WithdrawalEvent) newEvents[0].get("b");
				publisher.publishEvent(new FraudEvent(a, b));
			});
		};
	}

...

```


So, now, whenever somebody emits an event, it'll be added to the repository, and this query, called `withdrawals-from-multiple-locations`, will be invoked.

Let's define a client that works with Esper to emit events:


"`java
@Component
@RequiredArgsConstructor
class BankClient {

	private final EPEventService eventService;

	public void withdraw(String username, float amount, String location) {
		// persist or do something
		var withdrawalEvent = new WithdrawalEvent(amount, username, location);
		this.eventService.sendEventBean(withdrawalEvent, WithdrawalEvent.class.getSimpleName());
	}
}
```

So, somebody uses the bank client to make a withdrawal. The client publishes an event to the repository. This forces the engine to evaluate the query, which looks at whether two withdrawal events exist from the same account but from different locations within a certain (presumably small) period. For example, suppose two withdrawals have been made from different locations in the same time window. In that case, we take this opportunity to publish a Spring `ApplicationContextEvent`, notifying interested listeners that something has gone wrong. Here, we emit a _new_ event - a Java `record` called `FraudEvent` - which contains the pair of `WithdawalEvents`. Remember, this `FraudEvent` is not for Esper, but for other components in the Spring application context.


