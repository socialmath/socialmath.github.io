---
layout: katex
title: Index
---

Hi everyone this is a test.  

### Manifesto

[Here]({{ site.baseurl }}{% link manifesto.md %}) is the manifesto.

### Some background

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
this `index.md` file.  Later when I do more, this will become the
homepage and it will link to various other pages.  Now it is just a
testpage.

### KaTeX Support
I thought [KaTeX](https://khan.github.io/KaTeX/) was pretty cool,
because it does annoy me how long MathJax takes to load.  I got it
working by copying the KaTeX layout from
[here](https://github.com/cben/sandbox/blob/gh-pages/_layouts/katex.html).  Here are some examples:

$$
\frac{3}{2}=\int_{-\infty}^\epsilon\dfrac{x}{y}
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

```
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
