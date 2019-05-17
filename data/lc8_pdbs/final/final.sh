#!/bin/bash

while read -r pdb
do
    if [[ $pdb == 3f ]]
    then
        continue
    fi
    echo $pdb

    proto_lf=proto_${pdb}lf.pdb
    proto_lb=proto_${pdb}lb.pdb

    pro_lf=pro_${pdb}lf.pdb
    pro_lb=pro_${pdb}lb.pdb

    lf=${pdb}lf.pdb
    lb=${pdb}lb.pdb

    convpdb.pl -renumber 171 -chain C $proto_lb > c.pdb
    convpdb.pl -renumber 180 -chain D $proto_lb > d.pdb
    convpdb.pl -renumber 1 -chain E $proto_lb > e.pdb
    convpdb.pl -renumber 86 -chain F $proto_lb > f.pdb
    
    cat e.pdb f.pdb > $pro_lf
    sed -i /END/d $pro_lf
    
    cat e.pdb f.pdb c.pdb d.pdb > $pro_lb
    sed -i /END/d $pro_lb
    sed -i /END/d $pro_lb
    sed -i /END/d $pro_lb

    julia fix_elements.jl $pro_lf $lf
    julia fix_elements.jl $pro_lb $lb

done < pdbs.list

rm ?.pdb
