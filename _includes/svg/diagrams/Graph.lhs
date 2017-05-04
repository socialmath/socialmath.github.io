This is a module for drawing graphs (the "vertices and edges" kind,
not the "graphing a function" kind).  It was designed for drawing
graphs of social networks for socialmath.github.io.  It uses
`diagrams`, a `haskell` package.` This package can generate svg files
that can then be embedded in html webpages.

First some haskell extensions: I don't know what these do atm, but the
`diagrams` manual says to use them.`

> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE TypeFamilies #-}

An error message said I should use this, and
https://hackage.haskell.org/package/diagrams-lib-1.4.0.1/docs/src/Diagrams.TwoD.Arrow.html
does, so why not?

> {-# LANGUAGE TemplateHaskell #-}

Now the module declaration.  At the moment it has two methods, `node`
and `completeGraph`.

> module Graph
> ( node
> , textNode
> , completeGraph
> , graph
> , textGraph
> , horizGraph
> , horizTextGraph
> , edgeLength
> , interOffset0
> , ArrowInfo(..)
> ) where

Some imports.

Diagrams.Prelude is needed for every `diagrams` file:

> import Diagrams.Prelude

We import the SVG rendering backend.  I'm not sure why we need it
here, because this file doesn't render SVG directly.  According to the
manual, `B` is an alias for whatever backened we are using.

> import Diagrams.Backend.SVG.CmdLine

Two extra modules that are used here:

> import Diagrams.TwoD.Vector
> import Data.Maybe (fromMaybe)

For the workaround detailed here:
http://projects.haskell.org/diagrams/doc/manual.html#faking-optional-named-arguments

> import Control.Lens (makeLensesWith)
> import Data.Default.Class

Now the methods:

We define a function `node`, which draws a node (aka vertex) of the
graph and labels it with an integer.  This integer is not displayed:
it is just for subsequent processing in order to refer to the node.
Given a diagram $d$ and a subdiagram $sd$ labelled with integer $i$,
`withName` and related methods can retrieve $sd$ from $d$ and $i$ and
operate on it.

> node :: Int -> Diagram B
>
> node n = circle 2 # fc black # tracePad 2 # named n
>
> -- Commenting until I know more about types
> --node n = node' 0.02 2 n
> --node' :: (OrderedField f) => x -> f -> Int -> Diagram B
> --node' dotRadius padding n =
> --    circle dotRadius # fc black # tracePad padding # named n

`node` uses `tracePad`, which is like `pad`, except that it pads the
trace instead of the envelope.  It is implemented exactly the same as
`pad`, except that instead of `withPadding` it uses `withTrace`.  The
purpose of `tracePad` in `node` is so that the arrows don't touch the
nodes, but rather end a little bit away from them.

> tracePad :: (Metric v, OrderedField n, Monoid' m)
>     => n -> QDiagram b v n m -> QDiagram b v n m
> tracePad scalingFactor d = withTrace (d # scale scalingFactor) d

Sometimes we want a node that is actually just text:

> textNode :: Int -> [Char] -> Diagram B
>
> textNode n string = (text string <> circle (0.2*edgeLength))
>     # fontSizeO (0.2*edgeLength)
> --    # scale 0.05
>     # lw none
>     # named n

Now the `completeGraph` function.  This generates a complete graph in
n nodes.  First it makes a `node` at each point of a regular $n$-gon,
and then it connects every pair of points with an arrow, using the
function `connectNodes`, which we will discuss later.  This means that
every node is connected to itself and that there are two opposing
arrows connecting every pair of distinct nodes.

> edgeLength = 100

> completeGraph n = atPoints (trailVertices $ regPoly n edgeLength)
>     (map node [0..(n-1)])
>     # applyAll [connectNodes j k n
>         | j <- [0..(n-1)], k <- [0..(n-1)]]

A non-complete graph.  It takes as input a list of pairs of nodes to
connect.  `completeGraph` could now be implemented as

`completeGraph n = graph n [(j,k) | j <- [0..(n-1)], k <- [0..(n-1)]]`

> graph n arrows = atPoints (trailVertices $ regPoly n edgeLength)
>     (map node [0..(n-1)])
>     # applyAll [connectNodes j k n
>         | (j,k) <- arrows]

And a `graph` with `textNode`s.

> textGraph n arrows strings = atPoints (trailVertices $ regPoly n edgeLength)
>     (zipWith textNode [0..(n-1)] strings)
>     # applyAll [connectNodes j k n
>         | (j,k) <- arrows]

A graph consisting of nodes in a straight line is also useful:

> horizGraph n arrows = atPoints (map p2 [(fromIntegral $ k*edgeLength,0) | k <- [0..(n-1)]])
>     (map node [0..(n-1)])
>     # applyAll [connectNodes j k n
>         | (j,k) <- arrows]

