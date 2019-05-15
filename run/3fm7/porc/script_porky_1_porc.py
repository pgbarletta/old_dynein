from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("1_porc.pdb")
cmd.load("modevectors.py")
rgb="0.2910578604310601, 0.2714512310438306, 0.4590553862124571"
modevectors("3fm7", "1_porc", outname="1_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("1_porc")
