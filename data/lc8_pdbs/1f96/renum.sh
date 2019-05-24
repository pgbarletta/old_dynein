#!/bin/bash
convpdb.pl -renumber 171 -chain C tmp.pdb > c.pdb
convpdb.pl -renumber 180 -chain D tmp.pdb > d.pdb
convpdb.pl -renumber 1 -chain E tmp.pdb > e.pdb
convpdb.pl -renumber 86 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_16lf.pdb
cat e.pdb f.pdb c.pdb d.pdb > nrot_16lb.pdb
