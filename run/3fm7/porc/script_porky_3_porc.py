from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("3_porc.pdb")
cmd.load("modevectors.py")
rgb="0.016198300464512316, 0.8131889243123798, 0.8042361102913318"
modevectors("3fm7", "3_porc", outname="3_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("3_porc")
