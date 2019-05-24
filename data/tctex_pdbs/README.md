1XDX
----
    Usé normalize_pdbs.ipynb p/ determinar el frame más cercano al average.
    cp 1XDX.pdb tmp.pdb // y conservo el MODEL 15
    convpdb.pl -addres -16 -chain A tmp.pdb > a.pdb
    convpdb.pl -renumber 98 -chain B tmp.pdb > b.pdb
    cat a.pdb b.pdb > nrot_1xdx.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    vi nrot_1xdx.pdb // :%s/HSP/HIS/g    (arreglo las cagadas de convpdb.pl)

1YGT:
----
    fetch 1ygt, type = pdb1, multiplex 1 // en el pymol
    corto las cadenas en *a_1ygt.pdb* y *b_1ygt.pdb*    
    convpdb.pl -addres -13 a_1ygt.pdb > a.pdb
    convpdb.pl -addres 84 b_1ygt.pdb > b.pdb
    cat a.pdb b.pdb > nrot_1ygt.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados. También le cambio
el chain ID a la 2da cadena a *B*

2PG1:
----
    cp original(no se de donde) tmp.pdb
    run renum.sh  // le saco los END

5HXL: da feo pq hay missing re falopa
----
    fetch 5hxl, type = pdb1, multiplex 1 // en el pymol
    separé las cadenas A y B
    convpdb.pl -addres -12 a_5HXL.pdb > a.pdb
    convpdb.pl -addres -12 b_5HXL.pdb > b.pdb
    vi a.pdb // y hago:   %s/HSD/HIS/g
    vi b.pdb // y hago:   %s/HSD/HIS/g
    cat a.pdb b.pdb > pro_5hxl.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    en models.ipynb hago todo lo demas
    genero *canonical* bajando el fasta del PDB
    escribo el mod.py lo corro y selecciono el model 

5HYC: da feo pq hay missing re falopa
----
    separé las cadenas A, B y C
    Corto las cadenas A y B según lo q marca:
http://pfam.xfam.org/family/PF03645#tabview=tab9 y la cadena C hasta el resid
141 (residuo 20 luego de renumerar).
    convpdb.pl -addres -12 a_5hyc.pdb > a.pdb
    convpdb.pl -addres -12 b_5hyc.pdb > b.pdb
    convpdb.pl -addres -121 c_5hyc.pdb >  c.pdb
    vi a.pdb // y hago:   %s/HSD/HIS/g
    vi b.pdb // y hago:   %s/HSD/HIS/g
    cat a.pdb b.pdb c.pdb > pro_5hyc.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    en models.ipynb hago todo lo demas
    genero *canonical* bajando el fasta del PDB
    escribo el mod.py lo corro y selecciono el model

5VKY:
----
    separé las cadenas A y B
    convpdb.pl -addres -21 a_5vky.pdb > a.pdb
    convpdb.pl -addres -21 b_5vky.pdb > b.pdb
    vi a.pdb // y hago:   %s/HSD/HIS/g
    vi b.pdb // y hago:   %s/HSD/HIS/g
    cat a.pdb b.pdb > pro_5vky.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    en models.ipynb hago todo lo demas
    genero *canonical* bajando el fasta del PDB
    escribo el mod.py lo corro y selecciono el model 36

5JPW
----
    Usé normalize_pdbs.ipynb p/ determinar el frame más cercano al average.
    cp orig_5jpw.pdb tmp.pdb // y conservo el MODEL 1
    convpdb.pl -addres -17 -chain A tmp.pdb > a.pdb
    convpdb.pl -renumber 98 -chain B tmp.pdb > b.pdb
    cat a.pdb b.pdb > nrot_5jpw.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    vi nrot_5jpw.pdb // :%s/HSP/HIS/g    (arreglo las cagadas de convpdb.pl)

5WI4
----
    cp 5WI4.pdb proto_5wi4.pdb // le borré REMARKS y corté el dominio TcTex.
    convpdb.pl -addres -15 -chain A proto_5wi4.pdb > a.pdb // sólo cadena A.
    convpdb.pl -addres -15 -chain b proto_5wi4.pdb > b.pdb // sólo cadena B.
    cat a.pdb b.pdb > pro_5wi4.pdb // Le borro el *END* en el medio y no le doy bola
a los índices de los átomos, q van a quedar mal numerados
    vi pro_5wi4.pdb // y hago:   %s/HSD/HIS/g
    en models.ipynb hago todo lo demas
    escribo el mod.py lo corro y selecciono el model 7

