#!/bin/bash

pdb=3flb
file="$pdb.pdb"
CA_file="CA$pdb"
hb_file="hb_$pdb"
file_hb2="${pdb}.hb2"

/home/pbarletta/labo/19/dynein/src/nma/hbplus $file &> hbplus_output
cat $file_hb2 |  awk '8<NR {print $1}' | cut -c3-5 > tmp_hb1
cat $file_hb2 |  awk '8<NR {print $3}' | cut -c3-5 > tmp_hb2
paste tmp_hb1 tmp_hb2 > $hb_file
rm tmp_hb? $file_hb2 hbdebug.dat hbplus_output

##### calculo de modos
 
cutoff_a=15

file_bf=$pdb.bf
file_bfcorr=$pdb.bfcorr
file_bfcorr2=$pdb.bfcorr2
file_bfteo=$pdb.bfteo
file_colec=$pdb.colec
file_correl=$pdb.correl
file_freq=$pdb.freq
file_mods=$pdb.mods

/home/pbarletta/labo/19/dynein/src/nma/epanmhs $file $hb_file none $cutoff_a $file_bf $file_bfcorr $file_bfteo $file_colec $file_correl $file_freq $file_mods 

echo $file $hb_file none $cutoff_a $file_bf $file_bfcorr $file_bfteo $file_colec $file_correl $file_freq $file_mods 

exit 0
