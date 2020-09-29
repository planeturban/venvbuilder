#!/bin/env bash

function usage () {
    echo "Usage:"
    echo "docker run -it --rm -e packages=\"<list of pip packages>\" -e venvname=<name of venv> [-e venvpath=<path to \$venevname] -v <tarfile save dir>:/out venevbuilder [tar]"
    echo "venvpath defaults to \"/opt/venvs\""
    echo "To build tarfile directly:"
    echo "docker run -it --rm -e packages=\"<list of pip packages>\" -e venvname=<name of venv> [-e venvpath=<path to \$venevname] -v <tarfile save dir>:/out venevbuilder ./mktar.sh"
    exit 1
}

export PATH=/app/:$PATH

if [ "$packages" == "" ] || [ -z $venvname ] 
    then
    usage
fi
venv=$( echo ${venvpath}/$venvname/ | sed -r 's#/+#/#g')

if [ -f $venv ]
    then
    echo "Removing old venv @ $venv"
    rm -rf $venv
fi
echo "Building $venv"
mkdir -p $venv
#python -m virtualenv --python=/usr/bin/python3 $venv
virtualenv $venv
#$venv/bin/pip install --upgrade pip
$venv/bin/pip install $packages
if [ "$0" == "./mktar.sh" ]
then
    tarfile=$(echo $venv | cut -b2- | sed 's#/#-#g' | sed -r 's#(.*)-#\1#g').tar
    if [ -f /out/$tarfile ]
    then
        echo "$tarfile found in out directory. Delete."
        rm /out/$tarfile
    fi
    echo "Taring.. $(echo $venv | cut -b2- | sed 's#/#-#g' | sed -r 's#(.*)-#\1#g').tar"
    tar cf /out/$(echo $venv | cut -b2- | sed 's#/#-#g' | sed -r 's#(.*)-#\1#g').tar $venv
else
    if [ -d /out/$venv ]
    then
        echo "/out/$venv found in out directory. Delete."
        rm -rf /out/$venv
    fi
    echo "Copying venv."
    cp -r $venv /out/
fi
