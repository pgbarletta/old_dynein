#!/bin/bash
convpdb.pl -addres 170 -chain C tmp.pdb > c.pdb
convpdb.pl -addres 179 -chain D tmp.pdb > d.pdb
convpdb.pl -addres -4 -chain E tmp.pdb > e.pdb
convpdb.pl -addres 81 -chain F tmp.pdb > f.pdb

cat e.pdb f.pdb > nrot_15lf.pdb
sed -i /END/d nrot_15lf.pdb

cat e.pdb f.pdb c.pdb d.pdb > nrot_15lb.pdb
sed -i /END/d nrot_15lb.pdb
sed -i /END/d nrot_15lb.pdb
sed -i /END/d nrot_15lb.pdb
