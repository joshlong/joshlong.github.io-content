title=Easy and Secure Microservices with Spring Security and Auth0
date=2024-08-12
type=post
tags=blog
status=published
~~~~~~

A very common and useful pattern is to use OAuth (and OIDC in particular) to secure a proxy (a Spring Cloud Gateway instance) as an OAuth client. An OAuth client looks at incoming requests, determines if they have a valid OAuth token, and forces them to log in if not. The login part is handled by an Authorization Server, like Spring Authorization Server, Okta/Auth0, Active Directory, or Keycloak. These authorization servers redirect back to the OAuth client, hopefully with a token. Once the token is established, the OAuth client (which is also acting as a gateway) proxies all incoming requests, forwarding those requests and the token downstream to pure-play microservice APIs. These APIs also defend against invalid requests by rejecting those without tokens. They validate the token against the issuer URI of the authorization service. If the tokens don’t validate, the resource server rejects the requests. So, both the OAuth client/gateway and the OAuth resource server/API reject requests without tokens, but only the OAuth client/gateway is prepared to help you obtain one.

I've done countless blogs and videos on using the Spring Authorization Server. In this blog, I wanted to look at the integration of Auth0. Auth0 is a company that has its own IDP (identity provider). A little while back, they acquired Okta. Okta also had its own IDP. If you want to integrate with these services, you can use stock-standard Spring Security and its built-in OAuth support with a little customization. Or, you can use the official blessed Okta Spring Boot starter, which simplifies things. Confusingly, you will find various attempts at documentation showing how to use the Okta starter with Okta, how to use the Okta starter with Auth0, and how to use stock-standard Spring Security with Okta or Auth0. Most of these documents focus on the OAuth client capability, conveniently forgetting the OAuth resource server implementation.

In this blog, I'm going to look at using stock-standard Spring Security and Auth0. I couldn't sign up for a new Okta account, so I think by and large, you don't need to worry if you're starting today. You'll be using Auth0's IDP, which is a little different from Okta's.

