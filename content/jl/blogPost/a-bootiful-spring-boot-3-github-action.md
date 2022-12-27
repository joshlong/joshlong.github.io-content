title=Modern Github Actions in the world of Spring Boot 3
date=2022-12-27
type=post
tags=blog
status=published
~~~~~~


Spring Boot 3.0.0 was released on the same day as the US date for Thanksgiving Day  (November 24th) 2022! (That was also the first time in history I've forgotten to publish that week's installment of a @BootifulPodcast because I was so excited with the new release!) Anyway, it changed everything. The first order of business was to start going around and updating my Github Actions pipelines to use the new native facility and to update code to use it. 

This involved a few key steps:

I needed to change the Spring Boot parent to the new version (`3.0.0`; though, I just realized  `3.0.1` is out as of this writing).

I needed to make sure I had the correct the Spring Cloud version to line up with the new Spring Boot release (`<spring-cloud.version>2022.0.0</spring-cloud.version>`). 

I wanted to make sure that I'm using `<java.version>17</java.version>`. While I was at it, I figured it would be a good time to incoporate my Github Action - [`joshlong/java-version-export-github-action`](https://github.com/joshlong/java-version-export-github-action) - to set the current version of Java as a step output or as an environment variable.

In your `pom.xml`:

```xml
<properties>
	...
	<java.version>17</java.version>
	...
</properties>
```

Then configure the Github Action: 

```yaml
	  ...

      - uses: joshlong/java-version-export-github-action@v20

      ...

```

You need to make sure you add the `native-maven-plugin` Maven plugin if you plan on using the new Spring Boot 3 AOT engine (to build GraalVM native images) in conjunction [with Buildpacks.io](https://buildpacks.io).

```xml
<plugin>
    <groupId>org.graalvm.buildtools</groupId>
    <artifactId>native-maven-plugin</artifactId>
    <extensions>true</extensions>
</plugin>
```

Also, not particularly related to Spring Boot 3, _per se_, but it was useful to go through and update my Github Actions to use the latest and greatest versions of the Actions themselves, and to use the proper Github Actions, as there are now superior alternatives. 

Here's a complete Github Action:



```yaml

name: Deploy

env:
  # obviously, you'll have different environment variables than I will. 
  GKE_CLUSTER: my-gke-cluster
  GKE_ZONE: us-central1-c
  GCP_CREDENTIALS: ${{ secrets.GCP_CREDENTIALS }}
  PROJECT_ID: ${{ secrets.GKE_PROJECT }}
  SPRING_R2DBC_URL: ${{ secrets.SPRING_R2DBC_URL }}
  SPRING_R2DBC_PASSWORD: ${{ secrets.SPRING_R2DBC_PASSWORD }}
  SPRING_R2DBC_USERNAME: ${{ secrets.SPRING_R2DBC_USERNAME }}
  ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME }}
  ARTIFACTORY_PASSWORD: ${{ secrets.ARTIFACTORY_PASSWORD }}

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    name: Setup and Deploy
    runs-on: ubuntu-latest
    steps:


      - uses: actions/checkout@v3

      # configure GKE to use the new authentication mechanism
      - uses: 'google-github-actions/auth@v0'
        with:
          credentials_json: '${{ secrets.GCP_CREDENTIALS }}'

      - id: 'get-credentials'
        uses: 'google-github-actions/get-gke-credentials@v1'
        with:
          cluster_name: '${{ env.GKE_CLUSTER  }}'
          location: '${{ env.GKE_ZONE }}'

      - run: |
          gcloud config set project $PROJECT_ID
          gcloud --quiet auth configure-docker
          kubectl get pods

      - uses: actions/cache@v3
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-

      # this way you don't have to repeat yourself: the Github 
      # Action will use whatever version of Java your Maven build uses
      - uses: joshlong/java-version-export-github-action@v20

      - uses: actions/setup-java@v3
        with:
          distribution: 'adopt'
          java-version: ${{ env.JAVA_MAJOR_VERSION }}

      - name: Deploy 
        run: |
          cd $GITHUB_WORKSPACE
          ./my/deploy.sh

```

Easy, clean, and fast. 

Now, assuming you've tested that your code works well with Spring's AOT engine (see the video below), then you can build a Docker image, like this: 


```shell
./mvnw -U clean spring-boot:build-image \
	-Dspring-boot.build-image.imageName=my-docker-image-name
```

