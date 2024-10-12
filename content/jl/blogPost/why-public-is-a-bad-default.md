title=Why `public` is a bad default for new classes in IntelliJ IDEA
date=2024-10-12
type=post
tags=blog
status=published
~~~~~~





I recently posted a "poll" on Twitter, tongue very firmly planted in cheek, asking whether IntelliJ IDEA should stop defaulting new classes created in a Java project  with the visibility keyword `public`. [Here's my "poll"](https://x.com/starbuxman/status/1844658796154507709?s=61). Naturally, somebody asked "why not?" Here's my answer. I'll put it here and potentially update it over time as my thinking gets clearer.

TL;DR: Social political harmony, peace at the office or on Slack, and faster time-to-market with better products! 

Object orientation is about modeling state and encapsulation. Why do we value encapsulation? For the same reason humans don’t work well when our organs are outside our body, and that  we don't sleep at night with every door in our homes or cars unlocked, and that we don't leave our computers perpetually unlocked with every network service running without password challenges, and for the same  reason  we don't walk in the cold naked: there's simply too much risk! We don’t know what else might interfere. The goal of good software modularity is to minimize the blast radius for change. The fewer people you need to tell or involve when making a change, the faster you can go. If every class is `public` then every class is exposed. This means that the public surface area of your code is big as your codebase, and this means there might be potentially be endless and unknown dependents on that code.

If you want every type be visible (`public`) in a global namespace, just use C! It's at least more honest. 

The same logic applies to microservices. We create microservices not because they’re technically simpler - they’re not. They have more moving parts. No, we create them because have a well defined surface area - the network boundary - inside of which teams are able to iterate and innovate as fast as they want, and they can also deploy independent of other teams. So even though there are more moving parts, this can be an accelerant, assuming there’s proper convention and automation around deployment. Things slow down when you need to get consensus. Integration with other parts of the team or organization will always be slower than proceeding full-steam ahead in your own well-defined swimlane. But if you have a swimlane, you will know when you've departed from it and when it's time to do the arduous work of integration. Otherwise, you're never going to be sure. And you'll never get the productivity you desire without some pause.

## Layer by function, not by role

I see this far too often in code. It’s anti pattern to layer your code by role. 

Don’t do: 

`app.models.Customer`, `app.repositories.CustomerRepository`, `app.services.CustomerService`, and `app.controllers.CustomerController`, etc. 

In this scheme, every type except perhaps the controller would need to be public. Why is that acceptable? The model and repository are implementation details of the service and the service might be an implementation details of the controller. It's very hard to enforce a _bounded context_ in this arrangement, too.  

Instead, do: 

```
app.customers.{Customer,CustomerController,CustomerRepository,CustomerService, etc..}
app.fulfillment.*
app.orders.*
```

etc.

In this arrangement, we layer by feature. All of our types can be package private. If we truly want something to be accessible and visible to other parts of the codebase, we can make that decision deliberately.

Most technologies, including Spring, don't need your types to be `public`. It buys you nothing but extra code. Indeed, Spring works even better in a scenario where your types aren't `public` because it allows you a form of information hiding. You might have a core interface, that's `public`, at the root of your code, and an implementation - that's package private ` -in one of the subpackages. You can define the Spring `@Configuration` in the subpackage and consumers may inject it by its interface, ignorant to the particular implementation. You could rename the class altogether and nothing in the consuming code would need to change.



