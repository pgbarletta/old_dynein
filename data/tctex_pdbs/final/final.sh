#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "template" ]]
    then
        continue
    fi
    echo $pdb

    proto_pdb=proto_${pdb}.pdb
    pdb=${pdb}.pdb

    cp $proto_pdb $pdb

#    julia fix_elements.jl $pro_lf $lf

done < pdbs.list