The code for the [example lives here](https://github.com/joshlong-attic/auth0-signin-example). Who knows? I might even keep it up to date. Hopefully. Probably not.

## Setup an Account

- Go to [auth0.com](https://auth0.com) and sign up. They have a generous free tier.
- Create a new `application` and choose `regular web application`.
- Go to that application and then to `settings`: specify the Spring Security app as part of the `allowed callback URLs`. For localhost, the full URL is: `http://127.0.0.1:1010/login/oauth2/code/auth0`. Note: there's `auth0` in the URL. Also, you're probably going to want to run the OAuth client on a separate domain (for cookie purposes) than the other APIs. So, in this URL, I'm using 127.0.0.1, but you can use what works best for you.

## Gateway

- Go to the [Spring Initializr](https://start.spring.io) and  add   `web`, `graalvm`, `reactive gateway`, and `oauth client`. Name the artifact `gateway`. Click `Generate`.
- Use the following properties:
    ```properties
    spring.application.name=gateway
    server.port=1000
    auth0.domain=https://dev-6be331x4vkcs1c76.us.auth0.com/
    auth0.audience=${auth0.domain}api/v2/
    spring.security.oauth2.client.provider.auth0.issuer-uri=${auth0.domain}
    spring.security.oauth2.client.registration.auth0.client-id=${AUTH0_CLIENT_ID}
    spring.security.oauth2.client.registration.auth0.client-secret=${AUTH0_CLIENT_SECRET}
    spring.security.oauth2.client.registration.auth0.provider=auth0
    spring.security.oauth2.client.registration.auth0.authorization-grant-type=authorization_code
    spring.security.oauth2.client.registration.auth0.client-authentication-method=client_secret_basic
    spring.security.oauth2.client.registration.auth0.redirect-uri={baseUrl}/login/oauth2/code/{registrationId}
    spring.security.oauth2.client.registration.auth0.scope=user.read,openid
    ```
- Be sure to replace the values for `auth0.domain` with the value you see in the application in Auth0. Ditto for the `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET`.
- Use the following Java code:

    ```java
    package bootiful.gateway;

    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.gateway.route.RouteLocator;
    import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.security.config.Customizer;
    import org.springframework.security.config.web.server.ServerHttpSecurity;
    import org.springframework.security.oauth2.client.registration.ReactiveClientRegistrationRepository;
    import org.springframework.security.oauth2.client.web.server.DefaultServerOAuth2AuthorizationRequestResolver;
    import org.springframework.security.oauth2.client.web.server.ServerOAuth2AuthorizationRequestResolver;
    import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
    import org.springframework.security.web.server.SecurityWebFilterChain;

    import java.util.function.Consumer;

    @SpringBootApplication
    public class GatewayApplication {

        public static void main(String[] args) {
            SpringApplication.run(GatewayApplication.class, args);
        }

        @Bean
        RouteLocator gateway(RouteLocatorBuilder rlb) {
            var apiPrefix = "/api/";
            return rlb
                    .routes()
                    .route(rs -> rs.path(apiPrefix + "**")
                            .filters(f -> f.tokenRelay().rewritePath(apiPrefix + "(?<segment>.*)", "/$\\{segment}"))
                            .uri("http://localhost:8080"))
                    .build();
        }

        @Bean
        @SuppressWarnings("SpringJavaInjectionPointsAutowiringInspection")
        SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
            return http
                    .authorizeExchange(authorize -> authorize
                            .anyExchange()
                            .authenticated()
                    )
                    .csrf(ServerHttpSecurity.CsrfSpec::disable)
                    .oauth2Login(Customizer.withDefaults())
                    .oauth2Client(Customizer.withDefaults())
                    .build();
        }
    }


    // A useful fix from <a href="https://github.com/okta/okta-spring-boot/issues/596">Matt Raible</a>

    @Configuration
    class SecurityConfiguration {

        private final String audience;

        private final ReactiveClientRegistrationRepository clientRegistrationRepository;

        SecurityConfiguration(ReactiveClientRegistrationRepository clientRegistrationRepository,
                              @Value("${auth0.audience}") String audience) {
            this.clientRegistrationRepository = clientRegistrationRepository;
            this.audience = audience;
        }

        @Bean
        SecurityWebFilterChain filterChain(ServerHttpSecurity http) throws Exception {
            http
                    .authorizeExchange(authz -> authz
                            .anyExchange().authenticated()
                    )
                    .oauth2Login(oauth2 -> oauth2
                            .authorizationRequestResolver(
                                    authorizationRequestResolver(this.clientRegistrationRepository)
                            )
                    );
            return http.build();
        }

        private ServerOAuth2AuthorizationRequestResolver authorizationRequestResolver(
                ReactiveClientRegistrationRepository clientRegistrationRepository) {

            DefaultServerOAuth2AuthorizationRequestResolver authorizationRequestResolver =
                    new DefaultServerOAuth2AuthorizationRequestResolver(
                            clientRegistrationRepository);
            authorizationRequestResolver.setAuthorizationRequestCustomizer(
                    authorizationRequestCustomizer());

            return authorizationRequestResolver;
        }

        private Consumer<OAuth2AuthorizationRequest.Builder> authorizationRequestCustomizer() {
            return customizer -> customizer
                    .additionalParameters(params -> params.put("audience", audience));
        }
    }
    ```

## API

- Go to the [Spring Initializr](https://start.spring.io) and  add  `web`, `resource server`, and `graalvm`. Name the artifact `api`. Click `Generate`.
- Use the following properties:

    ```properties
    spring.application.name=api
    auth0.domain=https://dev-6be331x4vkcs1c76.us.auth0.com/
    auth0.audience=${auth0.domain}api/v2/
    spring.security.oauth2.resourceserver.jwt.issuer-uri=${auth0.domain}
    spring.security.oauth2.resourceserver.jwt.audiences=${auth0.audience}
    ```
- Be sure to replace the `auth0.domain` with the value you got from the `application` in the Auth0 console.
- Use the following Java code:
    ```java
    package bootiful.api;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.ResponseBody;

    import java.security.Principal;
    import java.util.Map;

    // https://developer.auth0.com/resources/labs/authorization/spring-boot-microservices-security#overview
    @SpringBootApplication
    public class ApiApplication {

        public static void main(String[] args) {
            SpringApplication.run(ApiApplication.class, args);
        }
    }

    @Controller
    @ResponseBody
    class GreetingsController {

        @GetMapping("/hello")
        Map<String, String> hello(Principal principal) {
            return Map.of("messages", "Hello, " + principal.getName() + ", from the backend API!");
        }
    }
    ```

## Try It Out

Make sure to specify the Auth0 `client-id`, `client-secret`, and `domain` specific to your Auth0 tenant. Use the environment variables referenced in both `application.properties`. Run both applications in Java on the local machine. Go to [`http://127.0.0.1:1000/api/hello`](http://127.0.0.1:1000/api/hello). You should be prompted to login. Congrats! You have a working OAuth-secured microservices architecture. 

## Wrap Up 

Most of what we showed today is basically the same as it would be in any OAuth integration. Notably, Auth0 has some hangups around the conveyance of the `audience` claim. So, there's extra code in the Gateway to support adding it to the `JWT` token that's sent onward.

