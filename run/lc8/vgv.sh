#!/bin/bash

while read -r pdb
do
    if [[ $pdb == "3lbzz" ]]
    then
        continue
    fi
    echo $pdb

    cd $pdb/modos/
    ./mod.sh
    cd ../../

    cd $pdb/ndd/

    #sed -i 's/NDD_frequences_scaling = true/#NDD_frequences_scaling = true/g' ecf.cfg
    #sed -i 's/NDD_frequences_scaling = true/#NDD_frequences_scaling = true/g' edf.cfg

    tail -n+8 ../modos/$pdb.freq > frq_$pdb

    var=`wc -l < frq_$pdb`
    tail -n $var ../../scl > scl

    # sdsd
    echo acb > out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c ecf.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 > out
    echo adb > out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c edf.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 > out
    cd ../../

done < pdbs.list
