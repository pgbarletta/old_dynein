1CMI
----
    fetch 1cmi, type = pdb1, multiplex = 1 // salvo moleculas 1 y 2
    separo las 4 cadenas y corto 1 residuo extra del dominio LC8
    corro su renum.sh

1F95
----
    cp 1F95.pdb tmp.pdb
    corto residuos extra del dominio LC8
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END
1F96
----
    cp 1F96.pdb tmp.pdb 
    normalize_nmr_pdbs.ipynb // conservo el MODEL 1
    corto residuos extra del dominio LC8 y la IC.
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END

2P2T
----
    fetch 2P2T, type = pdb1, multiplex = 1 // salvo moleculas 1 y 2




