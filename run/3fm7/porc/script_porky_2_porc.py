from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("2_porc.pdb")
cmd.load("modevectors.py")
rgb="0.9121440027292502, 0.8294243246655955, 0.057853241637600084"
modevectors("3fm7", "2_porc", outname="2_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("2_porc")
