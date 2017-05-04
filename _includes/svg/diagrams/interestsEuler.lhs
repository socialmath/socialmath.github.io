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

> gradient = mkLinearGradient (mkStops [(white,0,1), (black,1,1)]) ((-0.5*_width) ^& 0) (0.5*_width ^& 0) GradPad
>
> _width = 500
> _height = 50
> _textSize = 20
>
> diagram :: Diagram B
> diagram = atPoints (map p2 [(0,0),(0,40),(0,80)])
>                    [(beside (r2 (0,1)) (circle 30) (alignedText 0.5 1 "I(C)")),
>                     (beside (r2 (0,1)) (circle 80) (alignedText 0.5 1 "I(B)")),
>                     (beside (r2 (0,1)) (circle 130) (alignedText 0.5 1 "I(A)"))]
>           # fontSizeO _textSize # center # frame (0.5*100)

And the output:

> main :: IO ()
> main = renderWithoutDOCTYPE "interestsEuler.svg" diagram
