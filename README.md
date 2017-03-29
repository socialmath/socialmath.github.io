### Versions

Some files will have several versions.  This is because I plan to
rewrite things multiple times to practice writing them.  The versions
will all coexist in a single commit, but only one will appear on the
website.  Here is how this is implemented.

The file with multiple versions is basically just an empty shell that
links to some version of it.  Here is `manifesto.md`, for example:

```
---
title: Manifesto
published: false
version: 2
---
```

Notice that there is no content!  The content is in
`/versions/manifesto-1.md`.  If we wanted to use
`/versions/manifesto-2.md`, we would change the fifth line of
`manifesto.md` to `version: 2`.  If we wanted to use
`/versions/manifesto-sillyversion.md`, we would change this line to
`version: sillyversion`.

How does this work?  Well, `manifesto.md` uses the layout
`_layouts/katex.html`, which has the following body:

```
  <body>
    {% if page.version %}
      {% capture version_name %}/_versions/{{page.title | downcase}}-{{page.version}}.md{% endcapture %}
      {% capture version_content %}{% include_relative {{ version_name }} %}{% endcapture %}
      {{ version_content | markdownify }} 
    {% else %}
      {{ content }}
    {% endif %}
  </body>
```

This looks at the version tag in `manifesto.md` and if it exists,
finds the correct file to display.  Otherwise, it just prints the
content of the file.

How does Jekyll know that `manifesto.md` uses the layout
`_layouts/katex.html`?  Well, `_config.yml` has the line

```
layout: katex
```

which indicates that the default layout for all files is
`_layouts/katex.html`.  If we wanted a different layout for some file,
say, `_layouts/page.html`, we could put the line

```
layout: page
```

at the top of that file.
