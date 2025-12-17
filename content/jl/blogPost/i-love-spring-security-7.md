title=I love Spring Security 7 so much 
date=2025-12-17
type=post
tags=blog
status=published
~~~~~~

I love Spring Security so much.

It isn't real until it's secure and in production, and nothing gets you there faster than Spring Security.

Spring Security 7, in particular, is chock full of good stuff.

* New encoding algorithms (and some duplicate ones, lol) through the Password4J library integration. Want Argon? Now you have two choices: Bouncy Castle, which is a huge library, or Password4J.
* Password encoding is a very important topic. Spring Security makes it trivial to handle passwords sensibly and securely. But even more importantly, it makes it possible to avoid passwords in the first place. You can use one-time tokens (“magic links,” à la Slack) or WebAuthn (passkeys!) in just a few lines of Java code. Passkeys are especially impressive: use your Apple Touch ID or Face ID to log in. You can also use an external YubiKey or your Windows account. Easy!
* Passkeys and passwords aren’t a great signal—a “factor”—that someone is who they say they are. But you can combine them with other factors to boost confidence. And with Spring Security 7, multi-factor authentication is easier than ever!
* Spring Security Kerberos has been merged into Spring Security proper, so it will evolve with the project rather than as a separate—and sometimes slightly askew—one.
* The Spring Authorization Server is a full-fledged OAuth identity provider (think: Active Directory, Keycloak, or Okta) that’s been merged into the Spring Security codebase as well. This completes an arc that started in Spring Security 5 back in 2017, when we rebuilt OAuth/OIDC login support and OAuth resource server support. Now we’ve rebuilt OAuth authorization server support too, and all these pieces live in Spring Security itself.
* OAuth as a specification is still growing, of course, and you never know where it’ll be needed. OAuth dynamic client registration is a relatively new feature we introduced, in part, to support our efforts to secure agentic MCP services. See the [MCP Security project under the Spring AI Community organization](https://github.com/spring-ai-community/mcp-security).
* Want to secure your Spring gRPC projects? There’s HTTP Basic and OAuth resource server support in the project, building on the foundational blocks provided by Spring Security.
* Want to secure your Spring WS SOAP-based services? Easy! You can use the WSS4J interceptor with Spring Security, or use Spring Security directly—as I demonstrate in this example, securing a [SOAP service with OAuth (why are you shaking?)](https://github.com/coffee-software-show/2025-11-22-bootiful-spring-ws).
* The “easy mode” for developing single-page apps is to use Spring Cloud Gateway to front your CDN and APIs, configuring it as an OAuth client that kicks off the “Sign in with…” flow by redirecting to an OAuth identity provider like Spring Authorization Server or Okta. Now your React app has no CORS issues to worry about, no JWTs passed around in JavaScript, etc. E-Z!

If you’re a builder, you’ll want to use Spring Security. And if you're not a builder, then what's stopping you? Certainly not security!
