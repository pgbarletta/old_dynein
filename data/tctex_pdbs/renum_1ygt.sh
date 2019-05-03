#!/bin/bash

# sed -i 's/ A / B /g' 1ygt_b.pdb 

convpdb.pl -renumber 1 1ygt_a.pdb > a.pdb
convpdb.pl -renumber 104 1ygt_b.pdb > b.pdb

cat a.pdb b.pdb > 1ygt.pdb
rm a.pdb b.pdb
