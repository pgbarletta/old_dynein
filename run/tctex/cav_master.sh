#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "template" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/cav
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c acb.cfg -t acb_${pdb} 
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c adb.cfg -t adb_${pdb} 

    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c acb.cfg -o vol_acb -f cav_${pdb}_acb -w wall_${pdb}_acb 
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c adb.cfg -o vol_adb -f cav_${pdb}_adb -w wall_${pdb}_adb
    cd ../../

done < pdbs.list
