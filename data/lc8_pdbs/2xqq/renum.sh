#!/bin/bash
convpdb.pl -renumber 171 c_2xqq.pdb > c.pdb
convpdb.pl -renumber 178 d_2xqq.pdb > d.pdb
convpdb.pl -renumber 1 e_2xqq.pdb > e.pdb
convpdb.pl -renumber 86 f_2xqq.pdb > f.pdb

cat e.pdb f.pdb > nrot_2xlf.pdb
cat e.pdb f.pdb c.pdb d.pdb > nrot_2xlb.pdb
