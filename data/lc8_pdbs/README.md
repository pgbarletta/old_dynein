1CMI
----
    fetch 1cmi, type = pdb1, multiplex = 1 // salvo moleculas 1 y 2
    separo las 4 cadenas y corto 1 residuo extra del dominio LC8 (5-99)  
    corro su renum.sh

1F95
----
    cp 1F95.pdb tmp.pdb
    corto residuos extra del dominio LC8 (5-99)
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
1F96
----
    cp 1F96.pdb tmp.pdb 
    normalize_nmr_pdbs.ipynb // conservo el MODEL 1
    corto residuos extra del dominio LC8 y la IC. (5-99)
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END

2P2T
----
    fetch 2P2T, type = pdb1, multiplex = 1 // salvo moleculas 1 y 2
    corto residuos extra del dominio LC8. (5-99)
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END

2XQQ
----
    cp 2XQQ.pdb ?_2xqq.pdb // separo las 4 cadenas y corto los sobrantes 
(5-89)
    conservo los residuos A y descarto los B
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END

3FM7
----
    cp 3fm7.pdb tmp.pdb
    Descarto TcTex (chains A y B) y recorto IC.
    corro su renum.sh

3GLW
----
    cp 3glw.pdb tmp.pdb
    Descarto una IC, corto residuo extra de otra IC y corto residuo 4 del LC8 (5-89)
    corro su renum.sh
    borro los END    

3ZKE
----
    cp 3ZKE.pdb tmp.pdb
    corto residuos extra de la IC
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END
   
4qh7: le falta 1 residuo al ppio y al final (6-98)
----
    cp 3ZKE.pdb tmp.pdb
    Renombro las cadenas p/ respetar el formato de 3FM7.
    corro su renum.sh
    borro los END


