title=The Kubernetes Java Client and GraalVM support with Spring Native 0.11.x
date=2021-12-18
type=post
tags=blog
status=published
~~~~~~


You know, I love Spring Native. I've been working on making as much of the Java ecosystem work with Spring Native as I can. Spring Native works all but perfectly for most Spring configuration classes. You don't need to do much _unless_ your objects do something tricky that might anger the GraalVM native image compiler deity, like reflection, loading resources from the CLASSPATH, JDK or AOT(ByteBuddy, CGLib) proxies, serialization, etc. Then, you need to feed the beast some extra information about what went wrong and why. 

The Kubernetes Java client is an automatically code-generated Java client for the Kubernetes Java API. It uses GSON and other reflective technologies to work, so you have to register all the types that get generated. This could of course change from one release to another. The ideal solution is to update the Kubernetes Java client so that it automatically includes all the types in a `META-INF/native-image/` directory with the full and proper configuration to allow for reflection on those types. But, short of that happening, I've built a Spring Native hint that does the same thing in a fairly automatic fashion. 

I won't reproduce the build because the whole thing is in [the Kubernetes Native Java (`kubernetes-native-java`) repository, here](https://github.com/kubernetes-native-java/spring-native-kubernetes). Suffice it to say that you'll need the Spring Native and Spring AOT libraries on the classpath, and the latest version of the Kubernetes Java client (14.0 at the time of this writing). You could alternatively `git clone ` that repository and `mvn install` it. 

