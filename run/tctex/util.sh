#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "15lf" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/cav    
    cp ../../15lf/cav/*cfg .
    cd ../../

done < pdbs.list
