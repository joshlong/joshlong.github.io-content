title=Easy JVM Observability with the JCMD CLI
date=2023-01-11
type=page
status=published
listed=true
~~~~~~

Ha! [Dr. David Syer](https://twitter.com/David_Syer) just taught me about something that's been in Java forever: `jmcd`.

The [Bellsoft](https://bell-sw.com/announcements/2021/10/14/jcmd-everywhere-locally-containerized-and-remotely/) website has a good explanation:

> `jcmd` is the command line executed with JVM diagnostic tools shipped with OpenJDK. Before the introduction of jcmd, there were multiple tools to run live and post mortem diagnostics for JVM. `jcmd` became a to-go utility for live diagnostics of JVM executed from the command line (e.g., dumping threads or inspecting JVM configuration). The post mortem diagnostics are performed with other tools.

It's like a one-stop shop for all your JVM observability needs. The JVM exports certain signals, or commands, that it will respond to if you invoke them from `jcmd`. So, suppose you have a Spring Boot application that's up and running. 

Run just `jcmd` to see which JVM applications are running. It'll give you process identifiers (PIDs):

```shell
jcmd
```

Alternatively, Spring Boot will print the PID in the console when the application starts up:

```

... Starting JcmdApplication using Java 17.0.5 with PID 66488 ...

```

The PID for my application is 66488. So, run `jmcd <pid>` and you'll get a number of commands to which the JVM will respond for that application.

```shell
> jcmd 66488

66488:
The following commands are available:
Compiler.CodeHeap_Analytics
Compiler.codecache
Compiler.codelist
Compiler.directives_add
Compiler.directives_clear
Compiler.directives_print
Compiler.directives_remove
Compiler.queue
GC.class_histogram
GC.finalizer_info
GC.heap_dump
GC.heap_info
GC.run
GC.run_finalization
JFR.check
JFR.configure
JFR.dump
JFR.start
JFR.stop
JVMTI.agent_load
JVMTI.data_dump
ManagementAgent.start
ManagementAgent.start_local
ManagementAgent.status
ManagementAgent.stop
Thread.print
VM.cds
VM.class_hierarchy
VM.classloader_stats
VM.classloaders
VM.command_line
VM.dynlibs
VM.events
VM.flags
VM.info
VM.log
VM.metaspace
VM.native_memory
VM.print_touched_methods
VM.set_flag
VM.stringtable
VM.symboltable
VM.system_properties
VM.systemdictionary
VM.uptime
VM.version
help

For more information about a specific command use 'help <command>'.

```

Then you can invoke the signal with `jcmd`, like this:

```shell
> jcmd 66488 VM.version

66488:
OpenJDK 64-Bit Server VM version 17.0.5+8-jvmci-22.3-b08
JDK 17.0.5
```

Super useful, eh? 
