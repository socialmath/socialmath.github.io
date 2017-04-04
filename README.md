### Versions

Some files will have several versions.  This is because I plan to
rewrite things multiple times to practice writing them.  I would like
to think of writing as a performance.  It makes more sense to me to do
multiple takes and pick the best than to do a single take and edit it.
(Of course it may make _even_ more sense to pick the best take and
_then_ edit it.  I don't know because I don't have much experience
trying these different approaches, it is all speculative as of yet.)

I also hope that this kind of versioning will help with two problems I
have when writing:

1. I have trouble writing when I don't know who my audience is.  I say
   things in different ways to different audiences, so when I am
   writing for the public I lose footing and I mentally flounder
   between the ways I would say things to different possible
   audiences.  With the versioning approach above, I can write each
   take with a specific audience in mind.
   
2. I struggle with perfectionism.  That is, I have trouble committing
   to one way of saying something over another, especially when the
   result will look all official on a public website.  The thought
   that I am just writing _a version_ of a document and not _the
   document_ makes it a lot easier for me.  My particular phraseology
   is no longer set in stone, because I can do another take a
   different way.  It makes it more like a transient form of
   communication like live music or talking, and in these forms I have
   no problem with perfectionism.

Since later versions are not necessarily improvements of earlier
versions, I would like them to all coexist in a single commit, so a
developer can easily toggle between the different versions of a file
without affecting anything else on the site.  However, only one should
appear on the website.  This concept of "versions" is very similar to
the concept of "takes" in a DAW such as Reaper, where for each track
independently you can select the take that plays back.

Here is how this is implemented.

The file with multiple versions is basically just an empty shell that
links to some version of it.  Here is `manifesto.md`, for example:

```
---
title: Manifesto
published: false
versions:
  - 1
  - 2
---
```

Notice that there is no content, just YAML front matter!  The content
is in `/versions/manifesto-1.md` and `/versions/manifesto-2.md`.  The
front matter indicates that we want both versions, 1 and 2, to be
displayed.  If we wanted just one version, say version 1, then we
would change our front matter as follows:

```
---
title: Manifesto
published: false
version: 1
---
```

Of course, it would be annoying to make these changes on github
because they would have to be commits, so if you want to toggle
between versions you should branch and clone the repository and do it
locally.  Instructions for setting up an environment for locally
hosing github-pages websites can be found in the index.md file.

How does this work?  Well, `manifesto.md` uses the layout
`_layouts/default.html`, which has the following body:


```
<body>
  {% if page.version %}
    {% capture version_name %}/_versions/{{page.title | downcase}}-{{ page.version }}.md{% endcapture %}
    {% capture version_content %}{% include_relative {{ version_name }} %}{% endcapture %}
    {{ version_content | markdownify }}
  {% elsif page.versions %}
    <h1> Versions of {{ page.title }} </h1>
    {% for version in page.versions %}
      <h2> Version {{ version }} </h2>
      {% capture version_name %}/_versions/{{page.title | downcase}}-{{version}}.md{% endcapture %}
      {% capture version_content %}{% include_relative {{ version_name }} %}{% endcapture %}
      {{ version_content | markdownify }}
    {% endfor %}
  {% else %}
    {{ content }}
  {% endif %}
</body>
```

This looks at the `version` variable in `manifesto.md` and if it
exists, finds the correct file to display.  If the `version` variables
doesn't exist, it looks for the `versions` variable and finds the
correct files to display, each with its own header.  We don't really
want these headers on the "finished" website, which will just have a
single version, but the `versions` variable won't be used on the
"finished website", just the `version` variable, because by then we
will have chosen a version.  The `versions` variable is really just
for testing.  If neither the `version` variable or the `versions`
variable exists, the actual content of the file is printed.

How does Jekyll know that `manifesto.md` uses the layout
`_layouts/default.html`?  Well, `_config.yml` has the line

```
layout: default
```

which indicates that the default layout for all files is
`_layouts/default.html`.  If we wanted a different layout for some file,
say, `_layouts/page.html`, we could put the line

```
layout: page
```

in the YAML front matter at the top of that file.
