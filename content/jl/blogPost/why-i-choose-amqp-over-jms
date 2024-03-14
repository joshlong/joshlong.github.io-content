title=Why I choose AMQP over JMS 
date=2024-03-14
type=post
tags=blog
status=published
~~~~~~


Hi, my friends. I sometimes see folks debating JMS versus RabbitMQ. 

One complaint I see lauded is that RabbitMQ is a bit more complicated, and here I would agree, but would add that the extra complexity is worth the cost. It's minimal and important complexity. 

The topology is a little different than JMS; with JMS you have producer | destination | consumer. AMQP is a bit different: producer | exchange (which routes messages to 0 or more queus) | queue | consumer 

This exchange mechanism is key to AMQP's power. You can do replication, load balancing, introduce other intermediary brokers, adapt protocols, etc., all after the exchange and before the final queue. Neither side need know of the introduction of extra functionality. 

JMS was supposed to facilitate messaging and integration. The whole point of messaging system is to provide as much decoupling as possible.

* temporal - both sides don't need to be in the same time, they can be asynchronous. (JMS does this)
* physical - one side shouldn't need to know where you live to send a message to you; in JMS you can't change the JMS destination without breaking the integration flow.
* logical - yes, a message may ultimately get to me, but i want to put it through a series of filters, sort of like HTTP proxies, enriching the request or rejecting it as it proceeds. Can't do this in JMS itself.
* technological  - i'm trying to _integrate_ disparate systems and services.  We can't assume that everyone is using the same language, or within Java that they're using the same  broker-specific Java client and server revision. JMS is a Java API that is tied to the MQ broker being used, and sometimes to the _version_ of the MQ broker being used. So you may well end up having to shut both producer AND consumer down to upgrade either. 

Of these four kinds of decoupling, JMS somehow went out of its way to only provide one (temporal decoupling). When JMS first appeared there were already many proprietary brokers that provided three or more of those requirements. Somehow, rather perversely in this case, the open standard is far more likely to get you locked in than it should have.

The only  plus, you  might say, is that JMS supports distributed transactions - "XA". In practice there are patterns, like sagas, and "poor man's 2PC" - where you roll back a SQL transaction if the broker's consumer logic throws an exception - that render this benefit rather thin. 

I loved ActiveMQ and I especially loved HornetQ, too! And I loved their resulting fusion, Artemis. But remember, all of them supported other protocols beyond just JMS. JMS is probably the least effective way to consume any of them. Heck, Artemis supports AMQP, too, so it could be used with RabbitMQ in a multi node topology. 

Another thing that I love about AMQP is that the infrastructure itself - the queues, the bindings, the exchanges, etc., - can all be created by a client with the protocol. This is exactly the sort of self-service style of infrastructure that we should want in the era of the cloud native. Nobody should have to file an ITIL ticket to get a queue or topic set up.



