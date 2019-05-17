#!/bin/bash
convpdb.pl -addres 82 -chain C tmp.pdb > c.pdb
convpdb.pl -addres 109 -chain D tmp.pdb > d.pdb
convpdb.pl -addres 257 -chain E tmp.pdb > e.pdb
convpdb.pl -addres 342 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_3glf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_3glb.pdb
