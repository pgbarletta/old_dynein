#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "template" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/modos/
    ./mod.sh
    cd ../../

done < as.list
