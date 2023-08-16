title=How to publish an artifact to Artifactory without the Artifactory plugin
date=2023-08-16
type=post
tags=blog
status=published
~~~~~~


Ever wanted to publish an artifact to your instance of the excellent Artifactory artifact repository.. except directly, using `curl`? You have? What's wrong with you? I know why I need to do it and I'm not proud! 

For those others without shame, here's how you'd do it:


```bash
#!/usr/bin/env bash 

export ARTIFACTORY_PASSWORD="YOUR_PW"
export ARTIFACTORY_USERNAME="YOUR_ACCOUNT"

AUTH=$(echo -n "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_PASSWORD}" | base64)
REPO_NAME="libs-release-local"
GROUP_PATH="com/myapp"
ARTIFACT_ID="my-artifact"
VERSION="1.0.0"
URL="https://YOUR_INSTANCE.jfrog.io/artifactory/${REPO_NAME}/${GROUP_PATH}/$ARTIFACT_ID/$VERSION/$ARTIFACT_ID-${VERSION}.jar"
echo $URL 
curl -X PUT -T "./build/libs/my-artifact-1.0.0.jar" -H "Authorization: Basic $AUTH" "$URL"
```

Some notes. First, you should replace the username and password with the ones configured for your scenario. Second, make sure to use `libs-snapshot-local` for `-SNAPSHOT` dependencies, and change the `VERSION`, too.
Also, make sure to customize the URI for the Artifactory instance, pointing it to the right hostname, at a minimum.

Neat, eh?

There are ways to achieve the same thing using just the plain 'ol Gradle publishing machinery, too. Here's an example Gradle build that works for me:

```groovy

plugins {
    id 'java-library'
    id 'maven-publish'
    id "io.spring.dependency-management" version "1.1.3"
}

group = 'com.joshlong'
version = '1.0.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencyManagement {
    imports {
        mavenBom 'org.springframework.boot:spring-boot-dependencies:3.1.2'
    }
}

java {
    sourceCompatibility = '17'
}

dependencies {
    annotationProcessor 'org.springframework.boot:spring-boot-configuration-processor'
    testImplementation "org.springframework.boot:spring-boot-docker-compose"
    implementation "org.springframework.boot:spring-boot-starter-amqp"
    implementation "org.springframework.boot:spring-boot-starter-integration"
    implementation "org.springframework.boot:spring-boot-starter-json"
    implementation "org.springframework.boot:spring-boot-starter-oauth2-resource-server"
    implementation "org.springframework.integration:spring-integration-amqp"
    testImplementation "org.springframework.amqp:spring-rabbit-test"
    testImplementation "org.springframework.boot:spring-boot-starter-test"
    testImplementation "org.springframework.integration:spring-integration-test"
}

tasks.named('test') {
    useJUnitPlatform()
}


publishing {


    repositories {
        maven {
            name = 'artifactory'
            url = 'https://cloudnativejava.jfrog.io/artifactory/libs-snapshot-local' // modify this URL accordingly

            credentials {
                username = project.findProperty("artifactory_user") ?: System.getenv("ARTIFACTORY_USERNAME")
                password = project.findProperty("artifactory_password") ?: System.getenv("ARTIFACTORY_PASSWORD")
            }
        }
    }

    publications {
        mavenJava(MavenPublication) {
            from components.java

            pom {
                name = 'Social Hub Client'
                description = 'the client for the SocialHub service'

            }

            versionMapping {
                allVariants {
                    fromResolutionResult()
                }
            }
        }
    }
}


```

So, you'd either make sure to setup environment variables, or you'd run the build with command line switches to plug in the properties:

```shell
./gradlew -Partifactory_user=my-user  ...  publish
```

And of course, once that's done, it's trivial to use it from a Gradle project, like this:


```groovy
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.1.2'
    id 'io.spring.dependency-management' version '1.1.2'
    id 'org.graalvm.buildtools.native' version '0.9.23'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'


java {
    sourceCompatibility = '17'
}

repositories {
    mavenCentral()
    maven {
        url 'https://cloudnativejava.jfrog.io/artifactory/libs-snapshot-local'
    }
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter'
    implementation 'com.joshlong:social-hub-client:0.0.1-SNAPSHOT'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

Now then, that sorted, back to coding... 

