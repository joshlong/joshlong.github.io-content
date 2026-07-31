title=Updating SDKMAN to see your favorite new shiny JDK 
date=2026-07-31
type=post
tags=blog
status=published
~~~~~~


Sigh. SDKMAN.io has gone from being one of my favorite tools to being this never ending disappointment. What process could result in buildings taking this long to show up? It  sometimes lags _days_ behind a given JDK's release. Case in point, one OpenJDK distriution, [GraalVM](https://graalvm.org), has been available for _days_ but is still not available in SDKMAN. So, while we wait. Here's how you can install the JDK on your own system. I'm assuming you're using macOS. 

```shell

# first get the bits 
curl -LO https://gds.oracle.com/download/graal/25i2/latest/graalvm-jdk-25i2-25_macos-aarch64_bin.tar.gz

# download it somewhere 
mkdir ~/bin/graalvm 
cd ~/bin/

# unzip it 
tar -xvf graalvm-jdk-25i2-25.0.4_macos-aarch64_bin.tar.gz -C graalvm

# install it
sdk install java 25.2.4-graal $HOME/bin/graalvm/graalvm-25.2.4+7.1/Contents/Home

# make it available system-wide.
sdk default java 25.2.4-graal 
```


sigh.
