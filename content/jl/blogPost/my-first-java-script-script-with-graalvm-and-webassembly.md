title=Sorcery with WebAssembly, GraalVM, and Java!
date=2025-03-28
type=post
tags=blog
status=published
~~~~~~


Alternative title: _How I like to write my JavaScripts: in Java via WebAssembly!_ 

TL;DR: the code [is _here_](https://github.com/coffee-software-show/graalvm-and-webassembly) if you want to try it! But, I suggest you read on. 


Second: I don't have the ability to test or document any of this on Windows. I'm sorry. Though  I've committed the final built WebAssembly artifact so one imagines that, given `node` on Windows, you could run the application...

OK, read on! 

One of my favorite doctors, [Dr. Niephaus](https://medium.com/@fniephaus), is at it again! 

He's doing a presentation at WASM.io this [very day](https://2025.wasm.io/sessions/the-future-of-write-once-run-anywhere-from-java-to-webassembly/) looking at how to use a new WebAssembly backend for GraalVM! Yes, you heard me, you can write Java code and target WebAssembly! 

The full length talk from WASM.io should be online soon, and I can't wait to watch  it and greatly expand upon the pittance of a scrap of a rotten morself of knowledge  that is this post on which we must contentedly dine, for the moment...



Now, there are - as you might imagine - _several_ limitations. First, it's nowhere near done! Second, it's work that's being done on at the very least GraalVM for Java 25. Third, it's targeting Oracle GraalVM (as opposed to GraalVM community edition). Fourth,  there's no networking support.   

The third one isn't necessarily a dealbreaker for a lot of folks, but keep it in mind. Not sure whether this stuff ever lands in the community edition. I'm also not sure it matters, since the licensing for Oracle GraalVM is so permissive with respect to cost (free) and usecases. I'm not a lawyer and my knowledge of the situation could be out of date.. blah blah. Anyway, I'm locked in. 

So, next question. How do i get this early access JDK? 

I'm  using the excellent [SDKMAN.io](https://sdkman.io), which as of 28 March, 2025, doesn't yet have a distribution for this early access build of GraalVM for Java 25, so I just needed to do so manully. 

Here's a script that - depending on whether you're on macOS or Linux and x86 or ARM - downlaods the right version of the JDK by consulting [this releases file](https://raw.githubusercontent.com/graalvm/oracle-graalvm-ea-builds/refs/heads/main/versions/25-ea.json).

```shell
#!/usr/bin/env bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

function setup(){
  if [[ "$OSTYPE" == "darwin"* ]]; then
      platform="darwin"
  elif [[ "$OSTYPE" == "linux"* ]]; then
      platform="linux"
  fi
  arch=$(uname -m)
  if [[ "$arch" == "x86_64" ]]; then
      arch="x64"
  elif [[ "$arch" == "arm64" ]] || [[ "$arch" == "aarch64" ]]; then
      arch="aarch64"
  fi
  json_url="https://raw.githubusercontent.com/graalvm/oracle-graalvm-ea-builds/refs/heads/main/versions/25-ea.json"
  temp_file=$(mktemp)
  curl -s "$json_url" > "$temp_file"
  if [ $? -ne 0 ]; then
      echo "Failed to download version information"
      rm "$temp_file"
      exit 1
  fi
  latest_version=$(jq -r '[.[] | select(.latest == true)] | .[0].version' "$temp_file")
  base_url=$(jq -r --arg version "$latest_version" '[.[] | select(.version == $version)] | .[0].download_base_url' "$temp_file")
  filename=$(jq -r --arg version "$latest_version" --arg arch "$arch" --arg platform "$platform" \
    '[.[] | select(.version == $version)] | .[0].files[] | select(.arch == $arch and .platform == $platform) | .filename' "$temp_file")
  echo $filename
  download_url="${base_url}${filename}"
  curl -o graalvm.tgz -L -O "$download_url"
  OD=temp_extract
  mkdir -p $OD
  tar -xzf graalvm.tgz -C $OD
  cd $OD
  folder=$(  find . -maxdepth 1 -type d -mindepth 1   | head -n1 )
  echo "the folder is $folder "
  mkdir -p $HOME/bin
  install_dir=$HOME/bin/${folder}
  mv $OD/${folder} $install_dir
  sdk install java 25.ea.15-graal $install_dir/Contents/Home
  
}

sdk list java | grep 25.ea.15-graal || setup
```

That's a little much, perhaps, but it works for me.  I now have Oracle GraalVM for Java 25 installed and I can now make it the default for my system: 

```shell
sdk default java  25.ea.15-graal 
```

If everything's worked, you can do: 

```shell 
java --version 
```

Now let's try a simple example. Create a new directory, say `sample`. In there, create a new class called `Main.java`.

```java
public class Main {

	public static void main(String [] args) {
		System.out.println("Hello, WebAssembly!");
	}
}
```

Now you'll test that it's worked by compiling and running it on the JRE:


```shell
javac Main.java && java Main 
```

Now we're ready to make this work in WebAssembly. But first, you'll need a set of tools in a package called [binaryen](https://github.com/WebAssembly/binaryen). I'm on macOS, so  I use [Homebrew.sh](https://brew.sh): `brew install binaryen`. Easy! 



You can get a typical GraalVM native image thusly:

```shell
javac Main.java && native-image  Main  
```

Run `./main` in the same directory. _Zoom_! 
 
If that's worked, then we can finally do _the thing_ and get a WebAssembly artifact:

```shell
javac Main.java && native-image   --tool:svm-wasm Main  
```

You should see three files: 

```
...
main.js
main.js.wasm
main.js.wat
...
```

You can run `main.js` with `node` thusly:

`node main.js`

Do you see `Hello, WebAssembly!`? If so, congrats! You just wrote your first real Java.. Script!