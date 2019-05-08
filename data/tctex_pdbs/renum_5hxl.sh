#!/bin/bash

# sed -i 's/ A / B /g' 5hxl_b.pdb 

convpdb.pl -renumber 1 5hxl_a.pdb > a.pdb
convpdb.pl -renumber 124 5hxl_b.pdb > b.pdb

cat a.pdb b.pdb > 5hxl.pdb
rm a.pdb b.pdb
