title=Functionally Filtering a String in Java 8
date=2017-03-18
type=post
tags=blog
status=published
~~~~~~


I was looking for cleaner ways to filter a string in Java 8. I figured this would be easy as Java has lambdas nicely woven into the APIs, and `String` instances are _already_ immutable so it seemed like a home-run.

I knew how to do it in a trivial Python example:

```
#!/usr/bin/env python
print ''.join([a for a in '123 a string !!!' if a.isalpha()])
```

I asked on Twitter:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">“a string !!”.chars().boxed()<br>  .filter(c-&gt; isLetter(c))<br>  .map(i -&gt; Character.toString(Character.toChars(i)[0])) <br>  .collect(joining(&quot;&quot;)) 😞</p>&mdash; Josh Long (龙之春, जोश) (@starbuxman) <a href="https://twitter.com/starbuxman/status/843215420039553026">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

My initial attempt was valiant, but _very_ complicated. A Java `String` returns an `IntStream` from the `chars()` method, so at some point there _has_ to be a conversion to a `Character` - this means boxing and unboxing, _somewhere_.

Others replied suggesting that I use

..a regular expression:  

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/phillip_webb">@phillip_webb</a> <a href="https://twitter.com/starbuxman">@starbuxman</a> <a href="https://twitter.com/java">@java</a> what&#39;s wrong with something like<br>&quot;a string !!&quot;.replaceAll(&quot;[^a-zA-Z]&quot;,&quot;&quot;)<br>?</p>&mdash; Ralf D. Müller™ (@RalfDMueller) <a href="https://twitter.com/RalfDMueller/status/843224851267641349">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

..or Kotlin:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/starbuxman">@starbuxman</a> &quot;a string !!&quot;.filter(Char::isLetter)<br><br>Did I break your Java?</p>&mdash; Hadi Hariri (@hhariri) <a href="https://twitter.com/hhariri/status/843222983925792768">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

..or the `replace` method:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/starbuxman">@starbuxman</a> You don’t fancy:<br><br>&quot;a string !!&quot;.replaceAll(&quot;\\W&quot;, &quot;&quot;)<br><br>?</p>&mdash; Nicky Mølholm (@moelholm) <a href="https://twitter.com/moelholm/status/843226794241200128">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

All of these are good ideas, but not quite what I wanted.

I was looking for trivial amounts of conceptual noise - something I could stare at and process, quickly. Maybe Python was the right thing, after all? So I tried embedding Jython (the Python language implementation on the JVM). This required a pesky, um, let's call it _utility_ library (the entire Python language and runtime) whose Maven coordinates are `org.python` : `jython` : `2.7.1.b3` :

```
import org.python.util.PythonInterpreter;
import java.util.Properties;

public class JythonApplication {
	public static void main(String[] args) {
		Properties properties = new Properties();
		properties.put("python.import.site", "false");
		PythonInterpreter.initialize(System.getProperties(), properties, new String[0]);
		System.out.println(new PythonInterpreter().eval("''.join([a for a in '123 a string !!!' if a.isalpha()])"));
	}
}
```

Not bad! (I'm only kidding. Half kidding, anyway.) _Some_ people liked it, alright? Jeez! :D  

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/rotnroll666">@rotnroll666</a> <a href="https://twitter.com/phillip_webb">@phillip_webb</a>  <br>System.out.println(new PythonInterpreter().eval(&quot;&#39;&#39;.join([a for a in &#39;123 a string !!!&#39; if a.isalpha()])&quot;)); :D</p>&mdash; Josh Long (龙之春, जोश) (@starbuxman) <a href="https://twitter.com/starbuxman/status/843226085118554112">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The following example does a bit less gymnastics than my previous example, and is functional, so I suppose it's the best solution so far. I learned a lot from this example, too.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/phillip_webb">@phillip_webb</a> <a href="https://twitter.com/starbuxman">@starbuxman</a> Not sure if more clearer but one functional alternative would be <a href="https://t.co/RNFOvLSnAi">pic.twitter.com/RNFOvLSnAi</a></p>&mdash; Tomche Delev (@tdelev) <a href="https://twitter.com/tdelev/status/843220643760037888">March 18, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
