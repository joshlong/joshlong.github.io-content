title=How to Stop That Annoying macOS Prompt Asking If I'd Like to Allow Incoming Connections for RabbitMQ
date=2021-05-08
type=post
tags=blog
status=published
~~~~~~

If you install RabbitMQ on macOS using Homebrew, you'll ocassionally get a well-intentioned prompt from the system firewall asking if you'd like to accept incoming connections. You will click `Accept` and go on your merry way, thinking that - like other times you've done this - that that will be the last time you'll have to do that for RabbitMQ. But it won't be. You'll be prompted again, and again, and again. RabbitMQ occasionally changes the socket it uses so you'll get seemingly endless prompts. The [documentation spells out the fix](https://www.rabbitmq.com/networking.html#firewalls-mac-os). Based on that, here's what I did to make it work on my machine. 

```shell
#!/usr/bin/env bash 
V=23.2.6
E=/usr/local/Cellar/erlang/$V/lib/erlang/bin
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add $E/erl
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp $E/erl

E=/usr/local/Cellar/erlang/$V/lib/erlang/erts-11.1.8/bin
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add $E/beam.smp
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp $E/beam.smp

```