And with `textNode`s:

>-- horizTextGraph n offsets arrows strings = atPoints [p2 (fromIntegral $ k*edgeLength,0) | k <- [0..(n-1)]]
>--     (zipWith textNode [0..(n-1)] strings)
>--     # applyAll (zipWith (\(j,k) os -> connectNodes' os j k n) arrows offsets)

We need a datatype that stores the information about an arrow:

> data ArrowInfo = ArrowInfo { nodes :: (Int, Int)
>                            , aOffset :: Maybe Double
>                            , dash :: Maybe [Double]
>                            , label :: Maybe String
>                            }

>-- instance Default ArrowInfo where
>--   def = ArrowInfo
>--         { nodes = (0,0)
>--         , aOffset = Nothing
>--         , dash = Nothing
>--         , label = ""
>--         }
>
>-- makeLensesWith (lensRules & generateSignatures .~ False) ''ArrowInfo

> horizTextGraph n arrowInfos strings = atPoints [p2 (fromIntegral $ k*edgeLength,0) | k <- [0..(n-1)]]
>     (zipWith textNode [0..(n-1)] strings)
>     # applyAll (map (connectNodes' n) arrowInfos)


The two existing functions for connecting diagrams with arrows are
`connectOutside'` and `connectPerim'`.  In `connectOutside'`, the
endpoints of the generated arrow lie on the straight line between the
"origins" of the diagrams.  In `connectPerim'`, the endpoints of the
generated arrow are on the perimeters of the two diagrams at given
angles.

For connecting a node to itself, it makes sense to use `connectPerim'`,
because the straight line from the origin of a diagram to that very
same origin is undefined.  We want the arrow to curve a little, and
not go back to the exact same point on the perimeter of the node that
it started at.

For connecting a node to another node, we would think at first to use
`connectOutside'`.  However, this means that the arrow from node i to
node j has just the same endpoints as the arrow from node j to node i,
and this doesn't look very good.  So it would be nice for the
endpoints of an arrow to be slightly offset from the position that
`connectOutside'` would give them.  For this purpose I made the
function `connectOffset'`.  This function is modeled on
`connectPerim'` and `connectOutside`.

TODO: weird issue about different implementations of `connectPerim`
and `connectOutside` and `maxTraceP` vs `traceP`, and how these pick
out the right point after all, etc.

> connectOffset'
>   :: (TypeableFloat n, Renderable (Path V2 n) b, IsName n1, IsName n2)
>   => ArrowOpts n -> n1 -> n2 -> Angle n -> Angle n
>   -> QDiagram b V2 n Any -> QDiagram b V2 n Any
> 
> connectOffset' opts n1 n2 offset1 offset2 =
>   withName n1 $ \sub1 ->
>   withName n2 $ \sub2 ->
>     let [os, oe] = map location [sub1, sub2]
>         v = oe .-. os
>         s = fromMaybe os (maxTraceP os (v # rotate offset1) sub1)
>         e = fromMaybe oe (maxTraceP oe ((negated v) # rotate offset2) sub2)
>     in  atop (arrowBetween' opts s e)

Now we define the function `connectNodes`.  This function makes a
distinction between whether the nodes it is asked to connect are
distinct or identical.  The distinct case uses `connectOffset'`, and
the identical case uses `connectPerim'`, as previously noted.

The angles passed to `connectPerim` are chosen so that each self-arrow
is on the outside of the polygon.  The angle pointing out of the
polygon for node $j$, `idAngle j`, is determined by looking at the
nodes on either side of $j$, averaging the positions of these nodes,
and then returning the vector `v` from this average to the position of
node $j$ itself.  If `v==0`, then as a default `idAngle j` is chosen
to be upwards (this happens with `n==1`).

I originally based `idAngle` on the value of `j`, and incremented it
by `n`ths of a rotation as `j` increased.  However, this proved
unreliable, because although the node labels do increase
counterclockwise around the polygon, node $0$ is not in a consistent
location.  `regPoly` first generates the polygon with "turtle"
graphics (as in Logo), and the turtle starts by going upwards.  But
then the entire polygon is rotated by a minimum angle such that the
bottom edge is horizontal.  This procedure doesn't place node $0$ in a
natural location.  It could still be predicted, but I don't think anything
should be based on it, because there is clearly no guarantee that it
won't be changed in the next version of `diagrams`.

The actual angles passed to `connectOffset'` are
`idAngle`$\pm$`idOffset`, where `idOffset` is just a constant.  TODO:
make this not just a constant.

> connectNodes j k n = connectNodes' n (ArrowInfo { nodes = (j,k)
>                                                 , aOffset = Nothing
>                                                 , dash = Nothing
>                                                 , label = Nothing
>                                                 })
>
> connectNodes' n arrowInfo@(ArrowInfo { nodes = (j,k)
>                                      , aOffset = myOffset
>                                      , dash = myDash
>                                      , label = myText
>                                      }) d
>     | j/=k = connectOffset' (interStyle arrowInfo') j k (interOffset' @@ turn) (-interOffset' @@ turn) d
>     | otherwise = connectPerim' (idStyle arrowInfo') j k (idAngle ^+^ (idOffset' @@ turn)) (idAngle ^-^ (idOffset' @@ turn)) d
>         where interOffset' = (maybe (interOffset j k n) id myOffset)
>               idOffset' = maybe idOffset id myOffset
>               arrowInfo' = ArrowInfo { nodes = (j,k)
>                                      , aOffset = Just $ if (j==k) then idOffset' else interOffset'
>                                      , dash = myDash
>                                      , label = myText
>                                      }
>               idAngle =
>                   let getLoc = (maybe (p2 (0,0)) location).((`lookupName` d).(`mod` n))
>                       [nodeLoc,succLoc,predLoc] = map getLoc [j, succ j, pred j]
>                       v = nodeLoc .-. average predLoc succLoc
>                   in (if v==0 then (1/4 @@ turn) else (v ^. _theta))
>
> average u v = u .+^ (1/2 *^ (v .-. u))
> idOffset = 1/12

