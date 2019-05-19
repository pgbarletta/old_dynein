#!/bin/bash

convpdb.pl -renumber 171 -chain C tmp.pdb > c.pdb
convpdb.pl -renumber 180 -chain D tmp.pdb > d.pdb
convpdb.pl -renumber 1 -chain E tmp.pdb > e.pdb
convpdb.pl -renumber 86 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > pro_3flf.pdb
sed -i /END/d pro_3flf.pdb

cat e.pdb f.pdb c.pdb d.pdb > pro_3flb.pdb
sed -i /END/d pro_3flb.pdb
sed -i /END/d pro_3flb.pdb
sed -i /END/d pro_3flb.pdb


julia fix_elements.jl pro_3flf.pdb 3flf.pdb
julia fix_elements.jl pro_3flb.pdb 3flb.pdb
