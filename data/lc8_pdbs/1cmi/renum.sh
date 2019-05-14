#!/bin/bash
convpdb.pl -addres 206 c_1cmi.pdb > c.pdb
convpdb.pl -addres 233 d_1cmi.pdb > d.pdb
convpdb.pl -addres 257 e_1cmi.pdb > e.pdb
convpdb.pl -addres 342 f_1cmi.pdb > f.pdb

cat e.pdb f.pdb > nrot_1clf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_1clb.pdb
