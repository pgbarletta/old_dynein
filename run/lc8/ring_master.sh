#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "3lbzz" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/ring
    Ring -i ../modos/$pdb.pdb --all > ctcto_$pdb
    cd ../modos
    rm *fasta*
    cd ../../

done < was.list
