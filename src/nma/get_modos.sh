#! /bin/bash
list=$(<pdbs.list)
#list="1XKK_A"
i=0
for file in $list
do
    echo -------- $file -------  
    
    i=`expr $i + 1`

# Nombres de input
    nonrot_pdb=nonrot_$file.pdb
    pdb=$file.pdb
    file_dis=${file}_dis
    file_hb2=${file}.hb2
    hb_file=hb_${file}
    cutoff_a=10
# Nombres de output de 'epanmhs.exe'
    file_bf=bf_${file}
    file_bfcorr=bfcorr_${file}
    file_bfteo=bfteo_${file}
    file_colec=colec_${file}
    file_correl=correl_${file}
    file_freq=freq_${file}
    file_mods=modos_${file}
################################
################################
    cd $file
# Obtengo puentes H
    ./hbplus $pdb &> hbplus_output
    cat $file_hb2 |  awk '8<NR {print $1}' | cut -c3-5 > tmp_hb1
    cat $file_hb2 |  awk '8<NR {print $3}' | cut -c3-5 > tmp_hb2
    paste tmp_hb1 tmp_hb2 > $hb_file
    rm tmp_hb?

# Calculo modos

    
    #./epanmhs.exe $pdb $hb_file none $cutoff_a $file_bf $file_bfcorr $file_bfteo $file_colec $file_correl $file_freq $file_mods 
    echo $pdb $hb_file none $cutoff_a $file_bf $file_bfcorr $file_bfteo $file_colec $file_correl $file_freq $file_mods 
    #rm $file_correl 

    cd ..
done
