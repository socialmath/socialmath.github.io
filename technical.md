---
title: Technical Description
---

### Here's what I did to set up this site

I originally forked Barry Clark's
[jekyll-now](https://github.com/barryclark/jekyll-now) repository, but
then I deleted everything except those things that were absolutely
necessary.  I plan to possibly add these things back in as I
understand them.  The bulk of these things I don't understand because
I don't know css, so I guess I should learn css next.  But is it
really so bad if a website looks really minimal like this?  Maybe I
could still do a minimal look better by knowing css.

Also, jekyll seems to be designed for blogs, but I don't plan for this
site to be a blog, so I got rid of the stock `index.html` with its
fee, iterating through the posts in the `_posts` directory.  I also
removed the `_posts` directory.  In the place of `index.html`, I put
an `index.md` file.

### KaTeX Support
I thought [KaTeX](https://khan.github.io/KaTeX/) was pretty cool,
because it does annoy me how long MathJax takes to load.  I got it
working by copying the KaTeX layout from
[here](https://github.com/cben/sandbox/blob/gh-pages/_layouts/katex.html).  Here are some examples:

$$
\frac{3}{2}=\int_{-\infty}^\epsilon\dfrac{x}{y}+\textrm{some text}
$$

Here is some inline math: $$x$$, $$y$$, and $$x+y=\frac{2}{3}\sim\dfrac{3}{2}$$.

### Windows Development Environment

I am doing this on Windows!  It was really time-consuming to set up a
way to host the website locally!  I had to install all sorts of
things, like chocolatey and ruby.  As usual, the information was
scattered all over the web.  [This
guide](http://programminghistorian.org/lessons/building-static-sites-with-jekyll-github-pages)
in particular really helped.

Here is what I think I did (I don't remember exactly, but it's better
than nothing):

* Install chocolatey.  Open PowerShell as administrator (right-click
   and click on "open as administrator).  Then enter

```sh
> Set-ExecutionPolicy RemoteSigned
> (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex
```

* Install `ruby`.  Open `git-bash` and type:

```sh
$ choco install ruby
```

* Prepare to install things with Ruby.  In `git-bash`, type:

```sh
$ cd
$ touch .bashrc
$ echo "export SSL_CERT_DIR=/mingw64/ssl/certs" >> .bashrc
$ echo "export SSL_CERT_FILE=/mingw64/ssl/cert.pem" >> .bashrc
$ source .bashrc
```
Now close `git-bash` and restart it.

* Install the `github-pages` gem:

```sh
$ gem install github-pages
```

Now, to host a github-pages website locally, type

```sh
$ jekyll serve --watch
```

and go in your browser to "localhost:4000".

* (optional) You may want to locally host a website with a Rubyfile.
I'm not sure yet what the benefit of a Rubyfile is yet, but here's
what you have to do to locally host a website with one:

Download the version of DevKit from
[here](https://rubyinstaller.org/downloads/) corresponding to your
version of Ruby.  (To see what version of Ruby you have, type `ruby
-v` in `git-bash`.

In `git-bash`, navigate to wherever you unpacked DevKit and type:

```sh
$ ruby dk.rb init
```

Find where Ruby was installed, and add a line with a space, a dash, a
space, and then the path of the Ruby directory to the `config.yml`
file in the DevKit directory.  This line should look something like this:

```
 - C:/Tools/ruby23
```

Then type:

```sh
$ ruby dk.rb install
```

You also need the `bundle` gem:

```sh
$ gem bundle
```

Now, whenever you edit the Rubyfile, you have to type this:

```sh
$ gem install
```

to generate a Rubyfile.lock file.

Then instead of `jekyll serve`, you have to type `bundle exec jekyll serve`.

### Haskell Diagrams

The diagrams this site are svg files that are generated
with [Haskell diagrams](http://projects.haskell.org/diagrams/).  Here
is an example:

{% include svg/diagrams/community1.svg %}

All of the svg files, and the lhs files that generate them, are in
`_includes/svg/diagrams/`.  To compile them yourself, first install
the [Haskell platform](https://www.haskell.org/platform/).  Then
update `cabal`, the Haskell package manager, and use it to make a
sandbox in your working directory:

```sh
$ cabal update
$ cabal sandbox init
```

Now install diagrams:

```sh
$ cabal install diagrams -j1
```

The `-j1` flag is only necessary for Windows.  It prevents `cabal`
from editing the `package.cache` file multiple times at one, which is
a problem for Windows but not for *nix.
See
[here](https://github.com/haskell/cabal/issues/4005#issuecomment-275434975) and
[here](https://github.com/commercialhaskell/stack/issues/2617) for
more information.

Then you can compile a haskell file `diagram.lhs` with

```sh
$ cabal exec -- ghc --make diagram.lhs
```

or, in PowerShell,

```sh
> cabal exec (ghc --make diagram.lhs)
```

This runs `ghc --make diagram.lhs` in the sandbox environment, which
generates an executable `diagram.exe`.  We now run this executable to
generate an svg file `diagram.svg`.

Bash:
```sh
$ ./diagram
```
Cmd.exe
```sh
> diagram.exe
```
PowerShell
```sh
> .\diagram.exe
```

If you are using bash, then you can run the shell script
`./compileDiagrams.sh`.  This compiles some or all of the haskell
files in `_includes/svg/diagrams/`, executes the resulting
executables, and also does some postprocessing (replaces `&amp;` with
`&` to reverse the xml-encoding of the svg builder).

To use this script on all diagrams:

```sh
$ ./compileDiagrams
```

To use it just on diagrams `thisOne.lhs`, `thisOneToo.lhs`, and
`alsoThis.lhs`:

```sh
$ ./compileDiagrams thisOne.lhs thisOneToo.lhs alsoThis.lhs
```
