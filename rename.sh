#/bin/sh

recursiveRename() {

for f in *
do
    if [ -d "$f" ]
    then
        cd "$f"
        LOCATION="$SEARCH_FOLDER\\$f"
        recursiveRename $LOCATION
        cd ..
    else
        if [[ $f == *.html ]]
        then
            newLoc=${f%.html}
            currWord=""
            oldWord=""
            for word in $newLoc
            do
                currWord=$word
                if [[ ${currWord:0:1} == "[" ]]
                then
                    mv "$f" "${oldWord}.md"
                fi
                oldWord=$word
            done
            newLoc=${newLoc}.md
        fi
    fi
done

}

recursiveRename