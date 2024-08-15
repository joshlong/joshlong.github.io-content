title=Easy Project-Specific Configuration for Development 
date=2024-08-15
type=post
tags=blog
status=published
~~~~~~




Let's talk about two of my favorite tools for managing environments: [SDKMAN.io](https://sdkman.io) and [`direnv`](https://direnv.net). 

## `direnv`

Direnv makes it easy to run shell script code when `cd`'ing into a directory. What shell script? Well, basically anything. And, in particular, it does the right thing when you export environment variables. I use this capability all the time. Let's suppose I'm working on a bit of code I've checked out from Github but it requires some environment variables to specify certain values. No problem, as long as `direnv` is installed on my system. I need only add `.envrc` file to the directory and then add it to the Git repository. 


```shell
export FOO=bar
```

put that in a directory, `cd` out of (up, away from) the directory, then `cd` back into the directory. You'll be prompted to allow `direnv` to run: `direnv allow`. It'll then run and you can then `echo $FOO`. 

I often use this capability in tandem with Bitwarden, my secrets manager. Bitwarden is super useful. It's like LastPass, OnePass, your operating system's keychain, etc. Bitwarden has a CLI - `bw` - which I can use to request secrets from my vault. You need to first unlock the value with the `bw unlock --raw` command. This will give you a token you should store in a variable called `BW_SESSION`, like this:


```shell
export BW_SESSION=$(bw unlock --raw)
```

All subsequent interactions with `bw` in the same shell, with `BW_SESSION` set, will go unchallenged. So, all together, you might do something like this in an `.envrc` file:

```shell

export BW_SESSION=$(bw unlock --raw)

X="$(bw get item my-apps-auth0-client--production )"
export AUTH0_CLIENT_ID="$( echo $X | jq -r '.fields[] | select(.name == "client-id") | .value')"
export AUTH0_CLIENT_SECRET="$( echo $X | jq -r '.fields[] | select(.name == "client-secret") | .value' )"
export AUTH0_DOMAIN="$( echo $X | jq -r '.fields[] | select(.name == "domain") | .value'  )"
```

When somebody enters this directory, the user will be forced to authenticate with their Bitwarden vault. Therein, we'll look for an entry called `my-apps-auth0-client--production`. Bitwardens the contents of this entry as JSON which in turn has three fields we want: `client-id`, `client-secret`, and `domain`. So, a quick application of `jq` later and we have three environment variables ready to use. 

You don't have to use `direnv` for environment variables, too. I also use it to run certain initialization code. A common pattern I have is to setup an _init_ directory in a given Github organization. Let's say I've got a system with multiple modules, each in their own repository. Want to onramp a new developer? Tell them to clone this repository and simply `cd` into it. It in turn can clone everything else. 

One such example of mine uses Java for some lightweight _scripting_!

```
#!/usr/bin/env bash
java Init.java
```

The `Init.java` file looks like this: 


```java
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

public class Init {

    public static void main(String[] args) throws Exception {
        var cwd = new File(".").getAbsolutePath();
        var ghOrg = "git@github.com:my-org";
        var clone = new File(System.getenv("HOME") + "/code/mogul");
        if (!clone.exists()) clone.mkdirs();
        try (var ex = Executors.newCachedThreadPool()) {
            var repositories = ("one two three").split(" ");
            var waiting = new HashSet<Future<?>>();
            for (var repo : repositories)
                waiting.add(ex.submit(run(ghOrg + "/" + repo + ".git", new File(clone, repo.trim()))));
            for (var f : waiting) f.get();
        }

        for (var tc : new File(cwd, "to-copy").listFiles())
            exec("cp -r  " + tc.getAbsolutePath() + " " + new File(clone, tc.getName()).getAbsolutePath());

        for (var f : clone.listFiles())
            System.out.println("" + f.getAbsolutePath());

        System.out.println("Finished initializing " + clone.getAbsolutePath());
    }

    private static void exec(String cmd) throws Exception {
        var proc = Runtime.getRuntime().exec(cmd);
        var exit = proc.waitFor();
        if (exit != 0)
            System.out.println(cmd + " exited improperly.");
    }

    private static Runnable run(String gitUrl, File folder) {
        return (Runnable) () -> {
            try {
                var fullPath = folder.getAbsolutePath();
                var cmd = folder.exists() ? "cd " + fullPath + " ; git pull " : "git clone " + gitUrl + " " + fullPath;
                exec(cmd);
            } //
            catch (Exception ioException) {
                System.err.println("got an exception: [" + ioException + "]");
            }
        };
    }
}
```


I use Java to avail myself of easy concurrency to make short work of cloning multiple repositories at the same time. Super efficient. 

