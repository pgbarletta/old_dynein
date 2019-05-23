#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "4qlf" || $pdb == "4qlb" ]]
    then
        continue
    fi
    echo $pdb

    #cd $pdb/cav    
    cp 15lb/cav/*cfg $pdb/cav
    #cd ../../

done < pdbs.list
