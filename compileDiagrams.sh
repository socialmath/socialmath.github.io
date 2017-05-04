#!/usr/bin/bash

cd _includes/svg/diagrams/

function compile {
    echo "Compiling $1"
    [ -e "$1" ] || continue
    base=${1%.lhs}
    cabal exec -- ghc --make $filename
    ./$base
    # Haskell diagrams escapes text sequences when generating svg files,
    # so we need to unescape special characters to see them by replacing
    # "&amp;" --> "&".
    echo "$base.svg"
    sed -i "s/\&amp;/\&/g" "$base.svg"
}

if [[ $# -gt 0 ]]
then for filename in "$@" ; do
         compile $filename
     done
    
else for filename in [[:lower:]]*.lhs ; do
	 compile $filename
     done
fi


cd ../../../
