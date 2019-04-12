#!/bin/bash
convpdb.pl -renumber 1 a.pdb > a.pdb
convpdb.pl -renumber 104 b.pdb > bb.pdb
convpdb.pl -renumber 208 c.pdb > cc.pdb
convpdb.pl -renumber 235 d.pdb > dd.pdb
convpdb.pl -renumber 262 e.pdb > ee.pdb
convpdb.pl -renumber 347 f.pdb > ff.pdb
cat aa.pdb bb.pdb cc.pdb dd.pdb ee.pdb ff.pdb > 3f.pdb
mv 3f.pdb 3fm7.pdb
