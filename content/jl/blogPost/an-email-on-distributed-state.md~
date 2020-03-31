title=A Discussion on Distributed State and Microservices
date=2016-07-26
type=post
tags=blog
status=published
~~~~~~

> Note: I was recently asked about CQRS and its role in buiilding microservices. I threw together an email - high level, devoid of specific technologies (like Spring Cloud Stream, Axon, or Eventuate) that looks at some of the patterns for connecting distributed systems. I figure I may as well share it here, briskly edited.

Hi,

I believe CQRS to be one (though, interesting) dimension tot he challenge of modeling distributed state. The challenge is, given that microservices stand up APIs in front of data, how do we connect these datasets? How do we get services to agree upon distributed state? this isn't a new problem. there are quite a few nice patterns and approaches for dealing w/ this.

the CAP theorem offers an interesting, but flawed, mental model when talking about distributed state. nominally, it states: given availability (A), consistency (C) and partitionability (P), you can only have 2/3. Specifically, you can have A+C (but not P) or PA (but not C). The truth, however, is that very few systems need perfect CAP 100% of the time. If you're willing to accept gradients then you can have all 3 at the same time. One way to introduce a gradient is temporal decoupling, or just _time_. If I'm ok with a bit of time, then I *can* (given time) guarantee consistency and availability. Most systems are OK w/ this.

- the X/Open protocol / distributed transactions (in Java, this is supported through the JTA API): this is a *terrible* idea. it introduces a giant SPOF and, as most of the resources w/ which we'd like to work today (HTTP APIs or messaging APIs powered through the likes of WebSockets, AMQP, or Apache Kafka) don't implement the X/Open protocol, it's also moot/irrelevant.

- eventual consistency: this is messaging. Use messaging to introduce temporal decoupling. Hack CAP by introducing the gradient of time. In our case, it's RabbitMQ or Apache Kafka..

- Saga pattern: define a set of interleavable (eg, A doesn't *have* to come before B) transactions (eg: book a hotel, book a car, book a flight) w/ semantic (that is to say, they *undo* the transaction and return the system to a semantically consistent state: unbook hotel, unbook flight, unbook car) compensatory TXs. A compensatory transaction must be idempotent; the system *must* be able to retyr the compensatory transaction until it succeeds. The Saga pattern was defined in the 80s to model _long-running_ transactions. Naturally, a network gap - algorithmically - looks the same as time so it applies perfectly to distributed systems work today.

- CQRS: is a more sophisticated version of eventual consistency. It recognizes that reads are intrinsically different from writes and encourages a division of the models used to support them. The technology used to report on data could be optimized for that task (fast-read data grids like Geode or Redis) where the tech used for writes might be optimized for that (a transactional DB like Neo4J or PostgreSQL). If the read and the write databases are distinct then the logical consequence is that they must be synchronized, and this usually involves introducing messaging (eventual consistency). If you have enough components whose state needs to be synchronized it's natural to introduce an event bus so that all interested parties can consume events as necessary. This is where you get into event sourcing. An event store holds stacked events (think of them like layers on a git file system) and whenever a new record is introduced a message is published on the bus for all interested consumers who then update their own internal read cache of the data.

So, how's a microservice benefit from CQRS? Microservices represent bounded contexts, silod' bits of data behind an API. Clients talk to the API, not the data itself, and the API can hide the nuances of whether the data is being read from Geode or written to MongoDB. The microservice only knows about the data in its domain, of course, so we need to solve the problem of composing data from different sources in a transactional way. CQRS is a logical fit here, especially with event sourcing.

Hope this helps..
