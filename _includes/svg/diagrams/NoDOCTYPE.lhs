
Why go to all this trouble?  Well, we want to make a svg file with no
DOCTYPE header.  A DOCTYPE header will show on the page when we
include an svg file "inline" in jekyll using `{% include ... %}`.
Also, while we're at it, we might as well use pretty print so the svg
file we generate is actually readable and not just a block of text.

First some haskell extensions: I don't know what these do atm, but the
`diagrams` manual says to use them.`

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE TypeFamilies #-}

We define the module:

> module NoDOCTYPE ( renderWithoutDOCTYPE ) where

Some imports.

Diagrams.Prelude is needed for every `diagrams` file:

> import Diagrams.Prelude

We import the entire SVG rendering backend, not just
`Diagrams.Backend.SVG.CmdLine`.

> import Diagrams.Backend.SVG

Another thing we need:

> import Data.Text (empty)

We define an `SVGOptions` in order to set `_generateDoctype` to
`False` and hence prevent our svg file from having a DOCTYPE.

_size = mkSizeSpec $ V2 (Just w) Nothing,

> svgOpt :: Num n => Options SVG V2 n
> svgOpt = SVGOptions {
>   _size = absolute,
>   _idPrefix = empty,
>   _svgDefinitions = Nothing,
>   _svgAttributes = [],
>   _generateDoctype = False -- Here it is!!!
> }

I'm not sure why we need this elaborate type declaration, but the
program fails without it, saying:
    Expected type: SizeSpec V2 n
    Actual type: SizeSpec V2 Int

> w :: (Num n) => n
> w = 400

Why not pretty-print while we're at it?

> renderWithoutDOCTYPE :: SVGFloat n => FilePath -> QDiagram SVG V2 n Any -> IO ()
> renderWithoutDOCTYPE outFile = renderPretty' outFile svgOpt


