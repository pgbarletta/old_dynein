#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "3lbzz" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/cav    
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c ecf.cfg -t ecf_${pdb} 
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c edf.cfg -t edf_${pdb} 

    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c ecf.cfg -o vol_ecf -f cav_${pdb}_ecf -w wall_${pdb}_ecf
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c edf.cfg -o vol_edf -f cav_${pdb}_edf -w wall_${pdb}_edf
    cd ../../

done < as.list
