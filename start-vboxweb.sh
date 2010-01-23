#!/bin/bash

. ../../../config.sh

trap bashtrap SIGINT


cd $VBOXWEB_DIR
echo Usando parametros: $*
./VBoxWebSrv.py start $*
echo "VirtualBoxWeb finished..."

bashtrap()
{
    echo "CTRL+C Detected !...executing bash trap !"
    exit 1
}

