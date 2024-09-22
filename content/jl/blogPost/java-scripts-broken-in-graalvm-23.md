title=Java "Scripts" broken in GraalVM for Java 23
date=2024-09-22
type=post
tags=blog
status=published
~~~~~~

In OpenJDK Java 23 or indeed in GraalVM Java 22, I could have a Java program, which I'm executing as a "script", in a file like this, `Demo.java`:

```java
void main(){
  System.out.println("Hello, world!");
}
```

Then I could run it like this: 
  
```shell
java --enable-preview --source 22 Demo.java
```

This works in most distributions of Java 23, but fails in GraalVM 23 (and other distributions like Liberica's NIK for Java 23). You can get around it by - _cough_ - compiling the script.

```shell
javac --enable-preview --source 23   Demo.java 
java --enable-preview Demo "$@"  
```

This sort of removes half the fun of the original solution, but at least it works. And rest assured, [they're working on a fix...](https://github.com/oracle/graal/issues/9708)
