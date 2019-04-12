#!/bin/bash

# sed -i 's/ F / A /g' f.pdb 
# sed -i 's/ G / B /g' g.pdb 
# sed -i 's/ I / C /g' i.pdb 
# sed -i 's/ L / D /g' l.pdb 
# sed -i 's/ A / E /g' a.pdb 
# sed -i 's/ B / F /g' b.pdb 

convpdb.pl -renumber 1 f.pdb > aa.pdb
convpdb.pl -renumber 104 g.pdb > bb.pdb
convpdb.pl -renumber 208 i.pdb > cc.pdb
convpdb.pl -renumber 235 l.pdb > dd.pdb
convpdb.pl -renumber 262 a.pdb > ee.pdb
convpdb.pl -renumber 347 b.pdb > ff.pdb

cat aa.pdb bb.pdb cc.pdb dd.pdb ee.pdb ff.pdb > 2pg1.pdb
