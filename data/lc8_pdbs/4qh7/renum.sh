#!/bin/bash
convpdb.pl -renumber 208 -chain C tmp.pdb > c.pdb
convpdb.pl -renumber 235 -chain D tmp.pdb > d.pdb
convpdb.pl -addres 257 -chain E tmp.pdb > e.pdb
convpdb.pl -addres 342 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_4qlf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_4qlb.pdb
