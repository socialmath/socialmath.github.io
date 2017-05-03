#!/usr/bin/bash

cd _includes/svg/diagrams/

if [[ $# -gt 0 ]]
then for filename in "$@" ; do
	 echo $filename
         [ -e "$filename" ] || continue
         base=${filename%.lhs}
         cabal exec -- ghc --make $filename
         ./$base
     done
    
else for filename in [[:lower:]]*.lhs ; do
	 echo $filename
	 [ -e "$filename" ] || continue
	 base=${filename%.lhs}
	 cabal exec -- ghc --make $filename
	 ./$base
     done
fi

cd ../../../
