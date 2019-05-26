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

    sed 's/#NDD_/NDD_/g' ../cav/acb.cfg > acb.cfg
    sed 's/#NDD_/NDD_/g' ../cav/adb.cfg > adb.cfg

    sed -i /list_wall/d acb.cfg
    sed -i /list_wall/d adb.cfg

    tail -n+8 ../modos/$pdb.freq > frq_$pdb
    var=`wc -l < frq_$pdb`
    tail -n $var ../../scl > scl

    echo acb > out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c acb.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 >> out

    echo adb >> out
    ~/labo/ANA/build/ANA2 ../modos/$pdb.pdb -c adb.cfg -M ../modos/$pdb.mods -S scl -F frq_$pdb -Z 5 >> out

    cd ../../
    echo ------${pdb}------ >> volumenes
    cat $pdb/ndd/out >> volumenes
    echo >> volumenes
done < as.list

