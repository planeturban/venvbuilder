#!/bin/env bash

function usage () {
    echo "Usage:"
    echo "docker run -it --rm -e packages=\"<list of pip packages>\" -e venvname=<name of venv> [-e venvpath=<path to \$venevname] -v <tarfile save dir>:/out venevbuilder"
    echo "venvpath defaults to \"/opt/venvs/\""
    exit 1
}


if [ -z $packages ] || [ -z $venvname ] 
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
python3 -m virtualenv --python=/usr/bin/python3 $venv
$venv/bin/pip install $packages
if [ "$1" = "tar" ]
then
echo "Taring.. $(echo $venv | cut -b2- | sed 's#/#-#g' | sed -r 's#(.*)-#\1#g').tar"
tar cf /out/$(echo $venv | cut -b2- | sed 's#/#-#g' | sed -r 's#(.*)-#\1#g').tar $venv
else
echo "Copying venv."
cp -r $venv /out/
fi
