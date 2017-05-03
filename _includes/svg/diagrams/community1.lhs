\begin{code}

{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
import Graph
import NoDOCTYPE

diagram = atPoints (map ((scale edgeLength).p2) [(0,0), (1.75,-0.875), (0.9,0.9), (2,0.5), (2,1.5), (2.5,-0.4), (3,-0.5), (2.75,0.75)])
    ((map completeGraph [5, 3, 1, 1, 2]) ++ (map node [40..42]))
    # center # frame (0.5*edgeLength)

main = renderWithoutDOCTYPE "community1.svg" (diagram :: Diagram B)

\end{code}
