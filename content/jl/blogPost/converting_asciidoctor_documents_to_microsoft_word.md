title=Converting Asciidoctor documents to Microsoft Word
date=2023-02-02
type=post
tags=blog
status=published
~~~~~~


You know, I _love_ Asciidoctor! It's an amazing way to author and publish. I even built up a publishing pipeline called 
[_Bootiful Asciidoctor_](https://bootiful-asciidoctor.github.io/). That's a story for another day. In the meantime, I put together a, let's say _pamphlet_, or a particularly long article, using Asciidoctor. Not a full e-book. And, in order to move the process forward, I need to turn the output into a Microsoft Word document. So what's an awesome Asciidoctor author to do? Automate, obviously! 

Asciidoctor doesn't support direct transformations to _everything_, but it does support enough transformations that _one_ of the products of those transformations ought to be enough to get where you're going. In my case, it's with the help of a Haskell command line utility called `pandoc` and the Docbook format.  

 So, step one: turn your documentation into a Docbook document:

```shell
asciidoctor my.adoc --backend docbook -o output.docbook
```

Then, turn the output of that  - `output.docbook` - into a Microsoft Word `.docx` file with `pandoc`, like this:

```shell
pandoc -f docbook -t docx  ./output.docbook -o output.docx
```
Ét voilá! Send that `output.docx` to the unwashed in your workflow. 
