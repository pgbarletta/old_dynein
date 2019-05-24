#!/bin/bash
convpdb.pl -renumber 195 -chain C tmp.pdb > c.pdb
convpdb.pl -renumber 209 -chain D tmp.pdb > d.pdb
convpdb.pl -renumber 1 -chain A tmp.pdb > a.pdb
convpdb.pl -renumber 98 -chain B tmp.pdb > b.pdb

cat a.pdb b.pdb > nrot_2plf.pdb
cat a.pdb b.pdb c.pdb d.pdb > nrot_2plb.pdb
