#!/bin/bash
convpdb.pl -addres 207 c_2xqq.pdb > c.pdb
convpdb.pl -addres 234 d_2xqq.pdb > d.pdb
convpdb.pl -addres 257 e_2xqq.pdb > e.pdb
convpdb.pl -addres 342 f_2xqq.pdb > f.pdb

cat e.pdb f.pdb > nrot_2xlf.pdb
cat c.pdb d.pdb e.pdb f.pdb > nrot_2xlb.pdb