This hint works because, in addition to registering some types that are invariants and always need to be registered, it uses the handy [Reflections](https://github.com/ronmamo/reflections) API to find all the types annotated with certain annotations and register them for reflection. 


```java

package io.kubernetes.nativex;

import com.google.gson.annotations.JsonAdapter;
import io.swagger.annotations.ApiModel;
import lombok.extern.log4j.Log4j2;
import org.reflections.Reflections;
import org.springframework.aot.context.bootstrap.generator.infrastructure.nativex.NativeConfigurationRegistry;
import org.springframework.nativex.AotOptions;
import org.springframework.nativex.hint.NativeHint;
import org.springframework.nativex.hint.TypeHint;
import org.springframework.nativex.type.NativeConfiguration;

import java.util.HashSet;
import java.util.Set;

import static org.springframework.nativex.hint.TypeAccess.*;

@NativeHint(//

		options = { "-H:+AddAllCharsets", "--enable-all-security-services", "--enable-https", "--enable-http" },
		types = { //
				@TypeHint( //
						access = { DECLARED_CLASSES, DECLARED_CONSTRUCTORS, DECLARED_FIELDS, DECLARED_METHODS }, //
						typeNames = { "io.kubernetes.client.informer.cache.ProcessorListener",
								"io.kubernetes.client.extended.controller.Controller",
								"io.kubernetes.client.custom.IntOrString",
								"io.kubernetes.client.custom.Quantity$QuantityAdapter",
								"io.kubernetes.client.custom.IntOrString$IntOrStringAdapter",
								"io.kubernetes.client.util.generic.GenericKubernetesApi$StatusPatch",
								"io.kubernetes.client.util.Watch$Response" }) //
		}//
)
@Log4j2
public class KubernetesApiNativeConfiguration implements NativeConfiguration {

	@Override
	public void computeHints(NativeConfigurationRegistry registry, AotOptions aotOptions) {
		Reflections reflections = new Reflections("io.kubernetes");
		Set<Class<?>> apiModels = reflections.getTypesAnnotatedWith(ApiModel.class);
		Set<Class<?>> jsonAdapters = reflections.getTypesAnnotatedWith(JsonAdapter.class);
		Set<Class<?>> all = new HashSet<>();
		all.addAll(jsonAdapters);
		all.addAll(apiModels);
		all.forEach(clzz -> {
			if (log.isDebugEnabled()) {
				log.debug(clzz.getName());
			}
			registry.reflection().forType(clzz).withAccess(values()).build();
		});
	}

}

``` 

You'll need to make this discoverable by registering it in the `src/main/resources/META-INF/spring.factories` file. 


```properties
org.springframework.nativex.type.NativeConfiguration=io.kubernetes.nativex.KubernetesApiNativeConfiguration
```


Once that's done, install the library and then add it to the classpath of a module that uses it. I've got [just such an example here](https://github.com/kubernetes-native-java/kubernetes-controller). This examples uses not just the Kubernetes Java client but the Spring Boot autoconfiguration for the Kubernetes Java client.


```java

package booternetes.k8s;

import io.kubernetes.client.extended.controller.Controller;
import io.kubernetes.client.extended.controller.builder.ControllerBuilder;
import io.kubernetes.client.extended.controller.reconciler.Reconciler;
import io.kubernetes.client.extended.controller.reconciler.Result;
import io.kubernetes.client.informer.SharedIndexInformer;
import io.kubernetes.client.informer.SharedInformerFactory;
import io.kubernetes.client.informer.cache.Lister;
import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.models.V1Node;
import io.kubernetes.client.openapi.models.V1NodeList;
import io.kubernetes.client.openapi.models.V1Pod;
import io.kubernetes.client.openapi.models.V1PodList;
import io.kubernetes.client.util.generic.GenericKubernetesApi;
import lombok.extern.log4j.Log4j2;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Objects;

/**
 * @author Dave Syer
 * @author Josh Long
 */
@Log4j2
@SpringBootApplication
public class KubernetesControllerApplication {

	public static void main(String[] args) {
		SpringApplication.run(KubernetesControllerApplication.class, args);
	}

	@Bean
	SharedIndexInformer<V1Node> nodeInformer(ApiClient apiClient, SharedInformerFactory sharedInformerFactory) {
		return sharedInformerFactory.sharedIndexInformerFor(
				new GenericKubernetesApi<>(V1Node.class, V1NodeList.class, "", "v1", "nodes", apiClient), V1Node.class,
				0);
	}

	@Bean
	SharedIndexInformer<V1Pod> podInformer(ApiClient apiClient, SharedInformerFactory sharedInformerFactory) {
		return sharedInformerFactory.sharedIndexInformerFor(
				new GenericKubernetesApi<>(V1Pod.class, V1PodList.class, "", "v1", "pods", apiClient), V1Pod.class, 0);
	}

	// Lists the current nodes and pods that it finds
	@Bean
	Lister<V1Node> nodeLister(SharedIndexInformer<V1Node> informer) {
		return new Lister<>(informer.getIndexer());
	}

	@Bean
	Lister<V1Pod> podLister(SharedIndexInformer<V1Pod> informer) {
		return new Lister<>(informer.getIndexer());
	}

	@Bean
	Reconciler reconciler(Lister<V1Node> nodeLister, Lister<V1Pod> podLister) {
		return request -> {
			var namespace = "bk";
			var node = nodeLister.get(request.getName());

			System.out.println("node: " + Objects.requireNonNull(node.getMetadata()).getName());

			podLister.namespace(namespace).list().stream()
					.map(pod -> Objects.requireNonNull(pod.getMetadata()).getName())
					.forEach(podName -> System.out.println("pod name: " + podName));

			return new Result(false);
		};
	}

	@Bean
	Controller controller(SharedIndexInformer<V1Pod> podInformer, SharedIndexInformer<V1Node> nodeInformer,
			SharedInformerFactory sharedInformerFactory, Reconciler reconciler) {

		return ControllerBuilder.defaultBuilder(sharedInformerFactory)
				.watch(q -> ControllerBuilder.controllerWatchBuilder(V1Node.class, q).build())
				.withReadyFunc(() -> podInformer.hasSynced() && nodeInformer.hasSynced()).withReconciler(reconciler)
				.withName("booternetesController").build();
	}

	@Bean
	CommandLineRunner go(SharedInformerFactory sharedInformerFactory, Controller controller) {
		return args -> {
			sharedInformerFactory.startAllRegisteredInformers();
			controller.run();
		};
	}

}

```

This example iterates the current `pod` and `node` instances of the Kubernetes cluster to which you're authenticated and the `default` namespace. (There's a Java `String` with the name of the namespace specified in the Java code, and it defaults to `default`. Change it to use whatever namespace you'd like.). 


Compile the application thusly: 

```shell
mvn -DskipTests=true -Pnative clean package
```

Then run the application. I get output that looks like this. 


```shell
13:36:46.713 [main] INFO org.springframework.boot.SpringApplication - AOT mode enabled
2021-12-18 13:36:46.731  INFO 42020 --- [           main] o.s.nativex.NativeListener               : This application is bootstrapped with code generated with Spring AOT

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.6.1)

2021-12-18 13:36:46.733  INFO 42020 --- [           main] b.k8s.KubernetesControllerApplication    : Starting KubernetesControllerApplication v0.0.1-SNAPSHOT using Java 17.0.1 on mbp2019.local with PID 42020 (/Users/jlong/code/k8s/kubernetes-controller/target/kubernetes-controller started by jlong in /Users/jlong/code/k8s/kubernetes-controller)
2021-12-18 13:36:46.733  INFO 42020 --- [           main] b.k8s.KubernetesControllerApplication    : No active profile set, falling back to default profiles: default
2021-12-18 13:36:46.735  INFO 42020 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'io.kubernetes.client.spring.extended.manifests.config.KubernetesManifestsAutoConfiguration' of type [io.kubernetes.client.spring.extended.manifests.config.KubernetesManifestsAutoConfiguration] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
2021-12-18 13:36:46.736  INFO 42020 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'kubernetes.manifests-io.kubernetes.client.spring.extended.manifests.config.KubernetesManifestsProperties' of type [io.kubernetes.client.spring.extended.manifests.config.KubernetesManifestsProperties] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
2021-12-18 13:36:46.737  INFO 42020 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'io.kubernetes.client.spring.extended.controller.config.KubernetesInformerAutoConfiguration' of type [io.kubernetes.client.spring.extended.controller.config.KubernetesInformerAutoConfiguration] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
2021-12-18 13:36:46.743  INFO 42020 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'defaultApiClient' of type [io.kubernetes.client.openapi.ApiClient] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
2021-12-18 13:36:46.755  INFO 42020 --- [           main] b.k8s.KubernetesControllerApplication    : Started KubernetesControllerApplication in 0.038 seconds (JVM running for 0.041)
2021-12-18 13:36:46.755  INFO 42020 --- [ntroller-V1Node] i.k.client.informer.cache.Controller     : informer#Controller: ready to run resync & reflector runnable
2021-12-18 13:36:46.755  INFO 42020 --- [ontroller-V1Pod] i.k.client.informer.cache.Controller     : informer#Controller: ready to run resync & reflector runnable
2021-12-18 13:36:46.755  INFO 42020 --- [ontroller-V1Pod] i.k.client.informer.cache.Controller     : informer#Controller: resync skipped due to 0 full resync period
2021-12-18 13:36:46.755  INFO 42020 --- [ntroller-V1Node] i.k.client.informer.cache.Controller     : informer#Controller: resync skipped due to 0 full resync period
2021-12-18 13:36:46.755  INFO 42020 --- [.models.V1Pod-1] i.k.c.informer.cache.ReflectorRunnable   : class io.kubernetes.client.openapi.models.V1Pod#Start listing and watching...
2021-12-18 13:36:46.755  INFO 42020 --- [models.V1Node-1] i.k.c.informer.cache.ReflectorRunnable   : class io.kubernetes.client.openapi.models.V1Node#Start listing and watching...
node: gke-knj-demos-default-pool-8fdf2ef6-p3kz
node: gke-knj-demos-default-pool-8fdf2ef6-xh08
node: gke-knj-demos-default-pool-8fdf2ef6-55q9
pod name: hello-knj-native-6765d4b4d4-vcg9f
pod name: my-app-68dc994b7c-nddqs
pod name: hello-knj-native-6765d4b4d4-vcg9f
pod name: my-app-68dc994b7c-nddqs
pod name: hello-knj-native-6765d4b4d4-vcg9f
pod name: my-app-68dc994b7c-nddqs


```


That's 38 milliseconds, or 38 thousandths of a second. The resulting application takes up a trivially small memory footprint, too, taking 67.3 megabytes of RAM. You could easily put this inside of a container using the Spring Boot buildpacks support. Just run the following: 


```shell
mvn spring-boot:build-image
````

The default, out-of-the-box configuration for Spring Native and Buildpacks configures a tiny Linux distribution (like Alpine), so the resulting container might indeed be only a tiny bit larger than the GraalVM image itself. It's not uncommon to see Docker images that take up less than 80 megabytes of RAM, complete with an operating system and the GraalVM native image.


You could then deploy that application to a Kubernetes cluster, which the example also demonstrates by deploying the application to Google Cloud's Kubernetes environment (GKE). 

Here's the trivial Kubernetes configuration (`./k8s/controller.yaml`) for an example deployment in my Kubernetes cluster's `bk` namespace. 


```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: bk

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kce-rolebinding
subjects:
  - kind: ServiceAccount
    name: default
    namespace: bk
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin

---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: bk
  labels:
    app: kubernetes-controller
  name: kubernetes-controller
spec:
  selector:
    matchLabels:
      app: kubernetes-controller
  template:
    metadata:
      labels:
        app: kubernetes-controller
    spec:
      containers:
        - image: gcr.io/pgtm-jlong/kubernetes-controller
          imagePullPolicy: Always
          name: kubernetes-controller


```

Here's the trivial Github Actions file required to setup the build and the Google Cloud cluster connection from  my Github Actions pipeline:


```yaml

name: Deploy


env:
  ACTIONS_ALLOW_UNSECURE_COMMANDS: true
  GCLOUD_ZONE: ${{ secrets.GCLOUD_ZONE }}
  GCLOUD_PROJECT: ${{ secrets.GCLOUD_PROJECT  }}
  GKE_CLUSTER_NAME: ${{ secrets.GKE_CLUSTER_NAME  }}
  ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME  }}
  ARTIFACTORY_PASSWORD: ${{ secrets.ARTIFACTORY_PASSWORD  }}

