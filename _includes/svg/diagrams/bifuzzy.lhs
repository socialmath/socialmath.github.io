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


And NoDOCTYPE, a module I made that lets me make svg files with no
DOCTYPE header.  DOCTYPE headers show up on the webpage when I include
svg files with `{% include ... $}` in jekyll.

> import NoDOCTYPE

Here is our diagram.

> gradient = mkLinearGradient (mkStops [(black,0,1), (white,0.5,1), (black,1,1)]) ((-0.5*_width) ^& 0) (0.5*_width ^& 0) GradPad
>
> _width = 800
> _height = 50
> _textSize = 20
>
> diagram :: Diagram B
> diagram = atPoints (map p2 [(0,0),
>                             (-0.5*_width,0.65*_height), (0,0.65*_height), (0.5*_width,0.65*_height),
>                             (-0.5*_width,0.65*_height+_textSize), (0,0.65*_height+_textSize), (0.5*_width,0.65*_height+_textSize)])
>   [(rect _width _height # fillTexture gradient # lw 1),
>     alignedText 0 0 "Much hate", alignedText 0.5 0 "No intimacy", alignedText 1 0 "Much love",
>     alignedText 0 0 "-True", alignedText 0.5 0 "False", alignedText 1 0 "True"]

>   # fontSizeO _textSize # center # frame (0.5*100)

And the output:

> main :: IO ()
> main = renderWithoutDOCTYPE "bifuzzy.svg" diagram
