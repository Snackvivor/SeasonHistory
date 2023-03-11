#!/bin/bash

# Date: 
#
# Script Purpose: 
# Version: 1.0
#
# Command examples:
#   ./sitemap.sh

originalPWD=`pwd`                               # print working directory
sitemap="${originalPWD}/sitemap.md"             # initialize sitemap .md
echo "# DevOps Wiki Sitemap" > ${sitemap}       # Print header

# determines the number of tabs to format the sitemap and print the page links
createContent(){

    while getopts ":d:s" flag; do
        case "${flag}" in
            d) dir=${OPTARG};;
            s) strippedPwd=${OPTARG};;
        esac
    done

    currPwd=`pwd`
    char="/"
    slashCount=$(echo "${strippedPwd}/${dir}" | awk -F"${char}" '{print NF-1}')  # coutns / in path

    # counter for number of tabs over based of number of / in the path
    tabString=""
    i=1
    while [ $i -lt $((slashCount)) ] 
    do
        tabString="$tabString  "
        i=$(($i + 1))
    done
    if [[ ! -z "$tabString" ]]; then
        folderString=${tabString::-2}
    fi
    
    # checks if file is in the root, if it is then second level header
    if [[ "$strippedPwd" == "" ]]; then
        echo "" >> ${sitemap}
        echo "## [${dir^^}](${strippedPwd}/${dir})" >> ${sitemap}
        echo "" >> ${sitemap}
    else
        # if not in root, it must be a folder so print folder's landing page
        echo "" >> ${sitemap}
        echo "## [${dir^^}](${strippedPwd}/${dir})" >> ${sitemap}
        echo "" >> ${sitemap}
        # retrieves first line of the file which should be header according to markdown
        #FIRSTLINE=`head -n 1 ${dir}.md`
        # if in md linter format header will be first, remove #
        #if [[ "${FIRSTLINE:0:1}" == "#" ]]; then
        #    echo "$folderString- [${FIRSTLINE#*# }](${strippedPwd}/${dir})" >> ${sitemap}
        #else
        #    # if html format, remove <!-- TITLE:  -->
        #    if [[ "${FIRSTLINE:0:4}" == "<!--" ]]; then
        #        FIRSTLINE="${FIRSTLINE#*: }"
        #        FIRSTLINE="${FIRSTLINE% *}"
        #        echo "$folderString- [${FIRSTLINE}](${strippedPwd}/${dir})" >> ${sitemap}
        #    else
        #        # if not linter or html, just use file name
        #        echo "$folderString- [${dir}](${strippedPwd}/${dir})" >> ${sitemap}
        #    fi
        #fi
    fi

    # go into folder to get files within
    cd $dir
    for currentFile in *.md; do
        strippedFile="${currentFile%.*}"    # gets rid of .md at end of file name
        # checks to make sure not another folder
        if [[ -d $strippedFile ]]; then
            continue
        else
            # has to be file so print out file link
            if [[ $strippedFile != "*" ]]; then

                # retrieves first line of the file which should be header according to markdown
                FIRSTLINE=`head -n 1 ${strippedFile}.md`
                # if in md linter format header will be first, remove #
                if [[ "${FIRSTLINE:0:1}" == "#" ]]; then
                    echo "$tabString- [${FIRSTLINE#*# }](${strippedPwd}/${dir}/${strippedFile})" >> ${sitemap}
                else
                    # if html format, remove <!-- TITLE:  -->
                    if [[ "${FIRSTLINE:0:4}" == "<!--" ]]; then
                        FIRSTLINE="${FIRSTLINE#*: }"
                        FIRSTLINE="${FIRSTLINE% *}"
                        echo "$tabString- [${FIRSTLINE}](${strippedPwd}/${dir}/${strippedFile})" >> ${sitemap}
                    else
                        # if not linter or html, just use file name
                        echo "$tabString- [${strippedFile}](${strippedPwd}/${dir}/${strippedFile})" >> ${sitemap}
                    fi
                fi
            fi
        fi
    done
    cd ..
}

# finds folderd and files to print out in proper order
findFolders(){
    # looks at every file and folder in current path
    for dir in *; do
        if [ -d "$dir" ]; then
            currPwd=`pwd`
            strippedPwd="${currPwd##${originalPWD}}"
            # if dir is invalid, don't add a link, otherwise create
            if [[ $dir =~ " " ]]; then
               echo "INVALID DIRECTORY NAME, SKIPPING"
               echo "DIR: $dir"
               echo "INVALID DIRECTORY NAME, SKIPPING"
            else 
                createContent -d $dir -s $strippedPwd
                # go into folder as much as possible with recursive call
                cd $dir
                findFolders  
                cd ..
            fi
        fi
    done
}

# call to start script
findFolders
