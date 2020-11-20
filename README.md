# Content for the JoshLong.com blog 

![Build Status](https://github.com/joshlong/joshlong.github.io-content/workflows/Build%20the%20Blawg/badge.svg)

This blog uses `jbake` to process the Markdown, Asciidoctor and HTML files and turn them into content that people can [read on the blog](http://joshlong.com). 

Make a change (such as editing an existing file or adding a new one to, for example, `content/jl/blogPost/*`) and then `git commit` and `git push` the change and you'll trigger a CI build. The CI build runs `jbake` on the content, then `git clone`s the Github pages site for the actual blog itself, adds the updated site to that build and then `git add` and `git commit`s everything to the repository. The changes then usually appear live on the blog. The whole process takes a minute or so. Just keep refreshing and your change will land, eventually.