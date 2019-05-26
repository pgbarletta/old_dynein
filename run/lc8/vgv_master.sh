#!/bin/bash

echo > volumenes
while read -r pdb
do
    if [[ $pdb == "template" ]]
    then
        continue
    fi
    echo $pdb
    cd $pdb/ndd/

    sed 's/#NDD_/NDD_/g' ../cav/ecf.cfg > ecf.cfg
    sed 's/#NDD_/NDD_/g' ../cav/edf.cfg > edf.cfg

    tail -n+8 ../modos/$pdb.freq > frq_$pdb

    var=`wc -l < frq_$pdb`
    tail -n $var ../../scl > scl

    echo acb > out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c ecf.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 >> out

    echo adb >> out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c edf.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 >> out

    cd ../../
    echo ------${pdb}------ >> volumenes
    cat $pdb/ndd/out >> volumenes
    echo >> volumenes
done < as.list
