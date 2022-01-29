title=Using GraphQL from HTTP
date=2022-01-28
type=post
tags=blog
status=published
~~~~~~

I love GraphQL, and [Spring GraphQL in particular](https://spring.io/projects/spring-graphql), but sometimes it's easy to forget that it can and often does run on top of regular 'ol HTTP. GraphQL can run on any number of transports, one of hwihc is commonly HTTP. For example, you could use WebSockets. I hope one day we see support for RSocket. But, if you are running on top of HTTP, it's not hard to get data from it using ye 'ole `curl` or `httpie`:


```shell
curl -H"content-type: application/json" -d'{"query":"{appearances{event,startDate,endDate,time,marketingBlurb } }" }' http://localhost:8080/graphql
```
