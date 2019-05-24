#!/bin/bash
convpdb.pl -renumber 195 -chain C ic.pdb > c.pdb
convpdb.pl -renumber 209 -chain D ic.pdb > d.pdb

cat nrot_5wlf.pdb c.pdb d.pdb > nrot_5wlb.pdb
