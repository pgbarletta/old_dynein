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

5HXL
----
        
