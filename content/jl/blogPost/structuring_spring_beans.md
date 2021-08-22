title=Structuring Spring Boot Applications 
date=2021-08-22
type=post
tags=blog
status=published
~~~~~~

Its hard to think about structuring applications. Three's a lot to think aout at the higher level -  is it a batch job, a web application, a messaging application, etc., The frameworks - Spring Batch, Spring Webflux, Spring Integration, respectively - will guide those decisions.

It is easier to talk about how to structure your Java objects so that they work well in an IoC conainer like Spring. Remember, at the end of the day, Spring is a big bag of objects. It needs to know how your objects are arranged - how they wire up and how they relate to each other - so that it can provide services to them. It can begin and commit transactions when a method starts and stops. It can create HTTP endpoints that invoke your Spring controller handler methods when a request arrives. It can invoke your message listener objects in response to new messages arriving from an Apache Kafka broker or AWS SQS or RabbitMQ or whatever. The list of things Spring can do goes on and on, but it all assumes that you've registered the objects with Spring, first. 

Spring has a metamodel of your objects - it's sort of like the Java reflection API. It knows which classes have annotations. It knows which objects have consturctors. It knows which dependencies - which beans of which type - a given object depends on. Your job is to help it build up this metamodel sot hat it can manage all your objecets for you. If it can control the creation of your objects, then it can also change the creation of your objects before they get created. 

This is impiortant if Spring is to be able to provide all those services for you. The idea is that you give Spring plain 'ol Java objects (POJOs) and it'll detect annotations on them and use those annotations to wire up the behavior for your services. It can't do that unless it controls the creatino of your Java objects. 

Behind the scenes, it does this by either creating a Java InvocationHandler (a JDK proxy) _or_, more commonly, by using something like CGLIB to create a new class that extends your Java class. This class is a subclass of your class. So, imagine you have a class like this:


```java

class CustomerService  {

	private final JdbcTemplate template; 

	CustomerService (JdbcTemplate jt) {
		this.JdbcTemplate = jt;
	}

    @Transactional 
	public void updateCustomer ( long customerId, String name){
       // .. .
	}
}

```


You want Spring to automatically start and stop a transaction each time that method is invoked. In order for this to work, Spring needs to insert itself before and after your method is called. Behind the scenes, it does smething like this: 


```java
class SpringEnhancedCustomerService extends CustomerService {

    // Spring provides a reference from the applicationContext of type JdbcTemplate
	SpringEnhancedCustomerService (JdbcTemplate jt) {
		 super(JdbcTemplate ) ;
	}


	@Override 
	public void updateCustomer (long customerId, String name) {
		// call Java code to start a JDBC transaction 
		super.updateCustomer(customerId, name);
		// call Java code to stop a JDBC transaction
	}
}

```

In your code, you can then inject a reference to `CustomerService`. You'll stil get one, but not theone you created. You'll get the subclass. It's this magic trick - of you asking for a hat and getting a hat with a rabbit in it instead - that makes Spring so powerful. 

So, it's very important that Spring knows about your objects. There are many ways to do this. 

One, is you can be very explicit. Before Spring Boot, you had two common options: XML and Java configuration. That was 2013 and earlier, however. Nowadays, we don't encourag ethe use of XML, so you're left with Java configuration. Here's an example: 


```java
@Configuration 
class ServiceConfiguration {

 @Bean DataSource h2DataSource (){
 	return ... ;
 }

 @Bean JdbcTemplate JdbcTemplate (DataSource ds) {
 	return new JdbcTemplate(ds);
 }

  @Bean CustomerService customerService (JdbcTemplate jdbcTemplate) {
  	return new CustomerService (jdbcTemplate);
  }
}


```

Here, you're creating three objects and explicitly wiring things together. When Spring starts up it finds the `@Configuration` classes, invokes all the methods annotated with `@Bean`, stores all the reutn values in the application context, and makes them available for injection. If it sees that the method takes parameters, it looks to find any other method that returns a value of that type and invokes it first. This value is then _injected_ into the method as a parameter. If it's already invoked the method for some other injection, then it just reusees the already created instance. 

This approach has the benefit of being explicit - all the information about how your ojbects are wired up is in one place - the configuration classes. But, for classes that you created, it means that you have information in two different places: the class itself, and the configuration class. 

So, there's another, more implicit, approach you can use: component-scanning. In this approach, Spring looks for classes on the classpath that have _stereotype_ annotations, like `@Component` or `@Controller`. All stereotype annotations are ultimately annotated with `@Component`. `@Component` is the lowest, most undifferentiated annotation. If you look at `@Controller`, it is anotated with `@Component`. If you look at `@RestController`, it is annotated with `@Controller`. So there are 3 bits of indirection, but the class annotated with `@RestController` is still treated, at a minimum, like a class annotated ith `@Component`. The specialized annontations add on specialized treatment, but they're still specializations of `@Component`, not alternatives to it. 

So, we might decide that it's annoying to have to define `CustomerService` in the configuration class. After all, if Spring only knew about the class, it could figure out the rest of the relationships by itself, surely? It could look at the constructor and see that, in order to construct an instance of `CustomerService`, it would need a reference to `JdbcTemplate`, which has already been defined elsewhere.

So, that's what component scanning does. You can add `@Service`, another stereotype annotation that's annotated with `@Component`, to the class and then remove the `@Bean` method in the configuration class. Spring wil automatically create the service, it'll provide the required dependencies. It'll also subclass the class to provide those services.

We're making progress, removing ever more boilerplate. But what about the `DataSource` and the `JdbcTemplate`? You need them, but surely you shouldn't have to recreate them each time? This is the insight of Spring Boot. It uses `@Condition` annotations to decorate classes annotated with `@Component` or `@Configuration` to evaluate a test before creating the class or invoking the `@Bean` method. These tests can look for clues in the environment. Let's suppose you have H2 - an embedded, SQL database on the classpath. And you have the `spring-jdbc` library on teh classpath. That jar contains `JdbcTemplate`. It can use a test to test for the presence of those classes on the classpath and infer that you want an embedded SQL DataSource and that you want a `JdbcTemplate`. It has its own configuration to provide those beans for you. So now you can drop the `@Configuration` class completely! Spring Boot provided two of the beans and implied the other one based on the stereotype annotations. 



