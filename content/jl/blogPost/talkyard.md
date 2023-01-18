title=Blog comments, brought to you by Talkyard
date=2023-01-19
type=post
tags=blog
status=published
~~~~~~


I've always wanted a decent commenting system in my blog, but have been so very lazy in building it. But it's 2023! We've  [got self driving cars (see this tweet where I caught a Cruise vehicle driving around San Francisco without anybody in the front seats)](https://twitter.com/starbuxman/status/1606517634509725697?s=61&t=5fkh7F674R2u1CuxAKBJvg), [AI-generated TV shows and YouTube videos](https://chat.openai.com) (but not my content, no sirree! My content is crappy through good old fashioned elbow grease, and not of the synthetic crap variety...), targeted CRISPR-enabled genetic cures [for stage 4 cancers](https://isbscience.org/news/2022/11/10/in-first-of-its-kind-trial-scientists-use-crispr-to-treat-cancer/#:~:text=Scientists%20for%20the%20first%20time,of%20Cancer%20(SITC)%202022.), [perpetual energy engines](https://techcrunch.com/2022/12/13/world-record-fusion-experiment-produced-even-more-energy-than-expected/#:~:text=World%2Drecord%20fusion%20experiment%20produced%20even%20more%20energy%20than%20expected,-Tim%20De%20Chant&text=It's%20official%3A%20A%20U.S.%20Department,more%20energy%20than%20it%20consumed.), and more!  So, surely, there's an easy way to add comments to a fairly [typical Vue.js application](https://github.com/developer-advocacy/joshlong-site) talking to a [typical Spring Boot backend](https://github.com/developer-advocacy/joshlong-api)? Yes. _Yes there is_. 


It's called [**Talkyard**](https://www.talkyard.io/). It's an opensource solution, but you can also pay them to run it as a software-as-a-service.. I was dreading adding it, but it was even  easier than adding Google Analytics to a page! Truly trivial! 

So, let's review: 


Go to Talkyard and sign up for a new account. Tell it on which domain you'll be using it. It's a painless process. I just signed in with Github and gave it a domain and it generated the HTML and JavaScript I'm about to present. Don't use mine. Go get your own. 

I changed the static host page (`index.html`) for my dynamic Vue.js application, adding the following to the `<head>` elements:

```html
    <script>talkyardServerUrl='https://site-ypulnxougd.talkyard.net';</script>
    <script async defer src="https://c1.ty-cdn.net/-/talkyard-comments.min.js"></script>
```

And in the Vue.js component for blog posts (I've just named it `posts/Post.vue`), I added the following markup:

```html

 <div>

      <!-- You can specify a per page discussion id on the next line, if your URLs might change. -->
      <div class="talkyard-comments" data-discussion-id="" style="margin-top: 45px;">
        <noscript>Please enable Javascript to view comments.</noscript>
        <p style="margin-top: 25px; opacity: 0.9; font-size: 96%">Comments powered by
          <a href="https://www.talkyard.io">Talkyard</a>.</p>
      </div>

    </div>

```

Then I saved and pushed the changes. There, of course, is where the _real_ trouble began! The build failed because I was using out of date Github Actions (I've been busy! So sue me! (but please don't)) and so my pipeline would no longer connect and deploy correctly to my GKE cluster. I fixed it, but this process of mechnically updating the build took longer than actually doing the work of installing Talkyard. Huh! 

You can login to Talkyard, moderate comments, bury unoffensive but low signal comments (the "thank you"s, "First!"s, etc.), use Markdown in the comments, and so much more. It's pretty darned slick! 

