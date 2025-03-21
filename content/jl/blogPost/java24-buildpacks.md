title=Using Buildpacks on Java 24
date=2025-03-21
type=post
tags=blog
status=published
~~~~~~


Want to use Buildpacks with Java 24 and native images? 

* incept a new project at the Spring Initializr. I'm using Maven. 
* choose Java 24 (what else would you choose? It's almost April 2025!) 
* add the following XML below to your Maven build's `<plugins>` section.
* then build it `./mvnw -Dmaven.test.skip=true spring-boot:build-image -Pnative` 

```xml

 <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
          <image>
            <env>
              <BP_JVM_VERSION>24</BP_JVM_VERSION>
            </env>
            <buildpacks>
              <buildpack>gcr.io/paketo-buildpacks/graalvm</buildpack>
              <buildpack>urn:cnb:builder:paketo-buildpacks/java-native-image</buildpack>
            </buildpacks>
          </image>
        </configuration>
      </plugin>

```

(This works on Apple Silicon MacBook Pro M4's, too, by the way!) 

I love this. 

Enjoy your journey to production! 