And each of those cloned directories might in turn have their own `.envrc`, ensuring that their particular tools and environment are properly configured. Does this application require a Docker image? `docker pull` it. Need `node` installed? Install it. Does it need a particular tool? Install it. Obviously, this could get a little tedious across multiple operating systems, but Docker can insulate people from a lot of this complexity. I use Docker and common UNIX-isms to create relatively consistent environments. That said, I do _not_ want to manage installing and making available different JDKs. Too much could go wrong. Which brings me to my next favorite tool: SDKMAN.io! 


## SDKMAN.io 

SDKMAN.io is a package manager for JVM infrastructure: JDKs, Languages (Kotlin, Scala, Groovy, etc.), Build tools (Maven, Gradle, SBT, etc.), framework utilities, etc. I use it mostly for installing language-related facilities. Let's say I wanted to install Java 21 on my machine. I'd list all the Java versions available like this:


```
sdk list java
```

This will result in a wall of options. 


```

================================================================================
Available Java Versions for macOS ARM 64bit
================================================================================
 Vendor        | Use | Version      | Dist    | Status     | Identifier
--------------------------------------------------------------------------------
 Corretto      |     | 22.0.2       | amzn    |            | 22.0.2-amzn         
               |     | 21.0.4       | amzn    |            | 21.0.4-amzn         
               |     | 17.0.12      | amzn    |            | 17.0.12-amzn        
               |     | 11.0.24      | amzn    |            | 11.0.24-amzn        
               |     | 8.0.422      | amzn    |            | 8.0.422-amzn        
 Gluon         |     | 22.1.0.1.r17 | gln     |            | 22.1.0.1.r17-gln    
               |     | 22.1.0.1.r11 | gln     |            | 22.1.0.1.r11-gln    
 GraalVM CE    |     | 22.07        | graalce | local only | 22.07-graalce       
               | >>> | 22.0.2       | graalce | installed  | 22.0.2-graalce      
               |     | 22           | graalce | local only | 22-graalce          
               |     | 21.0.2       | graalce | installed  | 21.0.2-graalce      
               |     | 21.0.1       | graalce | local only | 21.0.1-graalce      
               |     | 21           | graalce | local only | 21-graalce          
               |     | 17.0.9       | graalce | installed  | 17.0.9-graalce      
 GraalVM Oracle|     | 24.ea.8      | graal   |            | 24.ea.8-graal       
               |     | 24.ea.7      | graal   |            | 24.ea.7-graal       
               |     | 23.ea.22     | graal   |            | 23.ea.22-graal      
               |     | 23.ea.21     | graal   |            | 23.ea.21-graal      
               |     | 22.0.2       | graal   |            | 22.0.2-graal        
               |     | 21.0.4       | graal   |            | 21.0.4-graal        
               |     | 17.0.12      | graal   |            | 17.0.12-graal       
 Java.net      |     | 24.ea.10     | open    |            | 24.ea.10-open       
               |     | 24.ea.9      | open    |            | 24.ea.9-open        
               |     | 23.ea.29     | open    |            | 23.ea.29-open       
               |     | 22.0.1       | open    |            | 22.0.1-open         
               |     | 21.0.2       | open    |            | 21.0.2-open         
 JetBrains     |     | 21.0.4       | jbr     |            | 21.0.4-jbr          
               |     | 21.0.3       | jbr     |            | 21.0.3-jbr          
               |     | 17.0.11      | jbr     | installed  | 17.0.11-jbr         
               |     | 11.0.14.1    | jbr     |            | 11.0.14.1-jbr       
 Liberica      |     | 22.0.2.fx    | librca  |            | 22.0.2.fx-librca    
               |     | 22.0.2       | librca  |            | 22.0.2-librca       
               |     | 21.0.4.fx    | librca  |            | 21.0.4.fx-librca    
               |     | 21.0.4       | librca  |            | 21.0.4-librca       
               |     | 17.0.12.fx   | librca  |            | 17.0.12.fx-librca   
               |     | 17.0.12      | librca  |            | 17.0.12-librca      
               |     | 11.0.24.fx   | librca  |            | 11.0.24.fx-librca   
               |     | 11.0.24      | librca  |            | 11.0.24-librca      
               |     | 8.0.422.fx   | librca  |            | 8.0.422.fx-librca   
               |     | 8.0.422      | librca  |            | 8.0.422-librca      
 Liberica NIK  |     | 24.0.2.r22   | nik     |            | 24.0.2.r22-nik      
               |     | 23.1.4.r21   | nik     |            | 23.1.4.r21-nik      
               |     | 23.0.5.r17   | nik     |            | 23.0.5.r17-nik      
               |     | 22.3.5.r17   | nik     |            | 22.3.5.r17-nik      
               |     | 22.3.5.r11   | nik     |            | 22.3.5.r11-nik      
 Mandrel       |     | 24.0.2.r22   | mandrel |            | 24.0.2.r22-mandrel  
               |     | 23.1.4.r21   | mandrel |            | 23.1.4.r21-mandrel  
 Microsoft     |     | 21.0.4       | ms      |            | 21.0.4-ms           
               |     | 17.0.12      | ms      |            | 17.0.12-ms          
               |     | 11.0.24      | ms      |            | 11.0.24-ms          
 Oracle        |     | 22.0.2       | oracle  |            | 22.0.2-oracle       
               |     | 21.0.4       | oracle  |            | 21.0.4-oracle       
               |     | 17.0.12      | oracle  |            | 17.0.12-oracle      
 SapMachine    |     | 22.0.2       | sapmchn |            | 22.0.2-sapmchn      
               |     | 21.0.4       | sapmchn |            | 21.0.4-sapmchn      
               |     | 17.0.12      | sapmchn |            | 17.0.12-sapmchn     
               |     | 11.0.24      | sapmchn |            | 11.0.24-sapmchn     
 Semeru        |     | 21.0.4       | sem     |            | 21.0.4-sem          
               |     | 21.0.3       | sem     |            | 21.0.3-sem          
               |     | 17.0.12      | sem     |            | 17.0.12-sem         
               |     | 17.0.11      | sem     |            | 17.0.11-sem         
               |     | 11.0.24      | sem     |            | 11.0.24-sem         
               |     | 11.0.23      | sem     |            | 11.0.23-sem         
 Temurin       |     | 22.0.2       | tem     |            | 22.0.2-tem          
               |     | 21.0.4       | tem     |            | 21.0.4-tem                 
               |     | 17.0.12      | tem     |            | 17.0.12-tem         
               |     | 11.0.24      | tem     |            | 11.0.24-tem         
 Tencent       |     | 17.0.12      | kona    |            | 17.0.12-kona        
               |     | 11.0.24      | kona    |            | 11.0.24-kona        
               |     | 8.0.422      | kona    |            | 8.0.422-kona        
 Zulu          |     | 22.0.2.fx    | zulu    |            | 22.0.2.fx-zulu      
               |     | 22.0.2       | zulu    |            | 22.0.2-zulu         
               |     | 21.0.4.fx    | zulu    |            | 21.0.4.fx-zulu      
               |     | 21.0.4       | zulu    |            | 21.0.4-zulu         
               |     | 17.0.12.fx   | zulu    |            | 17.0.12.fx-zulu     
               |     | 17.0.12      | zulu    |            | 17.0.12-zulu        
               |     | 11.0.24.fx   | zulu    |            | 11.0.24.fx-zulu     
               |     | 11.0.24      | zulu    |            | 11.0.24-zulu        
               |     | 8.0.422.fx   | zulu    |            | 8.0.422.fx-zulu     
               |     | 8.0.422      | zulu    |            | 8.0.422-zulu        
================================================================================
Omit Identifier to install default version 21.0.4-tem:
    $ sdk install java
Use TAB completion to discover available versions
    $ sdk install java [TAB]
Or install a specific version by Identifier:
    $ sdk install java 21.0.4-tem
Hit Q to exit this list view
================================================================================


```

