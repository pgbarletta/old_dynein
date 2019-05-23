#!/bin/bash
convpdb.pl -renumber 167 -chain C tmp.pdb > c.pdb
convpdb.pl -renumber 176 -chain D tmp.pdb > d.pdb
convpdb.pl -renumber  1 -chain E tmp.pdb > e.pdb
convpdb.pl -renumber  84 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_4qlf.pdb
cat e.pdb f.pdb c.pdb d.pdb > nrot_4qlb.pdb
