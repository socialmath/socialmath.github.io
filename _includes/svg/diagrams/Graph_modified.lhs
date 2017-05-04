This is a module for drawing graphs (the "vertices and edges" kind,
not the "graphing a function" kind).  It was designed for drawing
graphs of social networks for socialmath.github.io.  It uses
`diagrams`, a `haskell` package.` This package can generate svg files
that can then be embedded in html webpages.

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE TypeFamilies #-}

> module Graph where

> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
> import Diagrams.TwoD.Vector
> import Data.Maybe (fromMaybe)

> data ArrowInfo = ArrowInfo { _nodes :: (Int, Int)
>                            , _offset :: Maybe Double
>                            , _dashing :: [Double]
>                            , _text :: String
>                            }

> instance Default ArrowInfo where
>   def = ArrowInfo
>         { _nodes = (0,0)
>         , _offset = Nothing
>         , _dashing = []
>         , _text = ""
>         }

> makeLensesWith (lensRules & generateSignatures .~ False) ''ArrowInfo

> arrowStyle ArrowInfo { _nodes = (j,k)
>                      , _offset = maybeOffsetArg
>                      , _dashing = dashingArg
>                      , _text = textArg
>                      } =
>   (with & arrowHead .~ myTri
>         & arrowTail .~ lineTail
>         & lengths .~ output arrowLength
>         & arrowShaft .~ shaft offset
>         & shaftStyle .~ (lw shaftWidth).(dashingO dashingArg))
>   where (shaft,defaultOffset)=
>           if j==k then (idShaft, idOffset) else (interShaft, interOffset n j k)
>         offset = maybe defaultOffset maybeOffsetArg

> myTri = arrowheadTriangle (160 @@ deg)
> 
> shaftWidth = 1
> arrowLength = 15

> idOffset = 1/12
> interOffset n j k = interOffset0 + spaceCorrection n j k
> interOffset0 = 1/24
> spaceCorrection n j k = ((fromIntegral $ mod (k-j) n) - (fromIntegral n)/2)*spaceCorrectionFactor
> spaceCorrectionFactor = 1.5/48

> interShaft offset = arc xDir (-offset*2 @@ turn)
> idShaft offset = (fromSegments [bezier3 c1 c2 fin])
>     where c1 = r *^ (e (offset @@ turn))
>           c2 = (r *^ (e (-offset @@ turn))) ^+^ unit_Y
>           fin = unit_Y
>           r = 2
>

> connectNodes n arrowInfo@ArrowInfo { _nodes = (j,k)
>                                    , _offset = maybeOffsetArg
>                                    , _dashing = dashingArg
>                                    , _text = textArg
>                                    } d =
>   | j==k = connectPerim' (arrowStyle arrowInfo) j k (
> 
> 