A _ton_ of choices! And there are no bad ones. Just the ones you need for your environment. Personally, I tend to rock the latest-and-greatest GraalVM distributions, so I'd choose the latest GraalVM community edition (or Oracle edition, which is awesome) and use it to install GraalVM: `sdk install java 22.0.2-graalce`. If I wanted this to be the default JDK system wide, I'd say: `sdk default java 22.0.2-graalce`. Open a new shell and verify it's worked: `java --version`:


```shell
openjdk 22.0.2 2024-07-16
OpenJDK Runtime Environment GraalVM CE 22.0.2+9.1 (build 22.0.2+9-jvmci-b01)
OpenJDK 64-Bit Server VM GraalVM CE 22.0.2+9.1 (build 22.0.2+9-jvmci-b01, mixed mode, sharing)

```

Looks good to me! But not all projects are using the latest-and-greatest. And maybe they're using a different JDK with a different toolchain. Suppose they need Azul or Liberica's distributions to gain accesss to the CRaC support. SDKMAN.io can also install and switch to a particular JDK for you when you `cd` into a given directory, but you need to opt-in: open up `~/.sdkman/etc/config` and change or add the line which relates to `sdkman_auto_env` to be: 


```shell
sdkman_auto_env=true
```

Save the file and then open a new shell. Now go into a directory in whcih you need a particular version of Java configured. Let's say I need (_gasp!_) an anachronism like Java 17 for a project I wrote four years ago. I can switch to the directory and install the required Java version: 


```shell 
sdk install java 17.0.12-oracle
```

And then switch to it:

```shell
sdk use java 17.0.12-oracle
```

Then I can memorialize it in an environment file in the local directory: 

```shell
sdk env init
```

This will create a `.sdkmanrc` in the current directory. (Make sure to add, commit, and push it to your Git repository!) Now, anybody else using SDKMAN.io with the auto_env feature enable can git clone-and-run your project with the right JDK. 


## Conclusion 

These two tools, along with other much more well-known tools like Docker, are invaluable in supporting a consistent git-clone-and-run development experience. 