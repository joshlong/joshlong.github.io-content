title=The only good kind of Javascript is a Java Script
date=2025-10-05
type=post
tags=blog
status=published
~~~~~~


I just spent a bit too long trying to figure out how to script my Java scripts. I wanted to go as far as giving them a shebang line, but if I created a file called hello.java and put the following in

```java
#!/usr/bin/env -S java --source 25
void main(){ 
 IO.println("hi");
}
```

it would complain about not being able to find a class. which is irksome. it should be able to find a class. the implicit class. it's a feature in java. but it doesn't. 

however, if you _rename_ the file to something without `.java`, everything works flawlessly. I named it just script, then

```shell
> chmod a+x script 
```

then 

```shell
./script 
```

and it worked! 

i hope this helps someone else write effective java scripts. it's really nice being able to write java scripts. (with threads, no less!)