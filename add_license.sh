#!/bin/bash

LICENSE_TMP_DIR=`cd ${BASH_SOURCE[0]%/*}/;pwd`
export LICENSE_TMP_DIR
C_LICENSE="${LICENSE_TMP_DIR}/c_license_header.tmp"
XML_LICENSE="${LICENSE_TMP_DIR}/xml_license_header.tmp"
BASH_LICENSE="${LICENSE_TMP_DIR}/bash_license_header.tmp"
TMP_FILE=tmp.file
LICENSE_YEAR="2016"
LICENSE_HOLDER="HUAWEI TECHNOLOGIES CO.,LTD"
LICENSE_TOKEN="http://www.apache.org/licenses/LICENSE-2.0"

function add_license()
{
    cat $1 $2 > $TMP_FILE
    rm -f $2
    mv $TMP_FILE $2
#     echo "\nadd license testing"
}

cat << EOF >${C_LICENSE}
/******************************************************************************* 
 * Copyright (c) ${LICENSE_YEAR} ${LICENSE_HOLDER} and others. 
 *
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Apache License, Version 2.0 
 * which accompanies this distribution, and is available at 
 * http://www.apache.org/licenses/LICENSE-2.0 
 *******************************************************************************/ 
EOF

cat << EOF >${XML_LICENSE}
<!--
 Copyright (c) ${LICENSE_YEAR} ${LICENSE_HOLDER} and others.

 All rights reserved. This program and the accompanying materials
 are made available under the terms of the Apache License, Version 2.0
 which accompanies this distribution, and is available at
 http://www.apache.org/licenses/LICENSE-2.0
-->
EOF

cat << EOF >${BASH_LICENSE}
# Copyright (c) ${LICENSE_YEAR} ${LICENSE_HOLDER} and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
EOF

if [[ -z "$1" ]] || [[ ! -d "$1" ]]; then  
    echo "The directory is empty or not exist!"  
    echo "It will use the current directory."  
    nowdir=$(pwd)  
else  
    nowdir=$(cd $1; pwd)  
fi  
echo "$nowdir"  

n=0

function Searchfile()  
{  
    cd $1  
    
#    filelist=$(ls -l | awk '{print $9}')  
#    for filename in $filelist  
#    do  
#        echo  $filename
#    done  
    
    dirlist=$(ls)  
    for dirname in $dirlist
    do  
        if [[ -d "$dirname" ]];then
            n=$((n+4))
            cd $dirname
            for i in $( seq 0 $n );do echo -n ' ';done;echo "$dirname ..."  
            Searchfile $(pwd)  
            cd ..  
            n=$((n-4))
        fi;

        filename=$dirname
        if [[ -f "$filename" ]];then
            for i in $( seq 0 $n );do echo -n ' ';done;echo " |--$filename"
            grep -rn $LICENSE_SEARCH_TOKEN $filename
            if [ $? = 1 ];then
                if [ "${filename##*.}" = "c" -o "${filename##*.}" = "cpp" -o "${filename##*.}" = "java" ];then
                    add_license $C_LICENSE $filename 
                    for i in $( seq 0 $n );do echo -n ' ';done;echo " |--add license for $filename... "
                elif [ "${filename##*.}" = "yml" -o "${filename##*.}" = "yaml" -o "${filename##*.}" = "sh" ];then
                    add_license $BASH_LICENSE $filename 
                    for i in $( seq 0 $n );do echo -n ' ';done;echo " |--add license for $filename... "
                elif [ "${filename##*.}" = "xml" ];then
                    add_license $XML_LICENSE $filename 
                    for i in $( seq 0 $n );do echo -n ' ';done;echo " |--add license for $filename... "
                fi;
            fi;
        fi;
    done;  
}  
  
Searchfile $nowdir 
