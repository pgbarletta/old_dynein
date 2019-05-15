#!/bin/bash
convpdb.pl -addres 207 -chain C tmp.pdb > c.pdb
convpdb.pl -addres 234 -chain D tmp.pdb > d.pdb
convpdb.pl -addres 257 -chain E tmp.pdb > e.pdb
convpdb.pl -addres 342 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_16lf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_16lb.pdb
