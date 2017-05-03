First some haskell extensions: I don't know what these do atm, but the
`diagrams` manual says to use them.`

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE TypeFamilies #-}

Some imports.

Diagrams.Prelude is needed for every `diagrams` file:

> import Diagrams.Prelude

We import the SVG rendering backend.

> import Diagrams.Backend.SVG.CmdLine

We import Graph, a module I made that generates graphs (the
"vertices and edges" kind, not the "graphing a function" kind).

> import Graph

And NoDOCTYPE, a module I made that lets me make svg files with no
DOCTYPE header.  DOCTYPE headers show up on the webpage when I include
svg files with `{% include ... $}` in jekyll.

> import NoDOCTYPE

Here is our diagram.  It has one arrow `(1,0)` from $$B$$ to $$A$$.

> diagram :: Diagram B
> diagram = textGraph 2 [(1,0), (0,1)] ["A", "A"]
>     # center # frame (0.5*edgeLength)

And the output:

> main :: IO ()
> main = renderWithoutDOCTYPE "divided1.svg" diagram
