title=Getting Emacs Ready for Writin', Part 1
date=2019-01-21
type=post
tags=blog
status=published
~~~~~~

I'm working on a new book, [_Reactive Spring_](http://ReactiveSpring.io), and in the process I'm trying to level up my `emacs`-fu. I wrote most of my last book with my buddy [Kenny Bastani](http://Twitter.com/KennyBastani), [_Cloud Native Java_](http://CloudNativeJava.io), in `emacs` and really enjoyed the process, especially having come from four other published books before that where the work was done largely in Microsoft Word, running inside a Windows Virtual Machine, running on my workhorse Linux desktop machine, a decade ago.

This time I wanted go further than just using `emacs` as a text editor with no plugins. I wanted to use some of the famed flexibility in Emacs. Today I spent a little time my with my friend [Mario Gray](http://Twitter.com/MarioGray) tweaking `emacs` then I threw everything we did away and tried to get the meaningful stuff setup again, from scratch, avoiding all the mistakes made in the first run, so that I could explain them all here.

The pre-requisite is that you're going to need to [install Melpa](https://melpa.org/#/getting-started), a repository for the Elpa package manager. That's easy. Copy-and-paste the configuration shown in that file to your `~/.emacs` file. You might have to create that file.

Once that's installed the rest is easy. You can use `M-x package-list-packages` to see all the possible packages. You should be able to find [`adoc-mode`](https://github.com/sensorflo/adoc-mode/wiki). You can install it by issuing `M-X package-install` and then specifying `adoc-mode`.

Now you can open up any file with Asciidoctor in it, issue `M-X adoc-mode` and it'll give you decent syntax highlighting. 

Next, and hear me out. I want to use `emacs` for Asciidoctor editing and I want to use it to do light refactoring of Java code. Perfectly normal. It's a natu... I SAID HEAR ME OUT! I know. But it's normal. Java code is text, last I checked. `emacs` is great with text. So, I'll let that sink in. I want to edit Java code. In `emacs`. :whistles:

Still there? My book has tons of code and I need to be able to look at the code, especially when annotating it. I don't want to have to load a whole IDE just to annotate the code for use in the book as includes in that book. `emacs` is crazy fast and purpose-built for this sort of editing so it figures I'd do that in here. But i'm not the good [Dr. Venkat Subramaniam](http://twitter.com/VenkatS). I don't write Java code without an IDE and hope to get away with it! I need the soft landing of syntax highlighting and in-editor compilation and feedback. Autocompletion would be nice too. 

Now, keep in mind I'm not planning on using `emacs` for some of the things you might think I'd use an IDE.

I'm _not_ using the IDE to format the code. That's done by the glorious [Spring Boot Java Format](https://github.com/spring-io/spring-javaformat) Maven plugin which I've configured in all my Maven projects. I  run `mvn spring-javaformat:apply` at the root of my project and it formats all my code consistently. If I _don't_ run that command, it fails the build! So I don't need to worry about tidying up in `emacs` versus Eclipse versus IntelliJ. There's only one way to get code past the CI build and that's not in `emacs`.

I'm _not_ planning on using `emacs` to do large scale refactorings (though, this `emacs` plugin does apparently support some of that. Which is nice.

All I want is syntax highlighting and the usual feedback. Tell me if something won't compile. Give me autocompletion as I type. The usual. 

This is all quite elegantly acheived with a plugin called [Meghanada](https://github.com/mopemope/meghanada-emacs). You can install it from your Elpa package manager as well. You'll need to copy-and-paste the configuration from the linked website into your `~/.emacs` file as well.

Once it's installed, just point `emac` to a `.java` file. It'll automatically syntax highlight it and even offer auto-completion for types as you type. The first time it's used on a `.java` file it'll download a server - what I imagine to be something like, if not exactly like, a Visual Studio Code Language Server, that it uses to index Maven and Java projects. Truly, what a time to be alive! 

<img src = "https://pbs.twimg.com/media/Dxf6gYMUcAEl-UX.png:large" />	


Here's my finished, working `~/.emacs` file.

```text

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))



(package-initialize)


(require 'meghanada)
(add-hook 'java-mode-hook
          (lambda ()
            ;; meghanada-mode on
            (meghanada-mode t)
            (flycheck-mode +1)
            (setq c-basic-offset 2)
            ;; use code format
            (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))
(cond
   ((eq system-type 'windows-nt)
    (setq meghanada-java-path (expand-file-name "bin/java.exe" (getenv "JAVA_HOME")))
    (setq meghanada-maven-path "mvn.cmd"))
   (t
    (setq meghanada-java-path "java")
    (setq meghanada-maven-path "mvn")))




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (## adoc-mode meghanada))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


```

This is fresh getting everything working. Nothing else installed like `markdown-mode+` or any of the other packages I had installed. 

Thanks again to [Mario Gray](http://Twitter.com/MarioGray)) for helping me get all the bugs ironed out to get this abomination working so smoothly! Now if we could only figure out why the lights in the room flicker every time I open `emacs`...

