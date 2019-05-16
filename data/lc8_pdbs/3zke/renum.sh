#!/bin/bash
convpdb.pl -addres -734 -chain C tmp.pdb > c.pdb
convpdb.pl -addres -707 -chain D tmp.pdb > d.pdb
convpdb.pl -addres 257 -chain E tmp.pdb > e.pdb
convpdb.pl -addres 342 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_3zlf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_3zlb.pdb
