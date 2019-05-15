#!/bin/bash
convpdb.pl -addres 81 -chain C e_2p2t.pdb > c.pdb
convpdb.pl -addres 257 -chain E e_2p2t.pdb > e.pdb

convpdb.pl -addres 108 -chain D f_2p2t.pdb > d.pdb
convpdb.pl -addres 342 -chain F f_2p2t.pdb > f.pdb

cat e.pdb f.pdb > nrot_2plf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_2plb.pdb
