from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("6_porc.pdb")
cmd.load("modevectors.py")
rgb="0.5408008406987297, 0.1302095364608673, 0.46790955500542597"
modevectors("3fm7", "6_porc", outname="6_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("6_porc")
