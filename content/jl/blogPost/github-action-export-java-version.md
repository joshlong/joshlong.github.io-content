title=A Github Action to export your project's Java version as a variable
date=2022-12-26
type=post
tags=blog
status=published
~~~~~~

I saw a great tweet from [Bruno Borges](https://twitter.com/brunoborges) about using Github Actions to derive the version of Java to be installed by analyzing the `pom.xml` of the build itself. It seems like a good enough idea, 
so I [put it into practive here](https://github.com/joshlong/java-version-export-github-action). Most of the magic lives [in a very tiny JavaScript file, `index.js`](https://raw.githubusercontent.com/joshlong/java-version-export-github-action/main/index.js):

Usage:

```yaml

const core = require("@actions/core");
const github = require("@actions/github");
const exec = require("@actions/exec");

function cmd(cmd, args, stdoutListener) {
  exec
    .exec(cmd, args, {
      listeners: {
        stdout: stdoutListener,
      },
    })
    .then((ec) => {
      console.debug("the exit code is " + ec);
    });
}

try {
  cmd(
    "mvn",
    [
      "help:evaluate",
      "-q",
      "-DforceStdout",
      "-Dexpression=maven.compiler.target",
    ],
    // ["help:evaluate", "-q", "-DforceStdout", "-Dexpression=java.version"],
    (outputBuffer) => {
      const output = outputBuffer.toString();
      console.log(output);
      const varsMap = new Map();
      varsMap.set("java_version", output + "");
      varsMap.set("java_major_version", parseInt("" + output) + "");
      varsMap.forEach(function (value, key) {
        console.log(key + "=" + value);
        core.setOutput(key, value);
        core.exportVariable(key.toUpperCase(), value);
      });
    }
  );
} catch (error) {
  core.setFailed(error.message);
}
```

Basically, you put this at the very beginning of your Github Actions flow, right after the checkout, and it'll 
analyse your Maven `pom.xml` to determine which version of Java you've configured by having Maven tell it the value of `maven.compiler.version`. The 
program then exports the version and the major version of Java as a step output _and_ an environment variable that you could use in subsequent steps.


So, assuming the following usage:

```yaml
      - uses: joshlong/java-version-export-github-action@v17
        id: jve
```

You can use the exported environment variable:

```
      - uses: actions/setup-java@v3
        with:
          java-version: ${{ env.JAVA_MAJOR_VERSION }}
```

or reference the step's output values, like this:

```yaml

      - uses: actions/setup-java@v3
        with:
          java-version: ${{ steps.jve.outputs.java_major_version }}
```


Now Github Actions will download whatever version of Java you've specified in your Maven `pom.xml`. 

I really should make this work for Gradle... (Pull requests welcome!) 

Happy new year! 