on:

  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:

      - uses: actions/checkout@v2

      - uses: actions/cache@v1
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-

      - name: Set up JDK
        uses: actions/setup-java@v1
        with:
          java-version: 17

      - uses: google-github-actions/setup-gcloud@master
        with:
          version: '290.0.1'
          service_account_key: ${{ secrets.GCLOUD_SA_KEY }}
          project_id: ${{ env.GCLOUD_PROJECT }}
          export_default_credentials: true

      - run: |-
          gcloud config set project $GCLOUD_PROJECT
          gcloud --quiet auth configure-docker
          gcloud container clusters get-credentials $GKE_CLUSTER_NAME --zone "$GCLOUD_ZONE" --project $GCLOUD_PROJECT

      - name: Deploy
        run: |
          cd $GITHUB_WORKSPACE
          .github/workflows/deploy.sh


```


That done, the only thing that remained was the actual build and deployment, which happens, ultimately, in a shell script: 

```shell
#!/usr/bin/env bash
set -e
set -o pipefail

HERE="$(dirname $0)"
echo "current directory is $HERE "
cd "${HERE}"/..
export PROJECT_ID=${GCLOUD_PROJECT}
export ROOT_DIR=$(cd $(dirname $0) && pwd)
export APP_NAME=kubernetes-controller
export GCR_IMAGE_NAME=gcr.io/${PROJECT_ID}/${APP_NAME}
docker rmi $(docker images -a -q)
mvn -f "${ROOT_DIR}"/../pom.xml -DskipTests=true clean package spring-boot:build-image

image_id=$(docker images -q $APP_NAME)

echo "tagging ${GCR_IMAGE_NAME}"
docker tag "${image_id}" $GCR_IMAGE_NAME

echo "pushing ${image_id} to $GCR_IMAGE_NAME "
docker push $GCR_IMAGE_NAME

echo "deploying to Kubernetes"
kubectl apply -f ./k8s/controller.yaml
```

Awkwardly, the very large majority of work required to get a Spring Boot application to production as a GraalVM native image in a Docker image is the stuff _after_ Spring Boot, GraalVM, and and Spring Native are involved. Nice! 


It's a very exciting time to be alive. There are millions of Spring Boot developers out there, and now - with this  - Spring Boot developers can be unqualified Kubernetes developers, too. 


A huge tip of the hat to the [good Dr. David Syer](https://twitter.com/David_Syer) who put together a prototype (without Spring Native) on which I based the sample and the beginning of the Spring Native configuration.