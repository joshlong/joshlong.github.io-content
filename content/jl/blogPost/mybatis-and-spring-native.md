title=MyBatis and Spring Native 0.11.x
date=2021-12-18
type=post
tags=blog
status=published
~~~~~~

Hi, Spring fans! I've been working on getting various projects working with the [latest-and-greatest Spring Native release](https://spring.io/blog/2021/12/09/new-aot-engine-brings-spring-native-to-the-next-level). Spring Native is a framework that helps derive the hints for your Spring Boot application so  that they work correctly in a GraalVM natively compiled context. I did an extensive Spring Tips video on the topic just a week ago, and you should definitely check that out for the skinny on [what's new and nice in Spring Native 0.11.x](https://www.youtube.com/watch?v=DVo5vmk5Cuw&list=PLgGXSWYM2FpPw8rV0tZoMiJYSCiLhPnOc&index=3). Most Spring Boot applications doing typical bean creation and injection should work out of the box. The tricky bits are when you're trying to work with frameworks that leverage some of the JVM's more dynamic capabilities, like reflection and proxies. So, I've been looking at some of those more interesting use cases and seeing what it'd take to make them work with Spring Native. 

As part of that, I've been working on making [Spring Retrosocket work with Spring Native (tl;dr: it does!)](https://github.com/spring-projects-experimental/spring-retrosocket). I've been working with [Matt Rabile](https://twitter.com/mraible) on [making JHipster work with Spring Native (tl;dr: it _mostly_ does!)](https://www.linkedin.com/pulse/jhipster-works-spring-native-part-2-matt-raible/). 

And now I'm looking at what's required to make MyBatis work with Spring Native. So far, I've managed to make the core MyBatis Spring module work with Spring Native. I haven't yet tried the MyBatis Spring Boot Starter. Here's what's needed to make [MyBatis Spring](https://mybatis.org) work. 

I went to the [Spring Initializr](https://start.spring.io) and generated  a new project with `MyBatis`, the embedded SQL Database `H2`,`Lombok`, and `Spring Native` selected. I'm using Java 17. (Tangent: it appears that MyBatis doesn't yet support Java `record` types: boo! I wouldn't need `Lombok` if it did...).

In a typical Spring Native integration, there are two parts: the parts that are common to all the users of a library, and the parts that are unique to a particular user of a library. Let's look at the example, _in toto_, and then we'll look  at what we had to add to make it work as a native application.

MyBatis is a SQL mapper framework that's been around in some incarnation or another for almost as long as Spring has been. It works well and is widely used. I noticed that a ton of orgs and random users in China were also leveraging it, for example. 

A MyBatis application has a few typical components. A _mapper_ is a Java `interface` that defines queries, sort of like a Spring Data repository. 

Here's my trivial mapper: 

```java
package com.example.mybatisnative;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import java.util.Collection;

@Mapper
public interface CityMapper {

	@Insert("INSERT INTO city (name, state, country) VALUES(#{name}, #{state}, #{country})")
	@Options(useGeneratedKeys = true, keyProperty = "id")
	void insert(City city);

	@Select("SELECT id, name, state, country FROM city ")
	Collection<City> findAll();

}
```

This in turn maps SQL data from  my `city` table into Java objects of type `City`. 

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
class City {
	private Integer id;
	private String name, state, country;
}
```


In the following example, we setup a few objects that are responsible for factorying the mapper interface into a usable object.


```java
@SpringBootApplication(exclude = {
	MybatisLanguageDriverAutoConfiguration.class,
	MybatisAutoConfiguration.class
})
public class MybatisNativeApplication {

	public static void main(String[] args) {
		SpringApplication.run(MybatisNativeApplication.class, args);
	}

	@Bean
	SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
		return new SqlSessionTemplate(sqlSessionFactory);
	}

	@Bean
	CityMapper cityMapper(SqlSessionTemplate sqlSessionTemplate) {
		return sqlSessionTemplate.getMapper(CityMapper.class);
	}

	@Bean
	SqlSessionFactoryBean sqlSessionFactory(DataSource dataSource) throws Exception {
		SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		factoryBean.setDataSource(dataSource);
		Configuration configuration = new Configuration();
		configuration.addMapper(CityMapper.class);
		factoryBean.setConfiguration(configuration);
		return factoryBean;
	}

	@Bean
	ApplicationRunner runner(CityMapper cityMapper) {
		return args -> {

			for (var c : cityMapper.getClass().getInterfaces())
				System.out.println("class: " + c.getName());

			cityMapper.insert(new City(null, "NYC", "NY", "USA"));
			cityMapper.findAll().forEach(System.out::println);
		};
	}
}


```

Since we used the Spring Initializr to setup the application, it brought in the Spring Boot starter and its autoconfiguration, not just the core MyBatis Spring integration. If you're trying to make something work with Spring Native, always reduce the surface area of the integration. Get one small thing to work at a time and then scale up. So, in the example above, you'll note that I've _excluded_ the autoconfiguration from the Spring Boot autoconfiguration. 

That looks to be most of the application. I'm using H2 however, which is an embedded SQL database, so I need to initialize the schema with a file, `src/main/resources/schema.sql`:


```sql

CREATE TABLE city
(
  id      INT PRIMARY KEY auto_increment,
  name    VARCHAR,
  state   VARCHAR,
  country VARCHAR
);
```

I also installed some sample data, with a file `src/main/resources/data.sql`:

```sql
insert into city(name, state, country) values( 'San Francisco' , 'CA', 'USA') ;
insert into city(name, state, country) values( 'Boston' , 'MA', 'USA') ;
insert into city(name, state, country) values( 'Portland' , 'OR', 'USA') ;
```

Run the program on the JRE and you should see some output and everything should be fine. 

If you compile it to a native application, however, you'll run into trouble: 

```shell
mvn -DskipTests=true -Pnative clean package
```


You're going to need to tell Spring Native about your mapper (`CityMapper`) and the entity, `City`, so that it knows you're going to create proxies from a given type and that you're going to reflect on that type. Add the following to the top of your application's `@SpringBootApplication`-annotated type. 

```java
import org.springframework.nativex.hint.JdkProxyHint;
import org.springframework.nativex.hint.TypeHint;
import static org.springframework.nativex.hint.TypeAccess.*;


@TypeHint(
	types = {City.class, CityMapper.class},
	access = {
		PUBLIC_CONSTRUCTORS,
		PUBLIC_CLASSES,
		PUBLIC_FIELDS,
		PUBLIC_METHODS,
		DECLARED_CLASSES,
		DECLARED_CONSTRUCTORS,
		DECLARED_FIELDS,
		DECLARED_METHODS
	}
)
@JdkProxyHint(types = CityMapper.class)

``


This handles your unique incompatabilities, but doesn't help with the tons of reflection and proxy-work that MyBatis does behind the scenes. I've extracted all of that into a reusable, standalone `NativeConfiguration` class.


```java
package org.mybatis.spring.nativex;


import org.apache.ibatis.javassist.util.proxy.ProxyFactory;
import org.apache.ibatis.javassist.util.proxy.RuntimeSupport;
import org.apache.ibatis.logging.Log;
import org.apache.ibatis.logging.commons.JakartaCommonsLoggingImpl;
import org.apache.ibatis.logging.jdk14.Jdk14LoggingImpl;
import org.apache.ibatis.logging.log4j.Log4jImpl;
import org.apache.ibatis.logging.log4j2.Log4j2Impl;
import org.apache.ibatis.logging.nologging.NoLoggingImpl;
import org.apache.ibatis.logging.slf4j.Slf4jImpl;
import org.apache.ibatis.logging.stdout.StdOutImpl;
import org.apache.ibatis.scripting.defaults.RawLanguageDriver;
import org.apache.ibatis.scripting.xmltags.XMLLanguageDriver;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.nativex.hint.InitializationHint;
import org.springframework.nativex.hint.InitializationTime;
import org.springframework.nativex.hint.NativeHint;
import org.springframework.nativex.hint.TypeHint;
import org.springframework.nativex.type.NativeConfiguration;

import static org.springframework.nativex.hint.TypeAccess.*;


/**
	* Registers hints to make a MyBatis Mapper work in a Spring Native context
	*
	* @author Josh Long
	*/
@NativeHint(
	initialization = {
		@InitializationHint(initTime = InitializationTime.BUILD, types = org.apache.ibatis.type.JdbcType.class)
	},
	options = {"--initialize-at-build-time=org.apache.ibatis.type.JdbcType"}
)
@TypeHint(
	types = {
		RawLanguageDriver.class,
		XMLLanguageDriver.class,
		RuntimeSupport.class,
		ProxyFactory.class,
		Slf4jImpl.class,
		Log.class,
		JakartaCommonsLoggingImpl.class,
		Log4jImpl.class,
		Log4j2Impl.class,
		Jdk14LoggingImpl.class,
		StdOutImpl.class,
		NoLoggingImpl.class,
		SqlSessionFactory.class, SqlSessionFactoryBean.class,
	}, //
	access = {
		PUBLIC_CONSTRUCTORS,
		PUBLIC_CLASSES,
		PUBLIC_FIELDS,
		PUBLIC_METHODS,
		DECLARED_CLASSES,
		DECLARED_CONSTRUCTORS,
		DECLARED_FIELDS,
		DECLARED_METHODS
	})

public class MyBatisNativeConfiguration
	implements NativeConfiguration {

}

```

Spring Native won't invovle this `NativeConfiguration` implementation in the build unless you register it in the `src/main/resources/META-INF/spring.factories` service loader.

```properties
org.springframework.nativex.type.NativeConfiguration =org.mybatis.spring.nativex.MyBatisNativeConfiguration
```

With all that in place, re-run the build and you should get output like the following: 


```
11:07:40.651 [main] INFO org.springframework.boot.SpringApplication - AOT mode enabled
2021-12-18 11:07:40.669  INFO 6857 --- [           main] o.s.nativex.NativeListener               : This application is bootstrapped with code generated with Spring AOT

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.6.1)

2021-12-18 11:07:40.670  INFO 6857 --- [           main] c.e.m.MybatisNativeApplication           : Starting MybatisNativeApplication v0.0.1-SNAPSHOT using Java 17.0.1 on mbp2019.local with PID 6857 (/Users/jlong/Downloads/mybatis-native/target/mybatis-native started by jlong in /Users/jlong/Downloads/mybatis-native)
2021-12-18 11:07:40.670  INFO 6857 --- [           main] c.e.m.MybatisNativeApplication           : No active profile set, falling back to default profiles: default
2021-12-18 11:07:40.696  INFO 6857 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-12-18 11:07:40.698  INFO 6857 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-12-18 11:07:40.702  INFO 6857 --- [           main] c.e.m.MybatisNativeApplication           : Started MybatisNativeApplication in 0.051 seconds (JVM running for 0.052)
class: com.example.mybatisnative.CityMapper
City(id=1, name=San Francisco, state=CA, country=USA)
City(id=2, name=Boston, state=MA, country=USA)
City(id=3, name=Portland, state=OR, country=USA)
City(id=4, name=NYC, state=NY, country=USA)
2021-12-18 11:07:40.704  INFO 6857 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Shutdown initiated...
2021-12-18 11:07:40.704  INFO 6857 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Shutdown completed.
```


I've preserved all the code for this in the `mybatis-spring` [branch in this Git repository](https://github.com/joshlong/mybatis-spring-native/tree/mybatis-spring). 