There are a lot of arrows in a `completeGraph`, and they tend to bump
into each other.  To prevent this, I added an additional offset to the
endpoints of the arrows.  This offset, for nodes $j$ and $k$, is a
multiple of $(k-j \pmod n) - \frac{n}{2}$.

The original offset:

> interOffset0 = 1/24

The additional offset:

> spaceCorrection j k n = ((fromIntegral $ mod (k-j) n) - (fromIntegral n)/2)*spaceCorrectionFactor
> spaceCorrectionFactor = 1.5/48

The total offset:

> interOffset j k n = interOffset0 + spaceCorrection j k n

Although we can't rely on the location of node 0, I think the use of
turtle graphics means that we can rely on the labels ascending
counterclockwise.  We have relied on this fact here.

Finally, we need to define the `arrowStyle`s.  We use a thin arrowhead
in order to help prevent the arrows from hitting each other:

> myTri = arrowheadTriangle (160 @@ deg)

For some reason, the angle used by `arrowheadTriangle` is the exterior
angle, not the interior angle.  We put $160\deg$, which gives an
interior angle of $20\deg$.

Now the `angleStyles` themselves:

> shaftWidth = 1
> arrowLength = 15
> 
> interStyle ArrowInfo { nodes = (j,k)
>                      , aOffset = Just theOffset
>                      , dash = myDash
>                      , label = myText
>                      } =
>   (with & arrowHead .~ myTri
>         & headLength .~ output arrowLength
>         & arrowShaft .~ interShaft theOffset
>         & shaftStyle %~ (lwO shaftWidth).(maybeDashing myDash))
> 
> idStyle ArrowInfo { nodes = (j,k)
>                      , aOffset = Just theOffset
>                      , dash = myDash
>                      , label = myText
>                      } =
>   (with & arrowHead .~ myTri
>         & arrowTail .~ lineTail
>         & lengths .~ output arrowLength
>         & arrowShaft .~ idShaft theOffset
>         & shaftStyle %~ (lwO shaftWidth).(maybeDashing myDash))
>
> maybeDashing Nothing = id
> maybeDashing (Just dash) = dashingO dash 0

For `idStyle`, it is important that the head and tail are the same
length, since the arrow is very small.  Thus we have an `arrowTail`
that is just a straight line, and `lengths .~ normal` guarantees that
the head and tail are the same length.

TODO: insert good explanation of this

We want the arrows to always seem to "come out of the nodes".  In
other words, we want the tangent lines to the arrows at their
endpoints to go through the nodes they are ending at.  Thus we define
the `arrowShaft`s as functions of the offsets.

`interShaft` is an arc which turns by an angle of `offset*2`:

> interShaft offset = arc xDir (-offset*2 @@ turn)

`idShaft` is a Bezier curve.  This is assumed to start at $(0,0)$ and
is determined by two control points, `c1` and `c2`, and the final
point `fin`.  I choose `fin` arbitrarily to be `unit_Y`, or $(0,-1)$
(this is arbitrary because the shaft is ultimately scaled and rotated
anyway).  So we are imagining the arrow ending up directly below where
it started.  To get there it starts by going up and to the right at an
angle of `offset`, and then it curves clockwise, ending going up and
to the left at an angle of `-offset`.
 
> idShaft offset = (fromSegments [bezier3 c1 c2 fin])
>     where c1 = r *^ (e (offset @@ turn))
>           c2 = (r *^ (e (-offset @@ turn))) ^+^ unit_Y
>           fin = unit_Y
>           r = 2
